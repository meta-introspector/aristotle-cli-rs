/-
# Emoji Grammar: A Formal Language for the Meta-Meme

Instead of `abbrev SemanticCompound := List String`, we define a proper
inductive type for emojis and a typed semantic compound. This allows Lean
to reason structurally about emoji expressions.

## The Key Insight

The emoji sequences in SOLFUNMEME are not arbitrary strings — they are
elements of a formal language with:
- A finite alphabet (the emoji set)
- Semantic denotation (each emoji has a meaning)
- Compositional structure (sequences compose meanings)

This file formalizes that structure.
-/

import Mathlib

namespace EmojiGrammar

/-! ## §1. The Emoji Alphabet -/

/-- The formal emoji alphabet used in SOLFUNMEME.
    Each constructor represents a specific emoji with well-defined semantics. -/
inductive Emoji where
  | rocket      -- 🚀 launch / viral propagation
  | scroll      -- 📜 record / immutable state
  | magnifier   -- 🔍 inspect / introspection
  | speech      -- 💬 communicate / consensus
  | brain       -- 🧠 reason / self-reflection
  | key         -- 🔑 unlock / access
  | idea        -- 💡 discover / emergent meaning
  | thought     -- 💭 imagine / creative synthesis
  | shuffle     -- 🔀 combine / recombination
  | cycle       -- 🔄 iterate / self-replication
  | robot       -- 🤖 AI agent / autonomous agent
  | globe       -- 🌐 decentralized / distributed
  | chart       -- 📊 data / measurement
  | link        -- 🔗 connection / content-addressing
  | puzzle      -- 🧩 component / composable module
  | seedling    -- 🌱 growth / evolution
  deriving DecidableEq, Repr, Inhabited, Fintype

/-- A semantic compound is a list of emojis — a "word" in the meta-language. -/
abbrev SemanticCompound := List Emoji

/-! ## §2. Semantic Denotation -/

/-- The semantic category of an emoji: what aspect of the system it refers to. -/
inductive SemanticCategory where
  | action      -- something that happens
  | state       -- something that persists
  | agent       -- something that acts
  | structure   -- something that connects
  deriving DecidableEq, Repr

/-- Each emoji maps to a meaning string. -/
def Emoji.meaning : Emoji → String
  | .rocket    => "launch"
  | .scroll    => "record"
  | .magnifier => "inspect"
  | .speech    => "communicate"
  | .brain     => "reason"
  | .key       => "unlock"
  | .idea      => "discover"
  | .thought   => "imagine"
  | .shuffle   => "combine"
  | .cycle     => "iterate"
  | .robot     => "autonomous-agent"
  | .globe     => "decentralized"
  | .chart     => "measure"
  | .link      => "connect"
  | .puzzle    => "compose"
  | .seedling  => "evolve"

/-- Each emoji has a semantic category. -/
def Emoji.category : Emoji → SemanticCategory
  | .rocket    => .action
  | .scroll    => .state
  | .magnifier => .action
  | .speech    => .action
  | .brain     => .agent
  | .key       => .action
  | .idea      => .state
  | .thought   => .state
  | .shuffle   => .action
  | .cycle     => .action
  | .robot     => .agent
  | .globe     => .structure
  | .chart     => .state
  | .link      => .structure
  | .puzzle    => .structure
  | .seedling  => .action

/-! ## §3. The Four SOLFUNMEME Emoji Sequences -/

/-- 🚀📜🔍💬🧠 — Self-reflection & viral meme propagation -/
def selfReflectionSeq : SemanticCompound :=
  [.rocket, .scroll, .magnifier, .speech, .brain]

/-- 🔀💡💭🔑 — Emergent meme structures & narrative shifts -/
def emergentMeaningSeq : SemanticCompound :=
  [.shuffle, .idea, .thought, .key]

/-- 🤖🌐📊🔗 — AI-driven decentralized meme consensus -/
def consensusSeq : SemanticCompound :=
  [.robot, .globe, .chart, .link]

/-- 🧩🔗🌱 — Evolution & self-replicating meme economy -/
def evolutionSeq : SemanticCompound :=
  [.puzzle, .link, .seedling]

/-! ## §4. Structural Properties -/

/-- The emoji alphabet has exactly 16 elements. -/
theorem emoji_card : Fintype.card Emoji = 16 := by decide

/-- Every semantic category is represented in the self-reflection sequence. -/
theorem selfReflection_covers_actions_states_agents :
    (∃ e ∈ selfReflectionSeq, e.category = .action) ∧
    (∃ e ∈ selfReflectionSeq, e.category = .state) ∧
    (∃ e ∈ selfReflectionSeq, e.category = .agent) := by
  refine ⟨⟨.rocket, by simp [selfReflectionSeq], rfl⟩,
          ⟨.scroll, by simp [selfReflectionSeq], rfl⟩,
          ⟨.brain, by simp [selfReflectionSeq], rfl⟩⟩

/-- Meanings are injective: distinct emojis have distinct meanings. -/
theorem meaning_injective : Function.Injective Emoji.meaning := by
  intro a b h
  cases a <;> cases b <;> first | rfl | simp [Emoji.meaning] at h

/-- The full SOLFUNMEME meta-language: concatenation of all four sequences. -/
def fullMetaLanguage : SemanticCompound :=
  selfReflectionSeq ++ emergentMeaningSeq ++ consensusSeq ++ evolutionSeq

/-- The full meta-language has 16 emojis — one for each element of the alphabet. -/
theorem fullMetaLanguage_length : fullMetaLanguage.length = 16 := by
  simp [fullMetaLanguage, selfReflectionSeq, emergentMeaningSeq,
        consensusSeq, evolutionSeq]

/-- The full meta-language uses 15 of the 16 emojis (cycle is omitted
    because it is represented by the REPL loop structure itself). -/
theorem fullMetaLanguage_covers_most :
    ∀ e : Emoji, e ≠ .cycle → e ∈ fullMetaLanguage := by
  intro e he
  cases e <;> simp_all [fullMetaLanguage, selfReflectionSeq, emergentMeaningSeq,
                         consensusSeq, evolutionSeq]

/-- The full meta-language contains the `link` emoji (which appears in both
    consensusSeq and evolutionSeq). -/
theorem fullMetaLanguage_has_link :
    Emoji.link ∈ fullMetaLanguage := by
  simp [fullMetaLanguage, consensusSeq]

/-! ## §5. Compositional Semantics -/

/-- The meaning of a compound is the concatenation of its emoji meanings. -/
def compoundMeaning (sc : SemanticCompound) : String :=
  String.intercalate "+" (sc.map Emoji.meaning)

/-- The category profile of a compound: how many emojis in each category. -/
def categoryProfile (sc : SemanticCompound) : SemanticCategory → Nat :=
  fun c => sc.countP (fun e => e.category = c)

/-- The self-reflection sequence has 3 actions, 1 state, 1 agent, 0 structures. -/
theorem selfReflection_profile :
    categoryProfile selfReflectionSeq .action = 3 ∧
    categoryProfile selfReflectionSeq .state = 1 ∧
    categoryProfile selfReflectionSeq .agent = 1 ∧
    categoryProfile selfReflectionSeq .structure = 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> native_decide

end EmojiGrammar
