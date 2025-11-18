#!/bin/bash

# Perplexity Research Script - Optimized for Coding Documentation
# Usage: ./perplexity-research.sh "search query" [--domains domain1,domain2]

set -euo pipefail

# Default configuration for documentation research
MAX_RESULTS=15
RECENCY="year"  # Focus on recent documentation
COUNTRY=""
DOMAINS=""
QUERY=""
OUTPUT_FORMAT="structured"  # structured, json, or plain

# Documentation-focused domains (can be overridden)
DEFAULT_DOC_DOMAINS="stackoverflow.com,github.com,docs.python.org,developer.mozilla.org,nodejs.org,reactjs.org,vuejs.org,angular.io,rust-lang.org,go.dev,kotlinlang.org,dev.to,medium.com"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# System prompt for AI-optimized documentation extraction
SYSTEM_CONTEXT="You are researching coding documentation. Focus on:
- Official documentation and API references
- Code examples and best practices
- Recent updates and version-specific information
- Common patterns and anti-patterns
- Integration guides and setup instructions"

# Help message
show_help() {
    cat << EOF
Perplexity Research Script - Optimized for Coding Documentation

Usage: $(basename "$0") [OPTIONS] "query"

OPTIONS:
    -n, --max-results NUM    Maximum number of results (1-20, default: 15)
    -r, --recency FILTER     Filter by recency: day, week, month, year (default: year)
    -d, --domains LIST       Comma-separated list of domains (default: doc-focused sites)
    -f, --format FORMAT      Output format: structured, json, plain (default: structured)
    -h, --help              Show this help message

EXAMPLES:
    $(basename "$0") "python asyncio best practices"
    $(basename "$0") -d "docs.python.org,realpython.com" "python async await tutorial"
    $(basename "$0") -r month "react hooks documentation"
    $(basename "$0") -f json "typescript generics guide"

ENVIRONMENT:
    PERPLEXITY_API_KEY      Your Perplexity API key (required)

OUTPUT FORMATS:
    structured - AI-optimized markdown with clear sections (default)
    json       - Raw JSON response for programmatic use
    plain      - Simple text format

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
        -d|--domains)
            DOMAINS="$2"
            shift 2
            ;;
        -f|--format)
            OUTPUT_FORMAT="$2"
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

# Use default documentation domains if not specified
if [ -z "$DOMAINS" ]; then
    DOMAINS="$DEFAULT_DOC_DOMAINS"
fi

# Build JSON payload
JSON_PAYLOAD=$(cat <<EOF
{
  "query": "$QUERY",
  "max_results": $MAX_RESULTS,
  "search_recency_filter": "$RECENCY"
EOF
)

# Add domain filtering
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

# Close JSON
JSON_PAYLOAD+="
}"

# Make API request
echo -e "${BLUE}Researching documentation for: ${YELLOW}${QUERY}${NC}" >&2
echo -e "${CYAN}Context: ${SYSTEM_CONTEXT}${NC}" >&2
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

# Output based on format
case "$OUTPUT_FORMAT" in
    json)
        echo "$BODY" | jq '.'
        ;;
    plain)
        echo "$BODY" | jq -r '.results[] | "\(.title)\n\(.url)\n\(.snippet)\n"'
        ;;
    structured|*)
        # AI-optimized structured format
        echo "# Documentation Research: $QUERY"
        echo ""
        echo "**Search Date:** $(date '+%Y-%m-%d')"
        echo "**Results Found:** $(echo "$BODY" | jq '.results | length')"
        echo "**Recency Filter:** $RECENCY"
        echo ""
        echo "---"
        echo ""

        echo "$BODY" | jq -r '
.results[] |
"## \(.title)

**URL:** \(.url)
**Published:** \(.date)
**Last Updated:** \(.last_updated)

### Summary

\(.snippet)

---
"'

        # Summary footer
        RESULT_COUNT=$(echo "$BODY" | jq '.results | length')
        echo "" >&2
        echo -e "${GREEN}✓ Successfully researched $RESULT_COUNT documentation sources${NC}" >&2
        ;;
esac
