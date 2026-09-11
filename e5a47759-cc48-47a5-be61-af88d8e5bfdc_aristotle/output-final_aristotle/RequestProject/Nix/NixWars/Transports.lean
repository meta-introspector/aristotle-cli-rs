import RequestProject.Nix.NixWars.Codec

/-!
# Transports: the same payload over five different wires

A door-game state is a `List Nat` (see `RequestProject.NixWars.Session`).
This file wires that payload onto the physical layers the BBS actually uses
between two browser tabs:

* `urlTransport` -- a URL fragment (`#…`), the "stateless page" transport;
* `slipTransport` -- RFC 1055 SLIP framing over the audio modem coupler;
* `pppTransport` -- RFC 1662 async-HDLC (PPP) framing;
* `morseTransport` -- dots, dashes and gaps;
* `numbersTransport` -- a numbers-station broadcast of spoken digit groups.

Each one is a `Codec (List Nat) _`, so each one comes with the theorem that
what is received is exactly what was sent. The one-time "stego pad"
(`padCodec`) is a codec too, and composes with any of them.
-/

set_option maxRecDepth 100000

namespace NixWars

/-! ## Two generic wrappers -/

namespace Codec

variable {α X : Type} [DecidableEq X]

/-- Prepend a fixed header (a URL prefix, a leading PPP flag, a station call
sign) to every transmission. -/
def prefixed (c : Codec α (List X)) (p : List X) : Codec α (List X) where
  encode := fun a => p ++ c.encode a
  decode := fun l => if p.isPrefixOf l then c.decode (l.drop p.length) else none
  decode_encode := fun a => by
    have hp : p.isPrefixOf (p ++ c.encode a) = true := by simp
    simp [hp, c.decode_encode]

end Codec

/-- A character string is a `String`. -/
def stringCodec : Codec (List Char) String where
  encode := String.ofList
  decode := fun s => some s.toList
  decode_encode := fun cs => by rw [String.toList_ofList]

/-! ## The URL-fragment transport (radix 64) -/

/-- The URL-safe base-64 digits, followed by the field separator `'.'`. -/
def urlTable : List Char :=
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.".toList

theorem urlTable_length : urlTable.length = 64 + 1 := by decide

theorem urlTable_nodup : urlTable.Nodup := by decide

/-- Radix-64 symbols as URL-safe characters. -/
def urlSymCodec : Codec (Sym 64) Char := tableCodec urlTable urlTable_length urlTable_nodup

/-- The address of the BBS; the state rides in the fragment. -/
def urlPrefix : List Char := "https://bbs.8080.monster/nixwars#".toList

/-- **The stateless-page transport.** A game state travels as a single URL. -/
def urlTransport : Codec (List Nat) String :=
  (Codec.prefixed
      ((fieldsCodec 64 (by norm_num)).comp (Codec.onList urlSymCodec)) urlPrefix).comp
    stringCodec

theorem urlTransport_roundtrip (ns : List Nat) :
    urlTransport.decode (urlTransport.encode ns) = some ns :=
  urlTransport.decode_encode ns

/-! ## Byte transports: SLIP and PPP -/

/-- Radix-64 symbols as ASCII bytes. -/
def byteTable : List UInt8 := urlTable.map (fun c => UInt8.ofNat c.toNat)

theorem byteTable_length : byteTable.length = 64 + 1 := by decide

theorem byteTable_nodup : byteTable.Nodup := by decide

/-- Radix-64 symbols as bytes on the wire. -/
def byteSymCodec : Codec (Sym 64) UInt8 := tableCodec byteTable byteTable_length byteTable_nodup

/-- A game state as a raw byte string, before framing. -/
def bytePayload : Codec (List Nat) (List UInt8) :=
  (fieldsCodec 64 (by norm_num)).comp (Codec.onList byteSymCodec)

