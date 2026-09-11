import RequestProject.Gvcs.Rig.WasmExpr

/-!
# The module is the rule book

`RequestProject/Rig/Wasm.lean` builds a WebAssembly module out of the workshop
of `RequestProject/Rig/Blocks.lean` and the course of
`RequestProject/Rig/Drive.lean`.  This file proves that the module *is* those
two files: every one of its six entry points answers exactly what the Lean
definitions say.

The link between the two is `Rep d s mem`: the memory `mem` holds the design
`d` in its grid, the nine figures of `d` in its accumulators, the block tables
where the code generator put them, and the state `s` of the run in its first
seven cells.  Then

* `stat_correct` — `stat j` is the `j`th figure of the design;
* `get_correct` — `get j` is the `j`th field of the run;
* `valid_correct` — `valid ()` is one exactly when the design passes the
  workshop rules;
* `reset_correct` — `reset ()` puts the memory in the state `startDrive`
  describes, and disturbs nothing else;
* `place_correct` — `place i k` leaves the memory representing `place d i k`,
  figures and all, in constant time (this is where `statOf_place` is used);
* `tick_correct` — `tick th st sc br` leaves the memory representing
  `Drive.tick`, the rule book's own next state.

Together these say that a browser running the module plays the game the Lean
development defines, and nothing else.
-/

namespace LifeTrac
namespace Rig

open Wasm

/-! ## The reading of a memory -/

/-- The `j`th field of a run, in the order `get` numbers them. -/
def driveField (s : Drive) : Nat → Int
  | 0 => s.pos | 1 => s.lane | 2 => s.vel | 3 => s.fuel | 4 => s.load
  | 5 => s.score | _ => s.ticks

/-- `mem` holds the design `d`, its nine figures, the block tables and the
state `s` of a run, where the code generator put them. -/
structure Rep (d : Design) (s : Drive) (mem : Int → Int) : Prop where
  /-- The block tables are where the data segment put them. -/
  tbl : ∀ j < 9, ∀ k < kindN, mem (tblAddr j k) = (tables.getD j massTbl) k
  /-- The grid holds the design. -/
  grid : ∀ i < gridN, mem (gridAddr i) = (d i : Int)
  /-- The accumulators hold the nine figures. -/
  acc : ∀ j < 9, mem (accAddr j) = statAt d j
  /-- And the first seven cells hold the state of the run. -/
  field : ∀ j : Nat, j < 7 → mem (8 * (j : Int)) = driveField s j

/-! ## Where things are -/

theorem accAddr_range {j : Nat} (hj : j < 9) : 64 ≤ accAddr j ∧ accAddr j ≤ 128 := by
  have : (j : Int) ≤ 8 := by exact_mod_cast Nat.lt_succ_iff.1 hj
  have h0 : (0 : Int) ≤ (j : Int) := Int.natCast_nonneg j
  constructor <;> simp only [accAddr, aACC] <;> omega

theorem gridAddr_range {i : Nat} (hi : i < gridN) : 256 ≤ gridAddr i ∧ gridAddr i ≤ 760 := by
  have : (i : Int) ≤ 63 := by
    have : i ≤ 63 := by simpa [gridN, gridW, gridH, gridD] using Nat.lt_succ_iff.1 hi
    exact_mod_cast this
  have h0 : (0 : Int) ≤ (i : Int) := Int.natCast_nonneg i
  constructor <;> simp only [gridAddr, aGRID] <;> omega

theorem tblAddr_range {j k : Nat} (hj : j < 9) (hk : k < kindN) :
    1024 ≤ tblAddr j k ∧ tblAddr j k ≤ 1600 := by
  have hj' : (j : Int) ≤ 8 := by exact_mod_cast Nat.lt_succ_iff.1 hj
  have hk' : (k : Int) ≤ 6 := by
    have : k ≤ 6 := by simpa [kindN] using Nat.lt_succ_iff.1 hk
    exact_mod_cast this
  have h0 : (0 : Int) ≤ (j : Int) := Int.natCast_nonneg j
  have h1 : (0 : Int) ≤ (k : Int) := Int.natCast_nonneg k
  constructor <;> simp only [tblAddr, aTBL] <;> omega

theorem field_range {j : Nat} (hj : j < 7) : 0 ≤ 8 * (j : Int) ∧ 8 * (j : Int) ≤ 48 := by
  have : (j : Int) ≤ 6 := by exact_mod_cast Nat.lt_succ_iff.1 hj
  have h0 : (0 : Int) ≤ (j : Int) := Int.natCast_nonneg j
  omega

/-- The eleven addresses the state and the scratch live at, as literals. -/
theorem addrs :
    aPOS = 0 ∧ aLANE = 8 ∧ aVEL = 16 ∧ aFUEL = 24 ∧ aLOAD = 32 ∧ aSCORE = 40 ∧
    aTICKS = 48 ∧ sVEL = 192 ∧ sRAW = 200 ∧ sLAP = 208 ∧ sPOS = 216 ∧ sLOAD = 224 := by
  refine ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, ?_, ?_, ?_, ?_, ?_⟩ <;>
    simp [sVEL, sRAW, sLAP, sPOS, sLOAD, scrAddr, aSCR]

/-! ## `stat` -/

/-- **`stat j` is the `j`th figure of the machine.** -/
theorem stat_correct {d : Design} {s : Drive} {mem : Int → Int} (h : Rep d s mem)
    {j : Nat} (hj : j < 9) : callFun statFun [(j : Int)] 0 mem = statAt d j := by
  refine callFun_of_computes ?_
  have hp : Computes [(j : Int)] mem p0 (j : Int) := Code.loc 0
  have hj0 : (0 : Int) ≤ (j : Int) := Int.natCast_nonneg j
  have hj9 : (j : Int) < 9 := by exact_mod_cast hj
  refine Code.ifE (p := true) ?_ (fun _ => ?_) (fun hcon => absurd hcon (by simp))
  · simpa [hj0, hj9] using
      Code.andE (Code.leE (Code.cst 0) hp) (Code.ltE hp (Code.cst 9))
  · have := Code.ldE (Code.addE (Code.cst aACC) (Code.mulE (Code.cst 8) hp))
    rwa [show aACC + 8 * (j : Int) = accAddr j from by simp [accAddr], h.acc j hj] at this

/-! ## `get` -/

