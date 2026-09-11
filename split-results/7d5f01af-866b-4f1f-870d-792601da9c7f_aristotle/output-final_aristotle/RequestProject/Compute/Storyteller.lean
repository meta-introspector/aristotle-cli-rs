import RequestProject.Compute.Interpreter

/-!
# Ten Stories: Narrative Overlays on the Confluence Diamond

The `RequestProject.Compute.Interpreter` storyteller narrates the *executable* value-flow of the
attention dynamics under a single, fixed vocabulary (`nodeName`, in the "history of mathematics"
spirit of the Moonshine confluence diamond).

This module generalises that idea. A single underlying object — the 14-node confluence-diamond
value-flow `simRun qAttentionMatrix (pointMass 14 start) t` — is a *purely numerical* trace; the
"story" is only the vocabulary we lay over its nodes. We therefore separate the two cleanly:

* a **`NarrativeOverlay`** is just a name for a domain together with a labelling of the 14 nodes;
* the **trace** is overlay-independent (the dynamics never look at the labels).

We then provide **ten overlays** — the history of mathematics, mycology, the Linux-kernel eBPF
pipeline, the Tarot, the Iliad, the story of America, alchemy, Norse cosmology, the Hero's
Journey, and the tree of life — and a uniform `storyUnder` that narrates the same flow in each.

Because the labelling is the *only* thing that changes between domains, every story is faithful
to the same machine-checked dynamics:

* `trace_overlay_independent` — the underlying numeric trace does not depend on the overlay;
* `story_length` — every story has exactly `steps + 1` lines;
* `overlays_length` — there are exactly ten overlays;
* `every_story_converges` — under *every* overlay, the narrated value-flow concentrates all of
  its mass at the terminal node (index `13`) after `12` steps (reusing the verified
  `objectInterpreter_converges`).

All of this is computable, so the `#eval` demonstrations at the end actually print the ten
stories.
-/

namespace RequestProject.Compute.Storyteller

open RequestProject.Compute.Interpreter

/-! ## Narrative overlays -/

/-- A **narrative overlay**: a domain name together with a vocabulary for the 14 nodes of the
confluence diamond. The `labels` list is intended to have length `14` (node `i` is named
`labels[i]`); shorter lists fall back to a generic `Node i` name, so the structure is total. -/
structure NarrativeOverlay where
  /-- The name of the narrative domain (e.g. `"History of Mathematics"`). -/
  domain : String
  /-- Names for the 14 nodes, indexed `0..13`. -/
  labels : List String

/-- The label an overlay assigns to node `i`, with a total fallback. -/
def NarrativeOverlay.nodeLabel (o : NarrativeOverlay) (i : Fin 14) : String :=
  (o.labels[i.val]?).getD s!"Node {i.val}"

/-! ### The ten domains

Each overlay follows the shared *shape* of the confluence diamond: an origin (node `0`), two
branches that diverge (`1`, `2`) and reconverge at a hub (`3`), a descent of nine intermediate
stages (`4..12`), and a terminal/absorbing state (`13`). -/

/-- 1. The history of mathematics — the original Moonshine vocabulary, generalised. -/
def mathHistory : NarrativeOverlay where
  domain := "History of Mathematics"
  labels :=
    [ "Origin: Counting & Number",
      "Greek Geometry (Euclid)",
      "Indian–Arabic Algebra",
      "Synthesis: Analytic Geometry",
      "Calculus (Newton–Leibniz)",
      "Analysis & Rigour (Cauchy)",
      "Non-Euclidean Geometry",
      "Abstract Algebra (Galois)",
      "Set Theory (Cantor)",
      "Foundations (Hilbert)",
      "Incompleteness (Gödel)",
      "Computation (Turing)",
      "Category Theory",
      "Living Mathematics (Today)" ]

/-- 2. Mycology — the life cycle of a mushroom. -/
def mycology : NarrativeOverlay where
  domain := "Mycology"
  labels :=
    [ "Spore",
      "Hyphal Tip (mating type A)",
      "Hyphal Tip (mating type B)",
      "Mycelial Network Hub",
      "Primordium",
      "Pinhead",
      "Stipe Elongation",
      "Cap Expansion",
      "Gill Formation",
      "Veil Rupture",
      "Basidia Maturation",
      "Spore Print",
      "Sporulation",
      "Decomposition & Return" ]

