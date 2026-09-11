import RequestProject.Gvcs.Web.Base64

/-!
# Content packs: a paste-able, modular format for the game's contents

The single page of `RequestProject/Web/Standalone.lean` carries one fixed rule
book.  This file is the other half of the modular build: a *content pack* — a
list of items with their prices, bills of materials, labour and yields — and a
codec that turns a pack into one line of ASCII text and back.  A line of text
is a thing two players can exchange by paste, so packs are the unit in which
the game is extended and shared.

Everything here is proved, not tested:

* `splitOnChar_joinWith` — the field/record splitter inverts the joiner;
* `decNat_encNat`, `decInt_encInt` — the number syntax round-trips;
* `decodeBody_encodeBody` — the pack body text parses back to the pack;
* `decodeShare_encodeShare` — **the main theorem**: a safe pack, encoded to a
  share string (base64 with a checksum), decodes back to exactly that pack;
* `encodeShare_injective` — hence two different packs never share a code;
* `decodeShare_bad_checksum` — a share string whose checksum does not match the
  body it carries is rejected.

The only hypothesis is `Pack.Safe`, a decidable check that every text field is
printable ASCII without the field separator; the packs the game ships are
proved safe by evaluation.
-/

namespace LifeTrac
namespace Modular

open Web

/-! ## Splitting and joining

Two levels of the format — fields inside a record, records inside a body — are
the same operation, so it is done once, over `List Char`, and proved once. -/

/-- Split a character list at every occurrence of `d`.  The result is never
empty: `splitOnChar d [] = [[]]`, one empty field. -/
def splitOnChar (d : Char) : List Char → List (List Char)
  | [] => [[]]
  | c :: cs =>
      if c = d then [] :: splitOnChar d cs
      else match splitOnChar d cs with
           | f :: fs => (c :: f) :: fs
           | [] => [[c]]

/-- Put the pieces back together with `d` between them. -/
def joinWith (d : Char) : List (List Char) → List Char
  | [] => []
  | [f] => f
  | f :: fs => f ++ d :: joinWith d fs

theorem splitOnChar_ne_nil (d : Char) (l : List Char) : splitOnChar d l ≠ [] := by
  induction l with
  | nil => simp [splitOnChar]
  | cons c cs ih =>
      simp only [splitOnChar]
      split
      · simp
      · cases h : splitOnChar d cs with
        | nil => simp
        | cons g gs => simp

/-- A piece with no separator in it is one field. -/
theorem splitOnChar_of_not_mem {d : Char} :
    ∀ {l : List Char}, d ∉ l → splitOnChar d l = [l]
  | [], _ => rfl
  | c :: cs, h => by
      have hc : c ≠ d := fun h' => h (by simp [h'])
      have hcs : d ∉ cs := fun h' => h (by simp [h'])
      simp [splitOnChar, hc, splitOnChar_of_not_mem hcs]

/-- Splitting after a separator-free prefix peels that prefix off. -/
theorem splitOnChar_append_cons {d : Char} :
    ∀ {f : List Char}, d ∉ f → ∀ (rest : List Char),
      splitOnChar d (f ++ d :: rest) = f :: splitOnChar d rest
  | [], _, rest => by simp [splitOnChar]
  | c :: cs, h, rest => by
      have hc : c ≠ d := fun h' => h (by simp [h'])
      have hcs : d ∉ cs := fun h' => h (by simp [h'])
      simp [splitOnChar, hc, splitOnChar_append_cons hcs rest]

/-- **The splitter inverts the joiner** on any non-empty list of
separator-free fields. -/
theorem splitOnChar_joinWith {d : Char} :
    ∀ {fs : List (List Char)}, fs ≠ [] → (∀ f ∈ fs, d ∉ f) →
      splitOnChar d (joinWith d fs) = fs
  | [], h, _ => absurd rfl h
  | [f], _, hd => by
      simpa [joinWith] using splitOnChar_of_not_mem (hd f (by simp))
  | f :: g :: gs, _, hd => by
      have hf : d ∉ f := hd f (by simp)
      have hrest : ∀ x ∈ g :: gs, d ∉ x := fun x hx => hd x (by simp [hx])
      have : splitOnChar d (joinWith d (g :: gs)) = g :: gs :=
        splitOnChar_joinWith (by simp) hrest
      simp [joinWith, splitOnChar_append_cons hf, this]

