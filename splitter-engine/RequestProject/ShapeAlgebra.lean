/-
ShapeAlgebra.lean — a Clifford algebra of shapes, a shape-constraint language, and
similarity of objects by their *arrows* (n-grams of sizes), from `1`-grams up to `71`-grams.

This is the *verified* backbone for the companion analyser `RequestProject/ShapeFinder.lean`
(`shapefinder` executable). It builds on `RequestProject/SizeSignature.lean`, where an
object's structural shape is a tree (`Shape`) and its `size` is the number of leaf elements,
so the motivating "two elements, each two elements" object `[2[2]]` has size `2^2 = 4`.

Here we go beyond a single number:

* **The size word / arrows of a shape.** `sizeWord` is the pre-order list of subtree sizes,
  e.g. the word of `[2[2]]` records the total size `4`, then each child subtree's size.
  An *arrow* is a consecutive pair `[size₁, size₂]` in this word (a parent→child edge), and
  more generally an `n`-gram `[size₁, …, sizeₙ]` is a length-`n` window (`ngramsOf`).

* **Similarity by arrows.** Two objects are `n`-similar (`similarN n`) when they carry the
  same *bag* of `n`-grams (`bagNgrams`). `n = 1` compares the multiset of sizes (total-size
  information); `n = 2` compares arrows; higher `n` compares longer chains. We sweep
  `n = 1 … 71` (`gramProfile`, `similarUpTo`) — "from 1 arrow up to 71-grams". Each
  `similarN n` and the swept `similarUpTo` are equivalence relations.

* **A shape-constraint language.** `ShapeConstraint` is a small DSL (`sizeEq`, `sizeLe`,
  `depthLe`, `hasNgram`, and boolean combinators) with a computable evaluator `eval`, whose
  semantics we pin down (`eval_sizeEq`, …) — a "shape constraint language" in which the size
  classes and arrow patterns are expressible.

* **A Clifford algebra of shapes.** Over the quadratic form `Q = QuadraticMap.sq` on `ℚ`
  (`Q x = x·x`), each size `n` becomes a generator `shapeGen n = ι Q (n : ℚ)`, and a shape
  becomes the ordered product of the generators of its size word (`shapeCliff`). The Clifford
  relation holds (`shapeGen_sq : shapeGen n * shapeGen n = (n·n : ℚ)`), and the construction
  is multiplicative in word concatenation (`wordElt_append`).
-/
import Mathlib
import RequestProject.SizeSignature

namespace ShapeAlgebra

open SizeSignature

/-! ## The size word (arrows) of a shape -/

/-- The **size word** of a shape: the pre-order list of subtree sizes. A `leaf` contributes
the single size `1`; a `node` records its own total size first, then the words of its
children in order. Consecutive entries are the *arrows* (parent→child edges). -/
def sizeWord : Shape → List Nat
  | .leaf => [1]
  | .node cs => size (.node cs) :: (cs.flatMap sizeWord)

@[simp] theorem sizeWord_leaf : sizeWord .leaf = [1] := by simp [sizeWord]

@[simp] theorem sizeWord_node (cs : List Shape) :
    sizeWord (.node cs) = size (.node cs) :: (cs.flatMap sizeWord) := by rw [sizeWord]

/-- The size word is never empty. -/
theorem sizeWord_ne_nil (s : Shape) : sizeWord s ≠ [] := by
  cases s <;> simp

/-- The first entry of the size word is the total size of the shape. -/
theorem head?_sizeWord (s : Shape) : (sizeWord s).head? = some (size s) := by
  cases s <;> simp

/-- The **depth** of a shape (a leaf has depth `0`). -/
def depth : Shape → Nat
  | .leaf => 0
  | .node cs => 1 + (cs.map depth).foldr max 0

/-! ## n-grams and similarity by arrows -/

/-- All contiguous length-`n` sub-lists (**n-grams**) of a list, in order of position.
For `n = 2` these are the arrows `[size₁, size₂]`. -/
def ngramsOf (n : Nat) (l : List Nat) : List (List Nat) :=
  (List.range (l.length + 1 - n)).map (fun i => (l.drop i).take n)

@[simp] theorem ngramsOf_length (n : Nat) (l : List Nat) :
    (ngramsOf n l).length = l.length + 1 - n := by
  simp [ngramsOf]

/-
The 1-grams of a list are exactly its singletons, in order.
-/
theorem ngramsOf_one (l : List Nat) : ngramsOf 1 l = l.map (fun a => [a]) := by
  unfold ngramsOf;
  refine' List.ext_get _ _ <;> simp +decide;
  intro n hn h₂; rw [ List.take_add_one ] ; aesop;

