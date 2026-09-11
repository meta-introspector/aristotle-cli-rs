import RequestProject.Nix.NixWars.Market

/-!
# The real database behind the trading cabinet

The arcade's third door, the Shard Market, has always been a *toy*: a `Market`
record with credits, shards held and a price on a clock, living nowhere but the
screen of the cabinet.  This file gives it somewhere to live.  A `Db` is the
real book of the world: one `Account` per caller, the shards still on the
market's shelf (`float`), the house's own credits (`house`), the market clock
and an append-only `journal` of every trade ever settled.

The cabinet is then no longer a game *about* trading; it is a **view** of that
book.  `view db o` reads caller `o`'s row out of the database and presents it as
exactly the `Market` record the arcade already draws, and the headline theorem
`play_is_trade` says that pressing BUY at the cabinet and settling the
corresponding transaction against the database are *the same act*: the screen
after the keypress is the view of the book after the trade.  Nothing else could
make the sentence "playing the trading game in the arcade trades in the real
database" precise.

What is proved here:

* **the book balances.**  Credits are only ever moved between a caller and the
  house, and shards only between the shelf and a caller, so
  `applyTx_credits` and `applyTx_shards` say the two totals are the same before
  and after every transaction, and `runTx_credits`, `runTx_shards` say the same
  after a whole session.  Nothing is minted at the cabinet.
* **only your own row moves** (`applyTx_other_account`): trading at the cabinet
  cannot touch another caller's account.
* **a trade the book refuses changes nothing at all** (`applyTx_illegal`), and
  the book refuses only when the shelf is empty, the house is short, the caller
  is unknown, or the caller cannot pay (`legal_iff`).
* **the journal is an audit trail**: it is append-only (`applyTx_journal_prefix`)
  and grows by exactly one entry per settled trade, none per refused one
  (`applyTx_journal_length`).
* **the cabinet is the book** (`play_is_trade`, `session_is_trade`): a keypress
  is a transaction, and a whole session at the cabinet is the sequence of
  transactions it settles, provided the market is deep enough to serve it
  (`Rich`).
* **buying really takes a shard off the shelf** (`buy_moves_a_real_shard`): the
  cabinet's counter is the world's stock.
-/

set_option maxRecDepth 4000

namespace NixWars

namespace Nested

/-! ## The book -/

/-- One caller's row in the book: what they have in credits, and how many
shards they hold. -/
structure Account where
  /-- Which caller this row belongs to. -/
  owner : Nat
  /-- Credits in the caller's account. -/
  credits : Nat
  /-- Shards the caller holds. -/
  held : Nat
  deriving DecidableEq, Repr, Inhabited

/-- One line of the journal: who traded, what they did (`0` buy, `1` sell,
`2` hold), at what price and at what tick of the clock. -/
structure Entry where
  /-- The caller who traded. -/
  owner : Nat
  /-- `0` buy, `1` sell, `2` hold. -/
  kind : Nat
  /-- The price the trade settled at. -/
  price : Nat
  /-- The tick of the market clock the trade settled on. -/
  clock : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The real database: everyone's account, the shards still on the market's
shelf, the house's credits, the market clock and the journal. -/
structure Db where
  /-- One row per caller. -/
  accounts : List Account
  /-- Shards on the market's shelf, not held by anyone. -/
  float : Nat
  /-- The house's credits. -/
  house : Nat
  /-- The market clock, which sets the price. -/
  clock : Nat
  /-- Every trade ever settled, oldest first. -/
  journal : List Entry
  deriving DecidableEq, Repr, Inhabited

/-- The price the book quotes now: the arcade's own clock-driven quote. -/
def Db.price (db : Db) : Nat := shardPrice db.clock

/-- A book is well formed when no caller has two rows. -/
def WF (db : Db) : Prop := (db.accounts.map (·.owner)).Nodup

/-- Caller `o`'s row, if the book has one. -/
def findAcct (db : Db) (o : Nat) : Option Account :=
  db.accounts.find? (fun a => a.owner == o)

