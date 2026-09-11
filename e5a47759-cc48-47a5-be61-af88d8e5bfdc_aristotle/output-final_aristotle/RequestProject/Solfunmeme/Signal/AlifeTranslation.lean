/-
  AlifeTranslation.lean — the dataset's code, data, proof and proof execution,
  translated into the artificial life, and learned by it.

  `AlifeLattice.lean` built a self-hosted artificial life: the cells are the
  thirteen strands of the recorded continuum, the neighbourhood relation is the
  web's own hyphae, and the alphabet is the thirteen-element lattice of sizes.
  This module feeds four *external* objects into that life:

  * the **code** — the five Lean 4 modules of the `introspector/solfunmeme`
    dataset, measured by their length in lines;
  * the **data** — the published counts of the dataset's JSON artifacts;
  * the **proof** — the number of theorems in each module;
  * the **proof execution** — the number of those theorems whose proof is run
    by the compiler (`native_decide`) rather than by the kernel.

  Each measurement is a natural number, and has to be read into the life's
  alphabet.  The reading is `mag`: take the binary magnitude of the number
  (`lg`, floor of the base-2 logarithm, proved correct in `lg_spec`) and then
  the smallest recorded size that is at least that magnitude (`scaleOf`).  So
  the life sees each artifact at its order of magnitude, which is the only
  thing the thirteen-letter alphabet can carry.

  Placing the readings on strands is a stated convention, not a measurement:
  the five modules go on the five strands of the combinatory/formal branch, the
  published data on the semantic-web branch and the two late strands.  What is
  proved is what the life then does with them.

  Proved here:

  * each translated artifact is a legitimate colony, and its life converges —
    four generations suffice for all four (`*_life_stable`);
  * **the proof and its execution translate to the same organism**
    (`exec_eq_proof`): at the resolution of the alphabet, running a proof and
    checking it are indistinguishable;
  * the library — the mixture of the four artifacts — is learned in four
    generations to a colony `learned` that is at equilibrium for ever
    (`learned_stable`, `gen_learned`);
  * **reproduction**: `learned` contains every one of the four artifacts
    (`learned_reproduces_*`), and contains each artifact's own limit
    (`learned_dominates_*`);
  * **economy**: `learned` is the *least* equilibrium that contains all four
    (`learned_least`) — the life memorises the library and invents nothing;
  * **superposition of learning**: learning the four separately and then mixing
    gives exactly `learned` (`learned_eq_join_of_lives`), so the order of
    training does not matter.
-/
import RequestProject.Solfunmeme.Signal.AlifeLattice

set_option maxRecDepth 100000

namespace Mycelium
namespace Alife

/-! ## Reading a number into the alphabet -/

/-- Binary magnitude, by structural recursion on a fuel argument. -/
def lgAux : ℕ → ℕ → ℕ
  | 0, _ => 0
  | f + 1, n => if n < 2 then 0 else lgAux f (n / 2) + 1

/-- `lg n` is the floor of the base-2 logarithm of `n` (and `0` for `n = 0`). -/
def lg (n : ℕ) : ℕ := lgAux n n

theorem lgAux_spec : ∀ (f n : ℕ), 1 ≤ n → n ≤ f → 2 ^ lgAux f n ≤ n ∧ n < 2 ^ (lgAux f n + 1) := by
  intro f
  induction f with
  | zero => intro n h1 h2; omega
  | succ f ih =>
      intro n h1 h2
      by_cases hn : n < 2
      · have : n = 1 := by omega
        subst this
        simp [lgAux]
      · push_neg at hn
        have hhalf : 1 ≤ n / 2 := by omega
        have hle : n / 2 ≤ f := by omega
        obtain ⟨hA, hB⟩ := ih (n / 2) hhalf hle
        have hstep : lgAux (f + 1) n = lgAux f (n / 2) + 1 := by
          simp [lgAux, Nat.not_lt.mpr hn]
        rw [hstep]
        constructor
        · have : 2 * 2 ^ lgAux f (n / 2) ≤ 2 * (n / 2) := by omega
          calc 2 ^ (lgAux f (n / 2) + 1) = 2 * 2 ^ lgAux f (n / 2) := by ring
            _ ≤ 2 * (n / 2) := this
            _ ≤ n := by omega
        · have h2' : n / 2 + 1 ≤ 2 ^ (lgAux f (n / 2) + 1) := hB
          have : n ≤ 2 * (n / 2) + 1 := by omega
          calc n ≤ 2 * (n / 2) + 1 := this
            _ < 2 * (n / 2 + 1) := by omega
            _ ≤ 2 * 2 ^ (lgAux f (n / 2) + 1) := by omega
            _ = 2 ^ (lgAux f (n / 2) + 1 + 1) := by ring

