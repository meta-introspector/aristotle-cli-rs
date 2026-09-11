import RequestProject.Solfunmeme.Bootstrap.Plan

/-!
# Axiom audit for the bootstrap layer

Every result of the bootstrap development, printed with the axioms it rests on.
As elsewhere in this project nothing here uses `native_decide` or an axiom of
our own: at worst these proofs use `propext`, `Classical.choice` and
`Quot.sound`.
-/

namespace SFM.Bootstrap

-- the general model: capabilities
#print axioms caps_cons
#print axioms caps_append
#print axioms mem_caps_of_mem_held
#print axioms mem_caps_of_mem_gives
#print axioms feasible_mono
#print axioms needs_supplied
#print axioms not_feasible_of_need_missing
#print axioms feasible_from_caps
#print axioms caps_idem

-- the general model: cash
#print axioms run_append
#print axioms run_mem_trace
#print axioms rate_run
#print axioms trace_shift
#print axioms requiredFloat_nonneg
#print axioms solvent_iff_requiredFloat_le
#print axioms solvent_mono_float
#print axioms cash_ge_of_selfFunding
#print axioms solvent_of_selfFunding
#print axioms solvent_replicate_of_selfFunding
#print axioms requiredFloat_of_free
#print axioms totalCost_append
#print axioms totalIncome_append

-- the plan: what it is
#print axioms plan_length
#print axioms plan_feasible
#print axioms plan_needs_are_supplied_earlier
#print axioms plan_gives_everything
#print axioms mirror_restarts_the_plan
#print axioms mirror_publishes_the_seed
#print axioms plan_reruns_on_its_own_output
#print axioms stage_checks_nonempty
#print axioms stage_checks_distinct
#print axioms stage_names_distinct

-- the plan: what it costs
#print axioms total_cost
#print axioms total_cost_splits
#print axioms every_stage_pays_the_month
#print axioms eight_stages_cost_only_the_month
#print axioms monthly_run_rounds_up_the_priced_bill
#print axioms wish_spend_is_the_open_programme
#print axioms wish_stages_are_the_open_wishes

-- the plan: whether it can be paid for
#print axioms required_float
#print axioms plan_solvent
#print axioms float_is_tight
#print axioms affordable_iff
#print axioms deepest_month
#print axioms self_funding_from_senate
#print axioms not_self_funding_before_senate
#print axioms end_state
#print axioms maintenance_solvent_for_ever
#print axioms float_repaid_in_five_months
#print axioms float_not_repaid_in_four
#print axioms no_revenue_float

end SFM.Bootstrap
