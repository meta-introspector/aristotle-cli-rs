import RequestProject.Kernel.Check
import RequestProject.Relay.Core

/-!
# The externalised proof engine, part 3: proofs as bytes

A proof script is only *external* if it can leave the process that made it.
This file gives the engine a wire format — a flat string of printable ASCII —
and proves it lossless: `Script.dec_enc` says a script written out and read back
is the script you started with.

The format is deliberately trivial to re-implement:

```
nat     ::= digit* '.'            -- little-endian decimal, '.' terminates
formula ::= 'v' nat | 'f' | 'i' formula formula
step    ::= 'K' formula formula | 'S' formula formula formula
          | 'D' formula | 'M' nat nat
script  ::= nat step*             -- the nat is the number of steps
```

Reading is one left-to-right pass with an explicit fuel bound, so a port needs
neither recursion depth guarantees nor a garbage collector.

`Script.enc_ok` records that every character the format emits lies between `.`
(46) and `v` (118).  That is what connects the engine to the relay: such a
string is encodable in the relay's three-digits-per-character payload and never
collides with the block separator, so `RequestProject.Relay.ProofCarrying` can
put a proof into the cargo of all twenty-two programs.
-/

namespace RequestProject.Kernel

open RequestProject.Relay (digitChar digitVal? digitVal?_digitChar toNat_digitChar Codeable sep)

/-! ## Natural numbers -/

/-- A natural number as little-endian decimal digits (empty for zero). -/
def digitsRev : Nat → List Char
  | 0 => []
  | n + 1 => digitChar ((n + 1) % 10) :: digitsRev ((n + 1) / 10)
  decreasing_by omega

/-- A natural number, terminated by `.`. -/
def encNat (n : Nat) : List Char := digitsRev n ++ ['.']

/-- Read a `.`-terminated little-endian decimal number. -/
def parseNat : List Char → Option (Nat × List Char)
  | [] => none
  | c :: rest =>
      if c = '.' then some (0, rest)
      else
        match digitVal? c with
        | none => none
        | some d =>
            match parseNat rest with
            | none => none
            | some (v, r) => some (d + 10 * v, r)

theorem digitChar_ne_dot {k : Nat} (h : k < 10) : digitChar k ≠ '.' := by
  intro he
  have h1 : (digitChar k).toNat = 48 + k := toNat_digitChar h
  rw [he] at h1
  simp [Char.toNat] at h1
  omega

/-- **Numbers round-trip.** -/
theorem parseNat_encNat (n : Nat) (rest : List Char) :
    parseNat (encNat n ++ rest) = some (n, rest) := by
  induction n using Nat.strongRecOn with
  | _ n ih =>
      match n with
      | 0 => simp [encNat, digitsRev, parseNat]
      | m + 1 =>
          have hlt : (m + 1) / 10 < m + 1 := by omega
          have hmod : (m + 1) % 10 < 10 := Nat.mod_lt _ (by omega)
          have hrec := ih ((m + 1) / 10) hlt
          simp only [encNat, digitsRev, List.cons_append, parseNat,
            if_neg (digitChar_ne_dot hmod), digitVal?_digitChar hmod]
          simp only [encNat] at hrec
          rw [hrec]
          simp only []
          congr 2
          exact Nat.mod_add_div (m + 1) 10

/-! ## Formulas -/

/-- A formula on the wire. -/
def Form.enc : Form → List Char
  | .var n => 'v' :: encNat n
  | .fls => ['f']
  | .imp a b => 'i' :: (a.enc ++ b.enc)

/-- Read a formula.  `fuel` bounds the recursion; `Form.dec_enc` needs only
`fuel ≥ Form.size`, and `Script.dec` passes the length of the whole input. -/
def Form.dec : Nat → List Char → Option (Form × List Char)
  | 0, _ => none
  | _ + 1, [] => none
  | fuel + 1, c :: rest =>
      if c = 'v' then (parseNat rest).map (fun p => (Form.var p.1, p.2))
      else if c = 'f' then some (Form.fls, rest)
      else if c = 'i' then
        match Form.dec fuel rest with
        | none => none
        | some (a, r1) =>
            match Form.dec fuel r1 with
            | none => none
            | some (b, r2) => some (Form.imp a b, r2)
      else none

