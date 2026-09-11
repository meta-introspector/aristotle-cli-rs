import RequestProject.Nix.NixWars.Session

/-!
# The 71-shard DMZ

The BBS is not one machine: the world of the *shards* project is cut into 71
shards, and every artefact — a file, a challenge, a player — is placed on the
shard given by its hash modulo 71. A session already carries the shard it is
on (`GameSession.shard`); this file is the theory of that number.

What is formalized here:

* `numShards = 71` is prime, so the shard space is the field `ZMod 71` and
  every non-trivial rotation of the ring is a permutation of the shards
  (`rotate_bijective`);
* `shardOf n = n % 71`, the placement rule the repository uses, is a genuine
  index (`shardOf_lt`), is idempotent (`shardOf_shardOf`), and is *balanced*:
  a run of `71 * k` consecutive artefacts puts exactly `k` on every shard
  (`shard_balanced`);
* the fifteen Monster primes — the primes dividing the order of the Monster
  group — are primes, are exactly the primes occurring in that order
  (`monsterOrder_factorization`), and their largest is `71`
  (`le_seventyOne_of_mem_monsterPrimes`), which is where the number of shards
  comes from;
* shard 47 is the Monster Crown, the shard that unlocks j-invariant navigation
  in NixWars, and 47 is itself a Monster prime (`crownShard_mem_monsterPrimes`);
* routing on the ring is Chord-style, by powers of two (`chordHop`), and any
  shard reaches any other in at most seven hops (`chordPath_chordRoute`,
  `length_chordRoute_le`) — the `O(log N)` lookup of a Chord DHT, made concrete
  for `N = 71`.
-/

namespace NixWars

/-! ## The shard space -/

/-- The world is cut into 71 shards. -/
def numShards : Nat := 71

/-- 71 is prime — this is why the shard space is a field, and why rotations of
the ring never collapse two shards onto one. -/
theorem numShards_prime : Nat.Prime numShards := by decide

/-- Where an artefact with hash `n` lives. -/
def shardOf (n : Nat) : Nat := n % numShards

theorem shardOf_lt (n : Nat) : shardOf n < numShards :=
  Nat.mod_lt _ (by decide)

/-- Placing an artefact twice does not move it. -/
@[simp] theorem shardOf_shardOf (n : Nat) : shardOf (shardOf n) = shardOf n := by
  simp [shardOf, Nat.mod_mod_of_dvd]

/-- Every shard is used: shard `s` holds the artefact numbered `s`. -/
theorem shardOf_surjective {s : Nat} (hs : s < numShards) : shardOf s = s :=
  Nat.mod_eq_of_lt hs

/-- A *fixed point* of the placement rule, in the sense of the repository's
"location = value": an artefact that is numbered by the shard it lives on. -/
def IsShardFixedPoint (n : Nat) : Prop := shardOf n = n

theorem isShardFixedPoint_iff (n : Nat) : IsShardFixedPoint n ↔ n < numShards := by
  constructor
  · intro h; rw [← h]; exact shardOf_lt n
  · intro h; exact shardOf_surjective h

/-! ## The placement is balanced

Sharding by `n % 71` is not merely total, it is fair: over any run of `71 * k`
consecutive identifiers each shard receives exactly `k` of them. -/

/-- The identifiers below `m * k` that land on shard `j` are exactly
`j, m + j, 2m + j, …`. -/
theorem filter_mod_eq (m k j : Nat) (hj : j < m) :
    (Finset.range (m * k)).filter (fun i => i % m = j)
      = (Finset.range k).image (fun q => m * q + j) := by
  have hm : 0 < m := by omega
  ext i
  simp only [Finset.mem_filter, Finset.mem_range, Finset.mem_image]
  constructor
  · rintro ⟨hi, hmod⟩
    refine ⟨i / m, Nat.div_lt_of_lt_mul (by omega), ?_⟩
    have := Nat.div_add_mod i m
    omega
  · rintro ⟨q, hq, rfl⟩
    refine ⟨?_, by simp [Nat.mod_eq_of_lt hj]⟩
    calc m * q + j < m * q + m := by omega
      _ = m * (q + 1) := by ring
      _ ≤ m * k := Nat.mul_le_mul_left m (by omega)

