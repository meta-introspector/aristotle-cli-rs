import Mathlib

/-!
# Permission and Approval System

A Lean formalization of a tool permission and approval system inspired by
the Amazon Q Developer CLI architecture.

## Overview

The system models:
- **`PermissionEvalResult`**: Three-valued permission outcomes (Allow, Ask, Deny)
- **`ToolName`**: Tool identifiers with optional server namespacing
- **`Pattern`**: Glob-like patterns for matching tool names
- **`Agent`**: Configuration holding allowed tools and per-tool settings
- **`evalPerm`**: Permission evaluation combining allowlists, per-tool allow/deny paths,
  and a default fallback

## Key properties proved:
- Deny rules always take priority over allow rules
- An explicitly allowed tool (in the global allowlist, with no deny match) is allowed
- The evaluation is deterministic
- Monotonicity: enlarging the allowlist can only make permissions more permissive
-/

-- ============================================================================
-- Core Types
-- ============================================================================

/-- Result of evaluating tool permissions. -/
inductive PermissionEvalResult where
  | Allow
  | Ask
  | Deny (reasons : List String)
  deriving Repr, DecidableEq

/-- A tool name, optionally scoped to an MCP server. -/
structure ToolName where
  name : String
  server : Option String := none
  deriving Repr, DecidableEq

/-- A simple glob-like pattern that matches tool names.
    `exact s` matches the literal string `s`;
    `wildcard` matches everything. -/
inductive Pattern where
  | exact (s : String)
  | wildcard
  deriving Repr, DecidableEq

/-- Check whether a pattern matches a given string. -/
def Pattern.matches (p : Pattern) (s : String) : Bool :=
  match p with
  | .exact t => t == s
  | .wildcard => true

/-- Check whether *any* pattern in a set matches the string. -/
def matchesAny (patterns : List Pattern) (s : String) : Bool :=
  patterns.any (·.matches s)

-- ============================================================================
-- Tool Settings (per-tool allow / deny paths)
-- ============================================================================

/-- Per-tool settings that refine permission evaluation.
    `allowedPaths` / `deniedPaths` act as secondary allow/deny lists
    applied to the tool's *arguments* (e.g. file paths or commands). -/
structure ToolSettings where
  allowedPaths : List Pattern := []
  deniedPaths  : List Pattern := []
  deriving Repr, DecidableEq

-- ============================================================================
-- Agent Configuration
-- ============================================================================

/-- An agent's permission configuration. -/
structure Agent where
  /-- Global allowlist patterns for tool names. -/
  allowedTools  : List Pattern
  /-- Per-tool settings keyed by tool name. -/
  toolsSettings : List (String × ToolSettings)
  deriving Repr

-- ============================================================================
-- Permission Evaluation
-- ============================================================================

/-- Look up per-tool settings for a given tool name. -/
def Agent.getToolSettings (a : Agent) (toolName : String) : Option ToolSettings :=
  (a.toolsSettings.find? (·.1 == toolName)).map (·.2)

/-- Is the tool name in the agent's global allowlist? -/
def Agent.isInAllowlist (a : Agent) (toolName : String) : Bool :=
  matchesAny a.allowedTools toolName

/-- Core permission evaluation.

    The evaluation follows this priority order:
    1. If per-tool settings exist and a **deny** pattern matches `arg` → `Deny`
    2. If per-tool settings exist and an **allow** pattern matches `arg`,
       or the tool is in the global allowlist → `Allow`
    3. If no per-tool settings exist and the tool is in the global allowlist → `Allow`
    4. Otherwise → `Ask`

    Parameters:
    - `agent`    : the agent configuration
    - `toolName` : the name of the tool being invoked
    - `arg`      : the argument to the tool (e.g. a file path or command string)
-/
def evalPerm (agent : Agent) (toolName : String) (arg : String) : PermissionEvalResult :=
  let isInAllowlist := agent.isInAllowlist toolName
  match agent.getToolSettings toolName with
  | some settings =>
    -- Check deny list first
    let deniedMatches := settings.deniedPaths.filter (·.matches arg)
    if deniedMatches.length > 0 then
      .Deny (deniedMatches.map fun
        | .exact s => s
        | .wildcard => "*")
    else if isInAllowlist || matchesAny settings.allowedPaths arg then
      .Allow
    else
      .Ask
  | none =>
    if isInAllowlist then .Allow
    else .Ask

-- ============================================================================
-- Runtime Trust Management
-- ============================================================================

