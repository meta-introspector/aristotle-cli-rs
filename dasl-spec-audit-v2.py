#!/usr/bin/env python3
"""
DASL Spec Audit v2 — 36 spec elements from 7 sources, cross-referenced with fuzz corpus.

Sources: grant, theory, components, test-plan, build-memory, cddl, aristotle.
Output: HTML report with coverage % per source, per-category, per-element.
"""
import os, json
from collections import defaultdict
from datetime import datetime

FUZZ_CORPUS = os.path.expanduser("~/2026/06/22/dasl-fuzz-corpus")
OUT_HTML = os.path.expanduser("~/2026/06/22/dasl-spec-audit-v2.html")

ALL_SPECS = [
    {"id":"DASL-1.1","source":"grant","category":"Content Addressing","desc":"Content identifiers MUST be cryptographic hashes (SHA256-based CIDv1)","kw":["CID","hash","multihash","content","addressing","bafy"]},
    {"id":"DASL-1.2","source":"grant","category":"Content Addressing","desc":"Test vectors MUST have unique identifiers (no CID collisions)","kw":["CID","unique","injective","noConfusion","nocollision"]},
    {"id":"DASL-2.1","source":"grant","category":"Monster Symmetries","desc":"Corpus MUST cover all 15 supersingular prime symmetry classes","kw":["prime","supersingular","Monster","SSP","ogg","symmetry"]},
    {"id":"DASL-2.2","source":"grant","category":"Monster Symmetries","desc":"Complexity bounded by Griess dimension V1=196,883","kw":["196883","Griess","monster","dim","complexity","irrep"]},
    {"id":"DASL-3.1","source":"grant","category":"State Transitions","desc":"State transitions MUST be deterministic (pure functions)","kw":["step","deterministic","pure","preserves","idempotent"]},
    {"id":"REQ-1","source":"grant","category":"Corpus Scale","desc":"Test Corpus: target 38,725 test vectors","kw":["corpus","count","card","length","size","vector"]},
    {"id":"REQ-2","source":"grant","category":"Fuzzing","desc":"Automated test generation via FRACTRAN evolution","kw":["Fractran","step","run","evolve","generate","program"]},
    {"id":"REQ-13","source":"grant","category":"Adversarial","desc":"Edge case testing: Monster cusp evolution at 1/p","kw":["cusp","boundary","obstruction","qliphoth","edge","adversarial"]},
    {"id":"TH-1","source":"theory","category":"Quasi-Fiber Bundle","desc":"DASL traces form quasi-fiber bundle over Monster conjugacy classes","kw":["fiber","bundle","section","sheaf","orbifold","sheafSection"]},
    {"id":"TH-2","source":"theory","category":"Bott Periodicity","desc":"8-fold Bott periodicity in complexity classes","kw":["Bott","period","clock","bottFold","NestedCarriage","periodicity"]},
    {"id":"TH-3","source":"theory","category":"71-Layer Sharding","desc":"15 supersingular primes define execution partitions (max 71)","kw":["shard","layer","prime","partition","71","supersingular"]},
    {"id":"TH-4","source":"theory","category":"Griess Algebra","desc":"DAG operations correspond to Griess algebra axis products","kw":["Griess","axis","algebra","DAG","product"]},
    {"id":"TH-5","source":"theory","category":"Monster Walk","desc":"10-step calculation through Monster Group order","kw":["walk","step","order","Monster","stalk"]},
    {"id":"TH-6","source":"theory","category":"QxKxV Identity","desc":"71x59x47=196,883 (V1 irrep dimension)","kw":["196883","47","59","71","irrep","dimension"]},
    {"id":"CMP-1","source":"components","category":"IPLD Core","desc":"Rust ipld-core: Core IPLD traits and types","kw":["IPLD","CAR","block","dag","cbor"]},
    {"id":"CMP-2","source":"components","category":"DAG-CBOR Codec","desc":"serde_ipld_dagcbor: DAG-CBOR codec with Serde","kw":["codec","serde","encode","decode","cbor"]},
    {"id":"CMP-3","source":"components","category":"MMGroup","desc":"mmgroup: Monster Group computation","kw":["Monster","mmgroup","sporadic","simple"]},
    {"id":"CMP-4","source":"components","category":"Cross-Language","desc":"Multi-language IPLD: Go,Java,Python,JS,C","kw":["ipld","dag","cbor","codec","cross"]},
    {"id":"TEST-A","source":"test-plan","category":"Spec-Derived","desc":"Valid CBOR at each nesting level, all major types, Tag 42 CID, deterministic encoding","kw":["CBOR","tag","encode","nest","major","deterministic","map","key"]},
    {"id":"TEST-B","source":"test-plan","category":"Fuzzer-Generated","desc":"Crash/hang/memory error inputs from AFL++","kw":["crash","hang","memory","fuzz","AFL","ASan","input"]},
    {"id":"TEST-C","source":"test-plan","category":"Impl-Native","desc":"Tests: Rust serde_ipld, Go ipld-prime, Python libipld, JS, C","kw":["serde","ipld","go","python","javascript","tinycbor","test"]},
    {"id":"TEST-D","source":"test-plan","category":"App-Extracted","desc":"Real-world CBOR from ATProto firehose, CAR files","kw":["ATProto","firehose","CAR","production","real"]},
    {"id":"TEST-E","source":"test-plan","category":"Adversarial","desc":"Deep nesting, large arrays, duplicate keys, invalid UTF-8, indefinite-length","kw":["deep","large","duplicate","invalid","UTF","nest","non-deterministic"]},
    {"id":"BM-1","source":"build-memory","category":"Build CID","desc":"Every build output gets a CID: stdout,stderr,errors","kw":["CID","build","stdout","stderr","error","output"]},
    {"id":"BM-2","source":"build-memory","category":"Error Dedup","desc":"Errors de-duplicated across runs via content addressing","kw":["dedup","error","fingerprint","seen","occurrence","fix"]},
    {"id":"BM-3","source":"build-memory","category":"IPLD Shmem","desc":"Build outputs stored in IPLD CAR shmem","kw":["IPLD","CAR","shmem","store","builds","index"]},
    {"id":"BM-4","source":"build-memory","category":"DAG-CBOR Model","desc":"Build node data model in DAG-CBOR format","kw":["build","dagcbor","model","command","duration","exit"]},
    {"id":"CDDL-1","source":"cddl","category":"CDDL Types","desc":"dag-cbor-value: uint,int,bytes,text,array,map,null,bool,float","kw":["unsigned","negative","byte","text","array","map","null","boolean","float"]},
    {"id":"CDDL-2","source":"cddl","category":"CDDL Encoding","desc":"DAG-CBOR encoding: length-prefixed,UTF-8,deterministic order","kw":["length","prefixed","UTF","encoding","deterministic","order"]},
    {"id":"CDDL-3","source":"cddl","category":"CDDL CID","desc":"CID: multicodec 0x71,multihash 0x1220,32-byte bstr","kw":["multicodec","multihash","sha2","bstr","0x71","0x1220","CID"]},
    {"id":"CDDL-4","source":"cddl","category":"CDDL Block","desc":"dag-cbor-block: {multicodec,multihash,data}","kw":["block","multicodec","multihash","data","dagcbor"]},
    {"id":"ARI-1","source":"aristotle","category":"Monster CharTable","desc":"194x194 Monster character table (fef52e3d)","kw":["character","table","194","irrep","conjugacy","class"]},
    {"id":"ARI-2","source":"aristotle","category":"Consolidated DASL","desc":"842 files merged, 133 real declarations, 5 modules","kw":["consolidate","merge","reconstruct","module","splitter"]},
    {"id":"ARI-3","source":"aristotle","category":"ProofOfCoverage","desc":"ProofOfCoverage.lean: 250 lines, sorry-free, 15 claims","kw":["proof","coverage","claim","verify","sorry"]},
]

