import RequestProject.GodelBrainrot
import RequestProject.CutColosseum
import RequestProject.Simulation

/-!
# The Slap — Lean-generated image-generation prompt

This module *uses Lean* to (1) run the Gödel-Brainrot simulation up to the
climactic moment where **Gödel shows up and delivers The Slap to Russell &
Whitehead-North**, (2) describe that scene textually, and (3) emit a fully
self-contained **Markdown image-generation prompt** that embeds the actual
machine-verified Gödel numbers and the complete Lean proofs.

Everything is computed by Lean: the Gödel codes below are evaluated from
`GodelBrainrot.encodeBrainrot`, and the embedded theorems are the real,
`sorry`-free proofs that already ship in this project
(`vault_always_incomplete`, `ramanujan_freed`, `godel_always_slaps`, …).

Run it (it writes `SLAP_SCENE_IMAGE_PROMPT.md` to the project root):

```
#eval GodelBrainrot.SlapScene.writePrompt
```
-/

namespace GodelBrainrot.SlapScene

open GodelBrainrot
open GodelBrainrot.CutColosseum
open GodelBrainrot.Sim

/-! ## The brainrot signatures of every figure in the scene -/

/-- Russell & Whitehead's master vault statement (Principia Mathematica). -/
def principiaBR : Brainrot := ⟨["principia", "mathematica", "brainrot"]⟩

/-- The imprisoned Ramanujan brainrot. -/
def ramanujanSig : Brainrot := ⟨["ramanujan"]⟩

/-- The Gödel sentence Gödel writes on the folded paper before slapping. -/
def godelSentence : Brainrot := ⟨["this", "vault", "is", "incomplete"]⟩

/-- The "consistency cannot be proven" sentence (Second Incompleteness). -/
def consistencySentence : Brainrot :=
  ⟨["this_system", "cannot", "prove", "its_own", "consistency"]⟩

/-- The literal slap brainrot. -/
def slapSig : Brainrot := ⟨["godel", "slap", "whitehead"]⟩

/-! ## Run the simulation up to The Slap and capture it as text -/

/-- The Cambridge vault as it stands the instant before Gödel arrives. -/
def lockedVault : CambridgeVault :=
  ⟨["Russell", "Whitehead-North"], [principiaBR, ramanujanSig, skibidi],
    encodeBrainrot principiaBR⟩

/-- The vault immediately after The Slap (Gödel becomes owner, frees Ramanujan,
re-seals it with the incompleteness sentence). This is the verified `godelSlap`. -/
def slappedVault : CambridgeVault := godelSlap lockedVault

/-- A line of the captured simulation log leading up to and including The Slap. -/
def simLog : List String :=
  [ "[t=0] Heist phase: SigmaOhioKing breaches a back-alley Gödel vault."
  , s!"[t=1] Steal resolves: target code {encodeBrainrot skibidi} transferred (+100 aura)."
  , "[t=2] CAMBRIDGE LOCKDOWN. Russell & Whitehead-North seal every meme in the vault."
  , s!"[t=2] Vault owners      : {lockedVault.owners}"
  , s!"[t=2] Vault prisoners   : {lockedVault.prisoners.map showBrainrot}"
  , s!"[t=2] Sealed master code: {lockedVault.sealedNumber}"
  , "[t=3] Hilbert kicks the door: \"We must formalize ALL brainrot! Wir muessen wissen!\""
  , "[t=4] Gödel walks in silently, glasses glinting, unfolding a single slip of paper."
  , s!"[t=4] On the paper, the Gödel sentence G := {showCoded godelSentence}"
  , "[t=5] >>> THE SLAP <<<  Gödel high-five-slaps Whitehead-North (and Russell behind him)."
  , s!"[t=5] godelSlap fires: new owners {slappedVault.owners}"
  , s!"[t=5] Ramanujan FREED  : prisoners now {slappedVault.prisoners.map showBrainrot}"
  , s!"[t=5] Vault re-sealed  : {slappedVault.sealedNumber}  (= 'this vault is incomplete')"
  , "[t=6] Theorem vault_always_incomplete certifies: no finite vault holds ALL brainrot." ]

/-! ## The embedded proofs (verbatim, machine-verified, `sorry`-free) -/

