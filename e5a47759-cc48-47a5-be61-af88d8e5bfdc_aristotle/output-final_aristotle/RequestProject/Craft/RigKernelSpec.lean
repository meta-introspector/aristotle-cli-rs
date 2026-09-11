import RequestProject.Craft.RigKernel

/-!
# The kernel says what the rule book says

`RequestProject/RigKernel.lean` builds the WebAssembly module that ships to the
player's phone; `RequestProject/RigSim.lean` is the rule book the game's theorems
are about.  This file ties the two together: it says what it means for the
kernel's linear memory to *hold* a run, and proves that the exported functions
move that memory the way the rule book moves a `Sim`.

* `score_correct` — `score` returns exactly `Rig.score`;
* `reset_correct` — `reset` leaves the memory image of `Sim.start`.

The other two exports are matched in the files that build on this one:
`RequestProject/RigKernelTickSpec.lean` (`tick_correct`) and
`RequestProject/RigKernelSetupSpec.lean` (`setup_correct`).
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace RigKernel

open RigVM Rig

/-! ## What memory holds -/

/-- The eight state words hold the run `s`. -/
structure StateAt (m : Mem) (s : Sim) : Prop where
  x : m.word sX = s.x
  y : m.word sY = s.y
  vx : m.word sVX = s.vx
  vy : m.word sVY = s.vy
  fuel : m.word sFuel = s.fuel
  dist : m.word sDist = s.dist
  tick : m.word sTick = s.tick
  crash : m.word sCrash = s.crashed

/-- The parameter words hold the rig `p` and the finish line `fin`. -/
structure ParamsAt (m : Mem) (p : Params) (fin : Nat) : Prop where
  mass : m.word pMass = p.mass
  thrust : m.word pThrust = p.thrust
  lift : m.word pLift = p.lift
  fuel : m.word pFuel = p.fuel
  payload : m.word pPayload = p.payload
  finish : m.word pFinish = fin

/-- The track bytes hold the track `t`. -/
structure TrackAt (m : Mem) (t : Track) : Prop where
  ground : ∀ c, c < trackLen → m.byte (trackAddr + c) = t.ground c

/-- The rig's numbers are small enough that nothing wraps.  Every design built in
the game satisfies this: there are at most 63 blocks and each contributes at most a
handful. -/
structure Small (p : Params) : Prop where
  mass_pos : 0 < p.mass
  mass : p.mass < 65536
  thrust : p.thrust < 65536
  lift : p.lift < 65536
  fuel : p.fuel < 65536
  payload : p.payload < 65536

/-! ## Expressions -/

theorem pushes_congr {is : List Instr} {f g : Store → Nat} (h : Pushes is f)
    (e : ∀ st, f st = g st) : Pushes is g := by
  intro c fuel
  rw [h c fuel, e c.st]

theorem runs_congr {is : List Instr} {f g : Store → Store} (h : Runs is f)
    (e : ∀ st, f st = g st) : Runs is g := by
  intro c fuel
  rw [h c fuel, e c.st]

theorem pushes_cst {n : Nat} (h : n < W32) : Pushes (cst n) (fun _ => n) :=
  Pushes.const n h

theorem pushes_lget (i : Nat) : Pushes (lget i) (fun st => st.get i) :=
  Pushes.localGet i

theorem pushes_wLoad (a : Nat) : Pushes (wLoad a) (fun st => st.mem.word a) := by
  have h := Pushes.load (a := cst 0) (fa := fun _ => 0)
    (pushes_cst (by decide : (0 : Nat) < W32)) a
  exact pushes_congr h (fun st => by simp)

theorem pushes_op {o : Bin} {a b : List Instr} {fa fb : Store → Nat}
    (ha : Pushes a fa) (hb : Pushes b fb) (hz : ∀ st, o.divides = true → fb st ≠ 0) :
    Pushes (op o a b) (fun st => o.eval (fa st) (fb st)) :=
  Pushes.bin o ha hb hz

