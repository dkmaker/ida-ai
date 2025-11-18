#!/bin/bash

# Perplexity Search API Frontend
# Usage: ./perplexity.sh [OPTIONS] "query"

set -euo pipefail

# Default values
MAX_RESULTS=10
RECENCY=""
COUNTRY=""
DOMAINS=""
AFTER_DATE=""
BEFORE_DATE=""
QUERY=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Help message
show_help() {
    cat << EOF
Perplexity Search API Frontend

Usage: $(basename "$0") [OPTIONS] "query"

OPTIONS:
    -n, --max-results NUM    Maximum number of results (1-20, default: 10)
    -r, --recency FILTER     Filter by recency: day, week, month, year
    -c, --country CODE       Country code (e.g., US, GB, DE)
    -d, --domains LIST       Comma-separated list of domains to filter
    -a, --after DATE         Only content after this date (MM/DD/YYYY)
    -b, --before DATE        Only content before this date (MM/DD/YYYY)
    -h, --help              Show this help message

EXAMPLES:
    $(basename "$0") "latest AI developments"
    $(basename "$0") -r week -n 5 "machine learning breakthroughs"
    $(basename "$0") -d "science.org,nature.com" -r month "quantum computing"
    $(basename "$0") -c US -a "01/01/2025" "tech news"

ENVIRONMENT:
    PERPLEXITY_API_KEY      Your Perplexity API key (required)

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -n|--max-results)
            MAX_RESULTS="$2"
            shift 2
            ;;
        -r|--recency)
            RECENCY="$2"
            shift 2
            ;;
        -c|--country)
            COUNTRY="$2"
            shift 2
            ;;
        -d|--domains)
            DOMAINS="$2"
            shift 2
            ;;
        -a|--after)
            AFTER_DATE="$2"
            shift 2
            ;;
        -b|--before)
            BEFORE_DATE="$2"
            shift 2
            ;;
        *)
            QUERY="$1"
            shift
            ;;
    esac
done

# Check for API key
if [ -z "${PERPLEXITY_API_KEY:-}" ]; then
    echo -e "${RED}Error: PERPLEXITY_API_KEY environment variable is not set${NC}" >&2
    echo "Please set your API key: export PERPLEXITY_API_KEY='your-api-key'" >&2
    exit 1
fi

# Check for query
if [ -z "$QUERY" ]; then
    echo -e "${RED}Error: No query provided${NC}" >&2
    echo "Use -h or --help for usage information" >&2
    exit 1
fi

# Build JSON payload
JSON_PAYLOAD=$(cat <<EOF
{
  "query": "$QUERY",
  "max_results": $MAX_RESULTS
EOF
)

# Add optional fields
if [ -n "$RECENCY" ]; then
    JSON_PAYLOAD+=",
  \"search_recency_filter\": \"$RECENCY\""
fi

if [ -n "$COUNTRY" ]; then
    JSON_PAYLOAD+=",
  \"country\": \"$COUNTRY\""
fi

if [ -n "$DOMAINS" ]; then
    # Convert comma-separated domains to JSON array
    DOMAIN_ARRAY=$(echo "$DOMAINS" | awk -F',' '{
        printf "["
        for(i=1; i<=NF; i++) {
            gsub(/^[ \t]+|[ \t]+$/, "", $i)
            printf "\"%s\"", $i
            if(i<NF) printf ","
        }
        printf "]"
    }')
    JSON_PAYLOAD+=",
  \"search_domain_filter\": $DOMAIN_ARRAY"
fi

if [ -n "$AFTER_DATE" ]; then
    JSON_PAYLOAD+=",
  \"search_after_date\": \"$AFTER_DATE\""
fi

if [ -n "$BEFORE_DATE" ]; then
    JSON_PAYLOAD+=",
  \"search_before_date\": \"$BEFORE_DATE\""
fi

# Close JSON
JSON_PAYLOAD+="
}"

# Make API request
echo -e "${BLUE}Searching Perplexity for: ${YELLOW}${QUERY}${NC}" >&2
echo "" >&2

RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "https://api.perplexity.ai/search" \
    -H "Authorization: Bearer $PERPLEXITY_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$JSON_PAYLOAD")

# Extract HTTP status code and body
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

# Check for errors
if [ "$HTTP_CODE" != "200" ]; then
    echo -e "${RED}Error: API request failed with status code $HTTP_CODE${NC}" >&2
    echo "$BODY" | jq -r '.' 2>/dev/null || echo "$BODY" >&2
    exit 1
fi

# Parse and format results for AI optimization
echo "$BODY" | jq -r '
.results[] |
"---
Title: \(.title)
URL: \(.url)
Date: \(.date)
Last Updated: \(.last_updated)

\(.snippet)
"'

# Summary at the end
RESULT_COUNT=$(echo "$BODY" | jq '.results | length')
echo -e "\n${GREEN}✓ Found $RESULT_COUNT results${NC}" >&2
