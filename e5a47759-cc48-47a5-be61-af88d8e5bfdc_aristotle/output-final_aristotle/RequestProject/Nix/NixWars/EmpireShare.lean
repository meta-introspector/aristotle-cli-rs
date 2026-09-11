import RequestProject.Nix.NixWars.EmpireCodec

/-!
# Carrying a game in a link

A page of *Foundation and Empire* used to hand you a file: play one command and
the page wrote its successor, which you had to download and host before anybody
could see it. That is a poor way to play. This file is the machinery that lets
the game be *stored*, *compacted* and *joined* instead:

* **compacted** — `encodeLog` writes a whole log as a short run of URL-safe
  characters (`A`–`Z`, `a`–`z`, `0`–`9`, `-`, `_`): one character for a `pass`
  or a `research`, two for a `build` or a `colonise`, four for a small `jump`.
  `decodeLog` reads it back, and `decode_encode` proves the two are inverse:
  the code *is* the game, nothing about it is lost.

* **stored** — a code is a string, so the browser can keep it in the address
  bar (`…/empire-move1#g=CODE`) and in local storage. `hashOfLog` and
  `logOfHash` are that fragment, and `logOfHash_hashOfLog` proves the link
  round-trips too: a link is a whole game, and the same link always reopens
  the same game.

* **joined** — two players' pages drift apart. `joinLogs` puts them back
  together: if one log extends the other, the join is the longer one, and
  otherwise the two have genuinely diverged and no join exists.
  `join_isSome_iff_common` proves that any two records of *the same* game
  always join, `join_least` that the join is the shortest common extension,
  and `join_chain_prefix` that joining never rewrites history — the hash chain
  of each side survives in the chain of the join.

Nothing here is a new rule of the game: a joined log is one of the two logs it
came from, so it is legal exactly when that one was (`join_legalRun`).
-/

namespace NixWars

namespace Share

/-! ## Digits

Sixty-four characters that survive a URL fragment untouched. -/

/-- The digit alphabet: `A`–`Z`, `a`–`z`, `0`–`9`, `-`, `_`. -/
def digits : List Char :=
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_".toList

/-- The `n`th digit. -/
def digitChar (n : Nat) : Char := digits.getD n 'A'

/-- The value of a digit, or `none` if the character is not one. -/
def digitVal? (c : Char) : Option Nat := digits.findIdx? (· == c)

theorem digits_length : digits.length = 64 := by decide

theorem digit_roundtrip : ∀ n, n < 64 → digitVal? (digitChar n) = some n := by decide

/-! ## Numbers

A number is written in base 32, least significant digit first, with the digit
raised by 32 when another digit follows. So everything below 32 — every system
number, and every fleet a player is likely to move — is a single character. -/

/-- A number as digits: base 32, low digit first, `+32` marking "more to come". -/
def encNat (n : Nat) : List Char :=
  if n < 32 then [digitChar n]
  else digitChar (32 + n % 32) :: encNat (n / 32)
decreasing_by exact Nat.div_lt_self (by omega) (by omega)

/-- Read a number back, returning it with whatever follows it. -/
def decNat : List Char → Option (Nat × List Char)
  | [] => none
  | c :: rest =>
    match digitVal? c with
    | none => none
    | some v =>
      if v < 32 then some (v, rest)
      else
        match decNat rest with
        | none => none
        | some (m, rest') => some (v - 32 + 32 * m, rest')

theorem encNat_length_pos (n : Nat) : 0 < (encNat n).length := by
  rw [encNat]; split <;> simp

theorem encNat_ne_nil (n : Nat) : encNat n ≠ [] := by
  intro h
  have := encNat_length_pos n
  rw [h] at this
  exact absurd this (by simp)

theorem decNat_encNat : ∀ (n : Nat) (t : List Char), decNat (encNat n ++ t) = some (n, t) := by
  intro n
  induction n using Nat.strongRecOn with
  | _ n ih =>
    intro t
    rw [encNat]
    by_cases h : n < 32
    · simp only [h, if_pos, List.cons_append, List.nil_append, decNat,
        digit_roundtrip n (by omega)]
    · have hlt : n / 32 < n := Nat.div_lt_self (by omega) (by omega)
      have hd : digitVal? (digitChar (32 + n % 32)) = some (32 + n % 32) :=
        digit_roundtrip _ (by have := Nat.mod_lt n (y := 32) (by omega); omega)
      simp only [h, List.cons_append, decNat, hd, ite_false]
      rw [if_neg (by omega), ih (n / 32) hlt t]
      have hdm : 32 * (n / 32) + n % 32 = n := Nat.div_add_mod n 32
      simp only [Nat.add_sub_cancel_left, Option.some.injEq, Prod.mk.injEq, and_true]
      omega

