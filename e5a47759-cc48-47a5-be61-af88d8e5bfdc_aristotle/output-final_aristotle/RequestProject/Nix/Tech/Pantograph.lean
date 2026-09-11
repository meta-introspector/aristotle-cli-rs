/-
# Entry: **THE PANTOGRAPH** — a brass card shop that punches its own deck

*Backend theme.*  A workbench in a brass-and-oil card shop.  On the left, the
**spindle**: a spike with the shop's deck of brass shims on it, each shim a row
of pins filed to different heights.  On the right, the **loom**: a pin-barrel
reader with two card cradles and a punch.  Crank it, and it reads the card in
the first cradle one pin at a time — each pin height is one instruction to the
punch — and it punches fresh shims out of blank stock, using the card in the
second cradle as its pattern.  The whole shop is two machines and a box of
blank shims.  The claim proved here is that there is a deck you can put on that
spindle such that one crank of the loom punches that same deck back out, pin
for pin.

Three entries are given, all in the same shop:

* `ouroboros = [[0]]` — one card, one pin.  The minimum (see
  `selfCopying_has_pin`: no non-empty deck with zero pins can do it).
* `pantograph = [[4,4,0],[4,0]]` — the classical quine shape, in which the
  program card and the data card are *different* cards, and the data card is
  exactly the program card with its own first pin filed off.  The `LEAD` pin
  puts that pin back.
* `twoStroke = [[0],[1]]` — two cranks of the loom, each punching one card.

The correctness gate, in one line each:
* `SelfCopying` holds: `selfCopying_ouroboros`, `selfCopying_pantograph`,
  `selfCopying_twoStroke`.
* No tier skipping: `tierMonotone_ouroboros`, `tierMonotone_pantograph`,
  `tierMonotone_twoStroke` (spindle at tier 0, loom at tier 1).
* Bootstrap exceptions, declared and nothing else: `Bootstrap.BootstrapExceptions
  = [Res.shim]` — blank brass stock, and that is all.  Both patterns the loom
  reads must be produced by a tier-0 machine of the tree, which is proved in
  `emit_provenance`.
-/
import RequestProject.Nix.Tech.SelfCopy

namespace Bootstrap
namespace Pantograph

/-! ## The decks -/

/-- **The Ouroboros shim.**  One card carrying one pin, at height `0`: `STAMP`,
"punch a copy of the card in the data cradle".  Mounted alone, it is the card
in the data cradle, so it punches itself. -/
def ouroboros : CardSet := [[0]]

/-- **The Pantograph deck.**  Two cards.  The program card `[4,4,0]` reads as
`LEAD 4; STAMP`: punch a pin at height 4 and then the data card behind it, then
punch the data card by itself.  The data card `[4,0]` is the program card minus
its leading pin — so the first instruction rebuilds the program card and the
second reproduces the data card. -/
def pantograph : CardSet := [[4,4,0],[4,0]]

/-- **The two-stroke deck.**  `[[0],[1]]`: `STAMP` and `FOLD`.  Crank the loom
twice — program `[0]` against data `[0]`, then program `[0]` against data `[1]`
— and the two single-card outputs concatenate to the deck. -/
def twoStroke : CardSet := [[0],[1]]

/-- The pins on a whole deck: the natural size measure of a deck. -/
def pinCount (cs : CardSet) : Nat := (cs.flatMap id).length

/-! ## The fixed point

Each is checked twice over: once by `decide` on the equation the loom
satisfies, and once by the `#eval`s below, which print the punched deck. -/

theorem exec_ouroboros : exec [0] [0] = ouroboros := by decide

theorem exec_pantograph : exec [4,4,0] [4,0] = pantograph := by decide

theorem exec_twoStroke :
    [([0], [0]), ([0], [1])].flatMap (fun x => exec x.1 x.2) = twoStroke := by decide

/-- **The minimal entry is self-copying.** -/
theorem selfCopying_ouroboros : SelfCopying ouroboros :=
  selfCopying_of_exec (by simp [ouroboros]) (by simp [ouroboros]) exec_ouroboros

/-- **The Pantograph deck is self-copying**: the loom, fed its own program and
data cards, punches the deck it was fed. -/
theorem selfCopying_pantograph : SelfCopying pantograph :=
  selfCopying_of_exec (by simp [pantograph]) (by simp [pantograph]) exec_pantograph

