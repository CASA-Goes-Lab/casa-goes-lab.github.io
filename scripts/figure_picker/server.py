"""Local figure picker for the Publications page.

    docker compose up figures        # then open http://localhost:4001

Lists the papers in _bibliography/publications.bib, extracts the figures from
each paper's PDF (downloaded from arXiv, or uploaded on the page), and saves
the chosen figure or a hand-drawn crop as images/pubs/<key>.png, setting the
entry's `image` field. PDFs are kept in _bibliography/pdfs/<key>.pdf (committed,
but not published on the website); figure previews are cached in .figure-cache/,
which Git ignores.
"""
import json
import os
import re
import shutil
import threading
import urllib.request
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import urlparse

import pymupdf

SITE = Path(os.environ.get('SITE_DIR', '/site'))
BIB = SITE / '_bibliography' / 'publications.bib'
PDFS = SITE / '_bibliography' / 'pdfs'
OUT = SITE / 'images' / 'pubs'
CACHE = SITE / '.figure-cache'
PAGE = Path(__file__).with_name('index.html')

KEY = re.compile(r'^[\w:.-]+$')
CAPTION = re.compile(r'^\s*(?:Fig\.?|Figure|FIGURE|FIG\.?)\s*(\d+)\s*[.:|]')
THUMB_W, THUMB_H = 480, 360
bib_lock = threading.Lock()


# --- BibTeX -----------------------------------------------------------------

def matching(text, i):
    """Index of the brace that closes the one at text[i]."""
    depth = 0
    for j in range(i, len(text)):
        if text[j - 1] == '\\':
            continue
        if text[j] == '{':
            depth += 1
        elif text[j] == '}':
            depth -= 1
            if depth == 0:
                return j
    return len(text) - 1


def entries(text):
    """Yield (key, start, end, body); text[end] is the entry's closing brace."""
    for m in re.finditer(r'@(\w+)\s*\{\s*([^,\s]+)\s*,', text):
        if m.group(1).lower() in ('comment', 'string', 'preamble'):
            continue
        end = matching(text, text.index('{', m.start()))
        yield m.group(2), m.start(), end, text[m.end():end]


def field(body, name):
    m = re.search(rf'(?<![\w-]){name}\s*=\s*', body, re.I)
    if not m:
        return ''
    i = m.end()
    if body[i:i + 1] == '{':
        return body[i + 1:matching(body, i)]
    if body[i:i + 1] == '"':
        return body[i + 1:body.find('"', i + 1)]
    return re.match(r'[^,}\n]*', body[i:]).group(0).strip()


def arxiv_id(body):
    for text in (field(body, 'arxiv'), field(body, 'eprint'), field(body, 'journal'), field(body, 'url')):
        m = re.search(r'(\d{4}\.\d{4,5})', text)
        if m:
            return m.group(1)
    return ''


def plain(text):
    return re.sub(r'\s+', ' ', text.replace('{', '').replace('}', '')).strip()


def set_image(key, value):
    """Set (or with value=None, remove) the `image` field of one entry."""
    with bib_lock:
        text = BIB.read_text(encoding='utf-8')
        for k, start, end, _ in entries(text):
            if k != key:
                continue
            entry = re.sub(r',\s*image\s*=\s*\{[^{}]*\}', '', text[start:end]).rstrip()
            if value:
                entry = entry.rstrip(',') + f',\n  image={{{value}}}'
            BIB.write_text(text[:start] + entry + '\n' + text[end:], encoding='utf-8')
            return
        raise KeyError(key)


def papers():
    result = []
    for key, _, _, body in entries(BIB.read_text(encoding='utf-8')):
        image = field(body, 'image')
        image_file = SITE / image.lstrip('/') if image else None
        version = int(image_file.stat().st_mtime) if image_file and image_file.exists() else 0
        result.append({
            'key': key,
            'title': plain(field(body, 'title')),
            'year': field(body, 'year'),
            'venue': plain(field(body, 'journal') or field(body, 'booktitle') or field(body, 'school')),
            'image': f'{image}?v={version}' if version else '',
            'arxiv': arxiv_id(body),
            'pdf': pdf_path(key).exists(),
            'hidden': field(body, 'hidden').strip().lower() == 'true',
        })
    return sorted(result, key=lambda p: (-int(p['year'] or 0), p['title'].lower()))