/-- The `n`-grams of a shape: the `n`-grams of its size word. -/
def shapeNgrams (n : Nat) (s : Shape) : List (List Nat) := ngramsOf n (sizeWord s)

/-- The **arrows** of a shape: its `2`-grams `[size₁, size₂]`. -/
def arrows (s : Shape) : List (List Nat) := shapeNgrams 2 s

/-- The **bag of n-grams** of a shape (multiset, forgetting order/position). -/
def bagNgrams (n : Nat) (s : Shape) : Multiset (List Nat) := (shapeNgrams n s : Multiset _)

/-- Two shapes are **n-similar** when they carry the same bag of `n`-grams: at `n = 1` the
same multiset of sizes, at `n = 2` the same arrows, and so on. -/
def similarN (n : Nat) (a b : Shape) : Prop := bagNgrams n a = bagNgrams n b

/-
`n`-similarity is an equivalence relation.
-/
theorem similarN_equivalence (n : Nat) : Equivalence (similarN n) := by
  constructor;
  · exact fun x => rfl;
  · exact fun h => h.symm;
  · exact fun h1 h2 => h1.trans h2

/-
Shapes with the same size word are `n`-similar for every `n`.
-/
theorem similar_of_sizeWord_eq {a b : Shape} (h : sizeWord a = sizeWord b) (n : Nat) :
    similarN n a b := by
  -- Since `sizeWord a = sizeWord b`, we have `shapeNgrams n a = shapeNgrams n b` and hence `bagNgrams n a = bagNgrams n b`.
  simp [similarN, bagNgrams, shapeNgrams, h]

/-
At `n = 1`, similarity is exactly equality of the multiset of subtree sizes.
-/
theorem similarN_one_iff (a b : Shape) :
    similarN 1 a b ↔ (sizeWord a : Multiset Nat) = (sizeWord b : Multiset Nat) := by
  constructor;
  · unfold similarN bagNgrams shapeNgrams ngramsOf;
    intro h;
    convert congr_arg ( Multiset.map ( fun x => x.head! ) ) h using 1;
    · refine' congr_arg _ ( List.ext_get _ _ ) <;> simp +decide;
      intro n hn; rw [ List.take_add_one ] ; aesop;
    · refine' congr_arg _ ( List.ext_get _ _ ) <;> simp +decide;
      intro n hn; rw [ List.take_add_one ] ; aesop;
  · intro h
    simp [similarN, bagNgrams, shapeNgrams, ngramsOf_one];
    exact Multiset.coe_eq_coe.mp h |> List.Perm.map _

/-! ## Sweeping from 1-grams up to 71-grams -/

/-- The **gram profile** of a shape: its bag of `n`-grams for every window size `n = 1 … 71`
("from 1 arrow up to 71-grams"). -/
def gramProfile (s : Shape) : List (Multiset (List Nat)) :=
  (List.range 71).map (fun k => bagNgrams (k + 1) s)

/-- Two shapes are **similar up to 71-grams** when their whole gram profiles agree. -/
def similarUpTo (a b : Shape) : Prop := gramProfile a = gramProfile b

/-
Similarity up to 71-grams is an equivalence relation.
-/
theorem similarUpTo_equivalence : Equivalence similarUpTo := by
  constructor;
  · exact fun x => rfl;
  · exact fun h => h.symm;
  · exact fun h1 h2 => h1.trans h2

/-
Agreeing up to 71-grams implies `n`-similarity for each `1 ≤ n ≤ 71`.
-/
theorem similarN_of_similarUpTo {a b : Shape} (h : similarUpTo a b)
    {n : Nat} (h1 : 1 ≤ n) (h71 : n ≤ 71) : similarN n a b := by
  rcases n with ( _ | _ | n ) <;> simp_all +arith +decide [ similarUpTo ];
  · unfold gramProfile at h; aesop;
  · unfold similarN; simp_all +arith +decide [ gramProfile ] ;

/-! ## A shape-constraint language -/

/-- A small **shape-constraint language**: numeric size/depth bounds, the presence of a
given `n`-gram (arrow pattern), and boolean combinators. -/
inductive ShapeConstraint where
  | tru : ShapeConstraint
  | fls : ShapeConstraint
  | sizeEq : Nat → ShapeConstraint
  | sizeLe : Nat → ShapeConstraint
  | depthLe : Nat → ShapeConstraint
  | hasNgram : List Nat → ShapeConstraint
  | and : ShapeConstraint → ShapeConstraint → ShapeConstraint
  | or : ShapeConstraint → ShapeConstraint → ShapeConstraint
  | not : ShapeConstraint → ShapeConstraint