/-- A byte-stuffing frame format: one terminator byte, one escape byte and the
two codes that follow the escape. SLIP and PPP are both instances. -/
structure EscapeFraming where
  /-- Byte marking the end of a frame. -/
  term : UInt8
  /-- Escape byte. -/
  esc : UInt8
  /-- Code following the escape that stands for `term`. -/
  termCode : UInt8
  /-- Code following the escape that stands for `esc`. -/
  escCode : UInt8
  /-- The escape byte is not the terminator. -/
  esc_ne_term : esc ≠ term
  /-- The two escape codes are distinguishable. -/
  codes_ne : termCode ≠ escCode
  /-- An escaped terminator does not look like a terminator. -/
  termCode_ne_term : termCode ≠ term
  /-- An escaped escape does not look like a terminator. -/
  escCode_ne_term : escCode ≠ term

namespace EscapeFraming

/-- Byte stuffing: replace the two reserved bytes by escape sequences. -/
def escapeByte (F : EscapeFraming) (b : UInt8) : List UInt8 :=
  if b = F.term then [F.esc, F.termCode]
  else if b = F.esc then [F.esc, F.escCode]
  else [b]

/-- Stuff the payload and terminate the frame. -/
def frame (F : EscapeFraming) (bs : List UInt8) : List UInt8 :=
  bs.flatMap F.escapeByte ++ [F.term]

