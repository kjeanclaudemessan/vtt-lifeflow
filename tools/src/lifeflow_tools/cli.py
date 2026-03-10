"""CLI entry point for LifeFlow tools."""

import click

from lifeflow_tools.playstore.assets import playstore


@click.group()
@click.version_option()
def cli() -> None:
    """LifeFlow automation tools."""


cli.add_command(playstore)


if __name__ == "__main__":
    cli()