/-- **`get j` is the `j`th field of the run.** -/
theorem get_correct {d : Design} {s : Drive} {mem : Int → Int} (h : Rep d s mem)
    {j : Nat} (hj : j < 7) : callFun getFun [(j : Int)] 0 mem = driveField s j := by
  refine callFun_of_computes ?_
  have hp : Computes [(j : Int)] mem p0 (j : Int) := Code.loc 0
  have hj0 : (0 : Int) ≤ (j : Int) := Int.natCast_nonneg j
  have hj7 : (j : Int) < 7 := by exact_mod_cast hj
  refine Code.ifE (p := true) ?_ (fun _ => ?_) (fun hcon => absurd hcon (by simp))
  · simpa [hj0, hj7] using
      Code.andE (Code.leE (Code.cst 0) hp) (Code.ltE hp (Code.cst 7))
  · have := Code.ldE (Code.mulE (Code.cst 8) hp)
    rwa [h.field j hj] at this

/-! ## `valid` -/

/-- **`valid ()` is the workshop rule.** -/
theorem valid_correct {d : Design} {s : Drive} {mem : Int → Int} (h : Rep d s mem) :
    callFun validFun [] 0 mem = ofBool (decide (Valid d)) := by
  refine callFun_of_computes ?_
  have h6 : mem (accAddr 6) = wheels d := h.acc 6 (by norm_num)
  have h7 : mem (accAddr 7) = engines d := h.acc 7 (by norm_num)
  have h8 : mem (accAddr 8) = tanks d := h.acc 8 (by norm_num)
  have h4 : mem (accAddr 4) = cost d := h.acc 4 (by norm_num)
  have key : Computes [] mem validFun
      (ofBool ((decide (2 ≤ mem (accAddr 6)) && decide (1 ≤ mem (accAddr 7))) &&
        (decide (1 ≤ mem (accAddr 8)) && decide (mem (accAddr 4) ≤ budget)))) :=
    Code.andE
      (Code.andE (Code.leE (Code.cst 2) (Code.ld (accAddr 6)))
        (Code.leE (Code.cst 1) (Code.ld (accAddr 7))))
      (Code.andE (Code.leE (Code.cst 1) (Code.ld (accAddr 8)))
        (Code.leE (Code.ld (accAddr 4)) (Code.cst budget)))
  rw [h6, h7, h8, h4] at key
  suffices hb : decide (Valid d) =
      ((decide (2 ≤ wheels d) && decide (1 ≤ engines d)) &&
        (decide (1 ≤ tanks d) && decide (cost d ≤ budget))) by
    rw [hb]; exact key
  simp [Valid, Bool.and_assoc]

/-! ## `reset` -/

/-- The memory `reset` leaves behind: the seven state cells rewritten, the
tank filled from the fifth accumulator, and nothing else touched. -/
def resetMem (d : Design) (mem : Int → Int) : Int → Int :=
  store1 (store1 (store1 (store1 (store1 (store1 (store1 mem aPOS 0) aLANE 0) aVEL 0)
    aFUEL (fuelCap d)) aLOAD 0) aSCORE 0) aTICKS 0

/-- `reset` touches nothing above the state cells. -/
theorem resetMem_high {d : Design} {mem : Int → Int} {x : Int} (hx : 48 < x) :
    resetMem d mem x = mem x := by
  simp only [resetMem, aPOS, aLANE, aVEL, aFUEL, aLOAD, aSCORE, aTICKS]
  rw [store1_other (by omega), store1_other (by omega), store1_other (by omega),
    store1_other (by omega), store1_other (by omega), store1_other (by omega),
    store1_other (by omega)]

/-- What `reset` runs to. -/
theorem reset_returns {d : Design} {s : Drive} {mem : Int → Int} (h : Rep d s mem) :
    Returns [] mem (resetMem d mem) resetFun 1 := by
  have hfuel : mem (accAddr 5) = fuelCap d := h.acc 5 (by norm_num)
  have h3 : (store1 (store1 (store1 mem aPOS 0) aLANE 0) aVEL 0) (accAddr 5) = fuelCap d := by
    rw [store1_other (by norm_num [accAddr, aACC, aVEL]),
      store1_other (by norm_num [accAddr, aACC, aLANE]),
      store1_other (by norm_num [accAddr, aACC, aPOS])]
    exact hfuel
  simp only [resetMem, resetFun]
  refine Returns.step ?_ (Returns.ofComputes (Code.cst 1))
  refine Effects.trans (Effects.trans (Effects.trans (Effects.trans (Effects.trans
    (Effects.trans (Code.putE (Code.cst 0)) (Code.putE (Code.cst 0)))
    (Code.putE (Code.cst 0))) ?_) (Code.putE (Code.cst 0))) (Code.putE (Code.cst 0)))
    (Code.putE (Code.cst 0))
  rw [← h3]
  exact Code.putE (Code.ld (accAddr 5))

/-- **`reset ()` puts the machine back on the line.** -/
theorem reset_correct {d : Design} {s : Drive} {mem : Int → Int} (h : Rep d s mem) :
    Rep d (startDrive (rigOf d)) (memAfter resetFun [] 0 mem) := by
  rw [memAfter_of_returns (reset_returns h)]
  refine ⟨fun j hj k hk => ?_, fun i hi => ?_, fun j hj => ?_, fun j hj => ?_⟩
  · rw [resetMem_high (by have := (tblAddr_range hj hk).1; omega)]; exact h.tbl j hj k hk
  · rw [resetMem_high (by have := (gridAddr_range hi).1; omega)]; exact h.grid i hi
  · rw [resetMem_high (by have := (accAddr_range hj).1; omega)]; exact h.acc j hj
  · interval_cases j <;>
      simp [resetMem, store1, driveField, startDrive, rigOf,
        aPOS, aLANE, aVEL, aFUEL, aLOAD, aSCORE, aTICKS]

/-! ## `place` -/

/-- The `j`th block table. -/
def tblOf (j : Nat) : Nat → Int := tables.getD j massTbl

/-- The memory after the first `n` of the nine accumulator updates. -/
def placeMem (d : Design) (i k : Nat) (mem : Int → Int) : Nat → (Int → Int)
  | 0 => mem
  | n + 1 => store1 (placeMem d i k mem n) (accAddr n)
      (statAt d n - tblOf n (d i) + tblOf n k)

