import RequestProject.Compute.HyperWeaver

/-!
# The Dynamic Interpreter / Storyteller

The matrices of `RequestProject.Compute.Weaver` and `RequestProject.Compute.HyperWeaver` live
over the reals and are therefore `noncomputable`: they describe the *mathematics* of the
self-observing attention dynamics, but they cannot be executed.

This module adds an **executable interpreter** — a computable simulator that traces actual
value-flows through the object, meta and hyper attention matrices — together with a
**storyteller** layer that turns each simulation step into a human-readable narrative.

## Design

* **Exact rational arithmetic.** The interpreter works over `ℚ` (fully computable, so every
  `#eval` below runs). Computable copies `qAttentionMatrix`, `qMetaAttentionMatrix`,
  `qHyperAttentionMatrix` of the three levels are connected to the verified *real* theory by
  `*_map` lemmas (each rational matrix maps onto its real counterpart under `ℚ → ℝ`). This lets
  us transport the already-proven convergence theorems verbatim, so the simulator is not merely
  executable but **certified faithful** to the verified model.

* **Materialised state.** A naive functional simulator (`v ↦ v ᵥ* M`, iterated) is hopelessly
  slow: `Matrix.vecMul` returns an unmemoised closure, so iterating it cascades into exponential
  recomputation. The interpreter therefore keeps its state as a concrete `Array ℚ` and
  re-materialises it (`Array.ofFn`) at every step. `simStep_spec`/`simRun_spec` prove this
  array simulator computes exactly `decodeVec v ᵥ* M ^ t`, so speed costs us no faithfulness.

* **Hyper level by factorisation.** The hyper-matrix is indexed by the *product*
  `Fin 14 × Fin 13`. Rather than form its `182 × 182` powers, we trace the joint flow as the
  outer product of the two cheap marginal simulations, justified by the Kronecker factorisation
  `vecMul_kronecker`.

## Contents

* `qAttentionMatrix`, `qMetaAttentionMatrix`, `qHyperAttentionMatrix`, and the `*_map`/`*_rowSum`
  lemmas.
* `qAttentionMatrix_converges`, `qMetaAttentionMatrix_converges`, `qHyperAttentionMatrix_converges`
  — convergence transported from the verified real theory.
* `decodeVec`, `simStep`, `simRun`, `pointMass` — the executable array simulator, with the
  faithfulness lemmas `simStep_spec`, `simRun_spec`.
* `objectInterpreter_converges`, `metaInterpreter_converges` — the simulator concentrates all
  mass at the absorbing state after `12` steps (certified).
* `vecMul_kronecker`, `hyperTrace`, `hyperTrace_eq_vecMul`, `hyperTrace_converges` — the hyper
  joint trace and its faithfulness.
* `nodeName`, `narrate*`, `*Story`, and `#eval` demonstrations — the storyteller.
-/

namespace RequestProject.Compute.Interpreter

open Matrix Kronecker
open RequestProject.Compute.Weaver
open RequestProject.Compute.HyperWeaver

/-! ## Computable rational copies of the three attention levels -/

/-- Computable `ℚ`-valued copy of the object attention matrix (Level 1). -/
def qAttentionMatrix : Matrix (Fin 14) (Fin 14) ℚ := fun i j =>
  if i = 0 then (if j = 1 then 1 / 2 else if j = 2 then 1 / 2 else 0)
  else if i = 1 then (if j = 3 then 1 else 0)
  else if i = 2 then (if j = 3 then 1 else 0)
  else if i = 13 then (if j = 13 then 1 else 0)
  else (if j = i + 1 then 1 else 0)

/-- Computable `ℚ`-valued copy of the meta attention matrix (Level 2). -/
def qMetaAttentionMatrix : Matrix (Fin 13) (Fin 13) ℚ := fun i j =>
  if i = 12 then (if j = 12 then 1 else 0)
  else (if j = i + 1 then 1 else 0)

