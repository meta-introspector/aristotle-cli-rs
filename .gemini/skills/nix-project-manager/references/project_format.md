# projects.yaml Format

The `projects.yaml` file defines a list of projects to manage.

```yaml
projects:
  - name: my-project
    # The URL of the git repository.
    repo: "https://github.com/user/my-project.git"
    # The local path to clone the repository to.
    path: "./projects/my-project"
    # A list of actions to perform on the project.
    actions:
      - type: nix-build
        # The flake reference to build.
        flake: ".#my-package"
      - type: system-manager-deploy
        # The target machine for deployment.
        target: "my-machine"
      - type: nginx-proxy
        # The domain for the nginx proxy.
        domain: "my-project.example.com"
        # The port to proxy to.
        port: 8080
```

## Action Details

### `nix-build`

Builds a Nix flake.

-   `flake`: The flake reference to build (e.g., `.#defaultPackage.x86_64-linux`).

### `system-manager-deploy`

Deploys a configuration using `system-manager`.

-   `target`: The target machine to deploy to.

### `nginx-proxy`

Configures an nginx proxy.

-   `domain`: The domain name for the proxy.
-   `port`: The port to proxy traffic to.
