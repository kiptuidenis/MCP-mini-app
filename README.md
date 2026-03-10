# Jac MCP Mini-App 🔌

A Model Context Protocol (MCP) server and client implementation built entirely in the **Jac** programming language. 


## 📂 Repository Contents

* `mcp_server.jac`: The FastMCP backend server. Exposes tools via `@mcp.tool()` and `@mcp.resource()` decorators.
* `mcp_client.jac`: A simple MCP client written in Jac that connects to the server, dynamically discovers available tools, and executes them.
* `mcp_client_architecture.md`: Detailed architectural documentation explaining the inner workings of the Jac MCP client.
* `helpers.jac` & `ingest.jac`: Scripts used to parse and ingest Jac documentation into video memory.
* `weather.jac`: An example/utility file ().
* `*.mv2`: Memvid (memory video) knowledge artifacts ( `knowledge.mv2`) 
* `jaseci-docs-repo/`: The raw Jaseci documentation dataset source.

## 🚀 Getting Started

### Prerequisites
Make sure you have the required Jaseci/Jac plugins installed in your environment, including the memory storage:
```bash
pip install jaclang jac-mcp memvid-sdk
```

### Running the Application


```bash
jac run mcp_client.jac
```

## ⚠️ Limitations & Notes
* **Data Scale:** The current vector index (`jac_docs.mv2`) was built using only **7 documents** from the Jac documentation for rapid demonstration purposes. 
* **Search Strategy:** The application currently relies on strict **lexical search** for document retrieval. However, thanks to `memvid`, it can easily be configured to use **semantic** or **hybrid search** if stronger embedding models are integrated.

## 📖 Learn More
* [Jaseci Labs GitHub](https://github.com/Jaseci-Labs)
* [Jac Language Documentation](https://github.com/Jaseci-Labs/jaseci/tree/main/docs)

---
*Built natively in Jac*
