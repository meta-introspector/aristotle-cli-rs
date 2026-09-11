/-
  Hero's Journey typeclass.
  Translation of the Coq heros_journey_type class.
  The hero's journey is a narrative structure commonly used in storytelling
  and literature. It involves the main character, the "hero," on a quest to
  overcome challenges and achieve a goal.
-/
class HerosJourneyType
    (t_apotheosis : Type)
    (t_risk : Type)
    (t_adventure : Type)
    (t_threshold : Type)
    (t_mentor : Type)
    (t_road_of_trials : Type)
    (t_skills : Type)
    (t_wisdom : Type)
    (t_perspective : Type)
    (t_state_machine : Type)
    (t_event : Type)
    (t_call : Type)
    (t_goal : Type)
    (t_fufillment : Type)
    (t_reward : Type)
    (t_treasure : Type)
    (t_recognition : Type)
    (t_elixer : Type)
    (t_narrative : Type)
    (t_prophecy : Type)
    (t_retry : Type)
    (t_cave : Type)
    (t_sword : Type)
    (t_denied : Type)
    (t_failure : Type)
    (t_accepted : Type)
    (t_home : Type)
    (t_challenge : Type)
    (t_enemies : Type)
    (t_monsters : Type)
    (t_obstacles : Type)
    (t_action : Type)
    (t_descent : Type)
    (t_decision : Type)
    (t_being : Type)
    (t_hero : Type)
    (t_observation : Type)
    (t_descent2 : Type)
    (t_world : Type)
    (t_journey : Type)
    (t_situation : Type)
    (t_critical : Type)
    (t_team : Type)
    (t_opportunity : Type)
    (t_allies : Type) where
  handle_event : t_event
  recognise    : t_recognition
  recieve      : t_call → t_adventure
  begin_       : t_journey → t_state_machine
  thrown       : t_world → t_being → t_event
  join         : t_team → t_allies
  meet         : t_hero → t_mentor
  crossing     : t_threshold
  observe      : t_observation
  descend      : t_descent       -- LOW
  raise        : t_apotheosis    -- HIGH
  decide       : t_decision
  act          : t_action
  judge        : t_action
  critique     : t_action
  struggle     : t_hero → t_challenge
  transform    : t_hero → t_challenge
  take         : t_hero → t_sword
  gain         : t_hero → t_wisdom
  refusal      : t_hero → t_call → t_denied
  succeed      : t_hero → t_sword
  return_to    : t_hero → t_home
  resurrection : t_hero → t_failure → t_retry
