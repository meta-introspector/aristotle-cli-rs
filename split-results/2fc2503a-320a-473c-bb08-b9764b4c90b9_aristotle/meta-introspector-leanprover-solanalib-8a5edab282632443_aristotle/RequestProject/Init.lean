/-
Copyright (c) 2026 Solana Foundation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Solanalib Contributors
-/
import Mathlib.Tactic.Linter.Style
import Mathlib.Tactic.Linter.Header

/-!
# Solanalib.Init

Single upstream module activated by every Solanalib source file (via the
import chain rooted at `Solanalib.Primitives.Lamports`). Brings Mathlib's
linter implementations into scope so the `weak.linter.style.*` options
declared in `lakefile.lean` can actually fire.

Keep this file imports-only — no declarations.
-/
