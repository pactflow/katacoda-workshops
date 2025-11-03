## Installation

The SmartBear MCP Server is an npm package that enables AI assistants to interact with SmartBear services. We'll install OpenCode, authenticate with GitHub to access Copilot models, and configure the SmartBear MCP Server.

### Install OpenCode CLI

First, let's install the OpenCode CLI tool:

Docs: [OpenCode CLI Documentation](https://opencode.ai/docs/#install)

👉🏼 `npm install -g opencode-ai`{{exec}}

Verify the installation:

👉🏼 `opencode --version`{{exec}}

### Authenticate OpenCode with GitHub

To use GitHub Copilot models with OpenCode, you need to authenticate with your GitHub account:

👉🏼 `opencode auth login`{{exec}}

This command will:
1. Open your browser to GitHub's authentication page
2. Prompt you to authorize OpenCode
3. Grant access to GitHub Copilot models

Follow the on-screen instructions to complete the authentication process.

Once authenticated, verify your login status:

👉🏼 `opencode auth list`{{exec}}

It should show your GitHub account as authenticated.

### Install SmartBear MCP Server

Now let's verify the SmartBear MCP Server package is available (it will be installed on-demand via npx):

👉🏼 `npx -y @smartbear/mcp`{{exec}}

It should display an error message about required configuration.

### Understanding MCP Architecture

The MCP server acts as a bridge between AI assistants (like OpenCode) and SmartBear services:

```
┌─────────────┐         ┌──────────────┐         ┌─────────────────┐
│   OpenCode  │ ◄─────► │  MCP Server  │ ◄─────► │ SmartBear APIs  │
│ (AI Client) │   MCP   │  (Bridge)    │  HTTPS  │ (PactFlow, etc) │
└─────────────┘         └──────────────┘         └─────────────────┘
```

### Create OpenCode Configuration Directory

Let's create the OpenCode configuration directory:

👉🏼 `mkdir -p ~/.config/opencode`{{exec}}

### Check Your Installation

Before moving to the next step, verify:

1. ✅ OpenCode CLI is installed and you can run `opencode --version`
2. ✅ You are authenticated with GitHub: `opencode auth list`
3. ✅ You have access to GitHub Copilot models
4. ✅ The SmartBear MCP package is accessible via `npx -y @smartbear/mcp`
5. ✅ The `~/.config/opencode` directory has been created

You can check the directory was created:

👉🏼 `ls -la ~/.config/ | grep opencode`{{exec}}
