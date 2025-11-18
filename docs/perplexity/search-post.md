# Search

> Get ranked search results from Perplexity's continuously refreshed index with advanced filtering and customization options.

## OpenAPI

````yaml post /search
paths:
  path: /search
  method: post
  servers:
    - url: https://api.perplexity.ai
  request:
    security:
      - title: HTTPBearer
        parameters:
          query: {}
          header:
            Authorization:
              type: http
              scheme: bearer
          cookie: {}
    parameters:
      path: {}
      query: {}
      header: {}
      cookie: {}
    body:
      application/json:
        schemaArray:
          - type: object
            properties:
              query:
                allOf:
                  - title: Query
                    oneOf:
                      - type: string
                        description: >-
                          A search query. Can be a single query or a list of
                          queries for multi-query search.
                      - type: array
                        items:
                          type: string
                        maxItems: 5
                        description: >-
                          An array of search queries for multi-query search.
                          Maximum of 5 queries per request.
                    description: The search query or queries to execute.
                    example: latest AI developments 2024
              max_results:
                allOf:
                  - title: Max Results
                    type: integer
                    description: The maximum number of search results to return.
                    default: 10
                    minimum: 1
                    maximum: 20
              search_domain_filter:
                allOf:
                  - title: Search Domain Filter
                    type: array
                    items:
                      type: string
                    description: >-
                      A list of domains/URLs to limit search results to. Maximum
                      20 domains.
                    maxItems: 20
                    example:
                      - science.org
                      - pnas.org
                      - cell.com
              max_tokens_per_page:
                allOf:
                  - title: Max Tokens Per Page
                    type: integer
                    description: >-
                      Controls the maximum number of tokens retrieved from each
                      webpage during search processing. Higher values provide
                      more comprehensive content extraction but may increase
                      processing time.
                    default: 1024
                    example: 1024
              country:
                allOf:
                  - title: Country
                    type: string
                    description: >-
                      Country code to filter search results by geographic
                      location (e.g., 'US', 'GB', 'DE').
                    example: US
              search_recency_filter:
                allOf:
                  - title: Search Recency Filter
                    type: string
                    enum:
                      - day
                      - week
                      - month
                      - year
                    description: >-
                      Filters search results based on recency. Specify 'day' for
                      results from the past 24 hours, 'week' for the past 7
                      days, 'month' for the past 30 days, or 'year' for the past
                      365 days.
                    example: week
              search_after_date:
                allOf:
                  - title: Search After Date
                    type: string
                    description: >-
                      Filters search results to only include content published
                      after this date. Format should be %m/%d/%Y (e.g.,
                      '10/15/2025').
                    example: 10/15/2025
              search_before_date:
                allOf:
                  - title: Search Before Date
                    type: string
                    description: >-
                      Filters search results to only include content published
                      before this date. Format should be %m/%d/%Y (e.g.,
                      '10/16/2025').
                    example: 10/16/2025
            required: true
            title: SearchRequest
            refIdentifier: '#/components/schemas/SearchRequest'
            requiredProperties:
              - query
        examples:
          example:
            value:
              query: latest AI developments 2024
              max_results: 10
              search_domain_filter:
                - science.org
                - pnas.org
                - cell.com
              max_tokens_per_page: 1024
              country: US
              search_recency_filter: week
              search_after_date: 10/15/2025
              search_before_date: 10/16/2025
  response:
    '200':
      application/json:
        schemaArray:
          - type: object
            properties:
              results:
                allOf:
                  - title: Results
                    type: array
                    items:
                      $ref: '#/components/schemas/SearchResult'
                    description: An array of search results.
            title: SearchResponse
            refIdentifier: '#/components/schemas/SearchResponse'
            requiredProperties:
              - results
        examples:
          example:
            value:
              results:
                - title: <string>
                  url: <string>
                  snippet: <string>
                  date: '2025-03-20'
                  last_updated: '2025-09-19'
        description: Successfully retrieved search results.
  deprecated: false
  type: path
components:
  schemas:
    SearchResult:
      title: SearchResult
      type: object
      properties:
        title:
          title: Title
          type: string
          description: The title of the search result.
        url:
          title: URL
          type: string
          format: uri
          description: The URL of the search result.
        snippet:
          title: Snippet
          type: string
          description: A brief excerpt or summary of the content.
        date:
          title: Date
          type: string
          format: date
          description: The date that the page was crawled and added to Perplexity's index.
          example: '2025-03-20'
        last_updated:
          title: Last Updated
          type: string
          format: date
          description: The date that the page was last updated in Perplexity's index.
          example: '2025-09-19'
      required:
        - title
        - url
        - snippet
        - date
        - last_updated

````