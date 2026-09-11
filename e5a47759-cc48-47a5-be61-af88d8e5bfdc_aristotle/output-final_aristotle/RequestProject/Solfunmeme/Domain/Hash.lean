import RequestProject.Solfunmeme.Domain.Emit

/-!
# Canonical hashes

Every canonical object receives a deterministic content identity, and every
emitted representation carries it.  That is what makes "these five files are
the same domain object" a checkable statement rather than a claim in a README.

```text
canonical object → canonical serialization → hash
```

The canonical serialization of a record is its run of rows in the plain-text
row syntax; of the whole package, the whole table in the same syntax.  Both are
proved injective, so the hash identifies something.  The identity does not
depend on the codec a document arrived in (`domainHash_of_any_codec`).

Stamping is the last piece.  An emitted object carries its own hash in
`canonical_hash`, and `objectHash_stamp` proves that stamping does not change
the identity being stamped — the hash is taken of the object *without* its
stamp, so the file can quote its own digest without the digest becoming
self-referential.
-/

namespace Solfunmeme.Domain

open Solfunmeme.Codec

/-! ## Fixed-width hexadecimal -/

def hexDigit (n : Nat) : Char := "0123456789abcdef".toList.getD (n % 16) '0'

def hexDigitsAux : Nat → Nat → List Char
  | 0, _ => []
  | k + 1, n => hexDigit (n % 16) :: hexDigitsAux k (n / 16)

/-- A `UInt64` as sixteen lower-case hexadecimal digits, most significant
first.  Fixed width, so digests sort and compare as strings. -/
def hex16 (x : UInt64) : String := String.ofList (hexDigitsAux 16 x.toNat).reverse

/-- The digest of a hash value, with its algorithm named. -/
def digestOf (x : UInt64) : String := "fnv1a64:" ++ hex16 x

/-! ## Canonical serialization of one record -/

/-- The canonical serialization of a run of rows: the plain-text row syntax. -/
def cellsCanonical (cs : List Cell) : String := text.render cs

@[simp] theorem cellsParse_canonical (cs : List Cell) :
    text.parse (cellsCanonical cs) = some cs := RowSyntax.parse_render text_wf cs

theorem cellsCanonical_inj {cs ds : List Cell} (h : cellsCanonical cs = cellsCanonical ds) :
    cs = ds := by
  have hc := cellsParse_canonical cs
  rw [h, cellsParse_canonical ds] at hc
  exact (Option.some.inj hc).symm

/-- A domain object on its own. -/
def objectCanonical (o : DomainObject) : String :=
  cellsCanonical (blockCells "" o.id "object" (objectTriples o))

def objectParse (s : String) : Option DomainObject :=
  (text.parse s).bind (fun cs =>
    (takeBlock "object" objectFieldNames cs).bind (fun r => objectOfValues r.1))

@[simp] theorem objectParse_canonical (o : DomainObject) :
    objectParse (objectCanonical o) = some o := by
  have h := takeBlock_blockCells "" o.id "object" (objectTriples o) []
  rw [objectTriples_names, List.append_nil] at h
  simp [objectParse, objectCanonical, h]

theorem objectCanonical_inj {o q : DomainObject} (h : objectCanonical o = objectCanonical q) :
    o = q := by
  have ho := objectParse_canonical o
  rw [h, objectParse_canonical q] at ho
  exact (Option.some.inj ho).symm

/-- A proof record on its own. -/
def proofCanonical (p : ProofRecord) : String :=
  cellsCanonical (blockCells "" p.id "proof" (proofTriples p))

def proofParse (s : String) : Option ProofRecord :=
  (text.parse s).bind (fun cs =>
    (takeBlock "proof" proofFieldNames cs).bind (fun r => proofOfValues r.1))

@[simp] theorem proofParse_canonical (p : ProofRecord) :
    proofParse (proofCanonical p) = some p := by
  have h := takeBlock_blockCells "" p.id "proof" (proofTriples p) []
  rw [proofTriples_names, List.append_nil] at h
  simp [proofParse, proofCanonical, h]

theorem proofCanonical_inj {p q : ProofRecord} (h : proofCanonical p = proofCanonical q) :
    p = q := by
  have hp := proofParse_canonical p
  rw [h, proofParse_canonical q] at hp
  exact (Option.some.inj hp).symm

/-- A claim on its own. -/
def claimCanonical (c : DomainClaim) : String :=
  cellsCanonical (blockCells "" c.id "claim" (claimTriples c))

def claimParse (s : String) : Option DomainClaim :=
  (text.parse s).bind (fun cs =>
    (takeBlock "claim" claimFieldNames cs).bind (fun r => claimOfValues r.1))

@[simp] theorem claimParse_canonical (c : DomainClaim) :
    claimParse (claimCanonical c) = some c := by
  have h := takeBlock_blockCells "" c.id "claim" (claimTriples c) []
  rw [claimTriples_names, List.append_nil] at h
  simp [claimParse, claimCanonical, h]

theorem claimCanonical_inj {c e : DomainClaim} (h : claimCanonical c = claimCanonical e) :
    c = e := by
  have hc := claimParse_canonical c
  rw [h, claimParse_canonical e] at hc
  exact (Option.some.inj hc).symm

/-- The whole package. -/
def domainCanonical (d : Domain) : String := toDomainText d

@[simp] theorem domainParse_canonical (d : Domain) :
    ofDomainText (domainCanonical d) = some d := ofDomainText_toDomainText d

