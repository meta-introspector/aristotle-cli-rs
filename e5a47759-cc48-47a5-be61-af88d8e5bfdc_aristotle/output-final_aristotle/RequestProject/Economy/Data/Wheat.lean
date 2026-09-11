/-
# Data layer: one wheat basin, one year

Explicit observations and simulation assumptions.  Nothing in this file is a
claim about the world: the artifacts are named as they would be, but the
numbers here are a scenario, and the theory layer never imports it.

The scenario is deliberately built twice:

* `baselineCover` — five sites that can be reconciled;
* `disputedCover` — the same, plus a sixth site whose export figure is
  separated from customs, so the reconstruction *fails to glue*.

The negative case is the point.  A machine that can only say yes is not
checking anything.
-/
import RequestProject.Economy.Accept
import RequestProject.Economy.WeightedMedian

namespace RequestProject.Economy
namespace Wheat

/-- Smart constructor for an interval: the ordering proof is explicit. -/
def iv (lo hi : ℚ) (h : lo ≤ hi) : Interval := ⟨lo, hi, h⟩

/-- One agricultural basin, named by a canonical authority and code. -/
def basin : RegionCode := ⟨"ISO3166-2", "KZ-AKM", "Akmola wheat basin"⟩

/-- The calendar year 2023, as days since the epoch. -/
def year2023 : Period := ⟨19358, 19723, by decide⟩

/-- The four quarters of that year, as a consecutive decomposition. -/
def q1 : Period := ⟨19358, 19448, by decide⟩
def q2 : Period := ⟨19448, 19539, by decide⟩
def q3 : Period := ⟨19539, 19631, by decide⟩
def q4 : Period := ⟨19631, 19723, by decide⟩

def quarters : List Period := [q2, q3, q4]

def cell (l : Line) : Cell := ⟨Commodity.wheat, basin, year2023, l⟩

def cells : List Cell :=
  [cell Line.openingStock, cell Line.production, cell Line.imports, cell Line.otherSupply,
   cell Line.exports, cell Line.intermediateUse, cell Line.finalConsumption, cell Line.losses,
   cell Line.otherDisposition, cell Line.closingStock]

/-! ### Artifacts -/

def faoArtifact : Artifact :=
  { id := "fao-fbs-2023"
    kind := EvidenceKind.governmentStatistic
    source := { publisher := "national statistical office", title := "food balance sheet 2023"
                url := "https://example.invalid/fbs-2023.csv"
                publicationDate := some "2024-05-01", retrievedDate := "2024-06-01" }
    contentHash := "sha256:0000000000000000000000000000000000000000000000000000000000000001"
    licenseName := "unspecified — redistribution not assessed here"
    capturedAt := "2024-06-01T00:00:00Z"
    spatialExtent := some "KZ-AKM" }

def satelliteArtifact : Artifact :=
  { id := "sat-acreage-2023"
    kind := EvidenceKind.satelliteObservation
    source := { publisher := "earth observation provider", title := "cropland classification 2023"
                url := "https://example.invalid/acreage-2023.tif"
                publicationDate := some "2023-11-15", retrievedDate := "2024-06-01" }
    contentHash := "sha256:0000000000000000000000000000000000000000000000000000000000000002"
    licenseName := "provider terms — redistribution not assessed here"
    capturedAt := "2024-06-01T00:00:00Z"
    spatialExtent := some "KZ-AKM" }

def customsArtifact : Artifact :=
  { id := "customs-2023"
    kind := EvidenceKind.shippingRecord
    source := { publisher := "customs authority", title := "commodity trade 2023"
                url := "https://example.invalid/customs-2023.json"
                publicationDate := some "2024-03-01", retrievedDate := "2024-06-01" }
    contentHash := "sha256:0000000000000000000000000000000000000000000000000000000000000003"
    licenseName := "open government licence"
    capturedAt := "2024-06-01T00:00:00Z"
    spatialExtent := some "KZ-AKM" }