/-- **Formulas round-trip**, given enough fuel. -/
theorem Form.dec_enc : ∀ (fuel : Nat) (a : Form) (rest : List Char),
    a.size ≤ fuel → Form.dec fuel (a.enc ++ rest) = some (a, rest) := by
  intro fuel
  induction fuel with
  | zero => intro a _ h; have := Form.size_pos a; omega
  | succ fuel ih =>
      intro a rest h
      cases a with
      | var n => simp [Form.enc, Form.dec, parseNat_encNat]
      | fls => simp [Form.enc, Form.dec]
      | imp a b =>
          have ha : a.size ≤ fuel := by simp only [Form.size] at h; omega
          have hb : b.size ≤ fuel := by simp only [Form.size] at h; omega
          have h1 := ih a (b.enc ++ rest) ha
          have h2 := ih b rest hb
          simp only [Form.enc, List.cons_append, Form.dec, List.append_assoc, h1, h2]
          simp

/-! ## Steps and scripts -/

/-- A step on the wire. -/
def Step.enc : Step → List Char
  | .axK a b => 'K' :: (a.enc ++ b.enc)
  | .axS a b c => 'S' :: (a.enc ++ b.enc ++ c.enc)
  | .axDne a => 'D' :: a.enc
  | .mp i j => 'M' :: (encNat i ++ encNat j)

/-- The fuel a step needs: one more than the sizes of the formulas in it. -/
def Step.size : Step → Nat
  | .axK a b => a.size + b.size + 1
  | .axS a b c => a.size + b.size + c.size + 1
  | .axDne a => a.size + 1
  | .mp _ _ => 1

/-- Read a step. -/
def Step.dec (fuel : Nat) : List Char → Option (Step × List Char)
  | [] => none
  | c :: rest =>
      if c = 'K' then
        match Form.dec fuel rest with
        | none => none
        | some (a, r1) =>
            match Form.dec fuel r1 with
            | none => none
            | some (b, r2) => some (Step.axK a b, r2)
      else if c = 'S' then
        match Form.dec fuel rest with
        | none => none
        | some (a, r1) =>
            match Form.dec fuel r1 with
            | none => none
            | some (b, r2) =>
                match Form.dec fuel r2 with
                | none => none
                | some (d, r3) => some (Step.axS a b d, r3)
      else if c = 'D' then
        match Form.dec fuel rest with
        | none => none
        | some (a, r1) => some (Step.axDne a, r1)
      else if c = 'M' then
        match parseNat rest with
        | none => none
        | some (i, r1) =>
            match parseNat r1 with
            | none => none
            | some (j, r2) => some (Step.mp i j, r2)
      else none

theorem Step.dec_enc (fuel : Nat) (s : Step) (rest : List Char) (h : s.size ≤ fuel) :
    Step.dec fuel (s.enc ++ rest) = some (s, rest) := by
  cases s with
  | axK a b =>
      have ha : a.size ≤ fuel := by simp only [Step.size] at h; omega
      have hb : b.size ≤ fuel := by simp only [Step.size] at h; omega
      simp only [Step.enc, List.cons_append, Step.dec, List.append_assoc,
        Form.dec_enc fuel a _ ha, Form.dec_enc fuel b rest hb]
      simp
  | axS a b c =>
      have ha : a.size ≤ fuel := by simp only [Step.size] at h; omega
      have hb : b.size ≤ fuel := by simp only [Step.size] at h; omega
      have hc : c.size ≤ fuel := by simp only [Step.size] at h; omega
      simp only [Step.enc, List.cons_append, Step.dec, List.append_assoc,
        Form.dec_enc fuel a _ ha, Form.dec_enc fuel b _ hb, Form.dec_enc fuel c rest hc]
      simp
  | axDne a =>
      have ha : a.size ≤ fuel := by simp only [Step.size] at h; omega
      simp only [Step.enc, List.cons_append, Step.dec, Form.dec_enc fuel a rest ha]
      simp
  | mp i j =>
      simp only [Step.enc, List.cons_append, Step.dec, List.append_assoc,
        parseNat_encNat i, parseNat_encNat j]
      simp

