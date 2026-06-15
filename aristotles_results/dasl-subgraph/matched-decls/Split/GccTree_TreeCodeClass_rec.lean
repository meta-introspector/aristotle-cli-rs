import Split.GccTree_TreeCodeClass_tcc_unary
import Split.GccTree_TreeCodeClass_tcc_declaration
import Split.GccTree_TreeCodeClass_tcc_statement
import Split.GccTree_TreeCodeClass_tcc_exceptional
import Split.GccTree_TreeCodeClass_tcc_constant
import Split.GccTree_TreeCodeClass_tcc_comparison
import Split.GccTree_TreeCodeClass_tcc_type
import Split.GccTree_TreeCodeClass_tcc_binary
import Split.GccTree_TreeCodeClass_tcc_reference
import Split.GccTree_TreeCodeClass_tcc_vl_exp
import Split.GccTree_TreeCodeClass_tcc_expression
import Split.GccTree_TreeCodeClass

-- GccTree.TreeCodeClass.rec from environment
-- recursor GccTree.TreeCodeClass.rec : forall {motive : GccTree.TreeCodeClass -> Sort.{u}}, (motive GccTree.TreeCodeClass.tcc_exceptional) -> (motive GccTree.TreeCodeClass.tcc_constant) -> (motive GccTree.TreeCodeClass.tcc_type) -> (motive GccTree.TreeCodeClass.tcc_declaration) -> (motive GccTree.TreeCodeClass.tcc_reference) -> (motive GccTree.TreeCodeClass.tcc_comparison) -> (motive GccTree.TreeCodeClass.tcc_unary) -> (motive GccTree.TreeCodeClass.tcc_binary) -> (motive GccTree.TreeCodeClass.tcc_statement) -> (motive GccTree.TreeCodeClass.tcc_vl_exp) -> (motive GccTree.TreeCodeClass.tcc_expression) -> (forall (t : GccTree.TreeCodeClass), motive t)

-- Stub: this file represents the declaration `GccTree.TreeCodeClass.rec`.
-- In a full split, the body would be extracted from the environment.