/-- `lg` really is the binary magnitude: `2 ^ lg n ≤ n < 2 ^ (lg n + 1)`. -/
theorem lg_spec {n : ℕ} (h : 1 ≤ n) : 2 ^ lg n ≤ n ∧ n < 2 ^ (lg n + 1) :=
  lgAux_spec n n h le_rfl

/-- The smallest recorded size that is at least `n` (the top size `1152` if
    there is none). -/
def scaleOf (n : ℕ) : ℕ := (sizes.filter (fun s => decide (n ≤ s))).foldr min 1152

theorem foldr_min_mem : ∀ (l : List ℕ) (b : ℕ), l.foldr min b ∈ b :: l := by
  intro l
  induction l with
  | nil => intro b; exact List.mem_cons_self
  | cons a t ih =>
      intro b
      rcases le_total a (t.foldr min b) with h | h
      · have : min a (t.foldr min b) = a := min_eq_left h
        simp [this]
      · have : min a (t.foldr min b) = t.foldr min b := min_eq_right h
        show min a (t.foldr min b) ∈ b :: a :: t
        rw [this]
        rcases List.mem_cons.mp (ih b) with hb | ht
        · exact List.mem_cons.mpr (Or.inl hb)
        · exact List.mem_cons.mpr (Or.inr (List.mem_cons_of_mem _ ht))

/-- The reading always lands in the alphabet. -/
theorem scaleOf_mem (n : ℕ) : scaleOf n ∈ sizes := by
  have h := foldr_min_mem (sizes.filter (fun s => decide (n ≤ s))) 1152
  rcases List.mem_cons.mp h with hb | ht
  · rw [scaleOf, hb]; decide
  · exact (List.mem_filter.mp ht).1

theorem le_foldr_min {n : ℕ} : ∀ (l : List ℕ) (b : ℕ), n ≤ b → (∀ x ∈ l, n ≤ x) →
    n ≤ l.foldr min b := by
  intro l
  induction l with
  | nil => intro b hb _; exact hb
  | cons a t ih =>
      intro b hb hl
      exact le_min (hl a List.mem_cons_self) (ih b hb fun x hx => hl x (List.mem_cons_of_mem _ hx))

/-- Reading never loses magnitude: below the top size, `n ≤ scaleOf n`. -/
theorem le_scaleOf {n : ℕ} (h : n ≤ 1152) : n ≤ scaleOf n := by
  refine le_foldr_min _ _ h ?_
  intro x hx
  exact of_decide_eq_true (List.mem_filter.mp hx).2

/-- The reading of a measurement: its binary magnitude, rounded up into the
    alphabet of sizes. -/
def mag (n : ℕ) : ℕ := scaleOf (lg n)

theorem mag_mem (n : ℕ) : mag n ∈ sizes := scaleOf_mem _

/-! ## The four artifacts

The five Lean modules of the dataset are placed on the five strands of the
combinatory/formal branch, the published data on the semantic-web branch and
the two late strands.  Everything unmeasured starts at the bottom size. -/

/-- **The code.**  The five Lean 4 modules of the dataset, by length in lines:
    `Bills.lean` 169, `FederalGov.lean` 236, `FederalModel.lean` 97,
    `Governance.lean` 170, `VotingProtocol.lean` 217. -/
def codeGenome : Colony
  | .metamemeVerses => mag 169
  | .sCombinatorRewriting => mag 236
  | .introspectiveAgents => mag 97
  | .leanFormalLayer => mag 170
  | .multipolarProofPooling => mag 217
  | _ => 1

/-- **The data.**  The published counts: 652 credentials issued, 42 senate,
    145 house and 465 lobby credentials, 1976 ranked holders, 3610 wallets,
    5119 actors. -/
def dataGenome : Colony
  | .gccIntrospector => mag 652
  | .owlTreeOntology => mag 42
  | .semanticGraphStore => mag 145
  | .escapedRDFa => mag 465
  | .zkShardedSemantics => mag 1976
  | .upperOntologyMerge => mag 3610
  | .solfunmemeZOS => mag 5119
  | _ => 1

/-- **The proof.**  The number of theorems in each module: 12, 30, 17, 25, 14
    (98 in all), on the same strands as the code they belong to. -/
def proofGenome : Colony
  | .metamemeVerses => mag 12
  | .sCombinatorRewriting => mag 30
  | .introspectiveAgents => mag 17
  | .leanFormalLayer => mag 25
  | .multipolarProofPooling => mag 14
  | _ => 1

/-- **The proof execution.**  The number of theorems in each module whose proof
    is executed by the compiler rather than checked by the kernel: 9, 27, 16,
    19, 14 (85 in all). -/