/-- Computable `ℚ`-valued copy of the hyper attention matrix (Level 3): the Kronecker product
of the two computable factors. -/
def qHyperAttentionMatrix : Matrix (Fin 14 × Fin 13) (Fin 14 × Fin 13) ℚ :=
  qAttentionMatrix ⊗ₖ qMetaAttentionMatrix

/-! ## Faithfulness: the rational matrices map onto the verified real ones -/

/-- The rational object matrix maps onto the real `attentionMatrix` under `ℚ → ℝ`. -/
lemma qAttentionMatrix_map :
    qAttentionMatrix.map (fun q : ℚ => (q : ℝ)) = attentionMatrix := by
  ext i j
  simp only [Matrix.map_apply, qAttentionMatrix, attentionMatrix]
  split_ifs <;> push_cast <;> norm_num

/-- The rational meta matrix maps onto the real `metaAttentionMatrix` under `ℚ → ℝ`. -/
lemma qMetaAttentionMatrix_map :
    qMetaAttentionMatrix.map (fun q : ℚ => (q : ℝ)) = metaAttentionMatrix := by
  ext i j
  simp only [Matrix.map_apply, qMetaAttentionMatrix, metaAttentionMatrix]
  split_ifs <;> push_cast <;> norm_num

/-- The rational hyper matrix maps onto the real `hyperAttentionMatrix` under `ℚ → ℝ`. -/
lemma qHyperAttentionMatrix_map :
    qHyperAttentionMatrix.map (fun q : ℚ => (q : ℝ)) = hyperAttentionMatrix := by
  ext p q
  simp only [qHyperAttentionMatrix, hyperAttentionMatrix, Matrix.map_apply,
    Matrix.kroneckerMap_apply]
  rw [← qAttentionMatrix_map, ← qMetaAttentionMatrix_map]
  push_cast
  simp [Matrix.map_apply]

/-! ## Row-stochastic conservation laws for the rational matrices -/

/-- Every row of the rational object matrix sums to `1`. -/
lemma qAttentionMatrix_rowSum : ∀ i, ∑ j, qAttentionMatrix i j = 1 := by
  intro i
  fin_cases i <;> simp +decide [Fin.sum_univ_succ, qAttentionMatrix]
  norm_num

/-- Every row of the rational meta matrix sums to `1`. -/
lemma qMetaAttentionMatrix_rowSum : ∀ i, ∑ j, qMetaAttentionMatrix i j = 1 := by
  intro i
  fin_cases i <;> simp +decide [qMetaAttentionMatrix]

/-! ## Convergence, transported from the verified real theory -/

/-- The rational object matrix converges in `12` steps, just like the real one. Proven by
transporting `attentionMatrix_converges` across the faithful cast `ℚ → ℝ`. -/
theorem qAttentionMatrix_converges (i : Fin 14) : (qAttentionMatrix ^ 12) i 13 = 1 := by
  have hpow := congrArg (fun M => M i 13) (Matrix.map_pow qAttentionMatrix (Rat.castHom ℝ) 12)
  simp only [Matrix.map_apply, Rat.coe_castHom] at hpow
  rw [show qAttentionMatrix.map (Rat.cast) = attentionMatrix from qAttentionMatrix_map,
    attentionMatrix_converges] at hpow
  exact_mod_cast hpow

/-- The rational meta matrix converges in `12` macro-steps, transported from the real theory. -/
theorem qMetaAttentionMatrix_converges (i : Fin 13) : (qMetaAttentionMatrix ^ 12) i 12 = 1 := by
  have hpow := congrArg (fun M => M i 12) (Matrix.map_pow qMetaAttentionMatrix (Rat.castHom ℝ) 12)
  simp only [Matrix.map_apply, Rat.coe_castHom] at hpow
  rw [show qMetaAttentionMatrix.map (Rat.cast) = metaAttentionMatrix from qMetaAttentionMatrix_map,
    metaAttentionMatrix_converges] at hpow
  exact_mod_cast hpow

