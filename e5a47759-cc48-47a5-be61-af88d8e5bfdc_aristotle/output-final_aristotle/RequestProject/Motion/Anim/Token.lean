import Mathlib

/-!
# Tokens for renderings, minted by a static page

The formal counterpart of `web/js/nft.js`.  There is no chain and no server:
a token is a *signature chain* that travels in the URL beside the rendering it
is about.  The first record mints the token for a work — the content hash of
the playbook — and each later record hands it on, naming the previous record by
its hash and signed by whoever the chain says owns the token at that point.

The question a reader with nothing but the link has to answer is *who owns this
now, and may I believe it*.  What is proved:

* `Valid` is exactly the runtime's check: the chain begins with a self-signed
  mint, each later record is a transfer of the same work whose `prev` is the id
  of the record before it, each record carries the hash of its own contents,
  and each transfer is signed by the owner at that point;
* `owner_unique` — a valid chain determines the owner, the work and the last id
  uniquely, so two readers of the same link agree;
* `transfer_authorized` — **every transfer in a valid chain was signed by the
  owner at the time**; a record signed by anyone else cannot appear in one;
* `valid_prefix` — a valid chain is valid all the way down, so provenance can
  be read off it record by record;
* `work_const`, `mem_work` — every record of a chain is about the same work,
  and `id_ne_of_core_ne` — with an injective hash, altering any field of any
  record changes its id and the chain stops verifying;
* `bindsTo_iff` — a token is bound to the exact playbook: two playbooks share a
  token only if they are the same text.

`tests/node/test_lab.mjs` mints, transfers, forges, reorders and alters chains
against the shipped JavaScript, with real ECDSA P-256 keys.
-/

namespace Hesper.Token

/-- What a record does. -/
inductive Kind where
  | mint
  | xfer
  deriving DecidableEq, Inhabited

/-- The signed part of a record. -/
structure Core where
  kind : Kind
  /-- The content hash of the playbook this token is about. -/
  work : String
  /-- The id of the record before this one; empty for a mint. -/
  prev : String
  /-- Who holds the token after this record. -/
  owner : String
  ts : ℕ
  deriving DecidableEq, Inhabited

/-- A record as it travels: its signed core, the signature, and its own id. -/
structure Record (Sig : Type) where
  core : Core
  sig : Sig
  id : String

variable {Sig : Type}

/--
A valid chain, together with the work it is about, who owns it now, and the id
of its last record.  This is the runtime's `verify`, stated inductively.
-/
inductive Valid (hash : Core → String) (verify : String → Core → Sig → Prop) :
    List (Record Sig) → String → String → String → Prop
  /-- The genesis: a mint, signed by the one it mints to. -/
  | mint {r : Record Sig}
      (hk : r.core.kind = Kind.mint)
      (hp : r.core.prev = "")
      (hid : r.id = hash r.core)
      (hs : verify r.core.owner r.core r.sig) :
      Valid hash verify [r] r.core.work r.core.owner r.id
  /-- A transfer of the same work, following the last record, signed by the
  owner at that point. -/
  | xfer {c : List (Record Sig)} {work owner lastId : String} {r : Record Sig}
      (hc : Valid hash verify c work owner lastId)
      (hk : r.core.kind = Kind.xfer)
      (hw : r.core.work = work)
      (hp : r.core.prev = lastId)
      (hid : r.id = hash r.core)
      (hs : verify owner r.core r.sig) :
      Valid hash verify (c ++ [r]) work r.core.owner r.id

variable {hash : Core → String} {verify : String → Core → Sig → Prop}

/-- A valid chain is never empty. -/
theorem ne_nil_of_valid {c : List (Record Sig)} {w o l : String}
    (h : Valid hash verify c w o l) : c ≠ [] := by
  cases h with
  | mint => simp
  | xfer => simp

/-- The last record of a valid chain names the owner and the last id. -/
theorem getLast?_of_valid {c : List (Record Sig)} {w o l : String}
    (h : Valid hash verify c w o l) :
    ∃ r, c.getLast? = some r ∧ r.core.owner = o ∧ r.id = l := by
  cases h with
  | mint => exact ⟨_, by simp, rfl, rfl⟩
  | @xfer c work owner lastId r _ _ _ _ _ _ => exact ⟨r, by simp, rfl, rfl⟩

/-- **A valid chain determines who owns the token.**  Two readers of the same
link cannot disagree. -/
theorem owner_unique {c : List (Record Sig)} {w₁ o₁ l₁ w₂ o₂ l₂ : String}
    (h₁ : Valid hash verify c w₁ o₁ l₁) (h₂ : Valid hash verify c w₂ o₂ l₂) :
    o₁ = o₂ ∧ l₁ = l₂ := by
  obtain ⟨r₁, hr₁, ho₁, hi₁⟩ := getLast?_of_valid h₁
  obtain ⟨r₂, hr₂, ho₂, hi₂⟩ := getLast?_of_valid h₂
  have : r₁ = r₂ := by
    rw [hr₁] at hr₂
    exact Option.some.inj hr₂
  subst this
  exact ⟨by rw [← ho₁, ho₂], by rw [← hi₁, hi₂]⟩

