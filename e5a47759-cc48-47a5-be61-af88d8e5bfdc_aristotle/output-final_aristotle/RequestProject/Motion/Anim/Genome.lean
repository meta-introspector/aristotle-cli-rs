import Mathlib

/-!
# The genome of a playbook

The formal counterpart of `web/js/genome.js`, the genetic layer behind the
studio's **mutate** and **breed** buttons.

A playbook is cut into a *skeleton* — the literal text of the script — and its
*genes*: the numbers, colours and choice words that can be varied without
changing what kind of picture the script is.  `write` weaves the two back
together, and every operator here leaves the skeleton and the list of gene keys
exactly as it found them.  That is the point: it is what makes *every* mutant
and *every* child a playbook again, rather than a string that no longer parses.

What is proved:

* `mutate_chunks`, `mutate_keys`, `length_mutateGenes` — mutation keeps the
  skeleton, the gene keys and their order, so the mutant has the shape of its
  parent;
* `mutateGene_of_false`, `mutate_of_all_false` — a gene whose coin came up
  false is untouched, so a mutation with nothing selected is the identity
  (this is the `rate = 0` case of the runtime);
* `abs_mutate_num_sub_le`, `mutateNum_mem_Icc` — a mutated number moves by at
  most `amount · max |v| 1`, which is the bound the studio's *how far* slider
  sets;
* `mutateValue_word`, `mutate_num_iff` — mutation never changes the *kind* of a
  gene: a number stays a number and a word stays a word;
* `crossover_chunks`, `crossover_keys` — a child has its first parent's
  skeleton and gene keys, hence parses whenever that parent does;
* `crossGene_value_mem`, `crossover_value_from_parents` — **no invention**:
  every gene value of a child is a gene value one of its parents had, under
  the same key;
* `crossover_of_all_false`, `crossover_of_all_true` — the two extreme masks
  give back the first parent and (where the keys line up) the second;
* `mem_graft`, `mem_graft_of_mem`, `length_graft` — grafting a statement of B
  into A adds one line, keeps every line of A, and adds nothing that was not a
  line of a parent.

`tests/node/test_lab.mjs` checks the shipped JavaScript against the same
statements, on every example playbook.
-/

namespace Hesper.Genetics

/-! ## Genes and genomes -/

/-- What a gene can hold: a number, or a word drawn from a small vocabulary
(`ease inOut`, `palette magma`).  Colours are words in this model — the runtime
keeps them legal `#rrggbb` by construction. -/
inductive Value where
  | num : ℝ → Value
  | word : String → Value
  deriving Inhabited

/-- A gene: a value together with the key that addresses it.  The key is what
two *different* playbooks are aligned by when they are crossed. -/
structure Gene where
  key : String
  value : Value
  deriving Inhabited

/-- A genome: the literal pieces of the script, with the genes between them.
`chunks` is one longer than `genes` in anything `read` produces. -/
structure Genome where
  chunks : List String
  genes : List Gene
  deriving Inhabited

/-- Weave a skeleton and a list of gene texts back into one script. -/
def weave : List String → List String → String
  | [], _ => ""
  | c :: cs, [] => c ++ weave cs []
  | c :: cs, v :: vs => c ++ v ++ weave cs vs

/-- How a gene is written back into the script.  `numText` is the runtime's
`fmt`: how a number is printed (short, and integral if it began so). -/
def renderValue (numText : ℝ → String) : Value → String
  | .num r => numText r
  | .word w => w

/-- The script a genome stands for. -/
def write (numText : ℝ → String) (g : Genome) : String :=
  weave g.chunks (g.genes.map (fun x => renderValue numText x.value))

/-- A genome is written from its skeleton and the rendering of its genes; two
genomes with the same skeleton and the same gene renderings are the same
script. -/
theorem write_congr {numText : ℝ → String} {g h : Genome} (hc : g.chunks = h.chunks)
    (hv : g.genes.map (fun x => renderValue numText x.value)
        = h.genes.map (fun x => renderValue numText x.value)) :
    write numText g = write numText h := by
  unfold write; rw [hc, hv]

/-! ## Mutation