theorem pushes_op' {o : Bin} {a b : List Instr} {fa fb : Store → Nat}
    (ha : Pushes a fa) (hb : Pushes b fb) (hz : o.divides = false) :
    Pushes (op o a b) (fun st => o.eval (fa st) (fb st)) :=
  Pushes.bin o ha hb (fun _ h => by rw [hz] at h; exact absurd h (by simp))

theorem pushes_sel {x y k : List Instr} {fx fy fk : Store → Nat}
    (hx : Pushes x fx) (hy : Pushes y fy) (hk : Pushes k fk) :
    Pushes (sel x y k) (fun st => if fk st = 0 then fy st else fx st) :=
  Pushes.select hx hy hk

theorem pushes_bLoad {e : List Instr} {fe : Store → Nat} (he : Pushes e fe) :
    Pushes (bLoad e) (fun st => st.mem.byte (fe st)) :=
  pushes_congr (Pushes.load8 he 0) (fun st => by simp)

theorem pushes_eMin {a b : List Instr} {fa fb : Store → Nat}
    (ha : Pushes a fa) (hb : Pushes b fb) :
    Pushes (eMin a b) (fun st => min (fa st) (fb st)) := by
  refine pushes_congr (pushes_sel ha hb (pushes_op' (o := .ltu) ha hb rfl)) (fun st => ?_)
  simp only [Bin.eval]
  by_cases h : fa st < fb st <;> simp [h] <;> omega

theorem pushes_eMax {a b : List Instr} {fa fb : Store → Nat}
    (ha : Pushes a fa) (hb : Pushes b fb) :
    Pushes (eMax a b) (fun st => max (fa st) (fb st)) := by
  refine pushes_congr (pushes_sel ha hb (pushes_op' (o := .gtu) ha hb rfl)) (fun st => ?_)
  simp only [Bin.eval]
  by_cases h : fb st < fa st <;> simp [h] <;> omega

theorem pushes_eSubSat {a b : List Instr} {fa fb : Store → Nat}
    (ha : Pushes a fa) (hb : Pushes b fb) (hlt : ∀ st, fa st < W32) :
    Pushes (eSubSat a b) (fun st => fa st - fb st) := by
  refine pushes_congr (pushes_sel (pushes_op' (o := .sub) ha hb rfl)
    (pushes_cst (by decide : (0 : Nat) < W32))
    (pushes_op' (o := .geu) ha hb rfl)) (fun st => ?_)
  by_cases h : fb st ≤ fa st
  · have h1 : fa st + W32 - fb st = (fa st - fb st) + W32 := by omega
    have h2 : fa st - fb st < W32 := by have := hlt st; omega
    simp [Bin.eval, h, wrap, h1, Nat.add_mod_right, Nat.mod_eq_of_lt h2]
  · have h3 : fa st - fb st = 0 := by omega
    simp [Bin.eval, h, h3]

/-! ## Statements -/

theorem runs_lset {i : Nat} {e : List Instr} {fe : Store → Nat} (he : Pushes e fe) :
    Runs (lset i e) (fun st => st.set i (fe st)) :=
  Runs.localSet he i

theorem runs_wStore {a : Nat} {e : List Instr} {fe : Store → Nat} (he : Pushes e fe) :
    Runs (wStore a e) (fun st => { st with mem := st.mem.setWord a (fe st) }) := by
  have h := Runs.store (a := cst 0) (fa := fun _ => 0)
    (pushes_cst (by decide : (0 : Nat) < W32)) he a
  exact runs_congr h (fun st => by simp)

/-! ## `score` -/

theorem pushes_scoreBody : Pushes scoreBody (fun st =>
    wrap (wrap (st.mem.word sDist / unit +
        (if st.mem.word pFinish ≤ st.mem.word sDist then st.mem.word pPayload else 0)) +
      st.mem.word sFuel / 8) -
      (if st.mem.word sCrash = 1 then crashPenalty else 0)) := by
  have hdist : Pushes (op .divu (wLoad sDist) (cst unit))
      (fun st => st.mem.word sDist / unit) :=
    pushes_op (o := .divu) (pushes_wLoad sDist) (pushes_cst (by decide))
      (fun _ _ => by decide)
  have hfuel : Pushes (op .divu (wLoad sFuel) (cst 8))
      (fun st => st.mem.word sFuel / 8) :=
    pushes_op (o := .divu) (pushes_wLoad sFuel) (pushes_cst (by decide))
      (fun _ _ => by decide)
  have hpay : Pushes (sel (wLoad pPayload) (cst 0) (op .leu (wLoad pFinish) (wLoad sDist)))
      (fun st => if st.mem.word pFinish ≤ st.mem.word sDist then st.mem.word pPayload
        else 0) := by
    refine pushes_congr (pushes_sel (pushes_wLoad pPayload) (pushes_cst (by decide))
      (pushes_op' (o := .leu) (pushes_wLoad pFinish) (pushes_wLoad sDist) rfl)) (fun st => ?_)
    by_cases h : st.mem.word pFinish ≤ st.mem.word sDist <;> simp [Bin.eval, h]
  have hpen : Pushes (sel (cst crashPenalty) (cst 0) (op .eq (wLoad sCrash) (cst 1)))
      (fun st => if st.mem.word sCrash = 1 then crashPenalty else 0) := by
    refine pushes_congr (pushes_sel (pushes_cst (by decide)) (pushes_cst (by decide))
      (pushes_op' (o := .eq) (pushes_wLoad sCrash) (pushes_cst (by decide)) rfl)) (fun st => ?_)
    by_cases h : st.mem.word sCrash = 1 <;> simp [Bin.eval, h]
  exact pushes_eSubSat
    (pushes_op' (o := .add) (pushes_op' (o := .add) hdist hpay rfl) hfuel rfl) hpen
    (fun _ => wrap_lt _)

theorem score_correct {m : Mem} {t : Track} {p : Params} {s : Sim} {locals : Locals}
    {fuel : Nat} (hs : StateAt m s) (hp : ParamsAt m p t.finish) (hb : Small p)
    (hinv : Sim.Inv p s) :
    call scoreBody locals m fuel = some (Rig.score t p s, m) := by
  have hpush := pushes_scoreBody ⟨[], ⟨locals, m⟩⟩ fuel
  have hu : unit = 16 := rfl
  have hd : s.dist ≤ maxX := hinv.dist_le
  have hmx : maxX = 2047 := rfl
  have hf : s.fuel < 65536 := lt_of_le_of_lt hinv.fuel_le hb.fuel
  have hdiv : s.dist / unit ≤ 127 := by
    have : s.dist / 16 ≤ 2047 / 16 := Nat.div_le_div_right (by omega)
    rw [hu]
    omega
  have hpayb := hb.payload
  have hif : (if t.finish ≤ s.dist then p.payload else 0) ≤ p.payload := by split <;> simp
  have hA : s.dist / unit + (if t.finish ≤ s.dist then p.payload else 0) < W32 := by
    have : W32 = 4294967296 := rfl
    omega
  have hB : s.dist / unit + (if t.finish ≤ s.dist then p.payload else 0) + s.fuel / 8 < W32 := by
    have h8 : s.fuel / 8 ≤ s.fuel := Nat.div_le_self _ _
    have : W32 = 4294967296 := rfl
    omega
  unfold call
  rw [hpush]
  simp only [hs.dist, hs.fuel, hs.crash, hp.payload, hp.finish, wrap_eq_self hA,
    wrap_eq_self hB]
  rfl

/-! ## `reset` -/

theorem pushes_eFloor {x : List Instr} {fx : Store → Nat} (hx : Pushes x fx) :
    Pushes (eFloor x) (fun st => unit * st.mem.byte (wrap (trackAddr + fx st / 16))) := by
  have hshr : Pushes (op .shru x (cst 4)) (fun st => fx st / 16) := by
    refine pushes_congr (pushes_op' (o := .shru) hx (pushes_cst (by decide)) rfl) (fun st => ?_)
    norm_num [Bin.eval]
  have haddr : Pushes (op .add (cst trackAddr) (op .shru x (cst 4)))
      (fun st => wrap (trackAddr + fx st / 16)) :=
    pushes_op' (o := .add) (pushes_cst (by decide)) hshr rfl
  refine pushes_congr (pushes_op' (o := .mul) (pushes_cst (by decide))
    (pushes_bLoad haddr) rfl) (fun st => ?_)
  have hlt : st.mem.byte (wrap (trackAddr + fx st / 16)) < 256 := Nat.mod_lt _ (by decide)
  have : unit * st.mem.byte (wrap (trackAddr + fx st / 16)) < W32 := by
    rw [show unit = 16 from rfl, show W32 = 4294967296 from rfl]
    omega
  exact wrap_eq_self this

/-- The eight state words, written in order: this is the shape of the memory both
`reset` and `tick` leave behind. -/
def writeChain (m : Mem) (x y vx vy fuel dist tick crash : Nat) : Mem :=
  ((((((((m.setWord sX x).setWord sY y).setWord sVX vx).setWord sVY vy).setWord sFuel
    fuel).setWord sDist dist).setWord sTick tick).setWord sCrash crash)

section WriteChain

variable (m : Mem) {x y vx vy fuel dist tick crash : Nat}

theorem writeChain_word_sX (h : x < W32) :
    (writeChain m x y vx vy fuel dist tick crash).word sX = x := by
  simp only [writeChain]
  rw [Mem.word_setWord_ne (a := sCrash) (b := sX) _ _ (by decide),
    Mem.word_setWord_ne (a := sTick) (b := sX) _ _ (by decide),
    Mem.word_setWord_ne (a := sDist) (b := sX) _ _ (by decide),
    Mem.word_setWord_ne (a := sFuel) (b := sX) _ _ (by decide),
    Mem.word_setWord_ne (a := sVY) (b := sX) _ _ (by decide),
    Mem.word_setWord_ne (a := sVX) (b := sX) _ _ (by decide),
    Mem.word_setWord_ne (a := sY) (b := sX) _ _ (by decide),
    Mem.word_setWord_self]
  exact Nat.mod_eq_of_lt h

theorem writeChain_word_sY (h : y < W32) :
    (writeChain m x y vx vy fuel dist tick crash).word sY = y := by
  simp only [writeChain]
  rw [Mem.word_setWord_ne (a := sCrash) (b := sY) _ _ (by decide),
    Mem.word_setWord_ne (a := sTick) (b := sY) _ _ (by decide),
    Mem.word_setWord_ne (a := sDist) (b := sY) _ _ (by decide),
    Mem.word_setWord_ne (a := sFuel) (b := sY) _ _ (by decide),
    Mem.word_setWord_ne (a := sVY) (b := sY) _ _ (by decide),
    Mem.word_setWord_ne (a := sVX) (b := sY) _ _ (by decide),
    Mem.word_setWord_self]
  exact Nat.mod_eq_of_lt h

theorem writeChain_word_sVX (h : vx < W32) :
    (writeChain m x y vx vy fuel dist tick crash).word sVX = vx := by
  simp only [writeChain]
  rw [Mem.word_setWord_ne (a := sCrash) (b := sVX) _ _ (by decide),
    Mem.word_setWord_ne (a := sTick) (b := sVX) _ _ (by decide),
    Mem.word_setWord_ne (a := sDist) (b := sVX) _ _ (by decide),
    Mem.word_setWord_ne (a := sFuel) (b := sVX) _ _ (by decide),
    Mem.word_setWord_ne (a := sVY) (b := sVX) _ _ (by decide),
    Mem.word_setWord_self]
  exact Nat.mod_eq_of_lt h

theorem writeChain_word_sVY (h : vy < W32) :
    (writeChain m x y vx vy fuel dist tick crash).word sVY = vy := by
  simp only [writeChain]
  rw [Mem.word_setWord_ne (a := sCrash) (b := sVY) _ _ (by decide),
    Mem.word_setWord_ne (a := sTick) (b := sVY) _ _ (by decide),
    Mem.word_setWord_ne (a := sDist) (b := sVY) _ _ (by decide),
    Mem.word_setWord_ne (a := sFuel) (b := sVY) _ _ (by decide),
    Mem.word_setWord_self]
  exact Nat.mod_eq_of_lt h

theorem writeChain_word_sFuel (h : fuel < W32) :
    (writeChain m x y vx vy fuel dist tick crash).word sFuel = fuel := by
  simp only [writeChain]
  rw [Mem.word_setWord_ne (a := sCrash) (b := sFuel) _ _ (by decide),
    Mem.word_setWord_ne (a := sTick) (b := sFuel) _ _ (by decide),
    Mem.word_setWord_ne (a := sDist) (b := sFuel) _ _ (by decide),
    Mem.word_setWord_self]
  exact Nat.mod_eq_of_lt h

theorem writeChain_word_sDist (h : dist < W32) :
    (writeChain m x y vx vy fuel dist tick crash).word sDist = dist := by
  simp only [writeChain]
  rw [Mem.word_setWord_ne (a := sCrash) (b := sDist) _ _ (by decide),
    Mem.word_setWord_ne (a := sTick) (b := sDist) _ _ (by decide),
    Mem.word_setWord_self]
  exact Nat.mod_eq_of_lt h

theorem writeChain_word_sTick (h : tick < W32) :
    (writeChain m x y vx vy fuel dist tick crash).word sTick = tick := by
  simp only [writeChain]
  rw [Mem.word_setWord_ne (a := sCrash) (b := sTick) _ _ (by decide),
    Mem.word_setWord_self]
  exact Nat.mod_eq_of_lt h

theorem writeChain_word_sCrash (h : crash < W32) :
    (writeChain m x y vx vy fuel dist tick crash).word sCrash = crash := by
  simp only [writeChain]
  rw [Mem.word_setWord_self]
  exact Nat.mod_eq_of_lt h

/-- Neither `reset` nor `tick` touches anything below the state words — the design
grid, the track and the constant tables are left exactly as they were. -/
theorem writeChain_byte_low {a : Nat} (h : a < sX) :
    (writeChain m x y vx vy fuel dist tick crash).byte a = m.byte a := by
  have h' : a < 512 := h
  simp only [writeChain]
  rw [Mem.byte_setWord_ne (a := sCrash) (b := a) _ _ (Or.inl (by simp only [sCrash]; omega)),
    Mem.byte_setWord_ne (a := sTick) (b := a) _ _ (Or.inl (by simp only [sTick]; omega)),
    Mem.byte_setWord_ne (a := sDist) (b := a) _ _ (Or.inl (by simp only [sDist]; omega)),
    Mem.byte_setWord_ne (a := sFuel) (b := a) _ _ (Or.inl (by simp only [sFuel]; omega)),
    Mem.byte_setWord_ne (a := sVY) (b := a) _ _ (Or.inl (by simp only [sVY]; omega)),
    Mem.byte_setWord_ne (a := sVX) (b := a) _ _ (Or.inl (by simp only [sVX]; omega)),
    Mem.byte_setWord_ne (a := sY) (b := a) _ _ (Or.inl (by simp only [sY]; omega)),
    Mem.byte_setWord_ne (a := sX) (b := a) _ _ (Or.inl (by simp only [sX]; omega))]

/-- Neither `reset` nor `tick` touches the parameter words. -/
theorem writeChain_word_high {a : Nat} (h : sCrash + 4 ≤ a) :
    (writeChain m x y vx vy fuel dist tick crash).word a = m.word a := by
  have h' : 544 ≤ a := h
  simp only [writeChain]
  rw [Mem.word_setWord_ne (a := sCrash) (b := a) _ _ (Or.inr (by simp only [sCrash]; omega)),
    Mem.word_setWord_ne (a := sTick) (b := a) _ _ (Or.inr (by simp only [sTick]; omega)),
    Mem.word_setWord_ne (a := sDist) (b := a) _ _ (Or.inr (by simp only [sDist]; omega)),
    Mem.word_setWord_ne (a := sFuel) (b := a) _ _ (Or.inr (by simp only [sFuel]; omega)),
    Mem.word_setWord_ne (a := sVY) (b := a) _ _ (Or.inr (by simp only [sVY]; omega)),
    Mem.word_setWord_ne (a := sVX) (b := a) _ _ (Or.inr (by simp only [sVX]; omega)),
    Mem.word_setWord_ne (a := sY) (b := a) _ _ (Or.inr (by simp only [sY]; omega)),
    Mem.word_setWord_ne (a := sX) (b := a) _ _ (Or.inr (by simp only [sX]; omega))]

end WriteChain

/-- The memory `reset` leaves behind: the rig on the start line, with the ground
height under column zero read straight out of the track bytes. -/
def resetMem (m : Mem) : Mem :=
  writeChain m 0 (unit * m.byte trackAddr) vBias vBias (m.word pFuel) 0 0 0

/-- Everything `reset` does to memory is `resetMem`. -/
theorem runs_resetBody : Runs resetBody (fun st => { st with mem := resetMem st.mem }) := by
  have h0 : Pushes (cst 0) (fun _ => 0) := pushes_cst (by decide)
  have hfloor : Pushes (eFloor (cst 0)) (fun st => unit * st.mem.byte trackAddr) := by
    refine pushes_congr (pushes_eFloor h0) (fun st => ?_)
    norm_num [wrap, trackAddr, W32]
  have hrun :=
    Runs.seq (Runs.seq (Runs.seq (Runs.seq (Runs.seq (Runs.seq (Runs.seq
      (runs_wStore (a := sX) h0)
      (runs_wStore (a := sY) hfloor))
      (runs_wStore (a := sVX) (pushes_cst (n := vBias) (by decide))))
      (runs_wStore (a := sVY) (pushes_cst (n := vBias) (by decide))))
      (runs_wStore (a := sFuel) (pushes_wLoad pFuel)))
      (runs_wStore (a := sDist) h0))
      (runs_wStore (a := sTick) h0))
      (runs_wStore (a := sCrash) h0)
  refine runs_congr hrun (fun st => ?_)
  have hbyte : (st.mem.setWord sX 0).byte trackAddr = st.mem.byte trackAddr :=
    Mem.byte_setWord_ne (a := sX) (b := trackAddr) _ 0 (Or.inl (by decide))
  have hfuel : (((((st.mem.setWord sX 0).setWord sY
        (unit * st.mem.byte trackAddr)).setWord sVX vBias).setWord sVY vBias)).word pFuel
      = st.mem.word pFuel := by
    rw [Mem.word_setWord_ne (a := sVY) (b := pFuel) _ _ (by decide),
      Mem.word_setWord_ne (a := sVX) (b := pFuel) _ _ (by decide),
      Mem.word_setWord_ne (a := sY) (b := pFuel) _ _ (by decide),
      Mem.word_setWord_ne (a := sX) (b := pFuel) _ _ (by decide)]
  simp only [resetMem, writeChain, hbyte, hfuel]

/-! ### Reading the memory `reset` leaves -/

theorem resetMem_word_sX (m : Mem) : (resetMem m).word sX = 0 :=
  writeChain_word_sX m (by decide)

theorem resetMem_word_sY (m : Mem) : (resetMem m).word sY = unit * m.byte trackAddr := by
  refine writeChain_word_sY m ?_
  have : m.byte trackAddr < 256 := Nat.mod_lt _ (by decide)
  rw [show unit = 16 from rfl, show W32 = 4294967296 from rfl]
  omega

theorem resetMem_word_sVX (m : Mem) : (resetMem m).word sVX = vBias :=
  writeChain_word_sVX m (by decide)

theorem resetMem_word_sVY (m : Mem) : (resetMem m).word sVY = vBias :=
  writeChain_word_sVY m (by decide)

theorem resetMem_word_sFuel (m : Mem) (h : m.word pFuel < W32) :
    (resetMem m).word sFuel = m.word pFuel :=
  writeChain_word_sFuel m h

theorem resetMem_word_sDist (m : Mem) : (resetMem m).word sDist = 0 :=
  writeChain_word_sDist m (by decide)

theorem resetMem_word_sTick (m : Mem) : (resetMem m).word sTick = 0 :=
  writeChain_word_sTick m (by decide)

theorem resetMem_word_sCrash (m : Mem) : (resetMem m).word sCrash = 0 :=
  writeChain_word_sCrash m (by decide)

theorem resetMem_byte_low (m : Mem) {a : Nat} (h : a < sX) : (resetMem m).byte a = m.byte a :=
  writeChain_byte_low m h

theorem resetMem_word_high (m : Mem) {a : Nat} (h : sCrash + 4 ≤ a) :
    (resetMem m).word a = m.word a :=
  writeChain_word_high m h

theorem reset_correct {m : Mem} {t : Track} {p : Params} {locals : Locals} {fuel : Nat}
    (ht : TrackAt m t) (hp : ParamsAt m p t.finish) (hb : Small p) :
    ∃ m', callVoid resetBody locals m fuel = some m' ∧ StateAt m' (Sim.start t p) ∧
      TrackAt m' t ∧ ParamsAt m' p t.finish := by
  have hres := runs_resetBody ⟨[], ⟨locals, m⟩⟩ fuel
  have hg0 : m.byte trackAddr = t.ground 0 := by
    simpa using ht.ground 0 (by decide)
  have hfu : m.word pFuel = p.fuel := hp.fuel
  have hfult : m.word pFuel < W32 := by
    have := hb.fuel
    rw [hfu, show W32 = 4294967296 from rfl]
    omega
  refine ⟨resetMem m, ?_, ?_, ?_, ?_⟩
  · unfold callVoid
    rw [hres]
  · exact
      { x := by simpa [Sim.start] using resetMem_word_sX m
        y := by simpa [Sim.start, hg0] using resetMem_word_sY m
        vx := by simpa [Sim.start] using resetMem_word_sVX m
        vy := by simpa [Sim.start] using resetMem_word_sVY m
        fuel := by simpa [Sim.start, hfu] using resetMem_word_sFuel m hfult
        dist := by simpa [Sim.start] using resetMem_word_sDist m
        tick := by simpa [Sim.start] using resetMem_word_sTick m
        crash := by simpa [Sim.start] using resetMem_word_sCrash m }
  · exact
      { ground := fun c hc => by
          rw [resetMem_byte_low m (by simp [trackAddr, sX]; simp [trackLen] at hc; omega)]
          exact ht.ground c hc }
  · exact
      { mass := by rw [resetMem_word_high m (by decide)]; exact hp.mass
        thrust := by rw [resetMem_word_high m (by decide)]; exact hp.thrust
        lift := by rw [resetMem_word_high m (by decide)]; exact hp.lift
        fuel := by rw [resetMem_word_high m (by decide)]; exact hp.fuel
        payload := by rw [resetMem_word_high m (by decide)]; exact hp.payload
        finish := by rw [resetMem_word_high m (by decide)]; exact hp.finish }

end RigKernel