/-- Change caller `o`'s row and no other. -/
def onAcct (o : Nat) (f : Account → Account) (l : List Account) : List Account :=
  l.map (fun a => if a.owner = o then f a else a)

/-! ## Sums over the book -/

/-- Every credit in the world: the callers' accounts and the house's own. -/
def totalCredits (db : Db) : Nat := (db.accounts.map (·.credits)).sum + db.house

/-- Every shard in the world: the ones held by callers and the ones still on
the shelf. -/
def totalShards (db : Db) : Nat := (db.accounts.map (·.held)).sum + db.float

/-- Rewriting a row nobody owns rewrites nothing. -/
theorem onAcct_eq_self (o : Nat) (f : Account → Account) (l : List Account)
    (h : ∀ a ∈ l, a.owner ≠ o) : onAcct o f l = l := by
  induction l with
  | nil => rfl
  | cons b t ih =>
      have hb : b.owner ≠ o := h b (by simp)
      have ht : ∀ a ∈ t, a.owner ≠ o := fun a ha => h a (by simp [ha])
      have hrec := ih ht
      simp only [onAcct, List.map_cons, hb, if_false] at *
      rw [hrec]

/-- The book's row for `o` really is a row of the book. -/
theorem findAcct_mem {db : Db} {o : Nat} {a : Account} (h : findAcct db o = some a) :
    a ∈ db.accounts := List.mem_of_find?_eq_some h

/-- The row the book returns for `o` is owned by `o`. -/
theorem findAcct_owner {db : Db} {o : Nat} {a : Account} (h : findAcct db o = some a) :
    a.owner = o := by
  have := List.find?_some h
  simpa using this

/-- **Rewriting one row changes a sum by exactly that row.**  With no caller
holding two rows, any additive quantity `g` summed over the book after
rewriting caller `o`'s row differs from the sum before it by the difference `g`
makes on that one row. -/
theorem sum_onAcct (g : Account → Nat) (o : Nat) (f : Account → Account) :
    ∀ (l : List Account), (l.map (·.owner)).Nodup → ∀ {a : Account},
      l.find? (fun x => x.owner == o) = some a →
      ((onAcct o f l).map g).sum + g a = (l.map g).sum + g (f a) := by
  intro l
  induction l with
  | nil => intro _ a ha; simp at ha
  | cons b t ih =>
      intro hnd a ha
      by_cases hb : b.owner = o
      · have hfind : (b :: t).find? (fun x => x.owner == o) = some b := by
          simp [hb]
        rw [hfind] at ha
        cases ha
        have hnot : ∀ x ∈ t, x.owner ≠ o := by
          intro x hx hxo
          have hmem : x.owner ∈ t.map (·.owner) := List.mem_map_of_mem hx
          simp only [List.map_cons, List.nodup_cons] at hnd
          exact hnd.1 (by rw [hb, ← hxo]; exact hmem)
        have ht : onAcct o f t = t := onAcct_eq_self o f t hnot
        simp only [onAcct, List.map_cons, hb, if_true, List.sum_cons]
        simp only [onAcct] at ht
        rw [ht]
        omega
      · have hfind : (b :: t).find? (fun x => x.owner == o) = t.find? (fun x => x.owner == o) := by
          simp [hb]
        rw [hfind] at ha
        have hnd' : (t.map (·.owner)).Nodup := by
          simp only [List.map_cons, List.nodup_cons] at hnd
          exact hnd.2
        have hrec := ih hnd' ha
        simp only [onAcct, List.map_cons, List.sum_cons, hb, if_false] at *
        omega

/-- Rewriting rows never changes who owns them, so the book stays well
formed. -/
theorem onAcct_owners (o : Nat) (f : Account → Account) (l : List Account)
    (hf : ∀ x : Account, (f x).owner = x.owner) :
    (onAcct o f l).map (·.owner) = l.map (·.owner) := by
  simp only [onAcct, List.map_map]
  refine List.map_congr_left ?_
  intro a _
  by_cases h : a.owner = o <;> simp [Function.comp, h, hf]

