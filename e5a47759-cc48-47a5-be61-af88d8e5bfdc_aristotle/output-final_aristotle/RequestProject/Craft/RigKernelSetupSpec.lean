import RequestProject.Craft.RigKernelSetup

/-!
# `setup` computes the rig's parameters

The unrolled pass of `setup` over the design grid is given a meaning here
(`cellsStep`), read off as a sum over the cells (`cellsStep_get`), and then matched
against `Rig.Params.of` of the design the grid holds (`setup_correct`).

`setup` accumulates into its locals, so it is stated for a call that starts with the
locals at zero — which is what the WebAssembly format guarantees for a function's
own locals.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace RigKernel

open RigVM Rig

/-! ## What one unrolled cell does -/

/-- Add the table entry for grid byte `b` into local `i`. -/
def acc (base b i : Nat) (st : Store) : Store :=
  st.set i (wrap (st.get i + st.mem.byte (wrap (base + b))))

/-- Reading the cell's byte into local `5`, then adding its five table entries into
the five running totals. -/
def cellStep (c : Nat) (st : Store) : Store :=
  acc tblPayload (st.mem.byte (gridAddr + c)) 4
    (acc tblFuel (st.mem.byte (gridAddr + c)) 3
      (acc tblLift (st.mem.byte (gridAddr + c)) 2
        (acc tblThrust (st.mem.byte (gridAddr + c)) 1
          (acc tblMass (st.mem.byte (gridAddr + c)) 0
            (st.set 5 (st.mem.byte (gridAddr + c)))))))

/-- The first `n` cells, in the order the unrolled pass reads them. -/
def cellsStep : Nat → Store → Store
  | 0 => id
  | n + 1 => fun st => cellStep n (cellsStep n st)

/-- Where the table for local `j` lives. -/
def tblOf : Nat → Nat
  | 0 => tblMass
  | 1 => tblThrust
  | 2 => tblLift
  | 3 => tblFuel
  | _ => tblPayload

theorem tblOf_lt (j : Nat) : tblOf j < 512 := by
  match j with
  | 0 => decide
  | 1 => decide
  | 2 => decide
  | 3 => decide
  | (_ + 4) => exact (by decide : tblPayload < 512)

@[simp] theorem cellStep_mem (c : Nat) (st : Store) : (cellStep c st).mem = st.mem := rfl

theorem cellsStep_mem : ∀ (n : Nat) (st : Store), (cellsStep n st).mem = st.mem
  | 0, _ => rfl
  | n + 1, st => by rw [cellsStep, cellStep_mem, cellsStep_mem n st]

/-- Local `j` after one cell: the table entry for that cell added on. -/
theorem cellStep_get {j : Nat} (hj : j < 5) (c : Nat) (st : Store) :
    (cellStep c st).get j
      = wrap (st.get j + st.mem.byte (tblOf j + st.mem.byte (gridAddr + c))) := by
  have hb : st.mem.byte (gridAddr + c) < 256 := Nat.mod_lt _ (by decide)
  have hw : ∀ base : Nat, base < 512 →
      wrap (base + st.mem.byte (gridAddr + c)) = base + st.mem.byte (gridAddr + c) := by
    intro base h
    exact wrap_eq_self (by simp only [W32]; omega)
  interval_cases j <;>
    simp [cellStep, acc, tblOf, Store.get, Store.set,
      hw tblMass (by decide), hw tblThrust (by decide), hw tblLift (by decide),
      hw tblFuel (by decide), hw tblPayload (by decide)]

/-- Local `j` after the whole pass: the sum of the table entries over the cells. -/
theorem cellsStep_get {j : Nat} (hj : j < 5) {st : Store} (h0 : st.get j = 0) :
    ∀ n, n ≤ 256 → (cellsStep n st).get j
      = sumCells (fun c => st.mem.byte (tblOf j + st.mem.byte (gridAddr + c))) n
  | 0, _ => h0
  | n + 1, hn => by
      have hle : n ≤ 256 := by omega
      have ih := cellsStep_get hj h0 n hle
      have hbound : ∀ c, st.mem.byte (tblOf j + st.mem.byte (gridAddr + c)) ≤ 255 :=
        fun c => Nat.le_of_lt_succ (Nat.mod_lt _ (by decide))
      have hsum := sumCells_le hbound n
      have hlast := hbound n
      rw [cellsStep, cellStep_get hj, cellsStep_mem, ih, sumCells]
      exact wrap_eq_self (by simp only [W32]; omega)

/-! ## The instructions mean that -/

