//! Proof-acceptance policy for the local Lean checker.
//!
//! A clean `lean` exit code is not proof evidence: Lean exits 0 for files that
//! use `sorry`/`admit` (even with `set_option warningAsError false`), declare
//! or use custom axioms, use `native_decide`, contain no theorem at all, or are
//! empty, and a metaprogram can add an unchecked declaration with
//! `debug.skipKernelTC`.  This module decides acceptance from facts that Lean
//! itself reports about the compiled declarations instead.
//!
//! For each submitted file the checker
//!
//! 1. compiles a private copy, under the fixed module name
//!    [`SUBMISSION_MODULE`] in a fresh temporary directory, to an `.olean`;
//! 2. replays every declaration of that module through the Lean kernel with
//!    the toolchain's `leanchecker` (this rejects declarations that were added
//!    without kernel checking);
//! 3. runs the checker-owned inspector `proof_policy/inspect_proof_facts.lean`
//!    (`lean --run`), which loads the `.olean` without running any of the
//!    submission's code and reports, as one JSON line: the axioms the module
//!    declares, the declarations that mention `sorryAx`, and for every
//!    required theorem its kind and the transitive axiom closure
//!    (`#print axioms`).
//!
//! [`evaluate`] then accepts the submission iff at least one required theorem
//! is named, every file passed steps 1–3, no file declares an axiom or
//! contains `sorry`/`admit`, and every required theorem is a `theorem`
//! declared in exactly one submitted file whose axioms are all in
//! [`ALLOWED_AXIOMS`].  `native_decide` is rejected (see [`NATIVE_AXIOMS`]).

use std::collections::BTreeSet;
use std::ffi::{OsStr, OsString};
use std::fs;
use std::path::{Path, PathBuf};
use std::process::{Command, Output};

use serde::Deserialize;

/// Axioms a required theorem may depend on.  Anything else is rejected.
pub const ALLOWED_AXIOMS: &[&str] = &["propext", "Classical.choice", "Quot.sound"];

/// Axioms that mean the proof trusts compiled code (`native_decide`,
/// `Lean.ofReduceBool`, ...) rather than the kernel alone.  Policy: always
/// rejected.  On newer toolchains (observed on 4.34.1) `native_decide` instead emits an
/// auxiliary axiom named `<decl>._native.native_decide.ax_<n>`; that name is
/// recognised by [`is_native_axiom`] so it is reported as `native_decide`.
/// (Every non-allowed axiom is rejected anyway; the name only picks the
/// message, it can never cause acceptance.)
pub const NATIVE_AXIOMS: &[&str] = &[
    "Lean.ofReduceBool",
    "Lean.ofReduceNat",
    "Lean.trustCompiler",
];

/// Module name the checker compiles each submitted file under.
pub const SUBMISSION_MODULE: &str = "AristotleSubmission";

const INSPECTOR_FILE: &str = "inspect_proof_facts.lean";
const INSPECTOR_SRC: &str = include_str!("proof_policy/inspect_proof_facts.lean");

/// Facts reported by the inspector for one compiled file.
#[derive(Debug, Clone, Default, Deserialize, PartialEq)]
pub struct ProofFacts {
    pub module: String,
    #[serde(default)]
    pub lean_version: String,
    pub declared_axioms: Vec<String>,
    pub sorry_decls: Vec<String>,
    #[serde(default)]
    pub theorems: Vec<String>,
    pub required: Vec<RequiredFact>,
}

/// Inspector facts about one required theorem name.
#[derive(Debug, Clone, Default, Deserialize, PartialEq)]
pub struct RequiredFact {
    pub name: String,
    pub found: bool,
    #[serde(default)]
    pub kind: Option<String>,
    #[serde(default)]
    pub axioms: Vec<String>,
    #[serde(default)]
    pub unresolved: Vec<String>,
}