/-! ## Numbers -/

/-- The decimal digit of a value below ten. -/
def digitChar (n : Nat) : Char := Char.ofNat (48 + n)

/-- The value of a decimal digit. -/
def digitVal (c : Char) : Nat := c.toNat - 48

/-- Is this character a decimal digit? -/
def isDigitC (c : Char) : Bool := decide (48 ≤ c.toNat ∧ c.toNat ≤ 57)

theorem digitVal_digitChar {n : Nat} (h : n < 10) : digitVal (digitChar n) = n := by
  interval_cases n <;> decide

theorem isDigitC_digitChar {n : Nat} (h : n < 10) : isDigitC (digitChar n) = true := by
  interval_cases n <;> decide

theorem digitChar_toNat_lt {n : Nat} (h : n < 10) : (digitChar n).toNat < 128 := by
  interval_cases n <;> decide

/-- A natural number in decimal, most significant digit first. -/
def encNat (n : Nat) : List Char :=
  if n = 0 then ['0'] else ((Nat.digits 10 n).map digitChar).reverse

/-- Read a decimal numeral. -/
def decNat (l : List Char) : Option Nat :=
  if l ≠ [] ∧ l.all isDigitC then
    some (Nat.ofDigits 10 (l.reverse.map digitVal))
  else none

theorem encNat_ne_nil (n : Nat) : encNat n ≠ [] := by
  unfold encNat
  split
  · simp
  · simp [Nat.digits_ne_nil_iff_ne_zero.mpr (by assumption)]

theorem mem_encNat_digit {n : Nat} {c : Char} (h : c ∈ encNat n) :
    ∃ k, k < 10 ∧ c = digitChar k := by
  unfold encNat at h
  split at h
  · exact ⟨0, by norm_num, by simpa using h⟩
  · simp only [List.mem_reverse, List.mem_map] at h
    obtain ⟨k, hk, rfl⟩ := h
    exact ⟨k, Nat.digits_lt_base (by norm_num) hk, rfl⟩

theorem encNat_isDigit {n : Nat} : ∀ c ∈ encNat n, isDigitC c = true := by
  intro c hc
  obtain ⟨k, hk, rfl⟩ := mem_encNat_digit hc
  exact isDigitC_digitChar hk

/-- **The decimal syntax round-trips.** -/
theorem decNat_encNat (n : Nat) : decNat (encNat n) = some n := by
  have hall : (encNat n).all isDigitC = true := by
    simp only [List.all_eq_true]
    intro c hc
    exact encNat_isDigit c hc
  unfold decNat
  rw [if_pos ⟨encNat_ne_nil n, hall⟩]
  congr 1
  by_cases h : n = 0
  · subst h; decide
  · simp only [encNat, if_neg h, List.reverse_reverse, List.map_map]
    have : (Nat.digits 10 n).map (digitVal ∘ digitChar) = Nat.digits 10 n := by
      refine List.map_congr_left ?_ |>.trans (List.map_id _)
      intro k hk
      simpa using digitVal_digitChar (Nat.digits_lt_base (by norm_num) hk)
    rw [this, Nat.ofDigits_digits]

/-- An integer: an optional minus sign and a decimal numeral. -/
def encInt (i : Int) : List Char :=
  if i < 0 then '-' :: encNat i.natAbs else encNat i.natAbs

/-- Read an integer. -/
def decInt (l : List Char) : Option Int :=
  match l with
  | '-' :: rest => (decNat rest).map (fun n => -(n : Int))
  | _ => (decNat l).map (fun n => (n : Int))

