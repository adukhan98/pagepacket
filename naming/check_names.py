#!/usr/bin/env python3
import html
import json
import socket
import subprocess
import time
import urllib.error
import urllib.parse
import urllib.request
from datetime import datetime, timezone
from pathlib import Path


OUT = Path(__file__).with_name("project-name-sheet.html")
BOOTSTRAP_URL = "https://data.iana.org/rdap/dns.json"
USER_AGENT = "GraftNameCheck/1.0 (+local availability research)"
REQUEST_DELAY = 0.8
TIKTOK_DELAY = 1.2

NAMES = [
    "Draftlane",
    "Patchmark",
    "Filegrail",
    "Linekeep",
    "Quillrail",
    "Noteforge",
    "Diffdeck",
    "Textloom",
    "Reviewly",
    "Marknest",
    "Editrail",
    "Draftwell",
    "Patchpad",
    "Linewise",
    "Filewise",
    "Docloom",
    "Quillbase",
    "Markpilot",
    "Draftgrid",
    "Patchworkr",
    "Noterail",
    "Textpatch",
    "Reviewpad",
    "Linegraft",
    "Filebranch",
    "Draftfold",
    "Editpacket",
    "Markloop",
    "Quilldiff",
    "Docreview",
    "Patchlane",
    "Linepacket",
    "Notekeep",
    "Draftpacket",
    "Filepacket",
    "Marksmith",
    "Diffrail",
    "Textkeeper",
    "Reviewrail",
    "Pagepacket",
    "Patchbook",
    "Draftbranch",
    "Quillpacket",
    "Docbranch",
    "Lineforge",
    "Markreview",
    "Filedraft",
    "Editloom",
    "Patchpilot",
    "Draftmark",
]

TLDS = ["com", "io", "ai", "dev"]


def slug(name):
    return "".join(ch for ch in name.lower() if ch.isalnum() or ch == "-")


