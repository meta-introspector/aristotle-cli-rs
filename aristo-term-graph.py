#!/usr/bin/env python3
"""Aristotle Term Analysis — frequency graphs from all Aristotle chat/prose output."""
import json, os, sys
from collections import Counter

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

JSON_PATH = "/mnt/data1/aristotle-results/aristo-word-freq.json"
OUT_DIR = "/mnt/data1/aristotle-results/aristo-term-graphs"
os.makedirs(OUT_DIR, exist_ok=True)

with open(JSON_PATH) as f:
    data = json.load(f)

global_freq = data["global_freq"]
per_proj = data["per_project"]

# ── Fig 1: Top 30 global words (horizontal bar) ──
fig, ax = plt.subplots(figsize=(12, 10))
top = list(global_freq.items())[:30]
words, counts = zip(*reversed(top))
colors = plt.cm.viridis(np.linspace(0.2, 0.9, len(words)))
ax.barh(range(len(words)), counts, color=colors)
ax.set_yticks(range(len(words)))
ax.set_yticklabels(words)
ax.set_xlabel("Frequency")
ax.set_title(f"Aristotle Chat Term Frequency — Top 30 (of {data['total_words']} total words across {data['projects']} projects)")
for i, (w, c) in enumerate(reversed(top)):
    ax.text(c + 5, i, str(c), va="center", fontsize=8)
plt.tight_layout()
plt.savefig(os.path.join(OUT_DIR, "top30-global.png"), dpi=150)
plt.close()
print("Saved top30-global.png")

# ── Fig 2: Project comparison heatmap ──
fig, ax = plt.subplots(figsize=(16, 10))
# Top 20 words across projects
all_words_set = set()
for c in per_proj.values():
    all_words_set.update(list(c.keys())[:15])
# Pick top 20 globally that appear in multiple projects
global_20 = [w for w, _ in list(global_freq.items())[:30] 
             if sum(1 for p in per_proj.values() if w in p) >= 2][:20]

matrix = np.zeros((len(per_proj), len(global_20)))
proj_ids = sorted(per_proj.keys())
for i, pid in enumerate(proj_ids):
    for j, word in enumerate(global_20):
        matrix[i, j] = per_proj[pid].get(word, 0)

im = ax.imshow(matrix, aspect="auto", cmap="YlOrRd")
ax.set_xticks(range(len(global_20)))
ax.set_xticklabels(global_20, rotation=45, ha="right", fontsize=8)
ax.set_yticks(range(len(proj_ids)))
ax.set_yticklabels([f"{p[:8]}" for p in proj_ids], fontsize=8)
ax.set_title("Aristotle Word Heatmap — Top Terms × Project")
fig.colorbar(im, ax=ax, label="Frequency")
plt.tight_layout()
plt.savefig(os.path.join(OUT_DIR, "heatmap.png"), dpi=150)
plt.close()
print("Saved heatmap.png")

# ── Fig 3: Category breakdown — what kind of words does Aristotle use? ──
CATEGORIES = {
    "Lean/Formal": {"lean", "proof", "theorem", "lemma", "axiom", "axioms", "propext", "namespace",
                    "mathlib", "lake", "file", "module", "builds", "formal", "formalize", "formalization",
                    "requestproject", "sorry", "verified", "proved", "decree", "true", "map", "fin",
                    "identity", "standard", "type", "def", "calculus", "inductive"},
    "Legal/DAO": {"law", "title", "address", "federal", "statute", "statutes", "njstatute", "njlaw",
                  "billtracking", "bill", "njleg", "solfunmeme", "rullca", "statutory", "submission",
                  "archive", "htm", "securities", "act", "section", "chapter", "citation", "recognition"},
    "Visual/SVG": {"svg", "gallery", "tour", "scene", "comic", "graph", "graphs", "html", "render",
                   "animation", "panel", "panel", "picture", "canvas", "svg", "colour", "bar"},
    "Math/Geometry": {"matrix", "betti", "threshold", "vector", "reduced", "vertex", "graph", "graphs",
                      "omega", "omegavec", "isolated", "index", "moonshine", "number", "identity",
                      "representation", "irrep", "group", "jaccard", "similarity", "corpus", "facts"},
    "Philosophy": {"dao", "chapter", "chapters", "cosmos", "people", "world", "text", "nature",
                   "being", "sage", "harmony", "virtue", "heaven"},
    "Meta/Process": {"project", "task", "file", "changes", "summary", "existing", "source", "full",
                     "complete", "added", "ready", "files", "submission", "successfully", "work",
                     "content", "list", "entry", "aristo", "aristotle", "harmonic"},
}

cat_counts = Counter()
for word, count in global_freq.items():
    for cat, words in CATEGORIES.items():
        if word in words:
            cat_counts[cat] += count

fig, ax = plt.subplots(figsize=(10, 6))
cats, cvals = zip(*cat_counts.most_common())
colors = ["#e74c3c", "#3498db", "#2ecc71", "#f39c12", "#9b59b6", "#1abc9c"]
ax.pie(cvals, labels=cats, autopct="%1.1f%%", colors=colors[:len(cats)], startangle=140)
ax.set_title("Aristotle Word Categories")
plt.tight_layout()
plt.savefig(os.path.join(OUT_DIR, "categories.png"), dpi=150)
plt.close()
print("Saved categories.png")

# ── Fig 4: Per-project unique word diversity ──
fig, ax = plt.subplots(figsize=(12, 5))
proj_total = {}
proj_unique = {}
for pid in sorted(per_proj.keys()):
    proj_total[pid] = sum(per_proj[pid].values())
    proj_unique[pid] = len(per_proj[pid])

x = np.arange(len(proj_total))
width = 0.35
ax.bar(x - width/2, list(proj_unique.values()), width, label="Unique words", color="#3498db")
ax.bar(x + width/2, list(proj_total.values()), width, label="Total words", color="#e74c3c", alpha=0.7)
ax.set_xticks(x)
ax.set_xticklabels([p[:8] for p in proj_total.keys()], rotation=45, ha="right", fontsize=8)
ax.set_ylabel("Word count")
ax.set_title(f"Aristotle Vocabulary Diversity — {len(proj_total)} Projects")
ax.legend()
plt.tight_layout()
plt.savefig(os.path.join(OUT_DIR, "diversity.png"), dpi=150)
plt.close()
print("Saved diversity.png")

# ── Fig 5: Word cloud via frequency ──
try:
    from wordcloud import WordCloud
    wc = WordCloud(width=1200, height=600, background_color="white",
                   max_words=150, colormap="plasma")
    wc.generate_from_frequencies(global_freq)
    wc.to_file(os.path.join(OUT_DIR, "wordcloud.png"))
    print("Saved wordcloud.png")
except ImportError:
    print("wordcloud not installed, skipping")

print(f"\nAll graphs saved to {OUT_DIR}/")
for f in sorted(os.listdir(OUT_DIR)):
    print(f"  {f}")
