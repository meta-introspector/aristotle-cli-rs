import RequestProject.Relay.Cargo

/-!
# The bootstrap: a program that carries the thing that built it

The relay's programs carry their own source; `RequestProject.Relay.Cargo` lets
them carry something *else* as well.  This file is about the case where that
something else is *the builder itself* — and about what "self-hosting" means
once the cargo has stopped being an inert passenger.

A **builder** is a function from a payload to a program text: it is what the
harness does when it lays a payload out in one stage's notation and wraps it in
that stage's code.  Every stage of a relay is a builder in this sense
(`StageSpec.builder`), and `R.prog i` is exactly stage `i`'s builder applied to
the relay's payload (`builder_digits`).

The point of the file is that a builder need not be given from outside: it can
be *read out of a program's own text* (`recover`), because the payload a program
carries contains the blocks of every stage, and the blocks of a stage are all
there is to its builder.  Putting the two together:

* `rebuild j t` — recover stage `j`'s builder from the text `t` and apply it to
  `t`'s own payload;
* `rebuild_eq_host` — that is precisely what running a program does; the
  bootstrap view and the interpreter view of the relay agree, for *any* text,
  well formed or not;
* `bootstrap_fixed_point` — the builder recovered from a program's payload,
  applied to that payload, returns the same program.  This is the fixed-point
  property a self-hosting artefact has;
* `boot_cycle` — a bootstrap *sequence*: each builder recovered from the
  previous artefact, `R.size` of them, returns to the program it started from;
* `loaded_self_hosting` — for a relay loaded with cargo, both halves at once:
  the cargo (in practice: the sources of the harness) can be read back out of
  any program, and that same program is a bootstrap fixed point.

Finally, `cycle_cost_le` is the small arithmetic behind the performance protocol
of `BOOTSTRAP.md`: if every step of a cycle is inside a budget, the whole cycle
is inside the sum of the budgets.

As everywhere else in `RequestProject.Relay`, these are theorems about the
*model* of execution.  That `python3`, `node`, `gcc` and the rest implement the
model is evidence from running them — `bootstrap.sh` is that evidence.
-/

namespace RequestProject.Relay

/-- A **builder**: a function from a payload of digits to the text of a program.
Laying the payload out in a stage's notation and wrapping it in that stage's
code is a builder; so is anything else of that type. -/
def Builder : Type := List Char → List Char

/-- The builder of a stage: put the payload in this stage's shape, between the
two markers, with this stage's code around it. -/
def StageSpec.builder (S : StageSpec) : Builder :=
  fun d => S.pre ++ mark :: (S.shape.render d ++ mark :: S.post)

namespace Relay

variable {R : Relay}

/-- The program of a stage is that stage's builder applied to the relay's
payload.  This is the sense in which the relay *is* built by builders. -/
theorem builder_digits (R : Relay) (i : Nat) :
    (R.stage i).builder R.digits = R.prog i := rfl

end Relay

/-! ## Recovering the builder from a program -/

/-- The payload a program carries: the digits between its first two markers,
whatever notation they are written in. -/
def payload (t : List Char) : Option (List Char) := (extract t).map parseDigits

/-- **Recover a builder from a program's text.** The payload of `t` is decoded
and split into blocks, and the five blocks of stage `j` are assembled into the
function that lays a payload out as stage `j` writes it.  Nothing outside `t` is
consulted. -/
def recover (j : Nat) (t : List Char) : Option Builder := do
  let region ← extract t
  let ch ← decode (parseDigits region)
  let segs := splitOnChar sep ch
  let pre ← segs[5 * j]?
  let post ← segs[5 * j + 1]?
  let hd ← segs[5 * j + 2]?
  let gl ← segs[5 * j + 3]?
  let tl ← segs[5 * j + 4]?
  pure (fun d => pre ++ mark :: (hd ++ chunkJoin width gl d ++ tl ++ mark :: post))

/-- **One bootstrap step**: recover stage `j`'s builder from the text `t`, and
apply it to the payload `t` itself carries. -/
def rebuild (j : Nat) (t : List Char) : Option (List Char) :=
  (recover j t).bind fun B => (payload t).map B