A mutation is driven by one draw per gene: a coin saying whether the gene is
touched at all, and a number `u ∈ [0,1)` saying how far it moves.  Keeping the
draws explicit is what makes a mutation reproducible from a seed — the runtime
derives them from `mulberry32`, and the seed travels in the share link. -/

/-- The largest step a mutation of `v` may take.  Relative to the value, so a
line width of `0.02` and a sample count of `900` both move sensibly. -/
noncomputable def step (amount v : ℝ) : ℝ := amount * max |v| 1

/-- Move a value.  A word is left alone here; the runtime swaps it for another
member of the same vocabulary, which is again a legal word for that slot. -/
noncomputable def mutateValue (amount u : ℝ) : Value → Value
  | .num r => .num (r + (2 * u - 1) * step amount r)
  | .word w => .word w

/-- Mutate one gene, if its coin came up. -/
noncomputable def mutateGene (amount : ℝ) (roll : Bool × ℝ) (g : Gene) : Gene :=
  if roll.1 then { g with value := mutateValue amount roll.2 g.value } else g

/-- Mutate a list of genes against a list of draws. -/
noncomputable def mutateGenes (amount : ℝ) : List (Bool × ℝ) → List Gene → List Gene
  | _, [] => []
  | [], gs => gs
  | r :: rs, g :: gs => mutateGene amount r g :: mutateGenes amount rs gs

/-- Mutate a genome: the skeleton is not an argument, so it cannot change. -/
noncomputable def mutate (amount : ℝ) (rolls : List (Bool × ℝ)) (g : Genome) : Genome :=
  { g with genes := mutateGenes amount rolls g.genes }

@[simp] theorem mutate_chunks (amount : ℝ) (rolls : List (Bool × ℝ)) (g : Genome) :
    (mutate amount rolls g).chunks = g.chunks := rfl

@[simp] theorem mutateGene_key (amount : ℝ) (roll : Bool × ℝ) (g : Gene) :
    (mutateGene amount roll g).key = g.key := by
  unfold mutateGene; split <;> rfl

/-- A gene whose coin came up false is untouched: mutation is local. -/
theorem mutateGene_of_false (amount : ℝ) (u : ℝ) (g : Gene) :
    mutateGene amount (false, u) g = g := by
  unfold mutateGene; simp

theorem length_mutateGenes (amount : ℝ) (rolls : List (Bool × ℝ)) (gs : List Gene) :
    (mutateGenes amount rolls gs).length = gs.length := by
  induction rolls generalizing gs with
  | nil => cases gs <;> simp [mutateGenes]
  | cons r rs ih => cases gs with
    | nil => simp [mutateGenes]
    | cons g gs => simp [mutateGenes, ih]

/-- Mutation keeps every gene key, in order: the mutant has the shape of its
parent, so it is a playbook again. -/
theorem mutateGenes_keys (amount : ℝ) (rolls : List (Bool × ℝ)) (gs : List Gene) :
    (mutateGenes amount rolls gs).map Gene.key = gs.map Gene.key := by
  induction rolls generalizing gs with
  | nil => cases gs <;> simp [mutateGenes]
  | cons r rs ih => cases gs with
    | nil => simp [mutateGenes]
    | cons g gs => simp [mutateGenes, ih]

theorem mutate_keys (amount : ℝ) (rolls : List (Bool × ℝ)) (g : Genome) :
    (mutate amount rolls g).genes.map Gene.key = g.genes.map Gene.key :=
  mutateGenes_keys amount rolls g.genes

/-- With no gene selected, a mutation changes nothing at all. -/
theorem mutate_of_all_false (amount : ℝ) (rolls : List (Bool × ℝ)) (g : Genome)
    (h : ∀ r ∈ rolls, r.1 = false) : mutate amount rolls g = g := by
  have hgen : ∀ (rs : List (Bool × ℝ)) (gs : List Gene),
      (∀ r ∈ rs, r.1 = false) → mutateGenes amount rs gs = gs := by
    intro rs
    induction rs with
    | nil => intro gs _; cases gs <;> simp [mutateGenes]
    | cons r rs ih =>
      intro gs hr
      cases gs with
      | nil => simp [mutateGenes]
      | cons g gs =>
        have h0 : r.1 = false := hr r (by simp)
        have : mutateGene amount r g = g := by
          unfold mutateGene; rw [h0]; simp
        simp [mutateGenes, this, ih gs (fun x hx => hr x (by simp [hx]))]
  unfold mutate
  rw [hgen rolls g.genes h]