/-- Rewriting caller `p`'s row leaves the lookup of any other caller alone. -/
theorem find?_onAcct_ne (o p : Nat) (f : Account → Account) (l : List Account)
    (hf : ∀ x : Account, (f x).owner = x.owner) (hop : o ≠ p) :
    (onAcct p f l).find? (fun x => x.owner == o) = l.find? (fun x => x.owner == o) := by
  induction l with
  | nil => rfl
  | cons b t ih =>
      simp only [onAcct, List.map_cons] at *
      by_cases hb : b.owner = p
      · have hbo : ¬ ((fun x : Account => x.owner == o) b = true) := by
          simp only [beq_iff_eq, hb]
          exact fun hc => hop hc.symm
        have hfo : ¬ ((fun x : Account => x.owner == o) (f b) = true) := by
          simp only [beq_iff_eq, hf]
          simp only [beq_iff_eq] at hbo
          exact hbo
        rw [if_pos hb,
          List.find?_cons_of_neg (p := fun x : Account => x.owner == o) (a := f b) hfo,
          List.find?_cons_of_neg (p := fun x : Account => x.owner == o) (a := b) hbo]
        exact ih
      · rw [if_neg hb]
        by_cases hbo : (fun x : Account => x.owner == o) b = true
        · rw [List.find?_cons_of_pos (p := fun x : Account => x.owner == o) (a := b) hbo,
            List.find?_cons_of_pos (p := fun x : Account => x.owner == o) (a := b) hbo]
        · rw [List.find?_cons_of_neg (p := fun x : Account => x.owner == o) (a := b) hbo,
            List.find?_cons_of_neg (p := fun x : Account => x.owner == o) (a := b) hbo]
          exact ih

/-- Looking up the caller whose row was just rewritten finds the rewritten
row. -/
theorem find?_onAcct_self (o : Nat) (f : Account → Account)
    (hf : ∀ x : Account, (f x).owner = x.owner) :
    ∀ (l : List Account), (l.map (·.owner)).Nodup → ∀ {a : Account},
      l.find? (fun x => x.owner == o) = some a →
      (onAcct o f l).find? (fun x => x.owner == o) = some (f a) := by
  intro l
  induction l with
  | nil => intro _ a ha; simp at ha
  | cons b t ih =>
      intro hnd a ha
      simp only [onAcct, List.map_cons] at *
      by_cases hb : b.owner = o
      · have hpos : (fun x : Account => x.owner == o) b = true := by simp [hb]
        rw [List.find?_cons_of_pos (p := fun x : Account => x.owner == o) (a := b) hpos] at ha
        have hba : b = a := Option.some.inj ha
        subst hba
        have hfpos : (fun x : Account => x.owner == o) (f b) = true := by
          simp only [beq_iff_eq, hf, hb]
        rw [if_pos hb,
          List.find?_cons_of_pos (p := fun x : Account => x.owner == o) (a := f b) hfpos]
      · have hneg : ¬ ((fun x : Account => x.owner == o) b = true) := by simp [hb]
        rw [List.find?_cons_of_neg (p := fun x : Account => x.owner == o) (a := b) hneg] at ha
        have hnd' : (t.map (·.owner)).Nodup := by
          simp only [List.nodup_cons] at hnd
          exact hnd.2
        rw [if_neg hb,
          List.find?_cons_of_neg (p := fun x : Account => x.owner == o) (a := b) hneg]
        exact ih hnd' ha

/-! ## Transactions -/

/-- What a caller can ask the book to do. -/
inductive Tx
  /-- Buy one shard off the shelf. -/
  | buy (owner : Nat)
  /-- Sell one shard back to the shelf. -/
  | sell (owner : Nat)
  /-- Let the clock run. -/
  | hold (owner : Nat)
  deriving DecidableEq, Repr, Inhabited

/-- Who asked. -/
def Tx.owner : Tx → Nat
  | .buy o => o
  | .sell o => o
  | .hold o => o

/-- When the book will settle a transaction: the caller must be known, a buyer
must be able to pay and the shelf must have a shard, a seller must have a shard
and the house must be able to pay for it. -/
def legal (db : Db) : Tx → Bool
  | .buy o =>
      match findAcct db o with
      | some a => decide (db.price ≤ a.credits) && decide (1 ≤ db.float)
      | none => false
  | .sell o =>
      match findAcct db o with
      | some a => decide (1 ≤ a.held) && decide (db.price ≤ db.house)
      | none => false
  | .hold o => (findAcct db o).isSome