/-- **The bootstrap view and the interpreter view agree.** Recovering a builder
from a text and applying it to that text's own payload is exactly what running
the text as a program of the relay does — for every text, well formed or not. -/
theorem rebuild_eq_host (j : Nat) (t : List Char) : rebuild j t = host j t := by
  unfold rebuild recover host payload
  cases hx : extract t with
  | none => simp
  | some region =>
    cases hdec : decode (parseDigits region) with
    | none => simp [hdec]
    | some ch =>
      cases h0 : (splitOnChar sep ch)[5 * j]? with
      | none => simp [hdec, h0]
      | some pre =>
        cases h1 : (splitOnChar sep ch)[5 * j + 1]? with
        | none => simp [hdec, h0, h1]
        | some post =>
          cases h2 : (splitOnChar sep ch)[5 * j + 2]? with
          | none => simp [hdec, h0, h1, h2]
          | some hd2 =>
            cases h3 : (splitOnChar sep ch)[5 * j + 3]? with
            | none => simp [hdec, h0, h1, h2, h3]
            | some gl =>
              cases h4 : (splitOnChar sep ch)[5 * j + 4]? with
              | none => simp [hdec, h0, h1, h2, h3, h4]
              | some tl => simp [hdec, h0, h1, h2, h3, h4, List.append_assoc]

namespace Relay

variable {R : Relay}

/-- The payload read out of any program of a well-formed relay is the relay's
payload. -/
theorem payload_prog (h : R.WF) (i : Nat) : payload (R.prog i) = some R.digits := by
  simp [payload, extract_prog h i, parse_prog h i]

/-- **The builder of any stage can be read out of any program.** The relay's
own build recipe travels inside every one of its programs. -/
theorem recover_prog (h : R.WF) (i j : Nat) (hj : j < R.size) :
    recover j (R.prog i) = some (R.stage j).builder := by
  have hex := extract_prog h i
  have hpar := parse_prog h i
  have h0 := blocks_getElem R hj (k := 0) (by omega)
  have h1 := blocks_getElem R hj (k := 1) (by omega)
  have h2 := blocks_getElem R hj (k := 2) (by omega)
  have h3 := blocks_getElem R hj (k := 3) (by omega)
  have h4 := blocks_getElem R hj (k := 4) (by omega)
  simp only [StageSpec.blocks, Nat.add_zero, List.getElem?_cons_zero,
    List.getElem?_cons_succ] at h0 h1 h2 h3 h4
  simp only [recover, hex, Option.bind_eq_bind, Option.bind_some, hpar, decode_digits h,
    split_data h, h0, h1, h2, h3, h4]
  refine congrArg some (funext fun d => ?_)
  simp [StageSpec.builder, Shape.render, List.append_assoc]

/-- **Rebuilding.** The builder of stage `j`, recovered from the text of *any*
program of the relay and applied to that program's own payload, is the program
of stage `j`. -/
theorem rebuild_prog (h : R.WF) (i j : Nat) (hj : j < R.size) :
    rebuild j (R.prog i) = some (R.prog j) := by
  rw [rebuild_eq_host]
  exact host_prog h i j hj

/-- **The fixed point.** From a program's text alone: recover the builder it
carries for itself, apply it to the payload it carries, and you get that very
program back, byte for byte.  This is what makes the artefact self-hosting. -/
theorem bootstrap_fixed_point (h : R.WF) (i : Nat) (hi : i < R.size) :
    rebuild i (R.prog i) = some (R.prog i) :=
  rebuild_prog h i i hi

end Relay

/-! ## Bootstrap sequences

A bootstrap sequence is a chain of builders, each one recovered from the
artefact the previous one produced. -/

/-- One step of a bootstrap sequence of `n` stages: from the artefact of stage
`i`, recover the builder of stage `i+1` and apply it. -/
def bootStep (n i : Nat) (t : List Char) : Option (List Char) := rebuild ((i + 1) % n) t

/-- `k` steps of a bootstrap sequence, starting from the artefact of stage `i`
out of `n`. -/
def bootChain (n : Nat) : Nat → Nat → List Char → Option (List Char)
  | 0, _, t => some t
  | k + 1, i, t => (bootStep n i t).bind fun t' => bootChain n k ((i + 1) % n) t'