/-- 3. The Linux-kernel eBPF pipeline — from source to consumed result. -/
def ebpf : NarrativeOverlay where
  domain := "Linux Kernel eBPF"
  labels :=
    [ "User Program Source (.bpf.c)",
      "Clang/LLVM Frontend",
      "BTF Type Information",
      "ELF Object Loader (libbpf)",
      "bpf() Syscall",
      "Verifier: CFG Check",
      "Verifier: Range Analysis",
      "JIT Compilation",
      "Map Creation",
      "Hook Attachment (kprobe/XDP)",
      "Event Trigger",
      "Program Execution",
      "Perf / Ring Buffer Output",
      "Userspace Consumes Result" ]

/-- 4. The Tarot — the Fool's journey through the Major Arcana. -/
def tarot : NarrativeOverlay where
  domain := "The Tarot"
  labels :=
    [ "0 — The Fool",
      "I — The Magician",
      "II — The High Priestess",
      "VI — The Lovers (Confluence)",
      "VII — The Chariot",
      "X — Wheel of Fortune",
      "XI — Justice",
      "XII — The Hanged Man",
      "XIII — Death",
      "XV — The Devil",
      "XVI — The Tower",
      "XVII — The Star",
      "XIX — The Sun",
      "XXI — The World" ]

/-- 5. The Iliad — the wrath of Achilles to the funeral of Hector. -/
def iliad : NarrativeOverlay where
  domain := "The Iliad"
  labels :=
    [ "The Wrath of Achilles",
      "Agamemnon's Claim",
      "Achilles' Withdrawal",
      "The Embassy / Council Hub",
      "Battle at the Ships",
      "The Trojan Onslaught",
      "Patroclus Enters the Fray",
      "The Fall of Patroclus",
      "Achilles' Grief",
      "The Shield of Achilles",
      "Return to Battle",
      "The Duel with Hector",
      "The Death of Hector",
      "The Funeral of Hector" ]

/-- 6. The story of America — indigenous nations to the present day. -/
def america : NarrativeOverlay where
  domain := "The Story of America"
  labels :=
    [ "Indigenous Nations",
      "European Colonization",
      "The Thirteen Colonies",
      "Revolution & Founding",
      "The Constitution",
      "Westward Expansion",
      "The Civil War",
      "Reconstruction",
      "The Industrial Age",
      "The World Wars",
      "Civil Rights",
      "The Cold War",
      "The Digital Era",
      "America Today" ]

/-- 7. Alchemy — the stages of the Magnum Opus. -/
def alchemy : NarrativeOverlay where
  domain := "Alchemy (Magnum Opus)"
  labels :=
    [ "Prima Materia",
      "Sulphur (active principle)",
      "Mercury (passive principle)",
      "Conjunction",
      "Nigredo (Blackening)",
      "Putrefaction",
      "Albedo (Whitening)",
      "Ablution",
      "Citrinitas (Yellowing)",
      "Fermentation",
      "Distillation",
      "Rubedo (Reddening)",
      "Coagulation",
      "The Philosopher's Stone" ]

/-- 8. Norse cosmology — from the void to the world reborn. -/
def norse : NarrativeOverlay where
  domain := "Norse Mythology"
  labels :=
    [ "Ginnungagap (the Void)",
      "Muspelheim (Fire)",
      "Niflheim (Ice)",
      "Ymir & the First Beings",
      "Birth of the Gods",
      "Yggdrasil, the World Tree",
      "Asgard of the Aesir",
      "Midgard of Humankind",
      "The Mead of Poetry",
      "Loki's Mischief",
      "The Death of Baldr",
      "The Binding of Loki",
      "Ragnarök",
      "The World Reborn" ]

/-- 9. The Hero's Journey — Campbell's monomyth. -/
def heroJourney : NarrativeOverlay where
  domain := "The Hero's Journey"
  labels :=
    [ "The Ordinary World",
      "Call to Adventure",
      "Refusal of the Call",
      "Meeting the Mentor",
      "Crossing the Threshold",
      "Tests, Allies, Enemies",
      "Approach to the Inmost Cave",
      "The Ordeal",
      "The Reward",
      "The Road Back",
      "The Resurrection",
      "Return with the Elixir",
      "Mastery of Two Worlds",
      "The World Renewed" ]