def execGenome : Colony
  | .metamemeVerses => mag 9
  | .sCombinatorRewriting => mag 27
  | .introspectiveAgents => mag 16
  | .leanFormalLayer => mag 19
  | .multipolarProofPooling => mag 14
  | _ => 1

theorem codeGenome_inSizes : InSizes codeGenome := by
  intro x; cases x <;> first | exact mag_mem _ | decide

theorem dataGenome_inSizes : InSizes dataGenome := by
  intro x; cases x <;> first | exact mag_mem _ | decide

theorem proofGenome_inSizes : InSizes proofGenome := by
  intro x; cases x <;> first | exact mag_mem _ | decide

theorem execGenome_inSizes : InSizes execGenome := by
  intro x; cases x <;> first | exact mag_mem _ | decide

/-- The readings, spelled out. -/
theorem codeGenome_values :
    codeGenome .metamemeVerses = 8 ∧ codeGenome .sCombinatorRewriting = 8 ∧
    codeGenome .introspectiveAgents = 6 ∧ codeGenome .leanFormalLayer = 8 ∧
    codeGenome .multipolarProofPooling = 8 := by decide

theorem dataGenome_values :
    dataGenome .gccIntrospector = 12 ∧ dataGenome .owlTreeOntology = 6 ∧
    dataGenome .semanticGraphStore = 8 ∧ dataGenome .escapedRDFa = 8 ∧
    dataGenome .zkShardedSemantics = 12 ∧ dataGenome .upperOntologyMerge = 12 ∧
    dataGenome .solfunmemeZOS = 12 := by decide

theorem proofGenome_values :
    proofGenome .metamemeVerses = 3 ∧ proofGenome .sCombinatorRewriting = 4 ∧
    proofGenome .introspectiveAgents = 4 ∧ proofGenome .leanFormalLayer = 4 ∧
    proofGenome .multipolarProofPooling = 3 := by decide

/-- **The proof and its execution are the same organism.**  Ninety-eight
    theorems and the eighty-five of them that the compiler runs have the same
    binary magnitudes module by module, so the life cannot tell them apart. -/
theorem exec_eq_proof : ∀ x : Strand, execGenome x = proofGenome x := by decide

/-! ## Learning

Training is just living: `learn c` is four generations of the life on the
recorded continuum, which is enough for every colony considered here. -/

/-- Four generations of the life on the recorded continuum. -/
def learn (c : Colony) : Colony := gen continuum 4 c

theorem learn_inSizes {c : Colony} (hc : InSizes c) : InSizes (learn c) := gen_inSizes hc 4

/-- What the life makes of an artifact, once it has settled, it keeps for
    ever. -/
theorem gen_of_learned {c : Colony} (hc : InSizes c) (hs : Stable continuum (learn c)) :
    ∀ (n : ℕ) (x : Strand), gen continuum n (learn c) x = learn c x :=
  gen_of_stable (learn_inSizes hc) hs

/-- The artifact is contained in what the life learns from it. -/
theorem self_dvd_learn {c : Colony} (hc : InSizes c) (x : Strand) : c x ∣ learn c x :=
  self_dvd_gen hc 4 x

def codeLife : Colony := learn codeGenome
def dataLife : Colony := learn dataGenome
def proofLife : Colony := learn proofGenome
def execLife : Colony := learn execGenome

theorem codeLife_stable : Stable continuum codeLife := by decide
theorem dataLife_stable : Stable continuum dataLife := by decide
theorem proofLife_stable : Stable continuum proofLife := by decide
theorem execLife_stable : Stable continuum execLife := by decide

/-- Learning the proof and learning its execution give the same organism. -/
theorem execLife_eq_proofLife : ∀ x : Strand, execLife x = proofLife x := by decide

/-- The four limits, spelled out. -/
theorem codeLife_values : ∀ x : Strand, codeLife x =
    (match x with
     | .metamemeVerses => 8 | .sCombinatorRewriting => 8
     | .introspectiveAgents => 24 | .leanFormalLayer => 24
     | .multipolarProofPooling => 24 | .upperOntologyMerge => 24
     | .solfunmemeZOS => 8 | .mycelialContinuum => 24
     | _ => 1) := by decide

theorem dataLife_values : ∀ x : Strand, dataLife x =
    (match x with
     | .gccIntrospector => 12 | .owlTreeOntology => 12
     | .metamemeVerses => 12 | .sCombinatorRewriting => 12
     | .introspectiveAgents => 12
     | _ => 24) := by decide

theorem proofLife_values : ∀ x : Strand, proofLife x =
    (match x with
     | .metamemeVerses => 3 | .solfunmemeZOS => 3
     | .sCombinatorRewriting => 12 | .introspectiveAgents => 12
     | .leanFormalLayer => 12 | .multipolarProofPooling => 12
     | .upperOntologyMerge => 12 | .mycelialContinuum => 12
     | _ => 1) := by decide

