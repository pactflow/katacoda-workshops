# SmartBear MCP Server with OpenCode - Workshop

This workshop guides users through setting up and using the SmartBear MCP (Model Context Protocol) Server with OpenCode for AI-augmented development workflows.

## Overview

The SmartBear MCP Server enables AI assistants like OpenCode to interact with SmartBear services including PactFlow and SwaggerHub. This workshop demonstrates how to:

- Install and configure the SmartBear MCP Server
- Set up authentication with SmartBear services
- Connect OpenCode to the MCP server
- Use AI-powered tools for contract-driven development
- Generate code from contracts and API specifications
- Automate deployment safety checks

## Workshop Structure

### Introduction (`intro.md`)
- Prerequisites and setup requirements
- Overview of MCP, SmartBear MCP Server, and OpenCode
- Workshop goals and scenarios

### Step 1: Installation (`step1.md`)
- Installing the SmartBear MCP Server npm package
- Understanding MCP architecture
- Creating configuration directories
- Verification script included (`step1-verify.sh`)

### Step 2: Configuration (`step2.md`)
- Obtaining API credentials for PactFlow and SwaggerHub
- Setting up environment variables
- Creating MCP configuration file
- Configuring OpenCode to use the MCP server
- Testing the connection
- Verification script included (`step2-verify.sh`)

### Step 3: Using the MCP Server (`step3.md`)
- Understanding available MCP tools
- Using tools via OpenCode with natural language
- Manual tool testing from command line
- Integration into development workflows
- Best practices and troubleshooting

### Step 4: Practical Examples (`step4.md`)
- Contract-driven API client development
- SwaggerHub to implementation
- Contract test generation
- Deployment safety checks
- API documentation generation
- Contract diff analysis

### Finish (`finish.md`)
- Summary of learning outcomes
- Best practices recap
- Further resources and next steps
- Community links and feedback channels

## Key Features

✅ **Hands-on Examples**: Practical examples demonstrating real-world use cases
✅ **Interactive Commands**: Copy-paste commands for easy execution
✅ **Verification Steps**: Built-in verification scripts to ensure proper setup
✅ **Multiple Languages**: Examples in TypeScript, JavaScript, and extensible to other languages
✅ **CI/CD Integration**: Examples of incorporating MCP into automated pipelines
✅ **Best Practices**: Security, testing, and workflow recommendations throughout

## Prerequisites

### Online Environment

- All prerequisites are pre-installed in the online environment

### Local Environment

- Node.js 18+ (20 is recommended)
- Git
- VS Code or compatible editor
- Basic understanding of API testing concepts

## Time Required

Approximately 15 minutes to complete all steps

## Target Audience

- Developers working with microservices and APIs
- Teams using contract testing
- Users of PactFlow or SwaggerHub
- Anyone interested in AI-augmented development workflows

## Related Workshops

- `pactflow-ai`: PactFlow AI test generation capabilities
- `pactflow-ai-test-templates`: Advanced test templates with PactFlow AI
- `pactflow-bi-directional-contracts-intro`: Bi-directional contract testing

## Usage

This workshop is designed for Katacoda-style interactive learning platforms. The `index.json` file defines the workshop structure, and each step includes:

- Detailed instructions in markdown format
- Executable commands (marked with `{{exec}}` or `{{copy}}`)
- Verification scripts where applicable
- Check sections to ensure understanding

## Support

For questions or issues:

- [SmartBear MCP Server GitHub](https://github.com/SmartBear/smartbear-mcp-server)
- [PactFlow Slack](https://slack.pact.io/)
- [PactFlow Documentation](https://docs.pactflow.io/)

## License

This workshop follows the same license as the parent repository.
