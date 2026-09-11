import RequestProject.Nix.NixWars.Game

/-!
# Stateless sessions

A BBS session is a player, a shard, a game and that game's state. The BBS keeps
no state of its own: the whole session rides on the wire -- in a URL fragment,
in a SLIP or PPP frame, in morse, or read out by a numbers station -- and is
picked up again at the other end.

Sessions are generic in the game (`GameSession g`), because the board runs many
doors; `Session` is the NixWars instance that the single-page app uses.

The two theorems that make statelessness legitimate are

* `receive_transmit`: whatever the game and whatever the transport, a session
  comes back intact;
* `runOverWire_eq`: playing while serializing the state after *every* command
  gives exactly the same result as playing locally.

Together they say the "modem coupler between two browser tabs" is invisible to
the game.
-/

namespace NixWars

/-- A stateless BBS session for the door game `g`. -/
structure GameSession (g : DoorGame) where
  /-- Digest of the player's public key. -/
  user : Nat
  /-- Which of the 71 shards the player is on. -/
  shard : Nat
  /-- Which door game is being played. -/
  game : Nat
  /-- The state of that game. -/
  state : g.State

variable {g : DoorGame} {X : Type}

/-- A session as a payload. -/
def gsSerialize (s : GameSession g) : List Nat :=
  s.user :: s.shard :: s.game :: g.serialize s.state

/-- Reading a session back from a payload. -/
def gsDeserialize (g : DoorGame) : List Nat → Option (GameSession g)
  | user :: shard :: game :: rest =>
    (g.deserialize rest).map (fun st =>
      { user := user, shard := shard, game := game, state := st })
  | _ => none

theorem gsDeserialize_gsSerialize (s : GameSession g) :
    gsDeserialize g (gsSerialize s) = some s := by
  cases s with
  | mk user shard game state =>
    simp [gsSerialize, gsDeserialize, g.deserialize_serialize]

/-- Sessions as payloads. -/
def sessionCodec (g : DoorGame) : Codec (GameSession g) (List Nat) where
  encode := gsSerialize
  decode := gsDeserialize g
  decode_encode := gsDeserialize_gsSerialize

/-! ## Sending a session over an arbitrary transport -/

/-- Put a session on the wire. -/
def transmit (t : Codec (List Nat) X) (s : GameSession g) : X := t.encode (gsSerialize s)

/-- Take a session off the wire. -/
def receive (g : DoorGame) (t : Codec (List Nat) X) (x : X) : Option (GameSession g) :=
  (t.decode x).bind (gsDeserialize g)

/-- **The session survives the wire**, whichever game and whichever wire. -/
theorem receive_transmit (t : Codec (List Nat) X) (s : GameSession g) :
    receive g t (transmit t s) = some s := by
  simp [receive, transmit, t.decode_encode, gsDeserialize_gsSerialize]

/-- **Two tabs holding the same transmission hold the same session.** -/
theorem transmit_injective (t : Codec (List Nat) X) {s₁ s₂ : GameSession g}
    (h : transmit t s₁ = transmit t s₂) : s₁ = s₂ := by
  have h₁ : receive g t (transmit t s₁) = receive g t (transmit t s₂) := by rw [h]
  rw [receive_transmit, receive_transmit] at h₁
  exact Option.some.inj h₁

/-! ## Playing over the wire -/

/-- One command, applied to a session that is only ever held in transmitted
form: decode, step, re-encode. -/
def stepOverWire (t : Codec (List Nat) X) (x : X) (c : g.Cmd) : Option X :=
  (receive g t x).map (fun s => transmit t { s with state := g.step s.state c })

/-- A whole session played this way. -/
def runOverWire (t : Codec (List Nat) X) (x : X) : List g.Cmd → Option X
  | [] => some x
  | c :: cs => (stepOverWire t x c).bind (fun x' => runOverWire t x' cs)

/-- **Statelessness.** Serializing the state after every single command --
which is what a URL-fragment BBS, a SLIP link or a morse operator actually
does -- changes nothing about the game. -/
theorem runOverWire_eq (t : Codec (List Nat) X) (s : GameSession g) (cs : List g.Cmd) :
    runOverWire t (transmit t s) cs
      = some (transmit t { s with state := g.run s.state cs }) := by
  induction cs generalizing s with
  | nil => rfl
  | cons c cs ih =>
    have hstep : stepOverWire t (transmit t s) c
        = some (transmit t { s with state := g.step s.state c }) := by
      simp [stepOverWire, receive_transmit]
    simp only [runOverWire, hstep, Option.bind_some]
    exact ih { s with state := g.step s.state c }

/-- The player, the shard and the game are never disturbed by play. -/
theorem runOverWire_preserves_identity (t : Codec (List Nat) X) (s : GameSession g)
    (cs : List g.Cmd) :
    (runOverWire t (transmit t s) cs).bind (receive g t)
      = some { s with state := g.run s.state cs } := by
  rw [runOverWire_eq]
  simp [receive_transmit]

/-! ## The NixWars session and the concrete wires

Every transport is an instance of the theorems above; these are the
specializations a browser tab actually uses. -/

/-- The session type of the flagship door. -/
abbrev Session := GameSession nixWars

/-- The NixWars session as a payload. -/
def sessionSerialize (s : Session) : List Nat := gsSerialize s

/-- A session as a shareable URL. -/
def sessionUrl (s : Session) : String := transmit urlTransport s

/-- A session read back from a URL. -/
def sessionOfUrl (u : String) : Option Session := receive nixWars urlTransport u

theorem sessionOfUrl_sessionUrl (s : Session) : sessionOfUrl (sessionUrl s) = some s :=
  receive_transmit urlTransport s

/-- A session as a SLIP frame on the audio coupler. -/
def sessionSlip (s : Session) : List UInt8 := transmit slipTransport s

theorem sessionSlip_roundtrip (s : Session) :
    receive nixWars slipTransport (sessionSlip s) = some s :=
  receive_transmit slipTransport s

/-- A session as a PPP frame. -/
def sessionPpp (s : Session) : List UInt8 := transmit pppTransport s

theorem sessionPpp_roundtrip (s : Session) :
    receive nixWars pppTransport (sessionPpp s) = some s :=
  receive_transmit pppTransport s

/-- A session keyed out in morse. -/
def sessionMorse (s : Session) : List MorseSym := transmit morseTransport s

theorem sessionMorse_roundtrip (s : Session) :
    receive nixWars morseTransport (sessionMorse s) = some s :=
  receive_transmit morseTransport s

/-- A session read out by a numbers station. -/
def sessionNumbers (s : Session) : String := transmit numbersTransport s

theorem sessionNumbers_roundtrip (s : Session) :
    receive nixWars numbersTransport (sessionNumbers s) = some s :=
  receive_transmit numbersTransport s

/-- A session read out by a numbers station under a one-time pad. -/
def sessionPadded (key : List (Sym 9)) (s : Session) : String :=
  transmit (paddedNumbersTransport key) s

theorem sessionPadded_roundtrip (key : List (Sym 9)) (s : Session) :
    receive nixWars (paddedNumbersTransport key) (sessionPadded key s) = some s :=
  receive_transmit (paddedNumbersTransport key) s

/-- Playing NixWars entirely through URL fragments -- the single-page,
serverless BBS -- agrees with playing it locally. -/
theorem url_play_eq (s : Session) (cs : List nixWars.Cmd) :
    runOverWire (g := nixWars) urlTransport (sessionUrl s) cs
      = some (sessionUrl { s with state := nixWars.run s.state cs }) :=
  runOverWire_eq urlTransport s cs

end NixWars
