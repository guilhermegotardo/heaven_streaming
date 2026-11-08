// Heaven Streaming — Penpot template generator.
// Runs inside Penpot as a plugin and builds a full streaming UI kit
// (design system, components, desktop/TV and mobile screens, prototype flows)
// using the same tokens as design/tokens/tokens.json.

/* ------------------------------------------------------------------ */
/* Tokens (mirrors design/tokens/tokens.json)                          */
/* ------------------------------------------------------------------ */

const C = {
  primary: '#E5383B',
  primaryHover: '#F05A5D',
  primaryPressed: '#C4282B',
  onPrimary: '#FFFFFF',
  background: '#0B0B0F',
  surface: '#15151C',
  surfaceRaised: '#1F1F29',
  border: '#2C2C38',
  textPrimary: '#F5F5F7',
  textSecondary: '#A1A1AA',
  textDisabled: '#5C5C66',
  success: '#22C55E',
  warning: '#F5A524',
  error: '#F04444',
  scrim: '#000000',
  white: '#FFFFFF',
};

const SEMANTIC_COLORS = [
  ['primary', C.primary], ['primaryHover', C.primaryHover], ['primaryPressed', C.primaryPressed],
  ['onPrimary', C.onPrimary], ['background', C.background], ['surface', C.surface],
  ['surfaceRaised', C.surfaceRaised], ['border', C.border], ['textPrimary', C.textPrimary],
  ['textSecondary', C.textSecondary], ['textDisabled', C.textDisabled], ['success', C.success],
  ['warning', C.warning], ['error', C.error], ['scrim (70%)', C.scrim, 0.7],
];

const PRIMITIVE_COLORS = [
  ['red/400', '#F05A5D'], ['red/500', '#E5383B'], ['red/600', '#C4282B'],
  ['neutral/0', '#FFFFFF'], ['neutral/50', '#F5F5F7'], ['neutral/400', '#A1A1AA'],
  ['neutral/600', '#5C5C66'], ['neutral/700', '#2C2C38'], ['neutral/800', '#1F1F29'],
  ['neutral/900', '#15151C'], ['neutral/950', '#0B0B0F'], ['neutral/1000', '#000000'],
  ['green/500', '#22C55E'], ['amber/500', '#F5A524'], ['rose/500', '#F04444'],
];

// [size, weight, lineHeight, letterSpacing]
const T = {
  hero: [64, 700, 1.1, -1],
  display: [48, 700, 1.2, -0.5],
  headline: [32, 700, 1.2, 0],
  title: [24, 600, 1.2, 0],
  titleSm: [20, 600, 1.2, 0],
  body: [16, 400, 1.5, 0],
  bodyStrong: [16, 600, 1.5, 0],
  bodySm: [14, 400, 1.5, 0],
  label: [14, 600, 1.2, 0],
  caption: [12, 500, 1.5, 0],
  overline: [12, 700, 1.2, 2],
};

const TYPO_LIBRARY = [
  ['Display', 'display'], ['Headline', 'headline'], ['Title', 'title'], ['Title Sm', 'titleSm'],
  ['Body', 'body'], ['Body Strong', 'bodyStrong'], ['Body Sm', 'bodySm'], ['Label', 'label'],
  ['Caption', 'caption'], ['Overline', 'overline'],
];

// Placeholder "key art" gradients for posters and backdrops.
const ART = [
  ['#1B2A6B', '#7B2FF7'], ['#3A0CA3', '#F72585'], ['#0B3D2E', '#2EC4B6'],
  ['#5A189A', '#FF6D00'], ['#03045E', '#00B4D8'], ['#6A040F', '#FFBA08'],
  ['#1D3557', '#E63946'], ['#2B2D42', '#8D99AE'], ['#004B23', '#9EF01A'],
  ['#3C096C', '#E0AAFF'], ['#370617', '#E85D04'], ['#0D1B2A', '#778DA9'],
];

const TITLES = [
  'Silent Harbor', 'Neon Drift', 'Wildlands', 'Paper Moons', 'Iron Valley', 'The Quiet Year',
  'Glass City', 'Afterglow', 'Low Tide', 'Orbit 9', 'Sunday Ghosts', 'Hollow Pines',
  'Red Meridian', 'Small Hours', 'Static Bloom', 'North of Nowhere',
];

/* ------------------------------------------------------------------ */
/* Icons (24×24 stroke icons, color injected at build time)            */
/* ------------------------------------------------------------------ */

const F = 'fill="currentColor" stroke="none"';
const ICONS = {
  play: `<path d="M7 4.5v15a1 1 0 0 0 1.5.86l12-7.5a1 1 0 0 0 0-1.72l-12-7.5A1 1 0 0 0 7 4.5z" ${F}/>`,
  pause: `<rect x="6" y="4" width="4" height="16" rx="1" ${F}/><rect x="14" y="4" width="4" height="16" rx="1" ${F}/>`,
  plus: '<path d="M12 5v14M5 12h14"/>',
  check: '<path d="M5 12.5l4.5 4.5L19 7.5"/>',
  info: '<circle cx="12" cy="12" r="9"/><path d="M12 11v5M12 7.5v.5"/>',
  alert: '<circle cx="12" cy="12" r="9"/><path d="M12 7v6M12 16.5v.5"/>',
  search: '<circle cx="11" cy="11" r="7"/><path d="M20 20l-4-4"/>',
  home: '<path d="M3 10.5L12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z"/>',
  bell: '<path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/>',
  user: '<circle cx="12" cy="8" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/>',
  back: '<path d="M19 12H5M12 19l-7-7 7-7"/>',
  chevronLeft: '<path d="M15 18l-6-6 6-6"/>',
  chevronRight: '<path d="M9 18l6-6-6-6"/>',
  chevronDown: '<path d="M6 9l6 6 6-6"/>',
  volume: '<path d="M11 5L6 9H3v6h3l5 4z"/><path d="M15.5 8.5a5 5 0 0 1 0 7M18.5 5.5a9 9 0 0 1 0 13"/>',
  fullscreen: '<path d="M4 9V4h5M20 9V4h-5M4 15v5h5M20 15v5h-5"/>',
  rewind: '<path d="M3 12a9 9 0 1 0 3-6.7L3 8"/><path d="M3 3v5h5"/>',
  forward: '<path d="M21 12a9 9 0 1 1-3-6.7L21 8"/><path d="M21 3v5h-5"/>',
  subtitles: '<rect x="3" y="5" width="18" height="14" rx="2"/><path d="M7 15h4M13 15h4M7 11h2M11 11h6"/>',
  settings: '<path d="M4 6h10M18 6h2M4 12h4M12 12h8M4 18h12"/><circle cx="16" cy="6" r="2"/><circle cx="10" cy="12" r="2"/><circle cx="18" cy="18" r="2"/>',
  download: '<path d="M12 4v11M7 10l5 5 5-5M5 20h14"/>',
  share: '<circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><path d="M8.6 13.5l6.8 4M15.4 6.5l-6.8 4"/>',
  star: `<path d="M12 3l2.8 5.7 6.2.9-4.5 4.4 1.1 6.2L12 17.3 6.4 20.2l1.1-6.2L3 9.6l6.2-.9z" ${F}/>`,
  close: '<path d="M6 6l12 12M18 6L6 18"/>',
  list: '<path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/>',
  menu: '<path d="M4 6h16M4 12h16M4 18h16"/>',
  edit: '<path d="M4 20h4L19 9l-4-4L4 16z"/>',
  cast: '<path d="M2 8V6a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-6"/><path d="M2 12a9 9 0 0 1 8 8M2 16a5 5 0 0 1 4 4M2 20h.01"/>',
  refresh: '<path d="M20 11a8 8 0 1 0-2.3 5.7"/><path d="M20 4v7h-7"/>',
  thumbUp: '<path d="M7 10v11H4V10zM7 10l4-7a2 2 0 0 1 3 2l-1 4h6a2 2 0 0 1 2 2.3l-1.4 7A2 2 0 0 1 17.6 20H7"/>',
  nextEp: `<path d="M5 5v14l10-7z" ${F}/><path d="M19 5v14"/>`,
  episodes: '<rect x="3" y="4" width="18" height="12" rx="2"/><path d="M7 20h10"/>',
  film: '<rect x="3" y="3" width="18" height="18" rx="2"/><path d="M7 3v18M17 3v18M3 8h4M3 16h4M17 8h4M17 16h4M3 12h18"/>',
  spinner: `<circle cx="12" cy="12" r="9" stroke="${C.border}"/><path d="M12 3a9 9 0 0 1 9 9" stroke="${C.primary}"/>`,
};

/* ------------------------------------------------------------------ */
/* Low-level helpers                                                   */
/* ------------------------------------------------------------------ */

const ROOT = { shape: null, x: 0, y: 0 };
let INTER = null;
const LIB = { components: {} };