/-- A transaction that is not legal is illegal. -/
theorem not_legal {db : Db} {t : Tx} (h : ¬ (legal db t = true)) : legal db t = false := by
  cases hb : legal db t with
  | false => rfl
  | true => exact absurd hb h

/-- Settling a transaction against the book.  A buy moves the price from the
caller to the house and a shard from the shelf to the caller; a sell moves them
back; a hold only turns the clock.  Every settled transaction is journalled, and
a transaction the book will not settle does nothing whatsoever. -/
def applyTx (db : Db) (t : Tx) : Db :=
  if legal db t then
    match t with
    | .buy o =>
        { db with
          accounts := onAcct o
            (fun a => { a with credits := a.credits - db.price, held := a.held + 1 }) db.accounts,
          float := db.float - 1, house := db.house + db.price,
          clock := db.clock + 1, journal := db.journal ++ [⟨o, 0, db.price, db.clock⟩] }
    | .sell o =>
        { db with
          accounts := onAcct o
            (fun a => { a with credits := a.credits + db.price, held := a.held - 1 }) db.accounts,
          float := db.float + 1, house := db.house - db.price,
          clock := db.clock + 1, journal := db.journal ++ [⟨o, 1, db.price, db.clock⟩] }
    | .hold o =>
        { db with clock := db.clock + 1, journal := db.journal ++ [⟨o, 2, db.price, db.clock⟩] }
  else db

/-- A whole session settled against the book, in order. -/
def runTx (db : Db) (ts : List Tx) : Db := ts.foldl applyTx db

@[simp] theorem runTx_nil (db : Db) : runTx db [] = db := rfl

@[simp] theorem runTx_cons (db : Db) (t : Tx) (ts : List Tx) :
    runTx db (t :: ts) = runTx (applyTx db t) ts := rfl

/-- **A transaction the book refuses changes nothing at all.** -/
theorem applyTx_illegal (db : Db) (t : Tx) (h : legal db t = false) : applyTx db t = db := by
  simp [applyTx, h]

/-- Every settled transaction turns the market clock once. -/
theorem clock_applyTx {db : Db} {t : Tx} (hl : legal db t = true) :
    (applyTx db t).clock = db.clock + 1 := by
  cases t <;> simp [applyTx, hl]

/-- The book refuses exactly when the caller is unknown, the buyer cannot pay,
the shelf is empty, the seller has nothing or the house cannot pay. -/
theorem legal_iff (db : Db) (t : Tx) :
    legal db t = true ↔
      (match t with
       | .buy o => ∃ a, findAcct db o = some a ∧ db.price ≤ a.credits ∧ 1 ≤ db.float
       | .sell o => ∃ a, findAcct db o = some a ∧ 1 ≤ a.held ∧ db.price ≤ db.house
       | .hold o => ∃ a, findAcct db o = some a) := by
  cases t with
  | buy o =>
      cases h : findAcct db o with
      | none => simp [legal, h]
      | some a => simp [legal, h]
  | sell o =>
      cases h : findAcct db o with
      | none => simp [legal, h]
      | some a => simp [legal, h]
  | hold o =>
      cases h : findAcct db o with
      | none => simp [legal, h]
      | some a => simp [legal, h]

/-! ## The book balances -/

