/-
# Prove2me §11–§12 — human-readable names, and conflicts

Addresses solve identity; people need names.  A name is a *signed
mutable pointer*: the owner's key, a sequence number, and the address it
currently points at.  Nothing about a name is part of an artifact's
identity, and no name update ever alters an artifact.

Proved here:

* `resolve_update_accepted` — an accepted update is what the name now
  resolves to;
* `stale_never_wins` — a record with a sequence number that is not
  strictly newer is refused, so replaying an old signed record cannot
  roll a name back;
* `hijack_refused` — a record signed by a different key than the current
  owner is refused;
* `unsigned_refused` — an unsigned or badly signed record is refused;
* `history_retained` — every record the peer already had is still there
  after an update.  Nothing is overwritten, so previous states remain
  auditable;
* `update_other_name` — an update to one name never disturbs another,
  which is what lets aliases, branches and competing registries coexist;
* `distinct_names_coexist` — two names may point at different addresses
  and both resolve, and neither is "the" name;
* `setName_store` — a name update does not touch the content store: the
  bytes at an address never change because somebody renamed something.
-/
import RequestProject.Kant.Prove2me.Replication

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Prove2me

open Kant Kant.Text Kant.Urania

/-! ## Name records -/

/-- A signed mutable pointer from a name to an address. -/
structure NameRecord where
  /-- The human-readable name. -/
  name : Str
  /-- The address it currently points at. -/
  pointsTo : Cid
  /-- Monotone counter, per name. -/
  sequence : Nat
  /-- The key entitled to update this name. -/
  owner : Key
deriving DecidableEq, Repr

/-- A name record together with the owner's signature. -/
structure SignedName (Sig : Type) where
  /-- The record. -/
  record : NameRecord
  /-- The owner's signature over exactly that record. -/
  signature : Sig

/-- A peer accepts a record only if it verifies under the key it claims
as owner. -/
def validName {Sig : Type} (S : SigScheme Key NameRecord Sig) (sn : SignedName Sig) : Bool :=
  S.verify sn.record.owner sn.record sn.signature

/-- A registry is a history: the newest record for a name is the first
one that matches, and older records are retained behind it. -/
abbrev Registry := List NameRecord

/-- What a name currently resolves to. -/
def resolve (reg : Registry) (nm : Str) : Option NameRecord :=
  reg.find? (fun r => r.name == nm)

@[simp] theorem resolve_cons_self (r : NameRecord) (reg : Registry) :
    resolve (r :: reg) r.name = some r := by
  simp [resolve]

theorem resolve_cons_other {r : NameRecord} {reg : Registry} {nm : Str} (h : r.name ≠ nm) :
    resolve (r :: reg) nm = resolve reg nm := by
  simp [resolve, h]

/-- Whether a new record supersedes the current one: same owner, strictly
greater sequence number.  A name nobody has claimed can be claimed. -/
def supersedes (cur : Option NameRecord) (r : NameRecord) : Bool :=
  match cur with
  | none => true
  | some c => (c.owner == r.owner) && decide (c.sequence < r.sequence)

/-- Apply a signed name record. -/
def update {Sig : Type} (S : SigScheme Key NameRecord Sig) (reg : Registry)
    (sn : SignedName Sig) : Registry :=
  if validName S sn && supersedes (resolve reg sn.record.name) sn.record then
    sn.record :: reg
  else reg

/-! ## What an update does -/

/-- An accepted update is what the name now resolves to. -/
theorem resolve_update_accepted {Sig : Type} {S : SigScheme Key NameRecord Sig}
    {reg : Registry} {sn : SignedName Sig}
    (hv : validName S sn = true)
    (hs : supersedes (resolve reg sn.record.name) sn.record = true) :
    resolve (update S reg sn) sn.record.name = some sn.record := by
  simp [update, hv, hs]

/-- **A stale record never wins.**  Replaying an old signed pointer
cannot move a name backwards. -/
theorem stale_never_wins {Sig : Type} {S : SigScheme Key NameRecord Sig}
    {reg : Registry} {sn : SignedName Sig} {cur : NameRecord}
    (hcur : resolve reg sn.record.name = some cur)
    (hseq : sn.record.sequence ≤ cur.sequence) :
    update S reg sn = reg := by
  have : supersedes (resolve reg sn.record.name) sn.record = false := by
    rw [hcur]
    simp only [supersedes, Bool.and_eq_false_iff, decide_eq_false_iff_not, Nat.not_lt]
    exact Or.inr hseq
  simp [update, this]

