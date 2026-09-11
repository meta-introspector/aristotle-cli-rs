import RequestProject.Craft.RealmWF

/-!
# The chain: every move is a block, every page is a chain

A page of the game carries the opening position and one **block** per move played
so far.  A block is `⟨index, move, hash of the previous block, hash of the state
after the move⟩`.  Anyone holding the page can *verify* it from scratch — replay
the moves against the rules of `RequestProject/Realm.lean` and check every hash —
and the hash of the last block is the single number a player commits on chain.

Everything is hashed through `hashWords`, FNV-1a over the little-endian bytes of a
list of numbers, so that a browser can recompute it with the same arithmetic.

The encodings are shown to be **injective** by exhibiting a decoder (`dec_enc`
lemmas), so the only cryptographic assumption anywhere in this development is
collision-freedom of `hashWords`, and it is written out as a hypothesis
(`Function.Injective hashWords`) on exactly the theorems that need it.
-/

namespace Realm

/-! ## §1  Encoding the game as numbers -/

/-- Code a unit type. -/
def Kind.code : Kind → Nat
  | .worker => 0
  | .soldier => 1

/-- Decode a unit type. -/
def Kind.ofCode : Nat → Kind
  | 0 => .worker
  | _ => .soldier

/-- Code a direction. -/
def Dir.code : Dir → Nat
  | .north => 0
  | .south => 1
  | .west => 2
  | .east => 3

/-- Decode a direction. -/
def Dir.ofCode : Nat → Dir
  | 0 => .north
  | 1 => .south
  | 2 => .west
  | _ => .east

/-- Code a flag. -/
def boolCode (b : Bool) : Nat := if b then 1 else 0

/-- A bank as three numbers. -/
def Res.enc (r : Res) : List Nat := [r.food, r.wood, r.gold]

/-- A piece as six numbers. -/
def Piece.enc (u : Piece) : List Nat := [u.owner, u.kind.code, u.x, u.y, u.hp, boolCode u.acted]

/-- A city as four numbers. -/
def City.enc (c : City) : List Nat := [c.owner, c.x, c.y, c.hp]

/-- A whole position as a list of numbers, lists length-prefixed. -/
def State.enc (st : State) : List Nat :=
  [st.turn, st.active] ++ st.red.enc ++ st.blue.enc ++
    (st.pieces.length :: st.pieces.flatMap Piece.enc) ++
    (st.cities.length :: st.cities.flatMap City.enc)

/-- A move as three numbers: tag, index, parameter. -/
def Move.enc : Move → List Nat
  | .march i d  => [0, i, d.code]
  | .strike i d => [1, i, d.code]
  | .gather i   => [2, i, 0]
  | .found i    => [3, i, 0]
  | .train c k  => [4, c, k.code]
  | .endTurn    => [5, 0, 0]

/-! ## §2  Decoding them back -/

/-- Read a bank off the front of a list. -/
def decRes : List Nat → Option (Res × List Nat)
  | f :: w :: g :: rest => some (⟨f, w, g⟩, rest)
  | _ => none

/-- Read a piece off the front of a list. -/
def decPiece : List Nat → Option (Piece × List Nat)
  | o :: k :: x :: y :: hp :: a :: rest => some (⟨o, Kind.ofCode k, x, y, hp, a != 0⟩, rest)
  | _ => none

/-- Read a city off the front of a list. -/
def decCity : List Nat → Option (City × List Nat)
  | o :: x :: y :: hp :: rest => some (⟨o, x, y, hp⟩, rest)
  | _ => none

/-- Read `n` pieces. -/
def decPieces : Nat → List Nat → Option (List Piece × List Nat)
  | 0, l => some ([], l)
  | n + 1, l => (decPiece l).bind fun p =>
      (decPieces n p.2).map fun q => (p.1 :: q.1, q.2)

/-- Read `n` cities. -/
def decCities : Nat → List Nat → Option (List City × List Nat)
  | 0, l => some ([], l)
  | n + 1, l => (decCity l).bind fun p =>
      (decCities n p.2).map fun q => (p.1 :: q.1, q.2)