theorem decInt_encInt (i : Int) : decInt (encInt i) = some i := by
  unfold encInt
  by_cases h : i < 0
  · rw [if_pos h]
    have : decInt ('-' :: encNat i.natAbs) = (decNat (encNat i.natAbs)).map
        (fun n => -(n : Int)) := rfl
    rw [this, decNat_encNat]
    simp [Int.ofNat_natAbs_of_nonpos h.le]
  · rw [if_neg h]
    have hne : encNat i.natAbs ≠ [] := encNat_ne_nil _
    have hhd : ∀ c ∈ encNat i.natAbs, c ≠ '-' := by
      intro c hc
      obtain ⟨k, hk, rfl⟩ := mem_encNat_digit hc
      interval_cases k <;> decide
    cases hl : encNat i.natAbs with
    | nil => exact absurd hl hne
    | cons c cs =>
        have hc : c ≠ '-' := hhd c (by rw [hl]; simp)
        have : decInt (c :: cs) = (decNat (c :: cs)).map (fun n => (n : Int)) := by
          unfold decInt
          split
          · rename_i heq; cases heq; exact absurd rfl hc
          · rfl
        rw [this, ← hl, decNat_encNat]
        simp [Int.natAbs_of_nonneg (not_lt.mp h)]

/-! ## The pack model -/

/-- What sort of thing an item is: something bought from the dealer, something
built at the workbench, or something grown in the field. -/
inductive Kind where
  /-- Stock bought and sold at the market. -/
  | material : Kind
  /-- An assembly fabricated at the workbench from a bill of materials. -/
  | part : Kind
  /-- A crop worked in the field. -/
  | crop : Kind
  deriving DecidableEq, Repr, Inhabited

/-- The wire code of a kind. -/
def Kind.code : Kind → Nat
  | .material => 0
  | .part => 1
  | .crop => 2

/-- The kind a wire code names. -/
def Kind.ofCode : Nat → Option Kind
  | 0 => some .material
  | 1 => some .part
  | 2 => some .crop
  | _ => none

@[simp] theorem Kind.ofCode_code (k : Kind) : Kind.ofCode k.code = some k := by
  cases k <;> rfl

/-- One entry of a pack.  All money is in millionths of a unit of account, all
labour in millionths of a day and all fuel in millionths of a litre, exactly as
in `RequestProject/Runtime.lean`. -/
structure Item where
  /-- The key other items and the save file refer to it by. -/
  id : String
  /-- What the screens call it. -/
  name : String
  /-- Bought, built or grown. -/
  kind : Kind
  /-- The unit it is counted in. -/
  unit : String
  /-- What the dealer charges for one, in micro-money. -/
  price : Int
  /-- What the dealer pays for one, in micro-money. -/
  salvage : Int
  /-- The labour one takes, in micro-days. -/
  days : Int
  /-- What one fetches when it is produced, in micro-money. -/
  revenue : Int
  /-- The bill of materials: item keys and whole quantities. -/
  inputs : List (String × Int)
  deriving DecidableEq, Repr, Inhabited

/-- A content pack: a named, versioned list of items together with the goal a
player loading it plays for. -/
structure Pack where
  /-- The pack's key. -/
  id : String
  /-- Its title, as the pack list shows it. -/
  title : String
  /-- Its version. -/
  version : Nat
  /-- The key of the item that must be standing in the yard to win. -/
  goalItem : String
  /-- The cash that must be in hand as well, in micro-money. -/
  goalCash : Int
  /-- Its items. -/
  items : List Item
  deriving DecidableEq, Repr, Inhabited

/-! ## Safety: which text may go into a field -/

/-- Printable ASCII, and not the field separator. -/
def safeChar (c : Char) : Bool :=
  decide (32 ≤ c.toNat ∧ c.toNat ≤ 126) && !(decide (c = '|'))

/-- A string that may be written into a field. -/
def safeStr (s : String) : Bool := s.toList.all safeChar

/-- Every text field of an item is safe. -/
def Item.Safe (i : Item) : Bool :=
  safeStr i.id && safeStr i.name && safeStr i.unit && i.inputs.all (fun p => safeStr p.1)

/-- Every text field of the pack and of its items is safe. -/
def Pack.Safe (p : Pack) : Bool :=
  safeStr p.id && safeStr p.title && safeStr p.goalItem && p.items.all Item.Safe

theorem safeChar_ne_sep {c : Char} (h : safeChar c = true) : c ≠ '|' := by
  unfold safeChar at h
  simp only [Bool.and_eq_true, Bool.not_eq_true', decide_eq_false_iff_not,
    decide_eq_true_eq] at h
  exact h.2

