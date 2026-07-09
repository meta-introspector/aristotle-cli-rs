# DASL Plan Optimality Proof

**Submitted:** 2026-07-09T17:13:11Z
**Status:** ✅ PASSED

## Summary

| Metric | Value |
|--------|-------|
| Total tasks | 891 |
| Total layers | 10 |
| QoS entries | 517 |
| Last run pass rate | 24/24 (100%) |
| Proof checks passed | 15/15 |

## Plan Integrity

- **Topological sort:** 891 tasks in 10 layers
- **Cycles:** 0 ✅
- **Duplicates:** 0 ✅
- **GOAP state atoms:** 23 (valid dependency markers) ✅
- **Unresolvable dependencies:** 0 ✅

## Task Completeness

- **Task directories:** 891 all with SKILL.md ✅
- **All with SYSTEM.md:** ✅
- **Orphan tasks:** 0 ✅
- **Dead directories:** 0 ✅

## Model Selection (QoS)

| # | Provider | Model | QoS | p50 |
|---|----------|-------|-----|-----|
| 1 | cohere | command-a-vision-07-2025 | 0.920 | 16021ms |
| 2 | groq | openai/gpt-oss-20b | 0.919 | 16220ms |
| 3 | nvidia-nim | sarvamai/sarvam-m | 0.915 | 17019ms |
| 4 | nvidia-nim | meta/llama-3.2-3b-instruct | 0.914 | 17218ms |
| 5 | nvidia-nim | mistralai/mistral-nemotron | 0.914 | 17220ms |

## Previous Run

- **Project:** dasl-fuzz
- **Tasks:** 24
- **Passed:** 24
- **Failed:** 0
- **Time:** 218.027210672s
- **Rate:** 100% — zero waste ✅

## Sources

- toposort: /home/mdupont/dasl-planning/toposort-tasks.json (891 tasks, 10 layers)
- qos: /home/mdupont/dasl-planning/qos-registry.json (517 entries)
- plan: /home/mdupont/dasl-planning/DASL_PLAN.md
- proof_script: /mnt/data1/time-2026/05-may/31/n0x-pi/.dotagents/task-runner/scripts/prove-plan-optimality.py
- project_reports: /home/mdupont/dasl-planning/project-reports (last run: 24/24 passed)
