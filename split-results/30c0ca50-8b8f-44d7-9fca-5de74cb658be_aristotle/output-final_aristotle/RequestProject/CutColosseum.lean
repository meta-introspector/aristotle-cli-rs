import RequestProject.GodelBrainrot
import RequestProject.ProofTheory.CutElimination

/-!
# The Cut Colosseum — reflecting the proof engine into the game

This module wires the now fully-proved cut-elimination engine
(`RequestProject.ProofTheory.*`, with `cut_admissible` / `cut_elimination` no
longer `sorry`) into the Gödel-Brainrot game, realizing the requested features:

1. **A cut predicate, cutting the weakest brainrot every `N` rounds.**
   `cutWeakest` removes a minimal-code brainrot from the arena; iterating it
   (`simulateCuts`) models "cut every `N` rounds". We prove the arena's total
   power is monotonically non-increasing under cutting and that the roster
   strictly shrinks — exactly the *Subformula Property* intuition of Gentzen's
   Hauptsatz lifted into the game: cutting removes detours/weaklings.

2. **Lifting the proof via reflection + simulating proof search.**
   A game *position* (attacker hand ⊢ defender hand) reflects to a `Sequent`;
   `proofSearch` is literally `LKCutFree.complete` — given a winning (valid)
   position it *constructs* a cut-free proof. `game_cut_eliminates` is exactly
   `cut_admissible`: a middle-man "bridge" brainrot is cut out, yielding a
   direct cut-free proof.

3. **The engine as a (term / global env) like MetaCoq, and (cons head tail)
   like Lisp.** `Sexpr` is the Lisp `cons`/`atom` representation of a brainrot;
   `GlobalEnv` is a MetaCoq-style list of named declarations, and every declared
   brainrot is internally consistent (proves its own identity, cut-free).

Everything here is fully proved (no `sorry`).
-/

namespace GodelBrainrot.CutColosseum

open PropForm

/-! ## 1. Lisp-style `cons`/`atom` reflection of brainrot -/

/-- A Lisp S-expression: either an `atom` (a meme token) or a `cons` cell. -/
inductive Sexpr where
  | atom : String → Sexpr
  | cons : Sexpr → Sexpr → Sexpr
deriving Repr, DecidableEq

/-- The empty list marker `nil`. -/
def Sexpr.nil : Sexpr := .atom "nil"

/-- Reflect a brainrot into a right-nested list of `cons` cells (Lisp style). -/
def brainrotToSexpr (b : Brainrot) : Sexpr :=
  b.tokens.foldr (fun t acc => .cons (.atom t) acc) Sexpr.nil

/-- Read the tokens back out of an S-expression list. -/
def Sexpr.toTokens : Sexpr → List String
  | .atom _ => []
  | .cons h t => (match h with | .atom s => [s] | .cons _ _ => []) ++ t.toTokens

/-
Round-trip: reflecting a brainrot to Lisp and back recovers its tokens.
-/
theorem brainrotToSexpr_toTokens (b : Brainrot) : (brainrotToSexpr b).toTokens = b.tokens := by
  unfold brainrotToSexpr;
  induction b.tokens <;> simp +decide [ *, Sexpr.toTokens ]

/-
The Lisp encoding has one `cons` cell per token.
-/
theorem brainrotToSexpr_length (b : Brainrot) :
    (brainrotToSexpr b).toTokens.length = b.tokens.length := by
  grind +suggestions

/-! ## 2. The cut predicate: cut the weakest brainrot every `N` rounds -/

/-- The "power" / Gödel code of a brainrot. -/
def brainrotCode (b : Brainrot) : Nat := encodeBrainrot b

/-- Total power of an arena (a list of brainrot). -/
def totalCode (bs : List Brainrot) : Nat := (bs.map brainrotCode).sum

/-- **The cut step.** Remove one minimal-code ("weakest") brainrot from the arena.
This is the game's reflection of the cut rule: a low-value detour is cut out. -/
def cutWeakest (bs : List Brainrot) : List Brainrot :=
  match bs.argmin brainrotCode with
  | none => bs
  | some b => bs.erase b

/-- **Cut every `N` rounds.** Applying the cut step `k` times (one per `N`-round
period). -/
def simulateCuts : Nat → List Brainrot → List Brainrot
  | 0, bs => bs
  | k + 1, bs => simulateCuts k (cutWeakest bs)

/-
Cutting never increases the arena's total power.
-/
theorem cutWeakest_totalCode_le (bs : List Brainrot) :
    totalCode (cutWeakest bs) ≤ totalCode bs := by
  unfold totalCode cutWeakest;
  cases h : List.argmin brainrotCode bs <;> simp_all +decide [ List.map_erase ];
  have h_sublist : List.Sublist (bs.erase ‹_›) bs := by
    exact?;
  exact h_sublist.map _ |> List.Sublist.sum_le_sum <| by simp +decide ;

