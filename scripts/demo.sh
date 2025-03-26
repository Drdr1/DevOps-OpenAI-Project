#!/bin/bash
source ../env_vars.sh
echo "=== Generating Terraform Code for SonarQube VM ==="
./test_iac.sh > ../iac_response.json
cat ../iac_response.json | jq -r '.choices[0].message.content'
echo -e "\n=== Recommending Jira Backlog Tickets ==="
./test_jira.sh > ../jira_response.json
cat ../jira_response.json | jq -r '.choices[0].message.content'