/-- Read a position off the front of a list. -/
def decState (l : List Nat) : Option (State × List Nat) :=
  match l with
  | t :: a :: rest =>
    (decRes rest).bind fun p =>
      (decRes p.2).bind fun q =>
        match q.2 with
        | np :: rest2 =>
          (decPieces np rest2).bind fun ps =>
            match ps.2 with
            | nc :: rest3 =>
              (decCities nc rest3).map fun cs =>
                ({ turn := t, active := a, pieces := ps.1, cities := cs.1,
                   red := p.1, blue := q.1 }, cs.2)
            | _ => none
        | _ => none
  | _ => none

/-- Read a move off the front of a list. -/
def decMove : List Nat → Option (Move × List Nat)
  | 0 :: i :: d :: rest => some (.march i (Dir.ofCode d), rest)
  | 1 :: i :: d :: rest => some (.strike i (Dir.ofCode d), rest)
  | 2 :: i :: _ :: rest => some (.gather i, rest)
  | 3 :: i :: _ :: rest => some (.found i, rest)
  | 4 :: c :: k :: rest => some (.train c (Kind.ofCode k), rest)
  | 5 :: _ :: _ :: rest => some (.endTurn, rest)
  | _ => none

/-! ## §3  Round trips, hence injectivity -/

theorem decRes_enc (r : Res) (l : List Nat) : decRes (r.enc ++ l) = some (r, l) := by
  cases r; rfl

theorem decPiece_enc (u : Piece) (l : List Nat) : decPiece (u.enc ++ l) = some (u, l) := by
  obtain ⟨o, k, x, y, hp, a⟩ := u
  cases k <;> cases a <;> rfl

theorem decCity_enc (c : City) (l : List Nat) : decCity (c.enc ++ l) = some (c, l) := by
  cases c; rfl

theorem decPieces_enc (us : List Piece) (l : List Nat) :
    decPieces us.length (us.flatMap Piece.enc ++ l) = some (us, l) := by
  induction us generalizing l with
  | nil => rfl
  | cons u us ih =>
    simp [decPieces, List.flatMap_cons, decPiece_enc u (us.flatMap Piece.enc ++ l), ih]

theorem decCities_enc (cs : List City) (l : List Nat) :
    decCities cs.length (cs.flatMap City.enc ++ l) = some (cs, l) := by
  induction cs generalizing l with
  | nil => rfl
  | cons c cs ih =>
    simp [decCities, List.flatMap_cons, decCity_enc c (cs.flatMap City.enc ++ l), ih]

theorem decState_enc (st : State) (l : List Nat) : decState (st.enc ++ l) = some (st, l) := by
  obtain ⟨t, a, ps, cs, red, blue⟩ := st
  have h : (State.mk t a ps cs red blue).enc ++ l =
      t :: a :: (red.enc ++ (blue.enc ++ (ps.length ::
        (ps.flatMap Piece.enc ++ (cs.length :: (cs.flatMap City.enc ++ l)))))) := by
    simp [State.enc, List.append_assoc]
  rw [h]
  simp only [decState, decRes_enc, decPieces_enc, decCities_enc, Option.bind_some, Option.map_some]

theorem decMove_enc (mv : Move) (l : List Nat) : decMove (mv.enc ++ l) = some (mv, l) := by
  cases mv with
  | march i d => cases d <;> rfl
  | strike i d => cases d <;> rfl
  | gather i => rfl
  | found i => rfl
  | train c k => cases k <;> rfl
  | endTurn => rfl

/-- Positions encode injectively: the numbers on the page determine the position. -/
theorem State.enc_injective : Function.Injective State.enc := by
  intro a b h
  have ha := decState_enc a []
  have hb := decState_enc b []
  rw [h] at ha
  rw [ha] at hb
  simpa using hb

/-- Moves encode injectively. -/
theorem Move.enc_injective : Function.Injective Move.enc := by
  intro a b h
  have ha := decMove_enc a []
  have hb := decMove_enc b []
  rw [h] at ha
  rw [ha] at hb
  simpa using hb

/-! ## §4  The hash -/

/-- The FNV-1a 64-bit prime. -/
def fnvPrime : Nat := 1099511628211
/-- The FNV-1a 64-bit offset basis. -/
def fnvOffset : Nat := 14695981039346656037
/-- Two to the sixty-fourth. -/
def two64 : Nat := 18446744073709551616

