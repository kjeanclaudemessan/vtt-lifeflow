# LifeFlow Tools

Automation tools for the LifeFlow project.

## Setup

```bash
uv sync
```

## Usage

```bash
# Generate Play Store assets (icon, feature graphic, framed screenshots)
uv run lifeflow playstore generate

# Show available commands
uv run lifeflow --help
```

## Project Structure

```
tools/
├── pyproject.toml
├── src/
│   └── lifeflow_tools/
│       ├── __init__.py
│       ├── cli.py                  # CLI entry point (click)
│       ├── playstore/
│       │   ├── __init__.py
│       │   └── assets.py           # Play Store asset generation
│       └── utils/
│           ├── __init__.py
│           └── image.py            # Image utilities
└── output/                         # Generated assets (gitignored)
```

## Adding new commands

Add a new module under `src/lifeflow_tools/`, then register it in `cli.py`.