theorem safeChar_ne_newline {c : Char} (h : safeChar c = true) : c ≠ '\n' := by
  intro h'
  subst h'
  exact absurd h (by decide)

theorem safeChar_lt {c : Char} (h : safeChar c = true) : c.toNat < 128 := by
  unfold safeChar at h
  simp only [Bool.and_eq_true, decide_eq_true_eq] at h
  omega

/-! ## The text of a pack

A record is its fields joined with `|`; the body is its records joined with a
newline.  The first record is the header, the rest are items. -/

/-- The fields of an item, in order.  The bill of materials is written as pairs
of trailing fields, so the record needs no nested syntax. -/
def itemFields (i : Item) : List (List Char) :=
  [i.id.toList, i.name.toList, encNat i.kind.code, i.unit.toList,
   encInt i.price, encInt i.salvage, encInt i.days, encInt i.revenue] ++
  i.inputs.flatMap (fun p => [p.1.toList, encInt p.2])

/-- Read the trailing bill-of-materials fields. -/
def decInputs : List (List Char) → Option (List (String × Int))
  | [] => some []
  | [_] => none
  | k :: v :: rest => do
      let q ← decInt v
      let tl ← decInputs rest
      pure ((String.ofList k, q) :: tl)

/-- Read an item's record. -/
def decItem : List (List Char) → Option Item
  | id :: name :: kd :: unit :: pr :: sv :: dy :: rv :: rest => do
      let kn ← decNat kd
      let k ← Kind.ofCode kn
      let price ← decInt pr
      let salvage ← decInt sv
      let days ← decInt dy
      let revenue ← decInt rv
      let inputs ← decInputs rest
      pure { id := String.ofList id, name := String.ofList name, kind := k,
             unit := String.ofList unit, price := price, salvage := salvage,
             days := days, revenue := revenue, inputs := inputs }
  | _ => none

/-- The tag every pack body starts with. -/
def packTag : List Char := ['L', 'T', 'P', 'A', 'C', 'K']

/-- The records of a pack: a header and one record per item. -/
def packRecords (p : Pack) : List (List (List Char)) :=
  (packTag :: p.id.toList :: p.title.toList :: encNat p.version ::
    p.goalItem.toList :: [encInt p.goalCash]) ::
    p.items.map itemFields

/-- The pack as one text. -/
def encodeBody (p : Pack) : List Char :=
  joinWith '\n' ((packRecords p).map (joinWith '|'))

/-- Read a pack out of its text. -/
def decodeBody (l : List Char) : Option Pack :=
  match (splitOnChar '\n' l).map (splitOnChar '|') with
  | (tag :: pid :: ptitle :: pver :: pgoal :: [pcash]) :: rest =>
      if tag = packTag then do
        let v ← decNat pver
        let cash ← decInt pcash
        let items ← rest.mapM decItem
        pure { id := String.ofList pid, title := String.ofList ptitle,
               version := v, goalItem := String.ofList pgoal, goalCash := cash,
               items := items }
      else none
  | _ => none

/-! ## The share string -/

/-- A rolling checksum of the body text. -/
def checksum (l : List Char) : Nat :=
  l.foldl (fun a c => (a * 131 + c.toNat) % 1000003) 7

/-- The pack as one line of text: a tag, the base64 of the body, and the
checksum of the body. -/
def encodeShare (p : Pack) : String :=
  let body := encodeBody p
  String.ofList (joinWith '.'
    ["LTP1".toList, b64Enc (body.map Char.toNat), encNat (checksum body)])

/-- Read a share string. -/
def decodeShare (s : String) : Option Pack :=
  match splitOnChar '.' s.toList with
  | [tag, payload, ck] =>
      if tag = "LTP1".toList then
        let body := (b64Dec payload).map Char.ofNat
        match decNat ck with
        | some c => if c = checksum body then decodeBody body else none
        | none => none
      else none
  | _ => none


/-! ## The round trip

The proofs go up the format: characters, then fields, then records, then the
body, then the share string. -/

/-- A character that may appear in a field: printable ASCII, and neither
separator. -/
def okChar (c : Char) : Prop := c ≠ '|' ∧ c ≠ '\n' ∧ c.toNat < 128

/-- A field made only of such characters. -/
def okField (f : List Char) : Prop := ∀ c ∈ f, okChar c