/-- **Every transfer in a valid chain was signed by the owner at the time.** -/
theorem transfer_authorized {c : List (Record Sig)} {r : Record Sig} {w o l : String}
    (h : Valid hash verify (c ++ [r]) w o l) (hc : c ≠ []) :
    ∃ owner lastId, Valid hash verify c w owner lastId ∧
      verify owner r.core r.sig ∧ r.core.prev = lastId ∧ r.core.work = w ∧
      r.id = hash r.core := by
  generalize hch : c ++ [r] = ch at h
  cases h with
  | @mint r' hk hp hid hs =>
    exfalso
    have hlen := congrArg List.length hch
    simp at hlen
    exact hc hlen
  | @xfer c' work owner lastId r' hc' hk hw hp hid hs =>
    obtain ⟨hcc, hrr⟩ := List.append_inj' hch.symm rfl
    subst hcc
    have : r' = r := by simpa using hrr
    subst this
    exact ⟨owner, lastId, hc', hs, hp, hw, hid⟩

/-- A valid chain is valid all the way down: provenance can be read off it. -/
theorem valid_prefix {c : List (Record Sig)} {r : Record Sig} {w o l : String}
    (h : Valid hash verify (c ++ [r]) w o l) (hc : c ≠ []) :
    ∃ owner lastId, Valid hash verify c w owner lastId := by
  obtain ⟨owner, lastId, hv, _⟩ := transfer_authorized h hc
  exact ⟨owner, lastId, hv⟩

/-- Appending a properly signed transfer keeps a chain valid — this is what the
studio's *transfer* button does. -/
theorem valid_append {c : List (Record Sig)} {w o l : String} {r : Record Sig}
    (hc : Valid hash verify c w o l)
    (hk : r.core.kind = Kind.xfer) (hw : r.core.work = w) (hp : r.core.prev = l)
    (hid : r.id = hash r.core) (hs : verify o r.core r.sig) :
    Valid hash verify (c ++ [r]) w r.core.owner r.id :=
  Valid.xfer hc hk hw hp hid hs

/-- Every record of a valid chain is about the same work. -/
theorem work_const {c : List (Record Sig)} {w o l : String}
    (h : Valid hash verify c w o l) : ∀ r ∈ c, r.core.work = w := by
  induction h with
  | mint => intro r hr; simp at hr; subst hr; rfl
  | @xfer c' work owner lastId r hc hk hw hp hid hs ih =>
    intro x hx
    rcases List.mem_append.mp hx with hx | hx
    · exact ih x hx
    · simp at hx; subst hx; exact hw

/-- The first record of a valid chain is its mint, and it is self-signed. -/
theorem mint_first {c : List (Record Sig)} {w o l : String}
    (h : Valid hash verify c w o l) :
    ∃ r, c.head? = some r ∧ r.core.kind = Kind.mint ∧ r.core.prev = "" ∧
      verify r.core.owner r.core r.sig := by
  induction h with
  | @mint r hk hp hid hs => exact ⟨r, by simp, hk, hp, hs⟩
  | @xfer c' work owner lastId r hc hk hw hp hid hs ih =>
    obtain ⟨r₀, hr₀, rest⟩ := ih
    refine ⟨r₀, ?_, rest⟩
    cases c' with
    | nil => simp at hr₀
    | cons a as => simpa using hr₀

/-- Every record of a valid chain carries the hash of its own contents, so
altering any field of it breaks the chain. -/
theorem id_eq_hash {c : List (Record Sig)} {w o l : String}
    (h : Valid hash verify c w o l) : ∀ r ∈ c, r.id = hash r.core := by
  induction h with
  | mint => intro r hr; simp at hr; subst hr; assumption
  | @xfer c' work owner lastId r hc hk hw hp hid hs ih =>
    intro x hx
    rcases List.mem_append.mp hx with hx | hx
    · exact ih x hx
    · simp at hx; subst hx; exact hid

/-- **A record cannot be altered without changing its id.** -/
theorem id_ne_of_core_ne (hinj : Function.Injective hash) {a b : Core} (h : a ≠ b) :
    hash a ≠ hash b := fun hc => h (hinj hc)

/-! ## Binding a token to a rendering

The work is the content hash of the playbook, so a token is about one exact
text; a change of one number is a different work and the token does not follow
it. -/

/-- Two playbooks share a work exactly when they are the same text. -/
theorem bindsTo_iff {work : String → String} (hinj : Function.Injective work)
    (a b : String) : work a = work b ↔ a = b :=
  ⟨fun h => hinj h, fun h => by rw [h]⟩

/-- A valid chain is about the playbook whose content hash it names, and no
other. -/
theorem work_of_playbook {work : String → String} (hinj : Function.Injective work)
    {c : List (Record Sig)} {o l : String} {text text' : String}
    (h : Valid hash verify c (work text) o l) (hne : text ≠ text') :
    ¬ Valid hash verify c (work text') o l := by
  intro h'
  obtain ⟨r, hr, _, _⟩ := getLast?_of_valid h
  have h1 : ∀ x ∈ c, x.core.work = work text := work_const h
  have h2 : ∀ x ∈ c, x.core.work = work text' := work_const h'
  have hmem : r ∈ c := List.mem_of_getLast? hr
  exact hne (hinj ((h1 r hmem).symm.trans (h2 r hmem)))

end Hesper.Token
