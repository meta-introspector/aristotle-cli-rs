/-
# Executable checks for the codec layer

The theorems in `RequestProject/Codec/` are about *all* values; these
`#guard` checks run the same machinery on one concrete proof object, at
compile time, so that the definitions cannot drift away from what the
theorems say without the build noticing:

* the object survives every lossless codec, and its content identity is
  the same whichever of them carried it;
* detection recognises each format from its own output, an undeclared
  format is decided by signature, and a text no codec can read is kept
  verbatim instead of being rejected;
* validation reports the level an error belongs to, and resolution
  records its repairs without touching the status;
* reconciliation ignores field order and numeric spelling but not a
  changed value, and reports a conflict rather than merging one away;
* a conversion appends exactly one honest record to the ledger, and a
  chain of them appends one per step.
-/
import RequestProject.Edge.Codec.Convert

namespace CfDeploy
namespace Codec
namespace Tests

/-! ## One real proof object -/

/-- A small but complete proof object: two inputs, one output, a claim,
a certificate, a warning, provenance and metadata. -/
def sample : ProofObject :=
  { id := "proof-42"
    kind := "lean4/theorem"
    inputs :=
      [ { id := "in-1", name := "n", type := "integer", value := .int 17 }
      , { id := "in-2", name := "eps", type := "number", value := .num 5 (-3) } ]
    assumptions := ["classical choice"]
    parameters := [("depth", .int 3), ("strict", .bool true)]
    procedure := "kernel"
    outputs := [{ id := "out-1", name := "statement", value := .str "17 is prime" }]
    claims := ["Nat.Prime 17"]
    certificates := ["cert-1"]
    warnings := [{ id := "w-1", code := "SLOW", severity := .warning, message := "took a while" }]
    provenance :=
      { sourceSystem := "aristotle", sourceFile := "proof.lean", sourceFormat := "canonical"
        importedAt := "2026-01-01T00:00:00Z" }
    metadata := [("elapsedMs", .int 1234)]
    status := .valid }

def sampleVal : CVal := ProofObject.toVal sample

/-! ## The canonical model is lossless -/

#guard (ProofObject.ofVal sampleVal).map ProofObject.toVal == some sampleVal
#guard CVal.decode (CVal.encode sampleVal) == some sampleVal
#guard Canon.canon (Canon.canon sampleVal) == Canon.canon sampleVal

/-! ## Every codec that declares LOSSLESS round-trips this object -/

#guard canonicalCodec.roundTrips sampleVal
#guard ipdlCodec.roundTrips sampleVal
#guard xmlCodec.roundTrips sampleVal
#guard csvCodec.roundTrips sampleVal
#guard yamlCodec.roundTrips sampleVal

-- and the object really is in the one domain that is not everything
#guard Xml.noReserved sampleVal

-- the registry's own table, as §9 asks for it
#guard lossinessTable ==
  [("canonical", "LOSSLESS"), ("ipdl", "LOSSLESS"), ("xml", "LOSSLESS"),
   ("csv", "LOSSLESS"), ("yaml", "LOSSLESS"), ("text", "PARTIAL")]

#guard (codecNamed "yaml").isSome
#guard (codecNamed "protobuf").isNone

-- raw text does not claim losslessness, and it does not have it either
#guard textCodec.lossiness == Lossiness.partial'
#guard !textCodec.roundTrips sampleVal

/-! ## Content identity does not depend on the format it travelled in -/

def viaFormat (f : Format) : Option CVal := (codecFor f).decode ((codecFor f).encode sampleVal)

#guard (viaFormat .ipdl).map Canon.cid == some (Canon.cid sampleVal)
#guard (viaFormat .xml).map Canon.cid == some (Canon.cid sampleVal)
#guard (viaFormat .csv).map Canon.cid == some (Canon.cid sampleVal)
#guard (viaFormat .yaml).map Canon.cid == some (Canon.cid sampleVal)

-- and it is a content identity: a different object gets a different one
#guard Canon.cid sampleVal != Canon.cid (ProofObject.toVal { sample with id := "proof-43" })

/-! ## Detection -/

