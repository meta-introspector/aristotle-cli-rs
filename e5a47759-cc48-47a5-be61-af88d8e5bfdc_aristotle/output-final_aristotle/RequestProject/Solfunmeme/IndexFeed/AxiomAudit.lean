import RequestProject.Solfunmeme.IndexFeed.Facts

/-!
# Axiom audit for the index feed

The structural results in `RequestProject/IndexFeed/Model.lean` are ordinary
proofs: they rest on at most `propext`, `Classical.choice` and `Quot.sound`.

The facts about the *received* feed in `RequestProject/IndexFeed/Facts.lean`
are finite checks over 2250 documents and 52543 postings, discharged by
evaluating the check with the compiler (`native_decide`); they therefore also
rest on `Lean.ofReduceBool`.  This file prints both groups so the difference
is on the record.
-/

namespace Solfunmeme.IndexFeed

-- the model: kernel-checked
#print axioms mem_hits
#print axioms hits_mono
#print axioms hits_append
#print axioms missing_eq_nil_iff
#print axioms docIds_head_disjoint
#print axioms docIds_nodup_of_blocks
#print axioms exists_chunk_of_mem_allPostings
#print axioms mem_docIds_of_posting
#print axioms allPostings_nodup_of_blocks

-- the received feed: finite checks by evaluation
#print axioms feed_length
#print axioms feed_seqs
#print axioms missing_length
#print axioms docs_count
#print axioms docIds_nodup
#print axioms postings_count
#print axioms postings_nodup
#print axioms term_count
#print axioms hapax_count
#print axioms mathlib_docs
#print axioms aesop_docs
#print axioms no_solfunmeme_document
#print axioms solfunmeme_no_hits

end Solfunmeme.IndexFeed
