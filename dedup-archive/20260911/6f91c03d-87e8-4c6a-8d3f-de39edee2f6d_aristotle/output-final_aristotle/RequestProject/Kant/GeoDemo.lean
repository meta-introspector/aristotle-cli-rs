/-
# Worked examples for the map view

Every `#guard` below is checked when the project is built, and the same
values are the golden vectors the browser client is tested against
(`web/map-test.mjs`).  If the JavaScript ever disagrees with the Lean,
the test fails.
-/
import RequestProject.Kant.Nft

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.GeoDemo

open Kant Kant.Geo Kant.GeoRef Kant.MapView Kant.Nft

/-! ## Three places -/

/-- The Eiffel Tower. -/
def paris : Coord := ⟨48858370, 2294481⟩

/-- The Statue of Liberty. -/
def liberty : Coord := ⟨40689200, -74044500⟩

/-- Sydney Opera House. -/
def sydney : Coord := ⟨-33856800, 151215200⟩

#guard paris.Valid
#guard liberty.Valid
#guard sydney.Valid

/-! ## Normalising -/

#guard Coord.norm ⟨48858370, 2294481⟩ = paris
#guard wrapLon 190000000 = -170000000
#guard wrapLon (-190000000) = 170000000
#guard wrapLon 540000000 = -180000000
#guard clampLat 95000000 = 90000000
#guard clampLat (-95000000) = -90000000

/-! ## Tiles and quadkeys -/

#guard tileOf 12 paris = ⟨12, 2074, 936⟩
#guard tileOf 12 liberty = ⟨12, 1205, 1122⟩
#guard tileOf 12 sydney = ⟨12, 3768, 2818⟩
#guard (tileOf 12 paris).parent = tileOf 11 paris
#guard String.ofList (tileOf 6 paris).quadkey = "102220"
#guard String.ofList (tileOf 6 liberty).quadkey = "030012"
#guard String.ofList (tileOf 6 sydney).quadkey = "313210"
#guard ofQuadkey (tileOf 6 paris).quadkey = some (tileOf 6 paris)

/-! ## Degrees as text -/

#guard String.ofList (showDeg paris.lat) = "48.858370"
#guard String.ofList (showDeg liberty.lon) = "-74.044500"
#guard String.ofList (showDeg sydney.lat) = "-33.856800"
#guard readDeg (showDeg liberty.lon) = liberty.lon
#guard String.ofList (geoUri paris) = "geo:48.858370,2.294481"
#guard parseGeoUri (geoUri sydney) = some sydney

/-! ## Records -/

/-- Paris on Wikidata. -/
def parisQ : Qid := ⟨90⟩

/-- Paris on OpenStreetMap. -/
def parisOsm : OsmRef := ⟨.relation, 7444⟩

/-- The Eiffel Tower on Wikipedia. -/
def eiffelWiki : WikiRef := ⟨"en".toList, "Eiffel Tower".toList⟩

#guard String.ofList (qidUrl parisQ) = "https://www.wikidata.org/wiki/Q90"
#guard String.ofList (osmUrl parisOsm) = "https://www.openstreetmap.org/relation/7444"
#guard String.ofList (wikiUrl eiffelWiki) = "https://en.wikipedia.org/wiki/Eiffel_Tower"
#guard parseRefUrl (Ref.osm parisOsm).url = some (.osm parisOsm)
#guard parseRefUrl (Ref.data parisQ).url = some (.data parisQ)
#guard parseRefUrl (Ref.wiki eiffelWiki).url = some (.wiki eiffelWiki)
#guard String.ofList (Ref.attribution (.osm parisOsm)) = "© OpenStreetMap contributors, ODbL"
#guard String.ofList (Ref.attribution (.data parisQ)) = "Wikidata, CC0"
#guard String.ofList (Ref.attribution (.wiki eiffelWiki)) = "Wikipedia, CC BY-SA 4.0"

/-! ## Pins, clusters and pages -/