/-- **The sharding is balanced.** Of `71 * k` consecutive artefacts, exactly `k`
land on each shard. -/
theorem shard_balanced (k j : Nat) (hj : j < numShards) :
    ((Finset.range (numShards * k)).filter (fun i => shardOf i = j)).card = k := by
  have : ((Finset.range (numShards * k)).filter (fun i => i % numShards = j)).card = k := by
    rw [filter_mod_eq numShards k j hj, Finset.card_image_of_injective _ ?inj,
      Finset.card_range]
    case inj =>
      intro a b hab
      simp only [Nat.add_right_cancel_iff] at hab
      exact Nat.eq_of_mul_eq_mul_left (by decide) hab
  simpa [shardOf] using this

/-! ## Rotating the ring

The shard space is `ZMod 71`, a field. Rotating by an offset, or dilating by a
non-zero factor, permutes the shards: no gossip re-keying can collapse two
shards into one. -/

instance : Fact (Nat.Prime numShards) := ⟨numShards_prime⟩

/-- Dilating the ring of shards by a non-zero factor. -/
def rotate (a b : ZMod numShards) (s : ZMod numShards) : ZMod numShards := a * s + b

/-- **A non-degenerate rotation is a permutation of the shards.** -/
theorem rotate_bijective {a b : ZMod numShards} (ha : a ≠ 0) :
    Function.Bijective (rotate a b) := by
  refine ⟨fun x y hxy => ?_, fun y => ⟨a⁻¹ * (y - b), ?_⟩⟩
  · have : a * x = a * y := by
      simpa [rotate, add_left_inj] using hxy
    exact mul_left_cancel₀ ha this
  · rw [rotate, ← mul_assoc, mul_inv_cancel₀ ha, one_mul, sub_add_cancel]

/-! ## The Monster primes

The 71 shards come from the largest prime dividing the order of the Monster
group. -/

/-- The order of the Monster group. -/
def monsterOrder : Nat := 808017424794512875886459904961710757005754368000000000

/-- The fifteen Monster primes (the supersingular primes dividing
`monsterOrder`). -/
def monsterPrimes : List Nat := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

theorem monsterPrimes_length : monsterPrimes.length = 15 := rfl

theorem monsterPrimes_prime : ∀ p ∈ monsterPrimes, Nat.Prime p := by decide

theorem monsterPrimes_nodup : monsterPrimes.Nodup := by decide

/-- The factorization the Monster primes come from. -/
theorem monsterOrder_factorization :
    monsterOrder =
      2 ^ 46 * 3 ^ 20 * 5 ^ 9 * 7 ^ 6 * 11 ^ 2 * 13 ^ 3 *
        17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71 := by
  norm_num [monsterOrder]

/-- Every Monster prime divides the order of the Monster. -/
theorem monsterPrimes_dvd : ∀ p ∈ monsterPrimes, p ∣ monsterOrder := by
  decide

/-- **71 is the largest Monster prime** — hence 71 shards. -/
theorem le_seventyOne_of_mem_monsterPrimes : ∀ p ∈ monsterPrimes, p ≤ numShards := by
  decide

theorem numShards_mem_monsterPrimes : numShards ∈ monsterPrimes := by decide

/-- Shard 47 holds the Monster Crown, which unlocks j-invariant navigation. -/
def crownShard : Nat := 47

theorem crownShard_mem_monsterPrimes : crownShard ∈ monsterPrimes := by decide

theorem crownShard_lt : crownShard < numShards := by decide

/-! ## Chord routing between shards

Gossip between shards travels the ring by powers of two, as in a Chord DHT.
Seven hops always suffice, because `71 < 2 ^ 7`. -/

/-- One Chord hop: jump `2 ^ k` shards around the ring. -/
def chordHop (s k : Nat) : Nat := (s + 2 ^ k) % numShards

/-- Follow a route of hops. -/
def chordPath (s : Nat) (ks : List Nat) : Nat := ks.foldl chordHop s

theorem chordHop_lt (s k : Nat) : chordHop s k < numShards :=
  Nat.mod_lt _ (by decide)

/-- The route from shard `s` to shard `t`: the bits of their difference. -/
def chordRoute (s t : Nat) : List Nat :=
  (List.range 7).filter (fun k => ((t + numShards - s % numShards) % numShards).testBit k)