/-! ## The library, and what the life learns from all four at once -/

/-- The library: all four artifacts fed in together. -/
def library : Colony := mix (mix codeGenome dataGenome) (mix proofGenome execGenome)

theorem library_inSizes : InSizes library :=
  mix_inSizes (mix_inSizes codeGenome_inSizes dataGenome_inSizes)
    (mix_inSizes proofGenome_inSizes execGenome_inSizes)

/-- The learned organism. -/
def learned : Colony := learn library

theorem learned_inSizes : InSizes learned := learn_inSizes library_inSizes

/-- Learning converges: the learned organism is at equilibrium. -/
theorem learned_stable : Stable continuum learned := by decide

/-- …and stays there for ever: further training changes nothing. -/
theorem gen_learned : ∀ (n : ℕ) (x : Strand), gen continuum n learned x = learned x :=
  gen_of_stable learned_inSizes learned_stable

/-- The learned organism, spelled out: the bottom two strands hold 12, all
    eleven others hold 24. -/
theorem learned_values : ∀ x : Strand, learned x =
    (match x with
     | .gccIntrospector => 12 | .owlTreeOntology => 12
     | _ => 24) := by decide

/-! ### Reproduction -/

theorem learned_reproduces_code : ∀ x : Strand, codeGenome x ∣ learned x := by decide
theorem learned_reproduces_data : ∀ x : Strand, dataGenome x ∣ learned x := by decide
theorem learned_reproduces_proof : ∀ x : Strand, proofGenome x ∣ learned x := by decide
theorem learned_reproduces_exec : ∀ x : Strand, execGenome x ∣ learned x := by decide

theorem learned_dominates_codeLife : ∀ x : Strand, codeLife x ∣ learned x := by decide
theorem learned_dominates_dataLife : ∀ x : Strand, dataLife x ∣ learned x := by decide
theorem learned_dominates_proofLife : ∀ x : Strand, proofLife x ∣ learned x := by decide

/-- **Economy of learning.**  The learned organism is the least equilibrium
    that contains all four artifacts: any colony at equilibrium that reproduces
    the library already contains everything the life learned. -/
theorem learned_least {d : Colony} (hd : InSizes d) (hs : Stable continuum d)
    (hcode : ∀ x, codeGenome x ∣ d x) (hdata : ∀ x, dataGenome x ∣ d x)
    (hproof : ∀ x, proofGenome x ∣ d x) (hexec : ∀ x, execGenome x ∣ d x)
    (x : Strand) : learned x ∣ d x := by
  have hlib : ∀ y, library y ∣ d y := by
    intro y
    refine sjoin_dvd _ (sjoin_mem _ (codeGenome_inSizes y) _ (dataGenome_inSizes y)) _
      (sjoin_mem _ (proofGenome_inSizes y) _ (execGenome_inSizes y)) _ (hd y) ?_ ?_
    · exact sjoin_dvd _ (codeGenome_inSizes y) _ (dataGenome_inSizes y) _ (hd y) (hcode y) (hdata y)
    · exact sjoin_dvd _ (proofGenome_inSizes y) _ (execGenome_inSizes y) _ (hd y) (hproof y) (hexec y)
  exact gen_dvd_of_stable library_inSizes hd hs hlib 4 x

/-- **Superposition of learning.**  Training on the four artifacts together is
    the same as training on each separately and mixing the results: the order
    of training does not matter. -/
theorem learned_eq_join_of_lives : ∀ x : Strand,
    learned x = sjoin (sjoin (codeLife x) (dataLife x)) (sjoin (proofLife x) (execLife x)) := by
  intro x
  have h1 : ∀ y, gen continuum 4 (mix codeGenome dataGenome) y
      = sjoin (codeLife y) (dataLife y) :=
    gen_mix codeGenome_inSizes dataGenome_inSizes 4
  have h2 : ∀ y, gen continuum 4 (mix proofGenome execGenome) y
      = sjoin (proofLife y) (execLife y) :=
    gen_mix proofGenome_inSizes execGenome_inSizes 4
  have h := gen_mix (w := continuum) (mix_inSizes codeGenome_inSizes dataGenome_inSizes)
    (mix_inSizes proofGenome_inSizes execGenome_inSizes) 4 x
  rw [show learned x = gen continuum 4 library x from rfl, library, h, h1, h2]

/-! ## Axiom audit -/

#print axioms lg_spec
#print axioms scaleOf_mem
#print axioms exec_eq_proof
#print axioms learned_stable
#print axioms learned_values
#print axioms learned_reproduces_code
#print axioms learned_least
#print axioms learned_eq_join_of_lives

end Alife
end Mycelium