/-! ### How far a mutation moves a number -/

/-- The step a numeric gene takes is at most `amount · max |v| 1`. -/
theorem abs_mutate_num_sub_le {amount u r : ℝ} (ha : 0 ≤ amount)
    (h0 : 0 ≤ u) (h1 : u ≤ 1) :
    |(r + (2 * u - 1) * step amount r) - r| ≤ step amount r := by
  have hstep : 0 ≤ step amount r := by
    have : (0:ℝ) ≤ max |r| 1 := le_trans zero_le_one (le_max_right _ _)
    exact mul_nonneg ha this
  have hu : |2 * u - 1| ≤ 1 := by
    rw [abs_le]; constructor <;> linarith
  have : |(2 * u - 1) * step amount r| ≤ 1 * step amount r := by
    rw [abs_mul, abs_of_nonneg hstep]
    exact mul_le_mul_of_nonneg_right hu hstep
  simpa using this

/-- A mutated number stays inside the window the *how far* slider allows. -/
theorem mutateNum_mem_Icc {amount u r : ℝ} (ha : 0 ≤ amount) (h0 : 0 ≤ u) (h1 : u ≤ 1) :
    r + (2 * u - 1) * step amount r ∈ Set.Icc (r - step amount r) (r + step amount r) := by
  have h := abs_mutate_num_sub_le ha h0 h1 (r := r)
  rw [abs_le] at h
  constructor <;> [linarith [h.1]; linarith [h.2]]

/-- Mutation never turns a word into a number. -/
@[simp] theorem mutateValue_word (amount u : ℝ) (w : String) :
    mutateValue amount u (.word w) = .word w := rfl

/-- Nor a number into a word. -/
theorem mutate_num_iff (amount u : ℝ) (v : Value) :
    (∃ r, mutateValue amount u v = .num r) ↔ (∃ r, v = .num r) := by
  cases v with
  | num r => exact ⟨fun _ => ⟨r, rfl⟩, fun _ => ⟨_, rfl⟩⟩
  | word w =>
    constructor
    · rintro ⟨r, hr⟩; simp [mutateValue] at hr
    · rintro ⟨r, hr⟩; simp at hr

/-! ## Crossover

Two playbooks are crossed gene by gene, aligned by key.  The child keeps the
first parent's skeleton, and each of its genes is either its own or the one the
second parent had under the same key. -/

/-- The value the other parent has under a key, if it has one. -/
def lookupKey (gs : List Gene) (k : String) : Option Value :=
  (gs.find? (fun g => g.key = k)).map Gene.value

/-- Cross one gene: take the mate's value when the mask says so and the mate
has one. -/
def crossGene (b : List Gene) (take : Bool) (g : Gene) : Gene :=
  if take then
    match lookupKey b g.key with
    | some v => { g with value := v }
    | none => g
  else g

def crossGenes (b : List Gene) : List Bool → List Gene → List Gene
  | _, [] => []
  | [], gs => gs
  | m :: ms, g :: gs => crossGene b m g :: crossGenes b ms gs

/-- Cross two genomes.  The skeleton is the first parent's. -/
def crossover (a b : Genome) (mask : List Bool) : Genome :=
  { a with genes := crossGenes b.genes mask a.genes }

@[simp] theorem crossover_chunks (a b : Genome) (mask : List Bool) :
    (crossover a b mask).chunks = a.chunks := rfl

@[simp] theorem crossGene_key (b : List Gene) (m : Bool) (g : Gene) :
    (crossGene b m g).key = g.key := by
  unfold crossGene
  split
  · split <;> rfl
  · rfl

