# Jac MCP Mini-App

A Model Context Protocol (MCP) server and client implementation built entirely in the **Jac** programming language. 


## Repository Contents

* `mcp_server.jac`: The FastMCP backend server. Exposes tools via `@mcp.tool()` and `@mcp.resource()` decorators.
* `mcp_client.jac`: A simple MCP client written in Jac that connects to the server, dynamically discovers available tools, and executes them.
* `mcp_client_architecture.md`: Detailed architectural documentation explaining the inner workings of the Jac MCP client.
* `helpers.jac` & `ingest.jac`: Scripts used to parse and ingest Jac documentation into video memory.
* `*.mv2`: Memvid (memory video) knowledge artifacts ( `knowledge.mv2`) 
* `jaseci-docs-repo/`: The raw Jaseci documentation dataset source.

## Getting Started

### Prerequisites
Make sure you have the required Jaseci/Jac plugins and Google AI dependencies installed in your environment:
```bash
pip install jaclang jac-mcp jac-client memvid byllm google-genai python-dotenv
```

### 1. Environment Variables Configuration
To use the LLM integrations, you need to provide your API keys. 

1. Open the `.env` file and add your actual API key:
   ```env
   GEMINI_API_KEY="your_google_gemini_api_key_here"
   ```

### 2. Running the Application


```bash
jac run mcp_client.jac
```

## Limitations & Notes
* **Data Scale:** The current vector index (`jac_docs.mv2`) was built using only **7 documents** from the Jac documentation for rapid demonstration purposes. 
* **Search Strategy:** The application currently relies on strict **lexical search** for document retrieval. However, thanks to `memvid`, it can easily be configured to use **semantic** or **hybrid search** if stronger embedding models are integrated.