/-- A bootstrap step is a relay step. -/
theorem bootStep_eq_run (n i : Nat) (t : List Char) : bootStep n i t = run n i t := by
  simp [bootStep, run, rebuild_eq_host]

/-- A bootstrap sequence is a relay run. -/
theorem bootChain_eq_runN (n : Nat) : ∀ (k i : Nat) (t : List Char),
    bootChain n k i t = runN n k i t := by
  intro k
  induction k with
  | zero => intro i t; rfl
  | succ k ih =>
    intro i t
    simp only [bootChain, runN, bootStep_eq_run]
    cases run n i t with
    | none => rfl
    | some t' => simpa using ih ((i + 1) % n) t'

namespace Relay

variable {R : Relay}

/-- Each builder of a bootstrap sequence really is recovered from the artefact
the previous one produced, and produces the next artefact. -/
theorem boot_chain_step (h : R.WF) (i : Nat) :
    recover ((i + 1) % R.size) (R.prog i) = some (R.stage ((i + 1) % R.size)).builder ∧
      (R.stage ((i + 1) % R.size)).builder R.digits = R.prog ((i + 1) % R.size) :=
  ⟨recover_prog h i _ (Nat.mod_lt _ R.size_pos), builder_digits R _⟩

/-- **The bootstrap sequence closes.** Recover a builder from the artefact, run
it, recover the next builder from *its* output, and so on: after as many steps
as there are stages, the text is the program you started from. -/
theorem boot_cycle (h : R.WF) (i : Nat) (hi : i < R.size) :
    bootChain R.size R.size i (R.prog i) = some (R.prog i) := by
  rw [bootChain_eq_runN]
  exact runN_size h i hi

/-- **A loaded relay is self-hosting.** From the text of any one of its programs,
and nothing else: the cargo — in practice the sources of the harness that wrote
the programs — can be read back out whole, and the program is a bootstrap fixed
point, rebuilt byte for byte by the builder its own payload carries. -/
theorem loaded_self_hosting (h : R.WF) {c : List Char}
    (hcode : ∀ ch ∈ c, Codeable ch) (hsep : sep ∉ c) (i : Nat) (hi : i < R.size) :
    readCargo c.length ((R.withCargo c).prog i) = some c ∧
      rebuild i ((R.withCargo c).prog i) = some ((R.withCargo c).prog i) := by
  refine ⟨readCargo_prog h hcode hsep i, ?_⟩
  exact bootstrap_fixed_point (withCargo_wf h hcode hsep) i (by simpa using hi)

end Relay

/-! ## The performance protocol

Every step of the bootstrap is given a budget in `BOOTSTRAP.md`: reproduce your
successor within `b` milliseconds.  The arithmetic that makes such a protocol
compose is this: a cycle of `k` steps, each inside the budget, costs at most
`k * b`. -/

/-- The cost of a run: the sum of the costs of its steps. -/
def totalCost (cs : List Nat) : Nat := cs.foldr (· + ·) 0

/-- **Budgets compose.** If every step of a run is within budget `b`, the whole
run costs at most (number of steps) × `b`. -/
theorem cost_le_of_budget (b : Nat) :
    ∀ cs : List Nat, (∀ c ∈ cs, c ≤ b) → totalCost cs ≤ cs.length * b := by
  intro cs
  induction cs with
  | nil => intro _; simp [totalCost]
  | cons c rest ih =>
    intro hall
    have hc : c ≤ b := hall c (by simp)
    have hrest : totalCost rest ≤ rest.length * b := ih fun x hx => hall x (by simp [hx])
    simp only [totalCost, List.foldr_cons, List.length_cons] at *
    have : (rest.length + 1) * b = rest.length * b + b := by
      rw [Nat.succ_mul]
    omega

namespace Relay

variable {R : Relay}

/-- **A full cycle is inside the budget.** If each of the `R.size` steps of a
relay costs at most `b`, a whole trip around the cycle costs at most
`R.size * b`. -/
theorem cycle_cost_le (R : Relay) (b : Nat) (cs : List Nat)
    (hlen : cs.length = R.size) (hall : ∀ c ∈ cs, c ≤ b) :
    totalCost cs ≤ R.size * b := by
  have := cost_le_of_budget b cs hall
  rwa [hlen] at this

end Relay

end RequestProject.Relay
