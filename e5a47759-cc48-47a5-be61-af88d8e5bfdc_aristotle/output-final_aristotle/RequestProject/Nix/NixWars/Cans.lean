import RequestProject.Nix.NixWars.Scene3D
import RequestProject.Nix.NixWars.Empire
import RequestProject.Nix.NixWars.Monster.Irreps

/-!
# Cans: everything in the world, surfaced

In the voxel view and in the ship's view the world is made of boxes, and the
question this file settles is whether *everything* in the development can be
put in one of those boxes and reached by flying to it. The answer is yes, and
the reason is that the most abstract thing there is here is very small:

> **a can**: a label, a value, and whatever is inside it.

That is `Can`. A can with nothing inside is the bottom of the world — a can of
brainrot, a number in a labelled tin. A can with cans inside it is a room, a
cabinet, a table, a galaxy, a world.

What is proved:

* **Everything is drawn.** The things inside a can stand on the shelves of the
  same `16 × 16 × 16` arena the WebGL pages already draw (`Scene3D.arena`):
  `shelf_in_arena` puts every one of them inside the box, `shelf_covers` says
  none is left off the shelf, and `slots_distinct` that no two of them are
  given the same cube. So *looking* at a can shows you all of it.

* **Everything can be flown into.** `enter c k` is flying into the `k`th thing
  in front of you and `follow` is a whole flight. `reach` proves that every can
  anywhere inside the world is at the end of some flight, and `follow_mem_parts`
  that a flight can only ever arrive at something that was really there.

* **Examining tells you what you can fly into.** `examine` reports a can's
  label, its value, and how many things are inside it, and
  `enter_isSome_iff_lt_doors` says that report is exact: the things you can fly
  into are precisely the ones it counted.

* **The regress stops.** `enter_size_lt` says every flight inwards makes the
  world strictly smaller, and `exists_brainrot` that every flight can be
  continued until it arrives at a can with nothing inside — a value in a
  labelled container, and nothing further to open.

* **The world really is made of these.** `nixwarsWorld` is the actual
  development as cans: the fifteen cabinets of the board with every field of
  their state vectors, the 194 rows of the Monster's table with their fifteen
  exponents each and the divisor of `|M|` each one names, and the opening
  position of *Foundation and Empire* with its twelve systems. The cabinets
  carry exactly the fields their 3D scenes draw (`doorCans_match_scenes`), and
  by `reach` every one of those things is at the end of a flight.
-/

namespace NixWars

namespace Cans

/-! ## The can -/

/-- A can: a label, a value, and whatever is inside it. Everything in this
world that can be looked at is one of these. -/
inductive Can where
  /-- A labelled container holding a number and, possibly, more cans. -/
  | can (label : String) (value : Nat) (inside : List Can)
  deriving Repr, Inhabited

namespace Can

/-- What is written on the can. -/
def label : Can → String | .can l _ _ => l

/-- The number in the can. -/
def value : Can → Nat | .can _ v _ => v

/-- What is inside the can. -/
def inside : Can → List Can | .can _ _ i => i

@[simp] theorem label_can (l : String) (v : Nat) (i : List Can) : (Can.can l v i).label = l := rfl
@[simp] theorem value_can (l : String) (v : Nat) (i : List Can) : (Can.can l v i).value = v := rfl
@[simp] theorem inside_can (l : String) (v : Nat) (i : List Can) : (Can.can l v i).inside = i := rfl