/-- One byte into the FNV-1a state. -/
def hashByte (h b : Nat) : Nat := ((h ^^^ (b % 256)) * fnvPrime) % two64

/-- A number as its eight little-endian bytes. -/
def wordBytes (w : Nat) : List Nat :=
  [w % 256, w / 256 % 256, w / 65536 % 256, w / 16777216 % 256,
   w / 4294967296 % 256, w / 1099511627776 % 256, w / 281474976710656 % 256,
   w / 72057594037927936 % 256]

/-- FNV-1a over a list of numbers. -/
def hashWords (ws : List Nat) : Nat := (ws.flatMap wordBytes).foldl hashByte fnvOffset

/-- The commitment to a position. -/
def hashState (st : State) : Nat := hashWords (1 :: st.enc)

/-- The commitment to the opening position, which is where a chain starts. -/
def genesisHash (st : State) : Nat := hashWords (0 :: st.enc)

/-! ## §5  Blocks and chains -/

/-- One move of the game, as it appears on a page. -/
structure Block where
  /-- position of the move in the game, counting from zero -/
  idx : Nat
  /-- the move itself -/
  mv : Move
  /-- the hash of the previous block, or the genesis hash for the first -/
  prev : Nat
  /-- the hash of the position the move leads to -/
  state : Nat
  deriving DecidableEq, Repr, Inhabited

/-- A block as six numbers. -/
def Block.enc (b : Block) : List Nat := (b.idx :: b.mv.enc) ++ [b.prev, b.state]

/-- The hash of a block: the link the next block points at, and the number a
player commits on chain. -/
def Block.hash (b : Block) : Nat := hashWords (2 :: b.enc)

theorem Block.enc_injective : Function.Injective Block.enc := by
  intro a b h
  obtain ⟨i1, m1, p1, s1⟩ := a
  obtain ⟨i2, m2, p2, s2⟩ := b
  simp only [Block.enc, List.cons_append, List.cons.injEq] at h
  obtain ⟨hi, ht⟩ := h
  have h1 := decMove_enc m1 [p1, s1]
  have h2 := decMove_enc m2 [p2, s2]
  rw [ht, h2] at h1
  simp only [Option.some.injEq, Prod.mk.injEq] at h1
  obtain ⟨hm, hl⟩ := h1
  simp only [List.cons.injEq] at hl
  subst hi
  subst hm
  simp [hl.1, hl.2.1]

/-- Record a run of moves as blocks, stopping at the first illegal move. -/
def recordFrom (st : State) (prev i : Nat) : List Move → List Block
  | [] => []
  | m :: ms =>
    match step st m with
    | none => []
    | some st' =>
      let b : Block := ⟨i, m, prev, hashState st'⟩
      b :: recordFrom st' b.hash (i + 1) ms

/-- The chain of a game played from `st`. -/
def record (st : State) (ms : List Move) : List Block := recordFrom st (genesisHash st) 0 ms

