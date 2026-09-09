"""Build the self-contained HTML from the maintained Markdown and local assets."""
from pathlib import Path
import subprocess
import re

assets = Path(__file__).resolve().parent
base = assets.parent
stem = '적정_차선_원자재_폭설계_쉽게이해하기'
subprocess.run(['node', str(assets / 'build-beginner-figures.cjs')], check=True)
subprocess.run([
    'pandoc', stem + '.md', '--standalone', '--embed-resources',
    '--css=width-design-guide-assets/guide.css',
    '--lua-filter=width-design-guide-assets/document-filter.lua',
    '--toc', '--toc-depth=2', '--metadata', 'toc-title=읽는 순서',
    '--output=' + stem + '.html'
], cwd=base, check=True)
out = base / (stem + '.html')
html = out.read_text()
slot = r'<div id="width-explorer-slot">\s*</div>'
assert len(re.findall(slot, html)) == 1, 'Explorer placeholder not found exactly once'
html = re.sub(slot, lambda _: (assets / 'explorer.html').read_text(), html)
beginner = re.search(r'<h1 id="([^"]+)">그림으로 먼저 이해하기:', html)
detail = re.search(r'<h1 id="([^"]+)">코드와 연결해서 읽는 상세 분석', html)
assert beginner and detail
shortcuts = ('<nav class="reader-shortcuts" aria-label="추천 읽기 경로">'
    '<strong>처음 읽는 분은 제품폭 1,002에서 출발해 보세요.</strong>'
    '<div><a href="#' + beginner.group(1) + '">그림 해설부터 보기</a>'
    '<a href="#width-explorer">소재별 경로 비교하기</a>'
    '<a href="#' + detail.group(1) + '">상세 산식·코드 보기</a></div></nav>')
html = html.replace('</header>', '</header>\n' + shortcuts, 1)
html = html.replace('</body>', '<script>\n' + (assets / 'explorer.js').read_text() + '\n</script>\n</body>')
out.write_text(html)
print('Built self-contained guide with 14 diagrams and 6 scenario selections.')
