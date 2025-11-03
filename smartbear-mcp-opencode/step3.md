## Using the MCP Server with OpenCode

Now that everything is configured, let's explore how to use the SmartBear MCP Server with OpenCode to enhance your development workflow.

### View Available SmartBear Tools

Documentation Reference: [SmartBear MCP Portal](https://developer.smartbear.com/smartbear-mcp)

First, let's see what tools are available through the SmartBear MCP server:

👉🏼 Ask OpenCode to list all available tools:

```bash
opencode run "What tools are available from the SmartBear MCP server? Please provide a complete list with descriptions."  --model 'github-copilot/claude-sonnet-4'
```{{exec}}

OpenCode will query the MCP server and return a formatted list of all available tools.

### Understanding the SmartBear Tools

The SmartBear MCP Server provides tools from multiple SmartBear products:

#### Reflect (Test Automation)

**Suite Management:**
- `smartbearmcp_reflect_list_suites` - Retrieve a list of all available reflect suites
- `smartbearmcp_reflect_list_suite_executions` - List all executions for a given suite (requires suiteId)
- `smartbearmcp_reflect_execute_suite` - Execute a reflect suite (requires suiteId)
- `smartbearmcp_reflect_get_suite_execution_status` - Get the status of a suite execution (requires suiteId, executionId)
- `smartbearmcp_reflect_cancel_suite_execution` - Cancel a suite execution (requires suiteId, executionId)

**Individual Test Management:**
- `smartbearmcp_reflect_list_tests` - List all reflect tests
- `smartbearmcp_reflect_run_test` - Run a specific reflect test (requires testId)
- `smartbearmcp_reflect_get_test_status` - Get the status of a test execution (requires testId, executionId)

#### API Hub (Portal & API Management)

**Portal Management:**
- `smartbearmcp_api_hub_list_portals` - Search for available portals where you have designer role
- `smartbearmcp_api_hub_create_portal` - Create a new portal (requires subdomain, swaggerHubOrganizationId)
- `smartbearmcp_api_hub_get_portal` - Retrieve information about a specific portal (requires portalId)
- `smartbearmcp_api_hub_delete_portal` - Delete a specific portal (requires portalId)
- `smartbearmcp_api_hub_update_portal` - Update portal configuration (requires portalId)

**Product Management:**
- `smartbearmcp_api_hub_list_portal_products` - Get products for a specific portal (requires portalId)
- `smartbearmcp_api_hub_create_portal_product` - Create a new product for a portal (requires portalId, type, name, slug)
- `smartbearmcp_api_hub_get_portal_product` - Retrieve information about a specific product (requires productId)
- `smartbearmcp_api_hub_delete_portal_product` - Delete a product from a portal (requires productId)
- `smartbearmcp_api_hub_update_portal_product` - Update product settings (requires productId)

**API Registry & Management:**
- `smartbearmcp_api_hub_search_apis_and_domains` - Search for APIs and Domains in SwaggerHub Registry
- `smartbearmcp_api_hub_get_api_definition` - Fetch resolved API definition from SwaggerHub (requires owner, api, version)
- `smartbearmcp_api_hub_create_or_update_api` - Create/update API in SwaggerHub Registry (requires owner, apiName, definition)
- `smartbearmcp_api_hub_create_api_from_template` - Create API using predefined template (requires owner, apiName, template)
- `smartbearmcp_api_hub_scan_api_standardization` - Run standardization scan against API definition (requires orgName, definition)

#### Contract Testing (PactFlow)

**AI-Powered Test Generation & Review:**
- `smartbearmcp_contract_testing_generate_pact_tests` - Generate Pact tests using PactFlow AI from request/response pairs, code files, or OpenAPI documents
- `smartbearmcp_contract_testing_review_pact_tests` - Review Pact tests using PactFlow AI (requires pactTests object)

**Contract Verification & Deployment:**
- `smartbearmcp_contract_testing_get_provider_states` - Retrieve states of a specific provider (requires provider name)
- `smartbearmcp_contract_testing_can_i_deploy` - Check if a service version can be safely deployed (requires pacticipant, version, environment)
- `smartbearmcp_contract_testing_matrix` - Retrieve contract verification matrix showing consumer-provider relationships (requires q array)

**Account Management:**
- `smartbearmcp_contract_testing_check_pactflow_ai_entitlements` - Check PactFlow AI entitlements and credit balance

## Key Features:

1. **Test Automation**: Execute and manage Reflect test suites and individual tests
2. **API Portal Management**: Create and manage developer portals with products
3. **API Registry**: Search, create, and manage APIs in SwaggerHub
4. **AI-Powered Contract Testing**: Generate and review Pact tests automatically
5. **Deployment Safety**: Check contract compatibility before deployments
6. **Standardization**: Scan APIs for compliance with organizational standards

All tools integrate with SmartBear's cloud platform and require appropriate authentication and permissions.

### Practical Examples with OpenCode

Let's use OpenCode to interact with SmartBear services through the MCP server. All examples use `opencode run` with the GitHub Copilot Claude Sonnet 4 model.

#### Example 1: Check Deployment Safety (Contract Testing)

👉🏼 Use the `can_i_deploy` functionality to check if a version can be safely deployed:

```bash
opencode run "Using the SmartBear MCP server, can I deploy the version '5556b8149bf8bac76bc30f50a8a2dd4c22c85f30' of 'Example App' to the 'test' environment?" --model 'github-copilot/claude-sonnet-4'
```{{exec}}

OpenCode will:
1. Connect to the SmartBear MCP server
2. Call the `smartbearmcp_contract_testing_can_i_deploy` tool
3. Check all contract verifications
4. Return a deployment safety recommendation

#### Example 2: Download an API from API Hub

👉🏼 Query the contract verification matrix to see consumer-provider relationships:

```bash
opencode run "Using the SmartBear MCP server, grab a copy of a petstore api and save it to api-spec.yaml" --model 'github-copilot/claude-sonnet-4'
```{{exec}}

This will use the `smartbearmcp_api_hub_get_api_definition` tool to retrieve:
- The OpenAPI definition of the specified API

#### Example 3: Generate Pact Tests with AI

👉🏼 Use PactFlow AI to generate contract tests from your code or OpenAPI spec:

```bash
opencode run "Using the SmartBear MCP server, generate Pact tests for my API. I have an OpenAPI specification at ./api-spec.yaml. Create consumer tests in TypeScript with proper matchers." --model 'github-copilot/claude-sonnet-4'
```{{exec}}

OpenCode will:
1. Use the `smartbearmcp_contract_testing_generate_pact_tests` tool
2. Analyze your OpenAPI specification
3. Generate Pact tests with appropriate matchers
4. Include provider states where needed

#### Example 4: List and Execute Reflect Test Suites

👉🏼 Query and run automated tests in Reflect:

```bash
opencode run "Using the SmartBear MCP server, list all my Reflect test suites and show me the status of recent executions." --model 'github-copilot/claude-sonnet-4'
```{{exec}}

This uses the `smartbearmcp_reflect_list_suites` and `smartbearmcp_reflect_list_suite_executions` tools.

To execute a specific suite:

```bash
opencode run "Using the SmartBear MCP server, execute the Reflect test suite with ID 'smartbear-coin-api-regression-tests' and monitor its status." --model 'github-copilot/claude-sonnet-4'
```{{exec}}

#### Example 5: Search and Manage APIs in API Hub

👉🏼 Search for APIs in SwaggerHub Registry:

```bash
opencode run "Using the SmartBear MCP server, search for all APIs in SwaggerHub that contain 'petstore' in their name or description. Show me the owner, version, and status." --model 'github-copilot/claude-sonnet-4'
```{{exec}}

This uses the `smartbearmcp_api_hub_search_apis_and_domains` tool.

To get a specific API definition:

```bash
opencode run "Using the SmartBear MCP server, retrieve the API definition for 'my-org/user-api/1.0.0' from SwaggerHub." --model 'github-copilot/claude-sonnet-4'
```{{exec}}

#### Example 6: Check PactFlow AI Entitlements

👉🏼 Check your PactFlow AI credit balance:

```bash
opencode run "Using the SmartBear MCP server, check my PactFlow AI entitlements and show me my remaining credit balance." --model 'github-copilot/claude-sonnet-4'
```{{exec}}

This uses the `smartbearmcp_contract_testing_check_pactflow_ai_entitlements` tool.

### Using OpenCode Interactively

You can also start an interactive chat session with OpenCode:

👉🏼 Start interactive mode:

```bash
opencode
```{{exec}}

Then you can have a conversation with OpenCode about your SmartBear resources:

```
You: Generate tests for this contract
OpenCode: [Creates test code based on the contract]
```

### Best Practices for Using OpenCode with MCP

1. **Be Specific**: Include specific application names, versions, or environments in your queries
2. **Iterate**: Ask follow-up questions to refine results
3. **Verify**: Always review generated code before using in production
4. **Use Context**: Reference previous responses in your conversation
5. **Combine Tools**: Ask OpenCode to use multiple MCP tools together

### Troubleshooting

If OpenCode can't connect to the MCP server:

1. **Verify configuration file exists:**

   👉🏼 `cat ~/.config/opencode/opencode.jsonc`{{exec}}

2. **Check environment variables are set:**

   👉🏼 `env | grep PACT_BROKER`{{exec}}

3. **Verify OpenCode authentication:**

   👉🏼 `opencode auth list`{{exec}}

5. **Restart OpenCode** if you made configuration changes while it was running

### Common Issues

- **"No tools found"**: Check that your environment variables are set correctly
- **Authentication errors**: Verify your PactFlow token is valid and hasn't expired
- **MCP server not responding**: Ensure `npx` can download and run the MCP package
- **OpenCode not authenticated**: Run `opencode auth login` again

### What You've Learned

1. ✅ You can ask OpenCode to list available SmartBear tools
2. ✅ You can query PactFlow data through OpenCode
3. ✅ You understand how to use natural language queries with OpenCode
4. ✅ You can troubleshoot common connection issues
5. ✅ You've successfully retrieved data from your SmartBear products.

### Next Steps

- Explore the [SmartBear MCP Server documentation](https://github.com/SmartBear/smartbear-mcp-server)
- Try creating your own custom workflows
- Integrate MCP into your CI/CD pipeline
- Share your use cases with the community