/-- **The two-stroke deck is self-copying**, using two firings of the loom. -/
theorem selfCopying_twoStroke : SelfCopying twoStroke := by
  refine selfCopying_of_execs (ps := [([0], [0]), ([0], [1])]) ?_ exec_twoStroke
  intro x hx
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl <;> exact ⟨by simp [twoStroke], by simp [twoStroke]⟩

/-! ## The runs, and their tier discipline -/

/-- The bootstrap sequence witnessing `selfCopying_ouroboros`. -/
def ouroborosRun : BootstrapSeq := copyRun ouroboros [([0], [0])]

/-- The bootstrap sequence witnessing `selfCopying_pantograph`. -/
def pantographRun : BootstrapSeq := copyRun pantograph [([4,4,0], [4,0])]

/-- The bootstrap sequence witnessing `selfCopying_twoStroke`. -/
def twoStrokeRun : BootstrapSeq := copyRun twoStroke [([0], [0]), ([0], [1])]

theorem emit_ouroborosRun : emit ouroborosRun = ouroboros := by
  rw [ouroborosRun, emit_copyRun]; decide

theorem emit_pantographRun : emit pantographRun = pantograph := by
  rw [pantographRun, emit_copyRun]; decide

theorem emit_twoStrokeRun : emit twoStrokeRun = twoStroke := by
  rw [twoStrokeRun, emit_copyRun]; decide

theorem valid_ouroborosRun : ValidSequence ouroborosRun (interpret ouroboros) := by
  refine valid_copyRun _ _ ?_
  intro x hx
  simp only [List.mem_singleton] at hx
  subst hx
  exact ⟨by simp [ouroboros], by simp [ouroboros]⟩

theorem valid_pantographRun : ValidSequence pantographRun (interpret pantograph) := by
  refine valid_copyRun _ _ ?_
  intro x hx
  simp only [List.mem_singleton] at hx
  subst hx
  exact ⟨by simp [pantograph], by simp [pantograph]⟩

theorem valid_twoStrokeRun : ValidSequence twoStrokeRun (interpret twoStroke) := by
  refine valid_copyRun _ _ ?_
  intro x hx
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl <;> exact ⟨by simp [twoStroke], by simp [twoStroke]⟩

theorem tierMonotone_ouroboros : TierMonotone 0 ouroborosRun := tierMonotone_copyRun _ _

theorem tierMonotone_pantograph : TierMonotone 0 pantographRun := tierMonotone_copyRun _ _

theorem tierMonotone_twoStroke : TierMonotone 0 twoStrokeRun := tierMonotone_copyRun _ _

/-! ## The fixed point has content

Not every deck copies itself — that is what makes the claim worth proving.  The
provenance lemma rules out whole families of decks, because the only things
that can enter the shop are blank shims and the deck's own cards. -/

/-- A deck that does *not* copy itself, and cannot by any run whatsoever: the
one card `[2,7]` reads as `SHIM 7`, so the shop can only ever punch cards
carrying the single pin `7`. -/
theorem not_selfCopying_shim : ¬ SelfCopying [[2,7]] := by
  intro h
  have hc : ([2,7] : Card) ∈ ([[2,7]] : CardSet) := by simp
  obtain ⟨p, hp, d, hd, hmem⟩ := selfCopying_provenance h _ hc
  simp only [List.mem_singleton] at hp hd
  subst hp; subst hd
  revert hmem
  decide

/-- A deck of blank cards punches nothing, so it never copies itself. -/
theorem not_selfCopying_blank : ¬ SelfCopying [[]] := by
  intro h
  obtain ⟨c, hc, hne⟩ := selfCopying_has_pin h (by simp)
  simp only [List.mem_singleton] at hc
  exact hne hc

/-! ## Minimality

One pin is the floor, and the Ouroboros shim stands on it. -/

theorem pinCount_ouroboros : pinCount ouroboros = 1 := rfl

theorem pinCount_pantograph : pinCount pantograph = 5 := rfl

/-- **The floor.**  Every non-empty self-copying deck carries at least one pin,
so no non-empty deck is smaller than the Ouroboros shim. -/
theorem one_le_pinCount {cs : CardSet} (h : SelfCopying cs) (hne : cs ≠ []) :
    1 ≤ pinCount cs := by
  obtain ⟨c, hc, hcne⟩ := selfCopying_has_pin h hne
  obtain ⟨x, hx⟩ : ∃ x, x ∈ c := by
    cases c with
    | nil => exact absurd rfl hcne
    | cons a t => exact ⟨a, List.mem_cons_self ..⟩
  have hmem : x ∈ cs.flatMap id := List.mem_flatMap.mpr ⟨c, hc, hx⟩
  have : 0 < (cs.flatMap id).length := List.length_pos_iff.mpr (List.ne_nil_of_mem hmem)
  simpa [pinCount] using this

