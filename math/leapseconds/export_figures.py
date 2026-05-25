#!/usr/bin/env python3

import base64
from pathlib import Path

import nbformat
from nbclient import NotebookClient

notebook_path = Path("leapseconds.ipynb")

with notebook_path.open() as f:
    nb = nbformat.read(f, as_version=4)

client = NotebookClient(nb, timeout=600, kernel_name="python3")
client.execute()

for cell_index, cell in enumerate(nb.cells):
    if cell.cell_type != "code":
        continue

    metadata = cell.get("metadata", {})

    figname = metadata.get("figname")
    if figname is None:
        continue

    figure_count = 0

    for output_index, output in enumerate(cell.get("outputs", [])):
        data = output.get("data", {})

        if "image/svg+xml" in data:
            figure_count += 1
            suffix = f"-{figure_count}" if figure_count > 1 else ""
            Path(f"{figname}{suffix}.svg").write_text(data["image/svg+xml"], encoding="utf-8")

        elif "image/png" in data:
            figure_count += 1
            suffix = f"-{figure_count}" if figure_count > 1 else ""
            Path(f"{figname}{suffix}.png").write_bytes(base64.b64decode(data["image/png"]))