# --- PDFs and figures --------------------------------------------------------

def pdf_path(key):
    return PDFS / f'{key}.pdf'


def ensure_pdf(key):
    path = pdf_path(key)
    if path.exists():
        return path
    paper = next((p for p in papers() if p['key'] == key), None)
    if not paper or not paper['arxiv']:
        return None
    request = urllib.request.Request(f"https://arxiv.org/pdf/{paper['arxiv']}",
                                     headers={'User-Agent': 'casa-goes-lab figure picker'})
    data = urllib.request.urlopen(request, timeout=60).read()
    if not data.startswith(b'%PDF'):
        return None
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)
    return path


def figure_box(page, caption):
    """Grow a box upward from a caption over the drawings and images above it."""
    width = page.rect.width
    if caption.width > width * 0.5 or caption.x0 < width / 2 < caption.x1:
        x0, x1 = 0, width
    elif caption.x1 <= width / 2 + 10:
        x0, x1 = 0, width / 2 + 5
    else:
        x0, x1 = width / 2 - 5, width
    items = [d['rect'] for d in page.get_drawings()]
    items += [pymupdf.Rect(i['bbox']) for i in page.get_image_info()]
    items = [r for r in items if r.y1 <= caption.y0 + 3 and r.x1 > x0 and r.x0 < x1
             and r.y0 > 30 and not (r.height < 1.5 and r.width > width * 0.7)]
    if not items:
        return None
    items.sort(key=lambda r: -r.y1)
    box = pymupdf.Rect(items[0])
    if caption.y0 - box.y1 > 60:
        return None
    for r in items[1:]:
        if r.y1 >= box.y0 - 25:
            box |= r
    for block in page.get_text('blocks'):
        r = pymupdf.Rect(block[:4])
        if (r.y0 >= box.y0 - 2 and r.y1 <= caption.y0 - 1 and r.x0 >= box.x0 - 15
                and r.x1 <= box.x1 + 15 and len(block[4]) < 120):
            box |= r
    box = (box + (-4, -4, 4, 4)) & page.rect
    return box if box.height >= 30 else None


def figures(key):
    folder = CACHE / key
    meta = folder / 'figures.json'
    pdf = ensure_pdf(key)
    if not pdf:
        return None
    if meta.exists() and meta.stat().st_mtime >= pdf.stat().st_mtime:
        return json.loads(meta.read_text())
    shutil.rmtree(folder, ignore_errors=True)
    doc = pymupdf.open(pdf)
    folder.mkdir(parents=True, exist_ok=True)
    found, seen = [], set()
    for page in doc:
        for block in page.get_text('blocks'):
            m = CAPTION.match(block[4])
            if not m or m.group(1) in seen:
                continue
            box = figure_box(page, pymupdf.Rect(block[:4]))
            if box is None:
                continue
            seen.add(m.group(1))
            name = f'fig{m.group(1)}'
            page.get_pixmap(clip=box, dpi=110).save(folder / f'{name}.png')
            found.append({'id': name, 'label': f'Fig. {m.group(1)}', 'page': page.number,
                          'rect': list(box), 'src': f'/cache/{key}/{name}.png'})
    result = {'figures': found, 'pages': len(doc)}
    meta.write_text(json.dumps(result))
    return result


def page_image(key, number):
    path = CACHE / key / f'page-{number}.png'
    if not path.exists():
        doc = pymupdf.open(pdf_path(key))
        path.parent.mkdir(parents=True, exist_ok=True)
        doc[number].get_pixmap(dpi=110).save(path)
    return path


def save_thumbnail(key, page_number, rect):
    page = pymupdf.open(pdf_path(key))[page_number]
    clip = pymupdf.Rect(rect) & page.rect
    zoom = min(THUMB_W / clip.width, THUMB_H / clip.height)
    OUT.mkdir(parents=True, exist_ok=True)
    page.get_pixmap(matrix=pymupdf.Matrix(zoom, zoom), clip=clip).save(OUT / f'{key}.png')
    set_image(key, f'/images/pubs/{key}.png')


