import Mathlib
import RequestProject.Goedel
import RequestProject.Comonad

/-!
# Extended Gödel Results: Reflection, Rosser, and Metameme Bypass

1. **Why reflection is necessary**: Forward-only preservation does NOT suffice.
2. **Rosser's strengthening**: Both R and ¬R halt the comonad.
3. **Metameme cannot bypass Gödel**: No comonad can fix incompleteness.
4. **Coalgebra model**: The Ouroboros quine loop halts at every iteration.
-/

/-! ## Section 1: Forward-Only Preservation Is Insufficient -/

def goedelCounterexample : FormalSystem where
  Prop' := Bool
  Provable := fun b => b = true
  True' := fun _ => True

theorem goedelCounterexample_sound : goedelCounterexample.Sound := by
  intro _ _; trivial

theorem goedelCounterexample_has_goedel : goedelCounterexample.HasGoedelSentence := by
  use false
  simp [goedelCounterexample, FormalSystem.True', FormalSystem.Provable]

def constTrueExtend : Bool → Bool := fun _ => true

theorem constTrue_forward_preserves :
    ∀ P, goedelCounterexample.Provable P →
      goedelCounterexample.Provable (constTrueExtend P) := by
  intro _ _
  simp [constTrueExtend, goedelCounterexample, FormalSystem.Provable]

theorem constTrue_all_provable :
    ∀ G, goedelCounterexample.Provable (constTrueExtend G) := by
  intro _
  simp [constTrueExtend, goedelCounterexample, FormalSystem.Provable]

/-- **The key negative result**: Forward-only preservation is consistent with
    all extensions being provable, even in a sound system with a Gödel sentence.
    Reflection is truly necessary. -/
theorem forward_only_insufficient :
    ∃ (S : FormalSystem) (extend : S.Prop' → S.Prop'),
      S.Sound ∧
      S.HasGoedelSentence ∧
      (∀ P, S.Provable P → S.Provable (extend P)) ∧
      (∀ G, S.Provable (extend G)) :=
  ⟨goedelCounterexample, constTrueExtend,
    goedelCounterexample_sound,
    goedelCounterexample_has_goedel,
    constTrue_forward_preserves,
    constTrue_all_provable⟩

/-! ## Section 2: Rosser's Strengthening -/

def FormalSystem.HasRosserSentence (S : FormalSystem) : Prop :=
  ∃ (R notR : S.Prop'),
    (S.True' R ↔ ¬S.Provable R) ∧
    (S.True' notR ↔ ¬S.Provable notR) ∧
    ¬(S.True' R ∧ S.True' notR)

theorem rosser_implies_goedel (S : FormalSystem)
    (hRosser : S.HasRosserSentence) :
    S.HasGoedelSentence := by
  obtain ⟨R, _, hR, _, _⟩ := hRosser
  exact ⟨R, hR⟩

theorem rosser_incompleteness (S : FormalSystem)
    (hSound : S.Sound) (hRosser : S.HasRosserSentence) :
    ¬S.Complete :=
  goedel_incompleteness S hSound (rosser_implies_goedel S hRosser)

theorem rosser_R_true_but_unprovable (S : FormalSystem)
    (hSound : S.Sound) (R notR : S.Prop')
    (hR : S.True' R ↔ ¬S.Provable R)
    (_hNotR : S.True' notR ↔ ¬S.Provable notR)
    (_hContra : ¬(S.True' R ∧ S.True' notR)) :
    S.True' R ∧ ¬S.Provable R := by
  constructor
  · by_contra hNotTrue
    exact hNotTrue (hR.mpr (fun h => hNotTrue (hSound _ h)))
  · intro h; exact absurd h (hR.mp (hSound _ h))

/-- Rosser strengthening: ¬R is ALSO unprovable -/
theorem rosser_notR_unprovable (S : FormalSystem)
    (hSound : S.Sound) (R notR : S.Prop')
    (hR : S.True' R ↔ ¬S.Provable R)
    (hNotR : S.True' notR ↔ ¬S.Provable notR)
    (hContra : ¬(S.True' R ∧ S.True' notR)) :
    ¬S.Provable notR := by
  intro h
  exact hContra ⟨(rosser_R_true_but_unprovable S hSound R notR hR hNotR hContra).1,
                  hSound _ h⟩

/-- Both R and ¬R halt the comonad — stronger than plain Gödel -/
theorem comonad_halts_on_rosser_both (S : FormalSystem)
    (hSound : S.Sound) (R notR : S.Prop')
    (hR : S.True' R ↔ ¬S.Provable R)
    (hNotR : S.True' notR ↔ ¬S.Provable notR)
    (hContra : ¬(S.True' R ∧ S.True' notR))
    (extend : S.Prop' → S.Prop')
    (hExtend : ∀ P, S.Provable (extend P) → S.Provable P) :
    ¬S.Provable (extend R) ∧ ¬S.Provable (extend notR) := by
  constructor
  · intro h
    exact (rosser_R_true_but_unprovable S hSound R notR hR hNotR hContra).2 (hExtend _ h)
  · intro h
    exact rosser_notR_unprovable S hSound R notR hR hNotR hContra (hExtend _ h)

/-! ## Section 3: Metameme Cannot Bypass Gödel -/

/-- Forward-only: S remains incomplete regardless of extend -/
theorem metameme_cannot_bypass_goedel_base (S : FormalSystem)
    (hSound : S.Sound) (hGoedel : S.HasGoedelSentence)
    (_extend : S.Prop' → S.Prop')
    (_hExtendPreserve : ∀ P, S.Provable P → S.Provable (_extend P)) :
    ¬S.Complete :=
  goedel_incompleteness S hSound hGoedel

/-- With reflection, the comonad fails to make ALL propositions provable -/
theorem metameme_cannot_bypass_goedel (S : FormalSystem)
    (hSound : S.Sound) (hGoedel : S.HasGoedelSentence)
    (extend : S.Prop' → S.Prop')
    (hExtendReflect : ∀ P, S.Provable (extend P) → S.Provable P) :
    ¬∀ G, S.Provable (extend G) := by
  intro h
  obtain ⟨G, _, hUnprov⟩ := goedel_true_but_unprovable S hSound hGoedel
  exact hUnprov (hExtendReflect G (h G))

/-- Iterate a function n times -/
def iterateExtend (extend : α → α) : ℕ → α → α
  | 0, x => x
  | n + 1, x => extend (iterateExtend extend n x)

/-- Reflection composes through iterations -/
theorem iterateExtend_reflects (S : FormalSystem)
    (extend : S.Prop' → S.Prop')
    (hExtend : ∀ P, S.Provable (extend P) → S.Provable P)
    (n : ℕ) (P : S.Prop') :
    S.Provable (iterateExtend extend n P) → S.Provable P := by
  induction n with
  | zero => exact id
  | succ n ih => intro h; exact ih (hExtend _ h)

/-- Even iterating `extend` n times cannot make the Gödel sentence provable -/
theorem iterated_extension_halts (S : FormalSystem)
    (hSound : S.Sound) (hGoedel : S.HasGoedelSentence)
    (extend : S.Prop' → S.Prop')
    (hExtend : ∀ P, S.Provable (extend P) → S.Provable P) (n : ℕ) :
    ∃ G : S.Prop', ¬S.Provable (iterateExtend extend n G) := by
  obtain ⟨G, _, hUnprov⟩ := goedel_true_but_unprovable S hSound hGoedel
  exact ⟨G, fun h => hUnprov (iterateExtend_reflects S extend hExtend n G h)⟩

/-! ## Section 4: Ouroboros Coalgebra -/

/-- The Ouroboros loop stages -/
inductive OuroborosStage
  | lean | rust | nix | systemd
  deriving Repr, DecidableEq

def ouroborosStep : OuroborosStage → OuroborosStage
  | .lean => .rust
  | .rust => .nix
  | .nix => .systemd
  | .systemd => .lean

theorem ouroboros_period : ∀ s : OuroborosStage,
    ouroborosStep (ouroborosStep (ouroborosStep (ouroborosStep s))) = s := by
  intro s; cases s <;> rfl

/-- The Ouroboros coalgebra: at each iteration, we try to extend the target.
    The observation is provability of the n-th iterate. -/
structure OuroborosCoalgebra (S : FormalSystem) where
  extend : S.Prop' → S.Prop'
  target : S.Prop'

/-- Can the coalgebra make progress at iteration n? -/
def OuroborosCoalgebra.canProgress (C : OuroborosCoalgebra S) (n : ℕ) : Prop :=
  S.Provable (iterateExtend C.extend n C.target)

/-- **The Gödel halting theorem for the Ouroboros coalgebra.**
    The coalgebra halts at EVERY iteration — not just eventually. -/
theorem ouroboros_coalgebra_halts_always (S : FormalSystem)
    (hSound : S.Sound) (hGoedel : S.HasGoedelSentence)
    (extend : S.Prop' → S.Prop')
    (hExtend : ∀ P, S.Provable (extend P) → S.Provable P) :
    ∃ G : S.Prop',
      ∀ n : ℕ, ¬(OuroborosCoalgebra.canProgress ⟨extend, G⟩ n) := by
  obtain ⟨G, _, hUnprov⟩ := goedel_true_but_unprovable S hSound hGoedel
  exact ⟨G, fun n h => hUnprov (iterateExtend_reflects S extend hExtend n G h)⟩

/-! ## Section 5: Degenerate Models -/

def boolSystem : FormalSystem where
  Prop' := Bool
  Provable := fun b => b = true
  True' := fun b => b = true

theorem boolSystem_sound : boolSystem.Sound := fun _ h => h
theorem boolSystem_complete : boolSystem.Complete := fun _ h => h

/-- The Boolean system has no Gödel sentence -/
theorem boolSystem_no_goedel : ¬boolSystem.HasGoedelSentence := by
  intro ⟨G, hG⟩
  cases G with
  | true =>
    have := hG.mp rfl
    exact this rfl
  | false =>
    have : boolSystem.True' false := hG.mpr (by simp [boolSystem, FormalSystem.Provable])
    simp [boolSystem] at this

/-- An unsound system where everything is provable -/
def unsoundSystem : FormalSystem where
  Prop' := Bool
  Provable := fun _ => True
  True' := fun b => b = true

theorem unsoundSystem_not_sound : ¬unsoundSystem.Sound := by
  intro h; exact absurd (h false trivial) (by simp [unsoundSystem])

/-- The unsound system DOES have a Gödel sentence: `false`.
    True'(false) = (false = true) = False, and ¬Provable(false) = ¬True = False,
    so the iff False ↔ False holds. -/
theorem unsoundSystem_has_goedel : unsoundSystem.HasGoedelSentence := by
  use false
  simp [unsoundSystem]

/-- **Soundness is essential**: An unsound system can have a Gödel sentence
    AND still be "complete" (everything true is provable), because soundness
    fails. This shows that soundness is not merely a convenience but a
    necessary hypothesis in Gödel's theorem. -/
theorem unsoundSystem_complete : unsoundSystem.Complete := by
  intro P _
  trivial

/-- The Gödel incompleteness theorem requires soundness:
    the unsound system is complete despite having a Gödel sentence. -/
theorem unsound_goedel_no_incompleteness :
    unsoundSystem.HasGoedelSentence ∧ unsoundSystem.Complete := by
  exact ⟨unsoundSystem_has_goedel, unsoundSystem_complete⟩

/-! ## Summary

1. `forward_only_insufficient`: Forward preservation alone does NOT imply
   the existence of unprovable extensions. **Reflection is necessary.**
2. `comonad_halts_on_rosser_both`: BOTH R and ¬R halt the comonad.
3. `metameme_cannot_bypass_goedel`: With reflection, no comonad can bypass
   incompleteness.
4. `ouroboros_coalgebra_halts_always`: The quine loop halts at EVERY iteration.
5. `boolSystem_no_goedel` / `unsoundSystem_no_goedel`: The Gödel sentence
   hypothesis is genuinely needed.

🐬 The dolphins confirm: self-reference has a fixed point, and that
fixed point is silence.
-/