def request(url, method="GET", timeout=15):
    req = urllib.request.Request(
        url,
        method=method,
        headers={
            "User-Agent": USER_AGENT,
            "Accept": "application/json,text/html;q=0.9,*/*;q=0.8",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            body = resp.read(400000)
            return resp.status, body, dict(resp.headers)
    except urllib.error.HTTPError as exc:
        body = exc.read(400000)
        return exc.code, body, dict(exc.headers)
    except (urllib.error.URLError, TimeoutError, socket.timeout) as exc:
        return None, str(exc).encode("utf-8", "replace"), {}


def load_rdap_bootstrap():
    status, body, _ = request(BOOTSTRAP_URL)
    if status != 200:
        raise RuntimeError(f"Could not load IANA RDAP bootstrap: HTTP {status}")
    data = json.loads(body.decode("utf-8"))
    servers = {}
    for tlds, urls in data.get("services", []):
        for tld in tlds:
            if urls:
                servers[tld.lower()] = urls
    return servers


def rdap_domain(domain, servers):
    tld = domain.rsplit(".", 1)[1].lower()
    urls = servers.get(tld)
    if not urls:
        return dns_domain(domain)

    last_note = ""
    for base in urls:
        base = base.rstrip("/")
        url = f"{base}/domain/{urllib.parse.quote(domain)}"
        status, body, _ = request(url)
        time.sleep(REQUEST_DELAY)
        if status == 200:
            return {
                "state": "taken",
                "label": "taken",
                "confidence": "high",
                "method": "registry RDAP",
                "http": 200,
                "note": base,
            }
        if status == 404:
            return {
                "state": "free",
                "label": "likely free",
                "confidence": "high",
                "method": "registry RDAP",
                "http": 404,
                "note": base,
            }
        if status == 429:
            return blank("registry RDAP", 429, "rate limited")
        last_note = body.decode("utf-8", "replace")[:160]

    return blank("registry RDAP", None, last_note)


def dns_domain(domain):
    method = "DNS NXDOMAIN"
    try:
        proc = subprocess.run(
            ["dig", "+time=3", "+tries=1", "+comments", domain, "A"],
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=6,
        )
        text = proc.stdout + proc.stderr
        if "status: NXDOMAIN" in text:
            return {
                "state": "free",
                "label": "likely free",
                "confidence": "low",
                "method": method,
                "http": "",
                "note": "No RDAP bootstrap server; DNS returned NXDOMAIN",
            }
        if "status: NOERROR" in text:
            return {
                "state": "taken",
                "label": "dns seen",
                "confidence": "low",
                "method": method,
                "http": "",
                "note": "No RDAP bootstrap server; DNS did not return NXDOMAIN",
            }
        return blank(method, "", "DNS check inconclusive")
    except Exception as exc:
        try:
            socket.getaddrinfo(domain, None)
            return {
                "state": "taken",
                "label": "dns seen",
                "confidence": "low",
                "method": method,
                "http": "",
                "note": f"socket fallback after dig failed: {exc}",
            }
        except socket.gaierror:
            return {
                "state": "free",
                "label": "likely free",
                "confidence": "low",
                "method": method,
                "http": "",
                "note": f"socket fallback after dig failed: {exc}",
            }


def github_handle(handle):
    url = f"https://github.com/{handle}"
    status, body, _ = request(url, timeout=15)
    time.sleep(REQUEST_DELAY)
    if status == 200:
        return {
            "state": "taken",
            "label": "taken",
            "confidence": "high",
            "method": "GitHub web",
            "http": 200,
            "note": url,
        }
    if status == 404:
        return {
            "state": "free",
            "label": "likely free",
            "confidence": "high",
            "method": "GitHub web",
            "http": 404,
            "note": url,
        }
    if status == 429:
        return blank("GitHub web", 429, "rate limited")
    return blank("GitHub web", status, body.decode("utf-8", "replace")[:160])


def tiktok_handle(handle):
    url = f"https://www.tiktok.com/@{handle}"
    status, body, _ = request(url, timeout=15)
    time.sleep(TIKTOK_DELAY)
    text = body.decode("utf-8", "replace").lower()
    not_found_markers = [
        "couldn't find this account",
        "couldn\u2019t find this account",
        "could not find this account",
        "this account doesn't exist",
        "user not found",
    ]
    if status == 404:
        return {
            "state": "free",
            "label": "likely free",
            "confidence": "low",
            "method": "TikTok web heuristic",
            "http": 404,
            "note": url,
        }
    if status == 200 and any(marker in text for marker in not_found_markers):
        return {
            "state": "free",
            "label": "likely free",
            "confidence": "low",
            "method": "TikTok web heuristic",
            "http": 200,
            "note": "not-found marker in page",
        }
    if status == 200:
        return {
            "state": "taken",
            "label": "seen",
            "confidence": "low",
            "method": "TikTok web heuristic",
            "http": 200,
            "note": url,
        }
    if status == 429:
        return blank("TikTok web heuristic", 429, "rate limited")
    return blank("TikTok web heuristic", status, "ambiguous TikTok response")


def x_handle(_handle):
    return {
        "state": "manual",
        "label": "manual-check",
        "confidence": "manual",
        "method": "manual-check",
        "http": "",
        "note": "X cloaks availability; not scored",
    }


def blank(method, http="", note=""):
    return {
        "state": "",
        "label": "",
        "confidence": "",
        "method": method,
        "http": http,
        "note": note,
    }


def score_row(row):
    weights = {"com": 45, "io": 15, "ai": 14, "dev": 12}
    score = 0.0
    for tld, weight in weights.items():
        cell = row["domains"][tld]
        if cell["state"] == "free":
            score += weight if cell["confidence"] == "high" else weight * 0.5
    if row["github"]["state"] == "free":
        score += 8
    if row["tiktok"]["state"] == "free":
        score += 4 if row["tiktok"]["confidence"] == "high" else 2
    return round(score, 1)


def status_for(row):
    com = row["domains"]["com"]
    high_free_domains = [
        tld
        for tld, cell in row["domains"].items()
        if cell["state"] == "free" and cell["confidence"] == "high"
    ]
    low_free_domains = [
        tld
        for tld, cell in row["domains"].items()
        if cell["state"] == "free" and cell["confidence"] == "low"
    ]
    if com["state"] == "free" and com["confidence"] == "high" and row["github"]["state"] == "free":
        return "best survivor"
    if com["state"] == "free" and com["confidence"] == "high":
        return "domain survivor"
    if high_free_domains:
        return "fallback domain"
    if low_free_domains:
        return "low-confidence only"
    if any(cell["state"] == "" for cell in row["domains"].values()):
        return "incomplete"
    return "weak"


def recheck_survivors(rows, servers):
    survivors = [
        row
        for row in rows
        if any(
            cell["state"] == "free" and cell["confidence"] == "high"
            for cell in row["domains"].values()
        )
    ]
    print(f"rechecking {len(survivors)} RDAP survivors", flush=True)
    for row in survivors:
        for tld, cell in list(row["domains"].items()):
            if cell["state"] == "free" and cell["confidence"] == "high":
                domain = f"{row['handle']}.{tld}"
                row["domains"][tld] = rdap_domain(domain, servers)
                row["domains"][tld]["note"] += "; rechecked survivor"


def cell_class(cell):
    if cell["state"] == "free":
        return "free low" if cell["confidence"] == "low" else "free"
    if cell["state"] == "taken":
        return "taken low" if cell["confidence"] == "low" else "taken"
    if cell["state"] == "manual":
        return "manual"
    return "blank"


def cell_text(cell):
    if not cell["label"]:
        return ""
    suffix = ""
    if cell["confidence"] == "low":
        suffix = " (low)"
    if cell["confidence"] == "manual":
        suffix = ""
    return f"{cell['label']}{suffix}"


def render(rows, started_at, finished_at):
    rows = sorted(rows, key=lambda row: (-row["score"], row["name"].lower()))
    payload = json.dumps(rows, indent=2)
    generated = finished_at.strftime("%Y-%m-%d %H:%M:%S %Z")
    body_rows = []
    for row in rows:
        cells = [
            f"<td class='name'><span>{html.escape(row['name'])}</span><small>{html.escape(row['handle'])}</small></td>"
        ]
        for tld in TLDS:
            cell = row["domains"][tld]
            title = html.escape(f"{cell['method']} HTTP {cell['http']} - {cell['note']}")
            cells.append(
                f"<td class='{cell_class(cell)}' title='{title}'>{html.escape(cell_text(cell))}</td>"
            )
        for key in ["x", "github", "tiktok"]:
            cell = row[key]
            title = html.escape(f"{cell['method']} HTTP {cell['http']} - {cell['note']}")
            cells.append(
                f"<td class='{cell_class(cell)}' title='{title}'>{html.escape(cell_text(cell))}</td>"
            )
        cells.append(f"<td class='score' data-value='{row['score']}'>{row['score']}</td>")
        cells.append(f"<td class='status'>{html.escape(row['status'])}</td>")
        body_rows.append("<tr>" + "".join(cells) + "</tr>")

    return f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Project Name Availability Sheet</title>
  <style>
    :root {{
      color-scheme: light;
      --ink: #1f2420;
      --muted: #687168;
      --line: #d8ded4;
      --paper: #fbfaf4;
      --panel: #ffffff;
      --green-bg: #dff3e4;
      --green-ink: #155c2d;
      --red-bg: #f8d8d4;
      --red-ink: #84261f;
      --amber-bg: #f6ecd0;
      --amber-ink: #765316;
      --blank-bg: #f3f1ea;
    }}
    * {{ box-sizing: border-box; }}
    body {{
      margin: 0;
      background: var(--paper);
      color: var(--ink);
      font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      line-height: 1.35;
    }}
    main {{
      width: min(1500px, calc(100vw - 32px));
      margin: 24px auto 40px;
    }}
    header {{
      display: grid;
      grid-template-columns: 1fr auto;
      gap: 16px;
      align-items: end;
      margin-bottom: 16px;
    }}
    h1 {{
      margin: 0 0 4px;
      font-size: clamp(24px, 4vw, 42px);
      letter-spacing: 0;
    }}
    p {{
      margin: 0;
      color: var(--muted);
      max-width: 920px;
    }}
    .meta {{
      text-align: right;
      font-size: 13px;
      color: var(--muted);
      white-space: nowrap;
    }}
    .toolbar {{
      display: flex;
      gap: 10px;
      align-items: center;
      margin: 14px 0;
    }}
    input {{
      width: min(420px, 100%);
      border: 1px solid var(--line);
      border-radius: 8px;
      padding: 10px 12px;
      background: var(--panel);
      color: var(--ink);
      font: inherit;
    }}
    .legend {{
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin-left: auto;
      color: var(--muted);
      font-size: 12px;
    }}
    .chip {{
      border: 1px solid var(--line);
      border-radius: 999px;
      padding: 5px 8px;
      background: var(--panel);
    }}
    .wrap {{
      overflow: auto;
      border: 1px solid var(--line);
      background: var(--panel);
    }}
    table {{
      width: 100%;
      border-collapse: collapse;
      min-width: 1060px;
    }}
    th, td {{
      border-bottom: 1px solid var(--line);
      border-right: 1px solid var(--line);
      padding: 10px 12px;
      text-align: left;
      font-size: 14px;
      vertical-align: middle;
    }}
    th {{
      position: sticky;
      top: 0;
      z-index: 1;
      background: #eeefe7;
      color: #2f352f;
      cursor: pointer;
      user-select: none;
      font-size: 12px;
      text-transform: uppercase;
      letter-spacing: 0;
    }}
    tr:hover td {{ background-image: linear-gradient(rgba(0,0,0,0.025), rgba(0,0,0,0.025)); }}
    td.name span {{
      display: block;
      font-weight: 750;
      font-size: 15px;
    }}
    td.name small {{
      display: block;
      color: var(--muted);
      font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
      font-size: 12px;
      margin-top: 2px;
    }}
    td.free {{ background: var(--green-bg); color: var(--green-ink); font-weight: 700; }}
    td.taken {{ background: var(--red-bg); color: var(--red-ink); font-weight: 700; }}
    td.low {{ background-image: repeating-linear-gradient(135deg, rgba(255,255,255,0.35) 0 6px, rgba(255,255,255,0) 6px 12px); }}
    td.manual {{ background: var(--amber-bg); color: var(--amber-ink); font-weight: 700; }}
    td.blank {{ background: var(--blank-bg); color: var(--muted); }}
    td.score {{
      font-variant-numeric: tabular-nums;
      font-weight: 800;
    }}
    td.status {{
      color: #2f352f;
      font-weight: 650;
    }}
    script[type="application/json"] {{ display: none; }}
    @media (max-width: 800px) {{
      main {{ width: calc(100vw - 20px); margin-top: 14px; }}
      header {{ grid-template-columns: 1fr; }}
      .meta {{ text-align: left; white-space: normal; }}
      .toolbar {{ align-items: stretch; flex-direction: column; }}
      .legend {{ margin-left: 0; }}
    }}
  </style>
</head>
<body>
<main>
  <header>
    <div>
      <h1>Project Name Availability Sheet</h1>
      <p>50 Graft-style name candidates checked with real lookups. Domains use IANA RDAP bootstrap and registry RDAP where available; no-RDAP TLDs fall back to DNS NXDOMAIN and are marked low-confidence. X is manual-check by design.</p>
    </div>
    <div class="meta">
      <div>Generated: {html.escape(generated)}</div>
      <div>Rows: {len(rows)}</div>
    </div>
  </header>
  <div class="toolbar">
    <input id="filter" type="search" placeholder="filter names or statuses">
    <div class="legend">
      <span class="chip">green = likely free</span>
      <span class="chip">red = taken / seen</span>
      <span class="chip">stripe = low confidence</span>
      <span class="chip">blank = ambiguous</span>
    </div>
  </div>
  <div class="wrap">
    <table id="sheet">
      <thead>
        <tr>
          <th data-type="text">name</th>
          <th data-type="text">.com</th>
          <th data-type="text">.io</th>
          <th data-type="text">.ai</th>
          <th data-type="text">.dev</th>
          <th data-type="text">x</th>
          <th data-type="text">github</th>
          <th data-type="text">tiktok</th>
          <th data-type="number">score</th>
          <th data-type="text">status</th>
        </tr>
      </thead>
      <tbody>
        {''.join(body_rows)}
      </tbody>
    </table>
  </div>
</main>
<script id="raw-data" type="application/json">{html.escape(payload)}</script>
<script>
  const table = document.getElementById('sheet');
  const tbody = table.tBodies[0];
  const filter = document.getElementById('filter');
  let sortState = {{ index: 8, dir: -1 }};

  function value(row, index, type) {{
    const cell = row.cells[index];
    if (type === 'number') return Number(cell.dataset.value || cell.textContent.trim() || 0);
    return cell.textContent.trim().toLowerCase();
  }}

  function sortBy(index, type) {{
    const dir = sortState.index === index ? -sortState.dir : (type === 'number' ? -1 : 1);
    sortState = {{ index, dir }};
    const rows = Array.from(tbody.rows);
    rows.sort((a, b) => {{
      const av = value(a, index, type);
      const bv = value(b, index, type);
      if (av < bv) return -1 * dir;
      if (av > bv) return 1 * dir;
      return 0;
    }});
    rows.forEach(row => tbody.appendChild(row));
  }}

  Array.from(table.tHead.rows[0].cells).forEach((th, index) => {{
    th.addEventListener('click', () => sortBy(index, th.dataset.type));
  }});

  filter.addEventListener('input', () => {{
    const query = filter.value.trim().toLowerCase();
    Array.from(tbody.rows).forEach(row => {{
      row.style.display = row.textContent.toLowerCase().includes(query) ? '' : 'none';
    }});
  }});
</script>
</body>
</html>
"""


def main():
    started_at = datetime.now(timezone.utc)
    servers = load_rdap_bootstrap()
    rows = []

    for index, name in enumerate(NAMES, start=1):
        handle = slug(name)
        print(f"[{index:02d}/{len(NAMES)}] checking {name}", flush=True)
        domains = {}
        for tld in TLDS:
            domain = f"{handle}.{tld}"
            domains[tld] = rdap_domain(domain, servers)

        row = {
            "name": name,
            "handle": handle,
            "domains": domains,
            "x": x_handle(handle),
            "github": github_handle(handle),
            "tiktok": tiktok_handle(handle),
        }
        row["score"] = score_row(row)
        row["status"] = status_for(row)
        rows.append(row)

    recheck_survivors(rows, servers)
    for row in rows:
        row["score"] = score_row(row)
        row["status"] = status_for(row)

    finished_at = datetime.now(timezone.utc)
    OUT.write_text(render(rows, started_at, finished_at), encoding="utf-8")
    print(f"wrote {OUT}", flush=True)


if __name__ == "__main__":
    main()
