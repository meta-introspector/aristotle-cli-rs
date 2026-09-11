import RequestProject.GodelBrainrot
import RequestProject.ProofTheory.Formula
import RequestProject.ProofTheory.SequentCalculus
import RequestProject.ProofTheory.CutElimination

/-!
# Worked example: wiring the proof-theory engine into the Brainrot game

This module is the *integration example* requested by the user: it plugs the
self-contained proof-theory development under `RequestProject.ProofTheory.*`
(propositional formulas, the sequent calculus `LK`, cut-free `LKCutFree`, and the
consistency corollaries of Gentzen's Hauptsatz) directly into the
`GodelBrainrot` game world.

Narratively this is **Hilbert's program meeting Gödel** inside the Colosseum:

* Hilbert's dream — *"we must formalize all brainrot"* — is realized **per brainrot**:
  every brainrot phrase is turned into a propositional formula (`brainrotConj`),
  and `hilbert_formalizes_brainrot` shows the corresponding identity sequent is
  cut-free provable. So each individual brainrot *can* be formalized.

* Gödel's incompleteness still wins **globally**: the formal system stays
  consistent (`brainrot_logic_consistent`, ⊥ is unprovable) yet no finite vault
  can imprison every brainrot (`vault_always_incomplete`, re-exported here as
  `brainrot_vault_incomplete`).  The conjunction of the two is
  `hilbert_dream_vs_godel`.

Everything here is fully proved with no `sorry`. Gentzen's Hauptsatz core
`cut_admissible` (and hence `cut_elimination`) is now itself fully proved — via
the semantic route, i.e. completeness of cut-free LK (`LKCutFree.complete`) — so
the entire proof-theory stack is `sorry`-free.
-/

namespace GodelBrainrot.ProofTheoryExample

open PropForm

/-- Propositional variables are just meme-token strings. -/
abbrev MemeVar := String

/-- **Hilbert formalization of a brainrot.** Each token becomes a propositional
variable, and the whole brainrot becomes the conjunction of its tokens
(the empty brainrot becomes `⊤`). -/
def brainrotConj (b : Brainrot) : PropForm MemeVar :=
  b.tokens.foldr (fun t acc => conj (var t) acc) verum

/-- The formalized brainrot always evaluates to a tautology when implying itself:
`F → F` is true under every valuation. -/
theorem brainrotConj_self_imp_taut (b : Brainrot) :
    IsTautology (imp (brainrotConj b) (brainrotConj b)) := by
  intro v
  simp [eval]

/-- **Hilbert formalizes the brainrot.** The identity sequent `F ⊢ F` for the
formalized brainrot `F = brainrotConj b` is cut-free provable: every individual
brainrot can be put into the formal system. -/
theorem hilbert_formalizes_brainrot (b : Brainrot) :
    LKCutFree (V := MemeVar) ⟨[brainrotConj b], [brainrotConj b]⟩ :=
  LKCutFree.ax _

/-- The self-implication `F → F` of a formalized brainrot is provable from no
hypotheses (the cut-free system derives the brainrot tautology). -/
theorem hilbert_proves_brainrot_imp (b : Brainrot) :
    LKCutFree (V := MemeVar) ⟨[], [imp (brainrotConj b) (brainrotConj b)]⟩ :=
  (LKCutFree.ax _).impR

/-- **The brainrot logic is consistent**: falsum is not cut-free provable. -/
theorem brainrot_logic_consistent :
    ¬ LKCutFree (V := MemeVar) ⟨[], [falsum]⟩ :=
  consistent_of_cut_free

/-- Re-export of the game's incompleteness theorem in this example namespace:
no finite Cambridge vault can imprison all brainrot. -/
theorem brainrot_vault_incomplete (v : CambridgeVault) :
    ∃ b : Brainrot, encodeBrainrot b ∉ v.prisoners.map encodeBrainrot :=
  vault_always_incomplete v

/-- **Hilbert's dream vs. Gödel's incompleteness, in one statement.**
The formal brainrot system is consistent (Hilbert: ⊥ cannot be derived), and yet
for every vault there is a brainrot that escapes it (Gödel: the system can never
be complete). Both halves hold simultaneously. -/
theorem hilbert_dream_vs_godel (v : CambridgeVault) :
    (¬ LKCutFree (V := MemeVar) ⟨[], [falsum]⟩) ∧
      (∃ b : Brainrot, encodeBrainrot b ∉ v.prisoners.map encodeBrainrot) :=
  ⟨brainrot_logic_consistent, brainrot_vault_incomplete v⟩

/-- The "Incompleteness Shield" emote, as an actual provable tautology:
`⊤` is always derivable, so the shield is never down. -/
theorem incompleteness_shield_holds :
    LKCutFree (V := MemeVar) ⟨[], [verum]⟩ := by
  have h : LKCutFree (V := MemeVar) ⟨[falsum], [falsum]⟩ := LKCutFree.ax _
  -- verum = ¬⊥ = ⊥ → ⊥
  simpa [verum, neg] using h.impR

end GodelBrainrot.ProofTheoryExample
