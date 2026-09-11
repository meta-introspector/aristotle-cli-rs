import RequestProject.Craft.TouchKeys

/-!
# Touch input, part 5: the whole control layer

This file puts the previous four together into the thing the page actually
runs: a `System` holding the screen, the pad, the hotkey table, the swipe
table, the compiled macros, the gesture and joystick settings, and where the
virtual pointer is.  `handle` takes one raw input — a finger's trace, a new
joystick offset, or a chord — and returns the new system together with the
list of outputs the page performs.

The theorems say the control layer behaves:

* `handle_layout`, `handle_tables` — input never edits the pad or the tables;
  only the builder does that.
* `handle_pointer_mem` — the virtual pointer is always on the screen.
* `handle_wf` — the whole well-formedness invariant survives any input.
* `handle_key`, `handle_macro`, `handle_swipe` — a tap on a key sends that key,
  a tap on a macro button plays exactly that compiled macro, and a gesture on
  bare screen does exactly what the swipe table says.
* `handle_stick_opposite` — the joystick never asks for two opposite
  directions at once.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Touch

/-- What the page does in response to input. -/
inductive Out
  | key (c : Chord)
  | tapId (widget : String)
  | wait (ms : Nat)
  | mouse (e : MouseEvent) (pos : Pt)
  | nav (tab : String)
  | hold (keys : List PadKey)
deriving DecidableEq, Repr, Inhabited

/-- A compiled macro event, as an output. -/
def eventOut : Event → Out
  | .press c => .key c
  | .tapId w => .tapId w
  | .wait n => .wait n

/-- One raw input from the phone. -/
inductive Input
  /-- a finger went down and came up again -/
  | touch (t : Trace)
  /-- the joystick knob is at this offset from its centre -/
  | stickAt (v : Pt)
  /-- a chord, from the on-screen keyboard or a real one -/
  | chord (c : Chord)
deriving DecidableEq, Repr, Inhabited

/-- The whole control layer. -/
structure System where
  screen : Rect
  layout : Layout
  keys : Keymap
  swipes : SwipeMap
  table : MacroTable
  gcfg : GestureCfg
  scfg : StickCfg
  pointer : Pt
deriving DecidableEq, Repr, Inhabited

/-- A control layer is well formed when the pad is a valid mobile pad, neither
trigger table has a conflict, and the pointer is on a screen with room in it. -/
structure System.WF (s : System) : Prop where
  layout : s.layout.valid s.screen = true
  keys : conflictFree s.keys = true
  swipes : conflictFree s.swipes = true
  pointer : s.screen.contains s.pointer = true
  wide : 0 < s.screen.w
  tall : 0 < s.screen.h

/-- What an action makes the page do. -/
def System.actionOut (s : System) : Action → List Out
  | .send code => [.key (Chord.plain code)]
  | .mouse e => [.mouse e s.pointer]
  | .run n => ((s.table.lookup n).getD []).map eventOut
  | .nav t => [.nav t]

/-- Handle one raw input. -/
def handle (s : System) : Input → System × List Out
  | .chord c =>
      (s, match resolveT s.keys c with
          | some a => s.actionOut a
          | none => [])
  | .stickAt v => (s, [.hold (dir8 s.scfg v).keys])
  | .touch t =>
      match s.layout.hitTest t.start with
      | some w =>
          match w.kind with
          | .key code => (s, [.key (Chord.plain code)])
          | .macroBtn n => (s, ((s.table.lookup n).getD []).map eventOut)
          | .stick => (s, [.hold (dir8 s.scfg ⟨t.dx, t.dy⟩).keys])
          | .trackpad =>
              let p := clampPt s.screen ⟨s.pointer.x + t.dx, s.pointer.y + t.dy⟩
              ({ s with pointer := p }, [.mouse (mouseOfGesture (recognize s.gcfg t)) p])
      | none =>
          (s, match resolveT s.swipes (recognize s.gcfg t) with
              | some a => s.actionOut a
              | none => [])

/-! ## Input never edits the pad -/

