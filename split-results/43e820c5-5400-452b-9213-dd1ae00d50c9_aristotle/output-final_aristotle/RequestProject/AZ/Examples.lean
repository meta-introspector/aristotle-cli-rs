import RequestProject.AZ.SpectralReduction

/-!
# Altland–Zirnbauer: the textbook models

We assemble the standard physics models onto the Bott clock and verify, by
computation, that the AZ classification function `azReal` / `azComplex`
reproduces their known groups of strong topological invariants.

Each real AZ class sits at a Bott-clock position `s : ZMod 8`:

| class | AI | BDI | D  | DIII | AII | CII | C  | CI |
|-------|----|-----|----|------|-----|-----|----|----|
| `s`   | 0  | 1   | 2  | 3    | 4   | 5   | 6  | 7  |

and complex classes `A, AIII` at `s : ZMod 2` equal to `0, 1`.
-/

namespace RequestProject.AZ

/-! ## Bott-clock positions of the real symmetry classes -/

/-- AI (orthogonal). -/ def classAI : BottClock := 0
/-- BDI (chiral orthogonal). -/ def classBDI : BottClock := 1
/-- D (Bogoliubov–de Gennes). -/ def classD : BottClock := 2
/-- DIII. -/ def classDIII : BottClock := 3
/-- AII (symplectic). -/ def classAII : BottClock := 4
/-- CII (chiral symplectic). -/ def classCII : BottClock := 5
/-- C. -/ def classC : BottClock := 6
/-- CI. -/ def classCI : BottClock := 7

/-! ## Real-class models -/

/-- **SSH / polyacetylene chain** — class BDI in `d = 1`: invariant group `ℤ`
(the winding number). -/
theorem ssh_chain : azReal classBDI 1 = KGroup.Z := by decide

/-- **Kitaev `p`-wave chain** — class D in `d = 1`: invariant group `ℤ₂`
(Majorana parity). -/
theorem kitaev_chain : azReal classD 1 = KGroup.Z2 := by decide

/-- **`p + ip` superconductor** — class D in `d = 2`: invariant group `ℤ`
(the BdG Chern number). -/
theorem p_ip_superconductor : azReal classD 2 = KGroup.Z := by decide

/-- **Quantum spin Hall (Kane–Mele)** — class AII in `d = 2`: invariant `ℤ₂`. -/
theorem quantum_spin_hall : azReal classAII 2 = KGroup.Z2 := by decide

/-- **3D topological insulator (Bi₂Se₃)** — class AII in `d = 3`: invariant `ℤ₂`. -/
theorem topological_insulator_3d : azReal classAII 3 = KGroup.Z2 := by decide

/-- **Superfluid ³He-B** — class DIII in `d = 3`: invariant group `ℤ`. -/
theorem helium3_B : azReal classDIII 3 = KGroup.Z := by decide

/-! ## Complex-class models -/

/-- A (unitary). -/ def classA : ZMod 2 := 0
/-- AIII (chiral unitary). -/ def classAIII : ZMod 2 := 1

/-- **Integer quantum Hall** — class A in `d = 2`: invariant group `ℤ`
(the TKNN / first Chern number). -/
theorem integer_quantum_hall : azComplex classA 2 = KGroup.Z := by decide

/-- **Haldane Chern insulator** — class A in `d = 2`: invariant group `ℤ`. -/
theorem haldane_model : azComplex classA 2 = KGroup.Z := by decide

/-- **Su–Schrieffer–Heeger via chiral class AIII** — class AIII in `d = 1`:
invariant group `ℤ`. -/
theorem ssh_chiral : azComplex classAIII 1 = KGroup.Z := by decide

/-- The nine models above are realized; the eightfold real Bott clock together
with the two complex classes is the full AZ tenfold way. -/
theorem tenfold_way_complete :
    azReal classBDI 1 = KGroup.Z ∧ azReal classD 1 = KGroup.Z2 ∧
    azReal classD 2 = KGroup.Z ∧ azReal classAII 2 = KGroup.Z2 ∧
    azReal classAII 3 = KGroup.Z2 ∧ azReal classDIII 3 = KGroup.Z ∧
    azComplex classA 2 = KGroup.Z ∧ azComplex classAIII 1 = KGroup.Z := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> decide

end RequestProject.AZ
