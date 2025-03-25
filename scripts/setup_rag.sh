#!/bin/bash

source ../env_vars.sh

# Create index with vector search configuration
INDEX_JSON='{
  "name": "jira-iac-index",
  "fields": [
    {"name": "id", "type": "Edm.String", "key": true},
    {"name": "content", "type": "Edm.String", "searchable": true},
    {
      "name": "vector",
      "type": "Collection(Edm.Single)",
      "searchable": true,
      "retrievable": true,
      "dimensions": 3,
      "vectorSearchProfile": "vector-profile"
    }
  ],
  "vectorSearch": {
    "profiles": [
      {
        "name": "vector-profile",
        "algorithm": "vector-config"
      }
    ],
    "algorithms": [
      {
        "name": "vector-config",
        "kind": "hnsw",
        "hnswParameters": {
          "m": 4,
          "efConstruction": 400,
          "efSearch": 500,
          "metric": "cosine"
        }
      }
    ]
  }
}'
curl -X PUT "$SEARCH_ENDPOINT/indexes/jira-iac-index?api-version=2023-11-01" \
  -H "Content-Type: application/json" \
  -H "api-key: $SEARCH_KEY" \
  -d "$INDEX_JSON"

# Build DOCS_JSON dynamically from files in subdirectories
DOCS_JSON='{"value": ['  # Start JSON object with value array
id=1  # Incremental ID for documents

# Process files in data/infra.tf/
for file in ../data/infra.tf/*; do
  if [ -f "$file" ]; then  # Check if it's a regular file
    CONTENT=$(cat "$file" | sed 's/"/\\"/g')  # Escape double quotes
    DOCS_JSON="$DOCS_JSON{\"id\": \"$id\", \"content\": \"$CONTENT\", \"vector\": [0.$id, 0.$((id+1)), 0.$((id+2))]},"
    id=$((id+1))
  fi
done

# Process files in data/jira_tickets.txt/
for file in ../data/jira_tickets.txt/*; do
  if [ -f "$file" ]; then  # Check if it's a regular file
    CONTENT=$(cat "$file" | sed 's/"/\\"/g')  # Escape double quotes
    DOCS_JSON="$DOCS_JSON{\"id\": \"$id\", \"content\": \"$CONTENT\", \"vector\": [0.$id, 0.$((id+1)), 0.$((id+2))]},"
    id=$((id+1))
  fi
done

DOCS_JSON="${DOCS_JSON%,}]}"  # Remove trailing comma and close array and object

# Upload documents
curl -X POST "$SEARCH_ENDPOINT/indexes/jira-iac-index/docs/index?api-version=2023-11-01" \
  -H "Content-Type: application/json" \
  -H "api-key: $SEARCH_KEY" \
  -d "$DOCS_JSON"

echo "RAG setup complete."
