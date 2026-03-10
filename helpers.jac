""" Jac Docs

Provides search and Q&A functions for the Jac documentation
knowledge base using memvid.
"""

import from memvid_sdk { use }
import os;


def search_jac_docs(query: str, num_results: int = 5) -> str {
    """Search the Jac documentation and return matching snippets.""";

    kb_path = 'jac_docs.mv2';

    if not os.path.exists(kb_path) {
        return "Error: jac_docs.mv2 not found. Run ingest.jac first.";
    }

    mem = use('basic', kb_path);
    results = mem.find(query, k=num_results, mode='lex');

    hits = results.get('hits', []);
    if len(hits) == 0 {
        return "No results found for your query.";
    }

    hit_count = str(len(hits));
    output = "Found " + hit_count + " results for: '" + query + "'\n\n";
    i = 0;
    for hit in hits {
        i += 1;
        text = hit.get('text', 'N/A');
        output += "--- Result " + str(i) + " ---\n";
        output += text + "\n\n";
    }

    return output;
}


def ask_jac_docs(question: str) -> str {
    """Ask a question about Jac and get a direct answer from the docs.""";

    kb_path = 'jac_docs.mv2';

    if os.path.exists(kb_path) == False {
        return "Error: jac_docs.mv2 not found. Run ingest.jac first.";
    }

    mem = use('basic', kb_path);
    answer = mem.ask(question, k=5, mode='lex');

    return answer.get('answer', 'Could not find an answer.');
}


# Self-test when run directly
with entry:__main__ {
    print("=== Testing Jac Docs Tools ===\n");

    print("--- Search Test ---");
    result = search_jac_docs("How do I install Jac?");
    print(result);

    print("--- Ask Test ---");
    answer = ask_jac_docs("What is a walker in Jac?");
    print("Answer: " + answer);
}