def osmArtifact : Artifact :=
  { id := "osm-storage-2024"
    kind := EvidenceKind.osmFeature
    source := { publisher := "OpenStreetMap contributors", title := "grain storage extract"
                url := "https://example.invalid/osm-storage.osm.pbf"
                publicationDate := none, retrievedDate := "2024-06-01" }
    contentHash := "sha256:0000000000000000000000000000000000000000000000000000000000000004"
    licenseName := "ODbL — attribution required"
    capturedAt := "2024-06-01T00:00:00Z"
    spatialExtent := some "KZ-AKM" }

def fieldArtifact : Artifact :=
  { id := "field-samples-2023"
    kind := EvidenceKind.fieldSample
    source := { publisher := "paid sampling network", title := "ten compensated yield samples"
                url := "https://example.invalid/samples-2023.json"
                publicationDate := none, retrievedDate := "2024-06-02" }
    contentHash := "sha256:0000000000000000000000000000000000000000000000000000000000000005"
    licenseName := "collected under protocol v1"
    capturedAt := "2024-06-02T00:00:00Z"
    spatialExtent := some "KZ-AKM" }

def mirrorArtifact : Artifact :=
  { id := "mirror-trade-2023"
    kind := EvidenceKind.expertEstimate
    source := { publisher := "trade analytics vendor", title := "mirror export estimate 2023"
                url := "https://example.invalid/mirror-2023.pdf"
                publicationDate := some "2024-04-01", retrievedDate := "2024-06-03" }
    contentHash := "sha256:0000000000000000000000000000000000000000000000000000000000000006"
    licenseName := "vendor terms — redistribution not assessed here"
    capturedAt := "2024-06-03T00:00:00Z"
    spatialExtent := some "KZ-AKM" }

/-- Site identifier to artifact. -/
def dossier : String → Option Artifact
  | "fao-fbs" => some faoArtifact
  | "satellite" => some satelliteArtifact
  | "customs" => some customsArtifact
  | "osm-storage" => some osmArtifact
  | "field-samples" => some fieldArtifact
  | "mirror-trade" => some mirrorArtifact
  | _ => none

/-! ### Local sections

All masses are tonnes of wheat in the basin during 2023.
-/

def faoSection : LocalSection :=
  { site := "fao-fbs"
    constraints :=
      [(cell Line.openingStock, iv 200000 200000 (by norm_num)),
       (cell Line.production, iv 3400000 3600000 (by norm_num)),
       (cell Line.imports, iv 0 50000 (by norm_num)),
       (cell Line.otherSupply, iv 0 0 (by norm_num)),
       (cell Line.exports, iv 900000 1000000 (by norm_num)),
       (cell Line.intermediateUse, iv 800000 900000 (by norm_num)),
       (cell Line.finalConsumption, iv 1500000 1700000 (by norm_num)),
       (cell Line.losses, iv 50000 150000 (by norm_num)),
       (cell Line.otherDisposition, iv 0 0 (by norm_num)),
       (cell Line.closingStock, iv 150000 250000 (by norm_num))] }

/-- Cultivated area from the satellite product, in hectares. -/
def satelliteArea : IQty Dim.area := ⟨iv 3000000 3400000 (by norm_num)⟩

/-- Yield in tonnes per hectare — a calibrated assumption with provenance, not
a measurement of tonnes. -/
def yieldCalibration : IQty Dim.yield := ⟨iv (11/10) (13/10) (by norm_num)⟩

/-- The satellite-derived production interval: area × yield. -/
def satelliteProduction : IQty Dim.mass := IQty.harvest satelliteArea yieldCalibration

def satelliteSection : LocalSection :=
  { site := "satellite"
    constraints := [(cell Line.production, satelliteProduction.iv)] }

def customsSection : LocalSection :=
  { site := "customs"
    constraints :=
      [(cell Line.exports, iv 950000 1050000 (by norm_num)),
       (cell Line.imports, iv 10000 40000 (by norm_num))] }

def osmSection : LocalSection :=
  { site := "osm-storage"
    constraints := [(cell Line.closingStock, iv 0 1200000 (by norm_num))] }

def fieldSection : LocalSection :=
  { site := "field-samples"
    constraints := [(cell Line.production, iv 3350000 3800000 (by norm_num))] }