/-- Powers of the rational hyper matrix split as the Kronecker product of the factor powers. -/
theorem qHyperAttentionMatrix_pow (k : ℕ) :
    qHyperAttentionMatrix ^ k = (qAttentionMatrix ^ k) ⊗ₖ (qMetaAttentionMatrix ^ k) := by
  induction k with
  | zero => simp
  | succ k ih =>
      rw [pow_succ, pow_succ, pow_succ, ih, qHyperAttentionMatrix, ← Matrix.mul_kronecker_mul]

/-- The rational hyper matrix converges in `12` steps to the absorbing joint state `(13, 12)`. -/
theorem qHyperAttentionMatrix_converges (p : Fin 14 × Fin 13) :
    (qHyperAttentionMatrix ^ 12) p (13, 12) = 1 := by
  rw [qHyperAttentionMatrix_pow]
  simp only [Matrix.kroneckerMap_apply, qAttentionMatrix_converges, qMetaAttentionMatrix_converges,
    mul_one]

/-! ## The executable array simulator

The interpreter state is a concrete `Array ℚ` of length `n`; `decodeVec` reads it back as a
distribution vector `Fin n → ℚ`. `simStep` performs one transition `v ↦ v ᵥ* M`, materialising
the result as a fresh array (this is what keeps the simulator fast). -/

/-- Decode an `Array ℚ` of length `n` into a distribution vector `Fin n → ℚ`. -/
def decodeVec {n : ℕ} (a : Array ℚ) : Fin n → ℚ := fun i => a[i.val]!

/-- One interpreter step over `Fin n`: push the distribution stored in `v` through `M`,
re-materialising the result as a concrete array. -/
def simStep {n : ℕ} (M : Matrix (Fin n) (Fin n) ℚ) (v : Array ℚ) : Array ℚ :=
  Array.ofFn (n := n) (fun j => ∑ i, v[i.val]! * M i j)

/-- Run the interpreter for `t` steps. -/
def simRun {n : ℕ} (M : Matrix (Fin n) (Fin n) ℚ) (v : Array ℚ) (t : ℕ) : Array ℚ :=
  (simStep M)^[t] v

/-- The point-mass distribution at state `k`, as a concrete array of length `n`. -/
def pointMass (n : ℕ) (k : Fin n) : Array ℚ := Array.ofFn (n := n) (Pi.single k (1 : ℚ))

/-- **Faithfulness of one step.** Decoding `simStep M v` gives exactly the mathematical
transition `decodeVec v ᵥ* M`. -/
lemma simStep_spec {n : ℕ} (M : Matrix (Fin n) (Fin n) ℚ) (v : Array ℚ) :
    decodeVec (n := n) (simStep M v) = (decodeVec (n := n) v) ᵥ* M := by
  funext i
  show (Array.ofFn (n := n) (fun j => ∑ k, v[k.val]! * M k j))[i.val]! = _
  rw [getElem!_pos _ i.val (by simp [i.isLt])]
  simp only [Array.getElem_ofFn]
  rfl