/-- **No credit is created or destroyed at the cabinet.** -/
theorem applyTx_credits (db : Db) (hwf : WF db) (t : Tx) :
    totalCredits (applyTx db t) = totalCredits db := by
  cases t with
  | hold o => by_cases h : legal db (.hold o) <;> simp [applyTx, h, totalCredits]
  | buy o =>
      by_cases h : legal db (.buy o) = true
      · obtain ⟨a, ha, hpay, _⟩ := (legal_iff db (.buy o)).1 h
        have hs := sum_onAcct (·.credits) o
          (fun x => { x with credits := x.credits - db.price, held := x.held + 1 })
          db.accounts hwf ha
        simp only [applyTx, h, if_true, totalCredits] at *
        omega
      · rw [applyTx_illegal db _ (not_legal h)]
  | sell o =>
      by_cases h : legal db (.sell o) = true
      · obtain ⟨a, ha, _, hpay⟩ := (legal_iff db (.sell o)).1 h
        have hs := sum_onAcct (·.credits) o
          (fun x => { x with credits := x.credits + db.price, held := x.held - 1 })
          db.accounts hwf ha
        simp only [applyTx, h, if_true, totalCredits] at *
        omega
      · rw [applyTx_illegal db _ (not_legal h)]

/-- **No shard is created or destroyed at the cabinet.** -/
theorem applyTx_shards (db : Db) (hwf : WF db) (t : Tx) :
    totalShards (applyTx db t) = totalShards db := by
  cases t with
  | hold o => by_cases h : legal db (.hold o) <;> simp [applyTx, h, totalShards]
  | buy o =>
      by_cases h : legal db (.buy o) = true
      · obtain ⟨a, ha, _, hfloat⟩ := (legal_iff db (.buy o)).1 h
        have hs := sum_onAcct (·.held) o
          (fun x => { x with credits := x.credits - db.price, held := x.held + 1 })
          db.accounts hwf ha
        simp only [applyTx, h, if_true, totalShards] at *
        omega
      · rw [applyTx_illegal db _ (not_legal h)]
  | sell o =>
      by_cases h : legal db (.sell o) = true
      · obtain ⟨a, ha, hheld, _⟩ := (legal_iff db (.sell o)).1 h
        have hs := sum_onAcct (·.held) o
          (fun x => { x with credits := x.credits + db.price, held := x.held - 1 })
          db.accounts hwf ha
        simp only [applyTx, h, if_true, totalShards] at *
        omega
      · rw [applyTx_illegal db _ (not_legal h)]

/-- Settling a transaction keeps the book well formed: the rows, and their
owners, are exactly the ones that were there before. -/
theorem applyTx_owners (db : Db) (t : Tx) :
    (applyTx db t).accounts.map (·.owner) = db.accounts.map (·.owner) := by
  cases t with
  | buy o =>
      by_cases h : legal db (.buy o) = true
      · simp only [applyTx, h, if_true]
        exact onAcct_owners o
          (fun a => { a with credits := a.credits - db.price, held := a.held + 1 })
          db.accounts (fun _ => rfl)
      · rw [applyTx_illegal db _ (not_legal h)]
  | sell o =>
      by_cases h : legal db (.sell o) = true
      · simp only [applyTx, h, if_true]
        exact onAcct_owners o
          (fun a => { a with credits := a.credits + db.price, held := a.held - 1 })
          db.accounts (fun _ => rfl)
      · rw [applyTx_illegal db _ (not_legal h)]
  | hold o => by_cases h : legal db (.hold o) <;> simp [applyTx, h]

theorem applyTx_wf (db : Db) (hwf : WF db) (t : Tx) : WF (applyTx db t) := by
  unfold WF at *
  rw [applyTx_owners]
  exact hwf

theorem runTx_wf (db : Db) (hwf : WF db) (ts : List Tx) : WF (runTx db ts) := by
  induction ts generalizing db with
  | nil => exact hwf
  | cons t ts ih => exact ih _ (applyTx_wf db hwf t)

/-- **A whole session leaves every credit accounted for.** -/
theorem runTx_credits (db : Db) (hwf : WF db) (ts : List Tx) :
    totalCredits (runTx db ts) = totalCredits db := by
  induction ts generalizing db with
  | nil => rfl
  | cons t ts ih =>
      rw [runTx_cons, ih _ (applyTx_wf db hwf t), applyTx_credits db hwf t]

/-- **A whole session leaves every shard accounted for.** -/
theorem runTx_shards (db : Db) (hwf : WF db) (ts : List Tx) :
    totalShards (runTx db ts) = totalShards db := by
  induction ts generalizing db with
  | nil => rfl
  | cons t ts ih =>
      rw [runTx_cons, ih _ (applyTx_wf db hwf t), applyTx_shards db hwf t]