/-- The updates touch only the accumulators they have reached. -/
theorem placeMem_out {d : Design} {i k : Nat} {mem : Int → Int} :
    ∀ (n : Nat) (x : Int), (x < 64 ∨ 64 + 8 * (n : Int) ≤ x) → placeMem d i k mem n x = mem x
  | 0, _, _ => rfl
  | n + 1, x, hx => by
      have hn : (0 : Int) ≤ (n : Int) := Int.natCast_nonneg n
      have hstep : x ≠ accAddr n := by
        simp only [accAddr, aACC]
        push_cast at hx ⊢
        omega
      rw [placeMem, store1_other hstep]
      refine placeMem_out n x ?_
      push_cast at hx ⊢
      omega

/-- An accumulator the updates have not reached yet still holds its old value. -/
theorem placeMem_acc_ge {d : Design} {i k : Nat} {mem : Int → Int} {n j : Nat} (hj : n ≤ j) :
    placeMem d i k mem n (accAddr j) = mem (accAddr j) := by
  refine placeMem_out n _ (Or.inr ?_)
  have : (n : Int) ≤ (j : Int) := by exact_mod_cast hj
  simp only [accAddr, aACC]
  omega

/-- And one they have passed holds the updated figure. -/
theorem placeMem_acc_lt {d : Design} {i k : Nat} {mem : Int → Int} :
    ∀ {n j : Nat}, j < n →
      placeMem d i k mem n (accAddr j) = statAt d j - tblOf j (d i) + tblOf j k
  | 0, _, hj => absurd hj (by omega)
  | n + 1, j, hj => by
      rcases Nat.lt_succ_iff_lt_or_eq.1 hj with hlt | rfl
      · have hne : accAddr j ≠ accAddr n := by
          have : (j : Int) ≠ (n : Int) := by exact_mod_cast Nat.ne_of_lt hlt
          simp only [accAddr, aACC]
          omega
        rw [placeMem, store1_other hne]
        exact placeMem_acc_lt hlt
      · rw [placeMem, store1_same]

/-- The nine accumulator updates, as an effect on the memory. -/
theorem place_acc_effects {d : Design} {s : Drive} {mem : Int → Int} (h : Rep d s mem)
    (hd : DesignOk d) {i k : Nat} (hi : i < gridN) (hk : k < kindN) :
    ∀ n ≤ 9, Effects [(i : Int), (k : Int)] mem (placeMem d i k mem n)
      ((List.range n).flatMap (fun j => putE (accAddr j) (accUpdE j)))
  | 0, _ => Effects.nil mem
  | n + 1, hn => by
      have hn9 : n < 9 := by omega
      set L : List Int := [(i : Int), (k : Int)] with hL
      set m := placeMem d i k mem n with hm
      have hdi : d i < kindN := hd i hi
      -- what the memory still says at this point
      have hgrid : m (gridAddr i) = (d i : Int) := by
        rw [hm, placeMem_out n _ (Or.inr ?_), h.grid i hi]
        have := (gridAddr_range hi).1
        have : (n : Int) ≤ 9 := by exact_mod_cast Nat.le_of_lt_succ (by omega : n < 10)
        have h2 := (gridAddr_range hi).1
        omega
      have hacc : m (accAddr n) = statAt d n := by
        rw [hm, placeMem_acc_ge le_rfl, h.acc n hn9]
      have htbl1 : m (tblAddr n (d i)) = tblOf n (d i) := by
        rw [hm, placeMem_out n _ (Or.inr ?_), h.tbl n hn9 (d i) hdi]
        · rfl
        · have h1 := (tblAddr_range hn9 hdi).1
          have h2 : (n : Int) ≤ 9 := by exact_mod_cast Nat.le_of_lt_succ (by omega : n < 10)
          omega
      have htbl2 : m (tblAddr n k) = tblOf n k := by
        rw [hm, placeMem_out n _ (Or.inr ?_), h.tbl n hn9 k hk]
        · rfl
        · have h1 := (tblAddr_range hn9 hk).1
          have h2 : (n : Int) ≤ 9 := by exact_mod_cast Nat.le_of_lt_succ (by omega : n < 10)
          omega
      -- the two parameters
      have hp0 : Computes L m p0 (i : Int) := Code.loc 0
      have hp1 : Computes L m p1 (k : Int) := Code.loc 1
      have hold : Computes L m oldKindE (d i : Int) := by
        have := Code.ldE (Code.addE (Code.cst aGRID) (Code.mulE (Code.cst 8) hp0))
        rwa [show aGRID + 8 * (i : Int) = gridAddr i from rfl, hgrid] at this
      have hupd : Computes L m (accUpdE n) (statAt d n - tblOf n (d i) + tblOf n k) := by
        have e1 : Computes L m (ldE (tblAddrE n oldKindE)) (tblOf n (d i)) := by
          have := Code.ldE (Code.addE (Code.cst (aTBL + 64 * (n : Int)))
            (Code.mulE (Code.cst 8) hold))
          rwa [show aTBL + 64 * (n : Int) + 8 * ((d i : Nat) : Int) = tblAddr n (d i) from rfl,
            htbl1] at this
        have e2 : Computes L m (ldE (tblAddrE n p1)) (tblOf n k) := by
          have := Code.ldE (Code.addE (Code.cst (aTBL + 64 * (n : Int)))
            (Code.mulE (Code.cst 8) hp1))
          rwa [show aTBL + 64 * (n : Int) + 8 * ((k : Nat) : Int) = tblAddr n k from rfl,
            htbl2] at this
        have e0 : Computes L m (ld (accAddr n)) (statAt d n) := by
          rw [← hacc]; exact Code.ld _
        exact Code.addE (Code.subE e0 e1) e2
      rw [List.range_succ, List.flatMap_append]
      refine Effects.trans (place_acc_effects h hd hi hk n (by omega)) ?_
      simpa using Code.putE hupd

