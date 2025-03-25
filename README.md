# DevOps OpenAI Project with RAG
Integrates Azure OpenAI with Retrieval-Augmented Generation (RAG) using Azure AI Search to generate Terraform code and Jira backlog recommendations based on indexed infrastructure and ticket data.

---
## **Features** :

- Generates production-ready Azure Terraform code for VMs using indexed configurations.
- Recommends Jira backlog tickets based on closed tickets and team velocity.
- Built with Azure OpenAI, Azure AI Search, and Azure API Management (APIM).

---
## **Prerequisites** :

- Azure CLI
- Terraform
- Python 3.x (optional, for scripting)
- jq (sudo apt install jq)
  
---
## **Setup** :

1. Deploy Infrastructure:
   
```bash
cd terraform/
terraform init
terraform apply
```
Creates:
- Resource Group: devops-openai-rg
- Azure OpenAI: devops-openai
- Azure AI Search: devops-search
- APIM: devops-apim

Export environment variables:

```bash
OPENAI_KEY=$(az cognitiveservices account keys list --name devops-openai --resource-group devops-openai-rg --query key1 -o tsv)
SEARCH_KEY=$(az search admin-key show --resource-group devops-openai-rg --service-name devops-search --query primaryKey -o tsv)
APIM_SUB_KEY=$(az apim show --resource-group devops-openai-rg --name devops-apim --query id -o tsv | xargs -I {} az rest --method post --uri "{}/subscriptions/master/listSecrets?api-version=2022-08-01" --query primaryKey -o tsv)
cat <<EOF > ../env_vars.sh
OPENAI_KEY=$OPENAI_KEY
SEARCH_KEY=$SEARCH_KEY
APIM_SUB_KEY=$APIM_SUB_KEY
APIM_GATEWAY_URL=$(terraform output -raw apim_gateway_url)
SEARCH_ENDPOINT=$(terraform output -raw search_endpoint)
EOF
chmod +x ../env_vars.sh
```

2. Configure RAG:
   
Place data in:
- data/infra.tf/ 
- data/jira_tickets.txt/

Run:

```bash
cd scripts/
./setup_rag.sh
```
Verify:

```bash
source ../env_vars.sh
curl -X POST "$SEARCH_ENDPOINT/indexes/jira-iac-index/docs/search?api-version=2023-11-01" -H "Content-Type: application/json" -H "api-key: $SEARCH_KEY" -d '{"search": "*"}'
```

3. Set Up "On Your Data"

In Azure OpenAI Studio:
- Select devops-openai.
- Go to Playground > Add Your Data.
- Choose Azure AI Search:
- Service: devops-search
- Index: jira-iac-index
- Key: $SEARCH_KEY
- Save and test.
- Use deployment gpt-35-turbo

---

## **Usage**:

- Generate Terraform Code :
  
```bash
cd scripts/
./test_iac.sh > ../iac_response.json
cat ../iac_response.json
```
- Recommend Jira Tickets :
  
```bash
./test_jira.sh > ../jira_response.json
cat ../jira_response.json
```



