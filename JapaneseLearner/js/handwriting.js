(function() {
    'use strict';

    const TEMPLATE_SIZE = 64;
    const GRID = 8;
    const STORAGE_KEY = 'jp_handwriting_templates';

    let canvas = null;
    let ctx = null;
    let isDrawing = false;
    let strokes = [];
    let currentStroke = [];
    let dpr = 1;
    const kanaList = [];
    let fontFeatures = null;
    let userTemplates = [];

    function loadUserTemplates() {
        try {
            const raw = localStorage.getItem(STORAGE_KEY);
            if (raw) {
                const parsed = JSON.parse(raw.replace(/^\ufeff/, '').trim());
                userTemplates = parsed.map(function(t) { return { character: t.character, features: new Float64Array(t.features), created: t.created }; });
            } else {
                userTemplates = [];
            }
        } catch(e) {
            userTemplates = [];
        }
    }

    function saveUserTemplates() {
        try {
            const data = userTemplates.map(function(t) { return { character: t.character, features: Array.from(t.features), created: t.created }; });
            localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
        } catch(e) {
        }
    }

    function initCanvas(canvasId, width, height) {
        canvas = document.getElementById(canvasId);
        if (!canvas) return;
        dpr = window.devicePixelRatio || 1;
        const w = width || 280;
        const h = height || 280;
        canvas.style.width = w + 'px';
        canvas.style.height = h + 'px';
        canvas.width = w * dpr;
        canvas.height = h * dpr;
        ctx = canvas.getContext('2d');
        ctx.scale(dpr, dpr);
        ctx.strokeStyle = '#1d3557';
        ctx.lineWidth = 6;
        ctx.lineCap = 'round';
        ctx.lineJoin = 'round';
        strokes = [];
        currentStroke = [];
        canvas.addEventListener('pointerdown', onPointerDown);
        canvas.addEventListener('pointermove', onPointerMove);
        canvas.addEventListener('pointerup', onPointerUp);
        canvas.addEventListener('pointerleave', onPointerUp);
        loadUserTemplates();
    }

    function getPos(e) {
        var rect = canvas.getBoundingClientRect();
        return { x: e.clientX - rect.left, y: e.clientY - rect.top };
    }

    function onPointerDown(e) {
        isDrawing = true;
        var pos = getPos(e);
        currentStroke = [pos];
        ctx.beginPath();
        ctx.moveTo(pos.x, pos.y);
        canvas.setPointerCapture(e.pointerId);
    }

    function onPointerMove(e) {
        if (!isDrawing) return;
        var pos = getPos(e);
        currentStroke.push(pos);
        ctx.lineTo(pos.x, pos.y);
        ctx.stroke();
    }

    function onPointerUp(e) {
        if (!isDrawing) return;
        isDrawing = false;
        if (currentStroke.length > 0)
            strokes.push([].concat(currentStroke));
        currentStroke = [];
    }

    function clearCanvas() {
        if (!ctx || !canvas) return;
        ctx.clearRect(0, 0, canvas.width / dpr, canvas.height / dpr);
        strokes = [];
        currentStroke = [];
    }

    function undoLast() {
        if (strokes.length === 0) return;
        strokes.pop();
        redrawAll();
    }

    function redrawAll() {
        if (!ctx || !canvas) return;
        ctx.clearRect(0, 0, canvas.width / dpr, canvas.height / dpr);
        ctx.beginPath();
        for (var i = 0; i < strokes.length; i++) {
            var s = strokes[i];
            if (s.length === 0) continue;
            ctx.moveTo(s[0].x, s[0].y);
            for (var j = 1; j < s.length; j++)
                ctx.lineTo(s[j].x, s[j].y);
        }
        ctx.stroke();
    }

    function isEmpty() {
        return strokes.length === 0;
    }

    function hasLocalTemplates() {
        return userTemplates.length > 0;
    }

    function setKanaData(chars) {
        kanaList.length = 0;
        for (var i = 0; i < chars.length; i++)
            kanaList.push({ character: chars[i].character, type: chars[i].type });
        fontFeatures = null;
        buildFontFeatures();
    }

    function buildFontFeatures() {
        if (kanaList.length === 0) return;
        fontFeatures = {};
        for (var i = 0; i < kanaList.length; i++) {
            var k = kanaList[i];
            fontFeatures[k.character] = renderAndExtract(k.character);
        }
    }

    function renderAndExtract(char) {
        var c = document.createElement('canvas');
        c.width = TEMPLATE_SIZE;
        c.height = TEMPLATE_SIZE;
        var cx = c.getContext('2d');
        cx.fillStyle = '#ffffff';
        cx.fillRect(0, 0, TEMPLATE_SIZE, TEMPLATE_SIZE);
        cx.textAlign = 'center';
        cx.textBaseline = 'middle';
        cx.font = '48px "Noto Sans JP","Yu Gothic","Meiryo","MS Gothic",sans-serif';
        cx.fillStyle = '#000000';
        cx.fillText(char, TEMPLATE_SIZE / 2, TEMPLATE_SIZE / 2);
        return extractFeatures(cx.getImageData(0, 0, TEMPLATE_SIZE, TEMPLATE_SIZE));
    }

    function extractFeatures(imgData) {
        var cellW = TEMPLATE_SIZE / GRID;
        var cellH = TEMPLATE_SIZE / GRID;
        var feats = new Float64Array(GRID * GRID);
        var data = imgData.data;
        for (var row = 0; row < GRID; row++) {
            for (var col = 0; col < GRID; col++) {
                var sum = 0, cnt = 0;
                var y0 = row * cellH, y1 = (row + 1) * cellH;
                var x0 = col * cellW, x1 = (col + 1) * cellW;
                for (var y = y0; y < y1; y++) {
                    for (var x = x0; x < x1; x++) {
                        var off = (y * TEMPLATE_SIZE + x) * 4;
                        sum += 255 - data[off];
                        cnt++;
                    }
                }
                feats[row * GRID + col] = sum / (cnt * 255);
            }
        }
        return feats;
    }

    function cosineSim(a, b) {
        var dot = 0, na = 0, nb = 0;
        for (var i = 0; i < a.length; i++) {
            dot += a[i] * b[i];
            na += a[i] * a[i];
            nb += b[i] * b[i];
        }
        return dot / (Math.sqrt(na) * Math.sqrt(nb) + 1e-10);
    }

    function getUserFeatures() {
        if (!ctx || !canvas || strokes.length === 0) return null;

        var cw = canvas.width / dpr, ch = canvas.height / dpr;
        var minX = cw, minY = ch, maxX = 0, maxY = 0;
        for (var i = 0; i < strokes.length; i++) {
            var s = strokes[i];
            for (var j = 0; j < s.length; j++) {
                var px = s[j].x, py = s[j].y;
                if (px < minX) minX = px;
                if (py < minY) minY = py;
                if (px > maxX) maxX = px;
                if (py > maxY) maxY = py;
            }
        }

        var pad = 8;
        var sw = (maxX - minX) + pad * 2;
        var sh = (maxY - minY) + pad * 2;
        if (sw <= 0 || sh <= 0) return null;

        var scale = Math.min((TEMPLATE_SIZE - 4) / sw, (TEMPLATE_SIZE - 4) / sh, 1);

        var tc = document.createElement('canvas');
        tc.width = TEMPLATE_SIZE;
        tc.height = TEMPLATE_SIZE;
        var tctx = tc.getContext('2d');
        tctx.fillStyle = '#ffffff';
        tctx.fillRect(0, 0, TEMPLATE_SIZE, TEMPLATE_SIZE);
        tctx.save();
        tctx.scale(scale, scale);
        tctx.translate((TEMPLATE_SIZE / scale - sw) / 2 - minX + pad, (TEMPLATE_SIZE / scale - sh) / 2 - minY + pad);
        tctx.strokeStyle = '#000000';
        tctx.lineWidth = Math.max(6 / scale, 1.5);
        tctx.lineCap = 'round';
        tctx.lineJoin = 'round';
        tctx.beginPath();
        for (var i = 0; i < strokes.length; i++) {
            var s = strokes[i];
            if (s.length === 0) continue;
            tctx.moveTo(s[0].x, s[0].y);
            for (var j = 1; j < s.length; j++)
                tctx.lineTo(s[j].x, s[j].y);
        }
        tctx.stroke();
        tctx.restore();

        return extractFeatures(tctx.getImageData(0, 0, TEMPLATE_SIZE, TEMPLATE_SIZE));
    }

    function recognize(filterType) {
        var userFeats = getUserFeatures();
        if (!userFeats) {
            return JSON.stringify({ best: null, top3: [], scores: {} });
        }
        if (!fontFeatures || Object.keys(fontFeatures).length === 0) {
            buildFontFeatures();
        }

        var scores = {};
        for (var i = 0; i < kanaList.length; i++) {
            var ch = kanaList[i].character;
            if (filterType && kanaList[i].type !== filterType) continue;
            scores[ch] = cosineSim(userFeats, fontFeatures[ch]);
        }

        if (userTemplates.length > 0) {
            for (var i = 0; i < userTemplates.length; i++) {
                var ut = userTemplates[i];
                var sim = cosineSim(userFeats, ut.features);
                if (sim > (scores[ut.character] || 0))
                    scores[ut.character] = sim;
            }
        }

        var sorted = Object.entries(scores).sort(function(a, b) { return b[1] - a[1]; });

        var best = sorted.length > 0 ? sorted[0][0] : null;
        var bestScore = sorted.length > 0 ? sorted[0][1] : 0;
        var top3 = sorted.slice(0, 3).map(function(x) { return x[0]; });
        return JSON.stringify({ best: best, score: bestScore, top3: top3, scores: scores });
    }

    function saveUserTemplate(char) {
        var feats = getUserFeatures();
        if (!feats) return JSON.stringify({ ok: false, error: 'No drawing' });
        var entry = { character: char, features: feats, created: new Date().toISOString() };
        userTemplates.push(entry);
        saveUserTemplates();
        return JSON.stringify({ ok: true, total: userTemplates.length });
    }

    function deleteUserTemplate(index) {
        if (index < 0 || index >= userTemplates.length) return JSON.stringify({ ok: false, error: 'Invalid index' });
        var removed = userTemplates[index];
        userTemplates.splice(index, 1);
        saveUserTemplates();
        return JSON.stringify({ ok: true, total: userTemplates.length });
    }

    function deleteUserTemplatesForChar(char) {
        var before = userTemplates.length;
        userTemplates = userTemplates.filter(function(t) { return t.character !== char; });
        if (userTemplates.length < before) {
            saveUserTemplates();
        }
        return JSON.stringify({ ok: true, total: userTemplates.length });
    }

    function clearUserTemplates() {
        userTemplates = [];
        localStorage.removeItem(STORAGE_KEY);
        return JSON.stringify({ ok: true, total: 0 });
    }

    function getUserTemplateInfo() {
        var byChar = {};
        for (var i = 0; i < userTemplates.length; i++) {
            var ch = userTemplates[i].character;
            if (!byChar[ch]) byChar[ch] = 0;
            byChar[ch]++;
        }
        return JSON.stringify({ total: userTemplates.length, byChar: byChar });
    }

    function exportUserTemplates() {
        var data = userTemplates.map(function(t) {
            return { character: t.character, features: Array.from(t.features), created: t.created };
        });
        return JSON.stringify(data);
    }

    function importUserTemplates(json) {
        try {
            var clean = json.replace(/^\ufeff/, '').trim();
            var parsed = JSON.parse(clean);
            if (!Array.isArray(parsed)) return JSON.stringify({ ok: false, error: 'Invalid format' });
            var count = 0;
            for (var i = 0; i < parsed.length; i++) {
                var t = parsed[i];
                if (t.character && t.features && Array.isArray(t.features)) {
                    userTemplates.push({
                        character: t.character,
                        features: new Float64Array(t.features),
                        created: t.created || new Date().toISOString()
                    });
                    count++;
                }
            }
            saveUserTemplates();
            return JSON.stringify({ ok: true, count: count, total: userTemplates.length });
        } catch(e) {
            return JSON.stringify({ ok: false, error: e.message });
        }
    }

    function loadSeedFile(json) {
        try {
            var clean = json.replace(/^\ufeff/, '').trim();
            var parsed = JSON.parse(clean);
            if (!Array.isArray(parsed) || parsed.length === 0) return JSON.stringify({ ok: false, error: 'Empty' });
            userTemplates = parsed.map(function(t) {
                return { character: t.character, features: new Float64Array(t.features), created: t.created || new Date().toISOString() };
            });
            saveUserTemplates();
            return JSON.stringify({ ok: true, count: userTemplates.length });
        } catch(e) {
            return JSON.stringify({ ok: false, error: e.message });
        }
    }

    window.JapaneseHandwriting = {
        initCanvas: initCanvas,
        clearCanvas: clearCanvas,
        undoLast: undoLast,
        isEmpty: isEmpty,
        hasLocalTemplates: hasLocalTemplates,
        recognize: recognize,
        setKanaData: setKanaData,
        saveUserTemplate: saveUserTemplate,
        deleteUserTemplate: deleteUserTemplate,
        deleteUserTemplatesForChar: deleteUserTemplatesForChar,
        clearUserTemplates: clearUserTemplates,
        getUserTemplateInfo: getUserTemplateInfo,
        exportUserTemplates: exportUserTemplates,
        importUserTemplates: importUserTemplates,
        loadSeedFile: loadSeedFile,
        clickInput: function(el) { if (el) el.click(); },
        readFileText: function(el) {
            return new Promise(function(resolve) {
                if (!el || !el.files || !el.files[0]) { resolve(null); return; }
                var reader = new FileReader();
                reader.onload = function() { resolve(reader.result); };
                reader.readAsText(el.files[0]);
            });
        }
    };
})();
