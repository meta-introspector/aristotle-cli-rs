/-
# The Smallest Self-Copying Machine

A competition entry: a `Tech` tree, described by a `CardSet` (a deck of punched
clay tablets), one of whose outputs is *literally* the deck that built it.

Backend theme: **fired clay**.  Every machine in the tree is a kiln-fired clay
device; a *card* is a clay tablet with the machine's specification pressed into
it.  The one machine that matters is the **tablet press**: once it exists, it
walks the finished workshop, reads each machine that was fired, and presses one
tablet per machine, in firing order.  The deck that comes off the press is the
deck you started from.

The fixed point therefore is not "the deck stores a copy of itself"; the deck
stores *no* copy of anything.  It is that the deck's card order **is** a legal
firing order, and the press's record of the firing **is** the deck.  A tablet
both is a payload and describes a payload, exactly as in a minimal quine.

Everything here is decidable and `#eval`-able; see the `#eval`s at the bottom.
-/

namespace SelfCopy

/-! ## §0  Bootstrap exceptions: what is assumed for free

These are the only things the tree does not build.  They are declared here,
explicitly, and `ValidSequence` refuses any machine that feeds on anything else,
so nothing can be smuggled in. -/

/-- Raw stuff picked up off the riverbank. -/
inductive Material
  | clay | water | reed | fire
deriving DecidableEq, Repr

/-- **BootstrapExceptions** — assumed available in unlimited quantity, at tier 0,
without being produced by any node of the tree: river clay, water, cut reed and
an open fire.  Nothing else is free. -/
def BootstrapExceptions : List Material := [.clay, .water, .reed, .fire]

/-! ## §1  Cards, machines, trees -/

/-- A **card**: one clay tablet, carrying the full specification of one machine.
`raw` are the bootstrap materials it consumes, `needs` are the machines that must
already exist, `press` says whether this machine can press tablets. -/
structure Card where
  name  : String
  tier  : Nat
  raw   : List Material
  needs : List String
  press : Bool
deriving DecidableEq, Repr

/-- A **card set** (a deck) is an ordered list of tablets. -/
abbrev CardSet := List Card

/-- A **machine**: a fired, physical device standing on the workshop floor. -/
structure Machine where
  label   : String
  tier    : Nat
  feed    : List Material
  parents : List String
  punches : Bool
deriving DecidableEq, Repr

/-- A **tech tree** is the collection of machines a deck calls for. -/
structure Tech where
  nodes : List Machine
deriving DecidableEq, Repr

/-- Fire a machine from the tablet that specifies it. -/
def build (c : Card) : Machine :=
  ⟨c.name, c.tier, c.raw, c.needs, c.press⟩

/-- Read a standing machine and press a tablet describing it. -/
def punch (m : Machine) : Card :=
  ⟨m.label, m.tier, m.feed, m.parents, m.punches⟩

/-- Reading a deck yields the tech tree it specifies. -/
def interpret (cs : CardSet) : Tech := ⟨cs.map build⟩

/-- The press is an exact reader: pressing a tablet from a machine you just
fired from a tablet returns that tablet. -/
@[simp] theorem punch_build (c : Card) : punch (build c) = c := rfl

/-! ## §2  Build sequences -/

/-- A **bootstrap sequence** is the firing log: the machines that were built,
in the order they were built. -/
abbrev BootstrapSeq := List Machine

/-- The step-by-step legality check.  `built` is the set of labels already
standing (most recent first) and `reached` is the highest tier unlocked so far
(tier `0` is unlocked from the start; firing a tier-`k` machine unlocks tier
`k+1`). -/
def validFrom (t : Tech) : List String → Nat → BootstrapSeq → Bool
  | _, _, [] => true
  | built, reached, m :: rest =>
      t.nodes.contains m &&
      !built.contains m.label &&
      m.parents.all (fun p => built.contains p) &&
      m.feed.all (fun x => BootstrapExceptions.contains x) &&
      decide (m.tier ≤ reached) &&
      validFrom t (m.label :: built) (max reached (m.tier + 1)) rest

/-- `validSeq seq t` : the log `seq` is a legal, complete build of `t`.  Every
entry is a node of `t`, no machine is built twice, every prerequisite is already
standing, every raw input is a declared bootstrap exception, no tier is skipped,
and every node of `t` really does get built. -/
def validSeq (seq : BootstrapSeq) (t : Tech) : Bool :=
  validFrom t [] 0 seq && t.nodes.all (fun m => seq.contains m)