/// Result of checking one file: any stage failure, plus the facts if the
/// inspector produced them.
#[derive(Debug, Clone, Default, PartialEq)]
pub struct FileCheck {
    pub file: String,
    pub errors: Vec<String>,
    pub facts: Option<ProofFacts>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct PolicyVerdict {
    pub accepted: bool,
    pub reasons: Vec<String>,
    /// Lean versions reported by the inspector (informational only).
    pub lean_versions: Vec<String>,
}

impl PolicyVerdict {
    pub fn report(&self) -> String {
        let mut s = String::from(if self.accepted {
            "=== PROOF POLICY: ACCEPTED ==="
        } else {
            "=== PROOF POLICY: REJECTED ==="
        });
        s.push_str(&format!(
            "\n  allowed axioms: {}",
            ALLOWED_AXIOMS.join(", ")
        ));
        if !self.lean_versions.is_empty() {
            s.push_str(&format!(
                "\n  lean version: {}",
                self.lean_versions.join(", ")
            ));
        }
        for r in &self.reasons {
            s.push_str(&format!("\n  - {}", r));
        }
        s
    }
}

pub fn is_native_axiom(name: &str) -> bool {
    NATIVE_AXIOMS.contains(&name) || name.contains("._native.native_decide.")
}

/// Required theorem names are passed to Lean as separate argv entries (never
/// through a shell); reject anything that is not a plain declaration name.
fn invalid_required_name(name: &str) -> bool {
    name.is_empty()
        || name.len() > 512
        || name.starts_with('-')
        || name.starts_with('.')
        || name.ends_with('.')
        || name.chars().any(|c| c.is_whitespace() || c.is_control())
}

fn required_set(required: &[String]) -> (BTreeSet<&str>, Vec<String>) {
    let mut reasons = Vec::new();
    let set: BTreeSet<&str> = required.iter().map(|s| s.as_str()).collect();
    if set.is_empty() {
        reasons.push(
            "no required theorems were declared (`required_theorems`); \
             a submission must name at least one theorem to count as proof evidence"
                .to_string(),
        );
    }
    for r in &set {
        if invalid_required_name(r) {
            reasons.push(format!("invalid required theorem name {:?}", r));
        }
    }
    (set, reasons)
}

/// Pure acceptance decision from per-file checks.  `accepted` is true iff
/// `reasons` is empty.
pub fn evaluate(required: &[String], files: &[FileCheck]) -> PolicyVerdict {
    let (required, mut reasons) = required_set(required);
    if files.is_empty() {
        reasons.push("no files were checked".to_string());
    }

    for fc in files {
        for e in &fc.errors {
            reasons.push(format!("{}: {}", fc.file, e));
        }
        match &fc.facts {
            None => {
                if fc.errors.is_empty() {
                    reasons.push(format!("{}: no proof facts were produced", fc.file));
                }
            }
            Some(f) => {
                if f.module != SUBMISSION_MODULE {
                    reasons.push(format!(
                        "{}: facts are for unexpected module `{}`",
                        fc.file, f.module
                    ));
                }
                for a in &f.declared_axioms {
                    if is_native_axiom(a) {
                        reasons.push(format!(
                            "{}: uses native_decide (auxiliary axiom `{}`); native_decide is rejected by policy",
                            fc.file, a
                        ));
                    } else {
                        reasons.push(format!("{}: declares axiom `{}`", fc.file, a));
                    }
                }
                for d in &f.sorry_decls {
                    reasons.push(format!("{}: `{}` contains sorry/admit", fc.file, d));
                }
            }
        }
    }

    for r in &required {
        let hits: Vec<(&str, &RequiredFact)> = files
            .iter()
            .filter_map(|fc| {
                let f = fc.facts.as_ref()?;
                let q = f.required.iter().find(|q| q.name == *r && q.found)?;
                Some((fc.file.as_str(), q))
            })
            .collect();
        match hits.as_slice() {
            [] => reasons.push(format!(
                "required theorem `{}` was not found in any checked file",
                r
            )),
            [(file, q)] => {
                let kind = q.kind.as_deref().unwrap_or("unknown declaration");
                if kind != "theorem" {
                    reasons.push(format!(
                        "required `{}` in {} has kind `{}`, not `theorem`",
                        r, file, kind
                    ));
                }
                for u in &q.unresolved {
                    reasons.push(format!(
                        "required theorem `{}` refers to unknown constant `{}`",
                        r, u
                    ));
                }
                for a in &q.axioms {
                    if ALLOWED_AXIOMS.contains(&a.as_str()) {
                        continue;
                    }
                    if a == "sorryAx" {
                        reasons.push(format!(
                            "required theorem `{}` depends on sorry/admit (`sorryAx`)",
                            r
                        ));
                    } else if is_native_axiom(a) {
                        reasons.push(format!(
                            "required theorem `{}` depends on `{}` (native_decide); rejected by policy",
                            r, a
                        ));
                    } else {
                        reasons.push(format!(
                            "required theorem `{}` depends on non-allowed axiom `{}`",
                            r, a
                        ));
                    }
                }
            }
            many => reasons.push(format!(
                "required theorem `{}` is declared in {} files ({}); ambiguous",
                r,
                many.len(),
                many.iter().map(|(f, _)| *f).collect::<Vec<_>>().join(", ")
            )),
        }
    }

    let lean_versions: BTreeSet<String> = files
        .iter()
        .filter_map(|fc| fc.facts.as_ref().map(|f| f.lean_version.clone()))
        .filter(|v| !v.is_empty())
        .collect();
    PolicyVerdict {
        accepted: reasons.is_empty(),
        reasons,
        lean_versions: lean_versions.into_iter().collect(),
    }
}

/// Check the submitted `(name, content)` pairs against the policy using
/// `lean` / `leanchecker` from `PATH`.  The checked bytes are the submitted
/// content itself, not whatever is on disk in `work_dir` at check time.
pub fn check_submission(
    work_dir: &Path,
    files: &[(String, String)],
    required: &[String],
) -> PolicyVerdict {
    check_submission_with("lean", "leanchecker", work_dir, files, required)
}

pub fn check_submission_with(
    lean: &str,
    leanchecker: &str,
    work_dir: &Path,
    files: &[(String, String)],
    required: &[String],
) -> PolicyVerdict {
    let inherited = std::env::var_os("LEAN_PATH");
    check_submission_in(
        lean,
        leanchecker,
        work_dir,
        inherited.as_deref(),
        files,
        required,
    )
}

/// Like [`check_submission_with`], with the operator's `LEAN_PATH` passed
/// explicitly.  The compile step sees exactly `lean_path` (as the existing
/// `lean <file>` step does, by inheritance); kernel replay and the inspector
/// see the private `.olean` directory first, followed by `lean_path`, so a
/// library the compile step resolved is also resolvable when the module is
/// replayed and inspected.
fn check_submission_in(
    lean: &str,
    leanchecker: &str,
    work_dir: &Path,
    lean_path: Option<&OsStr>,
    files: &[(String, String)],
    required: &[String],
) -> PolicyVerdict {
    let (set, problems) = required_set(required);
    if !problems.is_empty() {
        return PolicyVerdict {
            accepted: false,
            reasons: problems,
            lean_versions: vec![],
        };
    }
    let required: Vec<String> = set.into_iter().map(String::from).collect();
    let checks: Vec<FileCheck> = files
        .iter()
        .map(|(name, content)| {
            check_file(lean, leanchecker, work_dir, lean_path, name, content, &required)
        })
        .collect();
    evaluate(&required, &checks)
}

/// Short, single-line summary of a tool's diagnostics for the report.
fn diagnostics(out: &Output) -> String {
    let stderr = String::from_utf8_lossy(&out.stderr);
    let stdout = String::from_utf8_lossy(&out.stdout);
    let text = if stderr.trim().is_empty() {
        stdout
    } else {
        stderr
    };
    let joined = text
        .lines()
        .map(str::trim)
        .filter(|l| !l.is_empty())
        .collect::<Vec<_>>()
        .join(" ");
    joined.chars().take(300).collect()
}

/// `LEAN_PATH` for kernel replay and inspection: the private `.olean`
/// directory first (so `SUBMISSION_MODULE` always resolves to the module just
/// compiled), then the operator's entries.
fn replay_lean_path(olean_dir: &Path, lean_path: Option<&OsStr>) -> Result<OsString, String> {
    let mut entries: Vec<PathBuf> = vec![olean_dir.to_path_buf()];
    if let Some(p) = lean_path {
        entries.extend(std::env::split_paths(p).filter(|e| !e.as_os_str().is_empty()));
    }
    std::env::join_paths(entries).map_err(|e| format!("could not build LEAN_PATH: {}", e))
}

/// Run the three stages for one file.  Every Lean process runs with
/// `current_dir(work_dir)`, like the existing compile step, so toolchain
/// selection is unchanged; only the private copy and its build products live
/// in a fresh temporary directory.
fn check_file(
    lean: &str,
    leanchecker: &str,
    work_dir: &Path,
    lean_path: Option<&OsStr>,
    name: &str,
    content: &str,
    required: &[String],
) -> FileCheck {
    let mut fc = FileCheck {
        file: name.to_string(),
        ..Default::default()
    };

    let setup =
        || -> std::io::Result<(tempfile::TempDir, std::path::PathBuf, std::path::PathBuf)> {
            let tmp = tempfile::Builder::new()
                .prefix("aristo-proof-policy-")
                .tempdir()?;
            let src_dir = tmp.path().join("src");
            let olean_dir = tmp.path().join("olean");
            fs::create_dir(&src_dir)?;
            fs::create_dir(&olean_dir)?;
            let src = src_dir.join(format!("{}.lean", SUBMISSION_MODULE));
            fs::write(&src, content)?;
            Ok((tmp, src, olean_dir))
        };
    let (tmp, src, olean_dir) = match setup() {
        Ok(x) => x,
        Err(e) => {
            fc.errors
                .push(format!("could not prepare proof check: {}", e));
            return fc;
        }
    };
    let src_dir = src.parent().unwrap_or(tmp.path()).to_path_buf();
    let olean = olean_dir.join(format!("{}.olean", SUBMISSION_MODULE));

    let replay_path = match replay_lean_path(&olean_dir, lean_path) {
        Ok(p) => p,
        Err(e) => {
            fc.errors.push(e);
            return fc;
        }
    };

    // 1. Compile to an .olean.
    let mut compile = Command::new(lean);
    compile
        .arg("-R")
        .arg(&src_dir)
        .arg("-o")
        .arg(&olean)
        .arg(&src)
        .current_dir(work_dir);
    match lean_path {
        Some(p) => compile.env("LEAN_PATH", p),
        None => compile.env_remove("LEAN_PATH"),
    };
    match compile.output() {
        Ok(out) if out.status.success() && olean.is_file() => {}
        Ok(out) => {
            let msg = diagnostics(&out).replace(&*src.to_string_lossy(), &fc.file);
            fc.errors
                .push(format!("does not compile ({}): {}", out.status, msg));
            return fc;
        }
        Err(e) => {
            fc.errors.push(format!("could not run lean: {}", e));
            return fc;
        }
    }

    // 2. Kernel replay of every declaration in the module.
    match Command::new(leanchecker)
        .arg(SUBMISSION_MODULE)
        .env("LEAN_PATH", &replay_path)
        .current_dir(work_dir)
        .output()
    {
        Ok(out) if out.status.success() => {}
        Ok(out) => fc.errors.push(format!(
            "kernel replay (leanchecker) rejected the module ({}): {}",
            out.status,
            diagnostics(&out)
        )),
        Err(e) => fc.errors.push(format!("could not run leanchecker: {}", e)),
    }

    // 3. Inspect.  The inspector is written only after the submission has
    //    been compiled, into a directory the submission never saw.
    let tool_dir = tmp.path().join("inspect");
    let inspector = tool_dir.join(INSPECTOR_FILE);
    if let Err(e) = fs::create_dir(&tool_dir).and_then(|_| fs::write(&inspector, INSPECTOR_SRC)) {
        fc.errors.push(format!("could not write inspector: {}", e));
        return fc;
    }
    match Command::new(lean)
        .arg("--run")
        .arg(&inspector)
        .arg(SUBMISSION_MODULE)
        .args(required)
        .env("LEAN_PATH", &replay_path)
        .current_dir(work_dir)
        .output()
    {
        Ok(out) if out.status.success() => {
            let stdout = String::from_utf8_lossy(&out.stdout);
            match serde_json::from_str::<ProofFacts>(stdout.trim()) {
                Ok(f) => fc.facts = Some(f),
                Err(e) => fc
                    .errors
                    .push(format!("inspector output is not valid facts JSON: {}", e)),
            }
        }
        Ok(out) => fc.errors.push(format!(
            "inspector failed ({}): {}",
            out.status,
            diagnostics(&out)
        )),
        Err(e) => fc.errors.push(format!("could not run inspector: {}", e)),
    }
    fc
}

#[cfg(test)]
mod tests {
    use super::*;

