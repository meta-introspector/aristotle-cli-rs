use std::process::Command;

fn main() {
    // Capture git commit hash at build time for --version output.
    // nix build sets GIT_HASH via flake.nix (self.shortRev).
    // cargo build (no nix) falls back to git rev-parse HEAD.
    if std::env::var("GIT_HASH").is_err() {
        let hash = Command::new("git")
            .args(["rev-parse", "--short", "HEAD"])
            .output()
            .ok()
            .and_then(|o| {
                if o.status.success() {
                    String::from_utf8(o.stdout).ok()
                } else {
                    None
                }
            })
            .map(|s| s.trim().to_string())
            .unwrap_or_else(|| "unknown".to_string());

        println!("cargo:rustc-env=GIT_HASH={}", hash);
    }

    // nix sets GIT_HASH via the derivation env — we use it as-is.
    // Rebuild when git HEAD changes (for cargo build users).
    println!("cargo:rerun-if-changed=.git/HEAD");
}
