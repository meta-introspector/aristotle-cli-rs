import RequestProject.Solfunmeme.Pricing.Infra

/-!
# The price list, evaluated

The same objects the ledgers prove things about, printed.  Nothing here is a
theorem: every number below is also pinned by a theorem in
`RequestProject/Pricing/Wishes.lean` or `RequestProject/Pricing/Infra.lean`,
and this file exists so the tables can be read without reading the proofs.
Dollars are exact rationals, so `#eval` prints fractions.
-/

namespace RequestProject.Pricing

/-- One row of the wish table: identifier, lines, measured?, commodity bill,
frontier bill. -/
def wishRow (w : WishPrice) : Nat × Nat × Bool × USD × USD :=
  (w.id, w.lines, w.measured, commodityRates.bill w.workload, frontierRates.bill w.workload)

/-! The sixteen wishes, priced. -/
#eval wishPrices.map wishRow

/-! Totals: granted, open, and the whole programme, at both rate cards. -/
#eval (billOf commodityRates grantedWishes, billOf frontierRates grantedWishes)
#eval (billOf commodityRates openWishes, billOf frontierRates openWishes)
#eval (billOf commodityRates wishPrices, billOf frontierRates wishPrices)

/-! The four lines of the monthly infrastructure bill, one hosted node. -/
#eval (hostingLine 1, storageLine 1, checkingLine,
  maintenanceLine cheapestOffer, maintenanceLine dearestOffer)

/-! Monthly and annual, at the cheapest and at the dearest posted offer. -/
#eval (monthlyBill cheapestOffer 1, monthlyBill dearestOffer 1)
#eval (annualBill cheapestOffer 1, annualBill dearestOffer 1)

/-! What a fleet costs: one, ten, a hundred, a thousand hosted nodes, at the
cheapest posted offer. -/
#eval [1, 10, 100, 1000].map (fun n => (n, monthlyBill cheapestOffer n))

/-! …and what the same fleet costs when the nodes host themselves, so the
project pays only for the bytes. -/
#eval [1, 10, 100, 1000].map (fun n => (n, storageLine n))

/-! The make-or-buy breakevens, in completion tokens, against the dearest and
the cheapest posted price. -/
#eval (ownServingVsFrontier.breakevenTokens, ownServingVsCommodity.breakevenTokens,
  annualGeneratedTokens)

end RequestProject.Pricing