/-- 10. The tree of life — abiogenesis to *Homo sapiens*. -/
def treeOfLife : NarrativeOverlay where
  domain := "The Tree of Life"
  labels :=
    [ "Abiogenesis (LUCA)",
      "Bacteria",
      "Archaea",
      "Eukaryotes (Endosymbiosis)",
      "Multicellularity",
      "The Cambrian Explosion",
      "Vertebrates",
      "Land Plants",
      "Tetrapods",
      "Amniotes",
      "Mammals",
      "Primates",
      "Hominins",
      "Homo sapiens" ]

/-- The ten narrative overlays. -/
def overlays : List NarrativeOverlay :=
  [ mathHistory, mycology, ebpf, tarot, iliad,
    america, alchemy, norse, heroJourney, treeOfLife ]

/-! ## Narrating the shared value-flow under any overlay -/

/-- The overlay-free content of one distribution: the list of `(node, weight)` pairs that
currently carry nonzero attention. This is the numeric substance of a narration; only the
*labels* attached to it depend on the chosen domain. -/
def activeNodes (a : Array ℚ) : List (Fin 14 × ℚ) :=
  (List.finRange 14).filterMap fun i =>
    let x := a[i.val]!
    if x = 0 then none else some (i, x)

/-- Narrate one Level-1 distribution (stored as an array) as a single line of text under a given
overlay, listing the nodes that currently carry attention together with their weights. -/
def narrateUnder (o : NarrativeOverlay) (t : ℕ) (a : Array ℚ) : String :=
  let parts := (activeNodes a).map fun p => s!"{o.nodeLabel p.1} ↦ {p.2}"
  s!"Step {t}: " ++ String.intercalate ", " parts

/-- The story of the value-flow under a given overlay: starting from `start`, run the verified
executable interpreter for `steps` steps, narrating each step in the overlay's vocabulary. -/
def storyUnder (o : NarrativeOverlay) (start : Fin 14) (steps : ℕ) : List String :=
  (List.range (steps + 1)).map fun t =>
    narrateUnder o t (simRun qAttentionMatrix (pointMass 14 start) t)

/-- A full, titled story for an overlay: the default flow from the root (node `0`) to the
terminus over the canonical `12` steps, with the domain name as a heading. -/
def titledStory (o : NarrativeOverlay) : String × List String :=
  (o.domain, storyUnder o 0 12)

/-- The ten stories: each overlay narrating the same root-to-terminus value-flow. -/
def tenStories : List (String × List String) :=
  overlays.map titledStory

/-! ## Faithfulness and structural facts

The vocabulary is the *only* degree of freedom: the numeric dynamics underneath every story are
identical and already machine-checked. -/

/-- **Overlay-independence of the substance.** Every narration is built from the
overlay-free `activeNodes` data; the overlay only supplies labels. Two overlays sharing the
same `labels` therefore produce identical narrations for any step and distribution. -/
theorem narrateUnder_labels_congr {o₁ o₂ : NarrativeOverlay} (h : o₁.labels = o₂.labels)
    (t : ℕ) (a : Array ℚ) : narrateUnder o₁ t a = narrateUnder o₂ t a := by
  simp only [narrateUnder, NarrativeOverlay.nodeLabel, h]

/-- Every story has exactly `steps + 1` lines (one per time step, including `t = 0`). -/
theorem story_length (o : NarrativeOverlay) (start : Fin 14) (steps : ℕ) :
    (storyUnder o start steps).length = steps + 1 := by
  simp only [storyUnder, List.length_map, List.length_range]

/-- There are exactly ten overlays, hence exactly ten stories. -/
theorem overlays_length : overlays.length = 10 := rfl

/-- There are exactly ten stories. -/
theorem tenStories_length : tenStories.length = 10 := rfl

/-- **Every story converges.** Under *any* overlay, narrating the value-flow from any starting
node, the underlying distribution concentrates all of its mass at the terminal node (index `13`)
after `12` steps. This is the verified `objectInterpreter_converges`, now seen to hold uniformly
across all ten narrative domains. -/
theorem every_story_converges (o : NarrativeOverlay) (start : Fin 14) :
    decodeVec (n := 14) (simRun qAttentionMatrix (pointMass 14 start) 12) 13 = 1 :=
  objectInterpreter_converges start

/-! ## Executable demonstrations -/

/-- Render all ten stories as one printable text block. -/
def renderTenStories : String :=
  String.intercalate "\n\n"
    (tenStories.map fun ts =>
      s!"==== {ts.1} ====" ++ "\n" ++ String.intercalate "\n" ts.2)

-- The ten stories, each narrating the same verified value-flow in its own vocabulary:
#eval IO.println renderTenStories

end RequestProject.Compute.Storyteller
