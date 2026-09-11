import RequestProject.Gvcs.Realm.Stake

/-!
# What goes on the chain

A page is hosted; a *digest* is published.  The ledger of a game is the list of
digests it has published: after each move, the mover posts the digest of the
game so far — one word, whatever the length of the game — and that is the whole
of its on-chain footprint.  Everything else (the board, the history, the checks)
is in the page the player hosts.

The ledger is defined against any digest function, because two are wanted:

* `ledger` — the real one, the 64-bit FNV-1a chain the pages compute;
* `idealLedger` — the same thing with an idealized digest that cannot collide,
  which is what makes `ledgerWith_binds` a statement about something that
  exists rather than an empty implication.

What is proved:

* `ledgerWith_concat` — **posting is append-only**: a move adds one entry and
  touches nothing already posted, so a chain that only accepts appends is a
  faithful record of the game.
* `ledgerWith_take` — the ledger of an earlier page is exactly the ledger now,
  cut short: what was posted then is still posted, and still says the same.
* `ledger_concat_step` — each posting is the previous posting with one move
  folded in, so a chain can check a new entry against the last one without
  replaying anything.
* `ledgerWith_binds` — if the digest does not collide, the ledger determines the
  game; `idealLedger_binds` is that conclusion, unconditionally, for the
  idealized digest.
-/

namespace LifeTrac
namespace Realm

/-- The digests a game posts under a digest function `dg`: after move `i`, the
digest of the first `i + 1` moves. -/
def ledgerWith (dg : List Move → Nat) (ms : List Move) : List Nat :=
  (List.range ms.length).map (fun i => dg (ms.take (i + 1)))

/-- What a game posts on a chain: after each move, the digest of the game so
far. -/
def ledger (ms : List Move) : List Nat := ledgerWith chainDigest ms

@[simp] theorem ledgerWith_nil (dg : List Move → Nat) : ledgerWith dg [] = [] := rfl

@[simp] theorem ledgerWith_length (dg : List Move → Nat) (ms : List Move) :
    (ledgerWith dg ms).length = ms.length := by simp [ledgerWith]

/-- **Posting is append-only.**  A move adds one digest to the ledger and
changes nothing that was posted before it. -/
theorem ledgerWith_concat (dg : List Move → Nat) (ms : List Move) (m : Move) :
    ledgerWith dg (ms ++ [m]) = ledgerWith dg ms ++ [dg (ms ++ [m])] := by
  unfold ledgerWith
  simp only [List.length_append, List.length_cons, List.length_nil,
    List.range_succ, List.map_append, List.map_cons, List.map_nil]
  congr 1
  · refine List.map_congr_left ?_
    intro i hi
    have hlt : i < ms.length := List.mem_range.mp hi
    congr 1
    exact List.take_append_of_le_length (by omega)
  · congr 2
    exact List.take_of_length_le (by simp)

/-- The ledger of an earlier page is the ledger now, cut short. -/
theorem ledgerWith_take (dg : List Move → Nat) (ms : List Move) (k : Nat) :
    ledgerWith dg (ms.take k) = (ledgerWith dg ms).take k := by
  unfold ledgerWith
  rw [List.length_take, ← List.map_take, List.take_range]
  refine List.map_congr_left ?_
  intro i hi
  have hlt : i < min k ms.length := List.mem_range.mp hi
  congr 1
  rw [List.take_take]
  congr 1
  omega

/-- The newest entry is the digest of the whole game so far: the number a stake
is settled against. -/
theorem ledgerWith_last (dg : List Move → Nat) (ms : List Move) (m : Move) :
    (ledgerWith dg (ms ++ [m])).getLast? = some (dg (ms ++ [m])) := by
  rw [ledgerWith_concat]; simp

/-- **The ledger determines the game**, when the digest does. -/
theorem ledgerWith_binds {dg : List Move → Nat} (hinj : Function.Injective dg)
    {ms ms' : List Move} (h : ledgerWith dg ms = ledgerWith dg ms') : ms = ms' := by
  have hlen : ms.length = ms'.length := by simpa using congrArg List.length h
  by_cases hnil : ms = []
  · subst hnil
    have hz : ms'.length = 0 := by simpa using hlen.symm
    rw [List.eq_nil_of_length_eq_zero hz]
  · have hnil' : ms' ≠ [] := by
      intro hz
      rw [hz] at hlen
      exact hnil (List.eq_nil_of_length_eq_zero (by simpa using hlen))
    obtain ⟨bs, b, hbs⟩ : ∃ bs b, ms = bs ++ [b] :=
      ⟨ms.dropLast, ms.getLast hnil, (List.dropLast_append_getLast hnil).symm⟩
    obtain ⟨cs, c, hcs⟩ : ∃ cs c, ms' = cs ++ [c] :=
      ⟨ms'.dropLast, ms'.getLast hnil', (List.dropLast_append_getLast hnil').symm⟩
    have hlast : (ledgerWith dg ms).getLast? = (ledgerWith dg ms').getLast? := by rw [h]
    rw [hbs, hcs, ledgerWith_last, ledgerWith_last] at hlast
    simp only [Option.some.injEq] at hlast
    rw [hbs, hcs]
    exact hinj hlast

/-! ## The real ledger -/

theorem ledger_concat (ms : List Move) (m : Move) :
    ledger (ms ++ [m]) = ledger ms ++ [chainDigest (ms ++ [m])] :=
  ledgerWith_concat _ _ _

theorem ledger_take (ms : List Move) (k : Nat) : ledger (ms.take k) = (ledger ms).take k :=
  ledgerWith_take _ _ _

/-- Each entry extends the last one by exactly the move that was made, so a
chain can check a posting against its predecessor without replaying the game. -/
theorem ledger_concat_step (ms : List Move) (m : Move) :
    ledger (ms ++ [m]) = ledger ms ++ [mix (chainDigest ms) m.code] := by
  rw [ledger_concat, chainDigest_concat]

/-! ## The idealized ledger -/

/-- An idealized digest of a game: the chained Cantor pairing of the full move
codes.  Unlike a 64-bit digest it is as wide as it needs to be, and so it really
cannot collide. -/
def idealGameDigest (ms : List Move) : Nat := idealDigest (ms.map Move.fullCode)

theorem idealGameDigest_inj : Function.Injective idealGameDigest := by
  intro a b h
  have h1 : a.map Move.fullCode = b.map Move.fullCode := idealDigest_inj h
  exact List.map_injective_iff.mpr Move.fullCode_inj h1

/-- The ledger a game would post if the digest were perfect. -/
def idealLedger (ms : List Move) : List Nat := ledgerWith idealGameDigest ms

/-- **Under a digest that cannot collide, the postings determine the game.**
This is `ledgerWith_binds` with its hypothesis discharged, and it is what a
64-bit ledger is an approximation of. -/
theorem idealLedger_binds {ms ms' : List Move} (h : idealLedger ms = idealLedger ms') :
    ms = ms' := ledgerWith_binds idealGameDigest_inj h

end Realm
end LifeTrac
