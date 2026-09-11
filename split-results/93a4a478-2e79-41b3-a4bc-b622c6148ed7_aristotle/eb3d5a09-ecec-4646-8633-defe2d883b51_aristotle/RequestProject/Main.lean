/-
  Main entry point. Imports all modules of the translated Coq project.

  This is a Lean 4 translation of a Coq file that defines:
  - Basic UniMath-style types (Total2, Dirprod, etc.)
  - Protocol and state machine types with typeclass instances
  - Network, authentication, and connection typeclasses
  - Introspector model typeclasses (prompt, network, event, memory, proof, grammar)
  - Language model and model parameter typeclasses
  - A "mythos" typeclass with a Greek Athena mythology instance
  - Archetype typeclasses (warrior, woman)
  - A hero's journey typeclass
  - A Diagonalization sum type collecting various constructors

  The original Coq code had a comment asking:
    "Please help finish this proof — what are the next tactics we can use,
     how can we resolve the error?"
  This referred to the Protocol_type instance, which is now fully defined
  as `instance : ProtocolType Protocols2` in Protocols.lean.
-/

import RequestProject.BasicTypes
import RequestProject.Protocols
import RequestProject.Network
import RequestProject.Introspector
import RequestProject.Mythos
import RequestProject.HerosJourney
import RequestProject.Diagonalization
