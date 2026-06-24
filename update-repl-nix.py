#!/usr/bin/env python3
"""Add shmem dependency to lean4-repl in all-services.nix."""
p = '/home/mdupont/projects/system-manager/all-services.nix'
t = open(p).read()

old = '''      after = [ "network.target" ];
      wantedBy = [ "system-manager.target" ];
      serviceConfig = {
        Type = "simple";
        User = "dasl";
        Group = "dasl";
        WorkingDirectory = "/tmp";
        ExecStart = "${LEAN4_REPL} --port 8156";
        Restart = "always";
        RestartSec = "5";
        StandardOutput = "journal";
        StandardError = "journal";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = "read-only";
        ProtectSystem = "strict";
      };
      environment = {
        STATIC_SPLIT_BIN = "${STATICSPLIT_JSON}";
        ARISTOTLE_API_KEY = "";
        RUST_LOG = "info";
        PATH = lib.mkForce "/nix/store/aqpyjzpqhs988lpqs8rnq8rw3i7ihrmi-lean/bin:/home/mdupont/.nix-profile/bin:/run/current-system/sw/bin";
      };'''

new = '''      after = [ "network.target" "ipld-car-shmem.service" ];
      wants = [ "ipld-car-shmem.service" ];
      wantedBy = [ "system-manager.target" ];
      serviceConfig = {
        Type = "simple";
        User = "dasl";
        Group = "dasl";
        WorkingDirectory = "/tmp";
        ExecStart = "${LEAN4_REPL} --port 8156";
        Restart = "always";
        RestartSec = "5";
        StandardOutput = "journal";
        StandardError = "journal";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = "read-only";
        ProtectSystem = "strict";
      };
      environment = {
        STATIC_SPLIT_BIN = "${STATICSPLIT_JSON}";
        ARISTOTLE_API_KEY = "";
        RUST_LOG = "info";
        SHMEM_NAMESPACE = "lean4";
        PATH = lib.mkForce "/nix/store/aqpyjzpqhs988lpqs8rnq8rw3i7ihrmi-lean/bin:/home/mdupont/.nix-profile/bin:/run/current-system/sw/bin";
      };'''

assert old in t, "old text not found"
t = t.replace(old, new)
open(p, 'w').write(t)
print('updated: added shmem dep + SHMEM_NAMESPACE=lean4')