/-- A post pinned at the Eiffel Tower. -/
def pinParis : Pin :=
  { witness := "aaaa".toList, title := "Tower".toList, place := paris,
    refs := [.wiki eiffelWiki, .osm parisOsm] }

/-- A post pinned in New York. -/
def pinLiberty : Pin :=
  { witness := "bbbb".toList, title := "Harbour".toList, place := liberty, refs := [.data ⟨9202⟩] }

/-- A second post at the same place as the first. -/
def pinParis2 : Pin :=
  { witness := "cccc".toList, title := "Again".toList, place := paris, refs := [] }

/-- The three of them. -/
def somePins : List Pin := [pinParis, pinLiberty, pinParis2]

#guard (keys 12 somePins).length = 2
#guard (clusterAt 12 somePins (tileOf 12 paris)).length = 2
#guard (clusterAt 12 somePins (tileOf 12 liberty)).length = 1
#guard ((clusters 12 somePins).map (fun c => c.2.length)).sum = 3
#guard (visible ⟨0, 0, 90000000, 90000000⟩ somePins).length = 2
#guard String.ofList (Page.path (Page.region (tileOf 6 paris))) = "map/102220.html"
#guard String.ofList (Page.path (Page.post pinParis.witness)) = "post/aaaa.html"
#guard (site 6 somePins).length = 6
#guard Kant.Text.containsSub "geo:48.858370,2.294481".toList (pinRow pinParis)
#guard Kant.Text.containsSub "Wikipedia, CC BY-SA 4.0".toList (pinRow pinParis)
#guard Kant.Text.containsSub "© OpenStreetMap contributors, ODbL".toList (pinRow pinParis)

/-! ## An OpenStreetMap element, imported -/

/-- The Eiffel Tower as OSM holds it, with its links to the other two
projects. -/
def eiffelElement : OsmElement :=
  { kind := .way, id := 5013364, place := paris, name := "Tour Eiffel".toList,
    tags := [("wikidata".toList, qidTag ⟨243⟩),
             ("wikipedia".toList, wikiTag eiffelWiki),
             ("tourism".toList, "attraction".toList)] }

#guard String.ofList (qidTag ⟨243⟩) = "Q243"
#guard String.ofList (wikiTag eiffelWiki) = "en:Eiffel Tower"
#guard parseQidTag (qidTag ⟨243⟩) = some ⟨243⟩
#guard parseWikiTag (wikiTag eiffelWiki) = some eiffelWiki
#guard refOfTag "tourism".toList "attraction".toList = none
#guard (refsOfElement eiffelElement).length = 3
#guard (pinOfElement "dddd".toList eiffelElement).place = paris
#guard Ref.data ⟨243⟩ ∈ (pinOfElement "dddd".toList eiffelElement).refs
#guard Ref.wiki eiffelWiki ∈ (pinOfElement "dddd".toList eiffelElement).refs
#guard (importOsm ["dddd".toList] [eiffelElement]).length = 1

/-! ## A gallery card -/

/-- One enrichment of the gallery. -/
def cardParis : Entry :=
  { entity := parisQ, name := "Paris".toList, description := "Capital of France".toList,
    category := "city".toList, imageCid := "bafyparis".toList,
    record := Kant.Text.asciiBytes "Q90:Paris".toList, time := 30, place := some paris }

#guard verify cardParis cardParis.witness
#guard ¬ verify cardParis "0000".toList
#guard parseGatewayPath (gatewayPath cardParis.imageCid) = some cardParis.imageCid
#guard gallery ⟨0, none⟩ [cardParis] = [cardParis]
#guard gallery ⟨31, none⟩ [cardParis] = []
#guard gallery ⟨0, some "city".toList⟩ [cardParis] = [cardParis]
#guard gallery ⟨0, some "river".toList⟩ [cardParis] = []
#guard Kant.Text.containsSub "Wikidata, CC0".toList (card cardParis)
#guard (pins [cardParis]).length = 1
#guard (pins [cardParis]).head?.map Pin.place = some paris

end Kant.GeoDemo