/-- Read `n` steps in a row. -/
def decSteps (fuel : Nat) : Nat → List Char → Option (List Step × List Char)
  | 0, l => some ([], l)
  | n + 1, l =>
      match Step.dec fuel l with
      | none => none
      | some (s, r) =>
          match decSteps fuel n r with
          | none => none
          | some (ss, r2) => some (s :: ss, r2)

theorem decSteps_enc (fuel : Nat) : ∀ (script : Script) (rest : List Char),
    (∀ s ∈ script, s.size ≤ fuel) →
      decSteps fuel script.length (script.flatMap Step.enc ++ rest) = some (script, rest) := by
  intro script
  induction script with
  | nil => intro rest _; simp [decSteps]
  | cons s tl ih =>
      intro rest h
      have hs : s.size ≤ fuel := h s (by simp)
      have htl := ih rest (fun t ht => h t (by simp [ht]))
      simp only [List.flatMap_cons, List.length_cons, decSteps, List.append_assoc,
        Step.dec_enc fuel s _ hs, htl]

/-- A script on the wire: the number of steps, then the steps. -/
def Script.enc (script : Script) : List Char :=
  encNat script.length ++ script.flatMap Step.enc

/-- Read a script.  The fuel is the length of the input, which
`Script.dec_enc` shows is always enough for a string this format produced. -/
def Script.dec (l : List Char) : Option Script :=
  match parseNat l with
  | none => none
  | some (n, r) =>
      match decSteps l.length n r with
      | none => none
      | some (script, _) => some script

/-! ### The fuel bound -/

theorem Form.size_le_enc_length : ∀ a : Form, a.size ≤ a.enc.length := by
  intro a
  induction a with
  | var n => simp [Form.size, Form.enc, encNat]
  | fls => simp [Form.size, Form.enc]
  | imp a b iha ihb => simp only [Form.size, Form.enc, List.length_cons, List.length_append]; omega

theorem Step.size_le_enc_length (s : Step) : s.size ≤ s.enc.length := by
  cases s with
  | axK a b =>
      have := Form.size_le_enc_length a
      have := Form.size_le_enc_length b
      simp only [Step.size, Step.enc, List.length_cons, List.length_append]; omega
  | axS a b c =>
      have := Form.size_le_enc_length a
      have := Form.size_le_enc_length b
      have := Form.size_le_enc_length c
      simp only [Step.size, Step.enc, List.length_cons, List.length_append]; omega
  | axDne a =>
      have := Form.size_le_enc_length a
      simp only [Step.size, Step.enc, List.length_cons]; omega
  | mp i j => simp [Step.size, Step.enc]

theorem Step.enc_length_le_flatMap : ∀ (script : Script) (s : Step), s ∈ script →
    s.enc.length ≤ (script.flatMap Step.enc).length := by
  intro script
  induction script with
  | nil => intro s hs; exact absurd hs (by simp)
  | cons t tl ih =>
      intro s hs
      simp only [List.flatMap_cons, List.length_append]
      rcases List.mem_cons.1 hs with rfl | hs
      · omega
      · have := ih s hs; omega

/-- **Scripts round-trip.**  A proof written out in the wire format and read
back is the proof you started with — so a proof can be shipped as bytes through
any channel that preserves printable ASCII, the relay's cargo included. -/
theorem Script.dec_enc (script : Script) : Script.dec script.enc = some script := by
  have hfuel : ∀ s ∈ script, s.size ≤ (Script.enc script).length := by
    intro s hs
    have h1 := Step.size_le_enc_length s
    have h2 := Step.enc_length_le_flatMap script s hs
    simp only [Script.enc, List.length_append]
    omega
  have hparse : parseNat (Script.enc script)
      = some (script.length, script.flatMap Step.enc) := by
    simpa [Script.enc] using parseNat_encNat script.length (script.flatMap Step.enc)
  have hsteps := decSteps_enc (Script.enc script).length script [] hfuel
  simp only [Script.dec, hparse]
  simp only [List.append_nil] at hsteps
  rw [hsteps]

/-! ## The characters the format uses -/

/-- Every character the wire format emits is printable ASCII between `.` and
`v`. -/
def okChar (c : Char) : Bool := 46 ≤ c.toNat && c.toNat ≤ 118

