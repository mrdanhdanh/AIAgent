/* ============================================================
   Long Vân — Dragon-website template
   script.js: ScrollEngine + DragonRenderer (Catmull-Rom spline)
   + StateMachine (IDLE|SCROLL|ESCAPE|SLEEP) + EscapeSequence
   + SleepSequence. Vanilla JS, không dependency.
   ============================================================ */
(function () {
  'use strict';

  /* ---------- DOM ---------- */
  var layer  = document.getElementById('dragon-layer');
  var outer  = document.getElementById('dragon-outer');
  var hit    = document.getElementById('dragon-hit');

  /* ---------- Config ---------- */
  var LERP      = 0.12;   // độ mượt scroll follow (F3)
  var SLEEP_IN  = 0.97;   // p >= → ngủ
  var SLEEP_OUT = 0.90;   // p <= → thức dậy (hysteresis)
  var ESC_DUR   = 1600;   // ms — thời gian escape sequence

  /* Waypoints dạng phần trăm viewport — uốn lượn bao bọc container (F2) */
  var WAYPOINTS = [
    { x: 0.50, y: 0.22 },  // hero — bay lượn đầu trang (F1)
    { x: 0.16, y: 0.38 },  // lướt sang mép trái
    { x: 0.84, y: 0.52 },  // vòng qua mép phải
    { x: 0.18, y: 0.66 },  // lại sang trái
    { x: 0.82, y: 0.80 },  // lại sang phải
    { x: 0.62, y: 0.90 },  // tiến về góc
    { x: 0.86, y: 0.92 }   // góc phải dưới — nơi ngủ (F5)
  ];

  /* ---------- State ---------- */
  var state = 'SCROLL';        // IDLE | SCROLL | ESCAPE | SLEEP
  var targetP = 0;             // scroll progress thô
  var smoothP = 0;             // scroll progress đã làm mượt
  var sleeping = false;        // đang trong trạng thái ngủ
  var escape = null;           // { t0, ret:{x,y,rot,scale} }
  var size = { w: 500, h: 225 };
  var cur = { x: 0, y: 0, rot: 0, scale: 0.9 };

  /* Expose state để test/debug (data-state trên layer) */
  function setState(s) {
    state = s;
    layer.setAttribute('data-state', s);
  }

  /* ---------- Utils ---------- */
  function clamp(v, a, b) { return v < a ? a : v > b ? b : v; }
  function lerp(a, b, t) { return a + (b - a) * t; }
  function easeOutQuad(t) { return 1 - (1 - t) * (1 - t); }
  function easeInOutCubic(t) {
    return t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2;
  }

  /* Catmull-Rom spline: điểm trên đường cong tại t ∈ [0,1] */
  function catmullRom(pts, t) {
    var n = pts.length;
    if (n === 1) return pts[0];
    var seg = t * (n - 1);
    var i = Math.min(Math.floor(seg), n - 2);
    var u = seg - i;
    var p0 = pts[Math.max(i - 1, 0)];
    var p1 = pts[i];
    var p2 = pts[i + 1];
    var p3 = pts[Math.min(i + 2, n - 1)];
    var u2 = u * u, u3 = u2 * u;
    return {
      x: 0.5 * ((2 * p1.x) + (-p0.x + p2.x) * u +
        (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * u2 +
        (-p0.x + 3 * p1.x - 3 * p2.x + p3.x) * u3),
      y: 0.5 * ((2 * p1.y) + (-p0.y + p2.y) * u +
        (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * u2 +
        (-p0.y + 3 * p1.y - 3 * p2.y + p3.y) * u3)
    };
  }

  /* ---------- Progress ---------- */
  function getProgress() {
    var doc = document.documentElement;
    var max = doc.scrollHeight - window.innerHeight;
    if (max <= 0) return 0;
    return clamp(window.pageYOffset / max, 0, 1);
  }

  /* ---------- Path transform (SCROLL) ---------- */
  function pathTransform(p) {
    var vw = window.innerWidth, vh = window.innerHeight;
    var wp = WAYPOINTS.map(function (w) { return { x: w.x * vw, y: w.y * vh }; });
    var pt = catmullRom(wp, p);
    var pt2 = catmullRom(wp, Math.min(p + 0.002, 1));
    var dx = pt2.x - pt.x, dy = pt2.y - pt.y;
    var rot = Math.atan2(dy, dx) * 180 / Math.PI;
    var s = Math.min(1, vw / 1500) * 0.9;   // scale theo viewport
    return { x: pt.x, y: pt.y, rot: rot, scale: s };
  }

  /* ---------- Sleep transform (F5) ---------- */
  function sleepTransform() {
    var vw = window.innerWidth, vh = window.innerHeight;
    var s = Math.min(1, vw / 1500) * 0.5;
    return {
      x: vw - 130,
      y: vh - 110,
      rot: -35,
      scale: s
    };
  }

  /* ---------- Escape sequence (F4) ---------- */
  function escapeTransform(t, ret) {
    var dir = { x: 0.5, y: -1 };
    var dl = Math.hypot(dir.x, dir.y);
    dir.x /= dl; dir.y /= dl;

    var burst = 150, R = 130;
    var lx = ret.x + dir.x * burst;
    var ly = ret.y + dir.y * burst;
    var x, y, rot, scale;

    if (t <= 0.30) {                       // T1: thoát ra
      var k1 = t / 0.30;
      var e1 = easeOutQuad(k1);
      x = ret.x + dir.x * burst * e1;
      y = ret.y + dir.y * burst * e1;
      rot = ret.rot + 20 * e1;
      scale = ret.scale * (1 + 0.12 * e1);
    } else if (t <= 0.72) {                // T2: vòng bay lượn
      var k2 = (t - 0.30) / 0.42;
      var a = k2 * Math.PI * 2;
      x = lx + Math.cos(a) * R;
      y = ly + Math.sin(a) * R * 0.9;
      rot = ret.rot + 360 * k2;
      scale = ret.scale * 1.12;
    } else {                               // T3: quay về vị trí cũ
      var k3 = (t - 0.72) / 0.28;
      var e3 = easeInOutCubic(k3);
      x = lerp(lx + R, ret.x, e3);
      y = lerp(ly, ret.y, e3);
      rot = lerp(ret.rot + 360, ret.rot, e3);
      scale = lerp(ret.scale * 1.12, ret.scale, e3);
    }
    return { x: x, y: y, rot: rot, scale: scale };
  }

  /* ---------- Measure ---------- */
  function measure() {
    size.w = outer.offsetWidth || 500;
    size.h = outer.offsetHeight || size.w * 360 / 800;
  }

  /* ---------- Apply transform ---------- */
  function applyTransform(t) {
    var cx = t.x - size.w / 2;
    var cy = t.y - size.h / 2;
    outer.style.transform =
      'translate3d(' + cx.toFixed(1) + 'px,' + cy.toFixed(1) + 'px,0) ' +
      'rotate(' + t.rot.toFixed(2) + 'deg) scale(' + t.scale.toFixed(3) + ')';
  }

  /* ---------- Main loop ---------- */
  function tick(now) {
    var target = null;

    if (state === 'ESCAPE' && escape) {
      var t = clamp((now - escape.t0) / ESC_DUR, 0, 1);
      target = escapeTransform(t, escape.ret);
      if (t >= 1) { setState('SCROLL'); escape = null; }
    } else {
      targetP = getProgress();

      // hysteresis ngủ/thức (F5)
      if (!sleeping && targetP >= SLEEP_IN) {
        sleeping = true;
        layer.classList.add('sleeping');
      } else if (sleeping && targetP <= SLEEP_OUT) {
        sleeping = false;
        layer.classList.remove('sleeping');
      }

      smoothP += (targetP - smoothP) * LERP;
      if (Math.abs(targetP - smoothP) < 0.0005) smoothP = targetP;

      target = sleeping ? sleepTransform() : pathTransform(smoothP);
    }

    // lerp từng thuộc tính để chuyển động mượt (F3)
    var f = state === 'ESCAPE' ? 0.35 : LERP;
    cur.x = lerp(cur.x, target.x, f);
    cur.y = lerp(cur.y, target.y, f);
    cur.rot = lerp(cur.rot, target.rot, f);
    cur.scale = lerp(cur.scale, target.scale, f);
    applyTransform(cur);

    requestAnimationFrame(tick);
  }

  /* ---------- Click escape (F4) ---------- */
  function onHitClick(e) {
    e.preventDefault();
    if (state === 'ESCAPE' || sleeping) return;
    setState('ESCAPE');
    escape = {
      t0: performance.now(),
      ret: { x: cur.x, y: cur.y, rot: cur.rot, scale: cur.scale }
    };
  }

  /* ---------- Init ---------- */
  measure();
  window.addEventListener('resize', measure);
  window.addEventListener('scroll', function () { targetP = getProgress(); }, { passive: true });
  hit.addEventListener('click', onHitClick);
  hit.addEventListener('touchstart', onHitClick, { passive: true });

  // Khởi tạo ở vị trí đầu trang
  cur = pathTransform(0);
  applyTransform(cur);
  requestAnimationFrame(tick);
})();
