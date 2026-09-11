/-
# The codec registry

Section 9 of the specification is a rule about honesty:

> A codec MUST NOT claim losslessness unless the complete semantic
> object survives the conversion.

Here that rule is a *type*.  A `StringCodec` cannot be built without
supplying `lossless_on_domain`, a proof that if the codec declares
`LOSSLESS` then decoding its encoding of any value in its declared
domain returns exactly that value.  A codec that cannot prove it must
declare `PARTIAL` or `LOSSY` instead — and then the obligation is
vacuous, which is the correct outcome.

The registry below therefore *is* the conformance table: what is listed
as lossless has a machine-checked proof behind it.
-/
import RequestProject.Edge.Codec.Ipdl
import RequestProject.Edge.Codec.XmlMap
import RequestProject.Edge.Codec.Csv
import RequestProject.Edge.Codec.Yaml
import RequestProject.Edge.Codec.Text

namespace CfDeploy
namespace Codec

/-! ## A codec, with its obligation -/

/-- A codec between canonical values and strings, carrying its declared
preservation level and the proof that the declaration is true. -/
structure StringCodec where
  /-- the codec's name, as it appears in an envelope -/
  name : String
  /-- the codec's version, as it appears in a transformation record -/
  version : String
  /-- the values the codec claims to represent -/
  domain : CVal → Bool
  encode : CVal → String
  decode : String → Option CVal
  /-- the declared preservation level of `canonical → target` -/
  lossiness : Lossiness
  /-- **The obligation.**  Declaring `LOSSLESS` requires a proof. -/
  lossless_on_domain :
    lossiness = .lossless → ∀ v : CVal, domain v = true → decode (encode v) = some v

namespace StringCodec

/-- Every value is in the domain. -/
def total : CVal → Bool := fun _ => true

/-- The round-trip test of §17, as something that can actually be run. -/
def roundTrips (c : StringCodec) (v : CVal) : Bool := c.decode (c.encode v) == some v

/-- Decoding a *document* rather than an exact string: whitespace around
the text is not part of it, so a file that ends in a newline — which is
to say almost every file — is read rather than refused.  The codec's own
`decode` is tried first, so nothing about an exact encoding changes. -/
def decodeDoc (c : StringCodec) (s : String) : Option CVal :=
  match c.decode s with
  | some v => some v
  | none => c.decode s.trimAscii.toString

/-- **Tolerating whitespace does not weaken the round trip.** -/
theorem decodeDoc_encode (c : StringCodec) (h : c.lossiness = .lossless)
    (v : CVal) (hv : c.domain v = true) : c.decodeDoc (c.encode v) = some v := by
  simp [decodeDoc, c.lossless_on_domain h v hv]

/-- **A document that the codec proper can read is read the same way.** -/
theorem decodeDoc_of_decode {c : StringCodec} {s : String} {v : CVal}
    (h : c.decode s = some v) : c.decodeDoc s = some v := by
  simp [decodeDoc, h]

/-- **§17 for the lossless codecs.**  The executable round-trip test
passes for every value in the domain of a codec that declares
`LOSSLESS`. -/
theorem roundTrips_of_lossless (c : StringCodec) (h : c.lossiness = .lossless)
    (v : CVal) (hv : c.domain v = true) : c.roundTrips v = true := by
  simp [roundTrips, c.lossless_on_domain h v hv]

end StringCodec

/-! ## The codecs -/

/-- The canonical serialization itself: deterministic, and what the
content hash is taken over. -/
def canonicalCodec : StringCodec where
  name := "canonical"
  version := "1.0"
  domain := StringCodec.total
  encode := CVal.encode
  decode := CVal.decode
  lossiness := .lossless
  lossless_on_domain := fun _ v _ => CVal.decode_encode v

/-- IPDL, the native structured interchange codec. -/
def ipdlCodec : StringCodec where
  name := "ipdl"
  version := "1.0"
  domain := StringCodec.total
  encode := Ipdl.encode
  decode := Ipdl.decode
  lossiness := .lossless
  lossless_on_domain := fun _ v _ => Ipdl.decode_encode v

/-- XML.  The domain excludes the values that themselves use the
reserved `@xml.*` shape, which is how foreign XML is carried. -/
def xmlCodec : StringCodec where
  name := "xml"
  version := "1.0"
  domain := Xml.noReserved
  encode := Xml.encode
  decode := Xml.decode
  lossiness := .lossless
  lossless_on_domain := fun _ v hv => Xml.decode_encode v hv

/-- CSV, the tabular projection. -/
def csvCodec : StringCodec where
  name := "csv"
  version := "1.0"
  domain := StringCodec.total
  encode := Csv.encode
  decode := Csv.decode
  lossiness := .lossless
  lossless_on_domain := fun _ v _ => Csv.decode_encode v

/-- YAML, flow style. -/
def yamlCodec : StringCodec where
  name := "yaml"
  version := "1.0"
  domain := StringCodec.total
  encode := Yaml.encode
  decode := Yaml.decode
  lossiness := .lossless
  lossless_on_domain := fun _ v _ => Yaml.decode_encode v

/-- Raw text.  Encoding writes the block-style rendering, which is for
human eyes; decoding preserves the text and whatever detection found.
This is a `PARTIAL` conversion and does not claim otherwise. -/
def textCodec : StringCodec where
  name := "text"
  version := "1.0"
  domain := StringCodec.total
  encode := Yaml.block
  decode := fun s => some (Text.RawText.toVal (Text.detect s))
  lossiness := .partial'
  lossless_on_domain := by intro h; simp at h

/-- Every codec of the standard profile. -/
def codecs : List StringCodec :=
  [canonicalCodec, ipdlCodec, xmlCodec, csvCodec, yamlCodec, textCodec]

/-- Look a codec up by name. -/
def codecNamed (n : String) : Option StringCodec :=
  codecs.find? (fun c => c.name == n)

/-- **§9, for the whole registry.**  Nothing in the registry claims a
losslessness it cannot deliver. -/
theorem registry_lossless_claims_are_true (c : StringCodec) (_ : c ∈ codecs)
    (h : c.lossiness = .lossless) (v : CVal) (hv : c.domain v = true) :
    c.decode (c.encode v) = some v :=
  c.lossless_on_domain h v hv

/-- The preservation level each codec declares, as the specification's
table in §9. -/
def lossinessTable : List (String × String) :=
  codecs.map (fun c => (c.name, c.lossiness.toString))

end Codec
end CfDeploy