deriving Inhabited

/-- The computable evaluator of the shape-constraint language. `hasNgram g` checks whether
the pattern `g` occurs as a `g.length`-gram of the shape. -/
def eval : ShapeConstraint → Shape → Bool
  | .tru, _ => true
  | .fls, _ => false
  | .sizeEq n, s => size s == n
  | .sizeLe n, s => decide (size s ≤ n)
  | .depthLe n, s => decide (depth s ≤ n)
  | .hasNgram g, s => (shapeNgrams g.length s).contains g
  | .and a b, s => eval a s && eval b s
  | .or a b, s => eval a s || eval b s
  | .not a, s => !eval a s

@[simp] theorem eval_tru (s : Shape) : eval .tru s = true := rfl
@[simp] theorem eval_fls (s : Shape) : eval .fls s = false := rfl
@[simp] theorem eval_and (a b : ShapeConstraint) (s : Shape) :
    eval (.and a b) s = (eval a s && eval b s) := rfl
@[simp] theorem eval_or (a b : ShapeConstraint) (s : Shape) :
    eval (.or a b) s = (eval a s || eval b s) := rfl
@[simp] theorem eval_not (a : ShapeConstraint) (s : Shape) :
    eval (.not a) s = !eval a s := rfl

/-
The `sizeEq` constraint expresses exactly "has size `n`".
-/
theorem eval_sizeEq (n : Nat) (s : Shape) : eval (.sizeEq n) s = true ↔ size s = n := by
  simp [eval]

/-
The `sizeLe` constraint expresses exactly "has size at most `n`".
-/
theorem eval_sizeLe (n : Nat) (s : Shape) : eval (.sizeLe n) s = true ↔ size s ≤ n := by
  simp +decide [ eval ]

/-
The size-class `SizeClass n` is exactly the set carved out by the `sizeEq n` constraint:
the constraint language can express the size signatures.
-/
theorem sizeClass_eq_eval (n : Nat) :
    SizeClass n = {s | eval (.sizeEq n) s = true} := by
  ext s; exact (by
  constructor <;> intro h <;> have := eval_sizeEq n s <;> aesop)

/-! ## A Clifford algebra of shapes -/

/-- The quadratic form `Q x = x · x` on `ℚ`, the form of our Clifford algebra of shapes. -/
noncomputable def Q : QuadraticForm ℚ ℚ := QuadraticMap.sq

theorem Q_apply (x : ℚ) : Q x = x * x := by
  simp [Q, QuadraticMap.sq]

/-- The Clifford **generator** of a size `n`: the image of `(n : ℚ)` under the canonical map
`ι`. Each size becomes a vector of the Clifford algebra. -/
noncomputable def shapeGen (n : Nat) : CliffordAlgebra Q := CliffordAlgebra.ι Q (n : ℚ)

/-- The Clifford element of a size *word*: the ordered product of the generators. -/
noncomputable def wordElt (l : List Nat) : CliffordAlgebra Q := (l.map shapeGen).prod

/-- The Clifford element of a *shape*: the ordered product of the generators along its size
word. This realises a shape as an element of the Clifford algebra of shapes. -/
noncomputable def shapeCliff (s : Shape) : CliffordAlgebra Q := wordElt (sizeWord s)

@[simp] theorem wordElt_nil : wordElt [] = 1 := by simp [wordElt]

@[simp] theorem wordElt_cons (n : Nat) (l : List Nat) :
    wordElt (n :: l) = shapeGen n * wordElt l := by simp [wordElt]

/-
The Clifford element of a word is multiplicative in concatenation: `wordElt` is a monoid
homomorphism from words (under `++`) into the Clifford algebra.
-/
theorem wordElt_append (l₁ l₂ : List Nat) :
    wordElt (l₁ ++ l₂) = wordElt l₁ * wordElt l₂ := by
  unfold wordElt; rw [List.map_append, List.prod_append]

/-
The defining **Clifford relation**: the generator of size `n` squares to the scalar
`n · n` (the value of the quadratic form).
-/
theorem shapeGen_sq (n : Nat) :
    shapeGen n * shapeGen n = algebraMap ℚ (CliffordAlgebra Q) ((n : ℚ) * (n : ℚ)) := by
  convert CliffordAlgebra.ι_sq_scalar Q ( n : ℚ ) using 1

end ShapeAlgebra