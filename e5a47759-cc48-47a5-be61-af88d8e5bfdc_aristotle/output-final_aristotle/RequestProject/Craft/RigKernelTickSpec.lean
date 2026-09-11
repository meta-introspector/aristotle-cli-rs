import RequestProject.Craft.RigKernelTick

/-!
# `tick` is the rule book

`RequestProject/RigKernelTick.lean` says what one call of the kernel's `tick` does
to linear memory (`tickMem`).  This file matches that against `Rig.step`, the
function the game's theorems are proved about: over a memory holding a run that is
in range, one call of `tick` leaves the memory image of `Rig.step`
(`tick_correct`).

Everything the kernel does is `i32` arithmetic that wraps, so each step of the
match is a small bound: the mass is not zero, the thrust and lift are small enough
that four times them does not wrap, positions and speeds stay in the ranges
`Sim.Inv` guarantees.  The one bound the rule book does not itself provide is the
clock: `Rig.step` counts ticks in ℕ and the kernel counts them in an `i32`, so
`tick_correct` asks that the tick about to be counted still fits.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace RigKernel

open RigVM Rig

section

variable {m : Mem} {t : Track} {p : Params} {s : Sim} {inp : Nat}

/-! ## Reading the track back -/

/-- Over a memory holding the track, the kernel's floor is the rule book's. -/
theorem mFloor_eq (ht : TrackAt m t) {x : Nat} (hx : x ≤ maxX) :
    mFloor m x = unit * t.ground (x / unit) := by
  have hc : x / 16 < trackLen := by
    have hm : maxX = 2047 := rfl
    have : x / 16 ≤ 2047 / 16 := Nat.div_le_div_right (by omega)
    simp only [trackLen]
    omega
  have hw : wrap (trackAddr + x / 16) = trackAddr + x / 16 := by
    refine wrap_eq_self ?_
    simp only [trackAddr, W32, trackLen] at *
    omega
  unfold mFloor
  rw [hw, ht.ground (x / 16) hc]
  rfl

/-! ## The locals -/

theorem mGrnd_eq (ht : TrackAt m t) (hs : StateAt m s) (hinv : Sim.Inv p s) :
    mGrnd m = if s.y ≤ unit * t.ground (s.x / unit) then 1 else 0 := by
  unfold mGrnd
  rw [hs.x, hs.y, mFloor_eq ht hinv.x_le]

theorem mAccel_eq (ht : TrackAt m t) (hp : ParamsAt m p t.finish) (hb : Small p)
    (hs : StateAt m s) (hinv : Sim.Inv p s) :
    mAccel m = accelOf p s (decide (s.y ≤ unit * t.ground (s.x / unit))) := by
  have h4 : wrap (4 * m.word pThrust) = 4 * p.thrust := by
    rw [hp.thrust]
    refine wrap_eq_self ?_
    have := hb.thrust
    rw [show W32 = 4294967296 from rfl]
    omega
  have h2 : wrap (2 * m.word pThrust) = 2 * p.thrust := by
    rw [hp.thrust]
    refine wrap_eq_self ?_
    have := hb.thrust
    rw [show W32 = 4294967296 from rfl]
    omega
  unfold mAccel accelOf
  rw [h4, h2, hp.mass, hs.fuel, mGrnd_eq ht hs hinv]
  by_cases hf : s.fuel = 0
  · simp [hf]
  · by_cases hg : s.y ≤ unit * t.ground (s.x / unit) <;> simp [hf, hg]

theorem mDrag_eq {v : Nat} (h1 : 0 < v) (h2 : v + 1 < W32) : mDrag v = drag v := by
  unfold mDrag drag
  by_cases hb : vBias < v
  · have : v + W32 - 1 = (v - 1) + W32 := by omega
    rw [if_pos hb, if_pos hb, this]
    simp only [wrap, Nat.add_mod_right]
    exact Nat.mod_eq_of_lt (by omega)
  · by_cases hl : v < vBias
    · rw [if_neg hb, if_pos hl, if_neg hb, if_pos hl]
      exact wrap_eq_self h2
    · rw [if_neg hb, if_neg hl, if_neg hb, if_neg hl]

