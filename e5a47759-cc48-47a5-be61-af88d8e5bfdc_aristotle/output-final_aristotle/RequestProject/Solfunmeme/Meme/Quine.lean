import RequestProject.Solfunmeme.Meme.Engine
import RequestProject.Solfunmeme.Meme.Commit
import RequestProject.Relay.Commit
import RequestProject.Relay.Templates

/-!
# Every quine is a meme

SOLFUNMEME's engine mints *memes*: minted objects a play-through pays for, and
whose provenance is a rolling commitment to the tape that produced them
(`Meme.Engine`).  The relay's twenty-two programs are exactly that kind of
object: each is a self-reproducing artefact, each stands for one of the six
merged developments, and — the point of this file — all twenty-two commit to
one and the same payload.

So the relay is read here as a collection of memes.

* `quineMemes` is the collection: one meme per stage, carrying its language,
  its file, and the development it stands for.
* `quineMemes_files_nodup` — they are twenty-two *different* memes.
* `quineMemes_cover` — between them they name all six developments.
* `memes_share_commitment` — and yet every one of them commits to the same
  payload: one bundle, twenty-two faces.  This is what makes the collection a
  single mintable thing rather than twenty-two unrelated ones.
* `mint_all_quines` / `mint_unlocks_memeLord` — minting the whole collection is
  a legal play-through of the game engine: forty-four inputs, twenty-two memes,
  and the `memeLord` badge, verified by replay (`mintClaim_verify`).

Nothing in the game engine had to change to accommodate this; the relay simply
supplies twenty-two things worth minting.
-/

namespace Meme.Quine

open RequestProject.Relay

/-! ## The memes -/

/-- One quine of the relay, seen as a meme: which stage it is, the file it
lives in, the language it is written in, and the development it stands for. -/
structure QuineMeme where
  /-- Position in the relay. -/
  stage : Nat
  /-- The file the generator writes it to. -/
  file : String
  /-- The language it is written in. -/
  language : String
  /-- The merged development it stands for. -/
  project : String
  deriving DecidableEq, Repr, Inhabited

/-- The meme of stage `i`. -/
def memeOf (i : Nat) : QuineMeme := ⟨i, fileName i, language i, project i⟩

/-- The twenty-two memes of the relay, in ring order. -/
def quineMemes : List QuineMeme := (List.range 22).map memeOf

/-- The collection has one meme per stage. -/
theorem quineMemes_length : quineMemes.length = 22 := by decide

/-- Stage numbers are recovered from the memes. -/
theorem memeOf_stage (i : Nat) : (memeOf i).stage = i := rfl

/-- **They are twenty-two different memes**: no two share a file. -/
theorem quineMemes_files_nodup : (quineMemes.map (·.file)).Nodup := by decide

/-- The six merged developments. -/
def developments : List String :=
  ["RequestProject.Solfunmeme", "RequestProject.Edge", "RequestProject.Nix",
   "RequestProject.Gvcs", "RequestProject.Motion", "RequestProject.Craft"]

/-- **The collection covers the whole repository**: every merged development is
represented by at least one meme. -/
theorem quineMemes_cover : ∀ d ∈ developments, d ∈ quineMemes.map (·.project) := by decide

/-- What a stage may stand for: one of the six developments, or the relay model
itself (the Lean stage, which hosts the relay's own theory). -/
def hosts : List String := developments ++ ["RequestProject.Relay"]

/-- Every meme stands for one of those and nothing else. -/
theorem quineMemes_projects_valid : ∀ m ∈ quineMemes, m.project ∈ hosts := by decide

/-! ## One bundle, twenty-two faces -/

/-- The commitment a meme makes: the commitment of the program of its stage. -/
def memeCommitment (m : QuineMeme) : Option Nat := commitment (stages.prog m.stage)

/-- **Every meme commits to the same payload.**  The twenty-two memes are
twenty-two renderings of one bundle, not twenty-two different things: whatever
notation a stage writes the payload in, the commitment it makes is the same. -/
theorem memes_share_commitment (m m' : QuineMeme) :
    memeCommitment m = memeCommitment m' :=
  Relay.commitment_eq stages_wf m.stage m'.stage

/-- The payload of any meme can be opened in full: possession is not merely
claimed. -/
theorem meme_opens (m : QuineMeme) :
    openPayload (stages.prog m.stage) = some stages.digits :=
  Relay.openPayload_prog stages_wf m.stage

/-- Every meme answers every challenge about the bundle the same way. -/
theorem memes_respond_alike (m m' : QuineMeme) (k : Nat) :
    respond (stages.prog m.stage) k = respond (stages.prog m'.stage) k :=
  Relay.respond_eq stages_wf m.stage m'.stage k

/-! ## Minting the collection -/

open Meme.Engine

/-- The tape that mints the whole collection: for each meme, raise the mint fee
and mint. -/
def mintTape : List Input :=
  quineMemes.flatMap fun _ => [Input.steal mintCost, Input.mint]

/-- Forty-four inputs: two per meme. -/
theorem mintTape_length : mintTape.length = 44 := by decide

/-- The state the collection is minted into. -/
def minted : State := run (start 0) mintTape

/-- **Minting the relay is a legal play-through**: twenty-two memes come out. -/
theorem mint_all_quines : minted.memes = quineMemes.length := by decide

/-- Nothing is minted for free: the ledger balances, `mintCost` per meme. -/
theorem mint_spent : minted.spent = mintCost * quineMemes.length := by decide

/-- Nothing is left over. -/
theorem mint_brainrot : minted.brainrot = 0 := by decide

/-- **Minting the collection unlocks `memeLord`** — ten memes were needed and
the relay supplies twenty-two. -/
theorem mint_unlocks_memeLord : Badge.memeLord ∈ unlocked minted := by decide

/-- …and `firstMeme` with it. -/
theorem mint_unlocks_firstMeme : Badge.firstMeme ∈ unlocked minted := by decide

/-- The claim a player publishes for this play-through. -/
def mintClaim : Claim := ⟨0, mintTape, minted⟩

set_option maxRecDepth 8000 in
/-- **The claim verifies**: a client that replays the tape gets exactly this
state, commitment included. -/
theorem mintClaim_verify : mintClaim.verify = true := by decide

end Meme.Quine