/-! ## Commands

A command is a tag followed by its arguments, each of them a number. The tags
are `0` build, `1` jump, `2` colonise, `3` research, `4` pass. -/

/-- A command as digits. -/
def encMove : Move → List Char
  | .build s => encNat 0 ++ encNat s
  | .jump a b n => encNat 1 ++ encNat a ++ encNat b ++ encNat n
  | .colonise s => encNat 2 ++ encNat s
  | .research => encNat 3
  | .pass => encNat 4

/-- Read a command back, returning it with whatever follows it. -/
def decMove (cs : List Char) : Option (Move × List Char) :=
  match decNat cs with
  | none => none
  | some (t, r) =>
    if t = 0 then
      match decNat r with
      | none => none
      | some (s, r') => some (.build s, r')
    else if t = 1 then
      match decNat r with
      | none => none
      | some (a, r1) =>
        match decNat r1 with
        | none => none
        | some (b, r2) =>
          match decNat r2 with
          | none => none
          | some (n, r3) => some (.jump a b n, r3)
    else if t = 2 then
      match decNat r with
      | none => none
      | some (s, r') => some (.colonise s, r')
    else if t = 3 then some (.research, r)
    else if t = 4 then some (.pass, r)
    else none

theorem encMove_length_pos (m : Move) : 0 < (encMove m).length := by
  cases m with
  | build s =>
      rw [encMove]; simp only [List.length_append]; have := encNat_length_pos 0; omega
  | jump a b n =>
      rw [encMove]; simp only [List.length_append]; have := encNat_length_pos 1; omega
  | colonise s =>
      rw [encMove]; simp only [List.length_append]; have := encNat_length_pos 2; omega
  | research => rw [encMove]; exact encNat_length_pos 3
  | pass => rw [encMove]; exact encNat_length_pos 4

theorem encMove_ne_nil (m : Move) : encMove m ≠ [] := by
  intro h
  have := encMove_length_pos m
  rw [h] at this
  exact absurd this (by simp)

theorem decMove_encMove (m : Move) (t : List Char) : decMove (encMove m ++ t) = some (m, t) := by
  cases m with
  | build s => simp [encMove, decMove, decNat_encNat]
  | jump a b n =>
      simp [encMove, decMove, List.append_assoc, decNat_encNat]
  | colonise s => simp [encMove, decMove, decNat_encNat]
  | research => simp [encMove, decMove, decNat_encNat]
  | pass => simp [encMove, decMove, decNat_encNat]

/-! ## Logs -/

/-- A whole log as digits: one command after another, nothing between them. -/
def encLog : List Move → List Char
  | [] => []
  | m :: rest => encMove m ++ encLog rest

/-- Read a log back. The fuel is only there to make the recursion obvious; one
unit per character is always enough, since every command costs at least one. -/
def decLogAux : Nat → List Char → Option (List Move)
  | _, [] => some []
  | 0, _ :: _ => none
  | fuel + 1, cs =>
    match decMove cs with
    | none => none
    | some (m, rest) => (decLogAux fuel rest).map (m :: ·)

/-- Read a log back from digits. -/
def decLog (cs : List Char) : Option (List Move) := decLogAux cs.length cs

theorem encLog_append (l l' : List Move) : encLog (l ++ l') = encLog l ++ encLog l' := by
  induction l with
  | nil => simp [encLog]
  | cons m rest ih => simp [encLog, ih, List.append_assoc]

theorem length_le_encLog (l : List Move) : l.length ≤ (encLog l).length := by
  induction l with
  | nil => simp [encLog]
  | cons m rest ih =>
      have h : 1 ≤ (encMove m).length := encMove_length_pos m
      simp only [encLog, List.length_cons, List.length_append]
      omega

