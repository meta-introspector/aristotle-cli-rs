/*
 * hesper-studio — gif.js
 *
 * A dependency-free animated-GIF89a encoder.
 *
 *   HesperGIF.encode([{data: RGBA Uint8ClampedArray}, ...], {
 *     width, height, delayMs, loop, dither, maxColors
 *   })  ->  Uint8Array
 *
 * Colour reduction is median-cut (per clip, one shared global palette so the
 * file stays small and free of inter-frame flicker), optionally with
 * Floyd–Steinberg dithering.  Compression is textbook GIF-LZW with
 * variable code width, dictionary reset and 255-byte sub-blocks.
 */
(function (root, factory) {
  const mod = factory();
  root.HesperGIF = mod;
  if (typeof module === 'object' && module.exports) module.exports = mod;
})(typeof self !== 'undefined' ? self : globalThis, function () {
  'use strict';

  // -------------------------------------------------------------- bit sink

  function ByteSink() { this.buf = new Uint8Array(1 << 16); this.len = 0; }
  ByteSink.prototype.ensure = function (extra) {
    if (this.len + extra <= this.buf.length) return;
    let cap = this.buf.length;
    while (cap < this.len + extra) cap *= 2;
    const nb = new Uint8Array(cap);
    nb.set(this.buf.subarray(0, this.len));
    this.buf = nb;
  };
  ByteSink.prototype.byte = function (b) { this.ensure(1); this.buf[this.len++] = b & 0xff; };
  ByteSink.prototype.bytes = function (arr) { this.ensure(arr.length); this.buf.set(arr, this.len); this.len += arr.length; };
  ByteSink.prototype.str = function (s) { for (let i = 0; i < s.length; i++) this.byte(s.charCodeAt(i)); };
  ByteSink.prototype.u16 = function (v) { this.byte(v & 0xff); this.byte((v >> 8) & 0xff); };
  ByteSink.prototype.done = function () { return this.buf.slice(0, this.len); };

  // ------------------------------------------------------------ median cut

  /** Build a palette of at most `maxColors` colours for the given frames. */
  function medianCutPalette(frames, maxColors) {
    // 5-bit histogram keeps the working set bounded regardless of frame size
    const hist = new Map();
    for (const f of frames) {
      const d = f.data;
      for (let i = 0; i < d.length; i += 4) {
        const key = ((d[i] >> 3) << 10) | ((d[i + 1] >> 3) << 5) | (d[i + 2] >> 3);
        const e = hist.get(key);
        if (e) { e[0] += d[i]; e[1] += d[i + 1]; e[2] += d[i + 2]; e[3]++; }
        else hist.set(key, [d[i], d[i + 1], d[i + 2], 1]);
      }
    }
    const colors = [];
    hist.forEach(function (e) { colors.push([e[0] / e[3], e[1] / e[3], e[2] / e[3], e[3]]); });
    if (colors.length <= maxColors) {
      return colors.map(function (c) { return [Math.round(c[0]), Math.round(c[1]), Math.round(c[2])]; });
    }
    let boxes = [colors];
    while (boxes.length < maxColors) {
      // split the box with the largest weighted extent
      let bi = -1, best = -1;
      for (let i = 0; i < boxes.length; i++) {
        const b = boxes[i];
        if (b.length < 2) continue;
        const ext = boxExtent(b);
        const score = ext.range * Math.log(1 + boxWeight(b));
        if (score > best) { best = score; bi = i; }
      }
      if (bi < 0) break;
      const b = boxes[bi];
      const ax = boxExtent(b).axis;
      b.sort(function (p, q) { return p[ax] - q[ax]; });
      // split at the weighted median
      const total = boxWeight(b);
      let acc = 0, cut = 1;
      for (let i = 0; i < b.length; i++) { acc += b[i][3]; if (acc >= total / 2) { cut = Math.max(1, Math.min(b.length - 1, i)); break; } }
      boxes.splice(bi, 1, b.slice(0, cut), b.slice(cut));
    }
    return boxes.map(function (b) {
      let r = 0, g = 0, bl = 0, w = 0;
      for (const c of b) { r += c[0] * c[3]; g += c[1] * c[3]; bl += c[2] * c[3]; w += c[3]; }
      return w ? [Math.round(r / w), Math.round(g / w), Math.round(bl / w)] : [0, 0, 0];
    });
  }

  function boxWeight(b) { let w = 0; for (const c of b) w += c[3]; return w; }
  function boxExtent(b) {
    let lo = [255, 255, 255], hi = [0, 0, 0];
    for (const c of b) for (let k = 0; k < 3; k++) { if (c[k] < lo[k]) lo[k] = c[k]; if (c[k] > hi[k]) hi[k] = c[k]; }
    let axis = 0, range = -1;
    for (let k = 0; k < 3; k++) { const r = hi[k] - lo[k]; if (r > range) { range = r; axis = k; } }
    return { axis: axis, range: range };
  }

  // ------------------------------------------------------------ quantising

  function PaletteIndex(palette) {
    this.pal = palette;
    this.cache = new Int16Array(32768).fill(-1);
  }
  PaletteIndex.prototype.nearest = function (r, g, b) {
    const key = ((r >> 3) << 10) | ((g >> 3) << 5) | (b >> 3);
    const c = this.cache[key];
    if (c >= 0) return c;
    let best = 0, bd = Infinity;
    for (let i = 0; i < this.pal.length; i++) {
      const p = this.pal[i];
      const dr = r - p[0], dg = g - p[1], db = b - p[2];
      const d = dr * dr * 0.299 + dg * dg * 0.587 + db * db * 0.114;
      if (d < bd) { bd = d; best = i; }
    }
    this.cache[key] = best;
    return best;
  };

  function quantizeFrame(data, w, h, index, dither) {
    const out = new Uint8Array(w * h);
    if (!dither) {
      for (let i = 0, p = 0; i < data.length; i += 4, p++) {
        out[p] = index.nearest(data[i], data[i + 1], data[i + 2]);
      }
      return out;
    }
    // Floyd–Steinberg on a float working copy
    const buf = new Float32Array(w * h * 3);
    for (let i = 0, p = 0; i < data.length; i += 4, p += 3) {
      buf[p] = data[i]; buf[p + 1] = data[i + 1]; buf[p + 2] = data[i + 2];
    }
    const clamp = function (v) { return v < 0 ? 0 : v > 255 ? 255 : v; };
    for (let y = 0; y < h; y++) {
      for (let x = 0; x < w; x++) {
        const p = (y * w + x) * 3;
        const r = clamp(buf[p]), g = clamp(buf[p + 1]), b = clamp(buf[p + 2]);
        const ci = index.nearest(Math.round(r), Math.round(g), Math.round(b));
        out[y * w + x] = ci;
        const pc = index.pal[ci];
        const er = r - pc[0], eg = g - pc[1], eb = b - pc[2];
        const push = function (xx, yy, f) {
          if (xx < 0 || xx >= w || yy < 0 || yy >= h) return;
          const q = (yy * w + xx) * 3;
          buf[q] += er * f; buf[q + 1] += eg * f; buf[q + 2] += eb * f;
        };
        push(x + 1, y, 7 / 16); push(x - 1, y + 1, 3 / 16);
        push(x, y + 1, 5 / 16); push(x + 1, y + 1, 1 / 16);
      }
    }
    return out;
  }

  // ------------------------------------------------------------------ LZW

  function lzwEncode(indices, minCodeSize, sink) {
    const clearCode = 1 << minCodeSize;
    const eoiCode = clearCode + 1;
    let codeSize = minCodeSize + 1;
    let next = clearCode + 2;
    let dict = new Map();

    // bit accumulator, LSB first, flushed into 255-byte sub-blocks
    let acc = 0, nbits = 0;
    let block = [];
    function flushBlock() {
      if (!block.length) return;
      sink.byte(block.length);
      sink.bytes(Uint8Array.from(block));
      block = [];
    }
    function emit(code) {
      acc |= code << nbits;
      nbits += codeSize;
      while (nbits >= 8) {
        block.push(acc & 0xff);
        acc >>>= 8; nbits -= 8;
        if (block.length === 255) flushBlock();
      }
    }

    emit(clearCode);
    let prefix = indices.length ? indices[0] : -1;
    for (let i = 1; i < indices.length; i++) {
      const k = indices[i];
      const key = prefix * 4096 + k;
      const found = dict.get(key);
      if (found !== undefined) { prefix = found; continue; }
      emit(prefix);
      if (next < 4096) {
        dict.set(key, next);
        if (next === (1 << codeSize) && codeSize < 12) codeSize++;
        next++;
      }
      if (next >= 4096) {
        emit(clearCode);
        dict = new Map();
        codeSize = minCodeSize + 1;
        next = clearCode + 2;
      }
      prefix = k;
    }
    if (prefix >= 0) emit(prefix);
    emit(eoiCode);
    // flush remaining bits
    while (nbits > 0) {
      block.push(acc & 0xff);
      acc >>>= 8; nbits -= 8;
      if (block.length === 255) flushBlock();
    }
    flushBlock();
    sink.byte(0); // block terminator
  }

  // -------------------------------------------------------------- encoder

  /** Capacity, in bytes, of a clip carrying one bit per pixel (see `stego`). */
  function stegoCapacity(width, height, frameCount) {
    return Math.floor(width * height * frameCount / 8);
  }

  /**
   * frames: [{data: Uint8ClampedArray|Uint8Array RGBA}] all of the same size
   * opts:   {width, height, delayMs (or fps), loop=0, dither=true, maxColors=256,
   *          stego: Uint8Array}
   *
   * With `stego`, the colour table is written in pairs of identical entries and
   * the low bit of each pixel's *index* carries one bit of the message.  The
   * decoded picture is bit-for-bit the picture that would have been written
   * without it — the message costs half the palette, not one pixel of quality.
   */
  function encode(frames, opts) {
    opts = opts || {};
    if (!frames.length) throw new Error('gif: no frames');
    const w = opts.width, h = opts.height;
    if (!w || !h) throw new Error('gif: width/height required');
    const delayCs = Math.max(2, Math.round((opts.delayMs !== undefined ? opts.delayMs : 1000 / (opts.fps || 25)) / 10));
    const stego = opts.stego ? new Uint8Array(opts.stego) : null;
    const maxColors = Math.min(stego ? 128 : 256, Math.max(2, opts.maxColors || 256));
    const dither = opts.dither !== false;

    let palette = medianCutPalette(frames, maxColors);
    while (palette.length < 2) palette.push([0, 0, 0]);
    const basePalette = palette;
    const index0 = new PaletteIndex(basePalette);
    let stegoBits = null;
    if (stego) {
      if (stego.length * 8 > w * h * frames.length) {
        throw new Error('gif: the message needs ' + (stego.length * 8) + ' pixels, the clip has ' + (w * h * frames.length));
      }
      stegoBits = new Uint8Array(stego.length * 8);
      for (let i = 0; i < stego.length; i++) {
        for (let b = 0; b < 8; b++) stegoBits[i * 8 + b] = (stego[i] >> (7 - b)) & 1;
      }
      palette = [];
      for (const c of basePalette) { palette.push(c.slice()); palette.push(c.slice()); }
    }
    let bits = 1;
    while ((1 << bits) < palette.length) bits++;
    const tableSize = 1 << bits;   // GIF colour tables are a power of two
    const index = stego ? index0 : new PaletteIndex(palette);
    let stegoAt = 0;

    const s = new ByteSink();
    s.str('GIF89a');
    s.u16(w); s.u16(h);
    s.byte(0x80 | ((bits - 1) & 7));   // global colour table, 2^bits entries
    s.byte(0);                          // background colour index
    s.byte(0);                          // pixel aspect ratio
    for (let i = 0; i < tableSize; i++) {
      const c = palette[i] || [0, 0, 0];
      s.byte(c[0]); s.byte(c[1]); s.byte(c[2]);
    }
    // Netscape looping extension
    if (frames.length > 1) {
      s.byte(0x21); s.byte(0xff); s.byte(11);
      s.str('NETSCAPE2.0');
      s.byte(3); s.byte(1); s.u16(opts.loop === undefined ? 0 : opts.loop);
      s.byte(0);
    }
    for (const f of frames) {
      // graphic control extension (delay, no transparency, keep frame)
      s.byte(0x21); s.byte(0xf9); s.byte(4);
      s.byte(0x04);                 // disposal = do not dispose
      s.u16(delayCs);
      s.byte(0);                    // transparent index (unused)
      s.byte(0);
      // image descriptor
      s.byte(0x2c);
      s.u16(0); s.u16(0); s.u16(w); s.u16(h);
      s.byte(0);                    // no local colour table, not interlaced
      const idx = quantizeFrame(f.data, w, h, index, dither);
      if (stego) {
        for (let i = 0; i < idx.length; i++) {
          idx[i] = idx[i] * 2 + (stegoAt < stegoBits.length ? stegoBits[stegoAt] : 0);
          stegoAt++;
        }
      }
      const minCodeSize = Math.max(2, bits);
      s.byte(minCodeSize);
      lzwEncode(idx, minCodeSize, s);
    }
    s.byte(0x3b);                   // trailer
    return s.done();
  }

  return {
    encode: encode,
    stegoCapacity: stegoCapacity,
    medianCutPalette: medianCutPalette,
    quantizeFrame: quantizeFrame,
    PaletteIndex: PaletteIndex,
  };
});
