#!/bin/bash

source ../env_vars.sh

# Import OpenAPI spec into APIM
az apim api import \
  --resource-group devops-openai-rg \
  --service-name devops-apim \
  --api-id openai-api \
  --path /openai \
  --specification-format OpenAPI \
  --specification-path ../apim/openai-spec.json

# Escape special characters in OPENAI_KEY for XML and JSON
ESCAPED_OPENAI_KEY=$(printf '%s' "$OPENAI_KEY" | sed 's/[&<>"'\'']/\\&/g')

# Set API policy using REST API
POLICY_XML="<policies><inbound><base /><set-header name=\"api-key\" exists-action=\"override\"><value>$ESCAPED_OPENAI_KEY</value></set-header></inbound></policies>"
az rest \
  --method PUT \
  --uri "https://management.azure.com/subscriptions/955faad9-ebe9-4a85-9974-acae429ae877/resourceGroups/devops-openai-rg/providers/Microsoft.ApiManagement/service/devops-apim/apis/openai-api/policies/policy?api-version=2022-08-01" \
  --body "{\"properties\": {\"format\": \"xml\", \"value\": \"$(echo "$POLICY_XML" | sed 's/"/\\"/g')\"}}" \
  --headers "Content-Type=application/json"

echo "APIM configured."