# --- HTTP ------------------------------------------------------------------------

class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass

    def send(self, status, body, content_type='application/json'):
        if isinstance(body, (dict, list)):
            body = json.dumps(body).encode()
        self.send_response(status)
        self.send_header('Content-Type', content_type)
        self.send_header('Cache-Control', 'no-store')
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def send_file(self, path, content_type):
        if path.is_file():
            self.send(200, path.read_bytes(), content_type)
        else:
            self.send(404, {'error': 'not found'})

    def check_key(self, key):
        if not KEY.match(key) or key not in {p['key'] for p in papers()}:
            raise LookupError(f'unknown paper {key}')
        return key

    def body_json(self):
        return json.loads(self.rfile.read(int(self.headers.get('Content-Length', 0))) or b'{}')

    def do_GET(self):
        parts = urlparse(self.path).path.strip('/').split('/')
        try:
            if parts == ['']:
                self.send_file(PAGE, 'text/html; charset=utf-8')
            elif parts == ['api', 'papers']:
                self.send(200, papers())
            elif parts[:2] == ['api', 'figures'] and len(parts) == 3:
                result = figures(self.check_key(parts[2]))
                self.send(200, result) if result else self.send(404, {'error': 'no PDF for this paper; upload one'})
            elif parts[:2] == ['api', 'page'] and len(parts) == 4:
                self.send_file(page_image(self.check_key(parts[2]), int(parts[3])), 'image/png')
            elif parts[0] == 'cache' and len(parts) == 3 and re.match(r'^fig\d+\.png$', parts[2]):
                self.send_file(CACHE / self.check_key(parts[1]) / parts[2], 'image/png')
            elif parts[:2] == ['images', 'pubs'] and len(parts) == 3 and KEY.match(parts[2]):
                self.send_file(OUT / parts[2], 'image/png')
            else:
                self.send(404, {'error': 'not found'})
        except LookupError as error:
            self.send(404, {'error': str(error)})
        except Exception as error:  # report extraction/download problems to the page
            self.send(500, {'error': f'{type(error).__name__}: {error}'})

    def do_POST(self):
        parts = urlparse(self.path).path.strip('/').split('/')
        try:
            if parts[:2] == ['api', 'pdf'] and len(parts) == 3:
                key = self.check_key(parts[2])
                data = self.rfile.read(int(self.headers.get('Content-Length', 0)))
                if not data.startswith(b'%PDF'):
                    return self.send(400, {'error': 'that file is not a PDF'})
                pdf_path(key).parent.mkdir(parents=True, exist_ok=True)
                pdf_path(key).write_bytes(data)
                shutil.rmtree(CACHE / key, ignore_errors=True)
                self.send(200, {'ok': True})
            elif parts == ['api', 'choose']:
                data = self.body_json()
                key = self.check_key(data['key'])
                if 'figure' in data:
                    fig = next(f for f in figures(key)['figures'] if f['id'] == data['figure'])
                    save_thumbnail(key, fig['page'], fig['rect'])
                else:
                    page = pymupdf.open(pdf_path(key))[int(data['page'])].rect
                    fx0, fy0, fx1, fy1 = data['crop']
                    save_thumbnail(key, int(data['page']),
                                   [fx0 * page.width, fy0 * page.height, fx1 * page.width, fy1 * page.height])
                self.send(200, {'ok': True})
            elif parts == ['api', 'remove']:
                key = self.check_key(self.body_json()['key'])
                (OUT / f'{key}.png').unlink(missing_ok=True)
                set_image(key, None)
                self.send(200, {'ok': True})
            else:
                self.send(404, {'error': 'not found'})
        except (LookupError, StopIteration) as error:
            self.send(404, {'error': str(error) or 'not found'})
        except Exception as error:
            self.send(500, {'error': f'{type(error).__name__}: {error}'})


if __name__ == '__main__':
    print('Figure picker running at http://localhost:4001', flush=True)
    ThreadingHTTPServer(('0.0.0.0', 4001), Handler).serve_forever()