/-! ## The physical form

A card is a brass shim; `o` is the punched hole, at the height of that pin;
`·` is unpunched metal.  Read left to right, one column per pin. -/

/-- Render one brass shim. -/
def renderCard (c : Card) : String :=
  let h := c.foldl Nat.max 0
  let width := 2 * c.length + 1
  let bar := String.ofList (List.replicate width '═')
  let rows := ((List.range (h + 1)).reverse).map (fun r =>
    "  ║ " ++ String.intercalate " " (c.map (fun n => if n = r then "o" else "·")) ++ " ║  " ++
      toString r)
  String.intercalate "\n" (("  ╔" ++ bar ++ "╗") :: rows ++ ["  ╚" ++ bar ++ "╝"])

/-- Render a whole deck, card by card. -/
def renderDeck (cs : CardSet) : String :=
  String.intercalate "\n\n"
    (cs.zipIdx.map (fun x => "  card " ++ toString (x.2 + 1) ++ ":  " ++ toString x.1 ++ "\n" ++
      renderCard x.1))

/-- A one-line description of the shop a deck describes. -/
def shopReport (cs : CardSet) : String :=
  let t := interpret cs
  "  tech tree: " ++ toString t.nodes.length ++ " nodes — " ++
    String.intercalate ", " (t.nodes.map (fun n => n.name ++ " (tier " ++ toString n.tier ++ ")")) ++
    "\n  bootstrap exceptions: blank shims only" ++
    "\n  cards: " ++ toString cs.length ++
    ", pins: " ++ toString (cs.flatMap id).length

/-! ## Independent verification by evaluation

These `#eval`s recompute the fixed point from the definitions, with no appeal
to the proofs above. -/

-- the shop, the deck, and the punched deck, for each entry
#eval IO.println (shopReport ouroboros)
#eval IO.println (renderDeck ouroboros)
#eval exec [0] [0]                          -- [[0]]
#eval emit ouroborosRun                     -- [[0]]
#eval emit ouroborosRun == ouroboros        -- true

#eval IO.println (shopReport pantograph)
#eval IO.println (renderDeck pantograph)
#eval exec [4,4,0] [4,0]                    -- [[4, 4, 0], [4, 0]]
#eval emit pantographRun                    -- [[4, 4, 0], [4, 0]]
#eval emit pantographRun == pantograph      -- true

#eval emit twoStrokeRun == twoStroke        -- true

-- the decidable criterion agrees, and rejects the non-example
#eval selfCopyCheck ouroboros               -- true
#eval selfCopyCheck pantograph              -- true
#eval selfCopyCheck [[2,7]]                 -- false
#eval selfCopyCheck [[4,4,0]]               -- false

/-! ## A brute-force look at the neighbourhood

An exhaustive `#eval` sweep of every deck of at most two cards, each card at
most three pins long with pin heights below five: which of them pass the
single-firing criterion.  This is evaluation, not proof — the proved statements
are the ones above — but it is what convinced us `[[0]]` is as small as it
gets, and that the shop is not so permissive that everything copies itself. -/

/-- All cards of exactly `len` pins, with heights `< pins`. -/
def cardsOfLen : Nat → Nat → List Card
  | 0, _ => [[]]
  | n + 1, pins => (List.range pins).flatMap (fun k => (cardsOfLen n pins).map (fun c => k :: c))

/-- All cards of at most `len` pins, with heights `< pins`. -/
def cardsUpTo (len pins : Nat) : List Card :=
  (List.range (len + 1)).flatMap (fun l => cardsOfLen l pins)

/-- All decks of one or two such cards. -/
def decksUpTo (len pins : Nat) : List CardSet :=
  let cs := cardsUpTo len pins
  cs.map (fun c => [c]) ++ cs.flatMap (fun a => cs.map (fun b => [a, b]))

#eval ((decksUpTo 3 5).filter selfCopyCheck).length
#eval (((decksUpTo 3 5).filter selfCopyCheck).map pinCount).foldl Nat.min 99
#eval ((decksUpTo 3 5).filter (fun cs => selfCopyCheck cs && pinCount cs ≤ 2))
#eval ((decksUpTo 3 5).filter (fun cs => selfCopyCheck cs && pinCount cs == 5 && cs.length == 2))

end Pantograph
end Bootstrap
