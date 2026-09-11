/-
# CliffordCl09Gram — Full Gram Orthogonality for Cl(0,9)

Assembles the 32 block-level Gram checks into the full orthogonality theorem.
Each block verifies 16 rows × 512 columns of the 512×512 Gram matrix.
Total: 262,144 trace computations confirming trace(Mᵢᵀ·Mⱼ) = 32·δᵢⱼ.
-/

import RequestProject.Math.Clifford.CliffordCl09SPerm
import RequestProject.Math.Clifford.CliffordCl09Gram0
import RequestProject.Math.Clifford.CliffordCl09Gram1
import RequestProject.Math.Clifford.CliffordCl09Gram2
import RequestProject.Math.Clifford.CliffordCl09Gram3
import RequestProject.Math.Clifford.CliffordCl09Gram4
import RequestProject.Math.Clifford.CliffordCl09Gram5
import RequestProject.Math.Clifford.CliffordCl09Gram6
import RequestProject.Math.Clifford.CliffordCl09Gram7
import RequestProject.Math.Clifford.CliffordCl09Gram8
import RequestProject.Math.Clifford.CliffordCl09Gram9
import RequestProject.Math.Clifford.CliffordCl09Gram10
import RequestProject.Math.Clifford.CliffordCl09Gram11
import RequestProject.Math.Clifford.CliffordCl09Gram12
import RequestProject.Math.Clifford.CliffordCl09Gram13
import RequestProject.Math.Clifford.CliffordCl09Gram14
import RequestProject.Math.Clifford.CliffordCl09Gram15
import RequestProject.Math.Clifford.CliffordCl09Gram16
import RequestProject.Math.Clifford.CliffordCl09Gram17
import RequestProject.Math.Clifford.CliffordCl09Gram18
import RequestProject.Math.Clifford.CliffordCl09Gram19
import RequestProject.Math.Clifford.CliffordCl09Gram20
import RequestProject.Math.Clifford.CliffordCl09Gram21
import RequestProject.Math.Clifford.CliffordCl09Gram22
import RequestProject.Math.Clifford.CliffordCl09Gram23
import RequestProject.Math.Clifford.CliffordCl09Gram24
import RequestProject.Math.Clifford.CliffordCl09Gram25
import RequestProject.Math.Clifford.CliffordCl09Gram26
import RequestProject.Math.Clifford.CliffordCl09Gram27
import RequestProject.Math.Clifford.CliffordCl09Gram28
import RequestProject.Math.Clifford.CliffordCl09Gram29
import RequestProject.Math.Clifford.CliffordCl09Gram30
import RequestProject.Math.Clifford.CliffordCl09Gram31

set_option maxHeartbeats 1600000

/-! ## Helper: Bool gramBlock9 → Prop -/

theorem gramBlock9_spec {start count : Nat} (h : gramBlock9 start count = true)
    (i j : Nat) (hi : start ≤ i) (hi' : i < start + count) (hj : j < 512) :
    traceProd32 (monomialN9 i) (monomialN9 j) = if i == j then 32 else 0 := by
  have hdi : i - start < count := by omega
  have : start + (i - start) = i := by omega
  unfold gramBlock9 at h
  have h1 : (List.range count).all (fun di =>
    (List.range 512).all fun j =>
      let mi := monomialN9 (start + di)
      let mj := monomialN9 j
      let tr := traceProd32 mi mj
      if start + di == j then tr == 32 else tr == 0) = true := h
  rw [List.all_eq_true] at h1
  have h2 := h1 (i - start) (List.mem_range.mpr hdi)
  rw [List.all_eq_true] at h2
  have h3 := h2 j (List.mem_range.mpr hj)
  rw [this] at h3
  split_ifs at h3 ⊢ with heq1 heq2 <;> simp_all [BEq.beq, beq_iff_eq]

/-- The 512 CL9 monomial matrices satisfy trace(Mᵢᵀ·Mⱼ) = 32·δᵢⱼ. -/
theorem gram9_orthogonality (i j : Fin 512) :
    traceProd32 (monomialN9 i.val) (monomialN9 j.val) =
      if i.val == j.val then 32 else 0 := by
  obtain ⟨start, count, h_block⟩ : ∃ start count : Nat,
      start ≤ i.val ∧ i.val < start + count ∧ count = 16 ∧
      gramBlock9 start count = true := by
    grind +suggestions
  exact gramBlock9_spec h_block.2.2.2 _ _ h_block.1 h_block.2.1
    (by linarith [Fin.is_lt j])