theorem crossGenes_keys (b : List Gene) (mask : List Bool) (gs : List Gene) :
    (crossGenes b mask gs).map Gene.key = gs.map Gene.key := by
  induction mask generalizing gs with
  | nil => cases gs <;> simp [crossGenes]
  | cons m ms ih => cases gs with
    | nil => simp [crossGenes]
    | cons g gs => simp [crossGenes, ih]

theorem crossover_keys (a b : Genome) (mask : List Bool) :
    (crossover a b mask).genes.map Gene.key = a.genes.map Gene.key :=
  crossGenes_keys b.genes mask a.genes

/-- The mate's value under a key really is one of the mate's gene values. -/
theorem lookupKey_mem {gs : List Gene} {k : String} {v : Value}
    (h : lookupKey gs k = some v) : ∃ g ∈ gs, g.key = k ∧ g.value = v := by
  unfold lookupKey at h
  cases hf : gs.find? (fun g => g.key = k) with
  | none => rw [hf] at h; simp at h
  | some g =>
    rw [hf] at h
    simp only [Option.map_some] at h
    refine ⟨g, List.mem_of_find?_eq_some hf, ?_, Option.some.inj h⟩
    have := List.find?_some hf
    simpa using this

/-- **No invention.**  A crossed gene carries its own value or the mate's value
under the same key — nothing else can appear in a child. -/
theorem crossGene_value_mem (b : List Gene) (m : Bool) (g : Gene) :
    (crossGene b m g).value = g.value ∨
      ∃ gb ∈ b, gb.key = g.key ∧ (crossGene b m g).value = gb.value := by
  unfold crossGene
  cases m with
  | false => exact Or.inl rfl
  | true =>
    cases h : lookupKey b g.key with
    | none => simp
    | some v =>
      obtain ⟨gb, hmem, hkey, hval⟩ := lookupKey_mem h
      exact Or.inr ⟨gb, hmem, hkey, by simp [hval]⟩

/-- Every gene of a child came from a parent, under its own key. -/
theorem crossover_value_from_parents (a b : Genome) (mask : List Bool) :
    ∀ g ∈ (crossover a b mask).genes,
      (∃ ga ∈ a.genes, ga.key = g.key ∧ ga.value = g.value) ∨
      (∃ gb ∈ b.genes, gb.key = g.key ∧ gb.value = g.value) := by
  have main : ∀ (ms : List Bool) (gs : List Gene), ∀ g ∈ crossGenes b.genes ms gs,
      (∃ ga ∈ gs, ga.key = g.key ∧ ga.value = g.value) ∨
      (∃ gb ∈ b.genes, gb.key = g.key ∧ gb.value = g.value) := by
    intro ms
    induction ms with
    | nil =>
      intro gs g hg
      cases gs with
      | nil => simp [crossGenes] at hg
      | cons x xs =>
        simp only [crossGenes] at hg
        exact Or.inl ⟨g, hg, rfl, rfl⟩
    | cons m ms ih =>
      intro gs g hg
      cases gs with
      | nil => simp [crossGenes] at hg
      | cons x xs =>
        simp only [crossGenes, List.mem_cons] at hg
        rcases hg with rfl | hg
        · rcases crossGene_value_mem b.genes m x with h | ⟨gb, hmem, hkey, hval⟩
          · exact Or.inl ⟨x, by simp, by simp, by simpa using h.symm⟩
          · exact Or.inr ⟨gb, hmem, by simpa using hkey, by simpa using hval.symm⟩
        · rcases ih xs g hg with ⟨ga, hmem, h⟩ | h
          · exact Or.inl ⟨ga, by simp [hmem], h⟩
          · exact Or.inr h
  intro g hg
  rcases main mask a.genes g hg with ⟨ga, h⟩ | h
  · exact Or.inl ⟨ga, h⟩
  · exact Or.inr h