theorem mVX_eq (ht : TrackAt m t) (hp : ParamsAt m p t.finish) (hb : Small p)
    (hs : StateAt m s) (hinv : Sim.Inv p s) :
    mVX m inp = newVX p s inp (decide (s.y ≤ unit * t.ground (s.x / unit))) := by
  have hvxlo : vBias - vCap ≤ s.vx := hinv.vx_lo
  have hvxhi : s.vx ≤ vBias + vCap := hinv.vx_hi
  have hvb : vBias = 1024 := rfl
  have hvc : vCap = 48 := rfl
  have hw : W32 = 4294967296 := rfl
  have hdrag : mDrag (m.word sVX) = drag s.vx := by
    rw [hs.vx]
    exact mDrag_eq (by omega) (by omega)
  have haccel : mAccel m ≤ 12 := by
    have h6 := Nat.min_le_left 6 (wrap (2 * m.word pThrust) / m.word pMass)
    have h12 := Nat.min_le_left 12 (wrap (4 * m.word pThrust) / m.word pMass)
    unfold mAccel
    split_ifs <;> omega
  have hacc := mAccel_eq ht hp hb hs hinv
  have hbit1 : inp &&& 1 = inp % 2 := Nat.and_one_is_mod inp
  have hbit2 : (inp / 2) &&& 1 = (inp / 2) % 2 := Nat.and_one_is_mod _
  unfold mVX newVX
  rw [hdrag, hacc, hbit1, hbit2, hs.vx]
  have hclamp : mClampV = clampV := rfl
  rw [hclamp]
  have hmod : inp % 2 = 0 ∨ inp % 2 = 1 := Nat.mod_two_eq_zero_or_one inp
  have hmod2 : (inp / 2) % 2 = 0 ∨ (inp / 2) % 2 = 1 := Nat.mod_two_eq_zero_or_one _
  have hsum : wrap (s.vx + accelOf p s (decide (s.y ≤ unit * t.ground (s.x / unit)))) =
      s.vx + accelOf p s (decide (s.y ≤ unit * t.ground (s.x / unit))) := by
    refine wrap_eq_self ?_
    have : accelOf p s (decide (s.y ≤ unit * t.ground (s.x / unit))) ≤ 12 := by
      rw [← hacc]; exact haccel
    omega
  rcases hmod with h | h <;> rcases hmod2 with h2 | h2 <;>
    simp [h, h2, subSat, hsum]

theorem mVY_eq (hp : ParamsAt m p t.finish) (hb : Small p) (hs : StateAt m s)
    (hinv : Sim.Inv p s) : mVY m inp = newVY p s inp := by
  have hvylo : vBias - vCap ≤ s.vy := hinv.vy_lo
  have hvyhi : s.vy ≤ vBias + vCap := hinv.vy_hi
  have hvb : vBias = 1024 := rfl
  have hvc : vCap = 48 := rfl
  have hw : W32 = 4294967296 := rfl
  have h4 : wrap (4 * m.word pLift) = 4 * p.lift := by
    rw [hp.lift]
    refine wrap_eq_self ?_
    have := hb.lift
    omega
  have hlift : mLift m inp = (if inp / 4 % 2 = 1 && 0 < s.fuel then liftOf p else 0) := by
    unfold mLift liftOf
    rw [h4, hp.mass, hs.fuel, Nat.and_one_is_mod]
    rcases Nat.mod_two_eq_zero_or_one (inp / 4) with h | h <;>
      by_cases hf : 0 < s.fuel <;> simp [h, hf]
  have hlift6 : mLift m inp ≤ 6 := by
    have h6 := Nat.min_le_left 6 (wrap (4 * m.word pLift) / m.word pMass)
    unfold mLift
    split_ifs <;> omega
  have hsum : wrap (m.word sVY + mLift m inp) = s.vy + mLift m inp := by
    rw [hs.vy]
    refine wrap_eq_self ?_
    omega
  unfold mVY newVY
  rw [hsum, hlift]
  rfl