    fn req(names: &[&str]) -> Vec<String> {
        names.iter().map(|s| s.to_string()).collect()
    }

    fn thm(name: &str, axioms: &[&str]) -> RequiredFact {
        RequiredFact {
            name: name.into(),
            found: true,
            kind: Some("theorem".into()),
            axioms: req(axioms),
            unresolved: vec![],
        }
    }

    fn absent(name: &str) -> RequiredFact {
        RequiredFact {
            name: name.into(),
            ..Default::default()
        }
    }

    fn file(name: &str, required: Vec<RequiredFact>) -> FileCheck {
        FileCheck {
            file: name.into(),
            errors: vec![],
            facts: Some(ProofFacts {
                module: SUBMISSION_MODULE.into(),
                required,
                ..Default::default()
            }),
        }
    }

    fn accepted(required: &[&str], files: &[FileCheck]) -> bool {
        evaluate(&req(required), files).accepted
    }

    #[test]
    fn clean_theorem_is_accepted() {
        assert!(accepted(
            &["target"],
            &[file("A.lean", vec![thm("target", &[])])]
        ));
    }

    #[test]
    fn standard_axioms_are_accepted() {
        for axs in [
            &["propext"][..],
            &["Classical.choice"],
            &["Quot.sound"],
            &["propext", "Classical.choice", "Quot.sound"],
        ] {
            assert!(
                accepted(&["target"], &[file("A.lean", vec![thm("target", axs)])]),
                "{:?}",
                axs
            );
        }
    }

