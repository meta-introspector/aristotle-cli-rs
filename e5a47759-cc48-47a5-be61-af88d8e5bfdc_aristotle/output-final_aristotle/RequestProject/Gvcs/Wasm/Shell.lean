import RequestProject.Gvcs.Wasm.Correct
import RequestProject.Gvcs.UI

/-!
# The shell functions are correct

`RequestProject/Wasm/Correct.lean` proves that the generated `enabled` and
`apply` play the rule book of `RequestProject/Game.lean`.  Three functions of
the module were left over: the two that move about the menu tree (`nav` and
`back`), and the one that draws the figure on the head-up display
(`netWorth`) — together with `commit`, the function a mouse click actually
calls, which plays a move only if the screen on show is the one that offers it.

This file proves them, against `RequestProject/UI.lean`, the model of the
interface:

* `Menus` — the screen graph and the "which screen offers which move" table are
  in memory, as `UI.Screen.parent` and `UI.home` say they should be.
* `RepUI s scr mem` — the memory holds the position `s` *and* the screen `scr`.
* `nav_correct`, `back_correct` — the two navigation functions answer `1`
  exactly when the interface accepts the click, and leave the screen cell
  holding the screen `UI.handle` moves to.  The position of the game is
  untouched.
* `commit_correct` — a click plays the move exactly when the screen offers it
  and the rule book accepts it; on any other click the memory does not move.
  `commit_matches_ui` states the same thing as agreement with `UI.handle`.
* `netWorth_correct` — the head-up display figure is the net worth of
  `Game.lean`, in units of `10⁻¹²`; `netWorth_toQ` converts it.

With these, the only parts of the browser implementation that are still taken
on trust are the binary encoder and the JavaScript that draws the page.
-/

namespace LifeTrac
namespace Wasm

open Build Runtime UI

/-! ## Sums the way the code adds them up -/

/-- A sum over a fintype is the sum over any duplicate-free list of all its
elements. -/
theorem sum_eq_list_sum {α M : Type*} [DecidableEq α] [Fintype α] [AddCommMonoid M]
    (l : List α) (hn : l.Nodup) (hc : ∀ a, a ∈ l) (f : α → M) :
    ∑ a : α, f a = (l.map f).sum := by
  rw [← List.sum_toFinset _ hn]
  exact Finset.sum_congr (by ext a; simp [hc a]) (fun _ _ => rfl)

/-- The assembly at a given position in the tables: the inverse of `idxP`. -/
def partOf : Nat → RPart
  | 0 => .frame | 1 => .wheelModule | 2 => .powerUnit | 3 => .controlStation
  | 4 => .loader | 5 => .finishing | _ => .lifeTrac

theorem idxP_partOf {i : Nat} (h : i ≤ 6) : idxP (partOf i) = (i : Int) := by
  interval_cases i <;> rfl

/-- A sum over the materials is the sum over the twenty-four table positions. -/
theorem sum_material (f : Material → Int) :
    ∑ m : Material, f m = ((List.range 24).map (fun i => f (matOf i))).sum := by
  rw [sum_eq_list_sum ((List.range 24).map matOf) (by decide) (by decide) f, List.map_map]
  rfl

/-- A sum over the assemblies is the sum over the seven table positions. -/
theorem sum_part (f : RPart → Int) :
    ∑ p : RPart, f p = ((List.range 7).map (fun i => f (partOf i))).sum := by
  rw [sum_eq_list_sum ((List.range 7).map partOf) (by decide) (by decide) f, List.map_map]
  rfl

/-- Adding a list of cells up, left to right, is adding their values up. -/
theorem computes_foldl_add {L : List Int} {mem : Int → Int} {g : Nat → List Instr}
    {v : Nat → Int} :
    ∀ (l : List Nat), (∀ i ∈ l, Computes L mem (g i) (v i)) →
      ∀ (base : List Instr) (a : Int), Computes L mem base a →
        Computes L mem (l.foldl (fun acc i => addE acc (g i)) base) (a + (l.map v).sum) := by
  intro l
  induction l with
  | nil => intro _ base a hb; simpa using hb
  | cons i l ih =>
      intro hg base a hb
      have h' := ih (fun j hj => hg j (by simp [hj])) (addE base (g i)) (a + v i)
        (Computes.add hb (hg i (by simp)))
      simpa [List.sum_cons, add_assoc] using h'

