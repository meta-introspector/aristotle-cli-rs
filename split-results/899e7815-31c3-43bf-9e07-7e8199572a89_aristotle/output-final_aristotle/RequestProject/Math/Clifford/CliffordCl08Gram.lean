/-
# CliffordCl08Gram — Full Gram Orthogonality for Cl(0,8)

Assembles the 8 block-level Gram checks into the full orthogonality theorem.
-/

import RequestProject.Math.Clifford.CliffordCl08SPerm
import RequestProject.Math.Clifford.CliffordCl08Gram0
import RequestProject.Math.Clifford.CliffordCl08Gram1
import RequestProject.Math.Clifford.CliffordCl08Gram2
import RequestProject.Math.Clifford.CliffordCl08Gram3
import RequestProject.Math.Clifford.CliffordCl08Gram4
import RequestProject.Math.Clifford.CliffordCl08Gram5
import RequestProject.Math.Clifford.CliffordCl08Gram6
import RequestProject.Math.Clifford.CliffordCl08Gram7

set_option maxHeartbeats 1600000

/-! ## Helper: Bool gramBlock → Prop -/

/-- gramBlock start count encodes that for all rows in [start, start+count) and all columns
    in [0, 256), the trace inner product equals 16 on the diagonal and 0 off-diagonal. -/
theorem gramBlock_spec {start count : Nat} (h : gramBlock start count = true)
    (i j : Nat) (hi : start ≤ i) (hi' : i < start + count) (hj : j < 256) :
    traceProd (monomialN i) (monomialN j) = if i == j then 16 else 0 := by
  have hdi : i - start < count := by omega
  have : start + (i - start) = i := by omega
  unfold gramBlock at h
  have h1 : (List.range count).all (fun di =>
    (List.range 256).all fun j =>
      let mi := monomialN (start + di)
      let mj := monomialN j
      let tr := traceProd mi mj
      if start + di == j then tr == 16 else tr == 0) = true := h
  rw [List.all_eq_true] at h1
  have h2 := h1 (i - start) (List.mem_range.mpr hdi)
  rw [List.all_eq_true] at h2
  have h3 := h2 j (List.mem_range.mpr hj)
  rw [this] at h3
  split_ifs at h3 ⊢ with heq1 heq2 <;> simp_all [BEq.beq, beq_iff_eq]

/-
The 256 gamma monomial matrices satisfy trace(M_i^T · M_j) = 16·δ_{i,j}.
-/
theorem gram_orthogonality (i j : Fin 256) :
    traceProd (monomialN i.val) (monomialN j.val) =
      if i.val == j.val then 16 else 0 := by
  obtain ⟨start, count, h_block⟩ : ∃ start count : Nat, start ≤ i.val ∧ i.val < start + count ∧ count = 32 ∧ gramBlock start count = true := by
    grind +suggestions;
  exact gramBlock_spec h_block.2.2.2 _ _ h_block.1 h_block.2.1 ( by linarith [ Fin.is_lt j ] )