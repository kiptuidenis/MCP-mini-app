"""Jac Documentation Ingestion Script.

Reads Jac documentation markdown files from the local clone
and stores them in a memvid .mv2 file for semantic search.
"""

import from memvid_sdk { create, use }
import os;
import glob;


with entry {
    docs_dir = 'jaseci-docs-repo/docs/docs/quick-guide';
    output_path = 'jac_docs.mv2';
    # Safety check: don't overwrite existing knowledge base
     if os.path.exists(output_path) {
        print(f"Warning: {output_path} already exists. Removing to rebuild...");
        os.remove(output_path);
    }
    # Create new memvid memory file
    mem =
        create(output_path);
    # Find all markdown files in the docs directory
    md_files =
        glob.glob(os.path.join(docs_dir, '*.md'));
    print(f"Found {len(md_files)} documentation files to ingest");
    if len(md_files) == 0 {
        print("ERROR: No .md files found. Did you clone the docs?");
        print(f"Expected docs at: {docs_dir}");
        print(
            "Run: git clone --depth 1 --filter=blob:none --sparse https://github.com/jaseci-labs/jaseci.git jaseci-docs-repo"
        );
        print(
            "Then: cd jaseci-docs-repo && git sparse-checkout set docs/docs/quick-guide"
        );
    } else {
        # Ingest each documentation file
         for file_path in md_files {
            with open(file_path, 'r', encoding='utf-8') as f  {
                content = f.read();
            }
            filename = os.path.basename(file_path);
            # Create a clean title from the filename
            title =
                filename.replace('.md', '').replace('-', ' ').title();
            print(f"  Ingesting: {filename} ({len(content)} chars) -> '{title}'");
            mem.put(
                title=title,
                label='jac-docs',
                metadata=
                {'source' : file_path , 'section' : 'quick-guide' , 'filename' : filename },
                text=content
            );
        }
        # Seal to commit all changes
        mem.seal();
        print(f"\nDone! Jac documentation stored in '{output_path}'");
        print(f"Total files ingested: {len(md_files)}");
    }
}