const sleep = (ms) => new Promise((r) => (typeof setTimeout === 'function' ? setTimeout(r, ms) : r()));

function log(msg, kind = 'info') {
  try { penpot.ui.sendMessage({ type: 'log', msg, kind }); } catch (_) { /* ui closed */ }
}

function safe(label, fn, fallback = null) {
  try { return fn(); } catch (e) { log(`⚠ ${label}: ${e && e.message ? e.message : e}`, 'warn'); return fallback; }
}

function grad(c1, c2, dir = 'diag', o1 = 1, o2 = 1) {
  const d = {
    diag: [0, 0, 1, 1], down: [0.5, 0, 0.5, 1], up: [0.5, 1, 0.5, 0],
    right: [0, 0.5, 1, 0.5], left: [1, 0.5, 0, 0.5],
  }[dir];
  return {
    fillColorGradient: {
      type: 'linear', startX: d[0], startY: d[1], endX: d[2], endY: d[3], width: 1,
      stops: [{ color: c1, opacity: o1, offset: 0 }, { color: c2, opacity: o2, offset: 1 }],
    },
  };
}

function art(i, dir = 'diag') {
  const [a, b] = ART[((i % ART.length) + ART.length) % ART.length];
  return grad(a, b, dir);
}

function fills(f, opacity = 1) {
  if (!f) return [];
  if (typeof f === 'string') return [{ fillColor: f, fillOpacity: opacity }];
  if (Array.isArray(f)) return f;
  return [f];
}

function strokes(o) {
  if (!o.stroke) return [];
  return [{
    strokeColor: o.stroke, strokeWidth: o.strokeWidth || 1, strokeAlignment: 'inner',
    strokeOpacity: o.strokeOpacity ?? 1, strokeStyle: o.strokeStyle || 'solid',
  }];
}

// Adds `s` to parent ref `p` at (x, y) relative to the parent's origin.
function place(p, s, x, y) {
  if (p.flex) { p.flex.appendChild(s); return s; }
  if (p.shape) p.shape.appendChild(s);
  s.x = p.x + x;
  s.y = p.y + y;
  return s;
}

function frame(p, name, x, y, w, h, fill, o = {}) {
  const b = penpot.createBoard();
  b.name = name;
  b.resize(w, h);
  b.fills = fills(fill, o.opacity ?? 1);
  b.clipContent = o.clip ?? true;
  if (o.radius) b.borderRadius = o.radius;
  if (o.stroke) b.strokes = strokes(o);
  place(p, b, x, y);
  return { shape: b, x: p.flex ? 0 : p.x + x, y: p.flex ? 0 : p.y + y, w, h };
}

function pin(s, h, v) {
  if (!s) return s;
  safe('constraints', () => { s.constraintsHorizontal = h; s.constraintsVertical = v; });
  return s;
}

function rect(p, x, y, w, h, fill, o = {}) {
  const r = penpot.createRectangle();
  r.name = o.name || 'rect';
  r.resize(w, h);
  r.fills = fills(fill, o.opacity ?? 1);
  if (o.radius) r.borderRadius = o.radius;
  if (o.stroke) r.strokes = strokes(o);
  place(p, r, x, y);
  return r;
}

function ellipse(p, x, y, w, h, fill, o = {}) {
  const e = penpot.createEllipse();
  e.name = o.name || 'ellipse';
  e.resize(w, h);
  e.fills = fills(fill, o.opacity ?? 1);
  if (o.stroke) e.strokes = strokes(o);
  if (o.blur) e.blur = { type: 'layer-blur', value: o.blur };
  place(p, e, x, y);
  return e;
}

function applyFont(t, style) {
  const [size, weight, lh, ls] = T[style] || T.body;
  if (INTER) {
    const v = INTER.variants.find((x) => x.fontWeight === String(weight) && x.fontStyle === 'normal')
      || INTER.variants.find((x) => x.fontStyle === 'normal');
    safe('font', () => INTER.applyToText(t, v));
  }
  t.fontSize = String(size);
  t.fontWeight = String(weight);
  t.lineHeight = String(lh);
  t.letterSpacing = String(ls);
}

function text(p, x, y, str, style = 'body', o = {}) {
  const t = penpot.createText(str);
  if (!t) return null;
  t.name = o.name || str.slice(0, 32);
  applyFont(t, style);
  if (o.size) t.fontSize = String(o.size);
  if (o.weight) t.fontWeight = String(o.weight);
  if (o.upper) t.textTransform = 'uppercase';
  t.fills = [{ fillColor: o.color || C.textPrimary, fillOpacity: o.opacity ?? 1 }];
  if (o.width) {
    t.growType = 'auto-height';
    t.resize(o.width, Math.max(t.height || 20, 20));
  } else {
    t.growType = 'auto-width';
  }
  if (o.align) t.align = o.align;
  place(p, t, x, y);
  return t;
}

