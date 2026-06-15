---
name: nix-project-manager
description: Manages Nix-based projects, including building, deployment with system-manager, and configuring nginx proxies. Use for automating DevOps workflows for Nix projects.
---

# Nix Project Manager

This skill helps automate the management of Nix-based projects. It uses a YAML configuration file to define projects and the actions to be performed on them.

## Core Workflow

1.  **Define Projects**: Create a `projects.yaml` file in the root of your repository. This file defines the git repositories to manage and the sequence of actions to perform on them. See the format description in [references/project_format.md](references/project_format.md).

2.  **Execute Plan**: Run the plan to clone/update repositories and execute the defined actions.

## Actions

The following actions are supported:

-   `nix-build`: Builds a Nix flake.
-   `system-manager-deploy`: Deploys a configuration using `system-manager`. (Note: `system-manager` is assumed to be in the `PATH`).
-   `nginx-proxy`: Configures an nginx proxy.

See the scripts in the `scripts/` directory for implementation details. You can extend the skill by adding more action scripts.

## Example Usage

To execute the plan defined in `projects.yaml`:

1.  Read and parse `projects.yaml`.
2.  For each project:
    -   Clone the repository if it doesn't exist.
    -   Pull the latest changes if it does.
    -   Execute the actions in order.