/-! ## Where the rig gets to -/

/-- The machine's `sub` is honest subtraction when the answer is not negative. -/
theorem wrap_sub_of_le {a b : Nat} (hba : b ≤ a) (h : a - b < W32) :
    wrap (a + W32 - b) = a - b := by
  have e : a + W32 - b = (a - b) + W32 := by omega
  rw [e]
  simp only [wrap, Nat.add_mod_right]
  exact Nat.mod_eq_of_lt h

theorem mX1_eq (hs : StateAt m s) (hinv : Sim.Inv p s) {v : Nat} (hvhi : v ≤ vBias + vCap) (hv : mVX m inp = v) :
    mX1 m inp = advance s.x v maxX := by
  have hx : s.x ≤ maxX := hinv.x_le
  have hmx : maxX = 2047 := rfl
  have hvb : vBias = 1024 := rfl
  have hvc : vCap = 48 := rfl
  have hw : W32 = 4294967296 := rfl
  unfold mX1 advance subSat
  rw [hv, hs.x]
  by_cases h : vBias ≤ v
  · have e1 : wrap (v + W32 - vBias) = v - vBias := wrap_sub_of_le h (by omega)
    rw [if_pos h, if_pos h, e1]
    have e2 : wrap (s.x + (v - vBias)) = s.x + (v - vBias) := by
      refine wrap_eq_self ?_
      omega
    rw [e2]
  · have e1 : wrap (vBias + W32 - v) = vBias - v := wrap_sub_of_le (by omega) (by omega)
    rw [if_neg h, if_neg h, e1]

theorem mY1_eq (hs : StateAt m s) (hinv : Sim.Inv p s) {v : Nat} (hvhi : v ≤ vBias + vCap) (hv : mVY m inp = v) :
    mY1 m inp = advance s.y v maxY := by
  have hy : s.y ≤ maxY := hinv.y_le
  have hmy : maxY = 240 := rfl
  have hvb : vBias = 1024 := rfl
  have hvc : vCap = 48 := rfl
  have hw : W32 = 4294967296 := rfl
  unfold mY1 advance subSat
  rw [hv, hs.y]
  by_cases h : vBias ≤ v
  · have e1 : wrap (v + W32 - vBias) = v - vBias := wrap_sub_of_le h (by omega)
    rw [if_pos h, if_pos h, e1]
    have e2 : wrap (s.y + (v - vBias)) = s.y + (v - vBias) := by
      refine wrap_eq_self ?_
      omega
    rw [e2]
  · have e1 : wrap (vBias + W32 - v) = vBias - v := wrap_sub_of_le (by omega) (by omega)
    rw [if_neg h, if_neg h, e1]

theorem mFloor_lt (m : Mem) (x : Nat) : mFloor m x < W32 := by
  have h : m.byte (wrap (trackAddr + x / 16)) < 256 := Mem.byte_lt _ _
  unfold mFloor
  rw [show unit = 16 from rfl, show W32 = 4294967296 from rfl]
  omega

theorem mHit_eq (ht : TrackAt m t) (hs : StateAt m s) (hinv : Sim.Inv p s) {v x1 : Nat}
    (hv : mVX m inp = v) (hx1 : mX1 m inp = x1) (hx1le : x1 ≤ maxX) :
    mHit m inp =
      if decide (s.y + unit < unit * t.ground (x1 / unit)) && decide (vBias < v) then 1
      else 0 := by
  have hy : s.y ≤ maxY := hinv.y_le
  have hwy : wrap (m.word sY + unit) = s.y + unit := by
    rw [hs.y]
    refine wrap_eq_self ?_
    rw [show unit = 16 from rfl, show W32 = 4294967296 from rfl]
    have : maxY = 240 := rfl
    omega
  unfold mHit
  rw [hv, hx1, hwy, mFloor_eq ht hx1le]
  by_cases h1 : s.y + unit < unit * t.ground (x1 / unit) <;> by_cases h2 : vBias < v <;>
    simp [h1, h2]