theorem okChar_of_safeChar {c : Char} (h : safeChar c = true) : okChar c :=
  ⟨safeChar_ne_sep h, safeChar_ne_newline h, safeChar_lt h⟩

theorem okField_of_safeStr {s : String} (h : safeStr s = true) : okField s.toList := by
  intro c hc
  exact okChar_of_safeChar (by simpa using (List.all_eq_true.mp h) c hc)

theorem okChar_digitChar {k : Nat} (h : k < 10) : okChar (digitChar k) := by
  interval_cases k <;> exact ⟨by decide, by decide, by decide⟩

theorem okField_encNat (n : Nat) : okField (encNat n) := by
  intro c hc
  obtain ⟨k, hk, rfl⟩ := mem_encNat_digit hc
  exact okChar_digitChar hk

theorem okField_encInt (i : Int) : okField (encInt i) := by
  intro c hc
  unfold encInt at hc
  split at hc
  · rcases List.mem_cons.mp hc with rfl | hc2
    · exact ⟨by decide, by decide, by decide⟩
    · exact okField_encNat _ c hc2
  · exact okField_encNat _ c hc

theorem not_mem_of_okField {f : List Char} (h : okField f) : '|' ∉ f ∧ '\n' ∉ f :=
  ⟨fun hm => (h _ hm).1 rfl, fun hm => (h _ hm).2.1 rfl⟩

/-- A character not in any of the pieces, and different from the separator, is
not in the join. -/
theorem not_mem_joinWith {d e : Char} (hde : e ≠ d) :
    ∀ {fs : List (List Char)}, (∀ f ∈ fs, e ∉ f) → e ∉ joinWith d fs
  | [], _ => by simp [joinWith]
  | [f], h => by simpa [joinWith] using h f (by simp)
  | f :: g :: gs, h => by
      have hf : e ∉ f := h f (by simp)
      have hrest : e ∉ joinWith d (g :: gs) :=
        not_mem_joinWith hde (fun x hx => h x (by simp [hx]))
      simp [joinWith, hf, hde, hrest]

/-- Every character of a joined record is below 128 if every field's is. -/
theorem joinWith_lt {d : Char} (hd : d.toNat < 128) :
    ∀ {fs : List (List Char)}, (∀ f ∈ fs, ∀ c ∈ f, c.toNat < 128) →
      ∀ c ∈ joinWith d fs, c.toNat < 128
  | [], _ => by simp [joinWith]
  | [f], h => by simpa [joinWith] using h f (by simp)
  | f :: g :: gs, h => by
      intro c hc
      simp only [joinWith, List.mem_append, List.mem_cons] at hc
      rcases hc with hc | rfl | hc
      · exact h f (by simp) c hc
      · exact hd
      · exact joinWith_lt hd (fun x hx => h x (by simp [hx])) c hc

/-! ### Items -/

theorem itemFields_ok {i : Item} (h : i.Safe = true) :
    ∀ f ∈ itemFields i, okField f := by
  simp only [Item.Safe, Bool.and_eq_true] at h
  obtain ⟨⟨⟨hid, hname⟩, hunit⟩, hins⟩ := h
  intro f hf
  simp only [itemFields, List.mem_append, List.mem_cons, List.mem_flatMap] at hf
  rcases hf with hf | ⟨q, hq, hf⟩
  · rcases hf with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | hf
    · exact okField_of_safeStr hid
    · exact okField_of_safeStr hname
    · exact okField_encNat _
    · exact okField_of_safeStr hunit
    · exact okField_encInt _
    · exact okField_encInt _
    · exact okField_encInt _
    · exact okField_encInt _
    · exact absurd hf (by simp)
  · have hq' : safeStr q.1 = true := by
      simpa using (List.all_eq_true.mp hins) q hq
    rcases hf with rfl | rfl | hf'
    · exact okField_of_safeStr hq'
    · exact okField_encInt _
    · exact absurd hf' (by simp)

theorem itemFields_ne_nil (i : Item) : itemFields i ≠ [] := by
  simp [itemFields]