theorem okChar_digitsRev : ∀ n : Nat, ∀ c ∈ digitsRev n, okChar c := by
  intro n
  induction n using Nat.strongRecOn with
  | _ n ih =>
      match n with
      | 0 => simp [digitsRev]
      | m + 1 =>
          intro c hc
          simp only [digitsRev, List.mem_cons] at hc
          rcases hc with rfl | hc
          · have : (digitChar ((m + 1) % 10)).toNat = 48 + (m + 1) % 10 :=
              toNat_digitChar (Nat.mod_lt _ (by omega))
            simp only [okChar, this, Bool.and_eq_true, decide_eq_true_eq]
            have : (m + 1) % 10 < 10 := Nat.mod_lt _ (by omega)
            omega
          · exact ih ((m + 1) / 10) (by omega) c hc

theorem okChar_encNat (n : Nat) : ∀ c ∈ encNat n, okChar c := by
  intro c hc
  rcases List.mem_append.1 hc with hc | hc
  · exact okChar_digitsRev n c hc
  · simp only [List.mem_cons, List.not_mem_nil, or_false] at hc
    subst hc
    decide

theorem okChar_Form_enc : ∀ (a : Form), ∀ c ∈ a.enc, okChar c := by
  intro a
  induction a with
  | var n =>
      intro c hc
      simp only [Form.enc, List.mem_cons] at hc
      rcases hc with rfl | hc
      · decide
      · exact okChar_encNat n c hc
  | fls => intro c hc; simp only [Form.enc, List.mem_cons, List.not_mem_nil, or_false] at hc
           subst hc; decide
  | imp a b iha ihb =>
      intro c hc
      simp only [Form.enc, List.mem_cons, List.mem_append] at hc
      rcases hc with rfl | hc | hc
      · decide
      · exact iha c hc
      · exact ihb c hc

theorem okChar_Step_enc (s : Step) : ∀ c ∈ s.enc, okChar c := by
  cases s with
  | axK a b =>
      intro c hc
      simp only [Step.enc, List.mem_cons, List.mem_append] at hc
      rcases hc with rfl | hc | hc
      · decide
      · exact okChar_Form_enc a c hc
      · exact okChar_Form_enc b c hc
  | axS a b d =>
      intro c hc
      simp only [Step.enc, List.mem_cons] at hc
      rcases hc with rfl | hc
      · decide
      · rcases List.mem_append.1 hc with hc | hc
        · rcases List.mem_append.1 hc with hc | hc
          · exact okChar_Form_enc a c hc
          · exact okChar_Form_enc b c hc
        · exact okChar_Form_enc d c hc
  | axDne a =>
      intro c hc
      simp only [Step.enc, List.mem_cons] at hc
      rcases hc with rfl | hc
      · decide
      · exact okChar_Form_enc a c hc
  | mp i j =>
      intro c hc
      simp only [Step.enc, List.mem_cons, List.mem_append] at hc
      rcases hc with rfl | hc | hc
      · decide
      · exact okChar_encNat i c hc
      · exact okChar_encNat j c hc

/-- **The wire format stays inside printable ASCII.** -/
theorem Script.enc_ok (script : Script) : ∀ c ∈ script.enc, okChar c := by
  intro c hc
  rcases List.mem_append.1 hc with hc | hc
  · exact okChar_encNat script.length c hc
  · simp only [List.mem_flatMap] at hc
    obtain ⟨s, _, hs⟩ := hc
    exact okChar_Step_enc s c hs

/-- The wire format is carriable by the relay: its characters are encodable in
the payload and none of them is the block separator. -/
theorem Script.enc_codeable (script : Script) :
    (∀ c ∈ script.enc, Codeable c) ∧ sep ∉ script.enc := by
  refine ⟨fun c hc => ?_, fun hc => ?_⟩
  · have := Script.enc_ok script c hc
    simp only [okChar, Bool.and_eq_true, decide_eq_true_eq] at this
    exact Nat.lt_of_le_of_lt this.2 (by omega)
  · have := Script.enc_ok script sep hc
    simp only [okChar, sep, Bool.and_eq_true, decide_eq_true_eq] at this
    have h1 : (Char.ofNat 1).toNat = 1 := RequestProject.Relay.toNat_ofNat_of_lt (by omega)
    omega

end RequestProject.Kernel