/-- Add patterns to the agent's global allowlist. -/
def Agent.trustTools (a : Agent) (patterns : List Pattern) : Agent :=
  { a with allowedTools := a.allowedTools ++ patterns }

/-- Remove patterns from the agent's global allowlist. -/
def Agent.untrustTools (a : Agent) (patterns : List Pattern) : Agent :=
  { a with allowedTools := a.allowedTools.filter (· ∉ patterns) }

-- ============================================================================
-- Properties
-- ============================================================================

/-- Helper: the denied-matches list for a given settings and arg. -/
def deniedMatches (settings : ToolSettings) (arg : String) : List Pattern :=
  settings.deniedPaths.filter (·.matches arg)

/-
**Deny Priority**: If any deny pattern matches the argument, evaluation
    always returns `Deny`, regardless of the allowlist or allow-path settings.
-/
theorem deny_takes_priority
    (agent : Agent) (toolName arg : String) (settings : ToolSettings)
    (hSettings : agent.getToolSettings toolName = some settings)
    (hDeny : (deniedMatches settings arg).length > 0) :
    ∃ reasons, evalPerm agent toolName arg = .Deny reasons := by
  unfold evalPerm;
  unfold deniedMatches at *; aesop;

/-
**Allow from allowlist**: If the tool is in the global allowlist and there
    are no deny matches, the tool is allowed.
-/
theorem allowlist_allows
    (agent : Agent) (toolName arg : String)
    (hAllow : agent.isInAllowlist toolName = true)
    (hNoDeny : ∀ s, agent.getToolSettings toolName = some s →
               (deniedMatches s arg).length = 0) :
    evalPerm agent toolName arg = .Allow := by
  unfold evalPerm;
  unfold deniedMatches at hNoDeny; aesop;

/-
**Default Ask**: If the tool has no settings and is not in the allowlist,
    the result is `Ask`.
-/
theorem default_is_ask
    (agent : Agent) (toolName arg : String)
    (hNoSettings : agent.getToolSettings toolName = none)
    (hNotAllowed : agent.isInAllowlist toolName = false) :
    evalPerm agent toolName arg = .Ask := by
  unfold evalPerm; aesop;

/-
**Determinism**: `evalPerm` is a function (same inputs → same output).
    This is trivially true in Lean but stated for documentation.
-/
theorem evalPerm_deterministic
    (agent : Agent) (toolName arg : String) :
    evalPerm agent toolName arg = evalPerm agent toolName arg := by
  rfl

/-
**Monotonicity of trust**: Adding patterns to the allowlist can only
    make a previously `Allow`ed tool remain `Allow`ed (when no deny matches).
-/
theorem trust_monotone_allow
    (agent : Agent) (toolName arg : String) (extra : List Pattern)
    (hAllow : evalPerm agent toolName arg = .Allow) :
    evalPerm (agent.trustTools extra) toolName arg = .Allow := by
  grind +locals

/-
**Wildcard deny blocks everything**: If the deny list contains a wildcard,
    every argument is denied.
-/
theorem wildcard_deny_blocks_all
    (agent : Agent) (toolName arg : String) (settings : ToolSettings)
    (hSettings : agent.getToolSettings toolName = some settings)
    (hWild : Pattern.wildcard ∈ settings.deniedPaths) :
    ∃ reasons, evalPerm agent toolName arg = .Deny reasons := by
  convert deny_takes_priority agent toolName arg settings hSettings _;
  exact List.length_pos_iff.mpr ( by unfold deniedMatches; aesop )

/-
**Untrust shrinks allowlist**: After untrusting a tool that was the only
    match, and with no per-tool settings, the result becomes `Ask`.
-/
theorem untrust_revokes
    (agent : Agent) (toolName arg : String) (p : Pattern)
    (hOnly : agent.allowedTools = [p])
    (_hMatch : p.matches toolName = true)
    (hNoSettings : agent.getToolSettings toolName = none) :
    evalPerm (agent.untrustTools [p]) toolName arg = .Ask := by
  unfold Agent.untrustTools evalPerm;
  simp_all +decide [ Agent.isInAllowlist, Agent.getToolSettings ];
  rw [ List.find?_eq_none.mpr ];
  · rfl;
  · grind

/-
**Evaluation trichotomy**: The result is exactly one of Allow, Ask, or Deny.
-/
theorem eval_trichotomy (agent : Agent) (toolName arg : String) :
    (evalPerm agent toolName arg = .Allow) ∨
    (evalPerm agent toolName arg = .Ask) ∨
    (∃ reasons, evalPerm agent toolName arg = .Deny reasons) := by
  unfold evalPerm; aesop;