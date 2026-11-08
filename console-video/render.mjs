// Renders index.html frame by frame (deterministic: window.render(t)) with Chrome and pipes PNGs into ffmpeg.
// Usage: node render.mjs <out.mp4>                      full video, 1920x1080, 30 fps
//        node render.mjs --stills <dir> <t1,t2,...>     PNG stills at those seconds (for checking)
// Needs: node, ffmpeg on PATH, Chrome, and the `playwright` package (set PLAYWRIGHT_DIR to its node_modules folder).
import http from "node:http"; import fs from "node:fs"; import path from "node:path"; import { spawn } from "node:child_process"; import { createRequire } from "node:module"; import { fileURLToPath } from "node:url";
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const { chromium } = createRequire(path.join(process.env.PLAYWRIGHT_DIR || "node_modules", "x.js"))("playwright");
const mime = { ".html": "text/html; charset=utf-8", ".svg": "image/svg+xml", ".woff2": "font/woff2", ".js": "text/javascript" };
const server = http.createServer((q, r) => {
  const f = path.join(root, decodeURIComponent(q.url.split("?")[0]));
  if (!f.startsWith(root) || !fs.existsSync(f)) { r.writeHead(404); return r.end(); }
  r.writeHead(200, { "content-type": mime[path.extname(f)] || "application/octet-stream" }); fs.createReadStream(f).pipe(r);
}).listen(0, "127.0.0.1");
await new Promise(r => server.on("listening", r));
const browser = await chromium.launch({ channel: "chrome" });
const page = await browser.newPage({ viewport: { width: 1920, height: 1080 }, deviceScaleFactor: 1 });
await page.goto(`http://127.0.0.1:${server.address().port}/console-video/index.html`);
await page.evaluate(() => document.fonts.ready);
const [a, b, c] = process.argv.slice(2);
if (a === "--stills") {
  fs.mkdirSync(b, { recursive: true });
  for (const t of c.split(",")) { await page.evaluate(t => render(t), +t); await page.screenshot({ path: path.join(b, `t${String(t).padStart(5, "0")}.png`) }); }
} else {
  const { total, fps } = await page.evaluate(() => ({ total: TOTAL, fps: FPS }));
  const ff = spawn("ffmpeg", ["-y", "-loglevel", "error", "-f", "image2pipe", "-framerate", String(fps), "-i", "-", "-c:v", "libx264", "-preset", "slow", "-crf", "15", "-pix_fmt", "yuv420p", "-movflags", "+faststart", a], { stdio: ["pipe", "inherit", "inherit"] });
  for (let f = 0; f < total * fps; f++) {
    await page.evaluate(t => render(t), f / fps);
    if (!ff.stdin.write(await page.screenshot({ type: "png" }))) await new Promise(r => ff.stdin.once("drain", r));
    if (f % 150 === 0) console.log("frame", f, "/", total * fps);
  }
  ff.stdin.end(); await new Promise(r => ff.on("close", r));
}
await browser.close(); server.close();
