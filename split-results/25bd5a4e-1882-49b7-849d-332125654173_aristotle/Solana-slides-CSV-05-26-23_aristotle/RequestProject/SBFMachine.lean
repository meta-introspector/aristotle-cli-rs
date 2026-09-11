import Mathlib

/-!
# A Lean 4 model of the eBPF/SBF virtual machine

This file imports into Lean 4 the concrete machine model described in the slide deck
*"Verification of Solana Programs"* (J. A. Navas and A. Gurfinkel, CSV, Venice, 2023).

The deck describes the eBPF/SBF (Solana Bytecode Format) virtual machine used to run
Solana programs.  Two concrete pieces of structure are specified on the
"eBPF/SBF Virtual Machine" slides:

* a **register file** with eleven general-purpose 64-bit registers `r0, …, r10`, where
  - `r0` holds the return value,
  - `r1, …, r5` are caller-saved (volatile),
  - `r6, …, r9` are callee-saved (non-volatile),
  - `r10` is a read-only frame pointer used to access the stack;
* a **memory layout** consisting of four disjoint, byte-addressable regions, each
  occupying one `2^32`-byte (4 GiB) segment of the 64-bit address space at a fixed base:
  - `Text`   (code + rodata)            at `0x100000000`,
  - `Stack`                             at `0x200000000`,
  - `Heap`                              at `0x300000000`,
  - `Input`  (deserialized blockchain state) at `0x400000000`.

We formalize this layout and prove its basic well-formedness properties: the four
regions are pairwise disjoint, and every address belonging to some region belongs to a
unique one (the classification function is correct).
-/

namespace SBF

/-! ## Registers -/

/-- The eleven general-purpose 64-bit registers `r0, …, r10` of the SBF VM. -/
abbrev Reg := Fin 11

namespace Reg

/-- `r0`: holds the return value of a call. -/
def r0 : Reg := 0
/-- `r10`: the read-only frame pointer used to access the stack. -/
def r10 : Reg := 10

/-- A register is *caller-saved* (volatile) iff it is one of `r1, …, r5`. -/
def CallerSaved (r : Reg) : Prop := 1 ≤ r.val ∧ r.val ≤ 5
/-- A register is *callee-saved* (non-volatile) iff it is one of `r6, …, r9`. -/
def CalleeSaved (r : Reg) : Prop := 6 ≤ r.val ∧ r.val ≤ 9

instance (r : Reg) : Decidable (CallerSaved r) := by unfold CallerSaved; infer_instance
instance (r : Reg) : Decidable (CalleeSaved r) := by unfold CalleeSaved; infer_instance

/-- No register is both caller-saved and callee-saved. -/
theorem callerSaved_not_calleeSaved (r : Reg) : ¬ (CallerSaved r ∧ CalleeSaved r) := by
  rintro ⟨⟨_, h1⟩, ⟨h2, _⟩⟩; omega

/-- The frame pointer `r10` is neither caller- nor callee-saved. -/
theorem r10_not_saved : ¬ CallerSaved r10 ∧ ¬ CalleeSaved r10 := by
  refine ⟨?_, ?_⟩ <;> decide

end Reg

/-! ## Memory layout -/

/-- The size of each memory region: one `2^32`-byte (4 GiB) segment of the address space. -/
def regionSize : ℕ := 2 ^ 32

/-- The four byte-addressable memory regions of the SBF VM. -/
inductive Region where
  | text   -- code + rodata,            base 0x100000000
  | stack  --                           base 0x200000000
  | heap   --                           base 0x300000000
  | input  -- deserialized blockchain state, base 0x400000000
  deriving DecidableEq, Repr

namespace Region

/-- The fixed base address of each region, as specified in the slides. -/
def base : Region → ℕ
  | text  => 0x100000000
  | stack => 0x200000000
  | heap  => 0x300000000
  | input => 0x400000000

/-- An address `a` lies in region `R` iff it is within `[base R, base R + regionSize)`. -/
def Contains (R : Region) (a : ℕ) : Prop := R.base ≤ a ∧ a < R.base + regionSize

instance (R : Region) (a : ℕ) : Decidable (R.Contains a) := by unfold Contains; infer_instance

/-- Classify an address into the region it belongs to, if any. -/
def classify (a : ℕ) : Option Region :=
  if text.Contains a then some text
  else if stack.Contains a then some stack
  else if heap.Contains a then some heap
  else if input.Contains a then some input
  else none

/-- The four regions are pairwise disjoint: no address lies in two distinct regions. -/
theorem disjoint {R S : Region} {a : ℕ} (hR : R.Contains a) (hS : S.Contains a) : R = S := by
  cases R <;> cases S <;>
    first
      | rfl
      | (exfalso
         simp only [Contains, base, regionSize] at hR hS
         omega)

/-- `classify` is sound: if it returns `some R` then `a` really lies in `R`. -/
theorem classify_sound {a : ℕ} {R : Region} (h : classify a = some R) : R.Contains a := by
  unfold classify at h
  split at h
  · simp_all
  · split at h
    · simp_all
    · split at h
      · simp_all
      · split at h
        · simp_all
        · simp at h

/-- `classify` is complete: if `a` lies in some region `R`, then `classify a = some R`. -/
theorem classify_complete {a : ℕ} {R : Region} (h : R.Contains a) : classify a = some R := by
  have huniq : ∀ S, S.Contains a → S = R := fun S hS => disjoint hS h
  unfold classify
  split
  · rename_i ht; rw [huniq text ht]
  · split
    · rename_i hs; rw [huniq stack hs]
    · split
      · rename_i hh; rw [huniq heap hh]
      · split
        · rename_i hi; rw [huniq input hi]
        · rename_i h1 h2 h3 h4
          cases R
          · exact absurd h h1
          · exact absurd h h2
          · exact absurd h h3
          · exact absurd h h4

/-- `classify` returns `none` exactly when the address lies in no region. -/
theorem classify_eq_none_iff {a : ℕ} :
    classify a = none ↔ ∀ R : Region, ¬ R.Contains a := by
  constructor
  · intro h R hR
    simp [classify_complete hR] at h
  · intro h
    unfold classify
    rw [if_neg (h text), if_neg (h stack), if_neg (h heap), if_neg (h input)]

end Region

end SBF