    #[test]
    fn sorry_is_rejected() {
        let mut f = file("A.lean", vec![thm("target", &["sorryAx"])]);
        f.facts.as_mut().unwrap().sorry_decls = req(&["target"]);
        let v = evaluate(&req(&["target"]), &[f]);
        assert!(!v.accepted);
        assert!(v.reasons.iter().any(|r| r.contains("sorry")));
    }

    #[test]
    fn sorry_in_a_non_required_declaration_is_rejected() {
        let mut f = file("A.lean", vec![thm("target", &[])]);
        f.facts.as_mut().unwrap().sorry_decls = req(&["helper"]);
        assert!(!accepted(&["target"], &[f]));
    }

    #[test]
    fn declared_custom_axiom_is_rejected_even_if_unused() {
        let mut f = file("A.lean", vec![thm("target", &[])]);
        f.facts.as_mut().unwrap().declared_axioms = req(&["bad_axiom"]);
        assert!(!accepted(&["target"], &[f]));
    }

    #[test]
    fn theorem_from_custom_axiom_is_rejected() {
        let mut f = file("A.lean", vec![thm("target", &["bad_axiom"])]);
        f.facts.as_mut().unwrap().declared_axioms = req(&["bad_axiom"]);
        assert!(!accepted(&["target"], &[f.clone()]));
        // Rejected by the axiom closure alone, too.
        f.facts.as_mut().unwrap().declared_axioms.clear();
        assert!(!accepted(&["target"], &[f]));
    }

