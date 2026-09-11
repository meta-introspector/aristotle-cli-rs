import RequestProject.Gvcs.FabLab

/-!
# The proof checker that runs on the machine the fab built

`RequestProject/FabLab.lean` ends with a computer standing on the bench.  This
file puts something on it: a **proof checker**, small enough to be written out
in full, and proved correct.

The logic is the smallest one worth having — implication and falsity — and the
checker is a total function

    `check : List Form → Cert → Option Form`

which reads a certificate (the bytes in the machine's memory) and either
returns the formula that certificate proves or refuses.  Everything else in
the file is about two questions.

**Is the machine to be trusted?**  `check_sound`: whenever the checker returns
a formula, that formula is true in every world in which the axioms it was
given are true.  From it: a certificate checked against no axioms at all
yields a tautology (`provable_nil_valid`), and no certificate whatsoever
yields a contradiction (`consistent`).

**Does the machine create anything?**  No, and that is the point.
`checker_adds_nothing` says the checker's output is always something the
axioms already entailed: the machine rearranges what was given to it, exactly
as the fab rearranges ore.  `truth_is_prior` is the same statement read
backwards — if a formula is false in the world, then no certificate, however
long, will make the machine print it.  A proof is not a source of truth; it is
a path through truth that already existed.

And the path costs something.  `energyOf` charges every elementary step of the
checker at `stepEnergy` kilowatt-hours; `woodFor` converts that into
kilograms of firewood through the wood-gas set of
`RequestProject/Sources.lean`, and `forestFor` into square metres of coppice.
`no_free_proof`: every certificate, including the empty-handed one, costs a
strictly positive amount of wood.  The mathematics is not conjured; it is paid
for out of the ground, like the machine that checks it.

The energy figures are illustrative of a small computer — 0.108 microjoules
per elementary step, which is a 30 W machine running at a gigahertz — but
every consequence drawn from them is proved.
-/

namespace LifeTrac
namespace Checker

/-! ## The logic -/

/-- A formula of the propositional logic the machine understands: atoms,
falsity, implication. -/
inductive Form where
  /-- The `n`-th atomic claim about the world. -/
  | atom : ℕ → Form
  /-- Falsity. -/
  | fls : Form
  /-- Implication. -/
  | imp : Form → Form → Form
  deriving DecidableEq, Repr, Inhabited

namespace Form

/-- The truth value of a formula in a world `v`, which assigns a truth value
to each atom. -/
def eval (v : ℕ → Bool) : Form → Bool
  | atom n => v n
  | fls => false
  | imp a b => !(eval v a) || eval v b

@[simp] theorem eval_atom (v : ℕ → Bool) (n : ℕ) : (atom n).eval v = v n := rfl

@[simp] theorem eval_fls (v : ℕ → Bool) : fls.eval v = false := rfl

@[simp] theorem eval_imp (v : ℕ → Bool) (a b : Form) :
    (a.imp b).eval v = (!(a.eval v) || b.eval v) := rfl

/-- The negation of a formula. -/
def neg (a : Form) : Form := a.imp fls

@[simp] theorem eval_neg (v : ℕ → Bool) (a : Form) : (neg a).eval v = !(a.eval v) := by
  simp [neg]

end Form

open Form

/-- A formula true in every world. -/
def Valid (φ : Form) : Prop := ∀ v : ℕ → Bool, φ.eval v = true

/-- `Entails Γ φ`: in every world in which all of `Γ` holds, `φ` holds.  This
is truth, prior to any machine. -/
def Entails (Γ : List Form) (φ : Form) : Prop :=
  ∀ v : ℕ → Bool, (∀ ψ ∈ Γ, ψ.eval v = true) → φ.eval v = true

theorem entails_nil_iff (φ : Form) : Entails [] φ ↔ Valid φ := by
  constructor
  · intro h v; exact h v (by simp)
  · intro h v _; exact h v

/-! ## The certificate format and the checker -/

/-- A certificate: the data the machine reads.  Four kinds of leaf — a
reference to one of the axioms it was handed, and the three Hilbert schemes —
and one rule, modus ponens. -/
inductive Cert where
  /-- The `i`-th axiom of the list the checker was given. -/
  | hyp : ℕ → Cert
  /-- The scheme `a → (b → a)`. -/
  | k : Form → Form → Cert
  /-- The scheme `(a → (b → c)) → ((a → b) → (a → c))`. -/
  | s : Form → Form → Form → Cert
  /-- The scheme `¬¬a → a`. -/
  | dne : Form → Cert
  /-- Modus ponens: detach the conclusion of an implication. -/
  | mp : Cert → Cert → Cert
  deriving Repr, Inhabited

/-- **The checker.**  A total function: it reads a certificate and returns the
formula it proves, or `none` if the certificate is malformed.  This is the
whole program that runs on the machine. -/
def check (Γ : List Form) : Cert → Option Form
  | .hyp i => Γ[i]?
  | .k a b => some (a.imp (b.imp a))
  | .s a b c => some ((a.imp (b.imp c)).imp ((a.imp b).imp (a.imp c)))
  | .dne a => some ((neg (neg a)).imp a)
  | .mp p q =>
      match check Γ p, check Γ q with
      | some (.imp x y), some z => if x = z then some y else none
      | _, _ => none

/-- `Provable Γ φ`: some certificate makes the machine print `φ`. -/
def Provable (Γ : List Form) (φ : Form) : Prop := ∃ c : Cert, check Γ c = some φ

/-! ## The machine is sound -/

private theorem bool_k (x y : Bool) : (!x || (!y || x)) = true := by
  cases x <;> cases y <;> rfl

private theorem bool_s (x y z : Bool) :
    (!(!x || (!y || z)) || (!(!x || y) || (!x || z))) = true := by
  cases x <;> cases y <;> cases z <;> rfl

private theorem bool_mp {x y : Bool} (h : (!x || y) = true) (hx : x = true) : y = true := by
  subst hx; simpa using h

/-- **The checker never lies.**  If it returns `φ` from the axioms `Γ`, then
`φ` is true in every world in which every axiom of `Γ` is true. -/
theorem check_sound (Γ : List Form) (v : ℕ → Bool) (hΓ : ∀ ψ ∈ Γ, ψ.eval v = true) :
    ∀ (c : Cert) (φ : Form), check Γ c = some φ → φ.eval v = true := by
  intro c
  induction c with
  | hyp i =>
      intro φ h
      exact hΓ φ (List.mem_of_getElem? h)
  | k a b =>
      intro φ h
      cases h
      simpa using bool_k (a.eval v) (b.eval v)
  | s a b c =>
      intro φ h
      cases h
      simpa using bool_s (a.eval v) (b.eval v) (c.eval v)
  | dne a =>
      intro φ h
      cases h
      simp
  | mp p q ihp ihq =>
      intro φ h
      simp only [check] at h
      split at h
      · rename_i x y z hp hq
        by_cases hxz : x = z
        · subst hxz
          rw [if_pos rfl] at h
          cases h
          have h1 := ihp _ hp
          have h2 := ihq _ hq
          rw [Form.eval_imp] at h1
          exact bool_mp h1 h2
        · rw [if_neg hxz] at h
          exact absurd h (by simp)
      · exact absurd h (by simp)

/-- **Everything the machine prints was already entailed.**  The checker is
not a source of truth: its output is a semantic consequence of the axioms it
was handed, and nothing else. -/
theorem checker_adds_nothing (Γ : List Form) (φ : Form) (h : Provable Γ φ) : Entails Γ φ := by
  obtain ⟨c, hc⟩ := h
  intro v hv
  exact check_sound Γ v hv c φ hc

/-- **Truth comes first.**  If a formula is false in some world in which the
axioms hold, then no certificate — of any length, on any machine — will make
the checker print it. -/
theorem truth_is_prior (Γ : List Form) (φ : Form) (v : ℕ → Bool)
    (hv : ∀ ψ ∈ Γ, ψ.eval v = true) (hfalse : φ.eval v = false) : ¬ Provable Γ φ := by
  intro h
  have := checker_adds_nothing Γ φ h v hv
  rw [hfalse] at this
  exact Bool.false_ne_true this

/-- A certificate checked against no axioms yields a tautology. -/
theorem provable_nil_valid (φ : Form) (h : Provable [] φ) : Valid φ :=
  (entails_nil_iff φ).1 (checker_adds_nothing [] φ h)

/-- **The machine cannot be made to prove a contradiction.** -/
theorem consistent : ¬ Provable [] fls := by
  intro h
  have := provable_nil_valid fls h (fun _ => false)
  simp at this

/-- The machine's world is not one in which everything holds: no certificate
proves an atom out of nothing. -/
theorem atom_not_provable (n : ℕ) : ¬ Provable [] (atom n) := by
  intro h
  have := provable_nil_valid (atom n) h (fun _ => false)
  simp at this

/-! ## Running it

Two runs of the checker, both carried out by `check` itself and not by hand.
The first proves a tautology out of nothing; the second draws a conclusion
about the workshop from two facts about the workshop. -/

/-- `p → p`, in the Hilbert system: two instances of `s` and `k` and two
detachments. -/
def selfImp (a : Form) : Cert :=
  .mp (.mp (.s a (a.imp a) a) (.k a (a.imp a))) (.k a a)

theorem check_selfImp (Γ : List Form) (a : Form) :
    check Γ (selfImp a) = some (a.imp a) := by
  simp [selfImp, check]

/-- **A tautology, checked by the machine.**  Because the machine returned it
from an empty list of axioms, it is true in every world — proved through
`check_sound`, not by inspecting the formula. -/
theorem selfImp_valid (a : Form) : Valid (a.imp a) :=
  provable_nil_valid _ ⟨selfImp a, check_selfImp [] a⟩

/-! ### A run about the workshop

The atoms are given meanings: three claims about the skill tree and the fab,
each of which is decidable.  `earth` is the world the shop is actually in. -/

open Skills (Skill)

/-- The claim the `n`-th atom makes about the workshop. -/
def earthClaim : ℕ → Prop
  | 0 => Skill.tractorBuilding ∈ Skill.bootstrapSkills
  | 1 => Skill.computer ∈ Skill.fabSkills
  | 2 => Fab.Part.printer3D ∈ Fab.Part.fabTools
  | _ => False

/-- The world the workshop is in: each atom gets the truth value its claim
actually has. -/
def earth : ℕ → Bool
  | 0 => decide (Skill.tractorBuilding ∈ Skill.bootstrapSkills)
  | 1 => decide (Skill.computer ∈ Skill.fabSkills)
  | 2 => decide (Fab.Part.printer3D ∈ Fab.Part.fabTools)
  | _ => false

/-- The world and the claims agree. -/
theorem earth_iff : ∀ n : ℕ, earth n = true ↔ earthClaim n
  | 0 => by simp [earth, earthClaim]
  | 1 => by simp [earth, earthClaim]
  | 2 => by simp [earth, earthClaim]
  | (_ + 3) => by simp [earth, earthClaim]

/-- The two facts the machine is handed: the shop can build a tractor, and if
it can build a tractor then — the digital branch being a straight extension of
the same tree — it can build a computer. -/
def workshopAxioms : List Form := [atom 0, (atom 0).imp (atom 1)]

/-- Both are true of the workshop. -/
theorem workshopAxioms_hold : ∀ ψ ∈ workshopAxioms, ψ.eval earth = true := by decide

/-- The certificate: one detachment. -/
def workshopCert : Cert := .mp (.hyp 1) (.hyp 0)

/-- The machine reads the certificate and prints `atom 1`. -/
theorem check_workshopCert : check workshopAxioms workshopCert = some (atom 1) := by
  simp [workshopCert, workshopAxioms, check]

/-- **A fact about the shop, obtained by running the checker.**  The machine
was given two true statements about the workshop and a certificate; it printed
`atom 1`; by `check_sound` that atom is true of the world the workshop is in —
so the fab can build a computer.  The conclusion is reached through the
checker's soundness theorem, not by deciding it again. -/
theorem machine_says_computer_buildable : Skill.computer ∈ Skill.fabSkills := by
  have h : (atom 1).eval earth = true :=
    check_sound workshopAxioms earth workshopAxioms_hold workshopCert (atom 1) check_workshopCert
  have h1 : earth 1 = true := by simpa using h
  simpa [earthClaim] using (earth_iff 1).1 h1

/-! ## What a proof costs

Every step the checker takes is a physical event in a machine made of sand,
ore and oil.  Charging each step at `stepEnergy` gives the energy a
certificate costs, and the wood-gas set of `RequestProject/Sources.lean` turns
that into firewood and into coppice. -/

namespace Cert

/-- The number of elementary steps the checker takes on a certificate. -/
def steps : Cert → ℕ
  | hyp _ => 1
  | k _ _ => 1
  | s _ _ _ => 1
  | dne _ => 1
  | mp p q => p.steps + q.steps + 1

/-- **No certificate is free**: every one of them takes at least one step. -/
theorem steps_pos (c : Cert) : 0 < c.steps := by
  cases c <;> simp [steps]

theorem steps_mp (p q : Cert) : (mp p q).steps = p.steps + q.steps + 1 := rfl

end Cert

/-- The energy one elementary step of the checker costs, in kilowatt-hours:
0.108 microjoules, a 30 W machine at a gigahertz. -/
def stepEnergy : ℚ := 3/10^11

theorem stepEnergy_pos : 0 < stepEnergy := by norm_num [stepEnergy]

/-- The energy a certificate costs to check, in kilowatt-hours. -/
def energyOf (c : Cert) : ℚ := c.steps * stepEnergy

/-- The firewood a certificate costs, in kilograms, burnt in the wood-gas set
that powers the shop. -/
def woodFor (c : Cert) : ℚ :=
  EnergySupply.woodGasSet.fuelFor EnergySupply.firewood (energyOf c)

/-- The coppice a certificate costs, in square metres worked for a year. -/
def forestFor (c : Cert) : ℚ := EnergySupply.forestArea (woodFor c)

theorem energyOf_pos (c : Cert) : 0 < energyOf c := by
  have h : (0:ℚ) < (c.steps : ℚ) := by exact_mod_cast Cert.steps_pos c
  have := stepEnergy_pos
  simpa [energyOf] using mul_pos h this

/-- **Every proof costs wood.**  There is no certificate the machine can check
for nothing: checking is a physical process, paid for out of the forest. -/
theorem no_free_proof (c : Cert) : 0 < woodFor c := by
  have h := energyOf_pos c
  have hd : (0:ℚ) < EnergySupply.firewood.lhv * EnergySupply.woodGasSet.eff := by
    norm_num [EnergySupply.firewood, EnergySupply.woodGasSet]
  simpa [woodFor, EnergySupply.HeatEngine.fuelFor] using div_pos h hd

/-- The wood a proof costs is proportional to its length. -/
theorem woodFor_eq (c : Cert) : woodFor c = (c.steps : ℚ) * (25/(7 * 10^11)) := by
  simp only [woodFor, EnergySupply.HeatEngine.fuelFor, energyOf, stepEnergy,
    EnergySupply.firewood, EnergySupply.woodGasSet]
  ring

/-- A longer certificate costs strictly more. -/
theorem woodFor_strictMono {c d : Cert} (h : c.steps < d.steps) : woodFor c < woodFor d := by
  rw [woodFor_eq, woodFor_eq]
  have : ((c.steps : ℚ)) < (d.steps : ℚ) := by exact_mod_cast h
  nlinarith

/-- **A proof of a trillion steps costs thirty kilowatt-hours, thirty-five and
a half kilograms of firewood, and thirty-five and a half square metres of
coppice worked for a year.** -/
theorem trillion_step_proof (c : Cert) (h : c.steps = 10 ^ 12) :
    energyOf c = 30 ∧ woodFor c = 250/7 ∧ forestFor c = 250/7 := by
  refine ⟨?_, ?_, ?_⟩
  · simp [energyOf, h, stepEnergy]; norm_num
  · rw [woodFor_eq, h]; norm_num
  · rw [forestFor, EnergySupply.forestArea_eq, woodFor_eq, h]; norm_num

/-- The two runs of the checker above are cheap: the tautology takes five
steps and the workshop inference three. -/
theorem demo_steps : (selfImp (atom 0)).steps = 5 ∧ workshopCert.steps = 3 := by
  constructor <;> rfl

/-! ## Where the mathematics comes from -/

/-- **A proof is a deformation of the ground.**  Three things hold of every
certificate at once: checking it costs a strictly positive mass of firewood;
the machine that checks it rests on the whole skill tree, down to the mine and
the fire; and what the machine prints was already entailed by what it was
given.  Nothing in the process creates a truth — the wood, the ore and the
consequence were all there beforehand; the shop only bends them into a shape a
person can read. -/
theorem a_proof_is_a_deformation (Γ : List Form) (φ : Form) (c : Cert)
    (hc : check Γ c = some φ) :
    0 < woodFor c ∧
      (Skill.computer ∈ Skill.needs Skill.proofChecking ∧
        Skill.mining ∈ Skill.needs Skill.proofChecking ∧
        Skill.fire ∈ Skill.needs Skill.proofChecking) ∧
      Entails Γ φ :=
  ⟨no_free_proof c, by decide, checker_adds_nothing Γ φ ⟨c, hc⟩⟩

end Checker
end LifeTrac
