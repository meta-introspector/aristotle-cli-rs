import RequestProject.Solfunmeme.Pricing.Infra

/-!
# Axiom audit for the pricing layer

Every result of the pricing development, printed with the axioms it rests on.
As elsewhere in this project nothing here uses `native_decide` or an axiom of
our own: at worst these proofs use `propext`, `Classical.choice` and
`Quot.sound`.
-/

namespace RequestProject.Pricing

-- the model
#print axioms Offer.quote_add
#print axioms Offer.blended_eq
#print axioms Offer.blended_mem_Icc
#print axioms Offer.quote_mono_outputTokens
#print axioms routeCost_le_of_mem
#print axioms routeCost_mem
#print axioms routeCost_cons_le
#print axioms routeCost_nonneg
#print axioms routeCost_le_blend
#print axioms Gateway.charge_eq_add_fee
#print axioms Gateway.charge_routeCost_le
#print axioms MakeOrBuy.makeCost_le_buyCost_iff
#print axioms MakeOrBuy.buying_always_wins
#print axioms RateCard.bill_add
#print axioms RateCard.bill_sum
#print axioms RateCard.bill_nonneg
#print axioms RateCard.bill_mono
#print axioms Effort.split_add
#print axioms Effort.quote_linear
#print axioms Effort.quote_scale_draftMultiplier
#print axioms Effort.quote_mono

-- the prices
#print axioms priceList_length
#print axioms priceList_wellFormed
#print axioms extremes_listed
#print axioms rates_wellFormed
#print axioms commodity_bill_le_frontier
#print axioms effortOf_one
#print axioms effortOf_add

-- the wishes
#print axioms pricing_covers_the_roadmap
#print axioms measured_iff_granted
#print axioms sized_counts
#print axioms every_wish_costs_something
#print axioms granted_lines
#print axioms open_lines
#print axioms ready_lines
#print axioms attribution_exhausts_the_corpus
#print axioms open_lines_exceed_granted
#print axioms bill_is_additive
#print axioms granted_bill_commodity
#print axioms granted_bill_frontier
#print axioms open_bill_commodity
#print axioms open_bill_frontier
#print axioms programme_bill_commodity
#print axioms programme_bill_frontier
#print axioms programme_splits
#print axioms open_dearer_than_granted
#print axioms ready_bill_commodity
#print axioms ready_bill_frontier
#print axioms dearest_open_wish
#print axioms frontier_over_commodity
#print axioms open_programme_in_h200_hours
#print axioms programme_share_of_marketplace
#print axioms programme_under_three_h100_hours
#print axioms doubling_waste_doubles_tokens

-- the infrastructure
#print axioms state_under_a_gigabyte
#print axioms hosting_one_node
#print axioms storage_one_node
#print axioms checking_monthly
#print axioms maintenance_range
#print axioms monthly_bill_commodity
#print axioms monthly_bill_frontier
#print axioms annual_bill_commodity
#print axioms annual_bill_frontier
#print axioms bill_linear_in_nodes
#print axioms links_exceed_nodes
#print axioms sneakernet_node_is_storage_only
#print axioms thousand_replicas
#print axioms hosting_dominates
#print axioms checking_exceeds_maintenance
#print axioms h100Year_value
#print axioms own_serving_breakeven
#print axioms annualGeneratedTokens_value
#print axioms buying_wins_at_our_volume
#print axioms month_in_h200_hours
#print axioms infra_year_under_one_h100_year
#print axioms whole_operation_annual
#print axioms whole_operation_share

end RequestProject.Pricing
