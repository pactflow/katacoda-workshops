## Configuration

Now that OpenCode is installed and authenticated, we need to set up environment variables for SmartBear services and configure OpenCode to use the SmartBear MCP server.

### Step 1: Obtain API Credentials

You'll need API tokens for the SmartBear services you want to use:

#### For PactFlow

1. Log into your PactFlow account at <https://pactflow.io>
2. Navigate to **Settings > API Tokens**
3. Copy your Read-Only API token and broker base URL

### Step 2: Configure Environment Variables in Your Shell

Set up your SmartBear credentials as environment variables. Paste these into the terminal (replace with your actual values):

👉🏼 Set your PactFlow broker URL:

```bash
export PACT_BROKER_BASE_URL="https://your-account.pactflow.io"
```{{copy}}

👉🏼 Set your PactFlow API token:

```bash
export PACT_BROKER_TOKEN="your-pactflow-token-here"
```{{copy}}

**Note:** Replace the placeholder values with your actual credentials from PactFlow.

To make these permanent across terminal sessions, add them to your shell profile:

👉🏼 Add to your shell profile:

```bash
echo 'export PACT_BROKER_BASE_URL="https://your-account.pactflow.io"' >> ~/.bashrc
echo 'export PACT_BROKER_TOKEN="your-token-here"' >> ~/.bashrc
source ~/.bashrc
```{{copy}}

Verify your environment variables are set:

👉🏼 `env | grep PACT_BROKER`{{exec}}

You should see both `PACT_BROKER_BASE_URL` and `PACT_BROKER_TOKEN` displayed.

If you have any other SmartBear services to configure (like SwaggerHub), repeat the above steps to obtain API tokens and set environment variables accordingly.

- `API_HUB_API_KEY`
- `REFLECT_API_TOKEN`

### Step 3: Configure OpenCode with SmartBear MCP Server

Now we'll configure OpenCode to use the SmartBear MCP server. Create the OpenCode configuration file:

👉🏼 Create the opencode.jsonc configuration file:

```bash
cat > ~/.config/opencode/opencode.jsonc << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "smartbear-mcp": {
      "type": "local",
      "command": ["npx", "-y", "@smartbear/mcp"],
      "enabled": true
    }
  }
}
EOF
```{{exec}}

This configuration:
- Enables the SmartBear MCP server
- Uses `npx` to run the MCP server on-demand (no global installation needed)
- The `-y` flag auto-accepts the npx prompt
- The MCP server will automatically use the environment variables we set earlier

Verify the configuration file was created:

👉🏼 `cat ~/.config/opencode/opencode.jsonc`{{exec}}

### Step 4: Query Available SmartBear Tools with OpenCode

Now let's use OpenCode to discover what SmartBear tools are available through the MCP server.

👉🏼 Query available tools using OpenCode:

```bash
opencode run "What SmartBear MCP tools are available? Please list all available tools with their descriptions." --model 'github-copilot/claude-sonnet-4'
```{{exec}}

OpenCode will:
1. Connect to the SmartBear MCP server
2. Query the available tools
3. Return a formatted list of all SmartBear tools you can use

Expected tools include:
- **Contract Testing (PactFlow)**: AI-powered test generation, can-i-deploy checks, verification matrix, provider states
- **Reflect**: Test automation suite and test execution management
- **API Hub**: Portal management, API registry, standardization scanning
- And more depending on your SmartBear subscriptions

### Check

Before moving to the next step, verify:

1. ✅ Your PactFlow environment variables are set: `env | grep PACT_BROKER`
2. ✅ The OpenCode configuration file exists: `~/.config/opencode/opencode.jsonc`
3. ✅ OpenCode can connect to the SmartBear MCP server
4. ✅ You can see the list of available SmartBear tools

Check your environment variables are set:

👉🏼 `env | grep PACT_BROKER`{{exec}}

Check the OpenCode configuration:

👉🏼 `cat ~/.config/opencode/opencode.jsonc`{{exec}}