/-- Taking nothing from the mate gives the first parent back. -/
theorem crossover_of_all_false (a b : Genome) (mask : List Bool)
    (h : ∀ m ∈ mask, m = false) : crossover a b mask = a := by
  have main : ∀ (ms : List Bool) (gs : List Gene), (∀ m ∈ ms, m = false) →
      crossGenes b.genes ms gs = gs := by
    intro ms
    induction ms with
    | nil => intro gs _; cases gs <;> simp [crossGenes]
    | cons m ms ih =>
      intro gs hm
      cases gs with
      | nil => simp [crossGenes]
      | cons g gs =>
        have h0 : m = false := hm m (by simp)
        simp [crossGenes, crossGene, h0, ih gs (fun x hx => hm x (by simp [hx]))]
  unfold crossover
  rw [main mask a.genes h]

/-- Taking everything from the mate takes every gene the mate has. -/
theorem crossover_of_all_true (a b : Genome) (mask : List Bool)
    (hm : ∀ m ∈ mask, m = true) (hlen : mask.length = a.genes.length) :
    ∀ i (hi : i < a.genes.length),
      lookupKey b.genes (a.genes[i]).key = some v →
        ((crossover a b mask).genes[i]?).map Gene.value = some v := by
  intro i hi hlook
  have main : ∀ (ms : List Bool) (gs : List Gene), (∀ m ∈ ms, m = true) →
      ms.length = gs.length → ∀ j (hj : j < gs.length),
        (crossGenes b.genes ms gs)[j]? = some (crossGene b.genes true gs[j]) := by
    intro ms
    induction ms with
    | nil =>
      intro gs _ hlen j hj
      have : gs = [] := List.eq_nil_of_length_eq_zero hlen.symm
      subst this
      simp at hj
    | cons m ms ih =>
      intro gs hall hlen j hj
      cases gs with
      | nil => simp at hj
      | cons g gs =>
        have hmtrue : m = true := hall m (by simp)
        cases j with
        | zero => simp [crossGenes, hmtrue]
        | succ j =>
          have hlen' : ms.length = gs.length := by simpa using hlen
          have hj' : j < gs.length := by simpa using hj
          simp [crossGenes, ih gs (fun x hx => hall x (by simp [hx])) hlen' j hj']
  have := main mask a.genes hm hlen i hi
  unfold crossover
  rw [this]
  simp [crossGene, hlook]

/-! ## Grafting

Structural breeding: a whole drawing statement of B is spliced into A, so the
child gains a layer that no amount of tuning numbers could have reached. -/

/-- Splice line `i` of `b` into `a` at position `k`. -/
def graft (a b : List String) (i k : ℕ) : List String :=
  match b[i]? with
  | none => a
  | some line => a.take k ++ line :: a.drop k

/-- Every line of a graft is a line of one of the parents: a graft writes no
new text. -/
theorem mem_graft {a b : List String} {i k : ℕ} {l : String}
    (h : l ∈ graft a b i k) : l ∈ a ∨ l ∈ b := by
  unfold graft at h
  cases hb : b[i]? with
  | none => rw [hb] at h; exact Or.inl h
  | some line =>
    rw [hb] at h
    simp only [List.mem_append, List.mem_cons] at h
    rcases h with h | h | h
    · exact Or.inl (List.mem_of_mem_take h)
    · exact Or.inr (by subst h; exact List.mem_of_getElem? hb)
    · exact Or.inl (List.mem_of_mem_drop h)

/-- Nothing of the first parent is lost. -/
theorem mem_graft_of_mem {a b : List String} {i k : ℕ} {l : String}
    (h : l ∈ a) : l ∈ graft a b i k := by
  unfold graft
  cases hb : b[i]? with
  | none => exact h
  | some line =>
    have : a = a.take k ++ a.drop k := (List.take_append_drop k a).symm
    rw [this] at h
    simp only [List.mem_append] at h
    simp only [List.mem_append, List.mem_cons]
    rcases h with h | h
    · exact Or.inl h
    · exact Or.inr (Or.inr h)

/-- A graft adds exactly one statement. -/
theorem length_graft {a b : List String} {i k : ℕ} (hi : i < b.length) :
    (graft a b i k).length = a.length + 1 := by
  unfold graft
  cases hb : b[i]? with
  | none => exact absurd hb (by simp [List.getElem?_eq_getElem hi])
  | some line =>
    simp [List.length_append, List.length_take, List.length_drop]
    omega

end Hesper.Genetics