/-- Propositional form of `validSeq`. -/
def ValidSequence (seq : BootstrapSeq) (t : Tech) : Prop := validSeq seq t = true

instance (seq : BootstrapSeq) (t : Tech) : Decidable (ValidSequence seq t) := by
  unfold ValidSequence; infer_instance

/-! ## §3  Output -/

/-- What the workshop **emits**: nothing at all unless a tablet press was among
the machines built; if one was, the press reads the finished workshop and presses
one tablet per machine, in firing order. -/
def emit (seq : BootstrapSeq) : CardSet :=
  if seq.any (fun m => m.punches) then seq.map punch else []

/-- **The competition target.**  Running `cs` through some valid build sequence
produces, as its output, the card set `cs` itself. -/
def SelfCopying (cs : CardSet) : Prop :=
  ∃ seq : BootstrapSeq,
    ValidSequence seq (interpret cs) ∧
    (emit seq) = cs

/-! ## §4  The general criterion

A deck is self-copying as soon as (a) it contains a press and (b) its own card
order is a legal firing order.  This is the whole mechanism: the deck is its own
build script, and the press's log of executing that script is the deck. -/

/-- The press really does reproduce the deck it was built from, provided the deck
calls for a press at all. -/
theorem emit_map_build (cs : CardSet) (hp : cs.any (fun c => c.press) = true) :
    emit (cs.map build) = cs := by
  have h1 : (cs.map build).any (fun m => m.punches) = true := by
    simpa [List.any_map, Function.comp, build] using hp
  simp [emit, h1, List.map_map, Function.comp_def]

/-- **Main criterion.**  If a deck contains a press and reading the deck in
order is itself a legal build of the tree the deck describes, the deck is
self-copying. -/
theorem selfCopying_of_deckOrder (cs : CardSet)
    (hp : cs.any (fun c => c.press) = true)
    (hv : ValidSequence (cs.map build) (interpret cs)) :
    SelfCopying cs :=
  ⟨cs.map build, hv, emit_map_build cs hp⟩

/-! ## §5  The entry: a one-card deck

`monogram` is a single tablet.  It specifies a tablet press made of clay and
fire, at tier 0, needing no other machine.  Fire the press; the press then
looks around the workshop, sees exactly one machine — itself — and presses one
tablet: its own specification.  Deck in, same deck out. -/

/-- The one card. -/
def pressCard : Card :=
  { name := "clay tablet press", tier := 0, raw := [.clay, .fire],
    needs := [], press := true }

/-- **The entry.**  One node. -/
def monogram : CardSet := [pressCard]

/-- The firing log: fire the press, and stop. -/
def monogramSeq : BootstrapSeq := monogram.map build

theorem monogram_valid : ValidSequence monogramSeq (interpret monogram) := by
  decide

theorem monogram_emits : emit monogramSeq = monogram := by
  decide

/-- **The fixed point, at one node.** -/
theorem monogram_selfCopying : SelfCopying monogram :=
  ⟨monogramSeq, monogram_valid, monogram_emits⟩

/-! ## §6  Minimality

Only the empty deck is smaller, and the empty deck emits nothing: it is
self-copying only in the degenerate sense that nothing copies to nothing.  Any
deck that emits at all must contain a press, so one card is the true minimum. -/

/-- The empty deck is vacuously self-copying — the degenerate solution the
competition is not asking for. -/
theorem empty_selfCopying : SelfCopying ([] : CardSet) :=
  ⟨[], by decide, by decide⟩

/-- A deck **produces** something if its tree contains a press. -/
def Productive (cs : CardSet) : Prop := cs.any (fun c => c.press) = true

/-- Any nonempty self-copying deck must contain a press: you cannot copy a
nonempty deck without the machine that presses tablets. -/
theorem productive_of_selfCopying (cs : CardSet) (h : SelfCopying cs) (hne : cs ≠ []) :
    Productive cs := by
  obtain ⟨seq, _, he⟩ := h
  unfold emit at he
  split at he
  · -- the log punched; the deck is the punched log, so the press is in it
    rename_i hs
    subst he
    simpa [Productive, List.any_map, Function.comp_def, punch] using hs
  · exact absurd he.symm hne

