/-
Coverage.lean — A machine-checked theory of dependency coverage, clustering, and interfaces.

This is the verified mathematical core behind the splitting/clustering tools
(`SplitDecls`, `DupFinder`, `ClusterDecls`). It models a code base as a directed
dependency graph and proves the properties those tools rely on:

* **Provable minimal coverage.** For a target set `T` of declarations, the *cover*
  `cover T` (everything reachable from `T` through the dependency edges, `T` included)
  is the unique *minimal* self-contained set that contains `T`:
  - `cover_covers`     : `cover T` is self-contained and contains `T`;
  - `cover_minimal`    : every self-contained set containing `T` contains `cover T`;
  - `cover_least`      : `cover T` is the least element of the covering sets;
  - `cover_eq_of_minimal` : it is the *unique* minimal cover.
  This justifies "load each declaration on its own with all the parts it needs, and no
  more": `cover {d}` is exactly the minimal set of declarations to load to use `d`.

* **Interfaces.** The *interface* of a cluster `K` is the set of external declarations it
  directly depends on. We prove the interface fully captures a cluster's external needs:
  `cover K = K ∪ cover (interface K)` (`cover_eq_cluster_interface`). So a cluster
  compiles given its own contents plus the covers of its interface — nothing else.

* **Topological clustering / build order.** With a strict rank (e.g. dependency depth),
  the dependency graph is acyclic (`reaches_antisymm`), reachability cannot increase rank
  (`reaches_rank_le`), and the rank-`i` cluster's interface lives strictly below level `i`
  (`interface_rankCluster_lt`). Hence the cluster graph is a DAG that can be built level by
  level (lower levels first), with independent clusters at the same level built in parallel.

Everything is proved with no `sorry` and only standard axioms.
-/
import Mathlib

namespace Coverage

variable {V : Type*}

-- The direct-dependency function: `deps a` is the set of declarations `a` directly uses.
variable (deps : V → Set V)

/-- One direct dependency step: `b` is directly used by `a`. -/
def Step (a b : V) : Prop := b ∈ deps a

/-- `Reaches a b` : `a` (transitively, reflexively) depends on `b`. -/
def Reaches : V → V → Prop := Relation.ReflTransGen (Step deps)

/-- The **cover** of a target set `T`: every declaration reachable from some member of `T`
(including `T` itself). This is the set of declarations one must load to use `T`. -/
def cover (T : Set V) : Set V := {v | ∃ t ∈ T, Reaches deps t v}

/-- A set `S` is **self-contained** if it contains all direct dependencies of its members. -/
def IsSelfContained (S : Set V) : Prop := ∀ a ∈ S, deps a ⊆ S

/-- `S` **covers** `T`: it is self-contained and contains `T`. Such a set is enough to
build everything in `T`. -/
def Covers (S T : Set V) : Prop := T ⊆ S ∧ IsSelfContained deps S

/-! ## Reachability basics -/

theorem reaches_refl (a : V) : Reaches deps a a := Relation.ReflTransGen.refl

theorem reaches_tail {a b c : V} (hab : Reaches deps a b) (hbc : c ∈ deps b) :
    Reaches deps a c := Relation.ReflTransGen.tail hab hbc

theorem reaches_trans {a b c : V} (hab : Reaches deps a b) (hbc : Reaches deps b c) :
    Reaches deps a c := Relation.ReflTransGen.trans hab hbc

/-! ## Minimal coverage -/

/-- Targets are contained in their own cover. -/
theorem subset_cover (T : Set V) : T ⊆ cover deps T := by
  exact fun x hx => ⟨ x, hx, Relation.ReflTransGen.refl ⟩

/-- The cover is self-contained. -/
theorem cover_selfContained (T : Set V) : IsSelfContained deps (cover deps T) := by
  intro a ha b;
  obtain ⟨ t, ht, h ⟩ := ha;
  exact fun hb => ⟨ t, ht, h.tail hb ⟩

/-- **The cover is a valid coverage of its targets.** -/
theorem cover_covers (T : Set V) : Covers deps (cover deps T) T :=
  ⟨subset_cover deps T, cover_selfContained deps T⟩