/-! ## The screen graph in memory -/

/-- The number the module keeps in the screen cell for each screen. -/
def scrIdx : Screen → Int
  | .title => 0 | .yard => 1 | .market => 2 | .workbench => 3
  | .field => 4 | .ledger => 5 | .help => 6

/-- The parent-screen table: the screen a screen was opened from, and `-1` for
the title screen, which has none. -/
def parIdx (s : Screen) : Int := s.parent.elim (-1) scrIdx

theorem scrIdx_bounds (s : Screen) : 0 ≤ scrIdx s ∧ scrIdx s ≤ 6 := by
  cases s <;> exact ⟨by decide, by decide⟩

/-- The parent table answers the question the interface asks: is this screen a
submenu of the one on show? -/
theorem parIdx_eq_iff (t scr : Screen) : (parIdx t = scrIdx scr) ↔ t.parent = some scr := by
  cases t <;> cases scr <;> simp [parIdx, scrIdx, Screen.parent]

/-- The screen cell is at least one exactly on the screens the back button
works on. -/
theorem one_le_scrIdx_iff (scr : Screen) : (1 : Int) ≤ scrIdx scr ↔ scr ≠ Screen.title := by
  cases scr <;> simp [scrIdx]

/-- The screen graph and the offers table, as the module holds them. -/
structure Menus (mem : Int → Int) : Prop where
  /-- The parent of every screen. -/
  parent : ∀ s : Screen, mem (PARENT + 8 * scrIdx s) = parIdx s
  /-- The screen every kind of move is made on. -/
  home : ∀ a : RAction, mem (HOME + 8 * (kindOf a : Int)) = scrIdx (UI.home (absAction a))

/-- The memory holds the position `s` and the screen `scr`. -/
structure RepUI (s : RState) (scr : Screen) (mem : Int → Int) : Prop where
  /-- The position of the game. -/
  rep : Rep s mem
  /-- The menu tables. -/
  menus : Menus mem
  /-- The screen on show. -/
  screen : mem SCREEN = scrIdx scr

/-! ## The frozen cells carry the shell -/

theorem frozen_screen : Frozen SCREEN := Or.inl rfl

theorem frozen_parent (s : Screen) : Frozen (PARENT + 8 * scrIdx s) := by
  have := (scrIdx_bounds s).1
  right; simp only [PARENT]; omega

theorem frozen_home (a : RAction) : Frozen (HOME + 8 * (kindOf a : Int)) := by
  right; simp only [HOME]; omega

