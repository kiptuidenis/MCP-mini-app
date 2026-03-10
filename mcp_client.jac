import asyncio;
import sys;
import from typing { Optional }
import from contextlib { AsyncExitStack }

import from mcp { ClientSession, StdioServerParameters }
import from mcp.client.stdio { stdio_client }

import from google { genai }
import from google.genai { types }
import from dotenv { load_dotenv }

with entry {
    load_dotenv();
}

obj MCPClient {
    has session: Optional[ClientSession] = None;
    has exit_stack: AsyncExitStack = AsyncExitStack();
    has ai_client: genai.Client = genai.Client();

    # Method to connect to the MCP Server
    # Method to connect to the MCP Server
    async def connect_to_server(server_script_path: str) {
        """Connect to an MCP Server

        Args:
            server_script_path: Path to the server script
        """;
        is_jac = server_script_path.endswith(".jac");
        if not is_jac {
            raise ValueError("Server script must be a .jac file") ;
        }
        command = "jac" if is_jac else "None";
        server_params = StdioServerParameters(
            command=command,
            args=[server_script_path],
            env=None
        );

        stdio_transport = await self.exit_stack.enter_async_context(
            stdio_client(server_params)
        );
        (self.stdio, self.write) = stdio_transport;
        self.session = await self.exit_stack.enter_async_context(
            ClientSession(self.stdio, self.write)
        );

        await self.session.initialize();

        # List available tools
        # List available tools
        response = await self.session.list_tools();
        tools = response.tools;
        print("\nConnected to server with tools:", [tool.name for tool in tools]);
    }

    # Processing Queries functionality
    # Processing Queries functionality
    async def process_query(query: str) -> str {
        """Process a query using Claude and available tools""";
        messages = [{"role": "user", "parts": [{"text": query}]}];

        response = await self.session.list_tools();

        # Build google-genai tool schemas
        # Build google-genai tool schemas
        available_tools = [
            types.Tool(
                function_declarations=[
                    types.FunctionDeclaration(
                        name=tool.name,
                        description=tool.description,
                        parameters=tool.inputSchema
                    )
                ]
            ) for tool in response.tools
        ];

        # Initialize Gemini API call
        # Initialize Gemini API call
        response = self.ai_client.models.generate_content(
            model="gemini-2.5-flash",
            contents=messages,
            config=types.GenerateContentConfig(tools=available_tools, temperature=0.7)
        );

        final_text = [];

        if response.text {
            final_text.append(response.text);
        }

        if response.function_calls {
            for fc in response.function_calls {
                tool_name = fc.name;
                tool_args = fc.args;

                # Execute tool call
                # Execute tool call
                result = await self.session.call_tool(tool_name, tool_args);
                final_text.append(f"[Calling tool {tool_name} with args {tool_args}]");

                # Add model's action intention to history
                # Add model's action intention to history
                messages.append(
                    {
                        "role": "model",
                        "parts": [
                            {"function_call": {"name": tool_name, "args": tool_args}}
                        ]
                    }
                );

                # Add user's function response to history
                # Add user's function response to history
                messages.append(
                    {
                        "role": "user",
                        "parts": [
                            {
                                "function_response": {
                                    "name": tool_name,
                                    "response": {"result": result.content}
                                }
                            }
                        ]
                    }
                );

                # Get final response from Gemini
                # Get final response from Gemini
                response = self.ai_client.models.generate_content(
                    model="gemini-2.5-flash",
                    contents=messages,
                    config=types.GenerateContentConfig(
                        tools=available_tools, temperature=0.7
                    )
                );

                if response.text {
                    final_text.append(response.text);
                }
            }
        }
        return "\n".join(final_text);
    }

    # interactive chat interface
    # interactive chat interface
    async def chat_loop() {
        """Run an interactive chat loop""";
        print("\nMCP Client Started");
        print("Type your queries or quit to exit");

        while True {
            try {
                query = input("\nQuery: ").strip();

                if query.lower() == 'quit' {
                    break;
                }
                response = await self.process_query(query);
                print("\n" + response);
            } except Exception as e {
                print(f"\nError: {str(e)}");
            }
        }
    }

    async def cleanup() {
        """Clean up resources""";
        await self.exit_stack.aclose();
    }
}

# main entry point
# main entry point
async def main() {
    if len(sys.argv) < 2 {
        print("Usage: jac client.jac <path_to_server_script>");
        sys.exit(1);
    }
    client = MCPClient();
    try {
        await client.connect_to_server(sys.argv[1]);
        await client.chat_loop();
    } finally {
        await client.cleanup();
    }
}

with entry {
    import sys;
    asyncio.run(main());
}
