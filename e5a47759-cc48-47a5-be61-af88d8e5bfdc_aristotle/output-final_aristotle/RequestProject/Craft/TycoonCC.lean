import RequestProject.Craft.DBPolicy
import RequestProject.Craft.Game

/-!
# The tycoon on a ComputerCraft computer

The tycoon of `RequestProject.Tycoon` is a pure game.  This file puts it on a
CC:Tweaked machine, reusing the verified components already in this
development, and proves that each of those components really does gate the game:

* a **build permit** is a `hopper.lua` glob pattern over part-kind names
  (`HopperGlob.globStr`): a part may only be built if the permit admits its
  kind;
* the seller's **payout line** is a bundled-cable colour (`CCColors.test`):
  ingots may only be sold while that colour is on;
* the **SVG film** of a game is written into the computer's virtual file system,
  and the write is refused unless the ComputerCraft path layer says the
  destination is inside the shop's root (`CCFileSystem.containsL`).

Proved: the gated game is still a game (the factory invariant and the economy
bound survive), a part of an unpermitted kind can never appear in the factory,
no cash can be earned while the payout line is off, and a film can never be
written outside the shop's root.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Tycoon

/-- The name a part kind goes by on the computer, and in the permit. -/
def kindName : Kind → String
  | .miner => "tycoon:miner"
  | .smelter => "tycoon:smelter"
  | .seller => "tycoon:seller"
  | .belt => "tycoon:belt"
  | .pillar => "tycoon:pillar"

/-- The machine the tycoon runs on: a build permit, the bundled cable, the
colour the seller's payout line sits on, and the directory films are saved
in. -/
structure Shop where
  /-- A `hopper.lua` glob (alternatives separated by `|`) over part-kind names. -/
  permit : String
  /-- The bundled cable's current colour set. -/
  gates : CCColors.ColorSet
  /-- The colour the seller's payout line uses. -/
  payout : CCColors.ColorSet
  /-- The sandbox root that films are saved under. -/
  root : List Char

namespace Shop

/-- Does the permit admit this kind of part? -/
def permits (sh : Shop) (k : Kind) : Bool := (HopperGlob.globStr sh.permit (kindName k)).isSome

/-- Is the seller's payout line live? -/
def payoutOn (sh : Shop) : Bool := CCColors.test sh.gates sh.payout

/-- A move is legal on the machine when the game allows it *and* the machine
does: builds need the permit, sales need the payout line. -/
def legalCC (sh : Shop) (g : GameState) : Action → Bool
  | .place k p => g.legal (.place k p) && sh.permits k
  | .sell n => g.legal (.sell n) && sh.payoutOn
  | a => g.legal a

/-- One move on the machine. -/
def stepCC (sh : Shop) (g : GameState) (a : Action) : GameState :=
  if sh.legalCC g a then g.perform a else g

/-- A play on the machine. -/
def runCC (sh : Shop) (g : GameState) (as : List Action) : GameState :=
  as.foldl (stepCC sh) g

@[simp] theorem runCC_nil (sh : Shop) (g : GameState) : sh.runCC g [] = g := rfl

@[simp] theorem runCC_cons (sh : Shop) (g : GameState) (a : Action) (as : List Action) :
    sh.runCC g (a :: as) = sh.runCC (sh.stepCC g a) as := rfl

theorem legalCC_imp_legal {sh : Shop} {g : GameState} {a : Action}
    (h : sh.legalCC g a = true) : g.legal a = true := by
  cases a <;> simp_all [legalCC]

/-- A machine move is either the game's move or nothing at all. -/
theorem stepCC_eq (sh : Shop) (g : GameState) (a : Action) :
    sh.stepCC g a = g.step a ∨ sh.stepCC g a = g := by
  unfold stepCC
  split
  · exact Or.inl (by rw [GameState.step, if_pos (legalCC_imp_legal (by assumption))])
  · exact Or.inr rfl

/-- The factory invariant survives a machine move … -/
theorem stepCC_wf {sh : Shop} {g : GameState} (hg : g.WF) (a : Action) :
    (sh.stepCC g a).WF := by
  rcases stepCC_eq sh g a with h | h
  · rw [h]; exact GameState.step_wf hg a
  · rw [h]; exact hg

/-- … and a whole play on the machine. -/
theorem runCC_wf {sh : Shop} {g : GameState} (hg : g.WF) (as : List Action) :
    (sh.runCC g as).WF := by
  induction as generalizing g with
  | nil => exact hg
  | cons a t ih => exact ih (stepCC_wf hg a)

/-- The economy bound survives too: the machine cannot mint money either. -/
theorem runCC_worth_le {sh : Shop} {g : GameState} (hg : g.WF) (as : List Action) :
    GameState.worth (sh.runCC g as)
      ≤ GameState.worth g + ingotPrice * Scene.maxParts * as.length := by
  induction as generalizing g with
  | nil => simp
  | cons a t ih =>
      have hstep : GameState.worth (sh.stepCC g a)
          ≤ GameState.worth g + ingotPrice * Scene.maxParts := by
        rcases stepCC_eq sh g a with h | h
        · rw [h]; exact GameState.step_worth_le hg a
        · rw [h]; omega
      have h2 := ih (stepCC_wf (sh := sh) hg a)
      have h3 : ingotPrice * Scene.maxParts * (t.length + 1)
          = ingotPrice * Scene.maxParts * t.length + ingotPrice * Scene.maxParts := by ring
      simp only [runCC_cons, List.length_cons]
      omega

