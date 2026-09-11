import RequestProject.Kernel.Serialize
import RequestProject.Kernel.Prove

/-!
# The externalised proof engine, part 4: conformance vectors

A port of the engine — the JavaScript one in `www/prover.html`, or a future
WebAssembly one — is only worth anything if it agrees with this one.  These are
the vectors that pin the two together: concrete proof scripts, the formula each
one proves, and the exact bytes each one serialises to.

For every vector the Lean kernel checks two things here:

* the engine accepts the script and returns the stated goal (`vectors_check`);
* the goal is a tautology (`vectors_tautology`) — a consequence of
  `check_tautology`, so it holds for any script anybody writes, not just these.

`vectorsJson` renders them, and `lake exe relay-index` writes them to
`www/kernel-vectors.json`, which the browser page loads and replays.  A port
that reproduces the `wire` string and the `checks` verdict of every vector is
behaving like this engine on these inputs.
-/

namespace RequestProject.Kernel

/-! ## Two proofs -/

/-- `p`, the variable the sample proofs are about. -/
def p : Form := .var 0

/-- The identity: `p ⇒ p`, in five lines. -/
def identityScript : Script :=
  [ .axS p (.imp p p) p,
    .axK p (.imp p p),
    .mp 0 1,
    .axK p p,
    .mp 2 3 ]

/-- The identity's conclusion. -/
def identityGoal : Form := .imp p p

theorem identity_checks : check identityScript = some identityGoal := by decide

/-- Ex falso: `⊥ ⇒ p`, in seven lines, using double negation elimination. -/
def exFalsoScript : Script :=
  [ .axK .fls (.imp p .fls),
    .axDne p,
    .axK (.imp (.imp (.imp p .fls) .fls) p) .fls,
    .mp 2 1,
    .axS .fls (.imp (.imp p .fls) .fls) p,
    .mp 4 3,
    .mp 5 0 ]

/-- Ex falso's conclusion. -/
def exFalsoGoal : Form := .imp .fls p

theorem exFalso_checks : check exFalsoScript = some exFalsoGoal := by decide

/-- A script the engine rejects: modus ponens on a line that is not an
implication.  Ports must reject it too. -/
def badScript : Script := [ .axK p p, .mp 0 0 ]

theorem bad_rejected : check badScript = none := by decide

/-! ## The mutator, concretely

Substituting `⊥ ⇒ p` for the variable turns the identity proof into a proof of
`(⊥ ⇒ p) ⇒ (⊥ ⇒ p)`, by `check_subst`, with no re-search. -/

/-- The substitution the sample mutation applies. -/
def sampleSubst : Nat → Form := fun _ => .imp .fls p

theorem mutated_identity_checks :
    check (mutate sampleSubst identityScript) = some (identityGoal.subst sampleSubst) :=
  check_subst sampleSubst identity_checks

/-! ## Vectors -/

/-- One conformance vector. -/
structure Vector where
  /-- The name a port reports. -/
  name : String
  /-- The script. -/
  script : Script
  /-- What the engine should return: `some goal`, or `none` for a rejection. -/
  goal : Option Form
  deriving Repr

/-- The vectors a port must reproduce. -/
def vectors : List Vector :=
  [ ⟨"identity", identityScript, some identityGoal⟩,
    ⟨"exFalso", exFalsoScript, some exFalsoGoal⟩,
    ⟨"mutatedIdentity", mutate sampleSubst identityScript,
      some (identityGoal.subst sampleSubst)⟩,
    ⟨"badModusPonens", badScript, none⟩ ]

/-- **Every vector is what it claims to be**: the engine's verdict on each
script is the one recorded. -/
theorem vectors_check : ∀ v ∈ vectors, check v.script = v.goal := by decide

/-! ## The prover's own output

The scripts above were written by hand.  These are found by `prove`, the
verified Kalmár prover of `RequestProject.Kernel.Prove`, and published so that
a port can be pinned to it as well: a re-implementation of the *prover* must
return this script, not merely some proof of the same formula. -/

