---
name: "dasl-tile-cli"
description: "Interact with the DASL tile system using the `tile-mothership` CLI. Use this skill to discover, inspect, and render DASL tiles."
---

# DASL Tile CLI Interaction

This skill provides a workflow for interacting with the DASL tile system using the `tile-mothership` command-line interface (CLI).

## Overview

The `tile-mothership` CLI is the primary tool for managing and interacting with DASL tiles. It allows you to discover, inspect, and render tiles from various sources.

## Workflow

1.  **Discover Tiles**: Use the `list` command to get a list of all active tiles. This is the first step to finding the tile you are interested in.

    ```bash
    cargo run --release --bin tile-mothership -- list
    ```

2.  **Inspect a Tile**: Once you have the ID or URL of a tile, use the `load` command to get its details.

    ```bash
    cargo run --release --bin tile-mothership -- load <tile-url>
    ```

3.  **Render a Tile**: To get a user-friendly representation of a tile, you can render its card or content to HTML.

    -   **Render Card**:
        ```bash
        cargo run --release --bin tile-mothership -- render-card <tile-url>
        ```
    -   **Render Content**:
        ```bash
        cargo run --release --bin tile-mothership -- render-content <tile-url>
        ```

## Example

Let's say you want to find and inspect the "plan" tile.

1.  **List all tiles**:
    ```bash
    cargo run --release --bin tile-mothership -- list
    ```
    (The output of this command will show you the URL for the "plan" tile)

2.  **Load the "plan" tile**:
    ```bash
    cargo run --release --bin tile-mothership -- load fuzz://planning/plan-tile
    ```

3.  **Render the "plan" tile's card**:
    ```bash
    cargo run --release --bin tile-mothership -- render-card fuzz://planning/plan-tile
    ```

## Notes

-   The `tile-mothership` binary is located in the `dasl-tiles-rust` project.
-   The commands should be run from the root of the `dasl-tiles-rust` project.
-   The `--release` flag is recommended for better performance.