/-- The sixth site: a mirror-trade estimate whose exports are far above what
customs reports.  Its interval is *separated* from the customs interval. -/
def mirrorSection : LocalSection :=
  { site := "mirror-trade"
    constraints := [(cell Line.exports, iv 1200000 1300000 (by norm_num))] }

def baselineCover : Cover :=
  [faoSection, satelliteSection, customsSection, osmSection, fieldSection]

def disputedCover : Cover := baselineCover ++ [mirrorSection]

/-! ### The published account -/

def intervalAccount : IntervalAccount :=
  { commodity := Commodity.wheat
    region := basin
    period := year2023
    openingStock := ⟨iv 200000 200000 (by norm_num)⟩
    production := ⟨iv 3400000 3600000 (by norm_num)⟩
    imports := ⟨iv 10000 40000 (by norm_num)⟩
    otherSupply := ⟨iv 0 0 (by norm_num)⟩
    exports := ⟨iv 950000 1000000 (by norm_num)⟩
    intermediateUse := ⟨iv 800000 900000 (by norm_num)⟩
    finalConsumption := ⟨iv 1500000 1700000 (by norm_num)⟩
    losses := ⟨iv 50000 150000 (by norm_num)⟩
    otherDisposition := ⟨iv 0 0 (by norm_num)⟩
    closingStock := ⟨iv 150000 250000 (by norm_num)⟩
    unattributedResidual := ⟨iv (-50000) 50000 (by norm_num)⟩ }

def account : Account :=
  { commodity := Commodity.wheat
    region := basin
    period := year2023
    openingStock := ⟨200000⟩
    production := ⟨3500000⟩
    imports := ⟨30000⟩
    otherSupply := ⟨0⟩
    exports := ⟨975000⟩
    intermediateUse := ⟨850000⟩
    finalConsumption := ⟨1600000⟩
    losses := ⟨100000⟩
    otherDisposition := ⟨0⟩
    closingStock := ⟨205000⟩ }

/-- An account that does not balance: production overstated by 300 000 t.
Used to check that the acceptance predicates can say no. -/
def inflatedAccount : Account := { account with production := ⟨3800000⟩ }

def reconstruction : Reconstruction :=
  { cover := baselineCover, cells := cells, dossier := dossier
    intervalAccount := intervalAccount, account := account }

def disputedReconstruction : Reconstruction := { reconstruction with cover := disputedCover }

def inflatedReconstruction : Reconstruction := { reconstruction with account := inflatedAccount }

/-! ### Field samples and settlement

Ten compensated samples of yield in tonnes per hectare: seven protocol-compliant
reports between 1.1 and 1.3, and three adversarial reports of 5.0.
-/

def honestSamples : List Obs :=
  [⟨1, 11/10⟩, ⟨1, 12/10⟩, ⟨1, 12/10⟩, ⟨1, 13/10⟩, ⟨1, 12/10⟩, ⟨1, 11/10⟩, ⟨1, 13/10⟩]

def adversarialSamples : List Obs := [⟨1, 5⟩, ⟨1, 5⟩, ⟨1, 5⟩]

def samples : List Obs := honestSamples ++ adversarialSamples

def settlementRule : Obs.SettlementRule :=
  { minWeight := 8, minCount := 10, fallback := 12/10 }

/-! ### Committee and certificate -/

def committee : Committee Nat :=
  { members := ({0, 1, 2, 3} : Finset Nat), faultBound := 1, sizeCondition := by decide }

/-- The state commitment the committee signs.  How the hash is computed is
irrelevant to the theorems; what matters is that the certificate binds one
state. -/
def hashOf (_a : Account) : StateHash := ⟨"wheat-akmola-2023"⟩

/-- In this scenario every committee member signs the published state and
nothing else. -/
def Signs (_v : Nat) (s : StateHash) : Prop := s = hashOf account

def quorum : Quorum committee :=
  { voters := ({0, 1, 2} : Finset Nat)
    subset := by decide
    large := by decide }

def certificate : Certificate committee Signs :=
  { state := hashOf account
    quorum := quorum
    signed := fun _ _ => rfl }

end Wheat
end RequestProject.Economy
