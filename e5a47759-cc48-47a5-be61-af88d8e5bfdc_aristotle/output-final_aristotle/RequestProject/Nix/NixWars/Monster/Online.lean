import RequestProject.Nix.NixWars.Monster.Flight
import RequestProject.Nix.Foundry.Fleet

/-!
# The online screen

A board is not a board without a `WHO'S ONLINE` screen.  The eight agents of
the foundry (`Foundry/Fleet.lean`) are the eight nodes of this one: each is
logged in on its own node, flying its own ship through the voxel world of
`Flight.lean`, and the screen lists them with the cell each is in.

A node's ship rides the 71-shard ring — the one-dimensional world, which is the
coarsest axis of every finer one — starting from the agent's own shard and
moving one cell per tick.  Because the agents sit on distinct shards, the nodes
are proved never to collide: at every tick, at every level of resolution from
the ring to the fifteen-dimensional world, no two nodes are in the same cell
(`nodes_never_collide`).  That is what makes the screen worth showing: the list
of occupied cells is always a list of eight distinct cells.
-/

namespace NixWars

namespace Monster

/-! ## The nodes -/

/-- A node of the board: an agent, logged in. -/
structure Node where
  /-- Node number, as the BBS counts them. -/
  num : Nat
  /-- The agent's handle. -/
  handle : String
  /-- Its amateur-radio callsign. -/
  callsign : String
  /-- What it does. -/
  role : String
  /-- The shard it logged in from, which is where its ship starts. -/
  shard : Nat
  deriving DecidableEq, Repr, Inhabited

/-- **Who is online**: the fleet, one node each, numbered from one. -/
def onlineNodes : List Node :=
  (List.range Foundry.fleet.length).map (fun i =>
    let a : Foundry.Agent := Foundry.fleet.getD i default
    { num := i + 1, handle := a.handle, callsign := a.callsign, role := a.role,
      shard := a.shard })

theorem onlineNodes_length : onlineNodes.length = 8 := by decide

/-- The screen lists the fleet, in order. -/
theorem onlineNodes_handles :
    onlineNodes.map Node.handle = Foundry.fleet.map Foundry.Agent.handle := by decide

/-- Every node is logged in from a real shard of the ring. -/
theorem onlineNodes_shard_lt : ∀ n ∈ onlineNodes, n.shard < 71 := by decide

/-- No two nodes logged in from the same shard. -/
theorem onlineNodes_shards_distinct :
    ∀ m ∈ onlineNodes, ∀ n ∈ onlineNodes, m ≠ n → m.shard ≠ n.shard := by decide

/-- Node numbers run 1 … 8. -/
theorem onlineNodes_numbers : onlineNodes.map Node.num = [1, 2, 3, 4, 5, 6, 7, 8] := by decide

/-! ## Where each node is -/

/-- A node's address at tick `t` in the level-`d` world: one cell per tick along
the 71-shard ring, from the agent's own shard. -/
def nodePos (d t : Nat) (n : Node) : List Nat :=
  (List.replicate d 0).set 0 ((n.shard + t) % 71)

/-- A node's ship at tick `t`. -/
def nodeShip (d t : Nat) (n : Node) : Ship :=
  { dim := d, pos := nodePos d t n, ax := 0, fwd := true, speed := 1,
    fuel := shipTank, docked := false, turn := t }

/-- The cell a node is in. -/
def nodeIndex (d t : Nat) (n : Node) : Nat := encode (level d) (nodePos d t n)

theorem nodePos_length (d t : Nat) (n : Node) : (nodePos d t n).length = d := by
  simp [nodePos]

theorem axis_zero_eq {d : Nat} (h1 : 1 ≤ d) : (level d).getD 0 1 = 71 := by
  have : (level d).getD 0 1 = axisLen d 0 := rfl
  rw [this, axisLen_eq h1]
  decide

theorem nodePos_valid {d : Nat} (hd : d ≤ 15) (t : Nat) (n : Node) :
    Valid (level d) (nodePos d t n) := by
  rcases Nat.eq_zero_or_pos d with rfl | h1
  · have hp : nodePos 0 t n = [] := by simp [nodePos]
    have hl : level 0 = [] := by decide
    rw [hp, hl]
    exact List.Forall₂.nil
  · refine valid_set (valid_replicate_zero hd) 0 _ ?_
    rw [axis_zero_eq h1]
    exact Nat.mod_lt _ (by norm_num)

/-- Every node's ship is a legal ship of the world. -/
theorem nodeShip_ok {d : Nat} (hd : d ≤ 15) (t : Nat) (n : Node) : Ok (nodeShip d t n) where
  dim_le := hd
  len := nodePos_length d t n
  valid := nodePos_valid hd t n
  ax_ok := Or.inr rfl
  speed_le := by simp [nodeShip, maxThrottle, frontierMaxSpeed]

/-- On the ring itself the node's cell is its shard, advanced by the tick. -/
theorem nodeIndex_one (t : Nat) (n : Node) : nodeIndex 1 t n = (n.shard + t) % 71 := by
  simp [nodeIndex, nodePos, level, worldAxes_eq, encode]

/-! ## The nodes never collide -/

theorem ring_add_inj {a b t : Nat} (ha : a < 71) (hb : b < 71)
    (h : (a + t) % 71 = (b + t) % 71) : a = b := by
  have hm : a % 71 = b % 71 := Nat.ModEq.add_right_cancel' t h
  rwa [Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt hb] at hm

/-- **The board never puts two callers in one cell.**  At every tick, at every
level of resolution, two different nodes are in two different cells of the
world. -/
theorem nodes_never_collide {d t : Nat} (h1 : 1 ≤ d) (hd : d ≤ 15) {m n : Node}
    (hm : m ∈ onlineNodes) (hn : n ∈ onlineNodes) (hmn : m ≠ n) :
    nodeIndex d t m ≠ nodeIndex d t n := by
  intro heq
  have hpos : nodePos d t m = nodePos d t n := by
    have hm' := decode_encode (nodePos_valid hd t m)
    have hn' := decode_encode (nodePos_valid hd t n)
    rw [← hm', ← hn']
    unfold nodeIndex at heq
    rw [heq]
  have hhead : (m.shard + t) % 71 = (n.shard + t) % 71 := by
    obtain ⟨e, rfl⟩ : ∃ e, d = e + 1 := ⟨d - 1, by omega⟩
    simpa [nodePos, List.replicate_succ] using congrArg (fun l => l.getD 0 0) hpos
  exact onlineNodes_shards_distinct m hm n hn hmn
    (ring_add_inj (onlineNodes_shard_lt m hm) (onlineNodes_shard_lt n hn) hhead)

/-- So the screen always shows eight distinct cells. -/
theorem online_cells_nodup {d t : Nat} (h1 : 1 ≤ d) (hd : d ≤ 15) :
    (onlineNodes.map (nodeIndex d t)).Nodup := by
  refine List.Nodup.map_on ?_ (by decide)
  intro m hm n hn heq
  by_contra hne
  exact nodes_never_collide h1 hd hm hn hne heq

end Monster

end NixWars