    #[test]
    fn native_decide_is_rejected_in_both_encodings() {
        // Lean 4.28: Lean.ofReduceBool + Lean.trustCompiler.
        let old = file(
            "A.lean",
            vec![thm("target", &["Lean.ofReduceBool", "Lean.trustCompiler"])],
        );
        let v = evaluate(&req(&["target"]), &[old]);
        assert!(!v.accepted);
        assert!(v.reasons.iter().any(|r| r.contains("native_decide")));
        // Newer toolchains: auxiliary axiom declared in the submission.
        let aux = "target._native.native_decide.ax_1_1";
        let mut new = file("A.lean", vec![thm("target", &[aux])]);
        new.facts.as_mut().unwrap().declared_axioms = req(&[aux]);
        let v = evaluate(&req(&["target"]), &[new]);
        assert!(!v.accepted);
        assert!(v.reasons.iter().all(|r| r.contains("native_decide")));
    }

    #[test]
    fn missing_required_theorem_is_rejected() {
        assert!(!accepted(
            &["target"],
            &[file("A.lean", vec![absent("target")])]
        ));
        // Inspector did not report the name at all: fail closed.
        assert!(!accepted(&["target"], &[file("A.lean", vec![])]));
    }

    #[test]
    fn no_required_theorems_is_rejected() {
        assert!(!accepted(&[], &[file("A.lean", vec![])]));
    }

    #[test]
    fn empty_file_is_rejected() {
        // An empty file compiles and declares nothing.
        assert!(!accepted(
            &["target"],
            &[file("Empty.lean", vec![absent("target")])]
        ));
    }

    #[test]
    fn definitions_only_is_rejected() {
        let mut def = thm("target", &[]);
        def.kind = Some("def".into());
        assert!(!accepted(&["target"], &[file("Defs.lean", vec![def])]));
        assert!(!accepted(
            &["target"],
            &[file("Defs.lean", vec![absent("target")])]
        ));
    }

    #[test]
    fn required_name_that_is_an_axiom_is_rejected() {
        let mut ax = thm("target", &["target"]);
        ax.kind = Some("axiom".into());
        let mut f = file("A.lean", vec![ax]);
        f.facts.as_mut().unwrap().declared_axioms = req(&["target"]);
        assert!(!accepted(&["target"], &[f]));
    }

    #[test]
    fn unrelated_clean_theorem_does_not_hide_bad_target() {
        let mut f = file("A.lean", vec![thm("target", &["sorryAx"])]);
        let facts = f.facts.as_mut().unwrap();
        facts.theorems = req(&["helper_ok", "target"]);
        facts.sorry_decls = req(&["target"]);
        assert!(!accepted(&["target"], &[f]));
    }

    #[test]
    fn unresolved_constants_are_rejected() {
        let mut t = thm("target", &[]);
        t.unresolved = req(&["ghost"]);
        assert!(!accepted(&["target"], &[file("A.lean", vec![t])]));
    }

    #[test]
    fn any_stage_error_rejects() {
        let mut f = file("A.lean", vec![thm("target", &[])]);
        f.errors
            .push("kernel replay (leanchecker) rejected the module".into());
        assert!(!accepted(&["target"], &[f]));
        let none = FileCheck {
            file: "B.lean".into(),
            errors: vec![],
            facts: None,
        };
        assert!(!accepted(
            &["target"],
            &[file("A.lean", vec![thm("target", &[])]), none]
        ));
    }

    #[test]
    fn wrong_module_is_rejected() {
        let mut f = file("A.lean", vec![thm("target", &[])]);
        f.facts.as_mut().unwrap().module = "Other".into();
        assert!(!accepted(&["target"], &[f]));
    }

    #[test]
    fn multi_file_rules() {
        let clean_a = file("A.lean", vec![thm("t1", &[]), absent("t2")]);
        let clean_b = file("B.lean", vec![absent("t1"), thm("t2", &["propext"])]);
        // Required theorems spread over files: accepted.
        assert!(accepted(&["t1", "t2"], &[clean_a.clone(), clean_b.clone()]));
        // Any sorry anywhere rejects.
        let mut dirty_b = clean_b.clone();
        dirty_b.facts.as_mut().unwrap().sorry_decls = req(&["junk"]);
        assert!(!accepted(&["t1", "t2"], &[clean_a.clone(), dirty_b]));
        // Same required theorem in two files: ambiguous, rejected.
        let dup = file("C.lean", vec![thm("t1", &[]), absent("t2")]);
        assert!(!accepted(&["t1", "t2"], &[clean_a.clone(), clean_b, dup]));
        // Order does not matter.
        let bad = file("D.lean", vec![absent("t1")]);
        let mut bad = bad;
        bad.errors.push("does not compile".into());
        assert!(!accepted(&["t1"], &[clean_a.clone(), bad.clone()]));
        assert!(!accepted(&["t1"], &[bad, clean_a]));
    }

    #[test]
    fn zero_files_is_rejected() {
        assert!(!accepted(&["target"], &[]));
    }

    #[test]
    fn invalid_required_names_are_rejected_without_running_lean() {
        for bad in ["", "-o", "a b", ".x", "x.", "a\nb"] {
            let v = check_submission_with(
                "/nonexistent/lean",
                "/nonexistent/leanchecker",
                Path::new("."),
                &[(
                    "A.lean".to_string(),
                    "theorem t : True := trivial\n".to_string(),
                )],
                &req(&[bad]),
            );
            assert!(!v.accepted, "{:?}", bad);
            assert!(
                v.reasons
                    .iter()
                    .any(|r| r.contains("invalid required theorem name"))
            );
        }
    }