/-- Read one frame, undoing the byte stuffing. -/
def unframe (F : EscapeFraming) : List UInt8 → Option (List UInt8)
  | [] => none
  | b :: bs =>
    if b = F.term then (if bs.isEmpty then some [] else none)
    else if b = F.esc then
      match bs with
      | [] => none
      | e :: bs' =>
        if e = F.termCode then (unframe F bs').map (fun l => F.term :: l)
        else if e = F.escCode then (unframe F bs').map (fun l => F.esc :: l)
        else none
    else (unframe F bs).map (fun l => b :: l)

theorem unframe_frame (F : EscapeFraming) (bs : List UInt8) :
    F.unframe (F.frame bs) = some bs := by
  induction bs with
  | nil => simp [frame, unframe]
  | cons b bs ih =>
    have hstep : F.frame (b :: bs) = F.escapeByte b ++ F.frame bs := by
      simp [frame, List.flatMap_cons, List.append_assoc]
    rw [hstep]
    by_cases hb : b = F.term
    · subst hb
      simp [escapeByte, unframe, F.esc_ne_term, ih]
    · by_cases hb' : b = F.esc
      · subst hb'
        simp [escapeByte, unframe, hb, Ne.symm F.codes_ne, ih]
      · have he : F.escapeByte b = [b] := by simp [escapeByte, hb, hb']
        rw [he, List.singleton_append, unframe.eq_def]
        simp [hb, hb', ih]

/-- Byte stuffing removes every terminator from the payload. -/
theorem term_notMem_stuffed (F : EscapeFraming) (bs : List UInt8) :
    F.term ∉ bs.flatMap F.escapeByte := by
  induction bs with
  | nil => simp
  | cons b bs ih =>
    simp only [List.flatMap_cons, List.mem_append, not_or]
    refine ⟨?_, ih⟩
    by_cases hb : b = F.term
    · subst hb
      simp [escapeByte, Ne.symm F.termCode_ne_term, Ne.symm F.esc_ne_term]
    · by_cases hb' : b = F.esc
      · subst hb'
        simp [escapeByte, hb, Ne.symm F.esc_ne_term, Ne.symm F.escCode_ne_term]
      · simp [escapeByte, hb, hb', Ne.symm hb]

/-- **Frames are self-delimiting**: the terminator occurs exactly once, at the
very end, so a receiver reading a stream can always find the frame boundary. -/
theorem frame_self_delimiting (F : EscapeFraming) (bs : List UInt8) :
    ∃ body, F.frame bs = body ++ [F.term] ∧ F.term ∉ body :=
  ⟨bs.flatMap F.escapeByte, rfl, F.term_notMem_stuffed bs⟩

/-- Framing is a codec. -/
def codec (F : EscapeFraming) : Codec (List UInt8) (List UInt8) where
  encode := F.frame
  decode := F.unframe
  decode_encode := F.unframe_frame

end EscapeFraming

/-- RFC 1055 SLIP: `END = 0xC0`, `ESC = 0xDB`, `ESC_END = 0xDC`, `ESC_ESC = 0xDD`. -/
def slip : EscapeFraming where
  term := 0xC0
  esc := 0xDB
  termCode := 0xDC
  escCode := 0xDD
  esc_ne_term := by decide
  codes_ne := by decide
  termCode_ne_term := by decide
  escCode_ne_term := by decide

/-- RFC 1662 async HDLC (PPP): flag `0x7E`, escape `0x7D`, escaped bytes are
transmitted xor `0x20`. -/
def ppp : EscapeFraming where
  term := 0x7E
  esc := 0x7D
  termCode := 0x5E
  escCode := 0x5D
  esc_ne_term := by decide
  codes_ne := by decide
  termCode_ne_term := by decide
  escCode_ne_term := by decide

/-- **The SLIP transport.** -/
def slipTransport : Codec (List Nat) (List UInt8) := bytePayload.comp slip.codec

theorem slipTransport_roundtrip (ns : List Nat) :
    slipTransport.decode (slipTransport.encode ns) = some ns :=
  slipTransport.decode_encode ns

/-- **The PPP transport**: an async-HDLC frame, opening flag included. -/
def pppTransport : Codec (List Nat) (List UInt8) :=
  Codec.prefixed (bytePayload.comp ppp.codec) [ppp.term]

theorem pppTransport_roundtrip (ns : List Nat) :
    pppTransport.decode (pppTransport.encode ns) = some ns :=
  pppTransport.decode_encode ns

/-! ## The morse transport (radix 36) -/

/-- What a morse key can emit. -/
inductive MorseSym
  | dot
  | dash
  | gap
  deriving DecidableEq, Repr, Inhabited

open MorseSym in
/-- International morse for `0-9`, `A-Z`, and the period used as the field
separator. -/
def morseTable : List (List MorseSym) :=
  [ [dash, dash, dash, dash, dash],          -- 0
    [dot, dash, dash, dash, dash],           -- 1
    [dot, dot, dash, dash, dash],            -- 2
    [dot, dot, dot, dash, dash],             -- 3
    [dot, dot, dot, dot, dash],              -- 4
    [dot, dot, dot, dot, dot],               -- 5
    [dash, dot, dot, dot, dot],              -- 6
    [dash, dash, dot, dot, dot],             -- 7
    [dash, dash, dash, dot, dot],            -- 8
    [dash, dash, dash, dash, dot],           -- 9
    [dot, dash],                             -- A
    [dash, dot, dot, dot],                   -- B
    [dash, dot, dash, dot],                  -- C
    [dash, dot, dot],                        -- D
    [dot],                                   -- E
    [dot, dot, dash, dot],                   -- F
    [dash, dash, dot],                       -- G
    [dot, dot, dot, dot],                    -- H
    [dot, dot],                              -- I
    [dot, dash, dash, dash],                 -- J
    [dash, dot, dash],                       -- K
    [dot, dash, dot, dot],                   -- L
    [dash, dash],                            -- M
    [dash, dot],                             -- N
    [dash, dash, dash],                      -- O
    [dot, dash, dash, dot],                  -- P
    [dash, dash, dot, dash],                 -- Q
    [dot, dash, dot],                        -- R
    [dot, dot, dot],                         -- S
    [dash],                                  -- T
    [dot, dot, dash],                        -- U
    [dot, dot, dot, dash],                   -- V
    [dot, dash, dash],                       -- W
    [dash, dot, dot, dash],                  -- X
    [dash, dot, dash, dash],                 -- Y
    [dash, dash, dot, dot],                  -- Z
    [dot, dash, dot, dash, dot, dash] ]      -- '.', the field separator

theorem morseTable_length : morseTable.length = 36 + 1 := by decide

theorem morseTable_nodup : morseTable.Nodup := by decide

/-- One radix-36 symbol as a morse letter. -/
def morseSymCodec : Codec (Sym 36) (List MorseSym) :=
  tableCodec morseTable morseTable_length morseTable_nodup

theorem morseSymCodec_no_gap (s : Sym 36) : MorseSym.gap ∉ morseSymCodec.encode s := by
  revert s
  decide

/-- **The morse transport.** Letters are separated by a gap; fields by the
morse period. -/
def morseTransport : Codec (List Nat) (List MorseSym) :=
  (fieldsCodec 36 (by norm_num)).comp
    (Codec.delimited morseSymCodec MorseSym.gap morseSymCodec_no_gap)

theorem morseTransport_roundtrip (ns : List Nat) :
    morseTransport.decode (morseTransport.encode ns) = some ns :=
  morseTransport.decode_encode ns

/-! ## The numbers-station transport (radix 9) -/

/-- Spoken digits: `1`–`9` carry information, `0` separates fields, exactly as
a numbers station reads out groups. -/
def numbersTable : List Char := "1234567890".toList

theorem numbersTable_length : numbersTable.length = 9 + 1 := by decide

theorem numbersTable_nodup : numbersTable.Nodup := by decide

/-- One radix-9 symbol as a spoken digit. -/
def numbersSymCodec : Codec (Sym 9) Char :=
  tableCodec numbersTable numbersTable_length numbersTable_nodup

/-- **The numbers-station transport.** -/
def numbersTransport : Codec (List Nat) String :=
  ((fieldsCodec 9 (by norm_num)).comp (Codec.onList numbersSymCodec)).comp stringCodec

theorem numbersTransport_roundtrip (ns : List Nat) :
    numbersTransport.decode (numbersTransport.encode ns) = some ns :=
  numbersTransport.decode_encode ns

/-! ## The stego pad

A one-time pad at the symbol layer: the key is added to the message digit by
digit, without carries, exactly as a paper pad is used with a numbers station.
The pad is itself a codec, so it can be inserted in front of any transport. -/

variable {r : Nat}

/-- Add the (cyclically repeated) key to the symbol stream. -/
def padAdd (key : List (Sym r)) : List (Sym r) → List (Sym r)
  | [] => []
  | s :: l =>
    match key with
    | [] => s :: padAdd [] l
    | k :: ks => (s + k) :: padAdd (ks ++ [k]) l

/-- Subtract the (cyclically repeated) key from the symbol stream. -/
def padSub (key : List (Sym r)) : List (Sym r) → List (Sym r)
  | [] => []
  | s :: l =>
    match key with
    | [] => s :: padSub [] l
    | k :: ks => (s - k) :: padSub (ks ++ [k]) l

theorem padSub_padAdd (key : List (Sym r)) (l : List (Sym r)) :
    padSub key (padAdd key l) = l := by
  induction l generalizing key with
  | nil => rfl
  | cons s l ih =>
    cases key with
    | nil => simp [padAdd, padSub, ih]
    | cons k ks => simp [padAdd, padSub, ih, add_sub_cancel_right]

/-- **The stego pad.** Encoding and decoding with the same key are inverse. -/
def padCodec (key : List (Sym r)) : Codec (List (Sym r)) (List (Sym r)) where
  encode := padAdd key
  decode := fun l => some (padSub key l)
  decode_encode := fun l => by rw [padSub_padAdd]

/-- A padded numbers-station broadcast: the classic one-time-pad + shortwave
combination, still a codec. -/
def paddedNumbersTransport (key : List (Sym 9)) : Codec (List Nat) String :=
  (((fieldsCodec 9 (by norm_num)).comp (padCodec key)).comp
    (Codec.onList numbersSymCodec)).comp stringCodec

theorem paddedNumbersTransport_roundtrip (key : List (Sym 9)) (ns : List Nat) :
    (paddedNumbersTransport key).decode ((paddedNumbersTransport key).encode ns) = some ns :=
  (paddedNumbersTransport key).decode_encode ns

end NixWars