/-! ## The permit really gates building -/

/-- A part the permit does not admit is simply not built. -/
theorem stepCC_place_refused {sh : Shop} (g : GameState) {k : Kind} (p : V3)
    (h : sh.permits k = false) : sh.stepCC g (.place k p) = g := by
  simp [stepCC, legalCC, h]

/-- **Nothing unpermitted is ever built.** If every part of the factory is
permitted to begin with, then every part of the factory is permitted after any
play on the machine. -/
theorem runCC_parts_permitted {sh : Shop} {g : GameState}
    (hg : ∀ p ∈ g.scene, sh.permits p.kind = true) (as : List Action) :
    ∀ p ∈ (sh.runCC g as).scene, sh.permits p.kind = true := by
  induction as generalizing g with
  | nil => exact hg
  | cons a t ih =>
      refine ih (g := sh.stepCC g a) ?_
      intro q hq
      unfold stepCC at hq
      split at hq
      case isFalse => exact hg q hq
      case isTrue hleg =>
        cases a with
        | place k p =>
            simp only [legalCC, Bool.and_eq_true] at hleg
            simp only [GameState.perform, Scene.place, List.mem_cons] at hq
            rcases hq with rfl | hq
            · exact hleg.2
            · exact hg q hq
        | remove i =>
            have : q ∈ g.scene :=
              (List.eraseIdx_sublist g.scene i).mem (by simpa [GameState.perform, Scene.remove] using hq)
            exact hg q this
        | tickWorld => exact hg q hq
        | sell n => exact hg q hq

/-! ## The payout line really gates selling -/

/-- With the payout line off, a sale is refused. -/
theorem stepCC_sell_refused {sh : Shop} (g : GameState) (n : Nat)
    (h : sh.payoutOn = false) : sh.stepCC g (.sell n) = g := by
  simp [stepCC, legalCC, h]

/-- **No cash while the payout line is off.** Whatever the player does, cash can
only fall. -/
theorem runCC_cash_le_of_payout_off {sh : Shop} (h : sh.payoutOn = false)
    (g : GameState) (as : List Action) : (sh.runCC g as).cash ≤ g.cash := by
  induction as generalizing g with
  | nil => exact le_refl _
  | cons a t ih =>
      refine le_trans (ih (g := sh.stepCC g a)) ?_
      cases a with
      | place k p =>
          unfold stepCC
          split
          · simp [GameState.perform]
          · exact le_refl _
      | remove i =>
          unfold stepCC
          split <;> simp [GameState.perform]
      | tickWorld =>
          unfold stepCC
          split <;> simp [GameState.perform]
      | sell n => rw [stepCC_sell_refused g n h]

/-! ## Saving the film cannot escape the shop -/

/-- Where the film of a game would be written. -/
def filmPath (sh : Shop) (name : String) : List Char :=
  CCFileSystem.combineL sh.root (name.toList ++ ".svg".toList)

/-- A write is only performed when the ComputerCraft path layer says the
destination is inside the shop's root. -/
def saveOk (sh : Shop) (name : String) : Bool :=
  CCFileSystem.containsL sh.root (sh.filmPath name)

/-- **A film can never be written outside the shop.** An accepted destination
has no `".."` component once sanitised, so it cannot climb out of the root. -/
theorem save_no_escape (sh : Shop) (name : String) (h : sh.saveOk name = true) :
    CCFileSystem.dd ∉ CCFileSystem.pathParts
      (CCFileSystem.sanitizeL false (sh.filmPath name)) :=
  Factory.no_dotdot_of_containsL sh.root (sh.filmPath name) h

end Shop

/-! ## A worked shop -/

/-- A shop that permits every tycoon part, with the payout line on white. -/
def demoShop : Shop :=
  { permit := "tycoon:*", gates := CCColors.white, payout := CCColors.white,
    root := "disk/tycoon".toList }

/-- A shop whose permit only covers mining gear, with the payout line off. -/
def restrictedShop : Shop :=
  { permit := "tycoon:miner|tycoon:belt", gates := CCColors.orange,
    payout := CCColors.white, root := "disk/tycoon".toList }

example : demoShop.permits .seller = true := by native_decide
example : restrictedShop.permits .seller = false := by native_decide
example : restrictedShop.permits .miner = true := by native_decide
example : demoShop.payoutOn = true := by native_decide
example : restrictedShop.payoutOn = false := by native_decide

/-- The restricted shop refuses to build a seller. -/
example : restrictedShop.stepCC GameState.demoStart (.place .seller ⟨10, 0, 10⟩)
    = GameState.demoStart := by native_decide

/-- The permissive shop builds it. -/
example : (demoShop.stepCC GameState.demoStart (.place .seller ⟨10, 0, 10⟩)).scene.length = 4 := by
  native_decide

/-- Films go into the shop's directory … -/
example : String.ofList (demoShop.filmPath "builder") = "disk/tycoon/builder.svg" := by native_decide

/-- … and a name that tries to climb out is refused. -/
example : demoShop.saveOk "../../secret" = false := by native_decide

/-- A legitimate name is accepted. -/
example : demoShop.saveOk "builder" = true := by native_decide

end Tycoon
