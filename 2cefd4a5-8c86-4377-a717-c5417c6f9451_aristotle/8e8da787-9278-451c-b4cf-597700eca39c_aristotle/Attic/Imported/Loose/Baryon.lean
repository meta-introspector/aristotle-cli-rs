import numpy as np
from numba import njit
import matplotlib.pyplot as plt
import time
import math

# ============================================================
# BARYON MAPPING (unchanged)
# ============================================================
baryon_map = {
    0: ("Neutron (n)", -0.5, 1.0, 0, 0, '#00aaff'),
    1: ("Σ⁻", -1.0, 0.0, -1, -1, '#ff00aa'),
    2: ("Ξ⁻", -0.5, -1.0, -2, -1, '#99004c'),
    3: ("Ξ⁰", 0.5, -1.0, -2, 0, '#cc0066'),
    4: ("Σ⁺", 1.0, 0.0, -1, 1, '#ff66b2'),
    5: ("Proton (p)", 0.5, 1.0, 0, 1, '#ff3385'),
    6: ("Σ⁰", 0.0, 0.0, -1, 0, '#ffcc00'),
    7: ("Λ", 0.0, 0.0, -1, 0, '#00ffcc')
}

# ============================================================
# NUMBA-COMPATIBLE HELPERS (matching Lean 4)
# ============================================================
@njit
def two_adic_valuation(n):
    if n == 0:
        return 0
    val = 0
    while n % 2 == 0:
        n //= 2
        val += 1
    return val

@njit
def is_prime(n):
    if n < 2:
        return False
    if n == 2 or n == 3:
        return True
    if n % 2 == 0 or n % 3 == 0:
        return False
    i = 5
    while i * i <= n:
        if n % i == 0 or n % (i + 2) == 0:
            return False
        i += 6
    return True

@njit
def compute_trajectory(n):
    current = n
    net_sum = 0
    total_steps = 0
    while current > 1:
        if current % 2 == 0:
            current = current // 2
            net_sum -= 1
        else:
            current = 3 * current + 1
            net_sum += 1
        total_steps += 1
    phase = net_sum % 6
    if phase < 0:
        phase += 6
    drop_trigger = two_adic_valuation(n) >= 2
    isospin_tag = is_prime(n)
    return phase, drop_trigger, isospin_tag

@njit
def generate_ensemble_streaming(limit):
    counts = np.zeros(8, dtype=np.int64)
    for i in range(1, limit + 1):
        phase, drop, iso = compute_trajectory(i)
        if drop:
            if iso:
                counts[6] += 1   # Σ⁰
            else:
                counts[7] += 1   # Λ
        else:
            counts[phase] += 1
    return counts

# ============================================================
# EXECUTION (N = 1_000_000_000)
# ============================================================
limit = 1_000_000_000
print(f"Firing engine for N = 1 to {limit:,} (Lean-aligned invariants)...")
start_time = time.time()
counts = generate_ensemble_streaming(limit)
exec_time = time.time() - start_time
print(f"Engine completed in {exec_time:.2f} seconds.\n")

total = limit
print("--- THERMODYNAMIC DISTRIBUTION (N = 1 000 000 000) ---")
for b_id in range(8):
    name = baryon_map[b_id][0]
    count = counts[b_id]
    pct = (count / total) * 100
    print(f"{name:>12}: {count:>12,} | {pct:.6f}%")

central = counts[6] + counts[7]
print(f"\nCentral population (Σ⁰ + Λ): {central:,} ({100 * central / total:.6f}%)")

# ============================================================
# DARK-THEME VISUALIZATION
# ============================================================
plt.style.use('dark_background')
fig = plt.figure(figsize=(18, 8), facecolor='#0a0a0a')

# Left: Production Ratios
ax1 = fig.add_subplot(121, facecolor='#0a0a0a')
labels = [baryon_map[i][0] for i in range(8)]
values = [counts[i] for i in range(8)]
colors = [baryon_map[i][5] for i in range(8)]

bars = ax1.bar(labels, values, color=colors, edgecolor='white', linewidth=1.0)
ax1.set_title(f'Baryon Production Ratios (N={limit:,}) – Lean 4 Invariants', color='white', fontsize=14, pad=20)
ax1.set_ylabel('Crystallization Count', color='white', fontsize=11)
ax1.tick_params(colors='white')
ax1.spines['top'].set_visible(False)
ax1.spines['right'].set_visible(False)
ax1.spines['bottom'].set_color('white')
ax1.spines['left'].set_color('white')

for bar in bars:
    yval = bar.get_height()
    pct = (yval / total) * 100
    ax1.text(bar.get_x() + bar.get_width()/2, yval + total*0.008,
             f'{pct:.2f}%', ha='center', va='bottom', color='white', fontsize=9, fontweight='bold')

# Right: SU(3) Topological Projection
ax2 = fig.add_subplot(122, facecolor='#0a0a0a')

hex_I3 = [-0.5, 0.5, 1.0, 0.5, -0.5, -1.0, -0.5]
hex_Y  = [1.0, 1.0, 0.0, -1.0, -1.0, 0.0, 1.0]
ax2.plot(hex_I3, hex_Y, color='#444444', linewidth=2.0, zorder=1)
ax2.axhline(0, color='#333333', linestyle='--', linewidth=0.8, zorder=1)
ax2.axvline(0, color='#333333', linestyle='--', linewidth=0.8, zorder=1)

for b_id in range(8):
    name, i3, y, s, q, color = baryon_map[b_id]
    count = counts[b_id]
    bubble_size = (count / total) * 12000

    if b_id == 6:  # Σ⁰
        ax2.scatter(i3 - 0.06, y, s=bubble_size, color=color, edgecolor='white', linewidth=1.5, zorder=5, alpha=0.85)
        ax2.text(i3 - 0.18, y + 0.12, name, color=color, fontsize=12, fontweight='bold')
    elif b_id == 7:  # Λ
        ax2.scatter(i3 + 0.06, y, s=bubble_size, color=color, edgecolor='white', linewidth=1.5, zorder=5, alpha=0.85)
        ax2.text(i3 + 0.12, y + 0.12, name, color=color, fontsize=12, fontweight='bold')
    else:
        ax2.scatter(i3, y, s=bubble_size, color=color, edgecolor='white', linewidth=1.5, zorder=5)
        ax2.text(i3, y + 0.12, name, color=color, fontsize=11, fontweight='bold')

ax2.set_xlim(-1.6, 1.6)
ax2.set_ylim(-1.6, 1.6)
ax2.set_aspect('equal')
ax2.set_title('SU(3) Topological Projection (Lean 4 Invariants)', color='white', fontsize=14, pad=20)
ax2.set_xlabel('Isospin (I₃)', color='white', fontsize=11)
ax2.set_ylabel('Hypercharge (Y = S + 1)', color='white', fontsize=11)
ax2.tick_params(colors='white')
ax2.spines['top'].set_visible(False)
ax2.spines['right'].set_visible(False)
ax2.spines['bottom'].set_color('white')
ax2.spines['left'].set_color('white')

plt.tight_layout()
plt.savefig('baryon_lean_aligned_projection.png', dpi=300, facecolor='#0a0a0a', bbox_inches='tight')
plt.show()

print("\nFigure saved as 'baryon_lean_aligned_projection.png'")
