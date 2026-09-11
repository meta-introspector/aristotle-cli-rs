import RequestProject.Nix.NixWars.Empire

/-!
# The ledger: a game as a hash chain

A game of *Foundation and Empire* is not a server session. It is a log: the
opening position, which is fixed, and the list of commands played since. Every
command extends the log by one, and with it the *chain* — one hash per state,
each hash folded from the hash before it, the command played and the state the
command produced.

That is what makes a move into a page. A player holds a page carrying the log;
they play a command; the page writes out a new page carrying the log with the
command appended. Anyone with the new page can replay the whole game from the
opening position and check every hash. The last hash is the commitment: the
number a player can post to a chain, a rollup or a bulletin board to stake a
claim on the position they are in.

What is proved here:

* the chain has one hash per state (`chain_length`), starts at the hash of the
  opening position (`chain_head`) and is *append-only* — playing on extends the
  chain and never rewrites a hash of it (`chain_prefix`, `chain_append`);
* replaying the log gives the state the chain's last hash was taken of
  (`commit_eq`);
* the verifier is exactly right: `verify` accepts a record if and only if
  every command in it is legal where it is played and every hash in it is the
  hash the rules give (`verifyFrom_iff`);
* tamper evidence: *if* the mixer never collides, two different logs of the
  same length cannot produce the same chain (`chainFrom_inj`), and hence not
  the same commitment (`commit_inj`). Collision-freedom is a hypothesis, not a
  claim: the mixer shipped here is a 31-bit rolling hash. What is checked by
  computation is that the campaign's own seventy-nine hashes are distinct
  (`campaign_chain_distinct`).
-/

namespace NixWars

/-- The modulus of the rolling hash: the Mersenne prime `2^31 - 1`. -/
def hashPrime : Nat := 2147483647

/-- The base of the rolling hash. -/
def hashBase : Nat := 131

/-- Fold one number into a hash. -/
def mix (h b : Nat) : Nat := (h * hashBase + b + 1) % hashPrime

/-- Fold a list of numbers into a hash. -/
def hashNums (h : Nat) (l : List Nat) : Nat := l.foldl mix h

/-- A system as five numbers. -/
def encodeSys (s : Sys) : List Nat := [s.owner, s.pop, s.ind, s.s1, s.s2]

/-- A galaxy as numbers: every system, then the two treasuries, the two
technology levels, the round, the player to move and the winner. -/
def encodeGalaxy (g : Galaxy) : List Nat :=
  (g.sys.flatMap encodeSys) ++ [g.cred1, g.cred2, g.tech1, g.tech2, g.round, g.active, g.winner]

/-- A command as numbers: a tag and its arguments. -/
def encodeMove : Move → List Nat
  | .build s => [1, s, 0, 0]
  | .jump src dst n => [2, src, dst, n]
  | .colonise s => [3, s, 0, 0]
  | .research => [4, 0, 0, 0]
  | .pass => [5, 0, 0, 0]

/-- The hash of the opening position. -/
def rootHash (g : Galaxy) : Nat := hashNums 0 (encodeGalaxy g)

/-- One link of the chain: the hash before it, the command played, and the
state the command produced. -/
def chainStep (h : Nat) (m : Move) (g : Galaxy) : Nat :=
  hashNums h (encodeMove m ++ encodeGalaxy g)

/-- The hashes of the states a log passes through, after the opening one. -/
def chainFrom (g : Galaxy) (h : Nat) : List Move → List Nat
  | [] => []
  | m :: rest =>
      let g' := step g m
      let h' := chainStep h m g'
      h' :: chainFrom g' h' rest

/-- The whole chain of a log: the hash of the opening position, then one hash
per command played. -/
def chain (g : Galaxy) (l : List Move) : List Nat :=
  rootHash g :: chainFrom g (rootHash g) l

/-- The commitment of a log: its last hash. This is the number a player posts. -/
def commit (g : Galaxy) (l : List Move) : Nat :=
  (chainFrom g (rootHash g) l).foldl (fun _ h => h) (rootHash g)

/-- A record of a game: what was played, and what the player claims each state
hashed to. -/
abbrev Record := List (Move × Nat)