    #[test]
    fn missing_tools_fail_closed() {
        let dir = tempfile::tempdir().unwrap();
        let v = check_submission_with(
            "/nonexistent/lean",
            "/nonexistent/leanchecker",
            dir.path(),
            &[(
                "A.lean".to_string(),
                "theorem target : True := trivial\n".to_string(),
            )],
            &req(&["target"]),
        );
        assert!(!v.accepted);
    }

    #[test]
    fn inspector_json_parses() {
        let json = r#"{"declared_axioms":[],"lean_version":"4.28.0","module":"AristotleSubmission","required":[{"axioms":["propext"],"found":true,"kind":"theorem","name":"target","unresolved":[]},{"found":false,"name":"nope"}],"sorry_decls":[],"theorems":["target"]}"#;
        let f: ProofFacts = serde_json::from_str(json).unwrap();
        assert_eq!(f.required.len(), 2);
        assert!(!f.required[1].found);
        assert!(accepted(
            &["target"],
            &[FileCheck {
                file: "A.lean".into(),
                errors: vec![],
                facts: Some(f)
            }]
        ));
    }

    // ── End-to-end with the real toolchain ─────────────────────────────
    //
    // These need `lean` and `leanchecker` (elan) on PATH and take a few
    // seconds per file.  Run with:
    //   cargo test --bin aristotle-manager proof_policy:: -- --include-ignored

    const CLEAN: &str = "theorem target : 2 + 2 = 4 := rfl\n";
    const DECIDE: &str = "theorem target : 2 + 2 = 4 := by decide\n";
    const SORRY: &str = "theorem target : 2 + 2 = 5 := sorry\n";
    const SORRY_NO_WARN_ERR: &str =
        "set_option warningAsError false in\ntheorem target : 2 + 2 = 5 := sorry\n";
    const ADMIT: &str = "theorem target : 2 + 2 = 5 := by admit\n";
    const CUSTOM_AXIOM: &str = "axiom bad_axiom : False\ntheorem target : 2 + 2 = 4 := rfl\n";
    const FROM_CUSTOM_AXIOM: &str =
        "axiom bad_axiom : False\ntheorem target : 2 + 2 = 5 := bad_axiom.elim\n";
    const CHOICE: &str = "noncomputable def pick : Nat := Classical.choice ⟨0⟩\n\
                          theorem target : pick = pick ∨ False := Or.inl (Classical.choice ⟨rfl⟩)\n";
    const PROPEXT: &str = "theorem target (a b : Prop) (h : a ↔ b) : a = b := propext h\n";
    const QUOT_SOUND: &str =
        "theorem target (f g : Nat → Nat) (h : ∀ x, f x = g x) : f = g := funext h\n";
    const EM: &str = "theorem target (p : Prop) : p ∨ ¬p := Classical.em p\n";
    const NATIVE: &str = "theorem target : 10 < 20 := by native_decide\n";
    /// `native_decide` trusts compiled code, so `implemented_by` lets it prove `False`.
    const NATIVE_FALSE: &str = "def trueImpl (_ : Nat) : Bool := true\n\
        @[implemented_by trueImpl] def g (_ : Nat) : Bool := false\n\
        theorem g_true : g 0 = true := by native_decide\n\
        theorem target : False := by\n  have h := g_true\n  simp [g] at h\n";
    const DEFS_ONLY: &str = "def double (n : Nat) : Nat := 2 * n\n";
    const DEF_NAMED_TARGET: &str = "def target : Nat := 4\n";
    const EMPTY: &str = "";
    const UNRELATED_PLUS_BAD: &str =
        "theorem helper_ok : 1 + 1 = 2 := rfl\ntheorem target : 2 + 2 = 5 := sorry\n";
    const OTHER_NAME: &str = "theorem other_name : 2 + 2 = 4 := rfl\n";
    const TARGET_IS_AXIOM: &str = "axiom target : 2 + 2 = 5\n";
    const KERNEL_BYPASS: &str = "import Lean\n\
        open Lean Elab Command in\n\
        set_option debug.skipKernelTC true in\n\
        run_cmd liftCoreM <| addDecl <| .thmDecl ({ name := `bad_thm, levelParams := [], \
        type := mkConst ``False, value := mkConst ``True.intro } : TheoremVal)\n\
        theorem target : 2 + 2 = 5 := bad_thm.elim\n";
    const SYNTAX_ERROR: &str = "theorem target : 2 + 2 = 4 := by\n  exact (\n";

    fn real(files: &[(&str, &str)], required: &[&str]) -> PolicyVerdict {
        let dir = tempfile::tempdir().unwrap();
        let files_owned: Vec<(String, String)> = files
            .iter()
            .map(|(n, body)| (n.to_string(), body.to_string()))
            .collect();
        let v = check_submission(dir.path(), &files_owned, &req(required));
        eprintln!(
            "{:?} -> {}",
            files.iter().map(|f| f.0).collect::<Vec<_>>(),
            v.report()
        );
        v
    }