theorem domainCanonical_inj {d e : Domain} (h : domainCanonical d = domainCanonical e) : d = e := by
  have hd := domainParse_canonical d
  rw [h, domainParse_canonical e] at hd
  exact (Option.some.inj hd).symm

/-! ## The hashes -/

def objectHashValue (o : DomainObject) : UInt64 := hashString (objectCanonical o)
def proofHashValue (p : ProofRecord) : UInt64 := hashString (proofCanonical p)
def claimHashValue (c : DomainClaim) : UInt64 := hashString (claimCanonical c)
def domainHashValue (d : Domain) : UInt64 := hashString (domainCanonical d)

def objectHash (o : DomainObject) : String := digestOf (objectHashValue o)
def proofHash (p : ProofRecord) : String := digestOf (proofHashValue p)
def claimHash (c : DomainClaim) : String := digestOf (claimHashValue c)
def domainHash (d : Domain) : String := digestOf (domainHashValue d)

/-- Different digests mean different objects.  (The converse is not claimed: a
64-bit hash can collide.) -/
theorem objectHash_ne {o q : DomainObject} (h : objectHash o ≠ objectHash q) : o ≠ q :=
  fun hoq => h (by rw [hoq])

theorem proofHash_ne {p q : ProofRecord} (h : proofHash p ≠ proofHash q) : p ≠ q :=
  fun hpq => h (by rw [hpq])

theorem domainHash_ne {d e : Domain} (h : domainHash d ≠ domainHash e) : d ≠ e :=
  fun hde => h (by rw [hde])

/-- **The same canonical hash in every file.**  A package written as IPDL, XML,
CSV, YAML or text decodes to a package with the same identity, so the five
files can be shown to represent the same domain. -/
theorem domainHash_of_any_codec (r : RowSyntax) (hr : r ∈ codecs) (d : Domain) :
    (decodeDomain r (encodeDomain r d)).map domainHash = some (domainHash d) := by
  rw [decodeDomain_of_codec r hr d]
  rfl

/-- And any two of them agree with each other. -/
theorem domainHash_cross (r r' : RowSyntax) (hr : r ∈ codecs) (hr' : r' ∈ codecs) (d : Domain) :
    (decodeDomain r (encodeDomain r d)).map domainHash
      = (decodeDomain r' (encodeDomain r' d)).map domainHash := by
  rw [domainHash_of_any_codec r hr d, domainHash_of_any_codec r' hr' d]

/-! ## Stamping -/

/-- The key under which an emitted object quotes its own digest. -/
def hashKey : String := "canonical_hash"

/-- An object with any previous stamp removed. -/
def DomainObject.unstamped (o : DomainObject) : DomainObject :=
  { o with extensions := o.extensions.filter (fun kv => kv.1 != hashKey) }

/-- An object carrying its own canonical hash.  The hash is of the *unstamped*
object, so quoting it does not change it. -/
def DomainObject.stamped (o : DomainObject) : DomainObject :=
  { o.unstamped with
      extensions := o.unstamped.extensions ++ [(hashKey, objectHash o.unstamped)] }

@[simp] theorem unstamped_stamped (o : DomainObject) : o.stamped.unstamped = o.unstamped := by
  cases o with
  | mk id kind name claim value valueType inputRefs parameters transformations outputRefs
      claimRefs evidence proofRefs errorRefs truth sourceRefs provenance extensions =>
    simp [DomainObject.stamped, DomainObject.unstamped, List.filter_append, List.filter_filter,
      hashKey]

/-- Stamping does not change the identity it records. -/
theorem objectHash_stamped (o : DomainObject) :
    objectHash o.stamped.unstamped = objectHash o.unstamped := by rw [unstamped_stamped]

/-- The stamp depends only on the unstamped object. -/
theorem stamped_congr {a b : DomainObject} (h : a.unstamped = b.unstamped) :
    a.stamped = b.stamped := by
  unfold DomainObject.stamped
  rw [h]

/-- Stamping is idempotent: re-emitting a stamped object gives the same bytes. -/
theorem DomainObject.stamped_idempotent (o : DomainObject) : o.stamped.stamped = o.stamped :=
  stamped_congr (unstamped_stamped o)

/-- The stamp is retrievable from the emitted object. -/
theorem stamped_hash_present (o : DomainObject) :
    (hashKey, objectHash o.unstamped) ∈ o.stamped.extensions := by
  simp [DomainObject.stamped]

/-- Stamp every object of a package. -/
def Domain.stamped (d : Domain) : Domain :=
  { d with objects := d.objects.map DomainObject.stamped }

theorem Domain.stamped_idempotent (d : Domain) : d.stamped.stamped = d.stamped := by
  have h : d.objects.map (fun o => DomainObject.stamped (DomainObject.stamped o))
      = d.objects.map DomainObject.stamped :=
    List.map_congr_left (fun a _ => a.stamped_idempotent)
  simp only [Domain.stamped, List.map_map, Function.comp_def, h]

/-- Stamping preserves the objects' identities, one for one. -/
theorem Domain.stamped_hashes (d : Domain) :
    d.stamped.objects.map (fun o => objectHash o.unstamped)
      = d.objects.map (fun o => objectHash o.unstamped) := by
  simp [Domain.stamped, List.map_map, Function.comp_def, unstamped_stamped]

end Solfunmeme.Domain
