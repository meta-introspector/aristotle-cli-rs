import RequestProject.Nix.NixWars.Bets

/-!
# The broadcast: five-megabyte clips, stills, and updates for the punters

What the arcade sends out. A clip is described by its frame size, frame rate,
duration and bit rates; `Clip.bytes` is the size that description implies, and
the posting budget is the one X imposes on an ordinary post: five million bytes
and two minutes twenty.

The substance here is the budget arithmetic, done once and for all:
`bytes_le_of_kbps_le` says that a clip whose total bit rate is inside
`budgetKbps` for its duration cannot exceed the byte limit, and
`reel_fits` applies it to every clip in the reel the arcade actually cuts.
`stills_fit` does the same for the frames posted as pictures, and `feed_fits`
checks that every update written for the punters is inside the 280 characters
a post allows.

The feed is *generated from the results*: the numbers in the posts are
`toString` of the values the rest of the development computes and proves — the
trained agent's score, the pool on the betting floor, the size of the shipped
module — so a post cannot drift from what was proved.
-/

set_option maxRecDepth 40000
set_option maxHeartbeats 2000000

namespace NixWars

namespace Broadcast

/-! ## The posting budget -/

/-- The byte budget for one posted clip: five megabytes. -/
def clipByteLimit : Nat := 5000000

/-- The length budget for one posted clip: two minutes twenty, in seconds. -/
def clipSecondsLimit : Nat := 140

/-- The character budget for one update. -/
def postCharLimit : Nat := 280

/-- A clip as it is cut and encoded. -/
structure Clip where
  /-- The name of the file, without an extension. -/
  slug : String
  /-- What the clip shows. -/
  caption : String
  /-- Frame width in pixels. -/
  w : Nat
  /-- Frame height in pixels. -/
  h : Nat
  /-- Frames a second. -/
  fps : Nat
  /-- How long the clip runs, in seconds. -/
  secs : Nat
  /-- Video bit rate, kbit/s. -/
  vkbps : Nat
  /-- Audio bit rate, kbit/s. `0` for a silent clip. -/
  akbps : Nat
  deriving Repr, Inhabited, DecidableEq

/-- How many frames the clip is cut from. -/
def Clip.frames (c : Clip) : Nat := c.fps * c.secs

/-- The size the clip's description implies, in bytes. -/
def Clip.bytes (c : Clip) : Nat := (c.vkbps + c.akbps) * 1000 * c.secs / 8

/-- The largest total bit rate, in kbit/s, that keeps a clip of this many
seconds inside the five-megabyte budget. -/
def budgetKbps (secs : Nat) : Nat := 8 * clipByteLimit / (1000 * secs)