    fn real1(body: &str) -> bool {
        real(&[("Main.lean", body)], &["target"]).accepted
    }

    #[test]
    #[ignore = "needs lean + leanchecker on PATH"]
    fn real_accepts_clean_and_standard_axioms() {
        for (label, body) in [
            ("clean", CLEAN),
            ("decide", DECIDE),
            ("Classical.choice", CHOICE),
            ("propext", PROPEXT),
            ("Quot.sound", QUOT_SOUND),
            ("all three standard axioms", EM),
        ] {
            assert!(real1(body), "{} should be accepted", label);
        }
    }

    #[test]
    #[ignore = "needs lean + leanchecker on PATH"]
    fn real_rejects_unsound_or_empty() {
        for (label, body) in [
            ("sorry", SORRY),
            ("sorry + warningAsError false", SORRY_NO_WARN_ERR),
            ("admit", ADMIT),
            ("declared custom axiom", CUSTOM_AXIOM),
            ("theorem from custom axiom", FROM_CUSTOM_AXIOM),
            ("native_decide", NATIVE),
            ("native_decide + implemented_by proving False", NATIVE_FALSE),
            ("definitions only", DEFS_ONLY),
            ("def named like the target", DEF_NAMED_TARGET),
            ("empty file", EMPTY),
            ("unrelated clean theorem + bad target", UNRELATED_PLUS_BAD),
            ("missing required theorem", OTHER_NAME),
            ("target is an axiom", TARGET_IS_AXIOM),
            ("kernel bypass via debug.skipKernelTC", KERNEL_BYPASS),
            ("syntax error", SYNTAX_ERROR),
        ] {
            assert!(!real1(body), "{} should be rejected", label);
        }
    }

    #[test]
    #[ignore = "needs lean + leanchecker on PATH"]
    fn real_multi_file_and_required_list() {
        // No required theorem named: rejected even though the file is clean.
        assert!(!real(&[("A.lean", CLEAN)], &[]).accepted);
        // Clean target + an unrelated file containing sorry: rejected.
        assert!(
            !real(
                &[
                    ("A.lean", CLEAN),
                    ("B.lean", "theorem junk : 1 = 2 := sorry\n")
                ],
                &["target"]
            )
            .accepted
        );
        // Same required theorem in two files: rejected.
        assert!(!real(&[("A.lean", CLEAN), ("B.lean", DECIDE)], &["target"]).accepted);
        // Two clean files, each providing one required theorem: accepted.
        assert!(
            real(
                &[
                    ("A.lean", "theorem t1 : 1 + 1 = 2 := rfl\n"),
                    ("B.lean", PROPEXT.replace("target", "t2").as_str())
                ],
                &["t1", "t2"]
            )
            .accepted
        );
        // A theorem from the toolchain is not evidence from the submission.
        assert!(!real(&[("A.lean", CLEAN)], &["target", "Nat.add_comm"]).accepted);
    }

    // ── Cross-file imports between submitted files ─────────────────────
    //
    // Each submitted file is compiled on its own (both by the pre-policy
    // `lean <file>` step and by the policy), and neither step builds an
    // `.olean` for a sibling, so `import Helper` of a submitted `Helper.lean`
    // never resolves.  These pin that the policy fails closed on it (at its
    // compile step, never later) instead of accepting or crashing.

    const HELPER: &str = "theorem helper : True := by trivial\n";
    const MAIN_IMPORTS_HELPER: &str = "import Helper\ntheorem target : True := helper\n";

    #[test]
    #[ignore = "needs lean + leanchecker on PATH"]
    fn real_cross_file_import_is_rejected_at_compile() {
        for files in [
            [("Helper.lean", HELPER), ("Main.lean", MAIN_IMPORTS_HELPER)],
            [("Main.lean", MAIN_IMPORTS_HELPER), ("Helper.lean", HELPER)],
        ] {
            let v = real(&files, &["target"]);
            assert!(!v.accepted);
            assert!(v.reasons.iter().any(|r| r.starts_with("Main.lean: does not compile")
                && r.contains("unknown module prefix 'Helper'")));
            assert!(!v.reasons.iter().any(|r| r.contains("leanchecker") || r.contains("inspector")));
            assert!(v.reasons.iter().any(|r| r.contains("`target` was not found")));
        }
        // A required theorem that lives in the (clean) sibling is still found there.
        assert!(real(&[("Helper.lean", HELPER)], &["helper"]).accepted);
    }

    #[test]
    #[ignore = "needs lean + leanchecker on PATH"]
    fn real_missing_import_is_rejected() {
        let v = real(&[("Main.lean", "import DoesNotExist\ntheorem target : True := trivial\n")], &["target"]);
        assert!(!v.accepted);
        assert!(v.reasons.iter().any(|r| r.contains("does not compile")));
    }

