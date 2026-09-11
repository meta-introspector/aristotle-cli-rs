import Mathlib

/-!
# A self-replicator on a fixed instruction set

The semantics of `web/js/replicator.js`, which is what the `replicate`
statement of a playbook means.

The physics is fixed and tiny: a tape of numbers, a read head, a write head,
and one instruction — *copy the symbol under the read head to the write head
and advance both* — repeated while there is anything left to copy.  Nothing
about any particular organism is built into it.

An **organism** is a segment of the tape whose first cell says how long it is.
The machine reads that cell, so how much gets copied is decided by the
organism, not by the physics: `seed t a` is the machine that starts on the
organism at `a` and lays its child down immediately after it.

What is proved here:

* `copy_lt` — the child is an exact copy of the parent, cell for cell;
* `untouched` — nothing outside the child's span is disturbed, so the parent
  survives its own replication;
* `run_left`, `halts` — the machine stops exactly when the copy is finished,
  and a stopped machine is a fixed point (`step_halted`);
* `child_length`, `child_is_organism` — the child's first cell holds the same
  length, so the child is an organism of the same size: replication is
  *closed*, and the offspring can replicate in turn (`offspring_replicates`);
* `gen_copies` — a colony: after `g` generations there are `g + 1` copies of
  the original organism, side by side, all identical to it.

The tape is a function `ℕ → ℕ` rather than a list: an organism should not be
able to fall off the end of the world, and the statements are then about
positions rather than about indices into a container.
-/

namespace Hesper.Replicator

/-- The world: a cell at every position, holding a number. -/
abbrev Tape := ℕ → ℕ

/-- The whole machine: a tape, where it reads, where it writes, how much is
left to copy.  There is no program counter because there is one instruction. -/
structure Machine where
  tape : Tape
  src : ℕ
  dst : ℕ
  left : ℕ

/-- The single instruction: copy one cell and advance, unless finished. -/
def step (m : Machine) : Machine :=
  match m.left with
  | 0 => m
  | Nat.succ k =>
      { tape := Function.update m.tape m.dst (m.tape m.src)
        src := m.src + 1
        dst := m.dst + 1
        left := k }

/-- `n` instructions. -/
def run (m : Machine) : ℕ → Machine
  | 0 => m
  | n + 1 => run (step m) n

@[simp] theorem run_zero (m : Machine) : run m 0 = m := rfl

@[simp] theorem run_succ (m : Machine) (n : ℕ) : run m (n + 1) = run (step m) n := rfl

/-- A machine with nothing left to copy has stopped for good. -/
@[simp] theorem step_halted {m : Machine} (h : m.left = 0) : step m = m := by
  unfold step
  rw [h]

theorem run_halted {m : Machine} (h : m.left = 0) (n : ℕ) : run m n = m := by
  induction n with
  | zero => rfl
  | succ n ih => rw [run_succ, step_halted h, ih]

@[simp] theorem step_left (m : Machine) : (step m).left = m.left - 1 := by
  unfold step
  cases hm : m.left with
  | zero => simp [hm]
  | succ k => simp

/-- The work remaining counts down, and stops at zero. -/
theorem run_left (m : Machine) (n : ℕ) : (run m n).left = m.left - n := by
  induction n generalizing m with
  | zero => simp
  | succ n ih => rw [run_succ, ih, step_left, Nat.sub_sub, Nat.add_comm]

/-- Running for exactly as long as there is work to do finishes the copy. -/
theorem halts (m : Machine) : (run m m.left).left = 0 := by
  rw [run_left, Nat.sub_self]

section Copy

variable (t : Tape) (a b L : ℕ)

/--
Nothing outside the child's span `[b, b + L)` is touched: in particular the
parent, which lies below `b`, survives its own replication unchanged.
-/
theorem untouched :
    ∀ (L : ℕ) (t : Tape) (a b j : ℕ), (j < b ∨ b + L ≤ j) →
      (run ⟨t, a, b, L⟩ L).tape j = t j := by
  intro L
  induction L with
  | zero => intro t a b j _; rfl
  | succ L ih =>
      intro t a b j hj
      have hstep : step (⟨t, a, b, L + 1⟩ : Machine)
          = ⟨Function.update t b (t a), a + 1, b + 1, L⟩ := rfl
      have hne : j ≠ b := by
        rcases hj with h | h
        · exact Nat.ne_of_lt h
        · exact fun he => absurd (he ▸ h) (by omega)
      have hj' : j < b + 1 ∨ (b + 1) + L ≤ j := by
        rcases hj with h | h
        · exact Or.inl (by omega)
        · exact Or.inr (by omega)
      rw [run_succ, hstep, ih (Function.update t b (t a)) (a + 1) (b + 1) j hj',
        Function.update_of_ne hne]