theorem decLogAux_encLog (l : List Move) (fuel : Nat) (h : l.length ≤ fuel) :
    decLogAux fuel (encLog l) = some l := by
  induction l generalizing fuel with
  | nil => simp [encLog, decLogAux]
  | cons m rest ih =>
      obtain ⟨f, rfl⟩ : ∃ f, fuel = f + 1 := ⟨fuel - 1, by simp at h; omega⟩
      have hne : encMove m ++ encLog rest ≠ [] := by
        intro hc
        exact encMove_ne_nil m (List.append_eq_nil_iff.mp hc).1
      cases hcs : encMove m ++ encLog rest with
      | nil => exact absurd hcs hne
      | cons c cs =>
          have hd : decMove (c :: cs) = some (m, encLog rest) := by
            rw [← hcs]; exact decMove_encMove m _
          have hrest : decLogAux f (encLog rest) = some rest := by
            apply ih; simp at h; omega
          show decLogAux (f + 1) (encLog (m :: rest)) = _
          rw [show encLog (m :: rest) = c :: cs from by rw [encLog]; exact hcs]
          simp [decLogAux, hd, hrest]

/-- **The code is the game.** Every log reads back exactly as it was written. -/
theorem decLog_encLog (l : List Move) : decLog (encLog l) = some l :=
  decLogAux_encLog l _ (length_le_encLog l)

/-! ## The code as a string -/

/-- The share code of a log. -/
def encodeLog (l : List Move) : String := String.ofList (encLog l)

/-- The log a share code carries, if it is one. -/
def decodeLog (s : String) : Option (List Move) := decLog s.toList

/-- **Round trip.** Decoding a share code gives back the game it was made
from. -/
theorem decode_encode (l : List Move) : decodeLog (encodeLog l) = some l := by
  simp [decodeLog, encodeLog, String.toList_ofList, decLog_encLog]

