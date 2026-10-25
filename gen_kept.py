#!/usr/bin/env python3
import gzip, re
from collections import Counter

INPUT_GZ = '/home/mdupont/projects/arist/all_lean_locate.txt.gz'
KEEP_TOKENS = {
    'sbfmachine', 'stackmachine', 'softmachine', 'mini2machine',
    'ziskmachine', 'ziskmachinefull', 'oodamachine', 'machinetranslatable',
    'vonneumanniasmachine', 'wumpusmachine', 'votemachine', 'tycoonmachine',
    'tournamentmachine', 'qbertmachine', 'oraclemachine', 'mememachine',
    'marketmachine', 'lordmachine', 'invadersmachine', 'hyperspacemachine',
    'frontiermachine', 'flightmachine', 'dashmachine',
    'universalmachineteachingset', 'universalmachinedistinct', 'universalgroupmachine', 'universalmachinemain',
    'projectiveline32machine', 'projectiveline27machine', 'affinefourmachine',
    'moretransitivemachines', 'morelargemachines', 'mathieubigmachines', 'evenmoretransitivemachines',
    'fractranvm', 'wasmemit', 'wasmmachine',
    'gearboxmachine', 'extrusionmachine', 'monster_vm_complete',
}

def should_keep(name):
    n = name.lower()
    for suf in ('.lean', '.ilean', '.olean'):
        if n.endswith(suf):
            n = n[:-len(suf)]
            break
    if n in KEEP_TOKENS:
        return True
    if n.startswith('server_variant_'):
        rest = n[len('server_variant_'):]
        if rest in KEEP_TOKENS:
            return True
    return False

name_counter = Counter()
with gzip.open(INPUT_GZ, 'rt', encoding='utf-8') as f:
    for line in f:
        basename = line.strip().split('/')[-1]
        normalized = basename.lower()
        if normalized.endswith('.lean'):
            normalized = normalized[:-5]
        if not normalized:
            continue
        name_counter[normalized] += 1

kept = sorted([name for name in name_counter if should_keep(name)])
with open('/mnt/data1/time-2026/05-may/07/arist/kept_names.txt', 'w') as f:
    for n in kept:
        f.write(f'{n}\n')

with open('/mnt/data1/time-2026/05-may/07/arist/deleted_names.txt', 'w') as f:
    for name, cnt in name_counter.most_common():
        if not should_keep(name):
            f.write(f'{cnt}\t{name}\n')
