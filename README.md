# Jac-GPT MCP Server & Client 🔌

A fully Jac-native **Model Context Protocol (MCP)** server and client application that powers a conversational AI assistant for Jaseci and Jac documentation. 

This project explores how developers can expose custom Jac logic as callable tools to Language Models via the standardized MCP interface.

## 🌟 Features
* **Zero Python Code:** The entire stack (Server, Client, and UI) is 100% written in the Jac programming language.
* **FastMCP Server:** Uses `@mcp.tool()` and `@mcp.resource()` decorators to expose Jac documentation parsing, retrieval, and Q&A endpoints.
* **Streamlit Client UI:** A modern web interface built natively in Jac using the `jac-streamlit` plugin to render the conversation and interact with the AI.
* **Retrieval-Augmented Generation (RAG):** Integrates `byllm` and `memvid` (memory video) behind the scenes in the tools layer for contextual Jac documentation injection.

## 📂 Project Structure
```text
MCP-mini-app/
├── mcp_server.jac   # The backend FastMCP server exposing tools via standard I/O
├── mcp_client.jac   # Connects the LLM to the MCP server tools dynamically
├── app.jac          # The Frontend UI (Streamlit wrapped in Jac)
├── tools.jac        # Core RAG, search, and knowledge extraction tools
├── jac_docs.mv      # Extracted memvid documentation vectors
├── jaseci-docs-repo/# The raw Jaseci documentation dataset source
└── ...
```

## 🚀 Getting Started

### Prerequisites
Make sure you have the required Jaseci/Jac plugins installed in your environment:
```bash
pip install jaclang jac-mcp jac-streamlit byllm
```

### 1. Run the Frontend Client
The application is launched via the `jac-streamlit` wrapper. In your terminal, run:
```bash
jac streamlit app.jac
```

### 2. How it works
1. **The Server (`mcp_server.jac`)** spawns independently and actively listens on transport layers (like `stdio`).
2. **The Client (`mcp_client.jac`)** is instantiated by the Streamlit App. It connects to the Server, automatically discovers the available `@mcp.tool()` Jac functions, and dynamically provisions them to the LLM agent.
3. **The User** asks a question in the UI (e.g., "How do I create a walker?"). The AI queries the MCP server tools under the hood and streams the response back to the client.

## 📖 Learn More
* [Jaseci Labs GitHub](https://github.com/Jaseci-Labs)
* [Jac Language Documentation](https://github.com/Jaseci-Labs/jaseci/tree/main/docs)

---
*Built with ❤️ in Jac*
