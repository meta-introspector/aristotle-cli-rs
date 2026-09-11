import RequestProject.Compute.IPLD.Cid

/-!
# IPLD content-addressing (aggregator)

This is the umbrella module for the cryptographic content-addressing engine. It
re-exports the verified CID layer (`RequestProject.Compute.IPLD.Cid`), whose
central guarantee is that the address map is injective (collision-free) and
deterministic.
-/