/-- Verify a chain against the rules, block by block. -/
def verifyFrom (st : State) (prev i : Nat) : List Block → Bool
  | [] => true
  | b :: bs =>
    b.idx == i && b.prev == prev &&
      (match step st b.mv with
       | none => false
       | some st' => b.state == hashState st' && verifyFrom st' b.hash (i + 1) bs)

/-- Verify a whole page: the opening position plus its blocks. -/
def verify (st : State) (bs : List Block) : Bool := verifyFrom st (genesisHash st) 0 bs

/-- The number a player commits: the hash of the last block, or the genesis hash
of an unplayed game. -/
def headHash (st : State) (bs : List Block) : Nat :=
  match bs.getLast? with
  | none => genesisHash st
  | some b => b.hash

/-! ## §6  What the chain guarantees -/

theorem verifyFrom_cons (st : State) (prev i : Nat) (b : Block) (bs : List Block) :
    verifyFrom st prev i (b :: bs) =
      (b.idx == i && b.prev == prev &&
        (match step st b.mv with
         | none => false
         | some st' => b.state == hashState st' && verifyFrom st' b.hash (i + 1) bs)) := rfl

theorem verifyFrom_cons_iff {st : State} {prev i : Nat} {b : Block} {bs : List Block} :
    verifyFrom st prev i (b :: bs) = true ↔
      b.idx = i ∧ b.prev = prev ∧ ∃ st', step st b.mv = some st' ∧ b.state = hashState st' ∧
        verifyFrom st' b.hash (i + 1) bs = true := by
  rw [verifyFrom_cons]
  cases hstep : step st b.mv with
  | none => simp
  | some st' => simp [and_assoc]

theorem verifyFrom_recordFrom (st : State) (prev i : Nat) (ms : List Move) :
    verifyFrom st prev i (recordFrom st prev i ms) = true := by
  induction ms generalizing st prev i with
  | nil => rfl
  | cons m ms ih =>
    rw [show recordFrom st prev i (m :: ms) =
        (match step st m with
         | none => []
         | some st' =>
           (⟨i, m, prev, hashState st'⟩ : Block) ::
             recordFrom st' (Block.hash ⟨i, m, prev, hashState st'⟩) (i + 1) ms) from rfl]
    cases hstep : step st m with
    | none => rfl
    | some st' =>
      show verifyFrom st prev i ((⟨i, m, prev, hashState st'⟩ : Block) ::
        recordFrom st' (Block.hash ⟨i, m, prev, hashState st'⟩) (i + 1) ms) = true
      rw [verifyFrom_cons, hstep]
      simp only [beq_self_eq_true, Bool.and_true, Bool.true_and]
      exact ih st' (Block.hash ⟨i, m, prev, hashState st'⟩) (i + 1)

theorem recordFrom_length (st : State) (prev i : Nat) (ms : List Move) (h : (play st ms).isSome) :
    (recordFrom st prev i ms).length = ms.length := by
  induction ms generalizing st prev i with
  | nil => rfl
  | cons m ms ih =>
    rw [show recordFrom st prev i (m :: ms) =
        (match step st m with
         | none => []
         | some st' =>
           (⟨i, m, prev, hashState st'⟩ : Block) ::
             recordFrom st' (Block.hash ⟨i, m, prev, hashState st'⟩) (i + 1) ms) from rfl]
    cases hstep : step st m with
    | none => rw [play, hstep] at h; simp at h
    | some st' =>
      rw [play, hstep] at h
      simp only [Option.bind_some] at h
      simp only [List.length_cons]
      rw [ih st' _ _ h]

theorem verifyFrom_playable {st : State} {prev i : Nat} {bs : List Block}
    (h : verifyFrom st prev i bs = true) : (play st (bs.map Block.mv)).isSome := by
  induction bs generalizing st prev i with
  | nil => simp [play]
  | cons b bs ih =>
    rw [verifyFrom_cons_iff] at h
    obtain ⟨_, _, st', hstep, _, hv⟩ := h
    simp only [List.map_cons, play, hstep, Option.bind_some]
    exact ih hv

theorem verifyFrom_eq_recordFrom {st : State} {prev i : Nat} {bs : List Block}
    (h : verifyFrom st prev i bs = true) : bs = recordFrom st prev i (bs.map Block.mv) := by
  induction bs generalizing st prev i with
  | nil => rfl
  | cons b bs ih =>
    rw [verifyFrom_cons_iff] at h
    obtain ⟨hidx, hprev, st', hstep, hstate, hv⟩ := h
    rw [List.map_cons, show recordFrom st prev i (b.mv :: bs.map Block.mv) =
        (match step st b.mv with
         | none => []
         | some st' =>
           (⟨i, b.mv, prev, hashState st'⟩ : Block) ::
             recordFrom st' (Block.hash ⟨i, b.mv, prev, hashState st'⟩) (i + 1) (bs.map Block.mv))
        from rfl, hstep]
    show b :: bs = (⟨i, b.mv, prev, hashState st'⟩ : Block) ::
      recordFrom st' (Block.hash ⟨i, b.mv, prev, hashState st'⟩) (i + 1) (bs.map Block.mv)
    have hb : (⟨i, b.mv, prev, hashState st'⟩ : Block) = b := by
      obtain ⟨bi, bm, bp, bs'⟩ := b
      simp_all
    rw [hb]
    exact congrArg _ (ih hv)

theorem verifyFrom_prefix {st : State} {prev i : Nat} {bs cs : List Block}
    (h : verifyFrom st prev i (bs ++ cs) = true) : verifyFrom st prev i bs = true := by
  induction bs generalizing st prev i with
  | nil => rfl
  | cons b bs ih =>
    rw [List.cons_append, verifyFrom_cons_iff] at h
    obtain ⟨hidx, hprev, st', hstep, hstate, hv⟩ := h
    rw [verifyFrom_cons_iff]
    exact ⟨hidx, hprev, st', hstep, hstate, ih hv⟩

theorem recordFrom_prefix (st : State) (prev i : Nat) (ms ns : List Move) :
    recordFrom st prev i ms <+: recordFrom st prev i (ms ++ ns) := by
  induction ms generalizing st prev i with
  | nil => exact List.nil_prefix
  | cons m ms ih =>
    rw [List.cons_append]
    rw [show recordFrom st prev i (m :: ms) =
        (match step st m with
         | none => []
         | some st' =>
           (⟨i, m, prev, hashState st'⟩ : Block) ::
             recordFrom st' (Block.hash ⟨i, m, prev, hashState st'⟩) (i + 1) ms) from rfl,
      show recordFrom st prev i (m :: (ms ++ ns)) =
        (match step st m with
         | none => []
         | some st' =>
           (⟨i, m, prev, hashState st'⟩ : Block) ::
             recordFrom st' (Block.hash ⟨i, m, prev, hashState st'⟩) (i + 1) (ms ++ ns)) from rfl]
    cases hstep : step st m with
    | none => exact List.nil_prefix
    | some st' => exact (List.prefix_cons_inj _).mpr (ih _ _ _)

theorem verifyFrom_idx {st : State} {prev i : Nat} {bs : List Block}
    (h : verifyFrom st prev i bs = true) (k : Nat) (hk : k < bs.length) : bs[k].idx = i + k := by
  induction bs generalizing st prev i k with
  | nil => simp at hk
  | cons b bs ih =>
    rw [verifyFrom_cons_iff] at h
    obtain ⟨hidx, hprev, st', hstep, hstate, hv⟩ := h
    cases k with
    | zero => simpa using hidx
    | succ k =>
      have hk' : k < bs.length := by simpa using hk
      simp only [List.getElem_cons_succ]
      rw [ih hv k hk']
      omega

theorem verifyFrom_links {st : State} {prev i : Nat} {bs : List Block}
    (h : verifyFrom st prev i bs = true) (k : Nat) (hk : k < bs.length) :
    bs[k].prev = (match k with
                  | 0 => prev
                  | j + 1 => if hj : j < bs.length then bs[j].hash else 0) := by
  induction bs generalizing st prev i k with
  | nil => simp at hk
  | cons b bs ih =>
    rw [verifyFrom_cons_iff] at h
    obtain ⟨hidx, hprev, st', hstep, hstate, hv⟩ := h
    cases k with
    | zero => simpa using hprev
    | succ k =>
      have hk' : k < bs.length := by simpa using hk
      have := ih hv k hk'
      cases k with
      | zero =>
        simp only [List.getElem_cons_succ, List.getElem_cons_zero]
        simpa using this
      | succ j =>
        have hj : j < bs.length := by omega
        simp only [List.getElem_cons_succ] at this ⊢
        rw [this]
        simp [hj]

theorem verifyFrom_states {st : State} {prev i : Nat} {bs : List Block}
    (h : verifyFrom st prev i bs = true) (k : Nat) (hk : k < bs.length) :
    ∃ s, play st ((bs.map Block.mv).take (k + 1)) = some s ∧ bs[k].state = hashState s := by
  induction bs generalizing st prev i k with
  | nil => simp at hk
  | cons b bs ih =>
    rw [verifyFrom_cons_iff] at h
    obtain ⟨hidx, hprev, st', hstep, hstate, hv⟩ := h
    cases k with
    | zero =>
      refine ⟨st', ?_, by simpa using hstate⟩
      simp [play, hstep]
    | succ k =>
      have hk' : k < bs.length := by simpa using hk
      obtain ⟨s, hs, hst⟩ := ih hv k hk'
      refine ⟨s, ?_, by simpa using hst⟩
      simp only [List.map_cons, List.take_succ_cons, play, hstep, Option.bind_some]
      exact hs

/-- A recorded game always verifies. -/
theorem verify_record (st : State) (ms : List Move) : verify st (record st ms) = true := verifyFrom_recordFrom _ _ _ _

/-- If the moves are all legal, the chain has one block per move. -/
theorem record_length (st : State) (ms : List Move) (h : (play st ms).isSome) :
    (record st ms).length = ms.length := recordFrom_length _ _ _ _ h

/-- A verified chain replays: every move on the page is legal in turn. -/
theorem verify_playable {st : State} {bs : List Block} (h : verify st bs = true) :
    (play st (bs.map Block.mv)).isSome := verifyFrom_playable h

/-- A verified chain is *the* chain of its moves: the hashes on the page are
forced by the moves on the page. -/
theorem verify_eq_record {st : State} {bs : List Block} (h : verify st bs = true) :
    bs = record st (bs.map Block.mv) := verifyFrom_eq_recordFrom h

/-- Any front part of a verified chain verifies on its own: an old page is still
a valid page. -/
theorem verify_prefix {st : State} {bs cs : List Block} (h : verify st (bs ++ cs) = true) :
    verify st bs = true := verifyFrom_prefix h

/-- Playing on extends the chain: the new page contains the old page, block for
block, unchanged. -/
theorem record_prefix (st : State) (ms ns : List Move) :
    record st ms <+: record st (ms ++ ns) := recordFrom_prefix _ _ _ _ _

/-- The blocks of a verified chain are numbered 0, 1, 2, … -/
theorem verify_idx {st : State} {bs : List Block} (h : verify st bs = true)
    (i : Nat) (hi : i < bs.length) : bs[i].idx = i := by
  simpa using verifyFrom_idx h i hi

/-- Each block points at the one before it, and the first at the genesis. -/
theorem verify_links {st : State} {bs : List Block} (h : verify st bs = true)
    (i : Nat) (hi : i < bs.length) :
    bs[i].prev = (match i with
                  | 0 => genesisHash st
                  | j + 1 => if hj : j < bs.length then bs[j].hash else 0) := verifyFrom_links h i hi

/-- Every state hash on the page is the hash of the state that really is reached
by the moves on the page: the page's record of the whole history is truthful. -/
theorem verify_states {st : State} {bs : List Block} (h : verify st bs = true)
    (i : Nat) (hi : i < bs.length) :
    ∃ s, play st ((bs.map Block.mv).take (i + 1)) = some s ∧ bs[i].state = hashState s := verifyFrom_states h i hi

/-! ## §7  Tamper evidence

The one cryptographic assumption of the development, written out: `hashWords` has
no collisions.  Under it the committed number pins down the whole history. -/

/-- Under collision-freedom, the hash of a block determines the block. -/
theorem hash_injective (hinj : Function.Injective hashWords) :
    Function.Injective Block.hash := by
  intro a b h
  unfold Block.hash at h
  have := hinj h
  simp only [List.cons.injEq, true_and] at this
  exact Block.enc_injective this

/-- Under collision-freedom, a block hash is never the genesis hash: the tags keep
the two apart. -/
theorem hash_ne_genesis (hinj : Function.Injective hashWords) (b : Block) (st : State) :
    b.hash ≠ genesisHash st := by
  intro h
  unfold Block.hash genesisHash at h
  have := hinj h
  simp at this

/-- The hash a page commits to, relative to a starting link. -/

def lastHash (prev : Nat) (bs : List Block) : Nat :=
  match bs.getLast? with
  | none => prev
  | some b => b.hash

theorem headHash_eq_lastHash (st : State) (bs : List Block) :
    headHash st bs = lastHash (genesisHash st) bs := rfl

theorem lastHash_concat (prev : Nat) (bs : List Block) (b : Block) :
    lastHash prev (bs ++ [b]) = b.hash := by
  unfold lastHash
  rw [List.getLast?_concat]

theorem lastHash_cons (prev : Nat) (c : Block) (cs : List Block) :
    lastHash prev (c :: cs) = lastHash c.hash cs := by
  cases cs with
  | nil => simp [lastHash]
  | cons d ds =>
    unfold lastHash
    rw [List.getLast?_cons_cons]
    cases hx : (d :: ds).getLast? with
    | none => simp [List.getLast?_eq_none_iff] at hx
    | some x => rfl

theorem verifyFrom_last_prev {st : State} {prev i : Nat} {bs : List Block} {b : Block}
    (h : verifyFrom st prev i (bs ++ [b]) = true) : b.prev = lastHash prev bs := by
  induction bs generalizing st prev i with
  | nil =>
    rw [List.nil_append, verifyFrom_cons_iff] at h
    simpa [lastHash] using h.2.1
  | cons c cs ih =>
    rw [List.cons_append, verifyFrom_cons_iff] at h
    obtain ⟨_, _, st', hstep, _, hv⟩ := h
    rw [lastHash_cons]
    exact ih hv

theorem verifyFrom_head_unique (hinj : Function.Injective hashWords) {st : State} {prev i : Nat}
    (hfresh : ∀ b : Block, i ≤ b.idx → prev ≠ b.hash) {bs cs : List Block}
    (hb : verifyFrom st prev i bs = true) (hc : verifyFrom st prev i cs = true)
    (hh : lastHash prev bs = lastHash prev cs) : bs = cs := by
  induction hn : bs.length using Nat.strong_induction_on generalizing bs cs with
  | _ n ih =>
    subst hn
    rcases List.eq_nil_or_concat bs with rfl | ⟨bs', b, rfl⟩
    · rcases List.eq_nil_or_concat cs with rfl | ⟨cs', c, rfl⟩
      · rfl
      · exfalso
        simp only [List.concat_eq_append] at hc hh
        rw [lastHash_concat] at hh
        have hidx := verifyFrom_idx hc cs'.length (by simp)
        rw [List.getElem_append_right (by omega)] at hidx
        simp only [Nat.sub_self, List.getElem_cons_zero] at hidx
        exact hfresh c (by omega) (by simpa [lastHash] using hh)
    · simp only [List.concat_eq_append] at hb hh ⊢
      rcases List.eq_nil_or_concat cs with rfl | ⟨cs', c, rfl⟩
      · exfalso
        rw [lastHash_concat] at hh
        have hidx := verifyFrom_idx hb bs'.length (by simp)
        rw [List.getElem_append_right (by omega)] at hidx
        simp only [Nat.sub_self, List.getElem_cons_zero] at hidx
        exact hfresh b (by omega) (by simpa [lastHash] using hh.symm)
      · simp only [List.concat_eq_append] at hc hh ⊢
        rw [lastHash_concat, lastHash_concat] at hh
        obtain rfl : b = c := hash_injective hinj hh
        have hb' := verifyFrom_prefix hb
        have hc' := verifyFrom_prefix hc
        have hpb := verifyFrom_last_prev hb
        have hpc := verifyFrom_last_prev hc
        have hbc : bs' = cs' := ih bs'.length (by simp) hb' hc' (by rw [← hpb, ← hpc]) rfl
        rw [hbc]

/-- **Tamper evidence.**  Two verified pages of the same game that commit the same
number are the same page — the same moves, the same states, all the way back. -/
theorem verify_head_unique (hinj : Function.Injective hashWords) {st : State}
    {bs cs : List Block} (hb : verify st bs = true) (hc : verify st cs = true)
    (hh : headHash st bs = headHash st cs) : bs = cs :=
  verifyFrom_head_unique hinj (fun b _ h => hash_ne_genesis hinj b st h.symm) hb hc hh

/-- …and therefore the same final position. -/
theorem verify_head_state (hinj : Function.Injective hashWords) {st : State}
    {bs cs : List Block} (hb : verify st bs = true) (hc : verify st cs = true)
    (hh : headHash st bs = headHash st cs) :
    play st (bs.map Block.mv) = play st (cs.map Block.mv) := by
  rw [verify_head_unique hinj hb hc hh]

end Realm