#guard detectFormat none (Ipdl.encode sampleVal) == ⟨.ipdl, .signature⟩
#guard detectFormat none (Xml.encode sampleVal) == ⟨.xml, .signature⟩
#guard detectFormat none (Csv.encode sampleVal) == ⟨.csv, .signature⟩
#guard detectFormat none (Yaml.encode sampleVal) == ⟨.yaml, .signature⟩
#guard detectFormat none (CVal.encode sampleVal) == ⟨.canonical, .signature⟩

-- a declaration is honoured even when the signature would say otherwise
#guard detectFormat (some "text") (Yaml.encode sampleVal) == ⟨.text, .declared⟩

-- an unknown declaration is not a guess at a different format
#guard detectFormat (some "protobuf") (Yaml.encode sampleVal) == ⟨.yaml, .signature⟩

/-! ## A file is a document, not an exact string

Almost every file ends in a newline; that must not turn a valid document
into an unparsed one. -/

def withNewline : String := Yaml.encode sampleVal ++ "\n"
def indented : String := "\n  " ++ Ipdl.encode sampleVal ++ "\n\n"

#guard (decodeAuto none withNewline).format == Format.yaml
#guard !(decodeAuto none withNewline).fellBack
#guard (decodeAuto none withNewline).value == sampleVal
-- the exact bytes that were read are still the ones recorded
#guard (decodeAuto none withNewline).source == withNewline

#guard (decodeAuto none indented).format == Format.ipdl
#guard (decodeAuto none indented).value == sampleVal
#guard (decodeAuto (some "ipdl") indented).value == sampleVal

-- and validation agrees with the decoder, rather than contradicting it
#guard (Validate.validate .yaml withNewline sample).syntax'.isEmpty

/-! ## A text nothing can parse is kept, not rejected -/

def junk : String := "%%% not any format we know %%%\nsecond line\n"

#guard (decodeAuto none junk).format == Format.text
#guard (decodeAuto none junk).source == junk
#guard (Text.RawText.ofVal (decodeAuto none junk).value).text == junk

-- declaring a format that cannot read it falls back rather than failing
#guard (decodeAuto (some "ipdl") junk).fellBack
#guard (Text.RawText.ofVal (decodeAuto (some "ipdl") junk).value).text == junk

-- and the import keeps it too
#guard (Convert.import' none junk).sourceData == junk

/-! ## Validation -/

#guard (Validate.validate .canonical (CVal.encode sampleVal) sample).syntax'.isEmpty

-- a complete object passes every level
#guard (Validate.validateObject { sample with status := .unknown }).ok

-- a missing identifier is a *structure* error, and nothing else
#guard (Validate.validateObject { sample with id := "" }).structure'.length == 1
#guard (Validate.validateObject { sample with id := "" }).type'.isEmpty

-- two inputs with the same id is a *type* error
#guard !(Validate.validateObject
  { sample with inputs := sample.inputs ++ [{ id := "in-1", name := "n" }] }).type'.isEmpty

-- INVALID with no error to explain it is a *semantic* error
#guard !(Validate.validateObject { sample with status := .invalid, errors := [] }).semantics.isEmpty

-- a syntax error is reported against the text, not invented from the object
#guard !(Validate.validate .ipdl junk sample).syntax'.isEmpty

/-! ## Resolution repairs, records and leaves the status alone -/

def coercible : ProofObject :=
  { sample with
      status := .valid
      inputs := [{ id := "in-1", name := "n", type := "integer", value := .str "17" }] }

#guard (Validate.resolve coercible).repairs.length == 1
#guard (Validate.resolve coercible).object.status == coercible.status
#guard (Validate.resolve coercible).object.inputs.head!.value == CVal.int 17
#guard (Validate.resolve coercible).diagnostics.length == 1
#guard (Validate.resolve coercible).diagnostics.head!.code == "RESOLVED_COERCED"
-- the original value is kept alongside the repaired one, not thrown away
#guard (Validate.resolve coercible).repairs.head!.original == CVal.str "17"
#guard (Validate.resolve coercible).repairs.head!.resolved == CVal.int 17

/-! ## Reconciliation -/