/-- **A name cannot be hijacked.**  A record signed by anybody other than
the current owner is refused, however new its sequence number. -/
theorem hijack_refused {Sig : Type} {S : SigScheme Key NameRecord Sig}
    {reg : Registry} {sn : SignedName Sig} {cur : NameRecord}
    (hcur : resolve reg sn.record.name = some cur)
    (hown : cur.owner ≠ sn.record.owner) :
    update S reg sn = reg := by
  have : supersedes (resolve reg sn.record.name) sn.record = false := by
    rw [hcur]
    simp only [supersedes, Bool.and_eq_false_iff, beq_eq_false_iff_ne, ne_eq]
    exact Or.inl hown
  simp [update, this]

/-- An unsigned record is refused. -/
theorem unsigned_refused {Sig : Type} {S : SigScheme Key NameRecord Sig}
    {reg : Registry} {sn : SignedName Sig} (hv : validName S sn = false) :
    update S reg sn = reg := by
  simp [update, hv]

/-- **Nothing is ever overwritten.**  Every record the peer held is still
held after an update, so the previous state of a name remains
auditable. -/
theorem history_retained {Sig : Type} {S : SigScheme Key NameRecord Sig}
    {reg : Registry} {sn : SignedName Sig} :
    ∀ r ∈ reg, r ∈ update S reg sn := by
  intro r hr
  unfold update
  split
  · exact List.mem_cons_of_mem _ hr
  · exact hr

/-- An update to one name leaves every other name exactly as it was. -/
theorem update_other_name {Sig : Type} {S : SigScheme Key NameRecord Sig}
    {reg : Registry} {sn : SignedName Sig} {nm : Str} (h : sn.record.name ≠ nm) :
    resolve (update S reg sn) nm = resolve reg nm := by
  unfold update
  split
  · exact resolve_cons_other h
  · rfl

/-- **Two names coexist.**  Different registries, aliases and branches
can point at different artifacts without either being "the" name and
without one silently replacing the other. -/
theorem distinct_names_coexist {r₁ r₂ : NameRecord} (hne : r₁.name ≠ r₂.name) :
    resolve [r₁, r₂] r₁.name = some r₁ ∧ resolve [r₁, r₂] r₂.name = some r₂ := by
  refine ⟨resolve_cons_self _ _, ?_⟩
  rw [resolve_cons_other hne]
  exact resolve_cons_self _ _

/-- A record a peer keeps was signed by the owner it names. -/
theorem name_record_authentic {Sig : Type} {S : SigScheme Key NameRecord Sig}
    {sn : SignedName Sig} (hv : validName S sn = true) :
    S.signedBy sn.record.owner sn.record sn.signature :=
  S.noForgery _ _ _ hv

/-! ## Names do not touch artifacts -/

/-- A node holds a content store and a name registry.  The two are
separate, which is the whole point of the mutable-pointer design. -/
structure Node where
  /-- Bodies, by address. -/
  store : List (Cid × Content)
  /-- Names. -/
  names : Registry

/-- Apply a name update to a node. -/
def Node.setName {Sig : Type} (S : SigScheme Key NameRecord Sig) (n : Node)
    (sn : SignedName Sig) : Node :=
  { n with names := update S n.names sn }

/-- **Renaming changes no bytes.**  A name update leaves the content
store exactly as it was, so an artifact cannot be altered by pointing a
name somewhere else. -/
@[simp] theorem setName_store {Sig : Type} (S : SigScheme Key NameRecord Sig) (n : Node)
    (sn : SignedName Sig) : (n.setName S sn).store = n.store := rfl

/-- And so the artifact a name *used* to point at is still there. -/
theorem setName_keeps_artifact {Sig : Type} {S : SigScheme Key NameRecord Sig} {n : Node}
    {sn : SignedName Sig} {cid : Cid} {c : Content} (h : (cid, c) ∈ n.store) :
    (cid, c) ∈ (n.setName S sn).store := by
  rw [setName_store]
  exact h

end Kant.Prove2me