theorem decInputs_enc : ∀ (l : List (String × Int)),
    decInputs (l.flatMap (fun p => [p.1.toList, encInt p.2])) = some l
  | [] => rfl
  | (k, q) :: t => by
      simp only [List.flatMap_cons, List.cons_append, List.nil_append, decInputs,
        decInt_encInt, decInputs_enc t]
      simp [String.ofList_toList]

/-- An item's record reads back as the item. -/
theorem decItem_itemFields (i : Item) : decItem (itemFields i) = some i := by
  simp [itemFields, decItem, decNat_encNat, decInt_encInt, decInputs_enc,
    Kind.ofCode_code, String.ofList_toList]

/-! ### The body -/

theorem okField_packTag : okField packTag := by
  intro c hc
  simp only [packTag, List.mem_cons, List.not_mem_nil, or_false] at hc
  rcases hc with rfl | rfl | rfl | rfl | rfl | rfl <;>
    exact ⟨by decide, by decide, by decide⟩

theorem packRecords_ok {p : Pack} (h : p.Safe = true) :
    ∀ r ∈ packRecords p, r ≠ [] ∧ ∀ f ∈ r, okField f := by
  simp only [Pack.Safe, Bool.and_eq_true] at h
  obtain ⟨⟨⟨hid, htitle⟩, hgoal⟩, hitems⟩ := h
  intro r hr
  simp only [packRecords, List.mem_cons, List.mem_map] at hr
  rcases hr with rfl | ⟨i, hi, rfl⟩
  · refine ⟨by simp, ?_⟩
    intro f hf
    rcases List.mem_cons.mp hf with rfl | hf
    · exact okField_packTag
    · rcases List.mem_cons.mp hf with rfl | hf
      · exact okField_of_safeStr hid
      · rcases List.mem_cons.mp hf with rfl | hf
        · exact okField_of_safeStr htitle
        · rcases List.mem_cons.mp hf with rfl | hf
          · exact okField_encNat _
          · rcases List.mem_cons.mp hf with rfl | hf
            · exact okField_of_safeStr hgoal
            · rcases List.mem_cons.mp hf with rfl | hf
              · exact okField_encInt _
              · exact absurd hf (by simp)
  · exact ⟨itemFields_ne_nil i, itemFields_ok (by simpa using (List.all_eq_true.mp hitems) i hi)⟩

/-- The two levels of splitting recover the records. -/
theorem split_encodeBody {p : Pack} (h : p.Safe = true) :
    (splitOnChar '\n' (encodeBody p)).map (splitOnChar '|') = packRecords p := by
  have hrec := packRecords_ok h
  have h1 : splitOnChar '\n' (encodeBody p) = (packRecords p).map (joinWith '|') := by
    refine splitOnChar_joinWith (by simp [packRecords]) ?_
    intro f hf
    simp only [List.mem_map] at hf
    obtain ⟨r, hr, rfl⟩ := hf
    exact not_mem_joinWith (by decide)
      (fun g hg => (not_mem_of_okField ((hrec r hr).2 g hg)).2)
  rw [h1, List.map_map]
  refine (List.map_congr_left ?_).trans (List.map_id _)
  intro r hr
  simpa using splitOnChar_joinWith (hrec r hr).1
    (fun g hg => (not_mem_of_okField ((hrec r hr).2 g hg)).1)

theorem mapM_decItem : ∀ (l : List Item), List.mapM (decItem ∘ itemFields) l = some l
  | [] => rfl
  | i :: t => by
      simp [List.mapM_cons, decItem_itemFields, mapM_decItem t]

/-- **The pack text parses back to the pack.** -/
theorem decodeBody_encodeBody {p : Pack} (h : p.Safe = true) :
    decodeBody (encodeBody p) = some p := by
  unfold decodeBody
  rw [split_encodeBody h]
  simp [packRecords, decNat_encNat, decInt_encInt, List.mapM_map, mapM_decItem,
    String.ofList_toList]

/-! ### The share string -/

theorem okField_encodeBody {p : Pack} (h : p.Safe = true) :
    ∀ c ∈ encodeBody p, c.toNat < 128 := by
  have hrec := packRecords_ok h
  refine joinWith_lt (by decide) ?_
  intro f hf
  simp only [List.mem_map] at hf
  obtain ⟨r, hr, rfl⟩ := hf
  exact joinWith_lt (by decide) (fun g hg c hc => ((hrec r hr).2 g hg c hc).2.2)

