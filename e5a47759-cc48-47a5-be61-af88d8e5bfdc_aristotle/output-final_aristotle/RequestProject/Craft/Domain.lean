/-
# Domain data codec and proof catalogue

This module imports the whole domain-data layer: the escaping and splitting
foundation, the record/token backbone, the canonical domain graph, the generic
line-codec layer, the five emitted representations, proof coverage and the
proof ledger, and the catalogue of this project's own proof corpus.
-/
import RequestProject.Craft.Domain.Escape
import RequestProject.Craft.Domain.Rec
import RequestProject.Craft.Domain.Graph
import RequestProject.Craft.Domain.Lines
import RequestProject.Craft.Domain.Formats
import RequestProject.Craft.Domain.Ledger
import RequestProject.Craft.Domain.Instance
import RequestProject.Craft.Domain.InstanceFacts
