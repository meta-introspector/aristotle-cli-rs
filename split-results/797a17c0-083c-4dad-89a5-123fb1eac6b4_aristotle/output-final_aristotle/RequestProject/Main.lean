/-
  Main.lean — Unified project hub.

  This project combines:
    • the original "Aristotle technical report" formalizations (`ImoReport`);
    • the playful description-logic / Clifford / Gödel / Monster experiments
      (`DescriptionLogic`, `Expressivity`, `Juggle`, `Clifford`, `GodelBrainrot`,
      `Monster`);
    • the full consolidated theory archive, re-exported through `ArchiveHub`
      (Monster/Moonshine, Clifford & Bott periodicity, DASHI, FRACTRAN, IPLD,
      governance, agents, Solfunmeme, and the cross-cluster bridges).

  The heavy Clifford "Gram block" cluster present in the tree is intentionally
  *not* imported here (each block is a long `native_decide` computation); those
  files can be built on demand via the `RequestProject` library glob.
-/

-- § Original technical-report formalizations
import RequestProject.ImoReport

-- § Description-logic experiments
import RequestProject.DescriptionLogic
import RequestProject.Expressivity
import RequestProject.Juggle
import RequestProject.Clifford
import RequestProject.GodelBrainrot
import RequestProject.Monster

-- § The full consolidated theory archive
import RequestProject.ArchiveHub