/-- Check a record against the rules and against the hashes: every command
legal where it is played, every hash the hash the rules give. -/
def verifyFrom (g : Galaxy) (h : Nat) : Record → Bool
  | [] => true
  | (m, x) :: rest =>
      let g' := step g m
      let h' := chainStep h m g'
      legal g m && x == h' && verifyFrom g' h' rest

/-- Check a record of a game from the opening position. -/
def verify (g : Galaxy) (r : Record) : Bool := verifyFrom g (rootHash g) r

/-! ## The chain is a chain -/

theorem chainFrom_length (g : Galaxy) (h : Nat) (l : List Move) :
    (chainFrom g h l).length = l.length := by
  induction l generalizing g h with
  | nil => rfl
  | cons m t ih => simp [chainFrom, ih]

/-- One hash per state. -/
theorem chain_length (g : Galaxy) (l : List Move) : (chain g l).length = l.length + 1 := by
  simp [chain, chainFrom_length]

/-- The chain starts at the hash of the opening position. -/
theorem chain_head (g : Galaxy) (l : List Move) : (chain g l).head? = some (rootHash g) := rfl

/-- Playing on extends the chain: the hashes already in it are not touched. -/
theorem chainFrom_append (g : Galaxy) (h : Nat) (l l' : List Move) :
    chainFrom g h (l ++ l') =
      chainFrom g h l ++ chainFrom (replay g l) (chainFrom g h l |>.foldl (fun _ x => x) h) l' := by
  induction l generalizing g h with
  | nil => rfl
  | cons m t ih =>
      simp only [List.cons_append, chainFrom, replay, List.foldl_cons]
      rw [ih]
      rfl

/-- The chain of a longer log extends the chain of the shorter one. -/
theorem chain_append (g : Galaxy) (l l' : List Move) :
    ∃ r, chain g (l ++ l') = chain g l ++ r := by
  refine ⟨chainFrom (replay g l) (chainFrom g (rootHash g) l |>.foldl (fun _ x => x) (rootHash g)) l', ?_⟩
  simp [chain, chainFrom_append]

/-- Append-only: the chain of a log is a prefix of the chain of anything played
on from it. -/
theorem chain_prefix (g : Galaxy) (l l' : List Move) :
    (chain g l).IsPrefix (chain g (l ++ l')) := by
  obtain ⟨r, hr⟩ := chain_append g l l'
  exact ⟨r, hr.symm⟩

/-- The commitment is the last hash of the chain. -/
theorem commit_eq (g : Galaxy) (l : List Move) :
    commit g l = (chain g l).foldl (fun _ x => x) 0 := by
  simp [commit, chain]

/-- Playing one more command moves the commitment on by one link. -/
theorem commit_snoc (g : Galaxy) (l : List Move) (m : Move) :
    commit g (l ++ [m]) = chainStep (commit g l) m (step (replay g l) m) := by
  simp only [commit, chainFrom_append]
  simp [chainFrom]

/-! ## The verifier -/

/-- The verifier accepts exactly the honest records: those whose commands are
legal where they are played and whose hashes are the hashes of the rules. -/
theorem verifyFrom_iff (g : Galaxy) (h : Nat) (r : Record) :
    verifyFrom g h r = true ↔
      (legalRun g (r.map Prod.fst) = true ∧ r.map Prod.snd = chainFrom g h (r.map Prod.fst)) := by
  induction r generalizing g h with
  | nil => simp [verifyFrom, legalRun, chainFrom]
  | cons a t ih =>
      obtain ⟨m, x⟩ := a
      simp only [verifyFrom, legalRun, chainFrom, List.map_cons, List.cons.injEq,
        Bool.and_eq_true, beq_iff_eq]
      rw [ih]
      constructor
      · rintro ⟨⟨hl, hx⟩, hleg, hrest⟩
        exact ⟨by simp [hl, hleg], hx, hrest⟩
      · rintro ⟨hall, hx, hrest⟩
        exact ⟨⟨hall.1, hx⟩, hall.2, hrest⟩

/-- A game played by the rules verifies. -/
theorem verify_of_play (g : Galaxy) (l : List Move) (hl : legalRun g l = true) :
    verify g (l.zip (chainFrom g (rootHash g) l)) = true := by
  have hlen : (l.zip (chainFrom g (rootHash g) l)).map Prod.fst = l := by
    simp [List.map_fst_zip, chainFrom_length]
  have hsnd : (l.zip (chainFrom g (rootHash g) l)).map Prod.snd = chainFrom g (rootHash g) l := by
    simp [List.map_snd_zip, chainFrom_length]
  rw [verify, verifyFrom_iff, hlen, hsnd]
  exact ⟨hl, rfl⟩

/-! ## Tamper evidence

Nothing here claims the 31-bit rolling hash is collision-free. What is proved
is the implication: a mixer that never collides makes the chain, and so the
commitment, determine the log. -/

/-- A mixer never collides on the arguments the chain feeds it. -/
def ChainInjective : Prop :=
  ∀ h₁ m₁ g₁ h₂ m₂ g₂, chainStep h₁ m₁ g₁ = chainStep h₂ m₂ g₂ → h₁ = h₂ ∧ m₁ = m₂ ∧ g₁ = g₂

/-- If the mixer never collides, two logs of the same length with the same
chain are the same log. -/
theorem chainFrom_inj (hinj : ChainInjective) (g : Galaxy) (h : Nat) :
    ∀ l₁ l₂ : List Move, l₁.length = l₂.length →
      chainFrom g h l₁ = chainFrom g h l₂ → l₁ = l₂ := by
  intro l₁
  induction l₁ generalizing g h with
  | nil => intro l₂ hlen _; cases l₂ <;> simp_all
  | cons m t ih =>
      intro l₂ hlen heq
      cases l₂ with
      | nil => simp at hlen
      | cons m' t' =>
          simp only [chainFrom, List.cons.injEq] at heq
          obtain ⟨hh, hrest⟩ := heq
          obtain ⟨-, hm, -⟩ := hinj _ _ _ _ _ _ hh
          subst hm
          have : t = t' := ih _ _ t' (by simpa using hlen) (by simpa [hh] using hrest)
          simp [this]

/-- If the mixer never collides, the commitment determines the log: two logs
of the same length with the same commitment are the same log. -/
theorem commit_inj (hinj : ChainInjective) (g : Galaxy) :
    ∀ (n : Nat) (l₁ l₂ : List Move), l₁.length = n → l₂.length = n →
      commit g l₁ = commit g l₂ → l₁ = l₂ := by
  intro n
  induction n with
  | zero =>
      intro l₁ l₂ h₁ h₂ _
      rw [List.length_eq_zero_iff] at h₁ h₂
      rw [h₁, h₂]
  | succ n ih =>
      intro l₁ l₂ h₁ h₂ hc
      obtain ⟨a, m₁, rfl⟩ : ∃ a b, l₁ = a ++ [b] := by
        rcases List.eq_nil_or_concat l₁ with rfl | ⟨a, b, rfl⟩
        · simp at h₁
        · exact ⟨a, b, List.concat_eq_append⟩
      obtain ⟨b, m₂, rfl⟩ : ∃ a b, l₂ = a ++ [b] := by
        rcases List.eq_nil_or_concat l₂ with rfl | ⟨a, b, rfl⟩
        · simp at h₂
        · exact ⟨a, b, List.concat_eq_append⟩
      rw [commit_snoc, commit_snoc] at hc
      obtain ⟨hcm, hm, -⟩ := hinj _ _ _ _ _ _ hc
      have ha : a.length = n := by simpa using h₁
      have hb : b.length = n := by simpa using h₂
      rw [ih a b ha hb hcm, hm]

/-! ## The campaign's own ledger -/

/-- Are all the numbers in a list different? -/
def allDistinct : List Nat → Bool
  | [] => true
  | x :: t => !t.contains x && allDistinct t

set_option maxRecDepth 100000

/-- The campaign's chain has one hash per state. -/
theorem campaign_chain_length : (chain genesis campaign).length = 79 := by decide

/-- The campaign's seventy-nine hashes are all different: no two states of the
game it records collide under the shipped mixer. -/
theorem campaign_chain_distinct : allDistinct (chain genesis campaign) = true := by decide

/-- The record of the campaign verifies. -/
theorem campaign_verifies :
    verify genesis (campaign.zip (chainFrom genesis (rootHash genesis) campaign)) = true :=
  verify_of_play genesis campaign campaign_legal

end NixWars