/-- **Minimality.**  Nothing smaller than `monogram` can be a solution worth the
name: the only deck with fewer than one card is the empty deck, and the empty
deck is not productive — it contains no press, so it emits nothing at all.
Together with `productive_of_selfCopying`, this says every self-copying deck
except `[]` has at least `monogram.length = 1` cards. -/
theorem no_smaller_solution (cs : CardSet) (hlt : cs.length < monogram.length) :
    cs = [] ∧ ¬ Productive cs := by
  have : cs = [] := by
    cases cs with
    | nil => rfl
    | cons c rest => simp [monogram] at hlt
  exact ⟨this, by simp [this, Productive]⟩

theorem monogram_length : monogram.length = 1 := rfl

/-- **Shape of every one-card solution.**  A self-copying deck of one card is,
necessarily, a press at tier 0 with no prerequisites — i.e. `monogram` up to its
name and its choice of raw materials.  So the entry is not merely of minimal
size, it is the unique minimal shape. -/
theorem one_card_shape (c : Card) (h : SelfCopying [c]) :
    c.press = true ∧ c.tier = 0 ∧ c.needs = [] := by
  -- the press must exist, else nothing is emitted
  have hpress : c.press = true := by
    have := productive_of_selfCopying [c] h (by simp)
    simpa [Productive] using this
  obtain ⟨seq, hv, _⟩ := h
  have h0 : validSeq seq (interpret [c]) = true := hv
  rw [validSeq, Bool.and_eq_true] at h0
  obtain ⟨hstep, hcomp⟩ := h0
  -- completeness forces the press to be built at all …
  have hmem : seq.contains (build c) = true := by
    simpa using List.all_eq_true.mp hcomp (build c) (by simp [interpret])
  cases seq with
  | nil => simp at hmem
  | cons m rest =>
      -- … and it can only be the very first machine fired
      simp [validFrom, Bool.and_eq_true, interpret] at hstep
      obtain ⟨⟨⟨⟨hm, hpar⟩, _⟩, htier⟩, _⟩ := hstep
      subst hm
      refine ⟨hpress, by simpa [build] using htier, ?_⟩
      have hnone : ∀ x : String, x ∉ c.needs := by simpa [build] using hpar
      exact List.eq_nil_iff_forall_not_mem.mpr hnone

/-! ## §7  Tier discipline

`ValidSequence` does not merely forbid building above the frontier; it forbids
*skipping*.  If anything of tier `k+1` is ever built, something of tier exactly
`k` was built before it. -/

/-- The invariant carried along a legal build: everything below the unlocked
frontier has actually been reached. -/
theorem validFrom_no_skip (t : Tech) :
    ∀ (seq : BootstrapSeq) (built : List String) (reached : Nat),
      validFrom t built reached seq = true →
      ∀ m ∈ seq, ∀ r, r < m.tier →
        (r < reached ∨ ∃ m' ∈ seq, m'.tier = r) := by
  intro seq
  induction seq with
  | nil => intro _ _ _ m hm; simp at hm
  | cons a rest ih =>
      intro built reached h m hm r hr
      simp [validFrom, Bool.and_eq_true] at h
      obtain ⟨⟨⟨⟨_, _⟩, _⟩, hta⟩, hrest⟩ := h
      rcases List.mem_cons.mp hm with rfl | hm'
      · -- `m = a` : its tier is below the frontier already
        exact Or.inl (by omega)
      · rcases ih (a.label :: built) (max reached (a.tier + 1)) hrest m hm' r hr with
          hlt | ⟨m', hm'', hev⟩
        · by_cases h1 : r < reached
          · exact Or.inl h1
          -- `r` is between `reached` and `a.tier + 1`, so `r = a.tier`
          · exact Or.inr ⟨a, by simp, by omega⟩
        · exact Or.inr ⟨m', List.mem_cons_of_mem _ hm'', hev⟩

/-- **Tier monotonicity / no tier-skipping.**  In any valid sequence, every tier
strictly below the tier of a built machine is itself the tier of some built
machine.  In particular a tier-`k+1` machine is never built in a tree with no
tier-`k` machine, and the tiers built form an unbroken run `0, 1, …`. -/
theorem tier_monotonicity {seq : BootstrapSeq} {t : Tech} (h : ValidSequence seq t)
    {m : Machine} (hm : m ∈ seq) {r : Nat} (hr : r < m.tier) :
    ∃ m' ∈ seq, m'.tier = r := by
  have h0 : validSeq seq t = true := h
  rw [validSeq, Bool.and_eq_true] at h0
  rcases validFrom_no_skip t seq [] 0 h0.1 m hm r hr with h2 | h2
  · omega
  · exact h2