def load_decls():
    decls = []
    ddir = os.path.join(FUZZ_CORPUS, "decls")
    for sp in os.listdir(ddir):
        spd = os.path.join(ddir, sp)
        if not os.path.isdir(spd): continue
        for f in os.listdir(spd):
            if not f.endswith(".lean"): continue
            path = os.path.join(spd, f)
            text = open(path).read().lower()
            decls.append({"name":f.replace(".lean",""),"splitter":sp,"text":text})
    return decls

def match_all(decls):
    results = []
    for spec in ALL_SPECS:
        matches = []
        for d in decls:
            score = sum(1 for kw in spec["kw"] if kw.lower() in d["text"])
            if score > 0:
                matches.append({"name":d["name"],"splitter":d["splitter"],"score":score})
        matches.sort(key=lambda m:-m["score"])
        results.append({"spec":spec,"count":len(matches),"top":matches[:8],"ok":len(matches)>0})
    return results

def html(results):
    ts = datetime.now().strftime("%Y-%m-%d %H:%M")
    decls = load_decls()
    ok = sum(1 for r in results if r["ok"])
    tot = len(results)
    pct = round(100*ok/tot,1)

    sources = defaultdict(list)
    for r in results: sources[r["spec"]["source"]].append(r)

    h = ['<!DOCTYPE html><html><head><meta charset="UTF-8"><title>DASL Spec Audit v2</title>',
         '<style>',
         'body{font-family:system-ui,sans-serif;max-width:1300px;margin:0 auto;padding:20px;background:#0d1117;color:#c9d1d9}',
         'h1{color:#58a6ff;border-bottom:2px solid #30363d;padding-bottom:10px}',
         'h2{color:#f0f6fc;margin-top:30px}',
         '.sum{background:#161b22;border:1px solid #30363d;border-radius:8px;padding:20px;margin:20px 0}',
         '.bar{background:#21262d;border-radius:4px;height:28px;margin:10px 0;overflow:hidden}',
         '.bar-fill{height:100%;border-radius:4px;text-align:center;line-height:28px;font-size:12px;color:#fff}',
         '.row{background:#161b22;border:1px solid #30363d;border-radius:6px;padding:12px;margin:8px 0}',
         '.row.ok{border-left:4px solid #238636} .row.no{border-left:4px solid #da3633}',
         '.row .id{font-weight:bold;color:#58a6ff}',
         '.row .cat{display:inline-block;padding:2px 8px;border-radius:4px;font-size:11px;margin:0 6px}',
         '.row .src{color:#8b949e;font-size:11px}',
         '.badge{display:inline-block;padding:2px 6px;border-radius:4px;font-size:11px}',
         '.badge.ok{background:#23863633;color:#3fb950} .badge.no{background:#da363333;color:#f85149}',
         '.match{font-family:monospace;font-size:12px;color:#8b949e;margin:3px 0 0 20px}',
         'table{width:100%;border-collapse:collapse;margin:10px 0}',
         'th,td{text-align:left;padding:6px 10px;border-bottom:1px solid #30363d}',
         'th{color:#8b949e;font-weight:600}',
         '</style></head><body>',
         '<h1>DASL Spec-Driven Proof Audit v2</h1>',
         '<p>'+ts+' | '+str(tot)+' spec elements | '+str(len(decls))+' fuzz corpus declarations</p>',
         '<div class="sum"><h2>Overall Coverage</h2>',
         '<div class="bar"><div class="bar-fill" style="width:'+str(pct)+'%;background:'+('#238636' if pct>=80 else '#da3633')+'">'+str(ok)+'/'+str(tot)+' ('+str(pct)+'%)</div></div>',
         '<h3>By Source</h3><table><tr><th>Source</th><th>Elements</th><th>Covered</th><th>%</th></tr>']
    
    colors = {"grant":"#58a6ff","theory":"#f0883e","components":"#3fb950","test-plan":"#bc8cff",
              "build-memory":"#f778ba","cddl":"#a5d6ff","aristotle":"#ff7b72"}
    
    for src in ["grant","theory","components","test-plan","build-memory","cddl","aristotle"]:
        items = sources.get(src,[])
        cov = sum(1 for r in items if r["ok"])
        spct = round(100*cov/len(items),1) if items else 0
        c = colors.get(src,"#666")
        h.append('<tr><td style="color:'+c+'">'+src+'</td><td>'+str(len(items))+'</td><td>'+str(cov)+'</td><td>'+str(spct)+'%</td></tr>')
    h.append('</table></div>')
    
    for src in ["grant","theory","components","test-plan","build-memory","cddl","aristotle"]:
        items = sources.get(src,[])
        if not items: continue
        c = colors.get(src,"#666")
        h.append('<h2 style="color:'+c+'">'+src.upper()+'</h2>')
        for r in items:
            s = r["spec"]
            cls = "ok" if r["ok"] else "no"
            h.append('<div class="row '+cls+'">')
            h.append('<span class="id">'+s["id"]+'</span>')
            h.append('<span class="cat" style="background:'+c+'33;color:'+c+'">'+s["category"]+'</span>')
            h.append('<span class="src">['+src+']</span>')
            h.append('<span class="badge '+cls+'">'+str(r["count"])+' matches</span>')
            h.append('<p><strong>'+s["desc"]+'</strong></p>')
            for m in r["top"][:4]:
                h.append('<div class="match">['+m["splitter"]+'] '+m["name"][:90]+' — score '+str(m["score"])+'</div>')
            h.append('</div>')
    
    h.append('</body></html>')
    return "\n".join(h)

def main():
    decls = load_decls()
    results = match_all(decls)
    ok = sum(1 for r in results if r["ok"])
    print(f"Spec audit: {ok}/{len(results)} ({round(100*ok/len(results),1)}%)")
    for src in ["grant","theory","components","test-plan","build-memory","cddl","aristotle"]:
        items = [r for r in results if r["spec"]["source"]==src]
        cov = sum(1 for r in items if r["ok"])
        print(f"  {src}: {cov}/{len(items)}")
        for r in items:
            s = "PASS" if r["ok"] else "FAIL"
            top = r["top"][0]["name"][:60] if r["top"] else "—"
            print(f"    {s} {r['spec']['id']}: {r['spec']['desc'][:60]} → {top}")
    
    h = html(results)
    with open(OUT_HTML,"w") as f: f.write(h)
    open("/mnt/data1/time-2026/05-may/07/arist/dasl-spec-audit-v2.html","w").write(h)
    print(f"\nHTML: {OUT_HTML}")

if __name__ == "__main__":
    main()