/--
The child is an exact copy of the parent: cell `b + i` of the finished tape is
cell `a + i` of the one the machine started with, for every `i < L`.  The
hypothesis is only that the child does not overlap the parent.
-/
theorem copy_lt :
    ∀ (L : ℕ) (t : Tape) (a b : ℕ), a + L ≤ b →
      ∀ i < L, (run ⟨t, a, b, L⟩ L).tape (b + i) = t (a + i) := by
  intro L
  induction L with
  | zero => intro t a b _ i hi; exact absurd hi (Nat.not_lt_zero i)
  | succ L ih =>
      intro t a b hab i hi
      have hstep : step (⟨t, a, b, L + 1⟩ : Machine)
          = ⟨Function.update t b (t a), a + 1, b + 1, L⟩ := rfl
      have hab' : (a + 1) + L ≤ b + 1 := by omega
      cases i with
      | zero =>
          have hb : b < b + 1 := by omega
          simp only [Nat.add_zero]
          rw [run_succ, hstep,
            untouched L (Function.update t b (t a)) (a + 1) (b + 1) b (Or.inl hb),
            Function.update_self]
      | succ i =>
          have hi' : i < L := by omega
          have hne : a + 1 + i ≠ b := by omega
          have hb : b + (i + 1) = (b + 1) + i := by omega
          have ha : a + (i + 1) = (a + 1) + i := by omega
          rw [hb, ha, run_succ, hstep,
            ih (Function.update t b (t a)) (a + 1) (b + 1) hab' i hi',
            Function.update_of_ne hne]

end Copy

/-- The machine an organism at `a` starts: it reads its own length out of its
first cell, and lays the child down immediately after itself. -/
def seed (t : Tape) (a : ℕ) : Machine := ⟨t, a, a + t a, t a⟩

/-- The tape after the organism at `a` has replicated once. -/
def offspring (t : Tape) (a : ℕ) : Tape := (run (seed t a) (t a)).tape

/-- Replication copies the organism, cell for cell. -/
theorem offspring_copies (t : Tape) (a : ℕ) :
    ∀ i < t a, offspring t a (a + t a + i) = t (a + i) :=
  fun i hi => copy_lt (t a) t a (a + t a) (Nat.le_refl _) i hi

/-- The parent is still there afterwards. -/
theorem parent_survives (t : Tape) (a : ℕ) :
    ∀ j < a + t a, offspring t a j = t j :=
  fun j hj => untouched (t a) t a (a + t a) j (Or.inl hj)

/-- The child's first cell holds the same length as the parent's. -/
theorem child_length (t : Tape) (a : ℕ) (h : 0 < t a) :
    offspring t a (a + t a) = t a := by
  have := offspring_copies t a 0 h
  simpa using this

/-- So the child is an organism of the same length, and the machine it seeds
is the same machine one span further along: replication is closed. -/
theorem child_is_organism (t : Tape) (a : ℕ) (h : 0 < t a) :
    (seed (offspring t a) (a + t a)).left = t a := by
  simpa [seed] using child_length t a h

/-- The offspring replicates in turn, and its child is again a copy of the
original organism. -/
theorem offspring_replicates (t : Tape) (a : ℕ) (h : 0 < t a) :
    ∀ i < t a,
      offspring (offspring t a) (a + t a) (a + t a + t a + i) = t (a + i) := by
  intro i hi
  have hlen : offspring t a (a + t a) = t a := child_length t a h
  have hstep := offspring_copies (offspring t a) (a + t a) i (by rw [hlen]; exact hi)
  rw [hlen] at hstep
  rw [hstep]
  exact offspring_copies t a i hi

/-- The colony: the tape after `g` generations, each organism copying itself
into the span after the last. -/
def gen (t : Tape) (a L : ℕ) : ℕ → Tape
  | 0 => t
  | g + 1 => (run ⟨gen t a L g, a + g * L, a + (g + 1) * L, L⟩ L).tape

/--
After `g` generations the tape carries `g + 1` copies of the original
organism, side by side, every one of them identical to it.
-/
theorem gen_copies (t : Tape) (a L : ℕ) :
    ∀ (g j : ℕ), j ≤ g → ∀ i < L, gen t a L g (a + j * L + i) = t (a + i) := by
  intro g
  induction g with
  | zero =>
      intro j hj i _
      have : j = 0 := Nat.le_zero.mp hj
      subst this
      simp [gen]
  | succ g ih =>
      intro j hj i hi
      have hle : a + g * L + L ≤ a + (g + 1) * L := by
        have : (g + 1) * L = g * L + L := by ring
        omega
      rcases Nat.lt_or_ge j (g + 1) with hlt | hge
      · -- an older copy: it lies below the span being written, so it is untouched
        have hj' : j ≤ g := Nat.lt_succ_iff.mp hlt
        have hbelow : a + j * L + i < a + (g + 1) * L := by
          have h1 : j * L + L ≤ (g + 1) * L := by
            have : (j + 1) * L ≤ (g + 1) * L := Nat.mul_le_mul_right L (by omega)
            calc j * L + L = (j + 1) * L := by ring
              _ ≤ (g + 1) * L := this
          omega
        have := untouched L (gen t a L g) (a + g * L) (a + (g + 1) * L)
          (a + j * L + i) (Or.inl hbelow)
        rw [gen, this]
        exact ih j hj' i hi
      · -- the newest copy: it is a copy of the one before it
        have hjg : j = g + 1 := Nat.le_antisymm hj hge
        subst hjg
        have := copy_lt L (gen t a L g) (a + g * L) (a + (g + 1) * L) hle i hi
        rw [gen, this]
        exact ih g (Nat.le_refl g) i hi

end Hesper.Replicator