/-- A block that only writes to the state region leaves the menus standing. -/
theorem Menus.of_frozen {mem mem' : Int → Int} (h : Menus mem)
    (hf : ∀ x : Int, Frozen x → mem' x = mem x) : Menus mem' where
  parent s := by rw [hf _ (frozen_parent s)]; exact h.parent s
  home a := by rw [hf _ (frozen_home a)]; exact h.home a

theorem screen_ne_cash : (SCREEN : Int) ≠ CASH := by decide
theorem screen_ne_fuel : (SCREEN : Int) ≠ FUEL := by decide
theorem screen_ne_day : (SCREEN : Int) ≠ DAY := by decide
theorem screen_ne_hect : (SCREEN : Int) ≠ HECT := by decide

theorem screen_ne_stock (m : Material) : STOCK + 8 * idxM m ≠ SCREEN := by
  have := (idxM_bounds m).1; simp only [STOCK, SCREEN]; omega

theorem screen_ne_built (a : RPart) : BUILT + 8 * idxP a ≠ SCREEN := by
  have := (idxP_bounds a).1; simp only [BUILT, SCREEN]; omega

theorem screen_lt : (SCREEN : Int) < 1024 := by decide

/-- Writing the screen cell changes nothing about the position of the game. -/
theorem Rep.storeScreen {s : RState} {mem : Int → Int} (h : Rep s mem) (v : Int) :
    Rep s (store1 mem SCREEN v) where
  tables := h.tables.store screen_lt
  cash := by rw [store1_other screen_ne_cash.symm]; exact h.cash
  fuel := by rw [store1_other screen_ne_fuel.symm]; exact h.fuel
  day := by rw [store1_other screen_ne_day.symm]; exact h.day
  hect := by rw [store1_other screen_ne_hect.symm]; exact h.hect
  stock m := by rw [store1_other (screen_ne_stock m)]; exact h.stock m
  built a := by rw [store1_other (screen_ne_built a)]; exact h.built a

/-- Nor does it disturb the menu tables. -/
theorem Menus.storeScreen {mem : Int → Int} (h : Menus mem) (v : Int) :
    Menus (store1 mem SCREEN v) where
  parent s := by
    rw [store1_other (by have := (scrIdx_bounds s).1; simp only [PARENT, SCREEN]; omega)]
    exact h.parent s
  home a := by
    rw [store1_other (by simp only [HOME, SCREEN]; omega)]
    exact h.home a

/-- Moving to another screen. -/
theorem RepUI.storeScreen {s : RState} {scr : Screen} {mem : Int → Int} (h : RepUI s scr mem)
    (t : Screen) : RepUI s t (store1 mem SCREEN (scrIdx t)) where
  rep := h.rep.storeScreen _
  menus := h.menus.storeScreen _
  screen := store1_same _ _ _

/-- The interface state a memory stands for: the screen on show and the
position of the game, with an empty undo stack and log. -/
def uiOf (s : RState) (scr : Screen) : UIState := ⟨scr, absState s, [], []⟩

/-! ## Navigation -/

/-- **The generated `nav` is the interface's navigation.**  It answers `1`
exactly when the screen asked for is a submenu of the screen on show, and the
screen cell it leaves behind is the screen `UI.handle` moves to.  The position
of the game is untouched. -/
theorem nav_correct {mem : Int → Int} {s : RState} {scr t : Screen} (h : RepUI s scr mem) :
    ∃ mem', runFun navBody [scrIdx t] 0 mem = (ofBool (decide (t.parent = some scr)), mem') ∧
      RepUI s (handle homestead (uiOf s scr) (.nav t)).screen mem' := by
  have hlocal : Computes [scrIdx t] mem [Instr.localGet 0] (scrIdx t) := Computes.localGet 0
  have hguard : Computes [scrIdx t] mem (eqE (loadCell PARENT [.localGet 0]) (get SCREEN))
      (ofBool (decide (t.parent = some scr))) := by
    have h1 : Computes [scrIdx t] mem (loadCell PARENT [.localGet 0]) (parIdx t) := by
      have h' := computes_loadCell (L := [scrIdx t]) (mem := mem) PARENT hlocal
      rwa [h.menus.parent t] at h'
    have h2 : Computes [scrIdx t] mem (get SCREEN) (scrIdx scr) := by
      have h' := computes_get (L := [scrIdx t]) (mem := mem) SCREEN
      rwa [h.screen] at h'
    have h3 := Computes.eq h1 h2
    rwa [show decide (parIdx t = scrIdx scr) = decide (t.parent = some scr) from by
      simp [parIdx_eq_iff]] at h3
  by_cases hp : t.parent = some scr
  · refine ⟨store1 mem SCREEN (scrIdx t),
      runFun_argsOf (Runs.guarded hguard (fun _ => Effects.put hlocal) (by simp [hp])), ?_⟩
    have : (handle homestead (uiOf s scr) (.nav t)).screen = t := by
      simp [handle, uiOf, hp]
    rw [this]
    exact h.storeScreen t
  · refine ⟨mem, runFun_argsOf (Runs.guarded hguard (by simp [hp]) (fun _ => rfl)), ?_⟩
    have : (handle homestead (uiOf s scr) (.nav t)).screen = scr := by
      simp [handle, uiOf, hp]
    rw [this]
    exact h

/-- **The generated `back` is the interface's back button.**  It answers `1`
exactly when there is somewhere to go back to, it leaves the screen cell
holding the parent screen, and on the title screen it does nothing. -/
theorem back_correct {mem : Int → Int} {s : RState} {scr : Screen} (h : RepUI s scr mem) :
    ∃ mem', runFun backBody [] 0 mem = (ofBool (decide (scr ≠ Screen.title)), mem') ∧
      RepUI s (handle homestead (uiOf s scr) .back).screen mem' := by
  have hscreen : Computes ([] : List Int) mem (get SCREEN) (scrIdx scr) := by
    have h' := computes_get (L := ([] : List Int)) (mem := mem) SCREEN
    rwa [h.screen] at h'
  have hguard : Computes ([] : List Int) mem (leE (constE 1) (get SCREEN))
      (ofBool (decide (scr ≠ Screen.title))) := by
    have h3 := Computes.le (Computes.const (L := ([] : List Int)) (mem := mem) 1) hscreen
    rwa [show decide ((1 : Int) ≤ scrIdx scr) = decide (scr ≠ Screen.title) from by
      simp [one_le_scrIdx_iff]] at h3
  cases hpar : scr.parent with
  | none =>
      have hti : scr = Screen.title := Screen.parent_eq_none_iff.mp hpar
      refine ⟨mem, runFun_argsOf (Runs.guarded hguard (by simp [hti]) (fun _ => rfl)), ?_⟩
      have : (handle homestead (uiOf s scr) .back).screen = scr := by
        simp [handle, uiOf, hpar]
      rw [this]
      exact h
  | some p =>
      have hne : scr ≠ Screen.title := by
        intro hEq; rw [hEq] at hpar; simp [Screen.parent] at hpar
      have hval : Computes ([] : List Int) mem (loadCell PARENT (get SCREEN)) (scrIdx p) := by
        have h' := computes_loadCell (L := ([] : List Int)) (mem := mem) PARENT hscreen
        rwa [h.menus.parent scr, show parIdx scr = scrIdx p by simp [parIdx, hpar]] at h'
      refine ⟨store1 mem SCREEN (scrIdx p),
        runFun_argsOf (Runs.guarded hguard (fun _ => Effects.put hval) (by simp [hne])), ?_⟩
      have : (handle homestead (uiOf s scr) .back).screen = p := by
        simp [handle, uiOf, hpar]
      rw [this]
      exact h.storeScreen p

