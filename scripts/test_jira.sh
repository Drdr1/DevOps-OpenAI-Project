#!/bin/bash

source ../env_vars.sh

curl -X POST "$APIM_GATEWAY_URL/openai/deployments/gpt-35-turbo/chat/completions?api-version=2023-05-15" \
  -H "Content-Type: application/json" \
  -H "Ocp-Apim-Subscription-Key: $APIM_SUB_KEY" \
  -d '{
    "messages": [
      {"role": "system", "content": "You are a Scrum Master assistant. Analyze closed Jira tickets and recommend backlog tickets based on team habits and velocity."},
      {"role": "user", "content": "Recommend tickets from the backlog."}
    ]
  }'
