import Mathlib
import RequestProject.Solfunmeme.Meme.Commit
import RequestProject.Solfunmeme.Meme.Proofs.Engine

/-!
# What a commitment to a tape is worth

`chain_append` is the unconditional part: a verifier can check a long game in
instalments, and a client can stream its commitment as it plays.

`chain_injective` is the conditional part.  Under the idealised assumption that
the compression function never collides and never lands back on the initial
value — the standard idealisation, and *not* something the concrete 64-bit
`Meme.Engine.mix` satisfies — the commitment determines the tape.  Combined with
`run_commit` and injectivity of input codes, that gives `tape_binding`: a player
who publishes a commitment cannot later exhibit a different play-through for it.
-/

namespace Meme.Commit

variable {H : Type}

@[simp] theorem chain_nil (f : H → Nat → H) (h0 : H) : chain f h0 [] = h0 := rfl

@[simp] theorem chain_cons (f : H → Nat → H) (h0 : H) (x : Nat) (xs : List Nat) :
    chain f h0 (x :: xs) = chain f (f h0 x) xs := rfl

/-- Commitments compose, so a long game can be verified incrementally. -/
theorem chain_append (f : H → Nat → H) (h0 : H) (xs ys : List Nat) :
    chain f h0 (xs ++ ys) = chain f (chain f h0 xs) ys := by
  simp [chain, List.foldl_append]

theorem chain_concat (f : H → Nat → H) (h0 : H) (xs : List Nat) (x : Nat) :
    chain f h0 (xs ++ [x]) = f (chain f h0 xs) x := by
  simp [chain_append]

/-- **Binding, relative to an ideal compression function.**  If `f` never
collides and never returns to the initial value, the chain determines the tape. -/
theorem chain_injective {f : H → Nat → H} {h0 : H}
    (hinj : ∀ h x h' x', f h x = f h' x' → h = h' ∧ x = x')
    (hfresh : ∀ h x, f h x ≠ h0) :
    Function.Injective (chain f h0) := by
  intro xs
  induction xs using List.reverseRecOn with
  | nil =>
      intro ys hys
      cases ys using List.reverseRecOn with
      | nil => rfl
      | append_singleton bs b =>
          exact absurd (by rw [chain_concat] at hys; exact hys.symm) (hfresh _ _)
  | append_singleton as a ih =>
      intro ys hys
      cases ys using List.reverseRecOn with
      | nil =>
          exact absurd (by rw [chain_concat] at hys; exact hys) (hfresh _ _)
      | append_singleton bs b =>
          rw [chain_concat, chain_concat] at hys
          obtain ⟨hc, hab⟩ := hinj _ _ _ _ hys
          rw [ih hc, hab]

end Meme.Commit

namespace Meme.Engine

/-- Every input advances the commitment, whether or not it could be paid for. -/
theorem step_commit (s : State) (i : Input) : (step s i).commit = mix s.commit i.code := by
  cases i <;> simp [step] <;> split <;> simp

/-- The state's rolling hash is the hash chain of the tape's codes. -/
theorem run_commit (s : State) (xs : List Input) :
    (run s xs).commit = Meme.Commit.chain mix s.commit (xs.map Input.code) := by
  induction xs generalizing s with
  | nil => simp
  | cons i t ih => simp [ih (step s i), step_commit]

/-! ### Checkpoints and selective disclosure -/

/-- A run's own play is always a valid segment of it: honest players can always
produce the checkpoint proof. -/
theorem segment_verify_run (s : State) (xs : List Input) :
    (Segment.mk s.commit xs (run s xs).commit).verify = true := by
  simp [Segment.verify, run_commit]

/-- Checkpoint proofs compose: two consecutive disclosed stretches make one. -/
theorem segment_compose {a b c : Nat} {xs ys : List Input}
    (h1 : (Segment.mk a xs b).verify = true) (h2 : (Segment.mk b ys c).verify = true) :
    (Segment.mk a (xs ++ ys) c).verify = true := by
  simp only [Segment.verify, beq_iff_eq] at h1 h2 ⊢
  rw [List.map_append, Meme.Commit.chain_append, h1, h2]

/-- A verified segment really is the hash of the play it discloses, so a
verifier who holds the checkpoint learns the new commitment without being shown
anything before the checkpoint. -/
theorem segment_verify_iff (sg : Segment) :
    sg.verify = true ↔ Meme.Commit.chain mix sg.before (sg.seg.map Input.code) = sg.after := by
  simp [Segment.verify]

/-- **Tape binding.**  Under the ideal-hash hypotheses, two play-throughs from
the same start with the same published commitment are the same play-through. -/
theorem tape_binding {b : Nat} {xs ys : List Input}
    (hinj : ∀ h x h' x', mix h x = mix h' x' → h = h' ∧ x = x')
    (hfresh : ∀ h x, mix h x ≠ 0)
    (h : (run (start b) xs).commit = (run (start b) ys).commit) :
    xs = ys := by
  rw [run_commit, run_commit] at h
  have hstart : (start b).commit = 0 := rfl
  rw [hstart] at h
  have := Meme.Commit.chain_injective hinj hfresh h
  exact List.map_injective_iff.mpr code_injective this

end Meme.Engine
