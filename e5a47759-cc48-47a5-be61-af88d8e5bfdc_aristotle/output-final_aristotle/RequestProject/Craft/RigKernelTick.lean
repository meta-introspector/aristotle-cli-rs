import RequestProject.Craft.RigKernelSpec
import RequestProject.Craft.RigVMAt

/-!
# What one call of `tick` does to memory

`tick` is the one function of the kernel that divides by a number it read out of
memory (the rig's mass), so its meaning is only fixed over memories where that
number is not zero: everything here is stated with the relative `PushesAt` /
`RunsAt` of `RequestProject/RigVMAt.lean`.

The file works out, once and for all, the ten locals `tick` computes and the eight
state words it writes, as explicit functions of the memory it was handed and the
joystick input (`mGrnd` … `mCrash`, `tickMem`), and proves

* `runs_tickLive` — the body of a live tick leaves memory `tickMem`;
* `tick_mem` — a whole call of `tick` leaves `tickMem`, or memory untouched if the
  rig is already wrecked.

`RequestProject/RigKernelTickSpec.lean` then matches `tickMem` against `Rig.step`.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace RigKernel

open RigVM Rig

/-! ## The relative combinators, at the kernel's level -/

theorem pushesAt_cst (m : Mem) {n : Nat} (h : n < W32) : PushesAt m (cst n) (fun _ => n) :=
  Pushes.at m (pushes_cst h)

theorem pushesAt_lget (m : Mem) (i : Nat) : PushesAt m (lget i) (fun st => st.get i) :=
  Pushes.at m (pushes_lget i)

theorem pushesAt_wLoad (m : Mem) (a : Nat) : PushesAt m (wLoad a) (fun _ => m.word a) :=
  (Pushes.at m (pushes_wLoad a)).congr (fun _ h => by rw [h])

theorem pushesAt_bLoad {m : Mem} {e : List Instr} {fe : Store → Nat} (he : PushesAt m e fe) :
    PushesAt m (bLoad e) (fun st => m.byte (fe st)) :=
  (PushesAt.load8 he 0).congr (fun _ h => by simp [h])

theorem pushesAt_op {m : Mem} {o : Bin} {a b : List Instr} {fa fb : Store → Nat}
    (ha : PushesAt m a fa) (hb : PushesAt m b fb)
    (hz : ∀ st : Store, st.mem = m → o.divides = true → fb st ≠ 0) :
    PushesAt m (op o a b) (fun st => o.eval (fa st) (fb st)) :=
  PushesAt.bin o ha hb hz

theorem pushesAt_op' {m : Mem} {o : Bin} {a b : List Instr} {fa fb : Store → Nat}
    (ha : PushesAt m a fa) (hb : PushesAt m b fb) (hz : o.divides = false) :
    PushesAt m (op o a b) (fun st => o.eval (fa st) (fb st)) :=
  PushesAt.bin o ha hb (fun _ _ h => by rw [hz] at h; exact absurd h (by simp))

theorem pushesAt_sel {m : Mem} {x y k : List Instr} {fx fy fk : Store → Nat}
    (hx : PushesAt m x fx) (hy : PushesAt m y fy) (hk : PushesAt m k fk) :
    PushesAt m (sel x y k) (fun st => if fk st = 0 then fy st else fx st) :=
  PushesAt.select hx hy hk

theorem pushesAt_eMin {m : Mem} {a b : List Instr} {fa fb : Store → Nat}
    (ha : PushesAt m a fa) (hb : PushesAt m b fb) :
    PushesAt m (eMin a b) (fun st => min (fa st) (fb st)) := by
  refine (pushesAt_sel ha hb (pushesAt_op' (o := .ltu) ha hb rfl)).congr (fun st _ => ?_)
  simp only [Bin.eval]
  by_cases h : fa st < fb st <;> simp [h] <;> omega

theorem pushesAt_eMax {m : Mem} {a b : List Instr} {fa fb : Store → Nat}
    (ha : PushesAt m a fa) (hb : PushesAt m b fb) :
    PushesAt m (eMax a b) (fun st => max (fa st) (fb st)) := by
  refine (pushesAt_sel ha hb (pushesAt_op' (o := .gtu) ha hb rfl)).congr (fun st _ => ?_)
  simp only [Bin.eval]
  by_cases h : fb st < fa st <;> simp [h] <;> omega

theorem pushesAt_eSubSat {m : Mem} {a b : List Instr} {fa fb : Store → Nat}
    (ha : PushesAt m a fa) (hb : PushesAt m b fb)
    (hlt : ∀ st : Store, st.mem = m → fa st < W32) :
    PushesAt m (eSubSat a b) (fun st => fa st - fb st) := by
  refine (pushesAt_sel (pushesAt_op' (o := .sub) ha hb rfl)
    (pushesAt_cst m (by decide : (0 : Nat) < W32))
    (pushesAt_op' (o := .geu) ha hb rfl)).congr (fun st hst => ?_)
  by_cases h : fb st ≤ fa st
  · have h1 : fa st + W32 - fb st = (fa st - fb st) + W32 := by omega
    have h2 : fa st - fb st < W32 := by have := hlt st hst; omega
    simp [Bin.eval, h, wrap, h1, Nat.add_mod_right, Nat.mod_eq_of_lt h2]
  · have h3 : fa st - fb st = 0 := by omega
    simp [Bin.eval, h, h3]

theorem runsAt_lset {m : Mem} {i : Nat} {e : List Instr} {fe : Store → Nat}
    (he : PushesAt m e fe) : RunsAt m (lset i e) (fun st => st.set i (fe st)) :=
  RunsAt.localSet he i

/-! ## The values `tick` computes -/

/-- The ground under a position, in sixteenths, as the kernel reads it. -/
def mFloor (m : Mem) (x : Nat) : Nat := unit * m.byte (wrap (trackAddr + x / 16))

/-- Are the wheels on the ground? -/
def mGrnd (m : Mem) : Nat := if m.word sY ≤ mFloor m (m.word sX) then 1 else 0

/-- The push of the wheels this tick. -/
def mAccel (m : Mem) : Nat :=
  if (if m.word sFuel = 0 then 1 else 0) = 0 then
    (if mGrnd m = 0 then min 6 (wrap (2 * m.word pThrust) / m.word pMass)
     else min 12 (wrap (4 * m.word pThrust) / m.word pMass))
  else 0

/-- Rolling friction, on the machine's wrapping arithmetic. -/
def mDrag (v : Nat) : Nat :=
  if vBias < v then wrap (v + W32 - 1) else if v < vBias then wrap (v + 1) else v

/-- The velocity cap. -/
def mClampV (v : Nat) : Nat := max (vBias - vCap) (min (vBias + vCap) v)

/-- The new horizontal velocity. -/
def mVX (m : Mem) (inp : Nat) : Nat :=
  mClampV
    (if inp &&& 1 = 0 then
        (if (inp / 2) &&& 1 = 0 then mDrag (m.word sVX) else mDrag (m.word sVX) - mAccel m)
      else wrap (m.word sVX + mAccel m))

/-- The pull of the balloons this tick. -/
def mLift (m : Mem) (inp : Nat) : Nat :=
  if ((inp / 4) &&& 1) &&& (if 0 < m.word sFuel then 1 else 0) = 0 then 0
  else min 6 (wrap (4 * m.word pLift) / m.word pMass)

/-- The new vertical velocity. -/
def mVY (m : Mem) (inp : Nat) : Nat :=
  mClampV (wrap (m.word sVY + mLift m inp) - gravity)

/-- Where the rig would get to. -/
def mX1 (m : Mem) (inp : Nat) : Nat :=
  if vBias ≤ mVX m inp then min maxX (wrap (m.word sX + wrap (mVX m inp + W32 - vBias)))
  else m.word sX - wrap (vBias + W32 - mVX m inp)

/-- How high the rig would get. -/
def mY1 (m : Mem) (inp : Nat) : Nat :=
  if vBias ≤ mVY m inp then min maxY (wrap (m.word sY + wrap (mVY m inp + W32 - vBias)))
  else m.word sY - wrap (vBias + W32 - mVY m inp)

/-- Did it run into a wall? -/
def mHit (m : Mem) (inp : Nat) : Nat :=
  (if wrap (m.word sY + unit) < mFloor m (mX1 m inp) then 1 else 0) &&&
    (if vBias < mVX m inp then 1 else 0)

/-- Where it actually gets to. -/
def mX2 (m : Mem) (inp : Nat) : Nat :=
  if mHit m inp = 0 then mX1 m inp else m.word sX

/-- The ground under where it gets to. -/
def mFloorY (m : Mem) (inp : Nat) : Nat := mFloor m (mX2 m inp)

/-- Is it standing on the ground? -/
def mDown (m : Mem) (inp : Nat) : Nat := if mY1 m inp < mFloorY m inp then 1 else 0

/-- The fuel left. -/
def mFuel (m : Mem) (inp : Nat) : Nat := m.word sFuel - (if inp = 0 then 0 else 1)

/-- The distance reached. -/
def mDist (m : Mem) (inp : Nat) : Nat := max (m.word sDist) (mX2 m inp)

/-- The clock. -/
def mTick (m : Mem) : Nat := wrap (m.word sTick + 1)

/-- Is the rig wrecked? -/
def mCrash (m : Mem) (inp : Nat) : Nat :=
  mHit m inp &&& (if vBias + smashSpeed ≤ mVX m inp then 1 else 0)

/-! ## The two halves of the body -/

/-- The ten locals `tick` works out before it writes anything. -/
def tickSetup : List Instr :=
  lset lGrnd (op .leu (wLoad sY) (eFloor (wLoad sX))) ++
  lset lA
    (sel (cst 0)
      (sel (eMin (cst 12) (op .divu (op .mul (cst 4) (wLoad pThrust)) (wLoad pMass)))
           (eMin (cst 6) (op .divu (op .mul (cst 2) (wLoad pThrust)) (wLoad pMass)))
           (lget lGrnd))
      (op .eq (wLoad sFuel) (cst 0))) ++
  lset lVX
    (eClampV
      (sel (op .add (wLoad sVX) (lget lA))
        (sel (eSubSat (eDrag (wLoad sVX)) (lget lA)) (eDrag (wLoad sVX))
          (op .and (op .shru (lget lInp) (cst 1)) (cst 1)))
        (op .and (lget lInp) (cst 1)))) ++
  lset lVY
    (eClampV
      (eSubSat
        (op .add (wLoad sVY)
          (sel
            (eMin (cst 6) (op .divu (op .mul (cst 4) (wLoad pLift)) (wLoad pMass)))
            (cst 0)
            (op .and (op .and (op .shru (lget lInp) (cst 2)) (cst 1))
              (op .ltu (cst 0) (wLoad sFuel)))))
        (cst gravity))) ++
  lset lX1
    (sel (eMin (cst maxX) (op .add (wLoad sX) (op .sub (lget lVX) (cst vBias))))
      (eSubSat (wLoad sX) (op .sub (cst vBias) (lget lVX)))
      (op .leu (cst vBias) (lget lVX))) ++
  lset lY1
    (sel (eMin (cst maxY) (op .add (wLoad sY) (op .sub (lget lVY) (cst vBias))))
      (eSubSat (wLoad sY) (op .sub (cst vBias) (lget lVY)))
      (op .leu (cst vBias) (lget lVY))) ++
  lset lHit
    (op .and (op .gtu (eFloor (lget lX1)) (op .add (wLoad sY) (cst unit)))
      (op .ltu (cst vBias) (lget lVX))) ++
  lset lX2 (sel (wLoad sX) (lget lX1) (lget lHit)) ++
  lset lFloor (eFloor (lget lX2)) ++
  lset lDown (op .ltu (lget lY1) (lget lFloor))

/-- The eight state words `tick` writes. -/
def tickWrites : List Instr :=
  wStore sX (lget lX2) ++
  wStore sY (sel (lget lFloor) (lget lY1) (lget lDown)) ++
  wStore sVX (sel (cst vBias) (lget lVX) (lget lHit)) ++
  wStore sVY (sel (cst vBias) (lget lVY) (lget lDown)) ++
  wStore sFuel (eSubSat (wLoad sFuel) (sel (cst 1) (cst 0) (lget lInp))) ++
  wStore sDist (eMax (wLoad sDist) (lget lX2)) ++
  wStore sTick (op .add (wLoad sTick) (cst 1)) ++
  wStore sCrash
    (op .and (lget lHit) (op .geu (lget lVX) (cst (vBias + smashSpeed))))

theorem tickLive_eq : tickLive = tickSetup ++ tickWrites := by
  simp only [tickLive, tickSetup, tickWrites, List.append_assoc]

/-! ## The locals -/

/-- The store after the ten locals have been worked out. -/
def tickLocals (m : Mem) (inp : Nat) (st : Store) : Store :=
  ((((((((((st.set lGrnd (mGrnd m)).set lA (mAccel m)).set lVX (mVX m inp)).set lVY
    (mVY m inp)).set lX1 (mX1 m inp)).set lY1 (mY1 m inp)).set lHit (mHit m inp)).set lX2
    (mX2 m inp)).set lFloor (mFloorY m inp)).set lDown (mDown m inp))

@[simp] theorem tickLocals_mem (m : Mem) (inp : Nat) (st : Store) :
    (tickLocals m inp st).mem = st.mem := by
  simp [tickLocals]

theorem tickLocals_get_inp (m : Mem) (inp : Nat) (st : Store) :
    (tickLocals m inp st).get lInp = st.get lInp := by
  simp [tickLocals, lInp, lGrnd, lA, lVX, lVY, lX1, lY1, lHit, lX2, lFloor, lDown,
    Store.get, Store.set]

theorem tickLocals_get (m : Mem) (inp : Nat) (st : Store) :
    (tickLocals m inp st).get lVX = mVX m inp ∧
      (tickLocals m inp st).get lVY = mVY m inp ∧
      (tickLocals m inp st).get lY1 = mY1 m inp ∧
      (tickLocals m inp st).get lHit = mHit m inp ∧
      (tickLocals m inp st).get lX2 = mX2 m inp ∧
      (tickLocals m inp st).get lFloor = mFloorY m inp ∧
      (tickLocals m inp st).get lDown = mDown m inp := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    simp [tickLocals, lGrnd, lA, lVX, lVY, lX1, lY1, lHit, lX2, lFloor, lDown,
      Store.get, Store.set]

/-! ## The memory -/

/-- The memory a live tick leaves. -/
def tickMem (m : Mem) (inp : Nat) : Mem :=
  writeChain m (mX2 m inp) (if mDown m inp = 0 then mY1 m inp else mFloorY m inp)
    (if mHit m inp = 0 then mVX m inp else vBias)
    (if mDown m inp = 0 then mVY m inp else vBias)
    (mFuel m inp) (mDist m inp) (mTick m) (mCrash m inp)

/-! ## The compound expressions of `tick` -/

theorem mDrag_lt {v : Nat} (h : v < W32) : mDrag v < W32 := by
  unfold mDrag
  split
  · exact wrap_lt _
  · split
    · exact wrap_lt _
    · exact h

theorem pushesAt_eFloor {m : Mem} {e : List Instr} {fe : Store → Nat} (he : PushesAt m e fe) :
    PushesAt m (eFloor e) (fun st => mFloor m (fe st)) := by
  have hshr : PushesAt m (op .shru e (cst 4)) (fun st => fe st / 16) := by
    refine (pushesAt_op' (o := .shru) he (pushesAt_cst m (by decide)) rfl).congr (fun st _ => ?_)
    norm_num [Bin.eval]
  have haddr : PushesAt m (op .add (cst trackAddr) (op .shru e (cst 4)))
      (fun st => wrap (trackAddr + fe st / 16)) :=
    pushesAt_op' (o := .add) (pushesAt_cst m (by decide)) hshr rfl
  refine (pushesAt_op' (o := .mul) (pushesAt_cst m (by decide))
    (pushesAt_bLoad haddr) rfl).congr (fun st _ => ?_)
  have hlt : m.byte (wrap (trackAddr + fe st / 16)) < 256 := Mem.byte_lt _ _
  have hw : unit * m.byte (wrap (trackAddr + fe st / 16)) < W32 := by
    rw [show unit = 16 from rfl, show W32 = 4294967296 from rfl]
    omega
  exact wrap_eq_self hw

theorem pushesAt_eDrag {m : Mem} {e : List Instr} {fe : Store → Nat} (he : PushesAt m e fe) :
    PushesAt m (eDrag e) (fun st => mDrag (fe st)) := by
  refine (pushesAt_sel (pushesAt_op' (o := .sub) he (pushesAt_cst m (by decide)) rfl)
    (pushesAt_sel (pushesAt_op' (o := .add) he (pushesAt_cst m (by decide)) rfl) he
      (pushesAt_op' (o := .ltu) he (pushesAt_cst m (by decide : vBias < W32)) rfl))
    (pushesAt_op' (o := .ltu) (pushesAt_cst m (by decide : vBias < W32)) he rfl)).congr
    (fun st _ => ?_)
  unfold mDrag
  by_cases h1 : vBias < fe st
  · simp [Bin.eval, h1]
  · by_cases h2 : fe st < vBias <;> simp [Bin.eval, h1, h2]

theorem pushesAt_eClampV {m : Mem} {e : List Instr} {fe : Store → Nat} (he : PushesAt m e fe) :
    PushesAt m (eClampV e) (fun st => mClampV (fe st)) :=
  pushesAt_eMax (pushesAt_cst m (by decide)) (pushesAt_eMin (pushesAt_cst m (by decide)) he)

/-! ## Working out the locals -/

/-- The ten locals, over a memory whose mass is not zero. -/
theorem runsAt_tickSetup (m : Mem) (hmass : m.word pMass ≠ 0) :
    RunsAt m tickSetup (fun st => tickLocals m (st.get lInp) st) := by
  have hmem : ∀ (f : Store → Store), (∀ st : Store, (f st).mem = st.mem) →
      ∀ st : Store, st.mem = m → (f st).mem = m := by
    intro f hf st h; rw [hf st, h]
  -- the ten expressions
  have e1 : PushesAt m (op .leu (wLoad sY) (eFloor (wLoad sX))) (fun _ => mGrnd m) :=
    (pushesAt_op' (o := .leu) (pushesAt_wLoad m sY)
      (pushesAt_eFloor (pushesAt_wLoad m sX)) rfl).congr (fun _ _ => by simp [Bin.eval, mGrnd])
  have hdiv : ∀ k : Nat, k < 1024 → ∀ a : Nat,
      PushesAt m (op .divu (op .mul (cst k) (wLoad a)) (wLoad pMass))
        (fun _ => wrap (k * m.word a) / m.word pMass) := by
    intro k hk a
    have hmul : PushesAt m (op .mul (cst k) (wLoad a)) (fun _ => wrap (k * m.word a)) :=
      pushesAt_op' (o := .mul)
        (pushesAt_cst m (by rw [show W32 = 4294967296 from rfl]; omega))
        (pushesAt_wLoad m a) rfl
    exact pushesAt_op (o := .divu) hmul (pushesAt_wLoad m pMass) (fun _ _ _ => hmass)
  have e2 : PushesAt m
      (sel (cst 0)
        (sel (eMin (cst 12) (op .divu (op .mul (cst 4) (wLoad pThrust)) (wLoad pMass)))
             (eMin (cst 6) (op .divu (op .mul (cst 2) (wLoad pThrust)) (wLoad pMass)))
             (lget lGrnd))
        (op .eq (wLoad sFuel) (cst 0)))
      (fun st => if (if m.word sFuel = 0 then 1 else 0) = 0 then
          (if st.get lGrnd = 0 then min 6 (wrap (2 * m.word pThrust) / m.word pMass)
           else min 12 (wrap (4 * m.word pThrust) / m.word pMass))
        else 0) := by
    refine (pushesAt_sel (pushesAt_cst m (by decide))
      (pushesAt_sel (pushesAt_eMin (pushesAt_cst m (by decide)) (hdiv 4 (by decide) pThrust))
        (pushesAt_eMin (pushesAt_cst m (by decide)) (hdiv 2 (by decide) pThrust))
        (pushesAt_lget m lGrnd))
      (pushesAt_op' (o := .eq) (pushesAt_wLoad m sFuel) (pushesAt_cst m (by decide))
        rfl)).congr (fun st _ => by simp [Bin.eval])
  have e3 : PushesAt m
      (eClampV
        (sel (op .add (wLoad sVX) (lget lA))
          (sel (eSubSat (eDrag (wLoad sVX)) (lget lA)) (eDrag (wLoad sVX))
            (op .and (op .shru (lget lInp) (cst 1)) (cst 1)))
          (op .and (lget lInp) (cst 1))))
      (fun st => mClampV
        (if st.get lInp &&& 1 = 0 then
            (if (st.get lInp / 2) &&& 1 = 0 then mDrag (m.word sVX)
             else mDrag (m.word sVX) - st.get lA)
          else wrap (m.word sVX + st.get lA))) := by
    refine (pushesAt_eClampV (pushesAt_sel
      (pushesAt_op' (o := .add) (pushesAt_wLoad m sVX) (pushesAt_lget m lA) rfl)
      (pushesAt_sel
        (pushesAt_eSubSat (pushesAt_eDrag (pushesAt_wLoad m sVX)) (pushesAt_lget m lA)
          (fun _ _ => mDrag_lt (Mem.word_lt _ _)))
        (pushesAt_eDrag (pushesAt_wLoad m sVX))
        (pushesAt_op' (o := .and) (pushesAt_op' (o := .shru) (pushesAt_lget m lInp)
          (pushesAt_cst m (by decide)) rfl) (pushesAt_cst m (by decide)) rfl))
      (pushesAt_op' (o := .and) (pushesAt_lget m lInp) (pushesAt_cst m (by decide))
        rfl))).congr (fun st _ => ?_)
    norm_num [Bin.eval]
  have e4 : PushesAt m
      (eClampV
        (eSubSat
          (op .add (wLoad sVY)
            (sel
              (eMin (cst 6) (op .divu (op .mul (cst 4) (wLoad pLift)) (wLoad pMass)))
              (cst 0)
              (op .and (op .and (op .shru (lget lInp) (cst 2)) (cst 1))
                (op .ltu (cst 0) (wLoad sFuel)))))
          (cst gravity)))
      (fun st => mVY m (st.get lInp)) := by
    refine (pushesAt_eClampV (pushesAt_eSubSat
      (pushesAt_op' (o := .add) (pushesAt_wLoad m sVY)
        (pushesAt_sel
          (pushesAt_eMin (pushesAt_cst m (by decide)) (hdiv 4 (by decide) pLift))
          (pushesAt_cst m (by decide))
          (pushesAt_op' (o := .and)
            (pushesAt_op' (o := .and)
              (pushesAt_op' (o := .shru) (pushesAt_lget m lInp)
                (pushesAt_cst m (by decide)) rfl)
              (pushesAt_cst m (by decide)) rfl)
            (pushesAt_op' (o := .ltu) (pushesAt_cst m (by decide))
              (pushesAt_wLoad m sFuel) rfl)
            rfl))
        rfl)
      (pushesAt_cst m (by decide))
      (fun _ _ => wrap_lt _))).congr (fun st _ => ?_)
    unfold mVY mLift
    norm_num [Bin.eval]
  have e5 : PushesAt m
      (sel (eMin (cst maxX) (op .add (wLoad sX) (op .sub (lget lVX) (cst vBias))))
        (eSubSat (wLoad sX) (op .sub (cst vBias) (lget lVX)))
        (op .leu (cst vBias) (lget lVX)))
      (fun st => if vBias ≤ st.get lVX then
          min maxX (wrap (m.word sX + wrap (st.get lVX + W32 - vBias)))
        else m.word sX - wrap (vBias + W32 - st.get lVX)) := by
    refine (pushesAt_sel
      (pushesAt_eMin (pushesAt_cst m (by decide))
        (pushesAt_op' (o := .add) (pushesAt_wLoad m sX)
          (pushesAt_op' (o := .sub) (pushesAt_lget m lVX) (pushesAt_cst m (by decide)) rfl) rfl))
      (pushesAt_eSubSat (pushesAt_wLoad m sX)
        (pushesAt_op' (o := .sub) (pushesAt_cst m (by decide)) (pushesAt_lget m lVX) rfl)
        (fun _ _ => Mem.word_lt _ _))
      (pushesAt_op' (o := .leu) (pushesAt_cst m (by decide)) (pushesAt_lget m lVX)
        rfl)).congr (fun st _ => ?_)
    by_cases h : vBias ≤ st.get lVX <;> simp [Bin.eval, h]
  have e6 : PushesAt m
      (sel (eMin (cst maxY) (op .add (wLoad sY) (op .sub (lget lVY) (cst vBias))))
        (eSubSat (wLoad sY) (op .sub (cst vBias) (lget lVY)))
        (op .leu (cst vBias) (lget lVY)))
      (fun st => if vBias ≤ st.get lVY then
          min maxY (wrap (m.word sY + wrap (st.get lVY + W32 - vBias)))
        else m.word sY - wrap (vBias + W32 - st.get lVY)) := by
    refine (pushesAt_sel
      (pushesAt_eMin (pushesAt_cst m (by decide))
        (pushesAt_op' (o := .add) (pushesAt_wLoad m sY)
          (pushesAt_op' (o := .sub) (pushesAt_lget m lVY) (pushesAt_cst m (by decide)) rfl) rfl))
      (pushesAt_eSubSat (pushesAt_wLoad m sY)
        (pushesAt_op' (o := .sub) (pushesAt_cst m (by decide)) (pushesAt_lget m lVY) rfl)
        (fun _ _ => Mem.word_lt _ _))
      (pushesAt_op' (o := .leu) (pushesAt_cst m (by decide)) (pushesAt_lget m lVY)
        rfl)).congr (fun st _ => ?_)
    by_cases h : vBias ≤ st.get lVY <;> simp [Bin.eval, h]
  have e7 : PushesAt m
      (op .and (op .gtu (eFloor (lget lX1)) (op .add (wLoad sY) (cst unit)))
        (op .ltu (cst vBias) (lget lVX)))
      (fun st => (if wrap (m.word sY + unit) < mFloor m (st.get lX1) then 1 else 0) &&&
        (if vBias < st.get lVX then 1 else 0)) := by
    refine (pushesAt_op' (o := .and)
      (pushesAt_op' (o := .gtu) (pushesAt_eFloor (pushesAt_lget m lX1))
        (pushesAt_op' (o := .add) (pushesAt_wLoad m sY) (pushesAt_cst m (by decide)) rfl) rfl)
      (pushesAt_op' (o := .ltu) (pushesAt_cst m (by decide)) (pushesAt_lget m lVX) rfl)
      rfl).congr (fun st _ => by simp [Bin.eval])
  have e8 : PushesAt m (sel (wLoad sX) (lget lX1) (lget lHit))
      (fun st => if st.get lHit = 0 then st.get lX1 else m.word sX) :=
    pushesAt_sel (pushesAt_wLoad m sX) (pushesAt_lget m lX1) (pushesAt_lget m lHit)
  have e9 : PushesAt m (eFloor (lget lX2)) (fun st => mFloor m (st.get lX2)) :=
    pushesAt_eFloor (pushesAt_lget m lX2)
  have e10 : PushesAt m (op .ltu (lget lY1) (lget lFloor))
      (fun st => if st.get lY1 < st.get lFloor then 1 else 0) :=
    (pushesAt_op' (o := .ltu) (pushesAt_lget m lY1) (pushesAt_lget m lFloor) rfl).congr
      (fun st _ => by simp [Bin.eval])
  -- and now the chain
  have h1 : RunsAt m (lset lGrnd (op .leu (wLoad sY) (eFloor (wLoad sX))))
      (fun st => st.set lGrnd (mGrnd m)) := runsAt_lset e1
  have h2 := (h1.seq (runsAt_lset (i := lA) e2) (hmem _ (fun st => rfl))).congr
    (fun st _ => by
      simp only [Store.get_set_self]
      rfl)
  have h3 := (h2.seq (runsAt_lset (i := lVX) e3) (hmem _ (fun st => rfl))).congr
    (fun st _ => by
      simp only [Store.get_set_self, Store.get_set_ne _ (by decide : lInp ≠ lA),
        Store.get_set_ne _ (by decide : lInp ≠ lGrnd)]
      rfl)
  have h4 := (h3.seq (runsAt_lset (i := lVY) e4) (hmem _ (fun st => rfl))).congr
    (fun st _ => by
      simp only [Store.get_set_ne _ (by decide : lInp ≠ lVX),
        Store.get_set_ne _ (by decide : lInp ≠ lA),
        Store.get_set_ne _ (by decide : lInp ≠ lGrnd)]
      rfl)
  have h5 := (h4.seq (runsAt_lset (i := lX1) e5) (hmem _ (fun st => rfl))).congr
    (fun st _ => by
      simp only [Store.get_set_self, Store.get_set_ne _ (by decide : lVX ≠ lVY)]
      rfl)
  have h6 := (h5.seq (runsAt_lset (i := lY1) e6) (hmem _ (fun st => rfl))).congr
    (fun st _ => by
      simp only [Store.get_set_self, Store.get_set_ne _ (by decide : lVY ≠ lX1)]
      rfl)
  have h7 := (h6.seq (runsAt_lset (i := lHit) e7) (hmem _ (fun st => rfl))).congr
    (fun st _ => by
      simp only [Store.get_set_self, Store.get_set_ne _ (by decide : lX1 ≠ lY1),
        Store.get_set_ne _ (by decide : lVX ≠ lY1), Store.get_set_ne _ (by decide : lVX ≠ lX1)]
      rfl)
  have h8 := (h7.seq (runsAt_lset (i := lX2) e8) (hmem _ (fun st => rfl))).congr
    (fun st _ => by
      simp only [Store.get_set_self, Store.get_set_ne _ (by decide : lX1 ≠ lHit)]
      rfl)
  have h9 := (h8.seq (runsAt_lset (i := lFloor) e9) (hmem _ (fun st => rfl))).congr
    (fun st _ => by
      simp only [Store.get_set_self]
      rfl)
  have h10 := (h9.seq (runsAt_lset (i := lDown) e10) (hmem _ (fun st => rfl))).congr
    (fun st _ => by
      simp only [Store.get_set_self, Store.get_set_ne _ (by decide : lY1 ≠ lFloor),
        Store.get_set_ne _ (by decide : lY1 ≠ lX2), Store.get_set_ne _ (by decide : lY1 ≠ lHit)]
      rfl)
  exact h10

/-! ## Writing the state words -/

/-- The eight writes, in terms of the locals `tick` has worked out. -/
theorem runs_tickWrites :
    Runs tickWrites (fun st => Store.mk st.locals
      (writeChain st.mem (st.get lX2)
        (if st.get lDown = 0 then st.get lY1 else st.get lFloor)
        (if st.get lHit = 0 then st.get lVX else vBias)
        (if st.get lDown = 0 then st.get lVY else vBias)
        (st.mem.word sFuel - (if st.get lInp = 0 then 0 else 1))
        (max (st.mem.word sDist) (st.get lX2))
        (wrap (st.mem.word sTick + 1))
        (st.get lHit &&& (if vBias + smashSpeed ≤ st.get lVX then 1 else 0)))) := by
  have hne : ∀ (mm : Mem) (a b v : Nat), b + 4 ≤ a ∨ a + 4 ≤ b →
      (mm.setWord a v).word b = mm.word b := fun mm _ _ v h => Mem.word_setWord_ne mm v h
  refine runs_congr (Runs.seq (Runs.seq (Runs.seq (Runs.seq (Runs.seq (Runs.seq (Runs.seq
    (runs_wStore (a := sX) (pushes_lget lX2))
    (runs_wStore (a := sY)
      (pushes_sel (pushes_lget lFloor) (pushes_lget lY1) (pushes_lget lDown))))
    (runs_wStore (a := sVX)
      (pushes_sel (pushes_cst (n := vBias) (by decide)) (pushes_lget lVX) (pushes_lget lHit))))
    (runs_wStore (a := sVY)
      (pushes_sel (pushes_cst (n := vBias) (by decide)) (pushes_lget lVY) (pushes_lget lDown))))
    (runs_wStore (a := sFuel)
      (pushes_eSubSat (pushes_wLoad sFuel)
        (pushes_sel (pushes_cst (n := 1) (by decide)) (pushes_cst (n := 0) (by decide))
          (pushes_lget lInp))
        (fun st => Mem.word_lt _ _))))
    (runs_wStore (a := sDist) (pushes_eMax (pushes_wLoad sDist) (pushes_lget lX2))))
    (runs_wStore (a := sTick)
      (pushes_op' (o := .add) (pushes_wLoad sTick) (pushes_cst (n := 1) (by decide)) rfl)))
    (runs_wStore (a := sCrash)
      (pushes_op' (o := .and) (pushes_lget lHit)
        (pushes_op' (o := .geu) (pushes_lget lVX)
          (pushes_cst (n := vBias + smashSpeed) (by decide)) rfl) rfl)))
    (fun st => ?_)
  simp only [Store.get, writeChain, Bin.eval,
    hne _ sX sFuel _ (by decide), hne _ sY sFuel _ (by decide),
    hne _ sVX sFuel _ (by decide), hne _ sVY sFuel _ (by decide),
    hne _ sX sDist _ (by decide), hne _ sY sDist _ (by decide),
    hne _ sVX sDist _ (by decide), hne _ sVY sDist _ (by decide),
    hne _ sFuel sDist _ (by decide),
    hne _ sX sTick _ (by decide), hne _ sY sTick _ (by decide),
    hne _ sVX sTick _ (by decide), hne _ sVY sTick _ (by decide),
    hne _ sFuel sTick _ (by decide), hne _ sDist sTick _ (by decide)]

/-! ## One live tick -/

/-- The body of a live tick: the locals, then the eight writes. -/
theorem runsAt_tickLive (m : Mem) (hmass : m.word pMass ≠ 0) :
    RunsAt m tickLive
      (fun st => { tickLocals m (st.get lInp) st with mem := tickMem m (st.get lInp) }) := by
  rw [tickLive_eq]
  refine ((runsAt_tickSetup m hmass).seqR runs_tickWrites).congr (fun st hst => ?_)
  obtain ⟨hvx, hvy, hy1, hhit, hx2, hfl, hdown⟩ := tickLocals_get m (st.get lInp) st
  simp only [tickLocals_mem, tickLocals_get_inp, hvx, hvy, hy1, hhit, hx2, hfl, hdown, hst,
    tickMem, mFuel, mDist, mTick, mCrash]

/-- A whole call of `tick`: nothing at all if the rig is already wrecked, and
`tickMem` otherwise. -/
theorem tick_mem (m : Mem) (hmass : m.word pMass ≠ 0) (locals : Locals) (fuel : Nat) :
    callVoid tickBody locals m fuel =
      some (if m.word sCrash = 1 then m else tickMem m (locals lInp)) := by
  have hk : PushesAt m (op .eq (wLoad sCrash) (cst 1))
      (fun _ => if m.word sCrash = 1 then 1 else 0) :=
    (pushesAt_op' (o := .eq) (pushesAt_wLoad m sCrash) (pushesAt_cst m (by decide)) rfl).congr
      (fun _ _ => by simp [Bin.eval])
  have hbody := RunsAt.ifte hk (RunsAt.nil m) (runsAt_tickLive m hmass)
  have hres := hbody ⟨[], ⟨locals, m⟩⟩ fuel rfl
  unfold callVoid
  rw [show tickBody = op .eq (wLoad sCrash) (cst 1) ++ [.ifElse [] tickLive] from rfl, hres]
  by_cases h : m.word sCrash = 1 <;> simp [h, Store.get]

end RigKernel