/-! ## A mouse click -/

/-- **The generated `commit` is a mouse click.**  The move is played exactly
when the screen on show offers it *and* the rule book accepts it; the memory
that comes out holds the position the rule book reaches, on the same screen;
and a click that is refused — wrong screen or dead button — changes nothing at
all. -/
theorem commit_correct {mem : Int → Int} {s : RState} {scr : Screen} (h : RepUI s scr mem)
    (a : RAction) :
    ∃ mem', runFun commitBody (argsOf a) 0 mem
        = (ofBool (offers scr (absAction a) && (rstep s a).isSome), mem') ∧
      (∀ t, offers scr (absAction a) = true → rstep s a = some t → RepUI t scr mem') ∧
      (offers scr (absAction a) = false → mem' = mem) ∧
      (rstep s a = none → mem' = mem) := by
  have hguard : Computes (argsOf a) mem (eqE (loadCell HOME [.localGet KIND]) (get SCREEN))
      (ofBool (offers scr (absAction a))) := by
    have hk : Computes (argsOf a) mem [Instr.localGet KIND] (kindOf a : Int) :=
      (getD_kind a) ▸ Computes.localGet KIND
    have h1 : Computes (argsOf a) mem (loadCell HOME [.localGet KIND])
        (scrIdx (UI.home (absAction a))) := by
      have h' := computes_loadCell (L := argsOf a) (mem := mem) HOME hk
      rwa [h.menus.home a] at h'
    have h2 : Computes (argsOf a) mem (get SCREEN) (scrIdx scr) := by
      have h' := computes_get (L := argsOf a) (mem := mem) SCREEN
      rwa [h.screen] at h'
    have h3 := Computes.eq h1 h2
    rwa [show decide (scrIdx (UI.home (absAction a)) = scrIdx scr) = offers scr (absAction a) from
      by cases (absAction a) <;> cases scr <;> rfl] at h3
  obtain ⟨mem', hruns, hsome, hnone, hfr⟩ := apply_runs h.rep a
  by_cases ho : offers scr (absAction a) = true
  · refine ⟨mem', runFun_argsOf ?_, ?_, ?_, ?_⟩
    · have : (ofBool (offers scr (absAction a) && (rstep s a).isSome))
          = ofBool (rstep s a).isSome := by rw [ho, Bool.true_and]
      rw [this]
      exact Runs.ifte (p := offers scr (absAction a)) hguard (fun _ => hruns)
        (fun hf => absurd hf (by simp [ho]))
    · intro t _ ht
      exact ⟨hsome t ht, h.menus.of_frozen hfr, by rw [hfr _ frozen_screen]; exact h.screen⟩
    · intro hf; exact absurd hf (by simp [ho])
    · exact hnone
  · have ho' : offers scr (absAction a) = false := by simpa using ho
    refine ⟨mem, runFun_argsOf ?_, ?_, fun _ => rfl, fun _ => rfl⟩
    · rw [ho', Bool.false_and]
      exact Runs.ifte (p := offers scr (absAction a)) hguard
        (fun ht => absurd ht (by simp [ho'])) (fun _ => Runs.of_computes (Computes.const 0))
    · intro t hoo; exact absurd hoo (by simp [ho'])

/-- **A click on the module is a click on the interface.**  Whatever the move,
the memory `commit` leaves behind holds the position `UI.handle` reaches, on
the screen `UI.handle` leaves on show. -/
theorem commit_matches_ui {mem : Int → Int} {s : RState} {scr : Screen} (h : RepUI s scr mem)
    (a : RAction) :
    ∃ (mem' : Int → Int) (u : RState),
      runFun commitBody (argsOf a) 0 mem
          = (ofBool (offers scr (absAction a) && (rstep s a).isSome), mem') ∧
        RepUI u scr mem' ∧
        absState u = (handle homestead (uiOf s scr) (.commit (absAction a))).game := by
  obtain ⟨mem', hrun, hok, hoff, hnone⟩ := commit_correct h a
  by_cases ho : offers scr (absAction a) = true
  · cases hstep : rstep s a with
    | none =>
        rw [hstep] at hrun
        refine ⟨mem', s, hrun, ?_, ?_⟩
        · rw [hnone hstep]; exact h
        · have : step homestead (absState s) (absAction a) = none := by
            rw [← rstep_refines s a, hstep]; rfl
          simp [handle, uiOf, ho, this]
    | some u =>
        rw [hstep] at hrun
        refine ⟨mem', u, hrun, hok u ho hstep, ?_⟩
        have : step homestead (absState s) (absAction a) = some (absState u) := by
          rw [← rstep_refines s a, hstep]; rfl
        simp [handle, uiOf, ho, this]
  · have ho' : offers scr (absAction a) = false := by simpa using ho
    refine ⟨mem', s, hrun, ?_, ?_⟩
    · rw [hoff ho']; exact h
    · simp [handle, uiOf, ho']

/-! ## The head-up display -/

/-- What the player is worth, in the integer units the module works in: cash
and fuel and the shelf at catalogue prices, plus the machines at material cost.
Prices and quantities are both held in millionths, so this is the net worth in
units of `10⁻¹²`. -/
def rNetWorth (s : RState) : Int :=
  s.cash * SCALE + (∑ m : Material, s.stock m * costM m) + s.fuel * fuelPriceM
    + ∑ p : RPart, (s.built.count p : Int) * p.cost * SCALE

/-- **The head-up display figure is the net worth.**  The generated `netWorth`
adds up exactly `rNetWorth`. -/
theorem netWorth_correct {mem : Int → Int} {s : RState} (h : Rep s mem) :
    callFun netWorthBody [] 0 mem = rNetWorth s := by
  have hcash : Computes ([] : List Int) mem (mulE (get CASH) (constE SCALE)) (s.cash * SCALE) := by
    have h' := Computes.mul (computes_get (L := ([] : List Int)) (mem := mem) CASH)
      (Computes.const (L := ([] : List Int)) (mem := mem) SCALE)
    rwa [h.cash] at h'
  have hstock : ∀ i ∈ List.range 24,
      Computes ([] : List Int) mem (mulE (get (STOCK + 8 * (i : Int))) (get (COST + 8 * (i : Int))))
        (s.stock (matOf i) * costM (matOf i)) := by
    intro i hi
    simp only [List.mem_range] at hi
    have hidx : (i : Int) = idxM (matOf i) := (idxM_matOf (by omega)).symm
    have h' := Computes.mul (computes_get (L := ([] : List Int)) (mem := mem)
        (STOCK + 8 * (i : Int)))
      (computes_get (L := ([] : List Int)) (mem := mem) (COST + 8 * (i : Int)))
    rw [hidx, h.stock (matOf i), h.tables.cost (matOf i)] at h'
    rwa [hidx]
  have hshelf := computes_foldl_add (L := ([] : List Int)) (mem := mem)
    (g := fun i => mulE (get (STOCK + 8 * (i : Int))) (get (COST + 8 * (i : Int))))
    (v := fun i => s.stock (matOf i) * costM (matOf i)) (List.range 24) hstock _ _ hcash
  have hfuel : Computes ([] : List Int) mem (mulE (get FUEL) (constE fuelPriceM))
      (s.fuel * fuelPriceM) := by
    have h' := Computes.mul (computes_get (L := ([] : List Int)) (mem := mem) FUEL)
      (Computes.const (L := ([] : List Int)) (mem := mem) fuelPriceM)
    rwa [h.fuel] at h'
  have hbase := Computes.add hshelf hfuel
  have hbuilt : ∀ i ∈ List.range 7,
      Computes ([] : List Int) mem
        (mulE (mulE (get (BUILT + 8 * (i : Int))) (get (PCOST + 8 * (i : Int)))) (constE SCALE))
        ((s.built.count (partOf i) : Int) * (partOf i).cost * SCALE) := by
    intro i hi
    simp only [List.mem_range] at hi
    have hidx : (i : Int) = idxP (partOf i) := (idxP_partOf (by omega)).symm
    have h' := Computes.mul (Computes.mul
        (computes_get (L := ([] : List Int)) (mem := mem) (BUILT + 8 * (i : Int)))
        (computes_get (L := ([] : List Int)) (mem := mem) (PCOST + 8 * (i : Int))))
      (Computes.const (L := ([] : List Int)) (mem := mem) SCALE)
    rw [hidx, h.built (partOf i), h.tables.pcost (partOf i)] at h'
    rwa [hidx]
  have hall := computes_foldl_add (L := ([] : List Int)) (mem := mem)
    (g := fun i => mulE (mulE (get (BUILT + 8 * (i : Int))) (get (PCOST + 8 * (i : Int))))
      (constE SCALE))
    (v := fun i => (s.built.count (partOf i) : Int) * (partOf i).cost * SCALE)
    (List.range 7) hbuilt _ _ hbase
  have : callFun netWorthBody [] 0 mem
      = s.cash * SCALE + ((List.range 24).map
            (fun i => s.stock (matOf i) * costM (matOf i))).sum + s.fuel * fuelPriceM
        + ((List.range 7).map
            (fun i => (s.built.count (partOf i) : Int) * (partOf i).cost * SCALE)).sum := by
    have h0 : runFun netWorthBody [] 0 mem = (_, mem) := runFun_argsOf (Runs.of_computes hall)
    simp only [callFun, h0]
  rw [this, rNetWorth, sum_material (fun m => s.stock m * costM m),
    sum_part (fun p => (s.built.count p : Int) * p.cost * SCALE)]

/-- The rational net worth an integer figure stands for: the module works in
units of `10⁻¹²`. -/
def toQ12 (n : Int) : ℚ := (n : ℚ) / 10 ^ 12

/-- A list sum over the machines built is a sum over the catalogue, counted
with multiplicity. -/
theorem sum_count_map {f : RPart → ℚ} : ∀ l : List RPart,
    (l.map f).sum = ∑ p : RPart, (l.count p : ℚ) * f p := by
  intro l
  induction l with
  | nil => simp
  | cons a l ih =>
      have hcount : ∀ p : RPart, ((a :: l).count p : ℚ) = (if p = a then 1 else 0) + l.count p := by
        intro p
        by_cases hp : p = a
        · subst hp; rw [List.count_cons_self, if_pos rfl]; push_cast; ring
        · rw [List.count_cons_of_ne (Ne.symm hp), if_neg hp]; simp
      simp only [List.map_cons, List.sum_cons, ih]
      rw [show ∑ p : RPart, ((a :: l).count p : ℚ) * f p
          = ∑ p : RPart, ((if p = a then 1 else 0) * f p + (l.count p : ℚ) * f p) from
        Finset.sum_congr rfl (fun p _ => by rw [hcount p]; ring)]
      rw [Finset.sum_add_distrib]
      simp

/-- **The display figure is the net worth of `Game.lean`.**  Divided by
`10¹²`, what the module puts on the head-up display is exactly
`GameState.netWorth` of the position it holds. -/
theorem netWorth_toQ (s : RState) :
    toQ12 (rNetWorth s) = GameState.netWorth homestead (absState s) := by
  have hstock : ((∑ m : Material, s.stock m * costM m : Int) : ℚ) / 10 ^ 12
      = Inventory.value (absState s).stock := by
    rw [Inventory.value]
    push_cast
    rw [Finset.sum_div]
    refine Finset.sum_congr rfl (fun m _ => ?_)
    rw [← toQ_costM m, absState]
    simp only [toQ]
    ring
  have hmach : ((∑ p : RPart, (s.built.count p : Int) * p.cost * SCALE : Int) : ℚ) / 10 ^ 12
      = (absState s).machineValue := by
    rw [GameState.machineValue, absState]
    simp only [List.map_map]
    rw [show ((s.built.map (Assembly.materialCost ∘ RPart.toAssembly)).sum : ℚ)
        = ∑ p : RPart, (s.built.count p : ℚ) * (p.toAssembly.materialCost) from
      sum_count_map s.built]
    push_cast
    rw [Finset.sum_div]
    refine Finset.sum_congr rfl (fun p _ => ?_)
    rw [← toQ_partCost p]
    simp only [toQ, SCALE]
    push_cast
    ring
  rw [toQ12, rNetWorth, GameState.netWorth, ← hstock, ← hmach]
  have hcash : ((s.cash * SCALE : Int) : ℚ) / 10 ^ 12 = (absState s).cash := by
    simp only [absState, toQ, SCALE]; push_cast; ring
  have hfuel : ((s.fuel * fuelPriceM : Int) : ℚ) / 10 ^ 12
      = homestead.fuelPrice * (absState s).fuel := by
    rw [← toQ_fuelPriceM]
    simp only [absState, toQ]
    push_cast
    ring
  rw [← hcash, ← hfuel]
  push_cast
  ring

/-! ## The module starts on the title screen -/

set_option maxRecDepth 8000 in
/-- The menu tables are laid down correctly by the data segment. -/
theorem menus_startMem : Menus startMem where
  parent s := by cases s <;> rfl
  home a := by cases a <;> rfl

/-- **The module opens on the title screen**, with the menus in place and the
opening position on the shelf. -/
theorem repUI_startMem : RepUI rstart Screen.title startMem where
  rep := rep_startMem
  menus := menus_startMem
  screen := rfl

/-! ## A whole session of clicking -/

/-- A click on the module: one of the three shell entry points a mouse can
call. -/
inductive Click where
  /-- Open a submenu. -/
  | nav (t : Screen)
  /-- The back button. -/
  | back
  /-- Press the confirm button of a control. -/
  | commit (a : RAction)

/-- The event of `UI.lean` a click stands for. -/
def Click.toEvent : Click → Event
  | .nav t => .nav t
  | .back => .back
  | .commit a => .commit (absAction a)

/-- The memory a click leaves behind. -/
def clickStep (mem : Int → Int) : Click → (Int → Int)
  | .nav t => memAfter navBody [scrIdx t] 0 mem
  | .back => memAfter backBody [] 0 mem
  | .commit a => memAfter commitBody (argsOf a) 0 mem

/-- The memory a session of clicking leaves behind. -/
def clickAll (mem : Int → Int) : List Click → (Int → Int)
  | [] => mem
  | c :: cs => clickAll (clickStep mem c) cs

/-- One click of the module is one event of the interface. -/
theorem click_step {mem : Int → Int} {s : RState} {u : UIState} (h : RepUI s u.screen mem)
    (hg : absState s = u.game) (c : Click) :
    ∃ t : RState, RepUI t (handle homestead u c.toEvent).screen (clickStep mem c) ∧
      absState t = (handle homestead u c.toEvent).game := by
  cases c with
  | nav scr =>
      obtain ⟨mem', hrun, hrep⟩ := nav_correct (t := scr) h
      have hs : (handle homestead u (Event.nav scr)).screen
          = (handle homestead (uiOf s u.screen) (Event.nav scr)).screen := by
        simp only [handle, uiOf]; split <;> rfl
      refine ⟨s, ?_, ?_⟩
      · show RepUI s (handle homestead u (Event.nav scr)).screen
          (memAfter navBody [scrIdx scr] 0 mem)
        rw [hs, memAfter, hrun]
        exact hrep
      · show absState s = (handle homestead u (Event.nav scr)).game
        rw [hg]; exact (game_nav homestead u scr).symm
  | back =>
      obtain ⟨mem', hrun, hrep⟩ := back_correct h
      have hs : (handle homestead u Event.back).screen
          = (handle homestead (uiOf s u.screen) Event.back).screen := by
        simp only [handle, uiOf]; split <;> rfl
      refine ⟨s, ?_, ?_⟩
      · show RepUI s (handle homestead u Event.back).screen (memAfter backBody [] 0 mem)
        rw [hs, memAfter, hrun]
        exact hrep
      · show absState s = (handle homestead u Event.back).game
        rw [hg]; exact (game_back homestead u).symm
  | commit a =>
      obtain ⟨mem', t, hrun, hrep, habs⟩ := commit_matches_ui (scr := u.screen) h a
      have hs : (handle homestead u (Event.commit (absAction a))).screen = u.screen := by
        simp only [handle]; split
        · split <;> rfl
        · rfl
      have hgame : (handle homestead u (Event.commit (absAction a))).game
          = (handle homestead (uiOf s u.screen) (Event.commit (absAction a))).game := by
        cases ho : offers u.screen (absAction a) <;>
          cases hst : step homestead u.game (absAction a) <;>
            simp [handle, uiOf, hg, ho, hst]
      refine ⟨t, ?_, ?_⟩
      · show RepUI t (handle homestead u (Event.commit (absAction a))).screen
          (memAfter commitBody (argsOf a) 0 mem)
        rw [hs, memAfter, hrun]
        exact hrep
      · show absState t = (handle homestead u (Event.commit (absAction a))).game
        rw [hgame]; exact habs

/-- **A session of clicking on the module is a session on the interface.**
Whatever the player clicks — navigation, the back button, or a move, accepted
or refused — the memory the module is left in holds the position and the screen
that `UI.handleAll` reaches. -/
theorem session_correct : ∀ (cs : List Click) (s : RState) (u : UIState) (mem : Int → Int),
    RepUI s u.screen mem → absState s = u.game →
    ∃ t : RState,
      RepUI t (handleAll homestead u (cs.map Click.toEvent)).screen (clickAll mem cs) ∧
        absState t = (handleAll homestead u (cs.map Click.toEvent)).game := by
  intro cs
  induction cs with
  | nil => intro s u mem h hg; exact ⟨s, h, hg⟩
  | cons c cs ih =>
      intro s u mem h hg
      obtain ⟨t, hrep, habs⟩ := click_step h hg c
      simpa using ih t (handle homestead u c.toEvent) (clickStep mem c) hrep habs

/-- **The head-up display after the verified season.**  Playing the four moves
of `Tycoon.lean` through the module and asking it for the net worth gives
28 060 — the figure `Tycoon.run_firstSeason` proves over ℚ and `UI.lean` puts
on the display — in the module's units of `10⁻¹²`. -/
theorem firstSeason_netWorth :
    callFun netWorthBody [] 0 (applyAll startMem rFirstSeason) = 28060 * 10 ^ 12 := by
  obtain ⟨t, hrun, -, -, -, -, -⟩ := runtime_firstSeason
  have hrep := applyAll_correct rFirstSeason rstart startMem rep_startMem t hrun
  rw [netWorth_correct hrep]
  obtain ⟨g, hg, -, -, -, -, -, -, hnw⟩ := run_firstSeason
  have habs : absState t = g := by
    have hre := rrun_refines rstart rFirstSeason
    rw [hrun, absState_rstart, absAction_rFirstSeason, hg] at hre
    simpa using hre
  have hq : ((rNetWorth t : ℚ)) = 28060 * 10 ^ 12 := by
    have h1 : toQ12 (rNetWorth t) = 28060 := by rw [netWorth_toQ, habs, hnw]
    rw [toQ12, div_eq_iff (by norm_num : ((10 : ℚ) ^ 12) ≠ 0)] at h1
    exact h1
  exact_mod_cast hq

end Wasm
end LifeTrac