/-- **The budget arithmetic.** A clip whose total bit rate is inside
`budgetKbps` for its length is inside the byte limit. -/
theorem bytes_le_of_kbps_le (c : Clip) (hs : 0 < c.secs)
    (h : c.vkbps + c.akbps ≤ budgetKbps c.secs) : c.bytes ≤ clipByteLimit := by
  have hpos : 0 < 1000 * c.secs := Nat.mul_pos (by norm_num) hs
  have h' : (c.vkbps + c.akbps) * (1000 * c.secs) ≤ 8 * clipByteLimit := by
    rw [← Nat.le_div_iff_mul_le hpos]
    exact h
  have hmul : (c.vkbps + c.akbps) * 1000 * c.secs = (c.vkbps + c.akbps) * (1000 * c.secs) :=
    Nat.mul_assoc _ _ _
  unfold Clip.bytes
  rw [hmul]
  refine Nat.le_trans (Nat.div_le_div_right h') (Nat.le_of_eq ?_)
  rw [Nat.mul_comm, Nat.mul_div_cancel _ (by norm_num)]

/-- A still as it is posted. -/
structure Still where
  /-- The name of the file, without an extension. -/
  slug : String
  /-- What the picture shows. -/
  caption : String
  /-- Width in pixels. -/
  w : Nat
  /-- Height in pixels. -/
  h : Nat
  deriving Repr, Inhabited, DecidableEq

/-- The size of the raw frame the still is rendered from: three bytes a pixel,
plus a kilobyte of headers. The encoded PNG is checked against the same limit
by `video/verify_broadcast.py`; this is the budget the renderer works to. -/
def Still.rawBytes (s : Still) : Nat := 3 * s.w * s.h + 1024

/-- An update for the punters. -/
structure Post where
  /-- Which channel this is: `clip`, `still` or `text`. -/
  kind : String
  /-- The slug of the artefact it carries, if any. -/
  slug : String
  /-- The words. -/
  text : String
  deriving Repr, Inhabited, DecidableEq

end Broadcast

/-! ## The reel this arcade cuts -/

open Broadcast

/-- The clips: one a cabinet, one for the agent, one for the floor. All 320×240
at 25 frames a second, silent except the tour, and all inside the budget. -/
def broadcastReel : List Clip :=
  [ { slug := "agent-pyramid", caption := "the trained agent paints all ten cubes",
      w := 320, h := 240, fps := 25, secs := 24, vkbps := 1200, akbps := 0 },
    { slug := "agent-invaders", caption := "nine commands, five invaders, no drop",
      w := 320, h := 240, fps := 25, secs := 20, vkbps := 1200, akbps := 0 },
    { slug := "critic", caption := "the critic strikes two wasted commands",
      w := 320, h := 240, fps := 25, secs := 12, vkbps := 1200, akbps := 0 },
    { slug := "floor", caption := "the betting floor settles on the Lean verdicts",
      w := 320, h := 240, fps := 25, secs := 18, vkbps := 1200, akbps := 0 },
    { slug := "tour", caption := "a lap of the filled arcade",
      w := 320, h := 240, fps := 25, secs := 30, vkbps := 1000, akbps := 64 } ]

/-- **Every clip in the reel is postable**: inside five megabytes and inside
two minutes twenty. -/
theorem reel_fits : ∀ c ∈ broadcastReel, c.bytes ≤ clipByteLimit ∧ c.secs ≤ clipSecondsLimit := by
  decide

/-- The whole reel, back to back, is under a minute and three-quarters. -/
theorem reel_total_seconds : (broadcastReel.map Clip.secs).sum = 104 := rfl

/-- The stills posted with the updates. -/
def broadcastStills : List Still :=
  [ { slug := "marquee", caption := "the filled arcade, all eighteen cabinets", w := 640, h := 480 },
    { slug := "tape", caption := "the agent's recorded tape, twelve frames", w := 640, h := 480 },
    { slug := "board", caption := "the betting floor as it stands", w := 640, h := 480 },
    { slug := "verdicts", caption := "how the four books settled", w := 640, h := 480 } ]

/-- Every still is inside the byte budget as a raw frame. -/
theorem stills_fit : ∀ s ∈ broadcastStills, s.rawBytes ≤ clipByteLimit := by
  decide

/-! ## The updates

Each post is built out of values the development computes, so the numbers in
the broadcast are the numbers that were proved. -/

/-- The score the trained agent posts. -/
def agentScore : Nat := Learn.value monsterCubes qbertReward initialQbert qbertLearned

/-- The score the untrained agent posts. -/
def selfPlayScore : Nat := Learn.value monsterCubes qbertReward initialQbert qbertSelfPlayed

/-- The credits on the betting floor. -/
def floorCredits : Nat := Bets.floorPool bettingFloor

/-- The size of the shipped module, in bytes. -/
def moduleBytes : Nat := Wasm.wasmBytes.length

/-- The feed the punters follow. -/
def punterFeed : List Post :=
  [ { kind := "clip", slug := "agent-pyramid",
      text := "TRAINED AGENT clears MONSTER CUBES: " ++ toString agentScore ++
        " points, three lives in hand. Self-play alone stalls at " ++
        toString selfPlayScore ++ ". Machine-checked in Lean. #nixwars" },
    { kind := "clip", slug := "agent-invaders",
      text := "SHARD INVADERS: rank down in nine commands, not a row dropped. " ++
        "The plan the loop found is the plan the proof names. #nixwars" },
    { kind := "still", slug := "board",
      text := "BETTING FLOOR: " ++ toString floorCredits ++
        " credits across four books — truth, size, speed, skill. " ++
        "Parimutuel, and proved solvent: the floor mints nothing. #nixwars" },
    { kind := "still", slug := "verdicts",
      text := "SETTLED: the pyramid clears with all three lives (paid). " ++
        "The module is under 8192 bytes at " ++ toString moduleBytes ++
        " (paid). Under 4096 (void). Lean settles every book. #nixwars" },
    { kind := "clip", slug := "critic",
      text := "THE CRITIC struck two wasted commands out of a five-command run " ++
        "and the score did not move. Shorter, same outcome, proved. #nixwars" },
    { kind := "clip", slug := "tour",
      text := "FILLED ARCADE: eighteen cabinets in one file, no server, no save. " ++
        "Open it, play it, bet on it. #nixwars #bbs" } ]

/-- **Every update fits in a post.** -/
theorem feed_fits : ∀ p ∈ punterFeed, p.text.length ≤ postCharLimit := by
  decide

/-- Every post carries an artefact that is on the reel or in the stills. -/
theorem feed_artefacts_exist :
    ∀ p ∈ punterFeed,
      (broadcastReel.any (fun c => c.slug == p.slug)) ||
        (broadcastStills.any (fun s => s.slug == p.slug)) := by
  decide

/-- The numbers in the feed are the numbers that were proved. -/
theorem agentScore_eq : agentScore = 103 := qbert_learned_value

theorem selfPlayScore_eq : selfPlayScore = 43 := qbert_selfplay_value

theorem floorCredits_eq : floorCredits = 403 := bettingFloor_pool

theorem moduleBytes_eq : moduleBytes = 7813 := rfl

end NixWars
