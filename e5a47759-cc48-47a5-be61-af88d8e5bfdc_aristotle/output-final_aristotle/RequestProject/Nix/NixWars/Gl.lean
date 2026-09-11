/-!
# The WebGL renderer the 3D pages share

One dependency-free voxel renderer, emitted as a JavaScript string and inlined
into every 3D page this development writes, so each page stays a single file
with no network access:

* `Gl.matrixJs` — 4×4 matrix and vector arithmetic;
* `Gl.rendererJs` — a WebGL renderer that draws a list of cubes and a list of
  line segments from one interleaved buffer, with a fixed sixteen-colour
  palette and per-face shading;
* `Gl.orbitJs` — pointer and touch control of the camera: one finger orbits,
  two fingers pinch to zoom, the wheel zooms, and `touch-action: none` keeps
  the browser from stealing the gesture;
* `Gl.mobileCss` — the responsive stylesheet, laid out around the touch-target
  size that `Mobile.lean` proves the pad respects.

Nothing here computes any game state: the state comes from Lean-emitted tables
and the models in `Scene3D.lean` and `Monster/Flight.lean`.
-/

namespace NixWars

namespace Gl

/-- Vector and matrix arithmetic. -/
def matrixJs : String := r##"
function m4mul(a, b) {
  const o = new Float32Array(16);
  for (let i = 0; i < 4; i++) for (let j = 0; j < 4; j++) {
    let s = 0;
    for (let k = 0; k < 4; k++) s += a[k * 4 + j] * b[i * 4 + k];
    o[i * 4 + j] = s;
  }
  return o;
}
function m4persp(fovy, aspect, near, far) {
  const t = 1 / Math.tan(fovy / 2), o = new Float32Array(16);
  o[0] = t / aspect; o[5] = t; o[10] = (far + near) / (near - far);
  o[11] = -1; o[14] = 2 * far * near / (near - far);
  return o;
}
function v3sub(a, b) { return [a[0] - b[0], a[1] - b[1], a[2] - b[2]]; }
function v3cross(a, b) {
  return [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
}
function v3norm(a) {
  const l = Math.hypot(a[0], a[1], a[2]) || 1;
  return [a[0] / l, a[1] / l, a[2] / l];
}
function v3dot(a, b) { return a[0] * b[0] + a[1] * b[1] + a[2] * b[2]; }
function m4look(eye, ctr, up) {
  const f = v3norm(v3sub(ctr, eye)), s = v3norm(v3cross(f, up)), u = v3cross(s, f);
  return new Float32Array([
    s[0], u[0], -f[0], 0,
    s[1], u[1], -f[1], 0,
    s[2], u[2], -f[2], 0,
    -v3dot(s, eye), -v3dot(u, eye), v3dot(f, eye), 1]);
}
// the camera is an orbit: yaw, pitch and distance about a target
function camEye(cam) {
  const cp = Math.cos(cam.pitch), sp = Math.sin(cam.pitch);
  return [cam.target[0] + cam.dist * cp * Math.sin(cam.yaw),
          cam.target[1] + cam.dist * sp,
          cam.target[2] + cam.dist * cp * Math.cos(cam.yaw)];
}
"##

/-- The renderer. -/
def rendererJs : String := r##"
const PALETTE = [
  [0.49, 0.91, 0.53], [0.47, 0.75, 1.00], [1.00, 0.65, 0.34], [1.00, 0.48, 0.45],
  [0.76, 0.61, 1.00], [0.49, 0.98, 1.00], [1.00, 0.83, 0.47], [0.80, 0.85, 0.90],
  [0.35, 0.55, 0.75], [1.00, 0.30, 0.55], [0.30, 0.85, 0.70], [0.95, 0.95, 0.55],
  [0.60, 0.60, 0.65], [0.20, 0.40, 0.60], [0.90, 0.40, 0.90], [0.25, 0.95, 0.40]];
// unit cube: six faces, two triangles each, with a shade per face
const FACES = [
  { n: [0, 1, 0], s: 1.00, v: [[0,1,0],[0,1,1],[1,1,1],[0,1,0],[1,1,1],[1,1,0]] },
  { n: [0,-1, 0], s: 0.42, v: [[0,0,0],[1,0,0],[1,0,1],[0,0,0],[1,0,1],[0,0,1]] },
  { n: [1, 0, 0], s: 0.80, v: [[1,0,0],[1,1,0],[1,1,1],[1,0,0],[1,1,1],[1,0,1]] },
  { n: [-1,0, 0], s: 0.60, v: [[0,0,0],[0,0,1],[0,1,1],[0,0,0],[0,1,1],[0,1,0]] },
  { n: [0, 0, 1], s: 0.72, v: [[0,0,1],[1,0,1],[1,1,1],[0,0,1],[1,1,1],[0,1,1]] },
  { n: [0, 0,-1], s: 0.54, v: [[0,0,0],[0,1,0],[1,1,0],[0,0,0],[1,1,0],[1,0,0]] }];

function makeGL(canvas) {
  const gl = canvas.getContext("webgl", { antialias: true, alpha: false })
          || canvas.getContext("experimental-webgl");
  if (!gl) return null;
  const compile = (type, src) => {
    const sh = gl.createShader(type);
    gl.shaderSource(sh, src); gl.compileShader(sh);
    if (!gl.getShaderParameter(sh, gl.COMPILE_STATUS)) throw new Error(gl.getShaderInfoLog(sh));
    return sh;
  };
  const prog = gl.createProgram();
  gl.attachShader(prog, compile(gl.VERTEX_SHADER,
    "attribute vec3 aPos; attribute vec3 aCol; uniform mat4 uMVP; varying vec3 vCol;" +
    "void main(){ gl_Position = uMVP * vec4(aPos, 1.0); vCol = aCol; }"));
  gl.attachShader(prog, compile(gl.FRAGMENT_SHADER,
    "precision mediump float; varying vec3 vCol;" +
    "void main(){ gl_FragColor = vec4(vCol, 1.0); }"));
  gl.linkProgram(prog);
  if (!gl.getProgramParameter(prog, gl.LINK_STATUS)) throw new Error(gl.getProgramInfoLog(prog));
  gl.useProgram(prog);
  const aPos = gl.getAttribLocation(prog, "aPos");
  const aCol = gl.getAttribLocation(prog, "aCol");
  const uMVP = gl.getUniformLocation(prog, "uMVP");
  const buf = gl.createBuffer();
  gl.enable(gl.DEPTH_TEST);

  function fit() {
    const dpr = Math.min(window.devicePixelRatio || 1, 2);
    const w = Math.max(1, Math.round(canvas.clientWidth * dpr));
    const h = Math.max(1, Math.round(canvas.clientHeight * dpr));
    if (canvas.width !== w || canvas.height !== h) { canvas.width = w; canvas.height = h; }
    gl.viewport(0, 0, canvas.width, canvas.height);
    return canvas.width / Math.max(1, canvas.height);
  }

  // cubes: {x,y,z,c,size?,rgb?}   lines: {a:[x,y,z], b:[x,y,z], c}
  function draw(cubes, lines, cam, clear) {
    const aspect = fit();
    const bg = clear || [0.02, 0.03, 0.06];
    gl.clearColor(bg[0], bg[1], bg[2], 1);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    const mvp = m4mul(m4persp(cam.fov || 1.0, aspect, 0.1, 4000),
                      m4look(camEye(cam), cam.target, [0, 1, 0]));
    gl.uniformMatrix4fv(uMVP, false, mvp);
    // triangles
    const tri = new Float32Array(cubes.length * 36 * 6);
    let p = 0;
    for (const cu of cubes) {
      const rgb = cu.rgb || PALETTE[cu.c % PALETTE.length];
      const sz = cu.size === undefined ? 1 : cu.size;
      for (const f of FACES) for (const v of f.v) {
        tri[p++] = cu.x + v[0] * sz; tri[p++] = cu.y + v[1] * sz; tri[p++] = cu.z + v[2] * sz;
        tri[p++] = rgb[0] * f.s; tri[p++] = rgb[1] * f.s; tri[p++] = rgb[2] * f.s;
      }
    }
    gl.bindBuffer(gl.ARRAY_BUFFER, buf);
    gl.enableVertexAttribArray(aPos); gl.enableVertexAttribArray(aCol);
    gl.vertexAttribPointer(aPos, 3, gl.FLOAT, false, 24, 0);
    gl.vertexAttribPointer(aCol, 3, gl.FLOAT, false, 24, 12);
    if (cubes.length) {
      gl.bufferData(gl.ARRAY_BUFFER, tri, gl.DYNAMIC_DRAW);
      gl.drawArrays(gl.TRIANGLES, 0, cubes.length * 36);
    }
    if (lines && lines.length) {
      const ln = new Float32Array(lines.length * 2 * 6);
      let q = 0;
      for (const l of lines) {
        const rgb = l.rgb || PALETTE[(l.c || 8) % PALETTE.length];
        for (const v of [l.a, l.b]) {
          ln[q++] = v[0]; ln[q++] = v[1]; ln[q++] = v[2];
          ln[q++] = rgb[0]; ln[q++] = rgb[1]; ln[q++] = rgb[2];
        }
      }
      gl.bufferData(gl.ARRAY_BUFFER, ln, gl.DYNAMIC_DRAW);
      gl.drawArrays(gl.LINES, 0, lines.length * 2);
    }
    return cubes.length;
  }
  return { gl, draw, fit };
}

// the twelve edges of a box, as line segments
function boxLines(x0, y0, z0, x1, y1, z1, c) {
  const P = [[x0,y0,z0],[x1,y0,z0],[x1,y0,z1],[x0,y0,z1],
             [x0,y1,z0],[x1,y1,z0],[x1,y1,z1],[x0,y1,z1]];
  const E = [[0,1],[1,2],[2,3],[3,0],[4,5],[5,6],[6,7],[7,4],[0,4],[1,5],[2,6],[3,7]];
  return E.map(e => ({ a: P[e[0]], b: P[e[1]], c: c }));
}
"##

/-- Camera control by pointer and touch. -/
def orbitJs : String := r##"
function attachOrbit(canvas, cam, redraw) {
  const pts = new Map();
  let last = null, pinch = 0;
  const dist2 = () => {
    const v = [...pts.values()];
    return Math.hypot(v[0].x - v[1].x, v[0].y - v[1].y);
  };
  canvas.style.touchAction = "none";
  canvas.addEventListener("pointerdown", (e) => {
    canvas.setPointerCapture(e.pointerId);
    pts.set(e.pointerId, { x: e.clientX, y: e.clientY });
    if (pts.size === 2) pinch = dist2();
    last = { x: e.clientX, y: e.clientY };
  });
  canvas.addEventListener("pointermove", (e) => {
    if (!pts.has(e.pointerId)) return;
    pts.set(e.pointerId, { x: e.clientX, y: e.clientY });
    if (pts.size >= 2) {
      const d = dist2();
      if (pinch > 0) {
        cam.dist = Math.max(cam.minDist || 2, Math.min(cam.maxDist || 400, cam.dist * pinch / d));
      }
      pinch = d;
    } else if (last) {
      cam.yaw -= (e.clientX - last.x) * 0.008;
      cam.pitch = Math.max(-1.45, Math.min(1.45, cam.pitch + (e.clientY - last.y) * 0.008));
      last = { x: e.clientX, y: e.clientY };
    }
    redraw();
    e.preventDefault();
  });
  const up = (e) => {
    pts.delete(e.pointerId);
    if (pts.size < 2) pinch = 0;
    if (pts.size === 0) last = null;
  };
  canvas.addEventListener("pointerup", up);
  canvas.addEventListener("pointercancel", up);
  canvas.addEventListener("wheel", (e) => {
    cam.dist = Math.max(cam.minDist || 2,
      Math.min(cam.maxDist || 400, cam.dist * (e.deltaY > 0 ? 1.1 : 0.9)));
    redraw();
    e.preventDefault();
  }, { passive: false });
  window.addEventListener("resize", redraw);
  window.addEventListener("orientationchange", redraw);
}
"##

/-- The responsive stylesheet the 3D pages share. -/
def mobileCss : String := r##"
:root { color-scheme: dark; --bg:#04070d; --ink:#cfe4f2; --dim:#6d8ba3; --line:#17293c;
  --cyan:#7cf9ff; --green:#7ee787; --amber:#ffd479; --red:#ff7b72; }
* { box-sizing: border-box; -webkit-tap-highlight-color: transparent; }
html, body { margin:0; padding:0; background:var(--bg); color:var(--ink);
  font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  overscroll-behavior: none; }
h1 { font-size: 1rem; letter-spacing:.28em; color:var(--cyan); margin:0; font-weight:600; }
h2 { font-size:.86rem; letter-spacing:.16em; color:var(--green); margin:.9rem 0 .35rem; }
a { color: var(--cyan); }
#stage { position:relative; width:100%; height:56vh; min-height:240px; }
#view { width:100%; height:100%; display:block; background:#04070d; touch-action:none; }
.hud { position:absolute; top:.5rem; left:.6rem; font-size:.72rem; line-height:1.45;
  color:var(--ink); text-shadow:0 0 6px #000; pointer-events:none; }
.hud b { color: var(--amber); font-weight:600; }
.wrap { padding:.6rem .7rem 2rem; max-width:60rem; margin:0 auto; }
.pad { display:grid; grid-template-columns:repeat(3, 1fr); gap:8px; margin:.6rem 0; }
.pad button, .row button { min-width:96px; min-height:64px; font:inherit; font-size:.78rem;
  letter-spacing:.08em; color:var(--ink); background:#0e1a2b; border:1px solid var(--line);
  border-radius:8px; padding:.4rem; cursor:pointer; touch-action:manipulation; }
.pad button:active, .row button:active { background:#1b3350; }
.row { display:flex; flex-wrap:wrap; gap:8px; align-items:center; margin:.5rem 0; }
.row button { min-height:44px; min-width:44px; padding:.35rem .7rem; }
select, input[type=range] { font:inherit; background:#0e1a2b; color:var(--ink);
  border:1px solid var(--line); border-radius:6px; min-height:44px; padding:0 .4rem; }
input[type=range] { flex:1 1 12rem; }
table { border-collapse:collapse; width:100%; font-size:.72rem; }
th, td { border:1px solid var(--line); padding:.2rem .35rem; text-align:right; }
th { color:var(--cyan); font-weight:600; }
td.l, th.l { text-align:left; }
.small { font-size:.7rem; color:var(--dim); line-height:1.5; }
pre { white-space:pre-wrap; font-size:.68rem; color:var(--dim); margin:.3rem 0; }
.ok { color:var(--green); } .bad { color:var(--red); }
@media (min-width: 780px) { #stage { height:64vh; } .pad { max-width:22rem; } }
"##

/-- The small stylesheet the older, two-dimensional pages carry so they read on
a phone: nothing is wider than the screen, tap targets are thumb-sized, and the
text does not get resized behind the page's back. It is appended to a page's
own `<style>` block, so it only overrides what it names. -/
def responsiveCss : String := r##"
/* --- mobile ---------------------------------------------------------- */
* { -webkit-tap-highlight-color: transparent; }
html { -webkit-text-size-adjust: 100%; }
img, svg, canvas, video, table { max-width: 100%; }
canvas, svg { height: auto; }
button, select, input { touch-action: manipulation; }
@media (max-width: 700px) {
  body { padding-left: 10px; padding-right: 10px; }
  button, select, input[type=button], input[type=submit] { min-height: 44px; }
  h1 { font-size: 16px; letter-spacing: 0.16em; }
  h2 { font-size: 14px; }
  table { display: block; overflow-x: auto; }
}
"##

end Gl

end NixWars
