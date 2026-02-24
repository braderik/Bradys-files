"""FastMCP server for the Bradys-files repository.

This server exposes lightweight tools for browsing and searching the local
repository contents so an MCP client can answer questions about the docs.
"""

from __future__ import annotations

from pathlib import Path
from typing import List

from fastmcp import FastMCP

REPO_ROOT = Path(__file__).resolve().parent

mcp = FastMCP(
    name="bradys-files-mcp",
    instructions=(
        "Use the provided tools to inspect repository documentation and scripts. "
        "Prefer returning concise, actionable summaries with exact file paths."
    ),
)


def _safe_resolve(relative_path: str) -> Path:
    """Resolve user-provided paths and prevent traversal outside the repo root."""
    candidate = (REPO_ROOT / relative_path).resolve()
    if not str(candidate).startswith(str(REPO_ROOT)):
        raise ValueError("Path is outside repository root")
    return candidate


@mcp.tool
def list_documents(subdir: str = "docs") -> List[str]:
    """List markdown files in a repository subdirectory.

    Args:
        subdir: Directory to search (defaults to "docs").
    """
    base = _safe_resolve(subdir)
    if not base.exists() or not base.is_dir():
        raise ValueError(f"Directory not found: {subdir}")

    return [
        str(path.relative_to(REPO_ROOT))
        for path in sorted(base.rglob("*.md"))
        if path.is_file()
    ]


@mcp.tool
def read_file(path: str, max_chars: int = 12000) -> str:
    """Read a text file from this repository.

    Args:
        path: Relative path from repository root.
        max_chars: Max characters to return.
    """
    file_path = _safe_resolve(path)
    if not file_path.exists() or not file_path.is_file():
        raise ValueError(f"File not found: {path}")

    content = file_path.read_text(encoding="utf-8", errors="replace")
    if len(content) > max_chars:
        return content[:max_chars] + "\n\n...[truncated]"
    return content


@mcp.tool
def search_repository(query: str, include_hidden: bool = False) -> List[str]:
    """Search repository files for a case-insensitive text query.

    Returns a list of `path:line_number:line_content` matches.
    """
    if not query.strip():
        raise ValueError("Query must not be empty")

    matches: List[str] = []
    for file_path in REPO_ROOT.rglob("*"):
        if not file_path.is_file():
            continue

        rel_path = file_path.relative_to(REPO_ROOT)

        if not include_hidden and any(part.startswith(".") for part in rel_path.parts):
            continue

        if rel_path.parts and rel_path.parts[0] in {".git", "node_modules", "dist", "__pycache__"}:
            continue

        try:
            text = file_path.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue

        for i, line in enumerate(text.splitlines(), start=1):
            if query.lower() in line.lower():
                matches.append(f"{rel_path}:{i}:{line.strip()}")

    return matches


if __name__ == "__main__":
    mcp.run()