theorem mX2_eq (hs : StateAt m s) {b : Bool} {x1 : Nat} (hhit : mHit m inp = if b then 1 else 0)
    (hx1 : mX1 m inp = x1) : mX2 m inp = if b then s.x else x1 := by
  unfold mX2
  rw [hhit, hx1, hs.x]
  cases b <;> simp

theorem mFloorY_eq (ht : TrackAt m t) {x2 : Nat} (hx2 : mX2 m inp = x2) (h : x2 ≤ maxX) :
    mFloorY m inp = unit * t.ground (x2 / unit) := by
  unfold mFloorY
  rw [hx2]
  exact mFloor_eq ht h

theorem mDown_eq {y1 fl : Nat} (hy1 : mY1 m inp = y1) (hfl : mFloorY m inp = fl) :
    mDown m inp = if y1 < fl then 1 else 0 := by
  unfold mDown
  rw [hy1, hfl]

/-! ## One tick of the kernel is one tick of the rule book -/

/-- One call of `tick` over a memory holding a run in range leaves the memory image
of `Rig.step`, and leaves the track and the rig's parameters alone.  The clock is
the one thing the rule book counts in ℕ and the kernel in an `i32`, so the tick
about to be counted has to fit. -/
theorem tick_correct {locals : Locals} {fuel : Nat} (ht : TrackAt m t)
    (hp : ParamsAt m p t.finish) (hb : Small p) (hs : StateAt m s) (hinv : Sim.Inv p s)
    (htick : s.tick + 1 < W32) :
    ∃ m', callVoid tickBody locals m fuel = some m' ∧
      StateAt m' (step t p (locals lInp) s) ∧ TrackAt m' t ∧ ParamsAt m' p t.finish := by
  have hmass : m.word pMass ≠ 0 := by
    have := hb.mass_pos
    rw [hp.mass]
    omega
  by_cases hcr : s.crashed = 1
  · refine ⟨m, ?_, ?_, ht, hp⟩
    · rw [tick_mem m hmass locals fuel, if_pos (by rw [hs.crash, hcr])]
    · rw [step_crashed t p (locals lInp) s hcr]
      exact hs
  · -- the live case
    set inp := locals lInp with hinp
    have hcrm : ¬ m.word sCrash = 1 := by rw [hs.crash]; exact hcr
    -- the rule book's values
    set gr : Bool := decide (s.y ≤ unit * t.ground (s.x / unit)) with hgr
    set vx1 : Nat := newVX p s inp gr with hvx1
    set vy1 : Nat := newVY p s inp with hvy1
    set x1 : Nat := advance s.x vx1 maxX with hx1def
    set y1 : Nat := advance s.y vy1 maxY with hy1def
    set hit : Bool :=
      decide (s.y + unit < unit * t.ground (x1 / unit)) && decide (vBias < vx1) with hhitdef
    set x2 : Nat := (if hit then s.x else x1) with hx2def
    set fl : Nat := unit * t.ground (x2 / unit) with hfldef
    set down : Bool := decide (y1 < fl) with hdowndef
    have hx1le : x1 ≤ maxX := advance_le hinv.x_le
    have hy1le : y1 ≤ maxY := advance_le hinv.y_le
    have hx2le : x2 ≤ maxX := by
      rw [hx2def]
      cases hit
      · simpa using hx1le
      · simpa using hinv.x_le
    -- the machine's values
    have mvx : mVX m inp = vx1 := mVX_eq ht hp hb hs hinv
    have mvy : mVY m inp = vy1 := mVY_eq hp hb hs hinv
    have mx1 : mX1 m inp = x1 :=
      mX1_eq hs hinv (newVX_hi p s inp gr) mvx
    have my1 : mY1 m inp = y1 :=
      mY1_eq hs hinv (newVY_hi p s inp) mvy
    have mhit : mHit m inp = if hit then 1 else 0 := mHit_eq ht hs hinv mvx mx1 hx1le
    have mx2 : mX2 m inp = x2 := mX2_eq hs mhit mx1
    have mfl : mFloorY m inp = fl := mFloorY_eq ht mx2 hx2le
    have mdown : mDown m inp = if down then 1 else 0 := by
      rw [mDown_eq my1 mfl, hdowndef]
      by_cases h : y1 < fl <;> simp [h]
    -- what the rule book does
    have hstep : step t p inp s =
        { x := x2, y := if down then fl else y1, vx := if hit then vBias else vx1,
          vy := if down then vBias else vy1, fuel := subSat s.fuel (if inp = 0 then 0 else 1),
          dist := max s.dist x2, tick := s.tick + 1,
          crashed := if hit && vBias + smashSpeed ≤ vx1 then 1 else 0 } := by
      unfold step
      rw [if_neg hcr]
      simp only [gt_iff_lt, ← hgr, ← hvx1, ← hvy1, ← hx1def, ← hy1def, ← hhitdef, ← hx2def,
        ← hfldef, hdowndef, decide_eq_true_eq]
    -- the bounds the writes need
    have hw : W32 = 4294967296 := rfl
    have hmx : maxX = 2047 := rfl
    have hmy : maxY = 240 := rfl
    have hvb : vBias = 1024 := rfl
    have hvc : vCap = 48 := rfl
    have hvxhi : vx1 ≤ vBias + vCap := newVX_hi p s inp gr
    have hvyhi : vy1 ≤ vBias + vCap := newVY_hi p s inp
    have hfllt : fl < W32 := by rw [← mfl]; exact mFloor_lt _ _
    have hfuellt : m.word sFuel < W32 := Mem.word_lt _ _
    refine ⟨tickMem m inp, by rw [tick_mem m hmass locals fuel, if_neg hcrm], ?_, ?_, ?_⟩
    · rw [hstep]
      refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
      · rw [tickMem, mx2]
        exact writeChain_word_sX m (by omega)
      · rw [tickMem, mdown, my1, mfl]
        refine (writeChain_word_sY m ?_).trans ?_ <;> cases down <;> simp <;> omega
      · rw [tickMem, mhit, mvx]
        refine (writeChain_word_sVX m ?_).trans ?_ <;> cases hit <;> simp <;> omega
      · rw [tickMem, mdown, mvy]
        refine (writeChain_word_sVY m ?_).trans ?_ <;> cases down <;> simp <;> omega
      · rw [tickMem]
        refine (writeChain_word_sFuel m ?_).trans ?_
        · unfold mFuel
          omega
        · unfold mFuel subSat
          rw [hs.fuel]
      · rw [tickMem]
        refine (writeChain_word_sDist m ?_).trans ?_
        · unfold mDist
          have := hinv.dist_le
          rw [hs.dist]
          omega
        · unfold mDist
          rw [hs.dist, mx2]
      · rw [tickMem]
        refine (writeChain_word_sTick m ?_).trans ?_
        · exact wrap_lt _
        · unfold mTick
          rw [hs.tick]
          exact wrap_eq_self htick
      · rw [tickMem]
        refine (writeChain_word_sCrash m ?_).trans ?_
        · unfold mCrash
          rw [mhit, mvx]
          cases hit <;> by_cases h : vBias + smashSpeed ≤ vx1 <;> simp [h] <;> omega
        · unfold mCrash
          rw [mhit, mvx]
          cases hit <;> by_cases h : vBias + smashSpeed ≤ vx1 <;> simp [h]
    · refine ⟨fun c hc => ?_⟩
      simp only [trackLen] at hc
      rw [tickMem, writeChain_byte_low m (by simp only [trackAddr, sX]; omega)]
      exact ht.ground c hc
    · exact
        { mass := by rw [tickMem, writeChain_word_high m (by decide)]; exact hp.mass
          thrust := by rw [tickMem, writeChain_word_high m (by decide)]; exact hp.thrust
          lift := by rw [tickMem, writeChain_word_high m (by decide)]; exact hp.lift
          fuel := by rw [tickMem, writeChain_word_high m (by decide)]; exact hp.fuel
          payload := by rw [tickMem, writeChain_word_high m (by decide)]; exact hp.payload
          finish := by rw [tickMem, writeChain_word_high m (by decide)]; exact hp.finish }

end

end RigKernel
