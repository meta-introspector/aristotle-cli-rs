/-
# Economic reconstruction

A formally checked, provenance-preserving reconstruction of physical economic
activity from public evidence.  The layers are kept apart deliberately:

* **Theory** — parameter-free definitions and proofs.  `Dimensions`,
  `Quantities`, `Intervals`, `Time`, `Regions`, `Accounting`, `WeightedMedian`,
  `Gluing`, `Quorum`, `Evidence`, `Accept`.  No dataset is imported here.
* **Data** — explicit observations and scenario assumptions (`Data.Wheat`).
* **Ledger** — the instantiated results for a scenario (`Ledger.Wheat`).

What is proved and what is assumed is set out in `docs/TRUST_BOUNDARIES.md`.
The short version: these are theorems about a model, under stated cryptographic
and measurement assumptions.  None of them says a source is truthful, that a
quorum implies physical reality, or that a satellite-to-tonnes conversion is
correct.
-/
import RequestProject.Economy.Dimensions
import RequestProject.Economy.Quantities
import RequestProject.Economy.Intervals
import RequestProject.Economy.Time
import RequestProject.Economy.Regions
import RequestProject.Economy.Accounting
import RequestProject.Economy.WeightedMedian
import RequestProject.Economy.Gluing
import RequestProject.Economy.Quorum
import RequestProject.Economy.Evidence
import RequestProject.Economy.Accept
import RequestProject.Economy.Data.Wheat
import RequestProject.Economy.Ledger.Wheat