/-- **`place i k` puts a block in a cell** and keeps the nine figures right,
without looking at any other cell. -/
theorem place_correct {d : Design} {s : Drive} {mem : Int → Int} (h : Rep d s mem)
    (hd : DesignOk d) {i k : Nat} (hi : i < gridN) (hk : k < kindN) :
    Rep (place d i k) s (memAfter placeFun [(i : Int), (k : Int)] 0 mem) := by
  set L : List Int := [(i : Int), (k : Int)] with hL
  have hbody : Effects L mem (store1 (placeMem d i k mem 9) (gridAddr i) (k : Int)) placeBody := by
    refine Effects.trans (place_acc_effects h hd hi hk 9 le_rfl) ?_
    have hp0 : Computes L (placeMem d i k mem 9) p0 (i : Int) := Code.loc 0
    have hp1 : Computes L (placeMem d i k mem 9) p1 (k : Int) := Code.loc 1
    exact Code.putAtE (Code.addE (Code.cst aGRID) (Code.mulE (Code.cst 8) hp0)) hp1
  have hi' : (i : Int) < 64 := by
    have : i < 64 := by simpa [gridN, gridW, gridH, gridD] using hi
    exact_mod_cast this
  have hk' : (k : Int) < 7 := by
    have : k < 7 := by simpa [kindN] using hk
    exact_mod_cast this
  have hi0 : (0 : Int) ≤ (i : Int) := Int.natCast_nonneg i
  have hk0 : (0 : Int) ≤ (k : Int) := Int.natCast_nonneg k
  have hguard : Computes L mem placeGuard (ofBool true) := by
    have hp0 : Computes L mem p0 (i : Int) := Code.loc 0
    have hp1 : Computes L mem p1 (k : Int) := Code.loc 1
    simpa [hi0, hi', hk0, hk'] using
      Code.andE (Code.andE (Code.leE (Code.cst 0) hp0) (Code.ltE hp0 (Code.cst 64)))
        (Code.andE (Code.leE (Code.cst 0) hp1) (Code.ltE hp1 (Code.cst 7)))
  have hrun : Returns L mem (store1 (placeMem d i k mem 9) (gridAddr i) (k : Int)) placeFun 1 := by
    intro s'
    simpa using computes_guarded hguard (fun _ => hbody) (fun hc => absurd hc (by simp)) s'
  rw [memAfter_of_returns hrun]
  have hgrid_lo := (gridAddr_range hi).1
  have hgrid_hi := (gridAddr_range hi).2
  refine ⟨fun j hj k' hk' => ?_, fun i' hi'' => ?_, fun j hj => ?_, fun j hj => ?_⟩
  · have h1 := (tblAddr_range hj hk').1
    rw [store1_other (by omega), placeMem_out 9 _ (Or.inr (by push_cast; omega))]
    exact h.tbl j hj k' hk'
  · have h2 := (gridAddr_range hi'').1
    by_cases he : i' = i
    · subst he; rw [store1_same, place_same]
    · have hne : gridAddr i' ≠ gridAddr i := by
        have : (i' : Int) ≠ (i : Int) := by exact_mod_cast he
        simp only [gridAddr, aGRID]
        omega
      rw [store1_other hne, placeMem_out 9 _ (Or.inr (by push_cast; omega)),
        h.grid i' hi'', place_other he]
  · have h3 := (accAddr_range hj).2
    rw [store1_other (by omega), placeMem_acc_lt hj]
    rw [statAt_eq hj, statAt_eq hj (place d i k)]
    simp only [tblOf]
    exact (statOf_place (tables.getD j massTbl) d hi k).symm
  · have h4 := (field_range hj).2
    rw [store1_other (by omega), placeMem_out 9 _ (Or.inl (by omega))]
    exact h.field j hj

/-! ## `tick`

`Drive.tick` is a chain of `let`s; the module writes the same chain into twelve
words of memory, five of them scratch.  To compare the two, the pieces of the
rule book's chain are named here (`tTh` … `tLoad`), `tick_eq` says the names are
the rule book (it is `rfl`), each little piece of generated code is shown to
compute its piece (`velE_computes` and the rest), and `tick_returns` puts the
twelve stores together into the memory the call leaves behind.
-/

/-- The four arguments the page passes to `tick`. -/
def tickArgs (u : Input) : List Int := [u.throttle, u.steer, ofBool u.scoop, ofBool u.brake]

/-- The throttle, clamped. -/
def tTh (u : Input) : Int := clampTo 1000 u.throttle
/-- The steering, clamped. -/
def tSt (u : Input) : Int := clampTo 1000 u.steer
/-- One while there is fuel in the tank. -/
def tLive (s : Drive) : Int := if 0 < s.fuel then 1 else 0
/-- The thrust. -/
def tDrive (d : Design) (u : Input) (s : Drive) : Int :=
  tLive s * (power d * tTh u).tdiv 1000
/-- Drag, and the brake. -/
def tResist (u : Input) (s : Drive) : Int :=
  dragK * s.vel + (if u.brake then brakeK * s.vel else 0)
/-- The mass the thrust has to shift. -/
def tMtot (d : Design) (s : Drive) : Int := mass d + 10 * s.load + 1
/-- The new speed. -/
def tVel (d : Design) (u : Input) (s : Drive) : Int :=
  clampTo vmax (s.vel + (tDrive d u s - tResist u s).tdiv (tMtot d s))
/-- The new line. -/
def tLane (d : Design) (u : Input) (s : Drive) : Int :=
  clampTo laneMax (s.lane + clampTo (grip d) ((tSt u * tVel d u s).tdiv 20000))
/-- The position before the lap is taken off. -/
def tRaw (d : Design) (u : Input) (s : Drive) : Int := s.pos + (tVel d u s).tdiv tickHz
/-- The new position. -/
def tPos (d : Design) (u : Input) (s : Drive) : Int :=
  if track ≤ tRaw d u s then tRaw d u s - track
  else if tRaw d u s < 0 then tRaw d u s + track else tRaw d u s
/-- The fuel burnt. -/
def tBurn (u : Input) (s : Drive) : Int :=
  tLive s * ((if tTh u < 0 then -tTh u else tTh u) + 200).tdiv 200
/-- The fuel left. -/
def tFuel (u : Input) (s : Drive) : Int := max 0 (s.fuel - tBurn u s)
/-- Is the scoop taking a bale? -/
def tPick (d : Design) (u : Input) (s : Drive) : Bool :=
  u.scoop && decide (zoneLo ≤ tPos d u s) && decide (tPos d u s ≤ zoneHi) &&
    decide (|tLane d u s| ≤ zoneLane)
/-- The load, before the line empties the scoop. -/
def tLoad1 (d : Design) (u : Input) (s : Drive) : Int :=
  if tPick d u s then min (cap d) (s.load + bite) else s.load
/-- The score. -/
def tScore (d : Design) (u : Input) (s : Drive) : Int :=
  if track ≤ tRaw d u s then s.score + 10 * tLoad1 d u s else s.score
/-- The load. -/
def tLoad (d : Design) (u : Input) (s : Drive) : Int :=
  if track ≤ tRaw d u s then 0 else tLoad1 d u s

/-- The rule book's own tick, in those names. -/
theorem tick_eq (d : Design) (u : Input) (s : Drive) :
    tick (rigOf d) u s =
      ⟨tPos d u s, tLane d u s, tVel d u s, tFuel u s, tLoad d u s, tScore d u s, s.ticks + 1⟩ :=
  rfl

/-! ## The addresses, as literals -/

theorem sVEL_eq : sVEL = 192 := by simp [sVEL, scrAddr, aSCR]
theorem sRAW_eq : sRAW = 200 := by simp [sRAW, scrAddr, aSCR]
theorem sLAP_eq : sLAP = 208 := by simp [sLAP, scrAddr, aSCR]
theorem sPOS_eq : sPOS = 216 := by simp [sPOS, scrAddr, aSCR]
theorem sLOAD_eq : sLOAD = 224 := by simp [sLOAD, scrAddr, aSCR]

theorem acc0_eq : accAddr 0 = 64 := by simp [accAddr, aACC]
theorem acc1_eq : accAddr 1 = 72 := by simp [accAddr, aACC]
theorem acc2_eq : accAddr 2 = 80 := by simp [accAddr, aACC]
theorem acc3_eq : accAddr 3 = 88 := by simp [accAddr, aACC]

/-! ## The arguments the page passes -/

theorem loc_th (u : Input) : (tickArgs u).getD 0 0 = u.throttle := rfl
theorem loc_st (u : Input) : (tickArgs u).getD 1 0 = u.steer := rfl
theorem loc_scoop (u : Input) : (tickArgs u).getD 2 0 = ofBool u.scoop := rfl
theorem loc_brake (u : Input) : (tickArgs u).getD 3 0 = ofBool u.brake := rfl

/-! ## What each piece of `tick` computes -/

section Pieces

variable {d : Design} {u : Input} {s : Drive} {M : Int → Int}

theorem thE_computes : Computes (tickArgs u) M thE (tTh u) := by
  rw [tTh, thE]
  exact Code.clampCE (by norm_num) (by rw [← loc_th u]; exact Code.loc 0)

theorem stE_computes : Computes (tickArgs u) M stE (tSt u) := by
  rw [tSt, stE]
  exact Code.clampCE (by norm_num) (by rw [← loc_st u]; exact Code.loc 1)

theorem liveE_computes (hf : M aFUEL = s.fuel) : Computes (tickArgs u) M liveE (tLive s) := by
  refine Code.ifE (p := decide (0 < s.fuel)) ?_ (fun hp => ?_) (fun hp => ?_)
  · rw [← hf]; exact Code.ltE (Code.cst 0) (Code.ld aFUEL)
  · rw [tLive, if_pos (of_decide_eq_true hp)]; exact Code.cst 1
  · rw [tLive, if_neg (of_decide_eq_false hp)]; exact Code.cst 0

theorem driveE_computes (hf : M aFUEL = s.fuel) (hp : M (accAddr 1) = power d) :
    Computes (tickArgs u) M driveE (tDrive d u s) := by
  rw [tDrive, driveE]
  exact Code.mulE (liveE_computes hf)
    (Code.divE (Code.mulE (by rw [← hp]; exact Code.ld _) thE_computes) (Code.cst 1000))

theorem resistE_computes (hv : M aVEL = s.vel) :
    Computes (tickArgs u) M resistE (tResist u s) := by
  rw [tResist, resistE]
  refine Code.addE (by rw [← hv]; exact Code.mulE (Code.cst dragK) (Code.ld aVEL)) ?_
  refine Code.ifE (p := u.brake) (by rw [← loc_brake u]; exact Code.loc 3)
    (fun hp => ?_) (fun hp => ?_)
  · rw [if_pos hp, ← hv]; exact Code.mulE (Code.cst brakeK) (Code.ld aVEL)
  · rw [if_neg (by simp [hp])]; exact Code.cst 0

theorem mtotE_computes (hm : M (accAddr 0) = mass d) (hl : M aLOAD = s.load) :
    Computes (tickArgs u) M mtotE (tMtot d s) := by
  rw [tMtot, mtotE]
  exact Code.addE (Code.addE (by rw [← hm]; exact Code.ld _)
    (by rw [← hl]; exact Code.mulE (Code.cst 10) (Code.ld aLOAD))) (Code.cst 1)

theorem velE_computes (hv : M aVEL = s.vel) (hf : M aFUEL = s.fuel) (hl : M aLOAD = s.load)
    (hm : M (accAddr 0) = mass d) (hp : M (accAddr 1) = power d) :
    Computes (tickArgs u) M velE (tVel d u s) := by
  rw [tVel, velE]
  exact Code.clampCE (by norm_num [vmax])
    (Code.addE (by rw [← hv]; exact Code.ld aVEL)
      (Code.divE (Code.subE (driveE_computes hf hp) (resistE_computes hv))
        (mtotE_computes hm hl)))

theorem laneE_computes (hg0 : 0 ≤ grip d) (hlane : M aLANE = s.lane)
    (hg : M (accAddr 2) = grip d) (hsv : M sVEL = tVel d u s) :
    Computes (tickArgs u) M laneE (tLane d u s) := by
  rw [tLane, laneE]
  refine Code.clampCE (by norm_num [laneMax]) (Code.addE (by rw [← hlane]; exact Code.ld aLANE) ?_)
  refine Code.clampE hg0 (by rw [← hg]; exact Code.ld _) ?_
  exact Code.divE (Code.mulE stE_computes (by rw [← hsv]; exact Code.ld sVEL)) (Code.cst 20000)

theorem rawE_computes (hpos : M aPOS = s.pos) (hsv : M sVEL = tVel d u s) :
    Computes (tickArgs u) M rawE (tRaw d u s) := by
  rw [tRaw, rawE]
  exact Code.addE (by rw [← hpos]; exact Code.ld aPOS)
    (Code.divE (by rw [← hsv]; exact Code.ld sVEL) (Code.cst tickHz))

theorem lapE_computes (hraw : M sRAW = tRaw d u s) :
    Computes (tickArgs u) M lapE (ofBool (decide (track ≤ tRaw d u s))) := by
  rw [← hraw]; exact Code.leE (Code.cst track) (Code.ld sRAW)

theorem posE_computes (hlap : M sLAP = ofBool (decide (track ≤ tRaw d u s)))
    (hraw : M sRAW = tRaw d u s) : Computes (tickArgs u) M posE (tPos d u s) := by
  refine Code.ifE (p := decide (track ≤ tRaw d u s)) (by rw [← hlap]; exact Code.ld sLAP)
    (fun hp => ?_) (fun hp => ?_)
  · rw [tPos, if_pos (of_decide_eq_true hp), ← hraw]
    exact Code.subE (Code.ld sRAW) (Code.cst track)
  · rw [tPos, if_neg (of_decide_eq_false hp)]
    refine Code.ifE (p := decide (tRaw d u s < 0))
      (by rw [← hraw]; exact Code.ltE (Code.ld sRAW) (Code.cst 0)) (fun hq => ?_) (fun hq => ?_)
    · rw [if_pos (of_decide_eq_true hq), ← hraw]
      exact Code.addE (Code.ld sRAW) (Code.cst track)
    · rw [if_neg (of_decide_eq_false hq), ← hraw]
      exact Code.ld sRAW

theorem burnE_computes (hf : M aFUEL = s.fuel) :
    Computes (tickArgs u) M burnE (tBurn u s) := by
  have habs : |tTh u| = if tTh u < 0 then -tTh u else tTh u := by
    split_ifs with h
    · exact abs_of_neg h
    · exact abs_of_nonneg (not_lt.1 h)
  rw [tBurn, burnE, ← habs]
  exact Code.mulE (liveE_computes hf)
    (Code.divE (Code.addE (Code.absE thE_computes) (Code.cst 200)) (Code.cst 200))

theorem fuelE_computes (hf : M aFUEL = s.fuel) :
    Computes (tickArgs u) M fuelE (tFuel u s) := by
  rw [tFuel, fuelE]
  exact Code.max0E (Code.subE (by rw [← hf]; exact Code.ld aFUEL) (burnE_computes hf))

theorem pickE_computes (hsp : M sPOS = tPos d u s) (hlane : M aLANE = tLane d u s) :
    Computes (tickArgs u) M pickE (ofBool (tPick d u s)) := by
  have h1 : Computes (tickArgs u) M pSCOOP (ofBool u.scoop) := by
    rw [← loc_scoop u]; exact Code.loc 2
  have h2 : Computes (tickArgs u) M (leE (cst zoneLo) (ld sPOS))
      (ofBool (decide (zoneLo ≤ tPos d u s))) := by
    rw [← hsp]; exact Code.leE (Code.cst zoneLo) (Code.ld sPOS)
  have h3 : Computes (tickArgs u) M (leE (ld sPOS) (cst zoneHi))
      (ofBool (decide (tPos d u s ≤ zoneHi))) := by
    rw [← hsp]; exact Code.leE (Code.ld sPOS) (Code.cst zoneHi)
  have h4 : Computes (tickArgs u) M (leE (absE (ld aLANE)) (cst zoneLane))
      (ofBool (decide (|tLane d u s| ≤ zoneLane))) := by
    rw [← hlane]; exact Code.leE (Code.absE (Code.ld aLANE)) (Code.cst zoneLane)
  have key := Code.andE (Code.andE h1 h2) (Code.andE h3 h4)
  rw [show tPick d u s = ((u.scoop && decide (zoneLo ≤ tPos d u s)) &&
      (decide (tPos d u s ≤ zoneHi) && decide (|tLane d u s| ≤ zoneLane))) from
    by simp [tPick, Bool.and_assoc]]
  exact key

theorem load1E_computes (hsp : M sPOS = tPos d u s) (hlane : M aLANE = tLane d u s)
    (hc : M (accAddr 3) = cap d) (hl : M aLOAD = s.load) :
    Computes (tickArgs u) M load1E (tLoad1 d u s) := by
  refine Code.ifE (p := tPick d u s) (pickE_computes hsp hlane) (fun hp => ?_) (fun hp => ?_)
  · rw [tLoad1, if_pos hp]
    exact Code.minE (by rw [← hc]; exact Code.ld _)
      (by rw [← hl]; exact Code.addE (Code.ld aLOAD) (Code.cst bite))
  · rw [tLoad1, if_neg (by simp [hp]), ← hl]
    exact Code.ld aLOAD

theorem scoreE_computes (hlap : M sLAP = ofBool (decide (track ≤ tRaw d u s)))
    (hsc : M aSCORE = s.score) (hsl : M sLOAD = tLoad1 d u s) :
    Computes (tickArgs u) M scoreE (tScore d u s) := by
  refine Code.ifE (p := decide (track ≤ tRaw d u s)) (by rw [← hlap]; exact Code.ld sLAP)
    (fun hp => ?_) (fun hp => ?_)
  · rw [tScore, if_pos (of_decide_eq_true hp), ← hsc, ← hsl]
    exact Code.addE (Code.ld aSCORE) (Code.mulE (Code.cst 10) (Code.ld sLOAD))
  · rw [tScore, if_neg (of_decide_eq_false hp), ← hsc]
    exact Code.ld aSCORE

theorem loadE_computes (hlap : M sLAP = ofBool (decide (track ≤ tRaw d u s)))
    (hsl : M sLOAD = tLoad1 d u s) : Computes (tickArgs u) M loadE (tLoad d u s) := by
  refine Code.ifE (p := decide (track ≤ tRaw d u s)) (by rw [← hlap]; exact Code.ld sLAP)
    (fun hp => ?_) (fun hp => ?_)
  · rw [tLoad, if_pos (of_decide_eq_true hp)]; exact Code.cst 0
  · rw [tLoad, if_neg (of_decide_eq_false hp), ← hsl]; exact Code.ld sLOAD

theorem ticksE_computes (hT : M aTICKS = s.ticks) :
    Computes (tickArgs u) M (addE (ld aTICKS) (cst 1)) (s.ticks + 1) := by
  rw [← hT]; exact Code.addE (Code.ld aTICKS) (Code.cst 1)

theorem ldPos_computes (hT : M sPOS = tPos d u s) :
    Computes (tickArgs u) M (ld sPOS) (tPos d u s) := by
  rw [← hT]; exact Code.ld sPOS

theorem ldVel_computes (hT : M sVEL = tVel d u s) :
    Computes (tickArgs u) M (ld sVEL) (tVel d u s) := by
  rw [← hT]; exact Code.ld sVEL

end Pieces

/-! ## The memory one tick leaves -/

/-- Applying a list of stores, in order. -/
def applyStores (mem : Int → Int) : List (Int × Int) → (Int → Int)
  | [] => mem
  | (a, v) :: r => applyStores (store1 mem a v) r

/-- The twelve words one tick writes, in the order it writes them. -/
def tickStores (d : Design) (u : Input) (s : Drive) : List (Int × Int) :=
  [(sVEL, tVel d u s), (aLANE, tLane d u s), (sRAW, tRaw d u s),
   (sLAP, ofBool (decide (track ≤ tRaw d u s))), (sPOS, tPos d u s), (aFUEL, tFuel u s),
   (sLOAD, tLoad1 d u s), (aSCORE, tScore d u s), (aLOAD, tLoad d u s),
   (aPOS, tPos d u s), (aVEL, tVel d u s), (aTICKS, s.ticks + 1)]

/-- The memory one tick leaves behind. -/
def tickMem (d : Design) (u : Input) (s : Drive) (mem : Int → Int) : Int → Int :=
  applyStores mem (tickStores d u s)

theorem tick_returns {d : Design} {s : Drive} {mem : Int → Int} (h : Rep d s mem) (u : Input) :
    Returns (tickArgs u) mem (tickMem d u s mem) tickFun 1 := by
  have hpos : mem aPOS = s.pos := by simpa [aPOS, driveField] using h.field 0 (by norm_num)
  have hlane : mem aLANE = s.lane := by simpa [aLANE, driveField] using h.field 1 (by norm_num)
  have hvel : mem aVEL = s.vel := by simpa [aVEL, driveField] using h.field 2 (by norm_num)
  have hfuel : mem aFUEL = s.fuel := by simpa [aFUEL, driveField] using h.field 3 (by norm_num)
  have hload : mem aLOAD = s.load := by simpa [aLOAD, driveField] using h.field 4 (by norm_num)
  have hscore : mem aSCORE = s.score := by simpa [aSCORE, driveField] using h.field 5 (by norm_num)
  have hticks : mem aTICKS = s.ticks := by simpa [aTICKS, driveField] using h.field 6 (by norm_num)
  have hmass : mem (accAddr 0) = mass d := h.acc 0 (by norm_num)
  have hpow : mem (accAddr 1) = power d := h.acc 1 (by norm_num)
  have hgrip : mem (accAddr 2) = grip d := h.acc 2 (by norm_num)
  have hcap : mem (accAddr 3) = cap d := h.acc 3 (by norm_num)
  have hg0 : 0 ≤ grip d := statOf_nonneg (by simp [tables]) d
  have nhpos : mem 0 = s.pos := by simpa [aPOS] using hpos
  have nhlane : mem 8 = s.lane := by simpa [aLANE] using hlane
  have nhvel : mem 16 = s.vel := by simpa [aVEL] using hvel
  have nhfuel : mem 24 = s.fuel := by simpa [aFUEL] using hfuel
  have nhload : mem 32 = s.load := by simpa [aLOAD] using hload
  have nhscore : mem 40 = s.score := by simpa [aSCORE] using hscore
  have nhticks : mem 48 = s.ticks := by simpa [aTICKS] using hticks
  have nhmass : mem 64 = mass d := by simpa [acc0_eq] using hmass
  have nhpow : mem 72 = power d := by simpa [acc1_eq] using hpow
  have nhgrip : mem 80 = grip d := by simpa [acc2_eq] using hgrip
  have nhcap : mem 88 = cap d := by simpa [acc3_eq] using hcap
  refine Returns.step ?_ (Returns.ofComputes (Code.cst 1))
  simp only [tickMem, tickStores, applyStores]
  set M1 := store1 mem sVEL (tVel d u s) with hM1
  set M2 := store1 M1 aLANE (tLane d u s) with hM2
  set M3 := store1 M2 sRAW (tRaw d u s) with hM3
  set M4 := store1 M3 sLAP (ofBool (decide (track ≤ tRaw d u s))) with hM4
  set M5 := store1 M4 sPOS (tPos d u s) with hM5
  set M6 := store1 M5 aFUEL (tFuel u s) with hM6
  set M7 := store1 M6 sLOAD (tLoad1 d u s) with hM7
  set M8 := store1 M7 aSCORE (tScore d u s) with hM8
  set M9 := store1 M8 aLOAD (tLoad d u s) with hM9
  set M10 := store1 M9 aPOS (tPos d u s) with hM10
  set M11 := store1 M10 aVEL (tVel d u s) with hM11
  set M12 := store1 M11 aTICKS (s.ticks + 1) with hM12
  have e1 : Effects (tickArgs u) mem M1 (putE sVEL velE) := by
    rw [hM1]
    exact Code.putE (velE_computes hvel hfuel hload hmass hpow)
  have e2 : Effects (tickArgs u) M1 M2 (putE aLANE laneE) := by
    rw [hM2]
    exact Code.putE (laneE_computes hg0
      (by simp [hM1, aLANE, sVEL_eq, nhlane])
      (by simp [hM1, sVEL_eq, acc2_eq, nhgrip])
      (by simp [hM1, sVEL_eq]))
  have e3 : Effects (tickArgs u) M2 M3 (putE sRAW rawE) := by
    rw [hM3]
    exact Code.putE (rawE_computes
      (by simp [hM1, hM2, store1, aPOS, aLANE, sVEL_eq, nhpos])
      (by simp [hM1, hM2, store1, aLANE, sVEL_eq]))
  have e4 : Effects (tickArgs u) M3 M4 (putE sLAP lapE) := by
    rw [hM4]
    exact Code.putE (lapE_computes (by simp [hM1, hM2, hM3, aLANE, sVEL_eq, sRAW_eq]))
  have e5 : Effects (tickArgs u) M4 M5 (putE sPOS posE) := by
    rw [hM5]
    exact Code.putE (posE_computes
      (by simp [hM1, hM2, hM3, hM4, aLANE, sVEL_eq, sRAW_eq, sLAP_eq])
      (by simp [hM1, hM2, hM3, hM4, store1, aLANE, sVEL_eq, sRAW_eq, sLAP_eq]))
  have e6 : Effects (tickArgs u) M5 M6 (putE aFUEL fuelE) := by
    rw [hM6]
    exact Code.putE (fuelE_computes (by simp [hM1, hM2, hM3, hM4, hM5, store1, aLANE, aFUEL,
      sVEL_eq, sRAW_eq, sLAP_eq, sPOS_eq, nhfuel]))
  have e7 : Effects (tickArgs u) M6 M7 (putE sLOAD load1E) := by
    rw [hM7]
    exact Code.putE (load1E_computes
      (by simp [hM1, hM2, hM3, hM4, hM5, hM6, store1, aLANE, aFUEL, sVEL_eq, sRAW_eq, sLAP_eq,
        sPOS_eq])
      (by simp [hM1, hM2, hM3, hM4, hM5, hM6, store1, aLANE, aFUEL, sVEL_eq, sRAW_eq, sLAP_eq,
        sPOS_eq])
      (by simp [hM1, hM2, hM3, hM4, hM5, hM6, store1, aLANE, aFUEL, sVEL_eq, sRAW_eq, sLAP_eq,
        sPOS_eq, acc3_eq, nhcap])
      (by simp [hM1, hM2, hM3, hM4, hM5, hM6, store1, aLANE, aFUEL, aLOAD, sVEL_eq, sRAW_eq,
        sLAP_eq, sPOS_eq, nhload]))
  have e8 : Effects (tickArgs u) M7 M8 (putE aSCORE scoreE) := by
    rw [hM8]
    exact Code.putE (scoreE_computes
      (by simp [hM1, hM2, hM3, hM4, hM5, hM6, hM7, store1, aLANE, aFUEL, sVEL_eq, sRAW_eq,
        sLAP_eq, sPOS_eq, sLOAD_eq])
      (by simp [hM1, hM2, hM3, hM4, hM5, hM6, hM7, store1, aLANE, aFUEL, aSCORE, sVEL_eq, sRAW_eq,
        sLAP_eq, sPOS_eq, sLOAD_eq, nhscore])
      (by simp [hM1, hM2, hM3, hM4, hM5, hM6, hM7, aLANE, aFUEL, sVEL_eq, sRAW_eq, sLAP_eq,
        sPOS_eq, sLOAD_eq]))
  have e9 : Effects (tickArgs u) M8 M9 (putE aLOAD loadE) := by
    rw [hM9]
    exact Code.putE (loadE_computes
      (by simp [hM1, hM2, hM3, hM4, hM5, hM6, hM7, hM8, store1, aLANE, aFUEL, aSCORE, sVEL_eq,
        sRAW_eq, sLAP_eq, sPOS_eq, sLOAD_eq])
      (by simp [hM1, hM2, hM3, hM4, hM5, hM6, hM7, hM8, store1, aLANE, aFUEL, aSCORE, sVEL_eq,
        sRAW_eq, sLAP_eq, sPOS_eq, sLOAD_eq]))
  have e10 : Effects (tickArgs u) M9 M10 (putE aPOS (ld sPOS)) := by
    rw [hM10]
    exact Code.putE (ldPos_computes (by simp [hM1, hM2, hM3, hM4, hM5, hM6, hM7, hM8, hM9, store1,
      aLANE, aFUEL, aLOAD, aSCORE, sVEL_eq, sRAW_eq, sLAP_eq, sPOS_eq, sLOAD_eq]))
  have e11 : Effects (tickArgs u) M10 M11 (putE aVEL (ld sVEL)) := by
    rw [hM11]
    exact Code.putE (ldVel_computes (by simp [hM1, hM2, hM3, hM4, hM5, hM6, hM7, hM8, hM9, hM10,
      store1, aPOS, aLANE, aFUEL, aLOAD, aSCORE, sVEL_eq, sRAW_eq, sLAP_eq, sPOS_eq, sLOAD_eq]))
  have e12 : Effects (tickArgs u) M11 M12 (putE aTICKS (addE (ld aTICKS) (cst 1))) := by
    rw [hM12]
    exact Code.putE (ticksE_computes (by simp [hM1, hM2, hM3, hM4, hM5, hM6, hM7, hM8, hM9, hM10,
      hM11, store1, aPOS, aLANE, aVEL, aFUEL, aLOAD, aSCORE, aTICKS, sVEL_eq, sRAW_eq, sLAP_eq,
      sPOS_eq, sLOAD_eq, nhticks]))
  exact (Effects.trans (Effects.trans (Effects.trans (Effects.trans (Effects.trans (Effects.trans
    (Effects.trans (Effects.trans (Effects.trans (Effects.trans (Effects.trans e1 e2) e3) e4) e5)
    e6) e7) e8) e9) e10) e11) e12)

/-- Nothing above the state cells and the scratch is touched. -/
theorem tickMem_other {d : Design} {u : Input} {s : Drive} {mem : Int → Int} {x : Int}
    (h1 : 64 ≤ x) (h2 : x < 192 ∨ 224 < x) : tickMem d u s mem x = mem x := by
  simp only [tickMem, tickStores, applyStores, aPOS, aLANE, aVEL, aFUEL, aLOAD, aSCORE, aTICKS,
    sVEL_eq, sRAW_eq, sLAP_eq, sPOS_eq, sLOAD_eq]
  rw [store1_other (by omega), store1_other (by omega), store1_other (by omega),
    store1_other (by omega), store1_other (by omega), store1_other (by omega),
    store1_other (by omega), store1_other (by omega), store1_other (by omega),
    store1_other (by omega), store1_other (by omega), store1_other (by omega)]

/-- **One tick of the module is one tick of the rule book.** -/
theorem tick_correct {d : Design} {s : Drive} {mem : Int → Int} (h : Rep d s mem) (u : Input) :
    Rep d (tick (rigOf d) u s) (memAfter tickFun (tickArgs u) 0 mem) := by
  rw [memAfter_of_returns (tick_returns h u)]
  refine ⟨fun j hj k hk => ?_, fun i hi => ?_, fun j hj => ?_, fun j hj => ?_⟩
  · have hlo := (tblAddr_range hj hk).1
    rw [tickMem_other (by omega) (Or.inr (by omega))]
    exact h.tbl j hj k hk
  · have hlo := (gridAddr_range hi).1
    rw [tickMem_other (by omega) (Or.inr (by omega))]
    exact h.grid i hi
  · have hlo := (accAddr_range hj).1
    have hhi := (accAddr_range hj).2
    rw [tickMem_other (by omega) (Or.inl (by omega))]
    exact h.acc j hj
  · rw [tick_eq]
    interval_cases j <;>
      norm_num [tickMem, tickStores, applyStores, store1, driveField, aPOS, aLANE, aVEL, aFUEL,
        aLOAD, aSCORE, aTICKS, sVEL_eq, sRAW_eq, sLAP_eq, sPOS_eq, sLOAD_eq]

end Rig
end LifeTrac