/-! ## Only your own row moves -/

/-- **Trading at the cabinet cannot touch another caller's account.** -/
theorem applyTx_other_account (db : Db) (t : Tx) (o : Nat) (h : o ≠ t.owner) :
    findAcct (applyTx db t) o = findAcct db o := by
  cases t with
  | buy p =>
      by_cases hl : legal db (.buy p) = true
      · simp only [applyTx, hl, if_true, findAcct]
        exact find?_onAcct_ne o p _ db.accounts (fun _ => rfl) (by simpa [Tx.owner] using h)
      · rw [applyTx_illegal db _ (not_legal hl)]
  | sell p =>
      by_cases hl : legal db (.sell p) = true
      · simp only [applyTx, hl, if_true, findAcct]
        exact find?_onAcct_ne o p _ db.accounts (fun _ => rfl) (by simpa [Tx.owner] using h)
      · rw [applyTx_illegal db _ (not_legal hl)]
  | hold p => by_cases hl : legal db (.hold p) <;> simp [applyTx, hl, findAcct]

/-! ## The journal is an audit trail -/

/-- Nothing already journalled is ever rewritten. -/
theorem applyTx_journal_prefix (db : Db) (t : Tx) : db.journal <+: (applyTx db t).journal := by
  cases t with
  | buy o => by_cases h : legal db (.buy o) <;> simp [applyTx, h]
  | sell o => by_cases h : legal db (.sell o) <;> simp [applyTx, h]
  | hold o => by_cases h : legal db (.hold o) <;> simp [applyTx, h]

/-- A settled transaction is exactly one journal line; a refused one is none. -/
theorem applyTx_journal_length (db : Db) (t : Tx) :
    (applyTx db t).journal.length =
      db.journal.length + (if legal db t then 1 else 0) := by
  cases t with
  | buy o => by_cases h : legal db (.buy o) <;> simp [applyTx, h]
  | sell o => by_cases h : legal db (.sell o) <;> simp [applyTx, h]
  | hold o => by_cases h : legal db (.hold o) <;> simp [applyTx, h]

/-! ## The cabinet is a view of the book -/

/-- Caller `o`'s screen at the trading cabinet: their own credits and shards,
the price the book quotes and the tick of the world's clock.  This is exactly
the `Market` record the arcade already draws. -/
def view (db : Db) (o : Nat) : Market :=
  match findAcct db o with
  | some a => { credits := a.credits, held := a.held, price := shardPrice db.clock,
                turn := db.clock }
  | none => { credits := 0, held := 0, price := shardPrice db.clock, turn := db.clock }

/-- What a caller with a row sees. -/
theorem view_of {db : Db} {o : Nat} {a : Account} (h : findAcct db o = some a) :
    view db o =
      { credits := a.credits, held := a.held, price := shardPrice db.clock, turn := db.clock } := by
  simp only [view, h]

/-- The keypress at the cabinet, as a transaction against the book. -/
def txOf (o : Nat) : MarketCmd → Tx
  | .buy => .buy o
  | .sell => .sell o
  | .hold => .hold o

@[simp] theorem txOf_owner (o : Nat) (c : MarketCmd) : (txOf o c).owner = o := by
  cases c <;> rfl

/-- The cabinet's screen is always on the market clock. -/
theorem view_onClock (db : Db) (o : Nat) : OnClock (view db o) := by
  simp only [view, OnClock]
  cases findAcct db o <;> rfl

/-- The trader's row after a settled buy. -/
theorem findAcct_buy {db : Db} (hwf : WF db) {o : Nat} {a : Account}
    (ha : findAcct db o = some a) (hl : legal db (.buy o) = true) :
    findAcct (applyTx db (.buy o)) o =
      some { a with credits := a.credits - db.price, held := a.held + 1 } := by
  have hfind := find?_onAcct_self o
    (fun x => { x with credits := x.credits - db.price, held := x.held + 1 })
    (fun _ => rfl) db.accounts hwf ha
  simp only [applyTx, hl, if_true, findAcct]
  exact hfind