/-- A tautology with no variables — small enough that the prover's output can
be published in full. -/
def provedGoal : Form := .imp .fls .fls

theorem provedGoal_tautology : Tautology provedGoal := by decide

/-- The script the prover finds for `provedGoal`. -/
def provedScript : Script := (prove provedGoal).getD []

/-- The prover's script is accepted, and proves what was asked.  Note this is
not a computation done by the kernel: it is `prove_sound` applied to this
formula. -/
theorem proved_checks : check provedScript = some provedGoal := by
  obtain ⟨s, hs, hc⟩ := prove_complete provedGoal_tautology
  simpa [provedScript, hs] using hc

/-- The vectors a port of the *prover* must reproduce. -/
def proverVectors : List Vector := [⟨"provedFlsImpFls", provedScript, some provedGoal⟩]

/-- **Every prover vector is what it claims to be.** -/
theorem proverVectors_check : ∀ v ∈ proverVectors, check v.script = v.goal := by
  intro v hv
  simp only [proverVectors, List.mem_singleton] at hv
  subst hv
  exact proved_checks

/-- **Every vector that is accepted proves a tautology.** -/
theorem vectors_tautology : ∀ v ∈ vectors, ∀ f, v.goal = some f → Tautology f := by
  intro v hv f hf
  exact check_tautology (by rw [vectors_check v hv, hf])

/-! ## Rendering

A hand-rolled JSON writer: this module is imported by an executable that must
not drag Mathlib in, and the shapes involved are tiny. -/

/-- A JSON string literal, escaping the two characters this format can produce. -/
def jsonStr (s : String) : String :=
  "\"" ++ (s.foldl (fun acc c =>
    if c = '"' then acc ++ "\\\"" else if c = '\\' then acc ++ "\\\\" else acc.push c) "") ++ "\""

/-- A formula in prefix notation, the human-readable half of a vector. -/
def Form.toText : Form → String
  | .var n => "v" ++ toString n
  | .fls => "F"
  | .imp a b => "(" ++ a.toText ++ " => " ++ b.toText ++ ")"

/-- A step in the notation the browser page prints. -/
def Step.toText : Step → String
  | .axK a b => "K " ++ a.toText ++ " " ++ b.toText
  | .axS a b c => "S " ++ a.toText ++ " " ++ b.toText ++ " " ++ c.toText
  | .axDne a => "D " ++ a.toText
  | .mp i j => "M " ++ toString i ++ " " ++ toString j

/-- Comma-separate a list of already-rendered JSON values. -/
def joinComma : List String → String
  | [] => ""
  | [x] => x
  | x :: xs => x ++ "," ++ joinComma xs

/-- One vector as a JSON object. -/
def Vector.toJson (v : Vector) : String :=
  let steps := joinComma (v.script.map fun s => jsonStr s.toText)
  let goal := match v.goal with
    | none => "null"
    | some f => jsonStr f.toText
  "{\"name\":" ++ jsonStr v.name ++
  ",\"steps\":[" ++ steps ++ "]" ++
  ",\"goal\":" ++ goal ++
  ",\"wire\":" ++ jsonStr (String.ofList (Script.enc v.script)) ++
  ",\"accepts\":" ++ (if v.goal.isSome then "true" else "false") ++ "}"

/-- The conformance vectors as JSON. -/
def vectorsJson : String :=
  "{\"engine\":\"RequestProject.Kernel\"," ++
  "\"calculus\":\"implicational propositional logic, Hilbert K/S/DNE + modus ponens\"," ++
  "\"soundness\":\"RequestProject.Kernel.check_tautology\"," ++
  "\"vectors\":[" ++ joinComma (vectors.map Vector.toJson) ++ "]," ++
  "\"proverSoundness\":\"RequestProject.Kernel.prove_sound\"," ++
  "\"proverCompleteness\":\"RequestProject.Kernel.prove_complete\"," ++
  "\"prover\":[" ++ joinComma (proverVectors.map Vector.toJson) ++ "]}"

end RequestProject.Kernel