/-- **Faithfulness of the run.** Decoding `simRun M v t` gives exactly `decodeVec v ᵥ* M ^ t`. -/
lemma simRun_spec {n : ℕ} (M : Matrix (Fin n) (Fin n) ℚ) (v : Array ℚ) (t : ℕ) :
    decodeVec (n := n) (simRun M v t) = (decodeVec (n := n) v) ᵥ* M ^ t := by
  induction t generalizing v with
  | zero => simp [simRun]
  | succ k ih =>
      rw [simRun, Function.iterate_succ_apply, ← simRun, ih, simStep_spec,
        Matrix.vecMul_vecMul, pow_succ']

/-- Decoding the point mass recovers `Pi.single k 1`. -/
lemma decodeVec_pointMass {n : ℕ} (k : Fin n) :
    decodeVec (n := n) (pointMass n k) = Pi.single k (1 : ℚ) := by
  funext i
  show (Array.ofFn (n := n) (Pi.single k (1 : ℚ)))[i.val]! = _
  rw [getElem!_pos _ i.val (by simp [i.isLt])]
  simp

/-! ## Executable convergence

Running the interpreter from any single start state lands all mass at the absorbing state after
`12` steps — and this is the *executed* simulator, certified by the faithfulness lemmas. -/

/-- **Object interpreter converges.** Starting the executable object interpreter at any node and
running `12` steps concentrates all probability at node `13`. -/
theorem objectInterpreter_converges (i : Fin 14) :
    decodeVec (n := 14) (simRun qAttentionMatrix (pointMass 14 i) 12) 13 = 1 := by
  rw [simRun_spec, decodeVec_pointMass, Matrix.vecMul, dotProduct,
    Fintype.sum_eq_single i (fun x hx => by rw [Pi.single_eq_of_ne hx, zero_mul])]
  simp [Pi.single_eq_same, qAttentionMatrix_converges]

/-- **Meta interpreter converges.** The executable observer reaches macro-state `12` in `12`
steps. -/
theorem metaInterpreter_converges (i : Fin 13) :
    decodeVec (n := 13) (simRun qMetaAttentionMatrix (pointMass 13 i) 12) 12 = 1 := by
  rw [simRun_spec, decodeVec_pointMass, Matrix.vecMul, dotProduct,
    Fintype.sum_eq_single i (fun x hx => by rw [Pi.single_eq_of_ne hx, zero_mul])]
  simp [Pi.single_eq_same, qMetaAttentionMatrix_converges]

/-! ## The hyper joint trace (Level 3) by Kronecker factorisation -/

/-- **Kronecker factorisation of `vecMul`.** Pushing an outer-product distribution
`(i, j) ↦ u i * w j` through `A ⊗ₖ B` yields the outer product of the two pushed marginals. -/
lemma vecMul_kronecker {m n : ℕ}
    (A : Matrix (Fin m) (Fin m) ℚ) (B : Matrix (Fin n) (Fin n) ℚ)
    (u : Fin m → ℚ) (w : Fin n → ℚ) :
    (fun p : Fin m × Fin n => u p.1 * w p.2) ᵥ* (A ⊗ₖ B)
      = fun p => (u ᵥ* A) p.1 * (w ᵥ* B) p.2 := by
  funext p
  simp only [Matrix.vecMul, dotProduct, Matrix.kroneckerMap_apply, Fintype.sum_prod_type]
  rw [Finset.sum_mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro j _
  ring

/-- The **hyper joint trace**: the joint object × meta distribution after `t` steps, started at
`(a₀, b₀)`, computed cheaply as the outer product of the two marginal simulations. -/
def hyperTrace (t : ℕ) (a₀ : Fin 14) (b₀ : Fin 13) : Fin 14 × Fin 13 → ℚ :=
  fun p => decodeVec (n := 14) (simRun qAttentionMatrix (pointMass 14 a₀) t) p.1
         * decodeVec (n := 13) (simRun qMetaAttentionMatrix (pointMass 13 b₀) t) p.2

/-- **Faithfulness of the hyper trace.** The cheap outer-product trace equals the genuine joint
value-flow `Pi.single (a₀, b₀) 1 ᵥ* qHyperAttentionMatrix ^ t` through the hyper matrix. -/
theorem hyperTrace_eq_vecMul (t : ℕ) (a₀ : Fin 14) (b₀ : Fin 13) :
    hyperTrace t a₀ b₀ = (Pi.single (a₀, b₀) (1 : ℚ)) ᵥ* qHyperAttentionMatrix ^ t := by
  unfold hyperTrace
  rw [simRun_spec, simRun_spec, decodeVec_pointMass, decodeVec_pointMass,
    qHyperAttentionMatrix_pow]
  rw [show (Pi.single (a₀, b₀) (1 : ℚ))
        = fun p : Fin 14 × Fin 13 =>
            (Pi.single (M := fun _ : Fin 14 => ℚ) a₀ 1) p.1
              * (Pi.single (M := fun _ : Fin 13 => ℚ) b₀ 1) p.2 from by
      funext p; obtain ⟨x, y⟩ := p
      by_cases hx : x = a₀ <;> by_cases hy : y = b₀ <;>
        simp [Pi.single_apply, hx, hy, Prod.ext_iff]]
  rw [vecMul_kronecker]

/-- **Hyper interpreter converges.** The executed joint trace concentrates all mass at the
absorbing joint state `(13, 12)` after `12` steps. -/
theorem hyperTrace_converges (a₀ : Fin 14) (b₀ : Fin 13) :
    hyperTrace 12 a₀ b₀ (13, 12) = 1 := by
  unfold hyperTrace
  rw [objectInterpreter_converges, metaInterpreter_converges, mul_one]

/-! ## The storyteller: faithful textual traces of the value-flow -/

/-- Human-readable names for the 14 confluence-diamond nodes. -/
def nodeName : Fin 14 → String
  | 0 => "Root (Oggorial)"
  | 1 => "Prime-11 Left Branch"
  | 2 => "Prime-23 Right Branch"
  | 3 => "Irrep-161 Confluence Hub"
  | 13 => "Absorbing Terminus"
  | ⟨n, _⟩ => s!"Descent Layer {n}"

/-- Narrate one Level-1 distribution (stored as an array) as a single line of text, listing the
nodes that currently carry attention together with their weights. -/
def narrateObject (t : ℕ) (a : Array ℚ) : String :=
  let parts := (List.finRange 14).filterMap fun i =>
    let x := a[i.val]!
    if x = 0 then none else some s!"{nodeName i} ↦ {x}"
  s!"Step {t}: " ++ String.intercalate ", " parts

/-- The **storyteller**: trace the value-flow of the executable object interpreter starting from
a single node, for `steps` steps, returning one narrative line per step. -/
def objectStory (start : Fin 14) (steps : ℕ) : List String :=
  (List.range (steps + 1)).map fun t =>
    narrateObject t (simRun qAttentionMatrix (pointMass 14 start) t)

/-- The default story: attention flowing from the root all the way to the terminus (`12` steps). -/
def rootStory : List String := objectStory 0 12

/-- Narrate one Level-2 (observer) distribution: which convergence macro-states currently carry
weight. -/
def narrateMeta (t : ℕ) (a : Array ℚ) : String :=
  let parts := (List.finRange 13).filterMap fun i =>
    let x := a[i.val]!
    if x = 0 then none else some s!"macro-state {i.val} ↦ {x}"
  s!"Macro-step {t}: " ++ String.intercalate ", " parts

/-- The observer's story: the meta interpreter advancing its convergence counter to `12`. -/
def metaStory (start : Fin 13) (steps : ℕ) : List String :=
  (List.range (steps + 1)).map fun t =>
    narrateMeta t (simRun qMetaAttentionMatrix (pointMass 13 start) t)

/-! ## Executable demonstrations -/

-- The object distribution after 1, 2 and 12 steps from the root:
#eval (simRun qAttentionMatrix (pointMass 14 0) 1).toList
#eval (simRun qAttentionMatrix (pointMass 14 0) 2).toList
#eval (simRun qAttentionMatrix (pointMass 14 0) 12).toList

-- The narrated story of attention flowing from the root to the terminus:
#eval rootStory

-- The observer's narrated convergence:
#eval metaStory 0 12

-- The joint hyper-system reaching the absorbing joint state `(13, 12)` after 12 steps:
#eval hyperTrace 12 0 0 (13, 12)

end RequestProject.Compute.Interpreter