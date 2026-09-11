/-
  Introspector model types.
  Translation of the Coq introspector classes.
-/
import RequestProject.Network

class IntrospectorPromptModel (t_language : Type) (t_project : Type) where
  prompt : SimpleString

class IntrospectorNetworkModel (t_state_machine : Type) (t_protocol : Type) where
  prompt_type : t_protocol → SimpleString

class IntrospectorEventModel
    (t_error_retry_handler : Type)
    (t_logging_handler : Type)
    (t_introspection_visitor : Type) where
  event : SimpleString

class IntrospectorMemoryModel
    (t_short_term_memory : Type)
    (t_long_term_memory : Type) where
  memory : SimpleString

class IntrospectorProofModel
    (t_prelude : Type)
    (t_context : Type)
    (t_environment : Type)
    (t_goal : Type)
    (t_notations : Type)
    (t_lemmas : Type)
    (t_proofs : Type)
    (t_sets : Type)
    (t_types : Type)
    (t_propositions : Type)
    (t_universes : Type)
    (t_objects : Type)
    (t_validators : Type) where
  proof : SimpleString

class IntrospectorGrammarModel (t_grammars : Type) where
  grammar : SimpleString

class ClassTypeResult
    (t_name : Type)
    (t_param : Type)
    (t_params : Type)
    (t_method : Type)
    (t_methods : Type)
    (t_method_param : Type)
    (t_type : Type)
    (t_val : Type)
    (t_vals : Type) where
  begin_type   : t_name → t_params → t_methods → t_vals → t_type
  begin_method : t_name → t_params → t_method
  add_method   : t_methods → t_method → t_methods
  begin_val    : t_name → t_type → t_val
  add_val      : t_vals → t_val → t_vals

class ModelParams
    (t_string : Type)
    (t_prompt : Type)
    (t_nat : Type)
    (t_real : Type)
    (t_result : Type) where
  request : t_prompt → t_nat → t_real → t_nat → t_nat → t_result

class LangModel
    (t_connection : Type)
    (t_model_params : Type)
    (t_style : Type)
    (t_prompt : Type)
    (t_result : Type) where
  generate_text : t_connection → t_model_params → t_style → t_prompt → t_result