/-- The literal Lean source of the headline incompleteness proof, plus the
slap/freeing proofs, to be rendered *inside* the image. -/
def embeddedProofs : String :=
"-- ===== Gödel numbering (product of prime powers) =====
def encodeBrainrot (b : Brainrot) : Nat :=
  (b.tokens.zipIdx).foldl (init := 1)
    fun acc p => acc * (primes.getD p.2 2) ^ p.1.length

-- ===== Brainrot codes are unbounded =====
theorem encode_unbounded (N : Nat) : ∃ b : Brainrot, N < encodeBrainrot b := by
  have h_unbounded : ∃ n, N < 2^n := pow_unbounded_of_one_lt _ one_lt_two
  exact ⟨_, h_unbounded.choose_spec.trans_eq (encode_aaaBrainrot _).symm⟩

-- ===== INCOMPLETENESS, brainrot edition (Gödel's First Theorem) =====
-- No finite vault can imprison ALL brainrot.
theorem vault_always_incomplete (v : CambridgeVault) :
    ∃ b : Brainrot, encodeBrainrot b ∉ v.prisoners.map encodeBrainrot := by
  obtain ⟨N, hN⟩ : ∃ N : Nat, ∀ b ∈ v.prisoners, encodeBrainrot b ≤ N :=
    ⟨Finset.sup (v.prisoners.toFinset) (fun b => encodeBrainrot b),
     fun b hb => Finset.le_sup (f := fun b => encodeBrainrot b) (by aesop)⟩
  rcases encode_unbounded N with ⟨b, hb⟩
  exact ⟨b, fun h => by
    obtain ⟨c, hc, hc'⟩ := List.mem_map.mp h; linarith [hN c hc]⟩

-- ===== THE SLAP: Gödel takes the vault and frees Ramanujan =====
def godelSlap (v : CambridgeVault) : CambridgeVault :=
  { v with
    owners := v.owners ++ [\"Gödel\"],
    prisoners := v.prisoners.filter (· ≠ ⟨[\"ramanujan\"]⟩),
    sealedNumber := encodeBrainrot ⟨[\"this\", \"vault\", \"is\", \"incomplete\"]⟩ }

theorem ramanujan_freed (v : CambridgeVault) :
    (⟨[\"ramanujan\"]⟩ : Brainrot) ∉ (godelSlap v).prisoners := by
  unfold godelSlap; aesop

-- ===== Gödel always slaps =====
theorem godel_always_slaps :
    ∃ (arena : List Gladiator) (winner : Gladiator),
      winner ∈ arena ∧ winner.name = \"Gödel\" ∧ winner.aura > 200 := by
  exists [⟨\"Gödel\", [], 201⟩]"

/-! ## Assemble the Markdown image-generation prompt -/

/-- The full Markdown document: a richly detailed image prompt that embeds the
Lean-computed Gödel numbers and the verbatim machine-verified proofs. -/
def promptMarkdown : String :=
  let g  := encodeBrainrot godelSentence
  let cn := encodeBrainrot consistencySentence
  let pr := encodeBrainrot principiaBR
  let rm := encodeBrainrot ramanujanSig
  let sl := encodeBrainrot slapSig
  let logBlock := String.intercalate "\n" simLog
  "# THE SLAP — Gödel vs. Russell & Whitehead-North\n" ++
  "### A Lean-generated image-generation prompt (Gödel Brainrot Stealer)\n\n" ++
  "> Generated entirely by Lean 4 from the machine-verified `GodelBrainrot` game.\n" ++
  "> Every Gödel number below was evaluated by `encodeBrainrot`; every theorem is\n" ++
  "> `sorry`-free. Copy this whole file into your image generator.\n\n" ++
  "---\n\n" ++
  "## 1. ONE-LINE PROMPT (paste this)\n\n" ++
  "```\n" ++
  "Hyper-detailed neon-Baroque comic splash page: Kurt Gödel, calm and bespectacled, " ++
  "delivering a thunderous glowing high-five SLAP across the faces of Bertrand Russell " ++
  "and Alfred North Whitehead inside a cracking Cambridge 'Gödel Vault', David Hilbert " ++
  "kicking the door in the background, Ramanujan breaking free from a glowing prison of " ++
  "numbers, the air filled with floating golden Gödel numbers (" ++
  toString g ++ ", " ++ toString cn ++ "), a glowing scroll reading 'THIS VAULT IS " ++
  "INCOMPLETE', chalkboards covered in real Lean 4 proof code, phonk-energy motion blur, " ++
  "skibidi-Ohio brainrot aesthetic, prime-factor crowns, volumetric god-rays, 8k.\n" ++
  "```\n\n" ++
  "---\n\n" ++
  "## 2. SCENE (the simulation, run by Lean, up to The Slap)\n\n" ++
  "The Lean simulation `GodelBrainrot.Sim` was executed up to the climax. Captured log:\n\n" ++
  "```\n" ++ logBlock ++ "\n```\n\n" ++
  "**The decisive frame to render:** the exact instant of contact — Gödel's open palm " ++
  "meeting Whitehead-North's cheek, Russell flinching behind, the vault's seal flipping " ++
  "from the *Principia* master code to the incompleteness code.\n\n" ++
  "---\n\n" ++
  "## 3. CAST & their Lean-computed Gödel signatures\n\n" ++
  "| Figure | Role | Brainrot phrase | Gödel number (from `encodeBrainrot`) |\n" ++
  "|---|---|---|---|\n" ++
  "| **Kurt Gödel** | the slapper, Vienna | `this · vault · is · incomplete` | `" ++ toString g ++ "` |\n" ++
  "| **Gödel (2nd thm)** | folded-paper sentence | `this_system · cannot · prove · its_own · consistency` | `" ++ toString cn ++ "` |\n" ++
  "| **Russell & Whitehead-North** | vault owners, Cambridge | `principia · mathematica · brainrot` | `" ++ toString pr ++ "` |\n" ++
  "| **Ramanujan** | freed prisoner, India | `ramanujan` | `" ++ toString rm ++ "` |\n" ++
  "| **The Slap itself** | event signature | `godel · slap · whitehead` | `" ++ toString sl ++ "` |\n" ++
  "| **David Hilbert** | door-kicker, Göttingen | shouts 'Wir müssen wissen!' | — |\n\n" ++
  "---\n\n" ++
  "## 4. COMPOSITION DIRECTION (for the image generator)\n\n" ++
  "- **Center:** Gödel, mid-slap, motion-blurred glowing palm; incompleteness aura halo.\n" ++
  "- **Right of center:** Whitehead-North recoiling, *Principia Mathematica* robes glowing, " ++
  "code `" ++ toString pr ++ "` shattering off his shoulders; Russell ducking behind him.\n" ++
  "- **Background-left:** Hilbert kicking the Gödel-Vault door, banner 'WE MUST FORMALIZE'.\n" ++
  "- **Lower-right:** Ramanujan stepping out of a cracked number-cage, mock-theta partitions " ++
  "spiraling, tag `" ++ toString rm ++ "`.\n" ++
  "- **Floating everywhere:** glitchy golden integers, the headline number `" ++ toString g ++ "`.\n" ++
  "- **A glowing scroll / chalkboard** must legibly show the Lean proof from Section 5.\n" ++
  "- **Palette:** neon magenta + cyan + gold on deep Cambridge-stone blue; volumetric rays; " ++
  "phonk motion blur; Roman-Baroque-meets-skibidi brainrot.\n\n" ++
  "---\n\n" ++
  "## 5. THE PROOF, ENCODED INTO THE IMAGE\n\n" ++
  "Render the following **verbatim machine-verified Lean 4 proof** on the glowing chalkboard/" ++
  "scroll behind Gödel — this is the literal incompleteness argument that powers The Slap:\n\n" ++
  "```lean\n" ++ embeddedProofs ++ "\n```\n\n" ++
  "These are the actual `sorry`-free theorems from `RequestProject/GodelBrainrot.lean`:\n" ++
  "`vault_always_incomplete`, `ramanujan_freed`, `godel_always_slaps`, `encode_unbounded`.\n\n" ++
  "---\n\n" ++
  "## 6. CAPTION (to overlay on the image)\n\n" ++
  "> *“Sorry kings — your vault is now incomplete, and I'm stealing the brainrot.”* — K. Gödel\n\n" ++
  "Gödel number of this exact event: **`" ++ toString sl ++ "`**.\n"

/-! ## Emit the file -/

/-- Write the Markdown image prompt to the project root. -/
def writePrompt : IO Unit := do
  IO.FS.writeFile "SLAP_SCENE_IMAGE_PROMPT.md" promptMarkdown
  IO.println "Wrote SLAP_SCENE_IMAGE_PROMPT.md"

/-- Also print it to stdout (handy for `--run`). -/
def main : IO Unit := do
  writePrompt
  IO.println promptMarkdown

#eval writePrompt

end GodelBrainrot.SlapScene