theorem b64Char_ne_dot (n : Nat) : b64Char n ≠ '.' := by
  by_cases h : n < 64
  · interval_cases n <;> decide
  · have hlen : b64Alphabet.length ≤ n := by simpa [b64Alphabet] using Nat.le_of_not_lt h
    have hnone : b64Alphabet[n]? = none := List.getElem?_eq_none hlen
    simp [b64Char, List.getD_eq_getElem?_getD, hnone]

theorem dot_ne_b64Char (n : Nat) : '.' ≠ b64Char n := fun h => b64Char_ne_dot n h.symm

theorem b64Enc_no_dot : ∀ (l : List Nat), '.' ∉ b64Enc l
  | [] => by simp [b64Enc]
  | [_] => by simp [b64Enc, dot_ne_b64Char]
  | [_, _] => by simp [b64Enc, dot_ne_b64Char]
  | _ :: _ :: _ :: t => by
      simp [b64Enc, dot_ne_b64Char, b64Enc_no_dot t]

/-- **A pack survives the trip through a share string**: the code a player
copies out of one page decodes, in another page, to the very same pack. -/
theorem decodeShare_encodeShare {p : Pack} (h : p.Safe = true) :
    decodeShare (encodeShare p) = some p := by
  set body := encodeBody p with hbody
  have hbytes : ∀ b ∈ body.map Char.toNat, b < 256 := by
    intro b hb
    simp only [List.mem_map] at hb
    obtain ⟨c, hc, rfl⟩ := hb
    exact lt_trans (okField_encodeBody h c hc) (by norm_num)
  have hround : (b64Dec (b64Enc (body.map Char.toNat))).map Char.ofNat = body := by
    rw [b64Dec_b64Enc _ hbytes, List.map_map]
    refine (List.map_congr_left ?_).trans (List.map_id _)
    intro c _
    simp
  have hsplit : splitOnChar '.' (encodeShare p).toList =
      ["LTP1".toList, b64Enc (body.map Char.toNat), encNat (checksum body)] := by
    rw [encodeShare, String.toList_ofList]
    refine splitOnChar_joinWith (by simp) ?_
    intro f hf
    simp only [List.mem_cons] at hf
    rcases hf with rfl | rfl | rfl | hf
    · decide
    · exact b64Enc_no_dot _
    · intro hm
      obtain ⟨k, hk, hkc⟩ := mem_encNat_digit hm
      interval_cases k <;> exact absurd hkc (by decide)
    · exact absurd hf (by simp)
  unfold decodeShare
  rw [hsplit]
  simp only [hround, decNat_encNat]
  exact decodeBody_encodeBody h

/-- Two different safe packs never have the same share code. -/
theorem encodeShare_injective {p q : Pack} (hp : p.Safe = true) (hq : q.Safe = true)
    (h : encodeShare p = encodeShare q) : p = q := by
  have := decodeShare_encodeShare hp
  rw [h, decodeShare_encodeShare hq] at this
  exact (Option.some.inj this).symm

/-- **A share string whose checksum does not match its payload is refused.**
This is what stops a pack that was truncated or mangled in transit from being
loaded as if it were intact. -/
theorem decodeShare_bad_checksum {payload ck : List Char} {c : Nat}
    (hp : '.' ∉ payload) (hck : '.' ∉ ck) (hc : decNat ck = some c)
    (hne : c ≠ checksum ((b64Dec payload).map Char.ofNat)) :
    decodeShare (String.ofList (joinWith '.' ["LTP1".toList, payload, ck])) = none := by
  have hsplit : splitOnChar '.' (String.ofList
      (joinWith '.' ["LTP1".toList, payload, ck])).toList =
      ["LTP1".toList, payload, ck] := by
    rw [String.toList_ofList]
    refine splitOnChar_joinWith (by simp) ?_
    intro f hf
    simp only [List.mem_cons] at hf
    rcases hf with rfl | rfl | rfl | hf
    · decide
    · exact hp
    · exact hck
    · exact absurd hf (by simp)
  unfold decodeShare
  rw [hsplit]
  simp [hc, hne]

end Modular
end LifeTrac