/-- **The code only ever grows.** Playing on extends the code by the code of
the commands played; nothing already in it is rewritten. -/
theorem encodeLog_append (l l' : List Move) :
    encodeLog (l ++ l') = encodeLog l ++ encodeLog l' := by
  simp [encodeLog, encLog_append, String.ofList_append]

/-! ## The link

A page keeps the game in its own address, after the `#`. Nothing after the `#`
is ever sent to a server, so a game lives in the player's browser and travels
only when they hand the link to somebody. -/

/-- The fragment a page puts in the address bar for a log. -/
def hashOfLog (l : List Move) : String := "#g=" ++ encodeLog l

/-- The game a fragment carries. Anything that is not a `#g=…` fragment, and
anything whose code does not decode, is no game. -/
def logOfHash (s : String) : Option (List Move) :=
  match s.toList with
  | '#' :: 'g' :: '=' :: rest => decLog rest
  | _ => none

/-- **A link is a whole game.** The fragment a page writes for a log is a
fragment that reads back as that same log. -/
theorem logOfHash_hashOfLog (l : List Move) : logOfHash (hashOfLog l) = some l := by
  have h : (hashOfLog l).toList = '#' :: 'g' :: '=' :: encLog l := by
    simp [hashOfLog, encodeLog, String.toList_append, String.toList_ofList]
    rfl
  simp [logOfHash, h, decLog_encLog]

/-! ## Joining two games

Two people play the same game from two pages. Their logs either agree — one is
the other with more commands played on the end — or they have diverged, and
there is no single game to be had. -/

/-- The join of two logs: the longer one, when one extends the other. -/
def joinLogs (a b : List Move) : Option (List Move) :=
  if a.isPrefixOf b then some b else if b.isPrefixOf a then some a else none

theorem isPrefixOf_iff (a b : List Move) : a.isPrefixOf b = true ↔ a <+: b :=
  List.isPrefixOf_iff_prefix

/-- Joining a game with itself changes nothing. -/
@[simp] theorem join_self (a : List Move) : joinLogs a a = some a := by
  simp [joinLogs, List.isPrefixOf_iff_prefix]

/-- The opening position joins with anything, and adds nothing. -/
@[simp] theorem join_nil (a : List Move) : joinLogs [] a = some a := by
  simp [joinLogs]

/-- **Joining is symmetric**: it does not matter whose page you paste into
whose. -/
theorem join_comm (a b : List Move) : joinLogs a b = joinLogs b a := by
  by_cases hab : a <+: b
  · by_cases hba : b <+: a
    · have : a = b := hab.eq_of_length (Nat.le_antisymm hab.length_le hba.length_le)
      subst this; rfl
    · simp [joinLogs, List.isPrefixOf_iff_prefix, hab, hba]
  · by_cases hba : b <+: a
    · simp [joinLogs, List.isPrefixOf_iff_prefix, hab, hba]
    · simp [joinLogs, List.isPrefixOf_iff_prefix, hab, hba]

/-- **A join is a common extension**: both players' games are still there,
move for move, at the front of the joined one. -/
theorem join_extends {a b c : List Move} (h : joinLogs a b = some c) :
    a <+: c ∧ b <+: c := by
  unfold joinLogs at h
  by_cases hab : a.isPrefixOf b
  · rw [if_pos hab] at h
    cases h
    exact ⟨(isPrefixOf_iff a b).1 hab, List.prefix_refl _⟩
  · rw [if_neg hab] at h
    by_cases hba : b.isPrefixOf a
    · rw [if_pos hba] at h
      cases h
      exact ⟨List.prefix_refl _, (isPrefixOf_iff b a).1 hba⟩
    · rw [if_neg hba] at h; exact absurd h (by simp)

/-- **A join is one of the two games**, so it invents nothing. -/
theorem join_eq {a b c : List Move} (h : joinLogs a b = some c) : c = a ∨ c = b := by
  unfold joinLogs at h
  by_cases hab : a.isPrefixOf b
  · rw [if_pos hab] at h; cases h; exact Or.inr rfl
  · rw [if_neg hab] at h
    by_cases hba : b.isPrefixOf a
    · rw [if_pos hba] at h; cases h; exact Or.inl rfl
    · rw [if_neg hba] at h; exact absurd h (by simp)

/-- **Two records of the same game always join.** If both players' logs are
prefixes of one real game, then the join exists — the players cannot both have
played by the rules and still be unable to reconcile. -/
theorem join_isSome_of_common {a b d : List Move} (ha : a <+: d) (hb : b <+: d) :
    (joinLogs a b).isSome = true := by
  rcases List.prefix_or_prefix_of_prefix ha hb with h | h
  · simp [joinLogs, (isPrefixOf_iff a b).2 h]
  · by_cases hab : a.isPrefixOf b
    · simp [joinLogs, hab]
    · simp [joinLogs, hab, (isPrefixOf_iff b a).2 h]

/-- **A join exists exactly when the two games have not diverged.** -/
theorem join_isSome_iff_common (a b : List Move) :
    (joinLogs a b).isSome = true ↔ (a <+: b ∨ b <+: a) := by
  constructor
  · intro h
    obtain ⟨c, hc⟩ := Option.isSome_iff_exists.1 h
    rcases join_eq hc with rfl | rfl
    · exact Or.inr (join_extends hc).2
    · exact Or.inl (join_extends hc).1
  · rintro (h | h)
    · simp [joinLogs, (isPrefixOf_iff a b).2 h]
    · by_cases hab : a.isPrefixOf b
      · simp [joinLogs, hab]
      · simp [joinLogs, hab, (isPrefixOf_iff b a).2 h]

/-- **The join is the least common extension.** Whatever real game both players
were playing, the join is no further along than that game: joining never
invents a move nobody played. -/
theorem join_least {a b d : List Move} (ha : a <+: d) (hb : b <+: d) :
    ∃ c, joinLogs a b = some c ∧ c <+: d := by
  obtain ⟨c, hc⟩ := Option.isSome_iff_exists.1 (join_isSome_of_common ha hb)
  refine ⟨c, hc, ?_⟩
  rcases join_eq hc with rfl | rfl
  · exact ha
  · exact hb

/-- **Joining preserves legality.** A join of two games played by the rules was
itself played by the rules. -/
theorem join_legalRun {a b c : List Move} (ha : legalRun genesis a = true)
    (hb : legalRun genesis b = true) (h : joinLogs a b = some c) :
    legalRun genesis c = true := by
  rcases join_eq h with rfl | rfl
  · exact ha
  · exact hb

/-- **Joining does not rewrite history.** Every hash either page had computed
is still there, in the same place, in the chain of the joined game. -/
theorem join_chain_prefix {a b c : List Move} (h : joinLogs a b = some c) :
    chain genesis a <+: chain genesis c ∧ chain genesis b <+: chain genesis c := by
  obtain ⟨hac, hbc⟩ := join_extends h
  obtain ⟨ta, hta⟩ := hac
  obtain ⟨tb, htb⟩ := hbc
  constructor
  · exact hta ▸ chain_prefix genesis a ta
  · exact htb ▸ chain_prefix genesis b tb

/-! ## How short the code is

Every command whose arguments are all below 32 — every command of a real game,
since there are only twelve systems and a fleet that large has already won —
costs at most four characters. -/

/-- A command all of whose arguments are single digits. -/
def Small : Move → Prop
  | .build s => s < 32
  | .jump a b n => a < 32 ∧ b < 32 ∧ n < 32
  | .colonise s => s < 32
  | .research => True
  | .pass => True

theorem encNat_length_of_lt (n : Nat) (h : n < 32) : (encNat n).length = 1 := by
  rw [encNat, if_pos h]; rfl

theorem encMove_length_le (m : Move) (h : Small m) : (encMove m).length ≤ 4 := by
  cases m with
  | build s => simp [encMove, encNat_length_of_lt _ h, encNat_length_of_lt 0 (by omega)]
  | jump a b n =>
      obtain ⟨h1, h2, h3⟩ := h
      simp [encMove, encNat_length_of_lt _ h1, encNat_length_of_lt _ h2,
        encNat_length_of_lt _ h3, encNat_length_of_lt 1 (by omega)]
  | colonise s => simp [encMove, encNat_length_of_lt _ h, encNat_length_of_lt 2 (by omega)]
  | research => simp [encMove, encNat_length_of_lt 3 (by omega)]
  | pass => simp [encMove, encNat_length_of_lt 4 (by omega)]

/-- **Four characters a command, at the very worst.** A hundred-command game
travels in four hundred characters of a link. -/
theorem encodeLog_length_le (l : List Move) (h : ∀ m ∈ l, Small m) :
    (encodeLog l).length ≤ 4 * l.length := by
  simp only [encodeLog, String.length_ofList]
  induction l with
  | nil => simp [encLog]
  | cons m rest ih =>
      have hm := encMove_length_le m (h m (by simp))
      have hr := ih (fun x hx => h x (by simp [hx]))
      simp only [encLog, List.length_append, List.length_cons] at *
      omega

/-- The code of a log is one character per digit of it. -/
theorem encodeLog_length (l : List Move) : (encodeLog l).length = (encLog l).length :=
  String.length_ofList

/-! ## What Lean hands the page

The page's JavaScript is a transcription of the definitions above, so the
harness needs Lean's own answers to check it against. -/

/-- The share code of the campaign. -/
def campaignCode : String := encodeLog campaign

/-- The share code of the probe log. -/
def probeCode : String := encodeLog probeLog

/-- The share code of the empty game. -/
def emptyCode : String := encodeLog []

/-- The share code of the one-command game the shipped move page carries. -/
def moveOneCode : String := encodeLog [Move.jump 0 1 1]

/-- Lean's answers about codes and joins, for the harness. -/
def shareJson : String :=
  let joinStr (o : Option (List Move)) : String :=
    match o with | none => "null" | some l => "\"" ++ encodeLog l ++ "\""
  "{\"digits\":" ++ jsonString (String.ofList digits) ++
  ",\"emptyCode\":" ++ jsonString emptyCode ++
  ",\"moveOneCode\":" ++ jsonString moveOneCode ++
  ",\"campaignCode\":" ++ jsonString campaignCode ++
  ",\"probeCode\":" ++ jsonString probeCode ++
  ",\"campaignHash\":" ++ jsonString (hashOfLog campaign) ++
  ",\"campaignPrefixCodes\":[" ++
    String.intercalate ","
      ((List.range 9).map (fun k => jsonString (encodeLog (campaign.take (k * 9))))) ++ "]" ++
  ",\"joinPrefix\":" ++ joinStr (joinLogs (campaign.take 10) (campaign.take 20)) ++
  ",\"joinSelf\":" ++ joinStr (joinLogs (campaign.take 10) (campaign.take 10)) ++
  ",\"joinEmpty\":" ++ joinStr (joinLogs [] (campaign.take 5)) ++
  ",\"joinDiverged\":" ++
    joinStr (joinLogs (campaign.take 10) (campaign.take 9 ++ [Move.build 99])) ++
  ",\"codeLengths\":[" ++
    String.intercalate ","
      [toString emptyCode.length, toString moveOneCode.length,
       toString campaignCode.length, toString probeCode.length] ++ "]}"

#guard decodeLog (encodeLog campaign) = some campaign
#guard decodeLog (encodeLog probeLog) = some probeLog
#guard decodeLog "" = some []
#guard decodeLog "!!!" = none
#guard logOfHash (hashOfLog campaign) = some campaign
#guard moveOneCode = encodeLog [Move.jump 0 1 1]
#guard joinLogs (campaign.take 10) (campaign.take 20) = some (campaign.take 20)
#guard joinLogs (campaign.take 10) (campaign.take 9 ++ [Move.build 99]) = none

end Share

end NixWars