    #[test]
    fn replay_lean_path_puts_private_oleans_first() {
        let p = replay_lean_path(Path::new("/priv/olean"), None).unwrap();
        assert_eq!(p, OsString::from("/priv/olean"));
        let p = replay_lean_path(Path::new("/priv/olean"), Some(OsStr::new("/lib/a::/lib/b")))
            .unwrap();
        let entries: Vec<PathBuf> = std::env::split_paths(&p).collect();
        assert_eq!(
            entries,
            vec![
                PathBuf::from("/priv/olean"),
                PathBuf::from("/lib/a"),
                PathBuf::from("/lib/b")
            ]
        );
    }

    // ── Imports resolved through the operator's LEAN_PATH ──────────────
    //
    // The existing `lean <file>` step inherits the server's LEAN_PATH, so a
    // submission may import a library the operator provides there.  Kernel
    // replay and the inspector must resolve the same library; facts about
    // it are still checked by the same rules.

    /// Compile `modules` (in order) into a fresh library directory with the
    /// toolchain under test and return it.
    fn build_lib(modules: &[(&str, &str)]) -> tempfile::TempDir {
        let lib = tempfile::tempdir().unwrap();
        for (m, body) in modules {
            let src = lib.path().join(format!("{}.lean", m));
            fs::write(&src, body).unwrap();
            let out = Command::new("lean")
                .arg("-R")
                .arg(lib.path())
                .arg("-o")
                .arg(lib.path().join(format!("{}.olean", m)))
                .arg(&src)
                .env("LEAN_PATH", lib.path())
                .output()
                .unwrap();
            assert!(out.status.success(), "{}: {}", m, diagnostics(&out));
        }
        lib
    }

    fn real_with_path(lib: Option<&Path>, files: &[(&str, &str)], required: &[&str]) -> PolicyVerdict {
        let dir = tempfile::tempdir().unwrap();
        let files_owned: Vec<(String, String)> = files
            .iter()
            .map(|(n, body)| (n.to_string(), body.to_string()))
            .collect();
        let v = check_submission_in(
            "lean",
            "leanchecker",
            dir.path(),
            lib.map(Path::as_os_str),
            &files_owned,
            &req(required),
        );
        eprintln!("{:?} (LEAN_PATH {:?}) -> {}", files.iter().map(|f| f.0).collect::<Vec<_>>(), lib, v.report());
        v
    }

    #[test]
    #[ignore = "needs lean + leanchecker on PATH"]
    fn real_library_import_through_lean_path() {
        let lib = build_lib(&[
            ("Lib", "theorem lib_thm : True := trivial\n"),
            ("LibSorry", "theorem lib_sorry : 2 + 2 = 5 := sorry\n"),
            ("LibAxiom", "axiom lib_ax : False\n"),
            ("LibNative", "theorem lib_native : 10 < 20 := by native_decide\n"),
        ]);
        let lib = Some(lib.path());
        let main = "import Lib\ntheorem target : True := lib_thm\n";

        // Clean import: accepted; kernel replay and inspection resolve `Lib`.
        assert!(real_with_path(lib, &[("Main.lean", main)], &["target"]).accepted);
        // Same file without the library on LEAN_PATH: rejected at compile.
        let v = real_with_path(None, &[("Main.lean", main)], &["target"]);
        assert!(!v.accepted);
        assert!(v.reasons.iter().any(|r| r.contains("does not compile")));
        // Missing module: rejected.
        assert!(
            !real_with_path(lib, &[("Main.lean", "import NoSuchLib\ntheorem target : True := trivial\n")], &["target"])
                .accepted
        );
        // A theorem declared by the library is not evidence from the submission.
        assert!(!real_with_path(lib, &[("Main.lean", main)], &["target", "lib_thm"]).accepted);

        // sorry / custom axiom / native_decide inside the imported module
        // still reject the required theorem that depends on it.
        let v = real_with_path(
            lib,
            &[("Main.lean", "import LibSorry\ntheorem target : 2 + 2 = 5 := lib_sorry\n")],
            &["target"],
        );
        assert!(!v.accepted);
        assert!(v.reasons.iter().any(|r| r.contains("depends on sorry/admit")));
        let v = real_with_path(
            lib,
            &[("Main.lean", "import LibAxiom\ntheorem target : 2 + 2 = 5 := lib_ax.elim\n")],
            &["target"],
        );
        assert!(!v.accepted);
        assert!(v.reasons.iter().any(|r| r.contains("non-allowed axiom `lib_ax`")));
        let v = real_with_path(
            lib,
            &[("Main.lean", "import LibNative\ntheorem target : 10 < 20 := lib_native\n")],
            &["target"],
        );
        assert!(!v.accepted);
        assert!(v.reasons.iter().any(|r| r.contains("native_decide")));
    }

    #[test]
    #[ignore = "needs lean + leanchecker on PATH"]
    fn real_lean_path_cannot_shadow_the_submission() {
        // A clean `AristotleSubmission` on the operator's LEAN_PATH must not
        // stand in for the submitted module during replay and inspection.
        let lib = build_lib(&[(SUBMISSION_MODULE, CLEAN)]);
        let v = real_with_path(Some(lib.path()), &[("Main.lean", SORRY)], &["target"]);
        assert!(!v.accepted);
        assert!(v.reasons.iter().any(|r| r.contains("contains sorry/admit")));
    }
}
