#!/bin/bash
source ../env_vars.sh

curl -X POST "https://devops-openai-custom.openai.azure.com/openai/deployments/gpt-35-turbo/chat/completions?api-version=2024-02-15-preview" \
  -H "Content-Type: application/json" \
  -H "api-key: $OPENAI_KEY" \
  -d '{
    "messages": [
      {"role": "system", "content": "You are an IaC expert. Generate production-ready Azure Terraform code for a VM in the EIS-DEVTEST-SONARQUBE-RG resource group, connected to the N800-Subnet-01 subnet in virtual network EIS-DEVTEST-SOUTHWEST (resource group eis-devtest-int-southwest-network-rg). Use VM size Standard_D2s_v3 (2 vCPUs, 8GB RAM) and tags { CKID = \"195\", Environment = \"DEVTEST\", ProjectName = \"SQ Integration Solution\" }. Ensure compatibility with a SonarQube setup including ACI, app gateway, and MSSQL server."},
      {"role": "user", "content": "Generate the Terraform code now."}
    ]
  }'