/-
Cutting a non-empty arena strictly shrinks the roster.
-/
theorem cutWeakest_length_lt (bs : List Brainrot) (h : bs ≠ []) :
    (cutWeakest bs).length < bs.length := by
  obtain ⟨b, hb⟩ : ∃ b, bs.argmin brainrotCode = some b ∧ b ∈ bs := by
    have h_argmin : ∃ b, bs.argmin brainrotCode = some b := by
      cases h' : List.argmin brainrotCode bs <;> aesop;
    exact ⟨ _, h_argmin.choose_spec, List.argmin_mem h_argmin.choose_spec ⟩;
  unfold cutWeakest;
  grind

/-
The brainrot cut out is genuinely a *weakest* one: its code is ≤ every code
in the arena.
-/
theorem cutWeakest_is_minimal (bs : List Brainrot) (b : Brainrot)
    (h : bs.argmin brainrotCode = some b) :
    ∀ c ∈ bs, brainrotCode b ≤ brainrotCode c := by
  rw [ List.argmin_eq_some_iff ] at h ; aesop

/-
Iterated cutting is also monotone: total power never increases over rounds.
-/
theorem simulateCuts_totalCode_le (k : Nat) (bs : List Brainrot) :
    totalCode (simulateCuts k bs) ≤ totalCode bs := by
  induction' k with k ih generalizing bs <;> simp_all +decide [ simulateCuts ];
  exact le_trans ( ih _ ) ( cutWeakest_totalCode_le _ )

/-! ## 3. Reflection of positions and proof search -/

/-- Reflect a brainrot as a propositional formula: the conjunction of its token
variables (the empty brainrot reflects to `⊤`). -/
def brainrotToFormula (b : Brainrot) : PropForm String :=
  b.tokens.foldr (fun t acc => PropForm.conj (PropForm.var t) acc) PropForm.verum

/-- A game *position*: the attacker's hand (antecedent) versus the defender's hand
(succedent), reflected as a sequent. -/
def reflectPosition (attacker defender : List Brainrot) : Sequent String :=
  ⟨attacker.map brainrotToFormula, defender.map brainrotToFormula⟩

/-- **Proof search lifted into the game.** A *winning* (semantically valid)
position is decoded into an actual cut-free derivation. This is literally
completeness of cut-free LK. -/
def proofSearch (s : Sequent String) (h : s.IsValid) : LKCutFree s :=
  LKCutFree.complete s h

/-- Every brainrot can defend itself: its reflected formula proves its own
identity, cut-free. -/
theorem brainrot_self_identity (b : Brainrot) :
    LKCutFree ⟨[brainrotToFormula b], [brainrotToFormula b]⟩ :=
  LKCutFree.ax _

/-- **The cut mechanic is cut elimination.** A "bridge" brainrot `C` that links
two positions is cut out, producing a single cut-free proof of the combined
position. This is exactly `cut_admissible`. -/
theorem game_cut_eliminates {Γ Δ Γ' Δ' : List (PropForm String)} (C : PropForm String)
    (left : LKCutFree ⟨Γ, C :: Δ⟩) (right : LKCutFree ⟨C :: Γ', Δ'⟩) :
    LKCutFree ⟨Γ ++ Γ', Δ ++ Δ'⟩ :=
  cut_admissible C left right

/-
**Decoding a tautological brainrot.** If a brainrot's reflected formula is a
tautology, the engine's proof search always succeeds, returning a cut-free proof
of it from no hypotheses.
-/
theorem proofSearch_tautology (A : PropForm String) (h : IsTautology A) :
    LKCutFree ⟨[], [A]⟩ := by
  convert LKCutFree.complete _ _;
  exact fun v hv => ⟨ A, by simp +decide, h v ⟩

/-! ## 4. The proof engine as a MetaCoq-style term / global environment -/

/-- A single declaration in the global environment: a named brainrot statement. -/
structure Decl where
  declName : String
  statement : PropForm String

/-- A MetaCoq-style global environment: a list of named declarations. -/
abbrev GlobalEnv := List Decl

/-- Look up a declaration's statement by name. -/
def GlobalEnv.lookup (e : GlobalEnv) (n : String) : Option (PropForm String) :=
  (e.find? (fun d => decide (d.declName = n))).map Decl.statement

/-- A global environment is *well-formed* when every declared statement is
internally consistent: it has a cut-free identity proof. -/
def GlobalEnv.WellFormed (e : GlobalEnv) : Prop :=
  ∀ d ∈ e, LKCutFree ⟨[d.statement], [d.statement]⟩

/-- Build the global environment reflecting a roster of brainrot. -/
def reflectEnv (bs : List Brainrot) : GlobalEnv :=
  bs.map (fun b => ⟨String.intercalate "_" b.tokens, brainrotToFormula b⟩)

/-
**Every reflected global environment is well-formed.** The whole brainrot
engine is a self-consistent MetaCoq-style term/global-env: each declared brainrot
proves its own identity, cut-free.
-/
theorem reflectEnv_wellFormed (bs : List Brainrot) : (reflectEnv bs).WellFormed := by
  intro d hd
  obtain ⟨b, hb⟩ : ∃ b ∈ bs, d.statement = brainrotToFormula b := by
    unfold reflectEnv at hd; aesop;
  exact hb.2 ▸ brainrot_self_identity b

end GodelBrainrot.CutColosseum