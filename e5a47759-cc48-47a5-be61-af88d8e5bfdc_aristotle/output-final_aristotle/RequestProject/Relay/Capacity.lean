import RequestProject.Relay.Cargo
import RequestProject.Relay.Templates

/-!
# How much of this repository can pass through the relay

`RequestProject.Relay.Cargo` shows that a relay can carry cargo — text that is
not part of any program — and that every program reproduces it and every trip
around the cycle returns it.  This file applies that to *the* relay: the
twenty-two programs of `RequestProject.Relay.Templates`.

`stages_carry_cargo` says that for **any** cargo at all — any length, as long as
each character is encodable in three decimal digits and none is the separator —
the loaded twenty-two-stage relay still has all its properties, and the cargo
can be read back out of every stage.  So in the model the answer to "how much of
the project can pass through the relay?" is: all of it, and any amount more.

The real programs are another matter, and that question is empirical.  The
measurement is done by `relay/capacity.py`, which loads the relay with a prefix
of the concatenated Lean sources of this repository and runs the whole cycle
through the twenty-two real interpreters and compilers; `README.md` reports
what it found.  The numbers there are measurements, not theorems.
-/

namespace RequestProject.Relay

/-- **The relay carries cargo.** Load the twenty-two programs with any text
whose characters are encodable and separator-free, and every one of them still
carries it: it can be read back out of any stage. -/
theorem stages_carry_cargo (c : List Char)
    (hcode : ∀ ch ∈ c, Codeable ch) (hsep : sep ∉ c) (i : Nat) :
    readCargo c.length ((stages.withCargo c).prog i) = some c :=
  Relay.readCargo_prog stages_wf hcode hsep i

/-- **The cargo goes all the way around.** Twenty-two runs return the program
they started from, cargo included. -/
theorem stages_cargo_cycle (c : List Char)
    (hcode : ∀ ch ∈ c, Codeable ch) (hsep : sep ∉ c) (i : Nat) (hi : i < stages.size) :
    runN (stages.withCargo c).size (stages.withCargo c).size i ((stages.withCargo c).prog i)
        = some ((stages.withCargo c).prog i)
      ∧ readCargo c.length ((stages.withCargo c).prog i) = some c :=
  Relay.cargo_survives_cycle stages_wf hcode hsep i hi

/-- Loading the relay does not change how many stages it has. -/
theorem stages_withCargo_size (c : List Char) : (stages.withCargo c).size = 22 := by
  rw [Relay.withCargo_size]
  exact stages_size

/-- **Every ASCII text can ride.** Printable ASCII — which is what the base64 of
anything at all is — satisfies the two conditions on cargo. -/
theorem ascii_ok (c : List Char) (h : ∀ ch ∈ c, 32 ≤ ch.toNat ∧ ch.toNat ≤ 126) :
    (∀ ch ∈ c, Codeable ch) ∧ sep ∉ c := by
  refine ⟨fun ch hch => ?_, fun hmem => ?_⟩
  · have hle := (h ch hch).2
    show ch.toNat < 1000
    omega
  · have hge := (h sep hmem).1
    have hsep : sep.toNat = 1 := by decide
    omega

/-- **No bound in the model.** For every size there is a cargo of that size that
the twenty-two-stage relay carries around its whole cycle. -/
theorem stages_cargo_unbounded (n : Nat) :
    ∃ c : List Char, c.length = n ∧
      ∀ i, readCargo n ((stages.withCargo c).prog i) = some c :=
  Relay.cargo_unbounded stages_wf n

end RequestProject.Relay
