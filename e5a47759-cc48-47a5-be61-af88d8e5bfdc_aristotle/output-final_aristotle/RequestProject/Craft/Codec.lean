/-
# Standard Proof Codec & Exchange Specification — reference implementation

This module imports the whole codec: the canonical model, the format adapters
(IPDL, XML, CSV, YAML, raw text), validation and error resolution,
reconciliation, schema evolution, the import/export pipeline, and the required
test suite.

The canonical model is the authoritative interchange representation; every
format is an adapter to and from it, and no format is ever treated as
canonical.
-/
import RequestProject.Craft.Codec.Value
import RequestProject.Craft.Codec.Canonical
import RequestProject.Craft.Codec.Model
import RequestProject.Craft.Codec.Ipdl
import RequestProject.Craft.Codec.Xml
import RequestProject.Craft.Codec.Yaml
import RequestProject.Craft.Codec.Csv
import RequestProject.Craft.Codec.Text
import RequestProject.Craft.Codec.Validate
import RequestProject.Craft.Codec.Reconcile
import RequestProject.Craft.Codec.Schema
import RequestProject.Craft.Codec.Pipeline
import RequestProject.Craft.Codec.Tests