/-- The trader's row after a settled sell. -/
theorem findAcct_sell {db : Db} (hwf : WF db) {o : Nat} {a : Account}
    (ha : findAcct db o = some a) (hl : legal db (.sell o) = true) :
    findAcct (applyTx db (.sell o)) o =
      some { a with credits := a.credits + db.price, held := a.held - 1 } := by
  have hfind := find?_onAcct_self o
    (fun x => { x with credits := x.credits + db.price, held := x.held - 1 })
    (fun _ => rfl) db.accounts hwf ha
  simp only [applyTx, hl, if_true, findAcct]
  exact hfind

/-- A hold moves no row at all. -/
theorem findAcct_hold {db : Db} {o p : Nat} (hl : legal db (.hold p) = true) :
    findAcct (applyTx db (.hold p)) o = findAcct db o := by
  simp only [applyTx, hl, if_true, findAcct]

/-- **Playing the trading game in the arcade is trading in the real database.**
A caller with a row in the book sees exactly the `Market` record the arcade
draws; pressing a key at the cabinet settles the corresponding transaction; and
the screen after the keypress is the view of the book after the trade.  The two
hypotheses are the market being able to serve the trade at all: a shard on the
shelf to sell to the caller, and enough in the house to buy one back. -/
theorem play_is_trade (db : Db) (hwf : WF db) (o : Nat) (a : Account)
    (ha : findAcct db o = some a) (hfloat : 1 ≤ db.float)
    (hhouse : shardPrice db.clock ≤ db.house) (c : MarketCmd) :
    view (applyTx db (txOf o c)) o = marketStep (view db o) c := by
  have hprice : db.price = shardPrice db.clock := rfl
  cases c with
  | buy =>
      by_cases hpay : shardPrice db.clock ≤ a.credits
      · have hl : legal db (.buy o) = true := by simp [legal, ha, hprice, hpay, hfloat]
        rw [show txOf o .buy = Tx.buy o from rfl, view_of (findAcct_buy hwf ha hl),
          clock_applyTx hl, view_of ha]
        simp only [marketStep]
        rw [if_pos hpay]
        simp [hprice, nextPrice_shardPrice]
      · have hl : legal db (.buy o) = false := by simp [legal, ha, hprice, hpay]
        rw [show txOf o .buy = Tx.buy o from rfl, applyTx_illegal db _ hl, view_of ha]
        simp only [marketStep]
        rw [if_neg hpay]
  | sell =>
      by_cases hheld : 1 ≤ a.held
      · have hl : legal db (.sell o) = true := by simp [legal, ha, hprice, hheld, hhouse]
        rw [show txOf o .sell = Tx.sell o from rfl, view_of (findAcct_sell hwf ha hl),
          clock_applyTx hl, view_of ha]
        simp only [marketStep]
        rw [if_pos hheld]
        simp [hprice, nextPrice_shardPrice]
      · have hl : legal db (.sell o) = false := by simp [legal, ha, hprice, hheld]
        rw [show txOf o .sell = Tx.sell o from rfl, applyTx_illegal db _ hl, view_of ha]
        simp only [marketStep]
        rw [if_neg hheld]
  | hold =>
      have hl : legal db (.hold o) = true := by simp [legal, ha]
      rw [show txOf o .hold = Tx.hold o from rfl,
        view_of (by rw [findAcct_hold hl]; exact ha : findAcct (applyTx db (.hold o)) o = some a),
        clock_applyTx hl, view_of ha]
      simp [marketStep, nextPrice_shardPrice]

/-- **Buying really takes a shard off the world's shelf.** -/
theorem buy_moves_a_real_shard (db : Db) (hwf : WF db) (o : Nat) (a : Account)
    (ha : findAcct db o = some a) (hl : legal db (.buy o) = true) :
    (applyTx db (.buy o)).float + 1 = db.float ∧
      findAcct (applyTx db (.buy o)) o =
        some { a with credits := a.credits - db.price, held := a.held + 1 } := by
  obtain ⟨a', ha', _, hfloat⟩ := (legal_iff db (.buy o)).1 hl
  refine ⟨?_, findAcct_buy hwf ha hl⟩
  simp only [applyTx, hl, if_true]
  omega