/-- Induction over a can and everything inside it. -/
theorem rec' {motive : Can → Prop}
    (h : ∀ l v inside, (∀ c ∈ inside, motive c) → motive (.can l v inside)) : ∀ c, motive c
  | .can l v inside => h l v inside (fun c hc => have := hc; rec' h c)
  decreasing_by
    have hlt := List.sizeOf_lt_of_mem hc
    simp only [Can.can.sizeOf_spec]
    omega

/-- How many cans there are, counting this one and everything inside it. -/
def size : Can → Nat
  | .can _ _ inside => 1 + (inside.map size).sum

theorem size_pos (c : Can) : 0 < c.size := by
  cases c with
  | can l v i => simp only [size]; omega

theorem size_le_sum : ∀ (l : List Can) (d : Can), d ∈ l → d.size ≤ (l.map size).sum := by
  intro l
  induction l with
  | nil => intro d hd; cases hd
  | cons e rest ih =>
      intro d hd
      rcases List.mem_cons.1 hd with rfl | hd'
      · simp only [List.map_cons, List.sum_cons]; omega
      · have := ih d hd'
        simp only [List.map_cons, List.sum_cons]
        omega

theorem size_lt_of_mem {l : String} {v : Nat} {inside : List Can} {d : Can} (h : d ∈ inside) :
    d.size < (Can.can l v inside).size := by
  have := size_le_sum inside d h
  simp only [size]
  omega

end Can

open Can

/-- A can of brainrot: a value in a labelled container, with nothing inside.
This is the most abstract thing in the world, and the bottom of every flight. -/
def brainrot (label : String) (value : Nat) : Can := .can label value []

/-- Is this the bottom — a labelled value with nothing inside it? -/
def isBrainrot (c : Can) : Bool := c.inside.isEmpty

@[simp] theorem isBrainrot_brainrot (l : String) (v : Nat) : isBrainrot (brainrot l v) = true := rfl

/-- **A can is either a value or a container.** There is no third kind of
thing: either there is nothing inside, or there is something to fly into. -/
theorem brainrot_or_enterable (c : Can) : isBrainrot c = true ∨ ∃ d, d ∈ c.inside := by
  cases c with
  | can l v inside =>
      cases inside with
      | nil => exact Or.inl rfl
      | cons d rest => exact Or.inr ⟨d, by simp⟩

/-! ## Examining -/

/-- What examining a can tells you. -/
structure Look where
  /-- What is written on it. -/
  label : String
  /-- The number in it. -/
  value : Nat
  /-- How many things you can fly into from here. -/
  doors : Nat
  deriving DecidableEq, Repr

/-- Look at a can. -/
def examine (c : Can) : Look := ⟨c.label, c.value, c.inside.length⟩

/-! ## Flying in -/

/-- Fly into the `k`th thing in front of you. -/
def enter (c : Can) (k : Nat) : Option Can := c.inside[k]?

/-- A flight: which thing to fly into, at each step. -/
def follow : Can → List Nat → Option Can
  | c, [] => some c
  | c, k :: p => match enter c k with
                 | none => none
                 | some d => follow d p

/-- Everything anywhere inside a can, the can itself included. -/
def parts : Can → List Can
  | .can l v inside => Can.can l v inside :: inside.flatMap parts

@[simp] theorem follow_nil (c : Can) : follow c [] = some c := rfl

theorem follow_cons (c : Can) (k : Nat) (p : List Nat) :
    follow c (k :: p) = match enter c k with | none => none | some d => follow d p := rfl

/-- **Examining tells you exactly what you can fly into.** -/
theorem enter_isSome_iff_lt_doors (c : Can) (k : Nat) :
    (enter c k).isSome = true ↔ k < (examine c).doors := by
  simp [enter, examine, List.getElem?_eq_some_iff, Option.isSome_iff_exists]

/-- Flying in only ever reaches something that was inside. -/
theorem enter_mem (c : Can) (k : Nat) (d : Can) (h : enter c k = some d) : d ∈ c.inside :=
  List.mem_of_getElem? h

/-- Everything inside can be flown into. -/
theorem exists_enter {c d : Can} (h : d ∈ c.inside) : ∃ k, enter c k = some d := by
  obtain ⟨k, hk⟩ := List.getElem?_of_mem h
  exact ⟨k, hk⟩

/-- **Flying in makes the world strictly smaller**, so no flight can go inwards
for ever. -/
theorem enter_size_lt {c d : Can} {k : Nat} (h : enter c k = some d) : d.size < c.size := by
  cases c with
  | can l v inside => exact size_lt_of_mem (enter_mem _ k d h)

/-! ## Nothing is out of reach -/

theorem mem_parts_self (c : Can) : c ∈ parts c := by
  cases c with
  | can l v inside => simp [parts]

theorem parts_subset_of_mem_inside {c d : Can} (h : d ∈ c.inside) : ∀ e ∈ parts d, e ∈ parts c := by
  cases c with
  | can l v inside =>
      intro e he
      simp only [inside_can] at h
      simp only [parts, List.mem_cons, List.mem_flatMap]
      exact Or.inr ⟨d, h, he⟩

/-- **Everything is reachable.** For every can anywhere inside `c` there is a
flight from `c` that arrives at it. -/
theorem reach : ∀ (c d : Can), d ∈ parts c → ∃ p, follow c p = some d := by
  intro c
  induction c using Can.rec' with
  | _ l v inside ih =>
      intro d hd
      simp only [parts, List.mem_cons, List.mem_flatMap] at hd
      rcases hd with rfl | ⟨e, he, hde⟩
      · exact ⟨[], rfl⟩
      · obtain ⟨p, hp⟩ := ih e he d hde
        obtain ⟨k, hk⟩ := exists_enter (c := Can.can l v inside) (d := e) (by simpa using he)
        refine ⟨k :: p, ?_⟩
        rw [follow_cons, hk]
        exact hp

/-- **A flight cannot invent a destination.** Whatever a flight arrives at was
really inside the can it started from. -/
theorem follow_mem_parts : ∀ (p : List Nat) (c d : Can), follow c p = some d → d ∈ parts c := by
  intro p
  induction p with
  | nil => intro c d h; cases h; exact mem_parts_self c
  | cons k rest ih =>
      intro c d h
      rw [follow_cons] at h
      cases he : enter c k with
      | none => rw [he] at h; exact absurd h (by simp)
      | some e =>
          rw [he] at h
          exact parts_subset_of_mem_inside (enter_mem c k e he) d (ih e d h)

/-- **Every flight bottoms out.** From anywhere, there is a flight that ends at
a can of brainrot: a label, a value, and nothing left to open. -/
theorem exists_brainrot : ∀ c : Can, ∃ p d, follow c p = some d ∧ isBrainrot d = true := by
  intro c
  induction c using Can.rec' with
  | _ l v inside ih =>
      cases hin : inside with
      | nil => exact ⟨[], Can.can l v [], rfl, by simp [isBrainrot]⟩
      | cons e rest =>
          have hmem : e ∈ inside := by rw [hin]; simp
          obtain ⟨p, d, hp, hd⟩ := ih e hmem
          refine ⟨0 :: p, d, ?_, hd⟩
          rw [follow_cons]
          exact hp

/-! ## How deep the world goes -/

/-- The largest of a list of numbers. -/
def maxOf : List Nat → Nat
  | [] => 0
  | x :: xs => max x (maxOf xs)

theorem le_maxOf : ∀ (l : List Nat) (x : Nat), x ∈ l → x ≤ maxOf l := by
  intro l
  induction l with
  | nil => intro x hx; cases hx
  | cons y ys ih =>
      intro x hx
      rcases List.mem_cons.1 hx with rfl | hx'
      · exact Nat.le_max_left _ _
      · exact Nat.le_trans (ih x hx') (Nat.le_max_right _ _)

/-- How many cans deep a can goes: a can of brainrot is one deep. -/
def depth : Can → Nat
  | .can _ _ inside => 1 + maxOf (inside.map depth)

theorem depth_pos (c : Can) : 0 < depth c := by
  cases c with
  | can l v i => simp only [depth]; omega

theorem depth_lt_of_mem {l : String} {v : Nat} {inside : List Can} {d : Can} (h : d ∈ inside) :
    depth d < depth (Can.can l v inside) := by
  have : depth d ≤ maxOf (inside.map depth) :=
    le_maxOf _ _ (List.mem_map_of_mem h)
  simp only [depth]
  omega

theorem depth_lt_of_enter {c d : Can} {k : Nat} (h : enter c k = some d) : depth d < depth c := by
  cases c with
  | can l v inside => exact depth_lt_of_mem (enter_mem _ k d h)

/-- **Every flight is short.** A flight of `n` steps that arrives somewhere
`m` deep needs `n + m` of the world's depth, so no flight from a can can be
longer than that can is deep. -/
theorem follow_length_add_depth_le :
    ∀ (p : List Nat) (c d : Can), follow c p = some d → p.length + depth d ≤ depth c := by
  intro p
  induction p with
  | nil => intro c d h; cases h; simp
  | cons k rest ih =>
      intro c d h
      rw [follow_cons] at h
      cases he : enter c k with
      | none => rw [he] at h; exact absurd h (by simp)
      | some e =>
          rw [he] at h
          have h1 := ih e d h
          have h2 := depth_lt_of_enter he
          simp only [List.length_cons]
          omega

/-! ## Standing on the shelves

The things inside a can are laid out in the same `16 × 16 × 16` arena the
WebGL pages draw: sixteen along, sixteen across, sixteen up. -/

/-- Where the `k`th thing inside stands. -/
def slot (k : Nat) : Scene3D.Voxel := ⟨k % 16, (k / 256) % 16, (k / 16) % 16, k % 16⟩

/-- How many things one arena holds. -/
def shelfRoom : Nat := 4096

theorem slot_in_arena (k : Nat) :
    (slot k).x < Scene3D.arena ∧ (slot k).y < Scene3D.arena ∧ (slot k).z < Scene3D.arena := by
  refine ⟨?_, ?_, ?_⟩ <;> simp [slot, Scene3D.arena] <;> omega

/-- **No two things share a cube.** As long as a can holds no more than an
arena's worth of things, each of them has its own place. -/
theorem slots_distinct {i j : Nat} (hi : i < shelfRoom) (hj : j < shelfRoom) (hij : i ≠ j) :
    slot i ≠ slot j := by
  intro h
  apply hij
  have hx : i % 16 = j % 16 := congrArg Scene3D.Voxel.x h
  have hy : (i / 256) % 16 = (j / 256) % 16 := congrArg Scene3D.Voxel.y h
  have hz : (i / 16) % 16 = (j / 16) % 16 := congrArg Scene3D.Voxel.z h
  simp only [shelfRoom] at hi hj
  omega

/-- The shelf of a can, from the `k`th place on: what stands where. -/
def shelfFrom : Nat → List Can → List (Scene3D.Voxel × Can)
  | _, [] => []
  | k, d :: rest => (slot k, d) :: shelfFrom (k + 1) rest

/-- What the arena of a can shows: every thing inside it, each on its own
cube. -/
def shelf (c : Can) : List (Scene3D.Voxel × Can) := shelfFrom 0 c.inside

theorem shelfFrom_length (k : Nat) (l : List Can) : (shelfFrom k l).length = l.length := by
  induction l generalizing k with
  | nil => rfl
  | cons d rest ih => simp [shelfFrom, ih]

/-- The shelf has one place per thing inside. -/
theorem shelf_length (c : Can) : (shelf c).length = c.inside.length := shelfFrom_length 0 c.inside

theorem shelfFrom_covers (k : Nat) (l : List Can) :
    ∀ d ∈ l, ∃ v, (v, d) ∈ shelfFrom k l := by
  induction l generalizing k with
  | nil => intro d hd; cases hd
  | cons e rest ih =>
      intro d hd
      rcases List.mem_cons.1 hd with rfl | hd'
      · exact ⟨slot k, by simp [shelfFrom]⟩
      · obtain ⟨v, hv⟩ := ih (k + 1) d hd'
        exact ⟨v, by simp [shelfFrom, hv]⟩

/-- **Nothing is left off the shelf.** Every thing inside a can is drawn. -/
theorem shelf_covers (c : Can) : ∀ d ∈ c.inside, ∃ v, (v, d) ∈ shelf c :=
  shelfFrom_covers 0 c.inside

theorem shelfFrom_mem_slot (k : Nat) (l : List Can) :
    ∀ p ∈ shelfFrom k l, ∃ i, p.1 = slot i := by
  induction l generalizing k with
  | nil => intro p hp; cases hp
  | cons e rest ih =>
      intro p hp
      rcases List.mem_cons.1 hp with rfl | hp'
      · exact ⟨k, rfl⟩
      · exact ih (k + 1) p hp'

/-- **Nothing escapes the arena.** Everything on a shelf is drawn inside the
same `16 × 16 × 16` box the rest of the world is drawn in. -/
theorem shelf_in_arena (c : Can) :
    ∀ p ∈ shelf c, p.1.x < Scene3D.arena ∧ p.1.y < Scene3D.arena ∧ p.1.z < Scene3D.arena := by
  intro p hp
  obtain ⟨i, hi⟩ := shelfFrom_mem_slot 0 c.inside p hp
  rw [hi]
  exact slot_in_arena i

theorem shelfFrom_mem_inside (k : Nat) (l : List Can) :
    ∀ p ∈ shelfFrom k l, p.2 ∈ l := by
  induction l generalizing k with
  | nil => intro p hp; cases hp
  | cons e rest ih =>
      intro p hp
      rcases List.mem_cons.1 hp with rfl | hp'
      · simp
      · exact List.mem_cons_of_mem _ (ih (k + 1) p hp')

/-- **You can fly into everything you can see, and see everything you can fly
into.** What stands on the shelves of a can is exactly what flying in from it
can reach. -/
theorem drawn_iff_enterable (c d : Can) :
    (∃ v, (v, d) ∈ shelf c) ↔ ∃ k, enter c k = some d := by
  constructor
  · rintro ⟨v, hv⟩
    exact exists_enter (shelfFrom_mem_inside 0 c.inside (v, d) hv)
  · rintro ⟨k, hk⟩
    exact shelf_covers c d (enter_mem c k d hk)

/-- **Surfaced.** Every can anywhere in the world is at the end of a flight;
when you get there, examining it names it and counts what you can fly into
next, and every one of those is standing on its own cube inside the arena. -/
theorem surfaceable (root : Can) (d : Can) (hd : d ∈ parts root) :
    ∃ p, follow root p = some d ∧
      examine d = ⟨d.label, d.value, d.inside.length⟩ ∧
      (∀ e ∈ d.inside, ∃ v, (v, e) ∈ shelf d) ∧
      (∀ q ∈ shelf d, q.1.x < Scene3D.arena ∧ q.1.y < Scene3D.arena ∧ q.1.z < Scene3D.arena) := by
  obtain ⟨p, hp⟩ := reach root d hd
  exact ⟨p, hp, rfl, shelf_covers d, shelf_in_arena d⟩

/-! ## Surfacing anything

Everything in this development is, in the end, a labelled record of numbers: a
cabinet's state vector, a row of a table, a star system, a galaxy. That is all
it takes to be surfaced. -/

/-- Any labelled record of numbers, surfaced: a can with one tin per field. -/
def ofFields (name : String) (labels : List String) (values : List Nat) : Can :=
  .can name values.length ((labels.zip values).map (fun lv => brainrot lv.1 lv.2))

/-- **Every field of a record is one flight in, under its own name, holding its
own value.** Nothing of a record is lost by putting it in a can. -/
theorem ofFields_field (name : String) (labels : List String) (values : List Nat) (i : Nat)
    (h1 : i < labels.length) (h2 : i < values.length) :
    (follow (ofFields name labels values) [i]).map (fun c => (c.label, c.value)) =
      some (labels[i]!, values[i]!) := by
  have hz : (labels.zip values)[i]? = some (labels[i]!, values[i]!) := by
    rw [List.getElem?_zip_eq_some]
    refine ⟨by simp [List.getElem?_eq_getElem h1, List.getElem!_eq_getElem?_getD], ?_⟩
    simp [List.getElem?_eq_getElem h2, List.getElem!_eq_getElem?_getD]
  simp [follow_cons, enter, ofFields, List.getElem?_map, hz, brainrot]

/-- A record's can holds one thing per field it has. -/
theorem ofFields_length (name : String) (labels : List String) (values : List Nat)
    (h : labels.length = values.length) :
    (ofFields name labels values).inside.length = values.length := by
  simp [ofFields, h]

/-- A kind of thing that can be put in a can. Everything the world is made of
has one of these. -/
class Surfaceable (α : Type) where
  /-- The can this thing goes in. -/
  toCan : α → Can

instance : Surfaceable Nat := ⟨fun n => brainrot "a number" n⟩
instance : Surfaceable (String × Nat) := ⟨fun p => brainrot p.1 p.2⟩
instance : Surfaceable (String × List String × List Nat) :=
  ⟨fun d => ofFields d.1 d.2.1 d.2.2⟩

/-! ## The world, as cans

The development itself, put in tins: the board's fifteen cabinets, the
Monster's table, and a game of *Foundation and Empire*. -/

/-- One cabinet of the board: its name, the names of the fields of its state
vector, and the state it starts in. -/
def doorRoster : List (String × List String × List Nat) :=
  [ ("nixwars", fieldNames, sessionSerialize initialSession),
    ("dash", dashFieldNames, gsSerialize initialDashSession),
    ("market", marketFieldNames, gsSerialize initialMarketSession),
    ("lord", lordFieldNames, gsSerialize initialLordSession),
    ("hunt", huntFieldNames, gsSerialize initialHuntSession),
    ("zx81", tapeFieldNames, gsSerialize initialZx81Session),
    ("frens", lobbyFieldNames, gsSerialize initialLobbySession),
    ("tycoon", tycoonFieldNames, gsSerialize initialTycoonSession),
    ("meme", memeFieldNames, gsSerialize initialMemeSession),
    ("hyper", hyperFieldNames, gsSerialize initialHyperSession),
    ("oracle", oracleFieldNames, gsSerialize initialOracleSession),
    ("vote", voteFieldNames, gsSerialize initialVoteSession),
    ("qbert", qbertFieldNames, gsSerialize initialQbertSession),
    ("frontier", frontierFieldNames, gsSerialize initialFrontierSession),
    ("invaders", invadersFieldNames, gsSerialize initialInvadersSession) ]

/-- The three fields every cabinet's state vector carries in front of the
game's own: who is playing, on which shard, and which game. -/
def sessionFieldNames : List String := ["the caller", "the shard", "the game"]

/-- A cabinet as a can: one tin per field of its state vector, labelled with
the name the game module gives that field. -/
def doorCan (d : String × List String × List Nat) : Can :=
  ofFields d.1 (sessionFieldNames ++ d.2.1) d.2.2

/-- The board: fifteen cabinets. -/
def boardCan : Can := .can "the board: fifteen cabinets" 15 (doorRoster.map doorCan)

/-- A row of the Monster's table as a can: the number it names, and one tin per
prime. -/
def rowCan (r : Monster.IrrepRow) : Can :=
  .can ("row " ++ toString r.idx) r.rowSum
    (brainrot "the divisor of |M| it names" (Monster.rowValue r) ::
      (monsterPrimes.zip r.exps).map
        (fun pe => brainrot ("how many times " ++ toString pe.1 ++ " divides it") pe.2))

instance : Surfaceable Monster.IrrepRow := ⟨rowCan⟩

/-- The Monster's table: 194 rows. -/
def tableCan : Can :=
  .can "the Monster's table: 194 rows" Monster.irrepRows.length (Monster.irrepRows.map rowCan)

/-- A star system of *Foundation and Empire* as a can. -/
def sysCan (i : Nat) (s : Sys) : Can :=
  .can ("system " ++ toString i ++ ": " ++ (systemNames.getD i "?")) s.pop
    [ brainrot "who holds it" s.owner,
      brainrot "colonists" s.pop,
      brainrot "industry" s.ind,
      brainrot "hulls of the Foundation in orbit" s.s1,
      brainrot "hulls of the Empire in orbit" s.s2 ]

/-- The opening position of *Foundation and Empire* as a can. -/
def galaxyCan (g : Galaxy) : Can :=
  .can "Foundation and Empire: the opening position" g.sys.length
    ((g.sys.zipIdx.map (fun si => sysCan si.2 si.1)) ++
      [ brainrot "credits of the Foundation" g.cred1,
        brainrot "credits of the Empire" g.cred2,
        brainrot "technology of the Foundation" g.tech1,
        brainrot "technology of the Empire" g.tech2,
        brainrot "the round" g.round,
        brainrot "whose move it is" g.active,
        brainrot "who has won" g.winner ])

/-- **The world.** Everything above, in one can. -/
def nixwarsWorld : Can :=
  .can "NIXWARS" 0
    [ boardCan,
      tableCan,
      galaxyCan genesis,
      brainrot "a can of brainrot" 42 ]

/-! ### What the world holds -/

/-- No field of a cabinet is dropped: the names and the values match up. -/
theorem doorRoster_lengths :
    ∀ d ∈ doorRoster, (sessionFieldNames ++ d.2.1).length = d.2.2.length := by decide

/-- The cabinets of the world are the cabinets of the board, in order. -/
theorem doorRoster_names :
    doorRoster.map Prod.fst = Scene3D.doorScenes.map Prod.fst := by decide

/-- **A cabinet's can holds exactly what its 3D scene draws.** The number of
things you can fly into inside a cabinet is the number of fields the scene of
that cabinet puts on the screen. -/
theorem doorCans_match_scenes :
    (doorRoster.map (fun d => (d.1, (doorCan d).inside.length))) =
      Scene3D.doorScenes.map (fun p => (p.1, p.2.1)) := by decide

/-- Every cabinet is one flight from the board. -/
theorem board_inside : boardCan.inside = doorRoster.map doorCan := rfl

/-- The world holds the board, the table, the galaxy and a can of brainrot. -/
theorem world_inside :
    nixwarsWorld.inside = [boardCan, tableCan, galaxyCan genesis, brainrot "a can of brainrot" 42] :=
  rfl

/-- The table has one can per row of `irreps_sum.tsv`. -/
theorem tableCan_length : tableCan.inside.length = 194 := by
  simp [tableCan, Monster.irrepRows_length]

/-- Each row can holds the number it names and one tin per prime. -/
theorem rowCan_length (r : Monster.IrrepRow) (h : r ∈ Monster.irrepRows) :
    (rowCan r).inside.length = 16 := by
  have hlen : r.exps.length = 15 := Monster.exps_length r h
  have hp : monsterPrimes.length = 15 := monsterPrimes_length
  simp [rowCan, hlen, hp]

/-- The galaxy can holds its twelve systems and its seven counters. -/
theorem galaxyCan_length : (galaxyCan genesis).inside.length = 19 := by decide

/-- **Everything in the world is surfaced.** Every can anywhere in the world is
at the end of a flight from the world's own can, and when you arrive everything
inside it is standing on its own cube in the arena. -/
theorem world_surfaceable (d : Can) (hd : d ∈ parts nixwarsWorld) :
    ∃ p, follow nixwarsWorld p = some d ∧
      (∀ e ∈ d.inside, ∃ v, (v, e) ∈ shelf d) ∧
      (∀ q ∈ shelf d, q.1.x < Scene3D.arena ∧ q.1.y < Scene3D.arena ∧ q.1.z < Scene3D.arena) := by
  obtain ⟨p, hp, _, hcov, harena⟩ := surfaceable nixwarsWorld d hd
  exact ⟨p, hp, hcov, harena⟩

/-- The board is one flight in from the world, the Frontier Run's cabinet two,
and a field of that cabinet three: the ship's own position is three flights
from the front door of the world. -/
theorem frontier_is_two_flights :
    (follow nixwarsWorld [0, 13]).map Can.label = some "frontier" := by decide

theorem frontier_field_is_three_flights :
    (follow nixwarsWorld [0, 13, 3]).map Can.label = some "x" := by decide

/-- The ship of the Frontier Run is three cans: its `x`, its `y` and its `z`,
each of them a value in a labelled tin, three flights from the front door. -/
theorem frontier_ship_is_three_cans :
    [3, 4, 5].map (fun k => (follow nixwarsWorld [0, 13, k]).map Can.label) =
      [some "x", some "y", some "z"] := by decide

/-- The first row of the Monster's table is two flights in, and the number it
names is three. -/
theorem row_is_two_flights :
    (follow nixwarsWorld [1, 0]).map Can.label = some "row 192" := by decide

theorem row_value_is_three_flights :
    (follow nixwarsWorld [1, 0, 0]).map Can.value =
      some (Monster.rowValue ⟨192, [46, 2, 0, 0, 2, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1], 56⟩) := by
  decide

end Cans

end NixWars