/-- **Routing is `O(log N)`:** never more than seven hops. -/
theorem length_chordRoute_le (s t : Nat) : (chordRoute s t).length ≤ 7 := by
  simpa using (List.length_filter_le _ (List.range 7))

/-- **Every shard reaches every shard.** Following the Chord route from `s`
arrives exactly at `t`. -/
theorem chordPath_chordRoute : ∀ s < numShards, ∀ t < numShards, chordPath s (chordRoute s t) = t := by
  decide

/-! ## Gossip: flooding the ring in seven rounds

The agents on the shards gossip by the same power-of-two schedule: in round `k`
every shard that already has the message forwards it `2 ^ k` positions around
the ring. Seven rounds inform all 71 shards, whoever started. -/

/-- The shards that know a message started at `s`, after `k` rounds of
doubling gossip. -/
def gossip (s : Nat) : Nat → Finset Nat
  | 0 => {s % numShards}
  | k + 1 => gossip s k ∪ (gossip s k).image (fun x => (x + 2 ^ k) % numShards)

/-- After `k` rounds, the informed shards are exactly the `2 ^ k` positions
ahead of the origin. -/
theorem gossip_eq (s : Nat) : ∀ k,
    gossip s k = (Finset.range (2 ^ k)).image (fun d => (s + d) % numShards) := by
  intro k
  induction k with
  | zero => simp [gossip]
  | succ k ih =>
      ext t
      simp only [gossip, ih, Finset.mem_union, Finset.mem_image, Finset.mem_range,
        Finset.image_image, Function.comp_def]
      constructor
      · rintro (⟨d, hd, rfl⟩ | ⟨d, hd, rfl⟩)
        · exact ⟨d, by omega, rfl⟩
        · exact ⟨d + 2 ^ k, by omega, by rw [Nat.mod_add_mod, Nat.add_assoc]⟩
      · rintro ⟨d, hd, rfl⟩
        rcases lt_or_ge d (2 ^ k) with h | h
        · exact Or.inl ⟨d, h, rfl⟩
        · refine Or.inr ⟨d - 2 ^ k, by omega, ?_⟩
          have hd' : s + (d - 2 ^ k) + 2 ^ k = s + d := by omega
          rw [Nat.mod_add_mod, hd']

/-- **Seven rounds of gossip inform the whole DMZ**, from any starting
shard. -/
theorem gossip_complete (s t : Nat) (ht : t < numShards) : t ∈ gossip s 7 := by
  rw [gossip_eq]
  refine Finset.mem_image.2 ⟨(t + numShards - s % numShards) % numShards, ?_, ?_⟩
  · show (t + numShards - s % numShards) % numShards ∈ Finset.range 128
    simp only [Finset.mem_range, numShards]
    omega
  · simp only [numShards] at ht ⊢
    omega

/-! ## Monster arithmetic the shards are named for -/

/-- The dimension of the Monster's smallest faithful representation. -/
def monsterDimension : Nat := 196883

/-- 71 divides 196883 — the reason the representation splits over the 71
shards. -/
theorem numShards_dvd_monsterDimension : numShards ∣ monsterDimension := by decide

/-- McKay's observation: the first non-trivial `j`-invariant coefficient is the
Monster dimension plus the trivial representation. -/
theorem jInvariant_coefficient : monsterDimension + 1 = 196884 := by decide

/-- 71 divides the order of the Monster. -/
theorem monsterOrder_mod_numShards : monsterOrder % numShards = 0 := by decide

/-! ## Placing a player -/

/-- The shard a player is dealt into: the placement rule applied to the digest
of their public key. -/
def placeSession {g : DoorGame} (user game : Nat) (st : g.State) : GameSession g :=
  { user := user, shard := shardOf user, game := game, state := st }

/-- A dealt session is always on a real shard. -/
theorem placeSession_shard_lt {g : DoorGame} (user game : Nat) (st : g.State) :
    (placeSession (g := g) user game st).shard < numShards :=
  shardOf_lt user

/-- Two players on the same shard are exactly two players whose digests agree
modulo 71. -/
theorem placeSession_shard_eq {g : DoorGame} (u₁ u₂ game : Nat) (st : g.State) :
    (placeSession (g := g) u₁ game st).shard = (placeSession (g := g) u₂ game st).shard
      ↔ u₁ ≡ u₂ [MOD numShards] :=
  Iff.rfl

end NixWars