def reordered : CVal :=
  match sampleVal with
  | .obj fs => .obj fs.reverse
  | v => v

-- field order is not a semantic difference; a changed value is
#guard Reconcile.semanticEq sampleVal reordered
#guard (Reconcile.differences sampleVal reordered).isEmpty
#guard Reconcile.verdict sampleVal reordered true true == Reconcile.Verdict.equivalent

def changed : CVal := ProofObject.toVal { sample with claims := ["Nat.Prime 19"] }

#guard !Reconcile.semanticEq sampleVal changed
#guard !(Reconcile.differences sampleVal changed).isEmpty
#guard Reconcile.verdict sampleVal changed true true == Reconcile.Verdict.conflict

-- numeric spelling is not a difference either: 5e-3 written as 50e-4
#guard Reconcile.semanticEq (.num 5 (-3)) (.num 50 (-4))

-- a conflict is reported, never merged away by default
#guard (Reconcile.resolveConflict .manual sampleVal changed true true).outcome.isNone
#guard (Reconcile.resolveConflict .manual sampleVal changed true true).verdict ==
  Reconcile.Verdict.conflict
#guard !(Reconcile.resolveConflict .manual sampleVal changed true true).differences.isEmpty
-- neither is an incomplete comparison mistaken for agreement
#guard Reconcile.verdict sampleVal changed true false == Reconcile.Verdict.incomplete

/-! ## Conversion: one honest record per step -/

def yamlText : String := Yaml.encode sampleVal

def toCsv : Convert.Outcome := Convert.convert (some "yaml") .csv "2026-01-02T00:00:00Z" yamlText

#guard toCsv.detection == ⟨.yaml, .declared⟩
#guard !toCsv.fellBack
#guard toCsv.record.lossiness == Lossiness.lossless
#guard toCsv.record.source == "yaml" && toCsv.record.target == "csv"
#guard toCsv.record.codec == "csv" && toCsv.record.codecVersion == "1.0"
#guard Convert.ledger toCsv.object == ["yaml->csv csv/1.0 LOSSLESS 2026-01-02T00:00:00Z"]

-- the text really does read back as the object that was written
#guard csvCodec.decode toCsv.text == some (ProofObject.toVal toCsv.object)

-- what the object says about itself is untouched by the conversion
#guard toCsv.object.status == sample.status
#guard toCsv.object.id == sample.id
#guard toCsv.object.claims == sample.claims

-- a conversion out of an unparseable text is recorded as PARTIAL, not as
-- a success and not as a failure to import
#guard (Convert.convert none .yaml "" junk).record.lossiness == Lossiness.partial'
#guard (Convert.convert none .yaml "" junk).object.sourceData == junk

-- so is a conversion *into* raw text
#guard (Convert.convert (some "yaml") .text "" yamlText).record.lossiness == Lossiness.partial'

/-! ## A chain of conversions: every step recorded, nothing rewritten -/

def chained : Option Convert.Outcome :=
  Convert.pipeline (some "yaml") "t" yamlText [.csv, .ipdl, .canonical]

#guard (chained.map (fun o => (Convert.ledger o.object).length)) == some 3
#guard (chained.map (fun o => Convert.ledger o.object)) ==
  some [ "yaml->csv csv/1.0 LOSSLESS t"
       , "csv->ipdl ipdl/1.0 LOSSLESS t"
       , "ipdl->canonical canonical/1.0 LOSSLESS t" ]

-- and the object at the end of the chain is still the object that
-- entered it: same minimum profile, same content
#guard (chained.map (fun o => o.object.id)) == some sample.id
#guard (chained.map (fun o => o.object.status)) == some sample.status
#guard (chained.map (fun o => o.object.claims)) == some sample.claims
#guard (chained.map (fun o => o.object.inputs.map (fun i => i.value))) ==
  some (sample.inputs.map (fun i => i.value))
#guard (chained.map (fun o => Canon.cid (ProofObject.toVal
  { o.object with provenance := sample.provenance, sourceFormat := "", sourceData := "" }))) ==
  some (Canon.cid sampleVal)

end Tests
end Codec
end CfDeploy