/-- A member reached from a set contained in a self-contained `S` lies in `S`. -/
theorem mem_of_reaches {S : Set V} (hSC : IsSelfContained deps S) {t v : V}
    (ht : t ∈ S) (h : Reaches deps t v) : v ∈ S := by
  induction h;
  · exact ht;
  · exact hSC _ ‹_› ‹_›

/-- **Minimality of coverage.** Every self-contained set that contains the targets
contains the cover. -/
theorem cover_minimal {S T : Set V} (h : Covers deps S T) : cover deps T ⊆ S := by
  -- By definition of `Covers`, we know that `T ⊆ S` and `IsSelfContained deps S`.
  obtain ⟨hTS, hSC⟩ := h;
  exact fun v hv => by rcases hv with ⟨ t, ht, hv ⟩ ; exact mem_of_reaches deps hSC ( hTS ht ) hv;

/-- `cover T` is the least covering set: it covers `T`, and is below any other cover. -/
theorem cover_least (T : Set V) :
    Covers deps (cover deps T) T ∧ ∀ S, Covers deps S T → cover deps T ⊆ S :=
  ⟨cover_covers deps T, fun _ h => cover_minimal deps h⟩

/-- **Uniqueness of the minimal cover.** Any *minimal* covering set equals `cover T`. -/
theorem cover_eq_of_minimal {S T : Set V} (hCov : Covers deps S T)
    (hmin : ∀ S', Covers deps S' T → S ⊆ S') : S = cover deps T := by
  refine' Set.Subset.antisymm ( hmin _ ( Coverage.cover_covers _ _ ) ) ( Coverage.cover_minimal _ _ );
  exact hCov

/-! ## Algebraic properties of `cover` -/

/-- The cover is monotone in its target set. -/
theorem cover_mono {T₁ T₂ : Set V} (h : T₁ ⊆ T₂) : cover deps T₁ ⊆ cover deps T₂ := by
  exact fun x ⟨ t, ht, p ⟩ => ⟨ t, h ht, p ⟩

/-- The cover is idempotent. -/
theorem cover_cover (T : Set V) : cover deps (cover deps T) = cover deps T := by
  refine' Set.Subset.antisymm _ _;
  · -- By definition of cover, we know that every element in `cover deps (cover deps T)` is reachable from `cover deps T`.
    intro v hv
    obtain ⟨t, htT, hvt⟩ := hv;
    -- By definition of cover, we know that every element in `cover deps T` is reachable from `T`.
    obtain ⟨u, huT, hut⟩ := htT;
    exact ⟨ u, huT, hut.trans hvt ⟩;
  · exact subset_cover deps (cover deps T)

/-- The cover distributes over unions. -/
theorem cover_union (T₁ T₂ : Set V) :
    cover deps (T₁ ∪ T₂) = cover deps T₁ ∪ cover deps T₂ := by
  ext v;
  simp [cover];
  grind

/-- The cover of a union of targets is the union of covers (indexed form). -/
theorem cover_iUnion {ι : Type*} (T : ι → Set V) :
    cover deps (⋃ i, T i) = ⋃ i, cover deps (T i) := by
  -- To prove the equality of sets, we show each set is a subset of the other.
  apply Set.ext
  intro v
  simp [cover];
  grind +qlia

/-! ## Interfaces of clusters

A *cluster* is just a set of declarations `K` (e.g. a group produced by the topological
clustering). Its **interface** is the set of declarations *outside* `K` that members of
`K` directly depend on — the external surface a cluster needs in order to build. -/

/-- The **interface** of a cluster `K`: external declarations directly used by `K`. -/
def interface (K : Set V) : Set V := {w | w ∉ K ∧ ∃ v ∈ K, w ∈ deps v}

/-- The interface is contained in the cluster's cover. -/
theorem interface_subset_cover (K : Set V) : interface deps K ⊆ cover deps K := by
  intro w hw; cases hw;
  case _ => rename_i hw; rcases hw with ⟨ v, hvK, hvw ⟩ ; exact ⟨ v, hvK, Relation.ReflTransGen.tail Relation.ReflTransGen.refl hvw ⟩ ;

/-- **Interface correctness.** A cluster's cover is the cluster together with the cover of
its interface: the interface fully captures the cluster's external requirements. -/
theorem cover_eq_cluster_interface (K : Set V) :
    cover deps K = K ∪ cover deps (interface deps K) := by
  refine' le_antisymm _ _;
  · intro v hv;
    obtain ⟨ t, ht, h ⟩ := hv;
    induction h <;> simp_all +decide;
    cases ‹_› <;> simp_all +decide [ Step, cover ];
    · exact Classical.or_iff_not_imp_left.2 fun h => ⟨ _, ⟨ h, _, ‹_›, ‹_› ⟩, by tauto ⟩;
    · exact Or.inr ( by rename_i h; obtain ⟨ t, ht, h ⟩ := h; exact ⟨ t, ht, h.tail ‹_› ⟩ );
  · refine' Set.union_subset ( subset_cover deps K ) _;
    apply Set.Subset.trans ( cover_mono deps ( interface_subset_cover deps K ) );
    rw [ cover_cover ]

/-! ## Topological clustering by rank

A `rank` that strictly decreases along every dependency edge witnesses that the graph is a
DAG (no cycles) and induces a layered clustering: cluster `i` = the declarations of rank
`i`. We show each cluster only depends on strictly-earlier clusters, so the clusters form a
DAG that can be built level by level. -/

/-- Reachability cannot increase a non-increasing rank. -/
theorem reaches_rank_le (rank : V → ℕ)
    (hrank : ∀ a, ∀ b ∈ deps a, rank b ≤ rank a) {a b : V} (h : Reaches deps a b) :
    rank b ≤ rank a := by
  induction h <;> [ rfl; linarith [ hrank _ _ ‹_› ] ]

/-- With a strictly-decreasing rank, the dependency graph is **acyclic**: mutual
reachability forces equality. -/
theorem reaches_antisymm (rank : V → ℕ)
    (hrank : ∀ a, ∀ b ∈ deps a, rank b < rank a) {a b : V}
    (hab : Reaches deps a b) (hba : Reaches deps b a) : a = b := by
  by_contra h_neq;
  -- By induction on the length of the path, we can show that if there's a path from `a` to `b`, then `rank a > rank b`.
  have h_ind : ∀ {a b : V}, Reaches deps a b → a ≠ b → rank a > rank b := by
    intro a b hab h_neq
    induction' hab with a b hab ih;
    · contradiction;
    · grind +locals;
  linarith [ h_ind hab h_neq, h_ind hba ( Ne.symm h_neq ) ]

/-- The rank-`i` cluster. -/
def rankCluster (rank : V → ℕ) (i : ℕ) : Set V := {v | rank v = i}

/-- **Topological clustering.** Every interface declaration of the rank-`i` cluster has
rank strictly less than `i`: cluster `i` depends only on earlier clusters. -/
theorem interface_rankCluster_lt (rank : V → ℕ)
    (hrank : ∀ a, ∀ b ∈ deps a, rank b < rank a) (i : ℕ) {w : V}
    (hw : w ∈ interface deps (rankCluster rank i)) : rank w < i := by
  -- From hw, we know that there exists a v in the rank-i cluster such that w is a direct dependency of v.
  obtain ⟨v, hv_cluster, hv_dep⟩ : ∃ v ∈ rankCluster rank i, w ∈ deps v := by
    exact hw.2;
  exact lt_of_lt_of_le ( hrank v w hv_dep ) hv_cluster.le

/-- The cover of the rank-`i` cluster stays at rank `≤ i`: building cluster `i` only ever
pulls in declarations of its own level or below. -/
theorem cover_rankCluster_le (rank : V → ℕ)
    (hrank : ∀ a, ∀ b ∈ deps a, rank b ≤ rank a) (i : ℕ) {v : V}
    (hv : v ∈ cover deps (rankCluster rank i)) : rank v ≤ i := by
  -- By definition of cover, there exists some $t \in \text{rankCluster } \text{rank } i$ such that $v$ is reachable from $t$.
  obtain ⟨t, ht₁, ht₂⟩ : ∃ t ∈ rankCluster rank i, Reaches deps t v := by
    exact hv;
  exact le_trans ( reaches_rank_le deps rank ( fun a b hb => hrank a b hb ) ht₂ ) ( by simpa [ rankCluster ] using ht₁.le )

end Coverage