theorem runs_setupCell (c : Nat) (hc : gridAddr + c < W32) : Runs (setupCell c) (cellStep c) := by
  have hcell : Pushes (bLoad (cst (gridAddr + c))) (fun st => st.mem.byte (gridAddr + c)) :=
    pushes_bLoad (pushes_cst hc)
  have hacc : ∀ tbl i : Nat, tbl < W32 →
      Pushes (op .add (lget i) (bLoad (op .add (cst tbl) (lget 5))))
        (fun st => wrap (st.get i + st.mem.byte (wrap (tbl + st.get 5)))) := by
    intro tbl i htbl
    exact pushes_op' (o := .add) (pushes_lget i)
      (pushes_bLoad (pushes_op' (o := .add) (pushes_cst htbl) (pushes_lget 5) rfl)) rfl
  have hrun :=
    Runs.seq (Runs.seq (Runs.seq (Runs.seq (Runs.seq
      (runs_lset (i := 5) hcell)
      (runs_lset (i := 0) (hacc tblMass 0 (by decide))))
      (runs_lset (i := 1) (hacc tblThrust 1 (by decide))))
      (runs_lset (i := 2) (hacc tblLift 2 (by decide))))
      (runs_lset (i := 3) (hacc tblFuel 3 (by decide))))
      (runs_lset (i := 4) (hacc tblPayload 4 (by decide)))
  refine runs_congr hrun (fun st => ?_)
  simp only [cellStep, acc, Store.mem_set, Store.get_set_self,
    Store.get_set_ne _ (by decide : (5 : Nat) ≠ 0),
    Store.get_set_ne _ (by decide : (5 : Nat) ≠ 1),
    Store.get_set_ne _ (by decide : (5 : Nat) ≠ 2),
    Store.get_set_ne _ (by decide : (5 : Nat) ≠ 3)]

theorem runs_setupCells : ∀ n, n ≤ 256 → Runs (setupCells n) (cellsStep n)
  | 0, _ => Runs.nil
  | n + 1, hn => by
      have hle : n ≤ 256 := by omega
      have h := Runs.seq (runs_setupCells n hle)
        (runs_setupCell n (by simp only [gridAddr, W32]; omega))
      exact h

/-! ## The five words `setup` writes -/

/-- The memory `setup` leaves behind. -/
def setupMem (m : Mem) (ma th li fu pa : Nat) : Mem :=
  ((((m.setWord pMass ma).setWord pThrust th).setWord pLift li).setWord pFuel
    fu).setWord pPayload pa

section SetupMem

variable (m : Mem) {ma th li fu pa : Nat}

theorem setupMem_word_pMass (h : ma < W32) : (setupMem m ma th li fu pa).word pMass = ma := by
  simp only [setupMem]
  rw [Mem.word_setWord_ne (a := pPayload) (b := pMass) _ _ (by decide),
    Mem.word_setWord_ne (a := pFuel) (b := pMass) _ _ (by decide),
    Mem.word_setWord_ne (a := pLift) (b := pMass) _ _ (by decide),
    Mem.word_setWord_ne (a := pThrust) (b := pMass) _ _ (by decide),
    Mem.word_setWord_self]
  exact Nat.mod_eq_of_lt h

theorem setupMem_word_pThrust (h : th < W32) : (setupMem m ma th li fu pa).word pThrust = th := by
  simp only [setupMem]
  rw [Mem.word_setWord_ne (a := pPayload) (b := pThrust) _ _ (by decide),
    Mem.word_setWord_ne (a := pFuel) (b := pThrust) _ _ (by decide),
    Mem.word_setWord_ne (a := pLift) (b := pThrust) _ _ (by decide),
    Mem.word_setWord_self]
  exact Nat.mod_eq_of_lt h

theorem setupMem_word_pLift (h : li < W32) : (setupMem m ma th li fu pa).word pLift = li := by
  simp only [setupMem]
  rw [Mem.word_setWord_ne (a := pPayload) (b := pLift) _ _ (by decide),
    Mem.word_setWord_ne (a := pFuel) (b := pLift) _ _ (by decide),
    Mem.word_setWord_self]
  exact Nat.mod_eq_of_lt h

theorem setupMem_word_pFuel (h : fu < W32) : (setupMem m ma th li fu pa).word pFuel = fu := by
  simp only [setupMem]
  rw [Mem.word_setWord_ne (a := pPayload) (b := pFuel) _ _ (by decide),
    Mem.word_setWord_self]
  exact Nat.mod_eq_of_lt h

theorem setupMem_word_pPayload (h : pa < W32) :
    (setupMem m ma th li fu pa).word pPayload = pa := by
  simp only [setupMem]
  rw [Mem.word_setWord_self]
  exact Nat.mod_eq_of_lt h

/-- `setup` touches nothing below the parameter block: the grid, the track and the
constant tables are left exactly as they were. -/
theorem setupMem_byte_low {a : Nat} (h : a < pMass) : (setupMem m ma th li fu pa).byte a =
    m.byte a := by
  have h' : a < 560 := h
  simp only [setupMem]
  rw [Mem.byte_setWord_ne (a := pPayload) (b := a) _ _ (Or.inl (by simp only [pPayload]; omega)),
    Mem.byte_setWord_ne (a := pFuel) (b := a) _ _ (Or.inl (by simp only [pFuel]; omega)),
    Mem.byte_setWord_ne (a := pLift) (b := a) _ _ (Or.inl (by simp only [pLift]; omega)),
    Mem.byte_setWord_ne (a := pThrust) (b := a) _ _ (Or.inl (by simp only [pThrust]; omega)),
    Mem.byte_setWord_ne (a := pMass) (b := a) _ _ (Or.inl (by simp only [pMass]; omega))]

/-- `setup` does not move the finish line. -/
theorem setupMem_word_pFinish : (setupMem m ma th li fu pa).word pFinish = m.word pFinish := by
  simp only [setupMem]
  rw [Mem.word_setWord_ne (a := pPayload) (b := pFinish) _ _ (by decide),
    Mem.word_setWord_ne (a := pFuel) (b := pFinish) _ _ (by decide),
    Mem.word_setWord_ne (a := pLift) (b := pFinish) _ _ (by decide),
    Mem.word_setWord_ne (a := pThrust) (b := pFinish) _ _ (by decide),
    Mem.word_setWord_ne (a := pMass) (b := pFinish) _ _ (by decide)]

end SetupMem

/-- Everything `setup` does: the pass over the grid, then the five words. -/
def setupStore (st : Store) : Store :=
  Store.mk (cellsStep 256 st).locals
    (setupMem (cellsStep 256 st).mem (max 1 ((cellsStep 256 st).get 0))
      ((cellsStep 256 st).get 1) ((cellsStep 256 st).get 2) ((cellsStep 256 st).get 3)
      ((cellsStep 256 st).get 4))

set_option maxRecDepth 10000 in
theorem runs_setupBody : Runs setupBody setupStore := by
  have hmax : Pushes (eMax (cst 1) (lget 0)) (fun st => max 1 (st.get 0)) :=
    pushes_eMax (pushes_cst (by decide)) (pushes_lget 0)
  have hrun :=
    Runs.seq (Runs.seq (Runs.seq (Runs.seq (Runs.seq
      (runs_setupCells 256 (le_refl _))
      (runs_wStore (a := pMass) hmax))
      (runs_wStore (a := pThrust) (pushes_lget 1)))
      (runs_wStore (a := pLift) (pushes_lget 2)))
      (runs_wStore (a := pFuel) (pushes_lget 3)))
      (runs_wStore (a := pPayload) (pushes_lget 4))
  exact runs_congr hrun (fun _ => rfl)

/-! ## The tables are the ones the module ships -/

/-- A memory holding the five constant tables exactly as the kernel's data segments
lay them out, and nothing else. -/
def tablesMem : Mem := fun a =>
  if 384 ≤ a ∧ a ≤ 390 then (0 :: Kind.all.map Kind.mass).getD (a - 384) 0
  else if 392 ≤ a ∧ a ≤ 398 then (0 :: Kind.all.map Kind.thrust).getD (a - 392) 0
  else if 400 ≤ a ∧ a ≤ 406 then (0 :: Kind.all.map Kind.lift).getD (a - 400) 0
  else if 408 ≤ a ∧ a ≤ 414 then (0 :: Kind.all.map Kind.fuelUnits).getD (a - 408) 0
  else if 416 ≤ a ∧ a ≤ 422 then (0 :: Kind.all.map Kind.payload).getD (a - 416) 0
  else 0

/-- The hypotheses of `setup_correct` are not empty: the data segments the kernel
ships really do satisfy `TablesAt`, over a grid that is still blank. -/
example : TablesAt tablesMem ∧ GridAt tablesMem [] :=
  ⟨{ mass := ⟨by decide, fun k => by cases k <;> decide⟩
     thrust := ⟨by decide, fun k => by cases k <;> decide⟩
     lift := ⟨by decide, fun k => by cases k <;> decide⟩
     fuel := ⟨by decide, fun k => by cases k <;> decide⟩
     payload := ⟨by decide, fun k => by cases k <;> decide⟩ },
   ⟨fun c hc => by
      have h1 : ¬ (384 ≤ c ∧ c ≤ 390) := by omega
      have h2 : ¬ (392 ≤ c ∧ c ≤ 398) := by omega
      have h3 : ¬ (400 ≤ c ∧ c ≤ 406) := by omega
      have h4 : ¬ (408 ≤ c ∧ c ≤ 414) := by omega
      have h5 : ¬ (416 ≤ c ∧ c ≤ 422) := by omega
      simp [valAt, gridAddr, Mem.byte, tablesMem, h1, h2, h3, h4, h5]⟩⟩

/-! ## `setup` computes `Params.of` -/

/-- Each of the five totals is the design's total for that quantity. -/
theorem cellsStep_get_eq {m : Mem} {d : Design} {base : Nat} {f : Kind → Nat} (j : Nat)
    (hj : j < 5) (hbase : tblOf j = base) (htab : TableAt m base f) (hg : GridAt m d)
    (hin : ∀ b ∈ d, b.inBounds = true) (hnd : (Design.cells d).Nodup)
    {locals : Locals} (hl : locals j = 0) :
    (cellsStep 256 ⟨locals, m⟩).get j = (d.map (fun b => f b.kind)).sum := by
  rw [cellsStep_get hj (st := ⟨locals, m⟩) hl 256 (le_refl _)]
  rw [← sumCells_valAt f d hin hnd]
  refine sumCells_congr 256 (fun c hc => ?_)
  show m.byte (tblOf j + m.byte (gridAddr + c)) = valAt f d c
  rw [hbase]
  exact byte_tbl_grid htab hg hc

/-- Everything a design contributes is at most `255` per cell, so no total wraps. -/
theorem design_sum_le {m : Mem} {d : Design} {base : Nat} {f : Kind → Nat} (j : Nat)
    (hj : j < 5) (hbase : tblOf j = base) (htab : TableAt m base f) (hg : GridAt m d)
    (hin : ∀ b ∈ d, b.inBounds = true) (hnd : (Design.cells d).Nodup) :
    (d.map (fun b => f b.kind)).sum ≤ 65280 := by
  have h := cellsStep_get_eq j hj hbase htab hg hin hnd (locals := fun _ => 0) rfl
  rw [← h, cellsStep_get hj (st := ⟨fun _ => 0, m⟩) rfl 256 (le_refl _)]
  have hbound : ∀ c, m.byte (tblOf j + m.byte (gridAddr + c)) ≤ 255 :=
    fun c => Nat.le_of_lt_succ (Nat.mod_lt _ (by decide))
  exact le_trans (sumCells_le hbound 256) (by omega)

/-- **`setup` computes the rig's parameters.**  Over a memory whose grid holds the
design `d`, whose constant tables are in place and whose locals start at zero — the
three things a freshly instantiated module gives — one call of `setup` writes
`Rig.Params.of d` into the parameter block, and leaves the grid, the tables, the
track and the finish line alone. -/
theorem setup_correct {m : Mem} {d : Design} {t : Track} {locals : Locals} {fuel : Nat}
    (htab : TablesAt m) (hg : GridAt m d) (hin : ∀ b ∈ d, b.inBounds = true)
    (hnd : (Design.cells d).Nodup) (hl : ∀ i, locals i = 0) (ht : TrackAt m t)
    (hfin : m.word pFinish = t.finish) :
    ∃ m', callVoid setupBody locals m fuel = some m' ∧
      ParamsAt m' (Params.of d) t.finish ∧ GridAt m' d ∧ TablesAt m' ∧ TrackAt m' t := by
  have hrun := runs_setupBody ⟨[], ⟨locals, m⟩⟩ fuel
  set s := cellsStep 256 (⟨locals, m⟩ : Store) with hs
  have hsmem : s.mem = m := cellsStep_mem 256 _
  have hmass : s.get 0 = Design.mass d :=
    cellsStep_get_eq 0 (by decide) rfl htab.mass hg hin hnd (hl 0)
  have hthrust : s.get 1 = Design.thrust d :=
    cellsStep_get_eq 1 (by decide) rfl htab.thrust hg hin hnd (hl 1)
  have hlift : s.get 2 = Design.lift d :=
    cellsStep_get_eq 2 (by decide) rfl htab.lift hg hin hnd (hl 2)
  have hfuel : s.get 3 = Design.fuel d :=
    cellsStep_get_eq 3 (by decide) rfl htab.fuel hg hin hnd (hl 3)
  have hpay : s.get 4 = Design.payload d :=
    cellsStep_get_eq 4 (by decide) rfl htab.payload hg hin hnd (hl 4)
  have bmass : Design.mass d ≤ 65280 := design_sum_le 0 (by decide) rfl htab.mass hg hin hnd
  have bthrust : Design.thrust d ≤ 65280 :=
    design_sum_le 1 (by decide) rfl htab.thrust hg hin hnd
  have blift : Design.lift d ≤ 65280 := design_sum_le 2 (by decide) rfl htab.lift hg hin hnd
  have bfuel : Design.fuel d ≤ 65280 := design_sum_le 3 (by decide) rfl htab.fuel hg hin hnd
  have bpay : Design.payload d ≤ 65280 := design_sum_le 4 (by decide) rfl htab.payload hg hin hnd
  have hw : W32 = 4294967296 := rfl
  refine ⟨(setupStore ⟨locals, m⟩).mem, ?_, ?_, ?_, ?_, ?_⟩
  · unfold callVoid
    rw [hrun]
  · have hmem : (setupStore ⟨locals, m⟩).mem =
        setupMem m (max 1 (Design.mass d)) (Design.thrust d) (Design.lift d) (Design.fuel d)
          (Design.payload d) := by
      simp only [setupStore, ← hs, hsmem, hmass, hthrust, hlift, hfuel, hpay]
    rw [hmem]
    exact
      { mass := setupMem_word_pMass m (by omega)
        thrust := setupMem_word_pThrust m (by omega)
        lift := setupMem_word_pLift m (by omega)
        fuel := setupMem_word_pFuel m (by omega)
        payload := setupMem_word_pPayload m (by omega)
        finish := by rw [setupMem_word_pFinish m, hfin] }
  · have hmem : (setupStore ⟨locals, m⟩).mem =
        setupMem m (max 1 (s.get 0)) (s.get 1) (s.get 2) (s.get 3) (s.get 4) := by
      simp only [setupStore, ← hs, hsmem]
    exact
      { cell := fun c hc => by
          rw [hmem, setupMem_byte_low m (by simp only [gridAddr, pMass]; omega)]
          exact hg.cell c hc }
  · have hmem : (setupStore ⟨locals, m⟩).mem =
        setupMem m (max 1 (s.get 0)) (s.get 1) (s.get 2) (s.get 3) (s.get 4) := by
      simp only [setupStore, ← hs, hsmem]
    rw [hmem]
    have hlow : ∀ a : Nat, a < 560 → (setupMem m (max 1 (s.get 0)) (s.get 1) (s.get 2)
        (s.get 3) (s.get 4)).byte a = m.byte a := fun a ha => setupMem_byte_low m ha
    exact
      { mass :=
          { zero := by rw [hlow tblMass (by decide)]; exact htab.mass.zero
            val := fun k => by
              rw [hlow (tblMass + k.code) (by have := k.code_lt; simp only [tblMass]; omega)]
              exact htab.mass.val k }
        thrust :=
          { zero := by rw [hlow tblThrust (by decide)]; exact htab.thrust.zero
            val := fun k => by
              rw [hlow (tblThrust + k.code) (by have := k.code_lt; simp only [tblThrust]; omega)]
              exact htab.thrust.val k }
        lift :=
          { zero := by rw [hlow tblLift (by decide)]; exact htab.lift.zero
            val := fun k => by
              rw [hlow (tblLift + k.code) (by have := k.code_lt; simp only [tblLift]; omega)]
              exact htab.lift.val k }
        fuel :=
          { zero := by rw [hlow tblFuel (by decide)]; exact htab.fuel.zero
            val := fun k => by
              rw [hlow (tblFuel + k.code) (by have := k.code_lt; simp only [tblFuel]; omega)]
              exact htab.fuel.val k }
        payload :=
          { zero := by rw [hlow tblPayload (by decide)]; exact htab.payload.zero
            val := fun k => by
              rw [hlow (tblPayload + k.code) (by have := k.code_lt; simp only [tblPayload]; omega)]
              exact htab.payload.val k } }
  · have hmem : (setupStore ⟨locals, m⟩).mem =
        setupMem m (max 1 (s.get 0)) (s.get 1) (s.get 2) (s.get 3) (s.get 4) := by
      simp only [setupStore, ← hs, hsmem]
    refine ⟨fun c hc => ?_⟩
    simp only [trackLen] at hc
    rw [hmem, setupMem_byte_low m (show trackAddr + c < pMass by
      simp only [trackAddr, pMass]; omega)]
    exact ht.ground c hc

end RigKernel