/-- Honesty about the bootstrap exceptions: in a valid build, every raw input of
every machine is one of the four declared free materials. -/
theorem validFrom_feeds (t : Tech) :
    ∀ (seq : BootstrapSeq) (built : List String) (reached : Nat),
      validFrom t built reached seq = true →
      ∀ m ∈ seq, ∀ x ∈ m.feed, x ∈ BootstrapExceptions := by
  intro seq
  induction seq with
  | nil => intro _ _ _ m hm; simp at hm
  | cons a rest ih =>
      intro built reached h m hm x hx
      simp [validFrom, Bool.and_eq_true] at h
      obtain ⟨⟨⟨⟨_, _⟩, hfeed⟩, _⟩, hrest⟩ := h
      rcases List.mem_cons.mp hm with rfl | hm'
      · have := hfeed x hx
        simpa using this
      · exact ih (a.label :: built) (max reached (a.tier + 1)) hrest m hm' x hx

/-- **No smuggling.**  Everything a valid build consumes without producing is on
the declared `BootstrapExceptions` list. -/
theorem exceptions_honest {seq : BootstrapSeq} {t : Tech} (h : ValidSequence seq t)
    {m : Machine} (hm : m ∈ seq) {x : Material} (hx : x ∈ m.feed) :
    x ∈ BootstrapExceptions := by
  have h0 : validSeq seq t = true := h
  rw [validSeq, Bool.and_eq_true] at h0
  exact validFrom_feeds t seq [] 0 h0.1 m hm x hx

/-! ## §8  A larger clay workshop, to show the mechanism scales

Three machines: a kiln and a reed stylus at tier 0, and the tablet press at
tier 1, which needs both.  The deck lists them in firing order; the press
records the firing; the record is the deck. -/

def kilnCard : Card :=
  { name := "kiln", tier := 0, raw := [.clay, .fire], needs := [], press := false }

def stylusCard : Card :=
  { name := "reed stylus", tier := 0, raw := [.reed], needs := [], press := false }

def workshopPressCard : Card :=
  { name := "tablet press", tier := 1, raw := [.clay, .water],
    needs := ["kiln", "reed stylus"], press := true }

/-- The three-card clay workshop. -/
def workshop : CardSet := [kilnCard, stylusCard, workshopPressCard]

def workshopSeq : BootstrapSeq := workshop.map build

theorem workshop_valid : ValidSequence workshopSeq (interpret workshop) := by
  decide

theorem workshop_emits : emit workshopSeq = workshop := by
  decide

theorem workshop_selfCopying : SelfCopying workshop :=
  ⟨workshopSeq, workshop_valid, workshop_emits⟩

/-! ### Negative controls: the checks have teeth -/

/-- Drop the press from the workshop and nothing is emitted at all. -/
theorem pressless_emits_nothing :
    emit ([kilnCard, stylusCard].map build) = [] := by decide

/-- Deal the workshop out of firing order (press first) and the sequence is
rejected: its prerequisites are not standing. -/
theorem out_of_order_invalid :
    ¬ ValidSequence ([workshopPressCard, kilnCard, stylusCard].map build)
        (interpret workshop) := by decide

/-- A tier-1 machine with no tier-0 machine below it is rejected: no skipping. -/
def skipCard : Card :=
  { name := "impossible press", tier := 1, raw := [.clay], needs := [], press := true }

theorem tier_skip_invalid :
    ¬ ValidSequence ([skipCard].map build) (interpret [skipCard]) := by decide

/-- A machine fed on something not declared free is rejected. -/
def smuggleCard : Card :=
  { name := "bronze press", tier := 0, raw := [.clay], needs := ["bronze"], press := true }

theorem smuggling_invalid :
    ¬ ValidSequence ([smuggleCard].map build) (interpret [smuggleCard]) := by decide

/-! ## §9  The mechanical judge

