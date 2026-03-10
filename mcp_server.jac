"""Jac Documentation MCP Server.

Exposes memvid-backed search and Q&A tools for the Jac language
via the Model Context Protocol.
Run: jac run mcp_server.jac
"""

import from mcp.server.fastmcp { FastMCP }
import from helpers { search_jac_docs, ask_jac_docs }
import sys;
import os;

# Initialize FastMCP server
with entry {
    mcp = FastMCP("jac-gpt");
}

@mcp.resource("docs://quick-guide/{filename}")
def get_doc(filename: str) -> str {
    """Get a quick guide document by filename.""";
    # Resolve the file path to the Jaseci docs repo relative to the server location
    filepath = f"jaseci-docs-repo/docs/docs/quick-guide/{filename}";
    
    if os.path.exists(filepath) {
        with open(filepath, "r") as f {
            return f.read();
        }
    }
    return f"Document {filename} not found.";
}

@mcp.tool()
def search_docs(query: str, num_results: int = 5) -> str {
    """Search the Jac programming language documentation.

    Args:
    query: Search query about Jac (e.g. 'how to install', 'walker syntax')
    num_results: Number of results to return (default 5)
    """;
    return search_jac_docs(query, num_results);
}

@mcp.tool()
def ask_docs(question: str) -> str {
    """Ask a question about the Jac programming language and get a direct answer.

    Args:
    question: A question about Jac (e.g. 'What is a walker?', 'How do I define a node?')
    """
    return ask_jac_docs(question);
}

def main() {
    print("Starting Jac-GPT MCP Server...", file=sys.stderr);
    mcp.run(transport="stdio");
}

with entry {
    main();
}