/-- **Handling input leaves the pad exactly as it was** — only the builder
changes it. -/
theorem handle_layout (s : System) (i : Input) : (handle s i).1.layout = s.layout := by
  cases i <;> (simp only [handle]; repeat' (first | rfl | trivial | split))

/-- Handling input leaves the hotkey and swipe tables, the macros and the
settings alone. -/
theorem handle_tables (s : System) (i : Input) :
    (handle s i).1.keys = s.keys ∧ (handle s i).1.swipes = s.swipes ∧
    (handle s i).1.table = s.table ∧ (handle s i).1.screen = s.screen ∧
    (handle s i).1.gcfg = s.gcfg ∧ (handle s i).1.scfg = s.scfg := by
  cases i <;> simp only [handle] <;>
    repeat' (first | exact ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩ | trivial | split)

/-- **The virtual pointer never leaves the screen.** -/
theorem handle_pointer_mem {s : System} (hs : s.WF) (i : Input) :
    (handle s i).1.screen.contains (handle s i).1.pointer = true := by
  cases i <;> simp only [handle] <;>
    repeat' (first | exact hs.pointer | exact clampPt_mem s.screen _ hs.wide hs.tall | split)

/-- **The control layer stays well formed** whatever the player does with it. -/
theorem handle_wf {s : System} (hs : s.WF) (i : Input) : (handle s i).1.WF := by
  obtain ⟨hl, hk, hsw, hp, hw, ht⟩ := hs
  have hlay := handle_layout s i
  obtain ⟨h1, h2, -, h4, -, -⟩ := handle_tables s i
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · rw [hlay, h4]; exact hl
  · rw [h1]; exact hk
  · rw [h2]; exact hsw
  · exact handle_pointer_mem ⟨hl, hk, hsw, hp, hw, ht⟩ i
  · rw [h4]; exact hw
  · rw [h4]; exact ht

/-! ## What each input does -/

/-- **A touch on a key sends that key.** -/
theorem handle_key {s : System} {t : Trace} {w : Widget} {code : String}
    (hw : s.layout.hitTest t.start = some w) (hk : w.kind = .key code) :
    (handle s (.touch t)).2 = [.key (Chord.plain code)] := by
  simp only [handle, hw, hk]

/-- **A touch on a macro button plays exactly that compiled macro.** -/
theorem handle_macro {s : System} {t : Trace} {w : Widget} {n : String}
    (hw : s.layout.hitTest t.start = some w) (hk : w.kind = .macroBtn n) :
    (handle s (.touch t)).2 = ((s.table.lookup n).getD []).map eventOut := by
  simp only [handle, hw, hk]

/-- **A gesture on bare screen does what the swipe table says.** -/
theorem handle_swipe {s : System} {t : Trace} {a : Action}
    (hw : s.layout.hitTest t.start = none)
    (ha : (recognize s.gcfg t, a) ∈ s.swipes) (hc : conflictFree s.swipes = true) :
    (handle s (.touch t)).2 = s.actionOut a := by
  simp only [handle, hw, resolveT_complete hc ha]

/-- A gesture on bare screen with nothing bound does nothing. -/
theorem handle_swipe_unbound {s : System} {t : Trace}
    (hw : s.layout.hitTest t.start = none)
    (hg : recognize s.gcfg t ∉ triggers s.swipes) :
    (handle s (.touch t)).2 = [] := by
  simp only [handle, hw, (resolveT_eq_none_iff s.swipes (recognize s.gcfg t)).mpr hg]

/-- A hotkey bound to a macro plays that macro. -/
theorem handle_chord_run {s : System} {c : Chord} {n : String}
    (hc : conflictFree s.keys = true) (h : (c, Action.run n) ∈ s.keys) :
    (handle s (.chord c)).2 = ((s.table.lookup n).getD []).map eventOut := by
  simp only [handle, resolveT_complete hc h, System.actionOut]

/-- **The joystick never asks for two opposite directions at once.** -/
theorem handle_stick_opposite (s : System) (v : Pt) :
    ∀ ks, (handle s (.stickAt v)).2 = [.hold ks] →
      ∀ k ∈ ks, k ∉ (dir8 s.scfg v).opposite.keys := by
  intro ks h k hk
  have : ks = (dir8 s.scfg v).keys := by
    simp only [handle, List.cons.injEq] at h
    exact (Out.hold.inj h.1).symm
  subst this
  exact Dir8.keys_opposite_disjoint _ k hk

/-- The joystick at rest holds nothing down. -/
theorem handle_stick_dead (s : System) (v : Pt) (h : magSq v ≤ s.scfg.dead * s.scfg.dead) :
    (handle s (.stickAt v)).2 = [.hold []] := by
  simp only [handle, dir8_dead s.scfg v h, Dir8.keys]

/-! ## The system the page ships with -/

/-- The gesture thresholds the page ships with: 10 px of slop, a 40 px swipe,
half a second for a long press. -/
def defaultGesture : GestureCfg := ⟨10, 40, 500⟩

/-- The joystick the page ships with: a 75 px pad with a 12 px dead zone. -/
def defaultStick : StickCfg := ⟨75, 12⟩

/-- The whole control layer as shipped. -/
def defaultSystem : System :=
  { screen := phoneScreen
    layout := defaultPad
    keys := defaultKeymap
    swipes := defaultSwipes
    table := defaultTable
    gcfg := defaultGesture
    scfg := defaultStick
    pointer := ⟨195, 300⟩ }

/-- The shipped gesture settings are sane. -/
theorem defaultGesture_wf : defaultGesture.WF := by decide

/-- The shipped joystick settings are sane. -/
theorem defaultStick_wf : defaultStick.WF := by decide

/-- **The control layer the page ships with is well formed.** -/
theorem defaultSystem_wf : defaultSystem.WF where
  layout := defaultPad_valid
  keys := defaultKeymap_conflictFree
  swipes := defaultSwipes_conflictFree
  pointer := by decide
  wide := by decide
  tall := by decide

end Touch
