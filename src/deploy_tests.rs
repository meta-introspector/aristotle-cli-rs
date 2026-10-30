//! ACR-PR9 regression tests for `prepare_workspace_in`.
//!
//! These tests exercise the interim mitigation for pre-existing workspace
//! and build-root symlinks. They do NOT exercise or claim to close the
//! TOCTOU race between the symlink checks and `create_dir_all`; that
//! remains OPEN and requires descriptor-anchored follow-up.
//!
//! Unix-only: uses `std::os::unix::fs::symlink`.
#![cfg(unix)]

use super::prepare_workspace_in;
use std::path::Path;
use tempfile::TempDir;

fn make_project(parent: &Path) -> std::path::PathBuf {
    let project = parent.join("project");
    std::fs::create_dir(&project).expect("create project");
    std::fs::write(project.join("Main.lean"), b"-- test").expect("write source");
    project
}

#[test]
fn rejects_existing_workspace_symlink() {
    let tmp = TempDir::new().expect("tempdir");
    let root = tmp.path().join("root");
    std::fs::create_dir(&root).expect("create root");
    let sensitive = tmp.path().join("sensitive");
    std::fs::create_dir(&sensitive).expect("create sensitive");

    // Pre-create the workspace path as a symlink to the sensitive directory.
    std::os::unix::fs::symlink(&sensitive, root.join("evil-id"))
        .expect("plant workspace symlink");

    let project = make_project(tmp.path());

    let err = prepare_workspace_in(&root, &project, "evil-id")
        .expect_err("must reject symlinked workspace");
    assert!(
        format!("{err}").contains("symlink"),
        "unexpected error: {err}"
    );
}

#[test]
fn rejects_existing_build_root_symlink() {
    let tmp = TempDir::new().expect("tempdir");
    let real_root = tmp.path().join("real-root");
    std::fs::create_dir(&real_root).expect("create real root");
    let link_root = tmp.path().join("link-root");
    std::os::unix::fs::symlink(&real_root, &link_root).expect("plant root symlink");

    let project = make_project(tmp.path());

    let err = prepare_workspace_in(&link_root, &project, "any-id")
        .expect_err("must reject symlinked build root");
    assert!(
        format!("{err}").contains("symlink"),
        "unexpected error: {err}"
    );
}

#[test]
fn allows_legitimate_workspace_creation() {
    let tmp = TempDir::new().expect("tempdir");
    let root = tmp.path().join("root");
    std::fs::create_dir(&root).expect("create root");

    let project = make_project(tmp.path());

    let ws = prepare_workspace_in(&root, &project, "ok-id")
        .expect("legitimate creation should succeed");
    assert!(ws.is_dir(), "workspace not created: {}", ws.display());
    assert!(ws.starts_with(&root), "workspace escaped build root");
    assert!(
        ws.join("Main.lean").is_file(),
        "source file not linked into workspace"
    );
}