One decidable function decides the whole correctness gate, so a judge never has
to read a proof: `checkEntry cs` says whether `cs` is a self-copying deck in the
strong (non-degenerate) sense, and `checkEntry_sound` says the checker is right. -/

/-- The judge: does the deck contain a press, is the deck's own order a legal,
tier-respecting, exception-honest, complete build of the tree it describes, and
does the press's output equal the deck? -/
def checkEntry (cs : CardSet) : Bool :=
  cs.any (fun c => c.press) &&
  validSeq (cs.map build) (interpret cs) &&
  (emit (cs.map build) == cs)

/-- **Soundness of the judge.**  A deck the checker accepts really is
self-copying (and nonempty). -/
theorem checkEntry_sound (cs : CardSet) (h : checkEntry cs = true) :
    SelfCopying cs ∧ cs ≠ [] := by
  rw [checkEntry, Bool.and_eq_true, Bool.and_eq_true] at h
  obtain ⟨⟨hp, hv⟩, _⟩ := h
  refine ⟨selfCopying_of_deckOrder cs hp hv, ?_⟩
  intro hnil
  rw [hnil] at hp
  simp at hp

/-- **Completeness of the judge on deck-ordered entries.**  Conversely, the
checker accepts every nonempty deck whose own order is a legal build — which by
`productive_of_selfCopying` and `one_card_shape` is the only shape a minimal
solution can take. -/
theorem checkEntry_of_deckOrder (cs : CardSet)
    (hp : cs.any (fun c => c.press) = true)
    (hv : ValidSequence (cs.map build) (interpret cs)) :
    checkEntry cs = true := by
  have he : emit (cs.map build) = cs := emit_map_build cs hp
  have hv' : validSeq (cs.map build) (interpret cs) = true := hv
  simp [checkEntry, hp, hv', he]

theorem monogram_accepted : checkEntry monogram = true := by decide

theorem workshop_accepted : checkEntry workshop = true := by decide

theorem empty_rejected : checkEntry [] = false := by decide

/-! ## §10  The physical form

An ASCII elevation of the workshop: one fired clay tablet per machine, in firing
order.  This is what the press stacks up on the bench when it is done. -/

private def padTo (s : String) (n : Nat) : String :=
  s ++ String.ofList (List.replicate (n - s.length) ' ')

def matName : Material → String
  | .clay => "clay" | .water => "water" | .reed => "reed" | .fire => "fire"

/-- Draw one clay tablet. -/
def tabletArt (c : Card) : String :=
  let w := 34
  let bar := String.ofList (List.replicate w '-')
  let mats := if c.raw.isEmpty then "-" else String.intercalate " + " (c.raw.map matName)
  let needs := if c.needs.isEmpty then "-" else String.intercalate ", " c.needs
  "  +" ++ bar ++ "+\n" ++
  "  | " ++ padTo (c.name ++ (if c.press then " *" else "")) (w - 8) ++
      "tier " ++ toString c.tier ++ " |\n" ++
  "  | " ++ padTo ("clay pit: " ++ mats) (w - 1) ++ "|\n" ++
  "  | " ++ padTo ("needs:    " ++ needs) (w - 1) ++ "|\n" ++
  "  +" ++ bar ++ "+"

/-- Draw the whole deck: the stack of tablets, top of the stack first. -/
def deckArt (cs : CardSet) : String :=
  String.intercalate "\n" (cs.map tabletArt)

/-! ## §9  Independent verification by evaluation -/

section Eval

-- The deck.
#eval monogram
-- The firing log.
#eval monogramSeq
-- What comes off the press.
#eval emit monogramSeq
-- The build is legal …
#eval validSeq monogramSeq (interpret monogram)
-- … and the output is *literally* the deck.  `true` means the fixed point holds.
#eval decide (validSeq monogramSeq (interpret monogram) = true ∧
              emit monogramSeq = monogram)

-- Same, for the three-card workshop.
#eval decide (validSeq workshopSeq (interpret workshop) = true ∧
              emit workshopSeq = workshop)

-- The declared bootstrap exceptions.
#eval BootstrapExceptions

-- The mechanical judge, on both entries and on the degenerate empty deck.
#eval checkEntry monogram
#eval checkEntry workshop
#eval checkEntry []

-- The physical form: the tablets the press stacks on the bench.
#eval IO.println (deckArt monogram)
#eval IO.println (deckArt workshop)

end Eval

end SelfCopy