function icon(p, name, x, y, size = 24, color = C.textPrimary, o = {}) {
  const body = (ICONS[name] || ICONS.info).split('currentColor').join(color);
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="${color}" stroke-width="${o.stroke || 2}" stroke-linecap="round" stroke-linejoin="round">${body}</svg>`;
  const g = safe(`icon ${name}`, () => penpot.createShapeFromSvg(svg));
  if (!g) return null;
  g.name = `icon/${name}`;
  if (size !== 24) g.resize(size, size);
  place(p, g, x, y);
  return g;
}

// Horizontal auto-layout container that hugs its content (buttons, chips, badges).
function hstack(p, name, x, y, h, fill, o = {}) {
  const f = frame(p, name, x, y, o.w || 100, h, fill, { radius: o.radius, stroke: o.stroke, strokeWidth: o.strokeWidth, opacity: o.opacity, clip: false });
  const fl = f.shape.addFlexLayout();
  fl.dir = 'row';
  fl.alignItems = 'center';
  fl.justifyContent = 'center';
  fl.columnGap = o.gap ?? 8;
  fl.leftPadding = o.padL ?? o.padX ?? 16;
  fl.rightPadding = o.padR ?? o.padX ?? 16;
  fl.topPadding = 0;
  fl.bottomPadding = 0;
  if (!o.w) f.shape.horizontalSizing = 'auto';
  f.shape.verticalSizing = 'fix';
  return { shape: f.shape, flex: fl, x: f.x, y: f.y };
}

function estW(str, style) {
  const [size, weight] = T[style] || T.body;
  return Math.round(str.length * size * (weight >= 600 ? 0.6 : 0.55));
}

function link(shape, dest, trigger = 'click') {
  if (!shape || !dest) return;
  safe('interaction', () => shape.addInteraction(trigger, { type: 'navigate-to', destination: dest }, trigger === 'after-delay' ? 2000 : undefined));
}

function back(shape) {
  if (!shape) return;
  safe('interaction', () => shape.addInteraction('click', { type: 'previous-screen' }));
}

function findByName(shape, name) {
  if (!shape) return null;
  if (shape.name === name) return shape;
  const kids = shape.children || [];
  for (const k of kids) {
    const r = findByName(k, name);
    if (r) return r;
  }
  return null;
}

/* ------------------------------------------------------------------ */
/* Components                                                          */
/* ------------------------------------------------------------------ */

const BUILDERS = {
  'Button/Primary': (p, x, y, o = {}) => {
    const b = hstack(p, 'Button/Primary', x, y, o.h || 48, C.primary, { radius: 8, padX: o.padX ?? 24, w: o.w });
    if (o.icon !== null) icon(b, o.icon || 'play', 0, 0, 24, C.onPrimary);
    text(b, 0, 0, o.label || 'Play', 'bodyStrong', { name: 'label', color: C.onPrimary });
    return b.shape;
  },
  'Button/Secondary': (p, x, y, o = {}) => {
    const b = hstack(p, 'Button/Secondary', x, y, o.h || 48, C.white, { radius: 8, padX: o.padX ?? 24, opacity: 0.16, w: o.w });
    if (o.icon !== null) icon(b, o.icon || 'info', 0, 0, 24, C.textPrimary);
    text(b, 0, 0, o.label || 'More info', 'bodyStrong', { name: 'label' });
    return b.shape;
  },
  'Button/Outline': (p, x, y, o = {}) => {
    const b = hstack(p, 'Button/Outline', x, y, o.h || 48, null, { radius: 8, padX: o.padX ?? 24, stroke: C.textSecondary, strokeWidth: 1.5, w: o.w });
    text(b, 0, 0, o.label || 'Manage Profiles', 'bodyStrong', { name: 'label', color: C.textSecondary });
    return b.shape;
  },
  'Button/Icon': (p, x, y, o = {}) => {
    const f = frame(p, 'Button/Icon', x, y, 48, 48, null, { radius: 24, stroke: C.textSecondary, strokeWidth: 1.5 });
    icon(f, o.icon || 'plus', 12, 12, 24, C.textPrimary);
    return f.shape;
  },
  'Chip': (p, x, y, o = {}) => {
    const active = !!o.active;
    const b = hstack(p, active ? 'Chip/Active' : 'Chip', x, y, 36, active ? C.textPrimary : null, {
      radius: 18, padX: 16, stroke: active ? null : C.border, strokeWidth: 1,
    });
    text(b, 0, 0, o.label || 'Sci-Fi', 'label', { name: 'label', color: active ? C.background : C.textPrimary });
    return b.shape;
  },
  'Badge': (p, x, y, o = {}) => {
    const b = hstack(p, 'Badge', x, y, 22, null, { radius: 4, padX: 6, stroke: C.textSecondary, strokeWidth: 1 });
    text(b, 0, 0, o.label || '16+', 'caption', { name: 'label', color: C.textSecondary, weight: 600 });
    return b.shape;
  },
  'Badge/New': (p, x, y, o = {}) => {
    const b = hstack(p, 'Badge/New', x, y, 20, C.primary, { radius: 4, padX: 6 });
    text(b, 0, 0, o.label || 'NEW', 'overline', { name: 'label', color: C.onPrimary, size: 10 });
    return b.shape;
  },
  'Card/Poster': (p, x, y, o = {}) => {
    const w = o.w || 160; const h = o.h || 240;
    const f = frame(p, 'Card/Poster', x, y, w, h, null, { radius: 8 });
    pin(rect(f, 0, 0, w, h, art(o.art ?? 0), { name: 'art' }), 'leftright', 'topbottom');
    pin(rect(f, 0, h * 0.55, w, h * 0.45, grad(C.scrim, C.scrim, 'down', 0, 0.85), { name: 'scrim' }), 'leftright', 'bottom');
    pin(text(f, 12, h - 44, o.title || 'Silent Harbor', 'label', { name: 'title', width: w - 24 }), 'leftright', 'bottom');
    return f.shape;
  },
  'Card/Continue': (p, x, y, o = {}) => {
    const w = o.w || 320; const h = o.h || 180;
    const f = frame(p, 'Card/Continue', x, y, w, h + 52, null, { clip: false });
    const thumb = frame(f, 'thumb', 0, 0, w, h, null, { radius: 8 });
    pin(thumb.shape, 'leftright', 'topbottom');
    pin(rect(thumb, 0, 0, w, h, art(o.art ?? 1), { name: 'art' }), 'leftright', 'topbottom');
    pin(rect(thumb, 0, 0, w, h, C.scrim, { opacity: 0.25, name: 'dim' }), 'leftright', 'topbottom');
    pin(ellipse(thumb, w / 2 - 24, h / 2 - 24, 48, 48, C.scrim, { opacity: 0.5, stroke: C.white, strokeWidth: 2, name: 'play-bg' }), 'center', 'center');
    pin(icon(thumb, 'play', w / 2 - 12, h / 2 - 12, 24, C.white), 'center', 'center');
    pin(rect(thumb, 0, h - 4, w, 4, C.white, { opacity: 0.3, name: 'track' }), 'leftright', 'bottom');
    pin(rect(thumb, 0, h - 4, Math.max(4, Math.round(w * (o.progress ?? 0.45))), 4, C.primary, { name: 'progress' }), 'left', 'bottom');
    pin(text(f, 0, h + 10, o.title || 'Neon Drift', 'label', { name: 'title' }), 'left', 'bottom');
    pin(text(f, 0, h + 30, o.meta || 'S1:E4 · 22m left', 'caption', { name: 'meta', color: C.textSecondary }), 'left', 'bottom');
    return f.shape;
  },
  'Row/Episode': (p, x, y, o = {}) => {
    const w = o.w || 1200;
    const f = frame(p, 'Row/Episode', x, y, w, 167, o.active ? C.surfaceRaised : null, { radius: 12 });
    text(f, 24, 66, String(o.n || 1), 'title', { name: 'number', color: C.textSecondary });
    const th = frame(f, 'thumb', 72, 16, 240, 135, null, { radius: 8 });
    rect(th, 0, 0, 240, 135, art(o.art ?? 2), { name: 'art' });
    icon(th, 'play', 104, 51, 32, C.white);
    if (o.progress) {
      rect(th, 0, 131, 240, 4, C.white, { opacity: 0.3, name: 'track' });
      rect(th, 0, 131, Math.round(240 * o.progress), 4, C.primary, { name: 'progress' });
    }
    text(f, 336, 28, o.title || 'Pilot', 'bodyStrong', { name: 'title' });
    text(f, w - 104, 28, o.duration || '52m', 'bodySm', { name: 'duration', color: C.textSecondary, width: 80, align: 'right' });
    text(f, 336, 60, o.synopsis || 'A faint transmission from deep space reaches a remote listening station, and Mara is the only one who hears it.', 'bodySm', { name: 'synopsis', color: C.textSecondary, width: w - 360 });
    return f.shape;
  },
  'Input/Search': (p, x, y, o = {}) => {
    const w = o.w || 640; const h = o.h || 56;
    const f = frame(p, 'Input/Search', x, y, w, h, C.surfaceRaised, { radius: 12, stroke: C.border });
    pin(icon(f, 'search', 16, (h - 24) / 2, 24, C.textSecondary), 'left', 'center');
    pin(text(f, 52, (h - 24) / 2, o.value || 'Search titles, people, genres', 'body', { name: 'value', color: o.value ? C.textPrimary : C.textSecondary }), 'leftright', 'center');
    return f.shape;
  },
};

// Instantiates a library component (or builds it directly as a fallback),
// then overrides named text layers and the "art" fill.
// Sizes of resizable components: [width, height] of the root for the requested props.
const RESIZABLE = {
  'Card/Poster': (o) => [o.w, o.h],
  'Card/Continue': (o) => [o.w, o.h !== undefined ? o.h + 52 : undefined],
  'Input/Search': (o) => [o.w, o.h],
};

function use(key, p, x, y, o = {}) {
  const comp = LIB.components[key];
  // Variations an instance can't express (other icon, fixed width button, active row)
  // are built directly instead.
  const sized = o.w !== undefined || o.h !== undefined;
  const canInstance = comp && o.icon === undefined && !o.active && o.padX === undefined
    && (!sized || RESIZABLE[key]);
  if (canInstance) {
    const inst = safe(`instance ${key}`, () => {
      const s = comp.instance();
      place(p, s, x, y);
      if (sized) {
        const [w, h] = RESIZABLE[key](o);
        s.resize(w ?? s.width, h ?? s.height);
      }
      return s;
    });
    if (inst) {
      for (const [name, value] of Object.entries(o.texts || {})) {
        const t = findByName(inst, name);
        if (t && t.type === 'text') safe('override', () => { t.characters = value; });
      }
      if (o.art !== undefined) {
        const a = findByName(inst, 'art');
        if (a) safe('override art', () => { a.fills = fills(art(o.art)); });
      }
      if (o.progress !== undefined) {
        const pr = findByName(inst, 'progress');
        const tr = findByName(inst, 'track');
        if (pr && tr) {
          safe('override progress', () => {
            if (!o.progress) { pr.hidden = true; tr.hidden = true; } else pr.resize(Math.max(4, Math.round(tr.width * o.progress)), pr.height);
          });
        }
      }
      return inst;
    }
  }
  const props = { ...o, ...(o.texts || {}) };
  return BUILDERS[key](p, x, y, props);
}

/* ------------------------------------------------------------------ */
/* Shared screen pieces                                                */
/* ------------------------------------------------------------------ */

function logo(p, x, y, size = 28) {
  return text(p, x, y, 'HEAVEN', 'headline', { name: 'logo', size, weight: 800, color: C.primary });
}

function topNav(p, active = 'Home', w = 1920) {
  const n = frame(p, 'Nav/Top', 0, 0, w, 96, grad(C.background, C.background, 'down', 0.95, 0), { clip: false });
  logo(n, 64, 30);
  const items = ['Home', 'Series', 'Movies', 'New & Popular', 'My List'];
  let x = 260;
  for (const it of items) {
    const on = it === active;
    text(n, x, 36, it, on ? 'bodyStrong' : 'body', { color: on ? C.textPrimary : C.textSecondary, name: `nav/${it}` });
    x += estW(it, 'body') + 36;
  }
  const s = icon(n, 'search', w - 200, 34);
  icon(n, 'bell', w - 152, 34);
  rect(n, w - 104, 28, 36, 36, art(4), { radius: 6, name: 'avatar' });
  icon(n, 'chevronDown', w - 60, 36, 20, C.textSecondary);
  return { nav: n, search: s };
}

function heroBackdrop(p, w, h, artIdx, o = {}) {
  rect(p, 0, 0, w, h, art(artIdx, 'diag'), { name: 'backdrop/art' });
  ellipse(p, w * 0.55, -h * 0.2, w * 0.6, w * 0.6, C.white, { opacity: 0.08, name: 'backdrop/glow', blur: 80 });
  ellipse(p, w * 0.7, h * 0.15, w * 0.18, w * 0.18, C.white, { opacity: 0.12, name: 'backdrop/moon' });
  rect(p, 0, 0, w * (o.scrimW || 0.65), h, grad(C.background, C.background, 'right', 0.95, 0), { name: 'backdrop/scrim-left' });
  rect(p, 0, h * 0.55, w, h * 0.45 + 2, grad(C.background, C.background, 'down', 0, 1), { name: 'backdrop/scrim-bottom' });
}

function metaRow(p, x, y, parts, o = {}) {
  let cx = x;
  if (o.match) {
    text(p, cx, y, o.match, 'bodyStrong', { color: C.success });
    cx += estW(o.match, 'bodyStrong') + 12;
  }
  for (const part of parts) {
    if (part.badge) {
      use('Badge', p, cx, y + 1, { texts: { label: part.badge } });
      cx += estW(part.badge, 'caption') + 28;
    } else {
      text(p, cx, y, part, 'body', { color: C.textSecondary });
      cx += estW(part, 'body') + 16;
    }
  }
}

function sectionTitle(p, x, y, title, w, seeAll = true) {
  text(p, x, y, title, 'titleSm');
  if (seeAll) {
    text(p, x + w - 90, y + 2, 'See all', 'label', { color: C.textSecondary });
    icon(p, 'chevronRight', x + w - 28, y, 20, C.textSecondary);
  }
}

function posterRow(p, y, title, start, count, o = {}) {
  const w = o.w || 200; const h = o.h || 300; const gap = o.gap || 16; const x0 = o.x || 64;
  sectionTitle(p, x0, y, title, (o.width || 1792));
  const cards = [];
  for (let i = 0; i < count; i++) {
    cards.push(use('Card/Poster', p, x0 + i * (w + gap), y + 44, {
      art: start + i, texts: { title: TITLES[(start + i) % TITLES.length] }, w, h,
    }));
  }
  return cards;
}

function statusBar(p, w = 390, color = C.textPrimary) {
  const s = frame(p, 'StatusBar', 0, 0, w, 44, null, { clip: false });
  text(s, 24, 14, '9:41', 'label', { color, weight: 600 });
  rect(s, w - 84, 18, 18, 10, color, { radius: 2, name: 'signal' });
  rect(s, w - 60, 18, 16, 10, color, { radius: 2, name: 'wifi' });
  rect(s, w - 38, 17, 24, 12, null, { radius: 3, stroke: color, strokeWidth: 1, name: 'battery' });
  rect(s, w - 36, 19, 16, 8, color, { radius: 1, name: 'battery-level' });
  return s;
}

function bottomNav(p, active = 'Home', w = 390, y = 760) {
  const n = frame(p, 'Nav/Bottom', 0, y, w, 84, C.surface, { clip: false });
  rect(n, 0, 0, w, 1, C.border, { name: 'divider' });
  const items = [['home', 'Home'], ['search', 'Search'], ['list', 'My List'], ['download', 'Downloads'], ['user', 'Profile']];
  const slot = w / items.length;
  const refs = {};
  items.forEach(([ic, label], i) => {
    const on = label === active;
    const cx = slot * i + slot / 2;
    refs[label] = icon(n, ic, cx - 12, 12, 24, on ? C.textPrimary : C.textSecondary);
    text(n, cx - slot / 2, 40, label, 'caption', { color: on ? C.textPrimary : C.textSecondary, width: slot, align: 'center' });
  });
  rect(n, w / 2 - 67, 70, 134, 5, C.textPrimary, { radius: 3, name: 'home-indicator' });
  return refs;
}

function label(p, x, y, str) {
  return text(p, x, y, str, 'title', { color: '#8A8A99', name: `label/${str}` });
}

/* ------------------------------------------------------------------ */
/* Page: Cover                                                         */
/* ------------------------------------------------------------------ */

function buildCover() {
  const b = frame(ROOT, 'Cover', 0, 0, 1600, 960, grad('#0B0B0F', '#2A0A0E', 'diag'));
  ellipse(b, 900, -300, 1000, 1000, C.primary, { opacity: 0.18, blur: 120, name: 'glow' });
  logo(b, 120, 120, 40);
  text(b, 120, 260, 'Streaming UI Kit', 'display', { size: 96, weight: 800 });
  text(b, 120, 390, 'Design system, components and screens for desktop/TV and mobile — built on the Heaven Streaming tokens.', 'title', { color: C.textSecondary, width: 980, weight: 400 });
  const pages = [
    ['01', 'Design System', 'Colors, typography, spacing, radius, iconography'],
    ['02', 'Components', 'Buttons, chips, badges, cards, episode row, search'],
    ['03', 'Desktop / TV', '1920×1080 · splash, profiles, home, details, player, states'],
    ['04', 'Mobile', '390×844 · splash, home, details, search, my list, player'],
  ];
  pages.forEach(([n, t, d], i) => {
    const y = 560 + i * 80;
    text(b, 120, y, n, 'title', { color: C.primary });
    text(b, 190, y, t, 'title');
    text(b, 520, y + 4, d, 'body', { color: C.textSecondary });
  });
  SEMANTIC_COLORS.slice(0, 11).forEach(([, hex], i) => rect(b, 120 + i * 72, 900, 64, 12, hex, { radius: 6 }));
  text(b, 1200, 900, 'v1.0 · generated by plugin', 'caption', { color: C.textDisabled });
}

/* ------------------------------------------------------------------ */
/* Page: Design System                                                 */
/* ------------------------------------------------------------------ */

function buildDesignSystem() {
  // Colors
  const colors = frame(ROOT, 'Foundations/Colors', 0, 0, 1440, 760, C.background, { radius: 24 });
  text(colors, 64, 56, 'Colors', 'display');
  text(colors, 64, 124, 'Semantic tokens — use these in screens. Primitives live in the color library under "primitives".', 'body', { color: C.textSecondary });
  SEMANTIC_COLORS.forEach(([name, hex, op], i) => {
    const col = i % 8; const row = Math.floor(i / 8);
    const x = 64 + col * 164; const y = 190 + row * 270;
    rect(colors, x, y, 148, 148, hex, { radius: 12, opacity: op ?? 1, stroke: C.border, name: `swatch/${name}` });
    text(colors, x, y + 160, name, 'label');
    text(colors, x, y + 182, hex + (op ? ' · 70%' : ''), 'caption', { color: C.textSecondary });
  });

  // Typography
  const typo = frame(ROOT, 'Foundations/Typography', 1540, 0, 1440, 1000, C.background, { radius: 24 });
  text(typo, 64, 56, 'Typography', 'display');
  text(typo, 64, 124, 'Inter · scale from tokens (font.size / font.weight / font.lineHeight)', 'body', { color: C.textSecondary });
  const samples = [['hero', 'Hero title'], ...TYPO_LIBRARY.map(([n, k]) => [k, n])];
  let ty = 190;
  for (const [k, n] of samples) {
    const [s, w, lh] = T[k];
    text(typo, 64, ty + 6, `${n}`, 'label', { color: C.textSecondary });
    text(typo, 64, ty + 28, `${s}/${w} · lh ${lh}`, 'caption', { color: C.textDisabled });
    text(typo, 320, ty, k === 'overline' ? 'Trending now' : 'The Last Signal', k, { upper: k === 'overline' });
    ty += Math.max(56, s * lh + 24);
  }

  // Spacing & radius
  const sp = frame(ROOT, 'Foundations/Spacing & Radius', 0, 860, 1440, 640, C.background, { radius: 24 });
  text(sp, 64, 56, 'Spacing & Radius', 'display');
  const spacing = [['xs', 4], ['sm', 8], ['md', 12], ['lg', 16], ['xl', 24], ['xxl', 32], ['xxxl', 48], ['huge', 64]];
  spacing.forEach(([n, v], i) => {
    const y = 160 + i * 44;
    text(sp, 64, y, n, 'label', { color: C.textSecondary });
    rect(sp, 160, y, v * 4, 20, C.primary, { radius: 2, opacity: 0.85 });
    text(sp, 180 + v * 4, y, `${v}px`, 'caption', { color: C.textSecondary });
  });
  const radius = [['sm', 4], ['md', 8], ['lg', 12], ['xl', 16], ['full', 999]];
  radius.forEach(([n, v], i) => {
    const x = 760 + i * 128;
    rect(sp, x, 170, 104, 104, C.surfaceRaised, { radius: Math.min(v, 52), stroke: C.border });
    text(sp, x, 290, `radius.${n}`, 'label');
    text(sp, x, 312, `${v}px`, 'caption', { color: C.textSecondary });
  });
  text(sp, 760, 400, 'Sizes', 'titleSm');
  text(sp, 760, 440, 'Poster 160×240 · Hero 480 · App bar 64 · Icons 16 / 24 / 32', 'body', { color: C.textSecondary, width: 600 });

  // Icons
  const ic = frame(ROOT, 'Foundations/Icons', 1540, 1100, 1440, 400, C.background, { radius: 24 });
  text(ic, 64, 56, 'Icons', 'display');
  Object.keys(ICONS).filter((k) => k !== 'spinner').forEach((k, i) => {
    const col = i % 12; const row = Math.floor(i / 12);
    const x = 64 + col * 110; const y = 150 + row * 84;
    icon(ic, k, x + 32, y, 28);
    text(ic, x, y + 38, k, 'caption', { color: C.textSecondary, width: 92, align: 'center' });
  });
}

/* ------------------------------------------------------------------ */
/* Page: Components (masters registered in the local library)          */
/* ------------------------------------------------------------------ */

function buildComponents() {
  const specs = [
    ['Button/Primary', 0, 0, {}],
    ['Button/Secondary', 220, 0, {}],
    ['Button/Outline', 480, 0, {}],
    ['Button/Icon', 760, 0, {}],
    ['Chip', 0, 120, { active: true, label: 'All' }],
    ['Badge', 220, 126, {}],
    ['Badge/New', 340, 127, {}],
    ['Input/Search', 480, 110, {}],
    ['Card/Poster', 0, 260, {}],
    ['Card/Continue', 220, 260, {}],
    ['Row/Episode', 0, 620, { progress: 0.6 }],
  ];
  text(ROOT, 0, -120, 'Components', 'display');
  text(ROOT, 0, -56, 'Main components — edit here and every screen instance updates. Find them in Assets → Components.', 'body', { color: C.textSecondary });

  for (const [key, x, y, o] of specs) {
    const shape = safe(`build ${key}`, () => BUILDERS[key](ROOT, x, y, o));
    if (!shape) continue;
    const comp = safe(`component ${key}`, () => penpot.library.local.createComponent([shape]));
    if (comp) {
      safe('component name', () => {
        const parts = key.split('/');
        comp.name = parts.pop();
        comp.path = parts.join(' / ');
      });
      LIB.components[key] = comp;
    }
  }
}

/* ------------------------------------------------------------------ */
/* Page: Desktop / TV                                                  */
/* ------------------------------------------------------------------ */

function buildDesktop() {
  const W = 1920; const H = 1080; const GAP = 240;
  const at = (col, row, rowH = H) => ({ x: col * (W + GAP), y: row });
  const S = {};
  const R1 = 0; const R2 = 2400; const R3 = 4400;

  // 1. Splash
  {
    const { x, y } = at(0, R1);
    label(ROOT, x, y - 60, '1 · Splash');
    const f = frame(ROOT, 'Desktop/01 Splash', x, y, W, H, C.background);
    ellipse(f, W / 2 - 500, H / 2 - 500, 1000, 1000, C.primary, { opacity: 0.12, blur: 140, name: 'glow' });
    text(f, 0, 420, 'HEAVEN', 'display', { size: 120, weight: 800, color: C.primary, width: W, align: 'center' });
    text(f, 0, 580, 'STREAMING', 'overline', { size: 18, color: C.textSecondary, width: W, align: 'center' });
    icon(f, 'spinner', W / 2 - 20, 760, 40, C.primary, { stroke: 2.5 });
    S.splash = f.shape;
  }

  // 2. Profiles
  {
    const { x, y } = at(1, R1);
    label(ROOT, x, y - 60, '2 · Who\'s watching');
    const f = frame(ROOT, 'Desktop/02 Profiles', x, y, W, H, C.background);
    logo(f, 64, 40);
    text(f, 0, 260, 'Who\'s watching?', 'display', { size: 56, width: W, align: 'center' });
    const names = ['Gui', 'Ana', 'Kids', 'Guest'];
    const tile = 180; const gap = 48; const total = (names.length + 1) * tile + names.length * gap;
    const x0 = (W - total) / 2;
    S.profileTiles = names.map((n, i) => {
      const tx = x0 + i * (tile + gap);
      const t = rect(f, tx, 400, tile, tile, art(i + 3), { radius: 12, name: `profile/${n}` });
      text(f, tx, 600, n, 'title', { color: C.textSecondary, width: tile, align: 'center', weight: 400 });
      return t;
    });
    const ax = x0 + names.length * (tile + gap);
    rect(f, ax, 400, tile, tile, null, { radius: 12, stroke: C.textDisabled, strokeWidth: 2, strokeStyle: 'dashed', name: 'profile/add' });
    icon(f, 'plus', ax + tile / 2 - 28, 400 + tile / 2 - 28, 56, C.textSecondary);
    text(f, ax, 600, 'Add Profile', 'title', { color: C.textSecondary, width: tile, align: 'center', weight: 400 });
    use('Button/Outline', f, W / 2 - 110, 760, { texts: { label: 'Manage Profiles' } });
    S.profiles = f.shape;
  }

  // 3. Home (scrolling page)
  {
    const { x, y } = at(2, R1);
    label(ROOT, x, y - 60, '3 · Home (scroll)');
    const HH = 2080;
    const f = frame(ROOT, 'Desktop/03 Home', x, y, W, HH, C.background);
    const heroH = 900;
    heroBackdrop(f, W, heroH, 0);
    text(f, 64, 240, 'H  ORIGINAL SERIES', 'overline', { color: C.primary });
    text(f, 64, 272, 'The Last Signal', 'hero', { size: 88, weight: 800, width: 900 });
    metaRow(f, 64, 384, ['2026', { badge: '16+' }, '3 Seasons', { badge: 'HD' }, 'Sci-Fi · Thriller'], { match: '98% match' });
    text(f, 64, 428, 'When a forgotten radio telescope picks up a message addressed to her by name, an astronomer must decide whether to answer — and what it will cost the world if she does.', 'body', { color: C.textPrimary, width: 640, size: 18 });
    S.homePlay = use('Button/Primary', f, 64, 560, { texts: { label: 'Play' } });
    S.homeInfo = use('Button/Secondary', f, 220, 560, { texts: { label: 'More info' } });
    for (let i = 0; i < 5; i++) rect(f, 64 + i * 28, 660, i === 0 ? 20 : 8, 4, i === 0 ? C.textPrimary : C.textDisabled, { radius: 2, name: `dot/${i}` });
    use('Badge', f, W - 120, 580, { texts: { label: '16+' } });

    // Continue watching
    sectionTitle(f, 64, 760, 'Continue Watching for Gui', 1792);
    for (let i = 0; i < 5; i++) {
      use('Card/Continue', f, 64 + i * 360, 804, {
        art: i + 1, progress: [0.45, 0.8, 0.2, 0.6, 0.3][i],
        texts: { title: TITLES[i + 1], meta: ['S1:E4 · 22m left', '1h 05m left', 'S2:E1 · 41m left', 'S1:E8 · 12m left', '58m left'][i] },
      });
    }
    S.homePosters = posterRow(f, 1080, 'Trending Now', 4, 8);

    // Top 10
    sectionTitle(f, 64, 1460, 'Top 10 in Your Country Today', 1792);
    for (let i = 0; i < 5; i++) {
      const cx = 64 + i * 360;
      text(f, cx, 1470, String(i + 1), 'display', { size: 260, weight: 800, color: C.surfaceRaised, name: `rank/${i + 1}` });
      use('Card/Poster', f, cx + 150, 1504, { art: i + 7, w: 200, h: 300, texts: { title: TITLES[(i + 7) % TITLES.length] } });
    }
    sectionTitle(f, 64, 1852, 'New Releases', 1792);
    for (let i = 0; i < 6; i++) {
      use('Card/Continue', f, 64 + i * 304, 1896, { art: i + 5, w: 288, h: 162, progress: 0, texts: { title: TITLES[(i + 9) % TITLES.length], meta: 'New episode · Fridays' } });
    }
    const n = topNav(f, 'Home');
    S.homeSearch = n.search;
    S.home = f.shape;
  }

  // 4. Movie details
  {
    const { x, y } = at(3, R1);
    label(ROOT, x, y - 60, '4 · Title details (movie)');
    const f = frame(ROOT, 'Desktop/04 Details – Movie', x, y, W, H, C.background);
    heroBackdrop(f, W, H, 5, { scrimW: 0.7 });
    topNav(f, 'Movies');
    S.movieBack = icon(f, 'back', 64, 140, 32);
    text(f, 64, 260, 'FILM', 'overline', { color: C.primary });
    text(f, 64, 290, 'Iron Valley', 'hero', { size: 80, weight: 800 });
    metaRow(f, 64, 398, ['2025', { badge: '14+' }, '2h 14m', { badge: '4K' }, { badge: '5.1' }], { match: '94% match' });
    text(f, 64, 444, 'A disgraced mining engineer returns to the valley that exiled her when the town\'s last working mine begins to swallow its own tunnels.', 'body', { width: 720, size: 18 });
    S.moviePlay = use('Button/Primary', f, 64, 560, { texts: { label: 'Play' } });
    use('Button/Secondary', f, 220, 560, { icon: 'plus', texts: { label: 'My List' } });
    use('Button/Icon', f, 404, 560, { icon: 'thumbUp' });
    use('Button/Icon', f, 468, 560, { icon: 'share' });
    text(f, 64, 650, 'Starring: Lena Okafor, Tomás Reyes, Ingrid Vail', 'bodySm', { color: C.textSecondary, width: 720 });
    text(f, 64, 676, 'Director: Ruth Achterberg · Genres: Drama, Mystery', 'bodySm', { color: C.textSecondary, width: 720 });
    posterRow(f, 750, 'More Like This', 2, 9, { w: 180, h: 270 });
    S.movie = f.shape;
  }

  // 5. Series details with episodes
  {
    const { x, y } = at(0, R2);
    label(ROOT, x, y - 60, '5 · Title details (series + episodes)');
    const HH = 1600;
    const f = frame(ROOT, 'Desktop/05 Details – Series', x, y, W, HH, C.background);
    heroBackdrop(f, W, 720, 0);
    topNav(f, 'Series');
    S.seriesBack = icon(f, 'back', 64, 140, 32);
    text(f, 64, 230, 'H  ORIGINAL SERIES', 'overline', { color: C.primary });
    text(f, 64, 262, 'The Last Signal', 'hero', { size: 80, weight: 800 });
    metaRow(f, 64, 370, ['2026', { badge: '16+' }, '3 Seasons', { badge: 'HD' }], { match: '98% match' });
    text(f, 64, 414, 'When a forgotten radio telescope picks up a message addressed to her by name, an astronomer must decide whether to answer.', 'body', { width: 720, size: 18 });
    S.seriesPlay = use('Button/Primary', f, 64, 516, { texts: { label: 'Resume S1:E3' } });
    use('Button/Secondary', f, 300, 516, { icon: 'check', texts: { label: 'My List' } });
    use('Button/Icon', f, 484, 516, { icon: 'download' });

    // Tabs
    const tabs = ['Episodes', 'More Like This', 'Trailers & More', 'Details'];
    let tx = 64;
    tabs.forEach((t, i) => {
      text(f, tx, 680, t, i === 0 ? 'bodyStrong' : 'body', { color: i === 0 ? C.textPrimary : C.textSecondary, size: 18 });
      if (i === 0) rect(f, tx, 716, estW(t, 'bodyStrong') + 8, 3, C.primary, { radius: 2, name: 'tab/indicator' });
      tx += estW(t, 'body') + 64;
    });
    rect(f, 64, 719, 1792, 1, C.border, { name: 'tabs/divider' });

    const sel = frame(f, 'Select/Season', 64, 760, 200, 44, C.surfaceRaised, { radius: 8, stroke: C.border });
    text(sel, 16, 11, 'Season 1', 'bodyStrong');
    icon(sel, 'chevronDown', 164, 10, 24, C.textSecondary);
    text(f, 290, 772, '8 episodes · 2026', 'bodySm', { color: C.textSecondary });

    const eps = [
      ['Pilot', '58m', 1], ['Dead Air', '52m', 1], ['Into the Static', '49m', 0.35],
      ['The Listening Post', '55m', 0], ['Carrier Wave', '51m', 0], ['Noise Floor', '47m', 0],
    ];
    eps.forEach(([t, d, pr], i) => {
      const r = use('Row/Episode', f, 64, 836 + i * 120, {
        art: i + 2, progress: pr, n: i + 1, active: i === 2,
        texts: { number: String(i + 1), title: t, duration: d },
      });
      if (i === 2) S.episodeRow = r;
    });
    S.series = f.shape;
  }

  // 6. Search
  {
    const { x, y } = at(1, R2);
    label(ROOT, x, y - 60, '6 · Search');
    const f = frame(ROOT, 'Desktop/06 Search', x, y, W, H, C.background);
    topNav(f, '');
    use('Input/Search', f, 64, 120, { w: 1792, h: 64, texts: { value: 'signal' } });
    const chips = ['All', 'Series', 'Movies', 'Sci-Fi', 'Drama', 'Comedy', 'Documentary', 'Kids'];
    let cx = 64;
    chips.forEach((c, i) => {
      if (i === 0) BUILDERS.Chip(f, cx, 212, { label: c, active: true });
      else use('Chip', f, cx, 212, { texts: { label: c } });
      cx += estW(c, 'label') + 48;
    });
    text(f, 64, 284, 'Top results for "signal"', 'titleSm');
    const cols = 8; const pw = 203; const ph = 304; const g = 24;
    for (let i = 0; i < 16; i++) {
      const col = i % cols; const row = Math.floor(i / cols);
      use('Card/Poster', f, 64 + col * (pw + g), 332 + row * (ph + g), { w: pw, h: ph, art: i, texts: { title: TITLES[i % TITLES.length] } });
    }
    S.search = f.shape;
  }

  // 7. Player
  {
    const { x, y } = at(2, R2);
    label(ROOT, x, y - 60, '7 · Player');
    const f = frame(ROOT, 'Desktop/07 Player', x, y, W, H, C.scrim);
    rect(f, 0, 0, W, H, art(0), { opacity: 0.7, name: 'video' });
    rect(f, 0, 0, W, 200, grad(C.scrim, C.scrim, 'down', 0.8, 0), { name: 'scrim/top' });
    rect(f, 0, H - 320, W, 320, grad(C.scrim, C.scrim, 'down', 0, 0.9), { name: 'scrim/bottom' });
    S.playerBack = icon(f, 'back', 48, 48, 32);
    text(f, 104, 44, 'The Last Signal', 'title');
    text(f, 104, 78, 'S1:E3 · Into the Static', 'body', { color: C.textSecondary });
    icon(f, 'cast', W - 96, 52, 32);

    // center controls
    icon(f, 'rewind', W / 2 - 200, H / 2 - 28, 56);
    text(f, W / 2 - 200, H / 2 - 10, '10', 'caption', { width: 56, align: 'center', weight: 700 });
    ellipse(f, W / 2 - 56, H / 2 - 56, 112, 112, C.white, { opacity: 0.16, name: 'play-bg' });
    icon(f, 'pause', W / 2 - 32, H / 2 - 32, 64);
    icon(f, 'forward', W / 2 + 144, H / 2 - 28, 56);
    text(f, W / 2 + 144, H / 2 - 10, '10', 'caption', { width: 56, align: 'center', weight: 700 });

    use('Button/Secondary', f, W - 260, 800, { icon: null, texts: { label: 'Skip Intro' } });

    // progress
    rect(f, 48, 930, W - 96, 6, C.white, { opacity: 0.25, radius: 3, name: 'progress/track' });
    rect(f, 48, 930, (W - 96) * 0.62, 6, C.white, { opacity: 0.45, radius: 3, name: 'progress/buffer' });
    rect(f, 48, 930, (W - 96) * 0.38, 6, C.primary, { radius: 3, name: 'progress/played' });
    ellipse(f, 48 + (W - 96) * 0.38 - 10, 923, 20, 20, C.primary, { name: 'progress/knob' });
    const tip = frame(f, 'progress/preview', 48 + (W - 96) * 0.38 - 120, 760, 240, 150, null, { radius: 8, stroke: C.white, strokeWidth: 2 });
    rect(tip, 0, 0, 240, 135, art(1), { name: 'art' });
    text(tip, 0, 112, '18:42', 'label', { width: 240, align: 'center' });
    text(f, 48, 960, '18:42', 'label');
    text(f, W - 48 - 60, 960, '49:10', 'label', { width: 60, align: 'right' });

    // control bar
    const cy = 1004;
    icon(f, 'pause', 48, cy, 36);
    icon(f, 'rewind', 116, cy, 36);
    icon(f, 'forward', 184, cy, 36);
    icon(f, 'volume', 252, cy, 36);
    rect(f, 304, cy + 16, 120, 4, C.white, { opacity: 0.3, radius: 2 });
    rect(f, 304, cy + 16, 80, 4, C.white, { radius: 2 });
    text(f, 0, cy + 4, 'The Last Signal  ·  S1:E3 Into the Static', 'bodyStrong', { width: W, align: 'center' });
    icon(f, 'nextEp', W - 316, cy, 36);
    icon(f, 'episodes', W - 248, cy, 36);
    icon(f, 'subtitles', W - 180, cy, 36);
    icon(f, 'settings', W - 112, cy, 36);
    icon(f, 'fullscreen', W - 48 - 36 + 12, cy, 36);
    S.player = f.shape;
  }

  // 8. My List
  {
    const { x, y } = at(3, R2);
    label(ROOT, x, y - 60, '8 · My List');
    const f = frame(ROOT, 'Desktop/08 My List', x, y, W, H, C.background);
    topNav(f, 'My List');
    text(f, 64, 128, 'My List', 'display');
    const sort = frame(f, 'Select/Sort', W - 64 - 220, 136, 220, 44, C.surfaceRaised, { radius: 8, stroke: C.border });
    text(sort, 16, 11, 'Recently added', 'bodyStrong');
    icon(sort, 'chevronDown', 184, 10, 24, C.textSecondary);
    const cols = 8; const pw = 203; const ph = 304; const g = 24;
    for (let i = 0; i < 16; i++) {
      const col = i % cols; const row = Math.floor(i / cols);
      use('Card/Poster', f, 64 + col * (pw + g), 228 + row * (ph + g + 8), { w: pw, h: ph, art: i + 3, texts: { title: TITLES[(i + 3) % TITLES.length] } });
    }
    S.mylist = f.shape;
  }

  // 9-11. States
  {
    const { x, y } = at(0, R3);
    label(ROOT, x, y - 60, '9 · Loading (skeleton)');
    const f = frame(ROOT, 'Desktop/09 Loading', x, y, W, H, C.background);
    topNav(f, 'Home');
    rect(f, 0, 0, W, 700, C.surface, { name: 'skeleton/hero' });
    rect(f, 64, 260, 160, 16, C.surfaceRaised, { radius: 4 });
    rect(f, 64, 300, 720, 72, C.surfaceRaised, { radius: 8 });
    rect(f, 64, 400, 520, 18, C.surfaceRaised, { radius: 4 });
    rect(f, 64, 432, 640, 18, C.surfaceRaised, { radius: 4 });
    rect(f, 64, 464, 460, 18, C.surfaceRaised, { radius: 4 });
    rect(f, 64, 540, 140, 48, C.surfaceRaised, { radius: 8 });
    rect(f, 220, 540, 170, 48, C.surfaceRaised, { radius: 8 });
    rect(f, 64, 760, 280, 24, C.surface, { radius: 4 });
    for (let i = 0; i < 6; i++) rect(f, 64 + i * 304, 808, 288, 162, C.surface, { radius: 8 });
  }
  {
    const { x, y } = at(1, R3);
    label(ROOT, x, y - 60, '10 · Error');
    const f = frame(ROOT, 'Desktop/10 Error', x, y, W, H, C.background);
    topNav(f, 'Home');
    icon(f, 'alert', W / 2 - 40, 340, 80, C.error, { stroke: 1.5 });
    text(f, 0, 460, 'Unable to load the catalog.', 'headline', { width: W, align: 'center' });
    text(f, 0, 512, 'Check your connection or the catalog server and try again.', 'body', { color: C.textSecondary, width: W, align: 'center' });
    use('Button/Primary', f, W / 2 - 90, 590, { icon: 'refresh', texts: { label: 'Try again' } });
  }
  {
    const { x, y } = at(2, R3);
    label(ROOT, x, y - 60, '11 · Empty');
    const f = frame(ROOT, 'Desktop/11 Empty', x, y, W, H, C.background);
    topNav(f, 'My List');
    icon(f, 'list', W / 2 - 40, 340, 80, C.textDisabled, { stroke: 1.5 });
    text(f, 0, 460, 'Your list is empty', 'headline', { width: W, align: 'center' });
    text(f, 0, 512, 'Add movies and series to watch them later.', 'body', { color: C.textSecondary, width: W, align: 'center' });
    use('Button/Primary', f, W / 2 - 110, 590, { icon: 'film', texts: { label: 'Browse catalog' } });
  }

  // Prototype links
  safe('desktop flow', () => {
    link(S.splash, S.profiles, 'after-delay');
    (S.profileTiles || []).forEach((t) => link(t, S.home));
    link(S.homePlay, S.player);
    link(S.homeInfo, S.series);
    link(S.homePosters && S.homePosters[0], S.movie);
    link(S.homeSearch, S.search);
    link(S.moviePlay, S.player);
    link(S.seriesPlay, S.player);
    link(S.episodeRow, S.player);
    back(S.movieBack); back(S.seriesBack); back(S.playerBack);
    penpot.currentPage.createFlow('Desktop flow', S.splash);
  });
}

/* ------------------------------------------------------------------ */
/* Page: Mobile                                                        */
/* ------------------------------------------------------------------ */

function buildMobile() {
  const W = 390; const H = 844; const GAP = 120;
  const X = (i) => i * (W + GAP);
  const S = {};

  // 1. Splash
  {
    label(ROOT, X(0), -60, '1 · Splash');
    const f = frame(ROOT, 'Mobile/01 Splash', X(0), 0, W, H, C.background);
    ellipse(f, -60, 220, 510, 510, C.primary, { opacity: 0.14, blur: 90, name: 'glow' });
    text(f, 0, 370, 'HEAVEN', 'display', { size: 56, weight: 800, color: C.primary, width: W, align: 'center' });
    text(f, 0, 444, 'STREAMING', 'overline', { color: C.textSecondary, width: W, align: 'center' });
    icon(f, 'spinner', W / 2 - 16, 700, 32, C.primary, { stroke: 2.5 });
    S.splash = f.shape;
  }

  // 2. Home
  {
    label(ROOT, X(1), -60, '2 · Home');
    const f = frame(ROOT, 'Mobile/02 Home', X(1), 0, W, H, C.background);
    rect(f, 0, 0, W, 520, grad('#2A1050', C.background, 'down'), { name: 'ambient' });
    statusBar(f);
    logo(f, 16, 54, 24);
    icon(f, 'cast', W - 88, 56);
    S.search = icon(f, 'search', W - 44, 56);
    let cx = 16;
    ['Series', 'Movies', 'Categories'].forEach((c) => {
      use('Chip', f, cx, 100, { texts: { label: c } });
      cx += estW(c, 'label') + 44;
    });
    const hero = frame(f, 'Hero', 24, 152, W - 48, 470, null, { radius: 16, stroke: C.white, strokeOpacity: 0.12 });
    rect(hero, 0, 0, W - 48, 470, art(0), { name: 'art' });
    ellipse(hero, 120, 40, 200, 200, C.white, { opacity: 0.12, name: 'moon' });
    rect(hero, 0, 220, W - 48, 250, grad(C.scrim, C.scrim, 'down', 0, 0.9), { name: 'scrim' });
    text(hero, 0, 300, 'The Last Signal', 'headline', { width: W - 48, align: 'center', weight: 800 });
    text(hero, 0, 346, 'Ominous · Sci-Fi · Mystery · Thriller', 'caption', { width: W - 48, align: 'center', color: C.textPrimary });
    S.play = use('Button/Primary', hero, 16, 394, { w: 151, h: 44, padX: 0, texts: { label: 'Play' } });
    use('Button/Secondary', hero, 175, 394, { w: 151, h: 44, padX: 0, icon: 'plus', texts: { label: 'My List' } });
    text(f, 16, 640, 'Continue Watching', 'titleSm', { size: 18 });
    S.posters = [];
    for (let i = 0; i < 4; i++) S.posters.push(use('Card/Poster', f, 16 + i * 118, 676, { w: 110, h: 165, art: i + 1, texts: { title: TITLES[i + 1] } }));
    bottomNav(f, 'Home');
    S.home = f.shape;
  }

  // 3. Details
  {
    label(ROOT, X(2), -60, '3 · Title details');
    const f = frame(ROOT, 'Mobile/03 Details', X(2), 0, W, H, C.background);
    const v = frame(f, 'Preview', 0, 0, W, 264, C.scrim);
    rect(v, 0, 0, W, 264, art(0), { name: 'art', opacity: 0.85 });
    statusBar(v);
    S.detailsBack = icon(v, 'close', W - 44, 52, 24);
    icon(v, 'volume', W - 44, 224, 24);
    ellipse(v, W / 2 - 28, 104, 56, 56, C.scrim, { opacity: 0.5, stroke: C.white, strokeWidth: 2 });
    icon(v, 'play', W / 2 - 12, 120, 24);
    text(f, 16, 280, 'The Last Signal', 'title', { weight: 700 });
    metaRow(f, 16, 316, ['2026', { badge: '16+' }, '3 Seasons'], { match: '98%' });
    S.play = use('Button/Primary', f, 16, 352, { w: W - 32, h: 44, texts: { label: 'Play' } });
    use('Button/Secondary', f, 16, 404, { w: W - 32, h: 44, icon: 'download', texts: { label: 'Download S1:E1' } });
    text(f, 16, 464, 'When a forgotten radio telescope picks up a message addressed to her by name, an astronomer must decide whether to answer.', 'bodySm', { width: W - 32 });
    text(f, 16, 534, 'Starring: Lena Okafor, Tomás Reyes… more', 'caption', { color: C.textSecondary, width: W - 32 });
    [['plus', 'My List'], ['thumbUp', 'Rate'], ['share', 'Share']].forEach(([ic, l], i) => {
      icon(f, ic, 44 + i * 96, 574, 24);
      text(f, 20 + i * 96, 604, l, 'caption', { color: C.textSecondary, width: 72, align: 'center' });
    });
    rect(f, 0, 640, W, 1, C.border);
    rect(f, 16, 640, 80, 3, C.primary, { radius: 2 });
    text(f, 16, 652, 'Episodes', 'label');
    text(f, 120, 652, 'More Like This', 'label', { color: C.textSecondary });
    [['1. Pilot', '58m'], ['2. Dead Air', '52m']].forEach(([t, d], i) => {
      const y = 692 + i * 84;
      rect(f, 16, y, 128, 72, art(i + 2), { radius: 6 });
      icon(f, 'play', 68, y + 24, 24);
      text(f, 156, y + 14, t, 'label');
      text(f, 156, y + 36, d, 'caption', { color: C.textSecondary });
      icon(f, 'download', W - 40, y + 24, 24);
    });
    S.details = f.shape;
  }

  // 4. Search
  {
    label(ROOT, X(3), -60, '4 · Search');
    const f = frame(ROOT, 'Mobile/04 Search', X(3), 0, W, H, C.background);
    statusBar(f);
    S.searchBack = icon(f, 'back', 16, 58);
    use('Input/Search', f, 52, 50, { w: W - 68, h: 40, texts: { value: 'Search shows, movies…' } });
    text(f, 16, 112, 'Top Searches', 'titleSm', { size: 18 });
    for (let i = 0; i < 7; i++) {
      const y = 152 + i * 84;
      rect(f, 16, y, 136, 76, art(i + 3), { radius: 6 });
      text(f, 164, y + 28, TITLES[(i + 3) % TITLES.length], 'label', { width: 160 });
      ellipse(f, W - 52, y + 20, 36, 36, null, { stroke: C.textPrimary, strokeWidth: 1.5 });
      icon(f, 'play', W - 44, y + 28, 20);
    }
    bottomNav(f, 'Search');
    S.searchScreen = f.shape;
  }

  // 5. My List
  {
    label(ROOT, X(4), -60, '5 · My List');
    const f = frame(ROOT, 'Mobile/05 My List', X(4), 0, W, H, C.background);
    statusBar(f);
    text(f, 16, 56, 'My List', 'headline', { size: 28 });
    for (let i = 0; i < 12; i++) {
      const col = i % 3; const row = Math.floor(i / 3);
      use('Card/Poster', f, 16 + col * 124, 112 + row * 176, { w: 110, h: 165, art: i + 5, texts: { title: TITLES[(i + 5) % TITLES.length] } });
    }
    bottomNav(f, 'My List');
  }

  // 6. Player (landscape)
  {
    const PW = 844; const PH = 390;
    label(ROOT, X(5), -60, '6 · Player (landscape)');
    const f = frame(ROOT, 'Mobile/06 Player', X(5), 0, PW, PH, C.scrim);
    rect(f, 0, 0, PW, PH, art(0), { opacity: 0.7, name: 'video' });
    rect(f, 0, 0, PW, 96, grad(C.scrim, C.scrim, 'down', 0.8, 0));
    rect(f, 0, PH - 140, PW, 140, grad(C.scrim, C.scrim, 'down', 0, 0.9));
    S.playerBack = icon(f, 'back', 48, 24);
    text(f, 0, 26, 'S1:E3 · Into the Static', 'label', { width: PW, align: 'center' });
    icon(f, 'cast', PW - 72, 24);
    icon(f, 'rewind', PW / 2 - 132, PH / 2 - 20, 40);
    icon(f, 'pause', PW / 2 - 24, PH / 2 - 24, 48);
    icon(f, 'forward', PW / 2 + 92, PH / 2 - 20, 40);
    rect(f, 48, 300, PW - 160, 4, C.white, { opacity: 0.3, radius: 2 });
    rect(f, 48, 300, (PW - 160) * 0.38, 4, C.primary, { radius: 2 });
    ellipse(f, 48 + (PW - 160) * 0.38 - 7, 295, 14, 14, C.primary);
    text(f, PW - 100, 292, '30:28', 'caption', { width: 52, align: 'right' });
    [['settings', 'Speed (1x)'], ['list', 'Episodes'], ['subtitles', 'Audio & Subtitles'], ['nextEp', 'Next Ep.']].forEach(([ic, l], i) => {
      const x = 96 + i * 180;
      icon(f, ic, x, 334, 20);
      text(f, x + 28, 336, l, 'caption', { weight: 600 });
    });
    S.player = f.shape;
  }

  safe('mobile flow', () => {
    link(S.splash, S.home, 'after-delay');
    link(S.play, S.player);
    link(S.posters && S.posters[0], S.details);
    link(S.search, S.searchScreen);
    back(S.detailsBack); back(S.searchBack); back(S.playerBack);
    penpot.currentPage.createFlow('Mobile flow', S.splash);
  });
}

/* ------------------------------------------------------------------ */
/* Library: colors & typographies                                      */
/* ------------------------------------------------------------------ */

function buildLibrary() {
  for (const [name, hex, op] of SEMANTIC_COLORS) {
    safe(`color ${name}`, () => {
      const c = penpot.library.local.createColor();
      c.name = name.replace(' (70%)', '');
      c.path = 'semantic';
      c.color = hex;
      c.opacity = op ?? 1;
    });
  }
  for (const [name, hex] of PRIMITIVE_COLORS) {
    safe(`color ${name}`, () => {
      const [group, shade] = name.split('/');
      const c = penpot.library.local.createColor();
      c.name = `${group}-${shade}`;
      c.path = `primitives / ${group}`;
      c.color = hex;
    });
  }
  for (const [name, key] of TYPO_LIBRARY) {
    safe(`typography ${name}`, () => {
      const [size, weight, lh, ls] = T[key];
      const t = penpot.library.local.createTypography();
      t.name = name;
      t.path = 'heaven';
      if (INTER) {
        const v = INTER.variants.find((x) => x.fontWeight === String(weight) && x.fontStyle === 'normal');
        t.fontId = INTER.fontId;
        t.fontFamily = INTER.fontFamily;
        if (v) t.fontVariantId = v.fontVariantId;
      }
      t.fontWeight = String(weight);
      t.fontSize = String(size);
      t.lineHeight = String(lh);
      t.letterSpacing = String(ls);
      if (key === 'overline') t.textTransform = 'uppercase';
    });
  }
}

/* ------------------------------------------------------------------ */
/* Orchestration                                                       */
/* ------------------------------------------------------------------ */

async function openNewPage(name) {
  const page = penpot.createPage();
  page.name = name;
  penpot.openPage(page, false);
  for (let i = 0; i < 40; i++) {
    if (penpot.currentPage && penpot.currentPage.id === page.id) return true;
    await sleep(100);
  }
  return false;
}

async function step(name, fn) {
  log(`→ ${name}…`);
  await sleep(30);
  safe(name, fn);
}

async function generate() {
  INTER = penpot.fonts.findByName('Inter') || (penpot.fonts.findAllByName('Inter') || [])[0] || null;
  if (!INTER) log('⚠ Inter not found — using the default font.', 'warn');

  let offset = 0;
  const pageOrFallback = async (name, height) => {
    const ok = await openNewPage(name);
    if (!ok) {
      log(`⚠ Could not switch to page "${name}" — drawing it on the current page instead.`, 'warn');
      offset += height;
      ROOT.y = offset;
    } else {
      ROOT.y = 0;
    }
  };

  // Current page becomes the cover.
  safe('rename page', () => { penpot.currentPage.name = '00 · Cover'; });
  await step('Cover', buildCover);
  await step('Color & typography library', buildLibrary);

  await pageOrFallback('01 · Design System', 1300);
  await step('Design system', buildDesignSystem);

  await pageOrFallback('02 · Components', 1700);
  await step('Components', buildComponents);

  await pageOrFallback('03 · Desktop / TV', 1700);
  await step('Desktop / TV screens', buildDesktop);

  await pageOrFallback('04 · Mobile', 5600);
  await step('Mobile screens', buildMobile);

  log('✓ Done! Check the pages panel on the left.', 'ok');
}

penpot.ui.open('Heaven Streaming Template', `/ui.html?theme=${penpot.theme}`, { width: 340, height: 460 });

penpot.ui.onMessage(async (message) => {
  if (!message || typeof message !== 'object') return;
  if (message.type === 'generate') {
    try {
      await generate();
      penpot.ui.sendMessage({ type: 'done' });
    } catch (e) {
      log(`✗ ${e && e.message ? e.message : e}`, 'error');
      penpot.ui.sendMessage({ type: 'done', error: true });
    }
  }
  if (message.type === 'close') penpot.closePlugin();
});