/-! ## A whole session at the cabinet -/

/-- The market is *deep enough for `n` more trades*: `n` shards on the shelf and
enough in the house to buy `n` back at the highest price on the board. -/
def Rich (db : Db) (n : Nat) : Prop := n ≤ db.float ∧ 71 * n ≤ db.house

/-- Depth is spent at most one trade at a time. -/
theorem Rich_applyTx (db : Db) (n : Nat) (h : Rich db (n + 1)) (t : Tx) :
    Rich (applyTx db t) n := by
  obtain ⟨hf, hh⟩ := h
  have hp : db.price ≤ 71 := shardPrice_le _
  have hmul : 71 * (n + 1) = 71 * n + 71 := by ring
  by_cases hl : legal db t = true
  · cases t with
    | buy o => refine ⟨?_, ?_⟩ <;> simp only [applyTx, hl, if_true] <;> omega
    | sell o => refine ⟨?_, ?_⟩ <;> simp only [applyTx, hl, if_true] <;> omega
    | hold o => refine ⟨?_, ?_⟩ <;> simp only [applyTx, hl, if_true] <;> omega
  · rw [applyTx_illegal db _ (not_legal hl)]
    exact ⟨by omega, by omega⟩

/-- A caller with a row keeps it however the book is traded against. -/
theorem findAcct_applyTx_isSome (db : Db) (hwf : WF db) (o : Nat) (t : Tx)
    (h : (findAcct db o).isSome) : (findAcct (applyTx db t) o).isSome := by
  by_cases hl : legal db t = true
  · obtain ⟨a, ha⟩ := Option.isSome_iff_exists.1 h
    cases t with
    | buy p =>
        by_cases hop : o = p
        · subst hop; rw [findAcct_buy hwf ha hl]; rfl
        · rw [applyTx_other_account db (.buy p) o (by simpa [Tx.owner] using hop)]; exact h
    | sell p =>
        by_cases hop : o = p
        · subst hop; rw [findAcct_sell hwf ha hl]; rfl
        · rw [applyTx_other_account db (.sell p) o (by simpa [Tx.owner] using hop)]; exact h
    | hold p => rw [findAcct_hold hl]; exact h
  · rw [applyTx_illegal db _ (not_legal hl)]; exact h

/-- **A whole session at the cabinet is the sequence of trades it settles.**
As long as the market stays deep enough to serve the session — which `Rich`
guarantees for its whole length — running the commands through the arcade's own
`Market` step function and settling them one by one against the real database
give the same screen at the end. -/
theorem session_is_trade (db : Db) (hwf : WF db) (o : Nat) (cs : List MarketCmd)
    (hrich : Rich db cs.length) (ha : (findAcct db o).isSome) :
    view (runTx db (cs.map (txOf o))) o = shardMarket.run (view db o) cs := by
  induction cs generalizing db with
  | nil => rfl
  | cons c cs ih =>
      obtain ⟨a, hacc⟩ := Option.isSome_iff_exists.1 ha
      have hlen : (c :: cs).length = cs.length + 1 := rfl
      have hrich' : Rich db (cs.length + 1) := by rwa [hlen] at hrich
      have hfloat : 1 ≤ db.float := by have := hrich'.1; omega
      have hhouse : shardPrice db.clock ≤ db.house := by
        have h2 := hrich'.2
        have h71 : 71 ≤ db.house := by omega
        exact le_trans (shardPrice_le _) h71
      have hstep := play_is_trade db hwf o a hacc hfloat hhouse c
      have hrun : shardMarket.run (view db o) (c :: cs)
          = shardMarket.run (marketStep (view db o) c) cs := rfl
      rw [List.map_cons, runTx_cons, hrun, ← hstep]
      exact ih (applyTx db (txOf o c)) (applyTx_wf db hwf _)
        (Rich_applyTx db cs.length hrich' _)
        (findAcct_applyTx_isSome db hwf o _ ha)

end Nested

end NixWars
