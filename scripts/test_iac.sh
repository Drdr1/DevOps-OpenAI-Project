#!/bin/bash
source ../env_vars.sh

curl -X POST "$APIM_GATEWAY_URL/openai/deployments/gpt-35-turbo/chat/completions?api-version=2023-12-01-preview" \
  -H "Content-Type: application/json" \
  -H "Ocp-Apim-Subscription-Key: $APIM_SUB_KEY" \
  -d '{
    "messages": [
      {"role": "system", "content": "You are an IaC expert."},
      {"role": "user", "content": "Generate Terraform code for a new VM."}
    ]
  }'
