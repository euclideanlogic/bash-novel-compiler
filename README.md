# bash-novel-compiler
A bash script the takes an organized collection of Markdown files and formats and exports them to a .pdf appropriate for manuscript submission or book publishing.

## Useage

`bnc.sh` should be placed in the parent directory that holds all of your Markdown files. The Markdown files should be arranged in folders -- one folder per chapter. Each chapter should have at least one Markdown file within it, as each chapter should have at least one scene.

Here is an example parent directory structure:
```
book/
├─ 1 Chapter the First/
│  ├─ 1 Scene the First.md
│  ├─ 2 Scene the Second.md
├─ 2 Chapter the Second/
│  ├─ 1 Scene the First.md
│  ├─ 2 Scene the Second.md
│  ├─ 3 Scene the Third.md
├─ 3 Chapter the Third/
│  ├─ 1 Scene the First.md
├─ bnc.sh
```

`bnc.sh` will create a folder called `exports`, which will store all exports as a combination of the book's title and the date/time it was exported at.

## Requirements

- `typst` installed ([View on GitHub](https://github.com/typst/typst))
- `bash` (shouldn't be a problem on most UNIX-based systems. Sorry, Windows.)

## Future Goals

- `.docx` export
- multiple formatting options (manuscript, paperback, etc.)
- `--help` options, more verbose interactions.
- Support for non-numbered chapters (Prologue, Epilogue, etc.)
