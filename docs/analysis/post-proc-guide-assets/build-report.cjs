// Build the self-contained HTML from the maintained Markdown and local assets.
// pandoc is unavailable in this environment, so md2html.cjs handles the conversion.
const fs=require('node:fs');
const path=require('node:path');
const {execFileSync}=require('node:child_process');
const {convert}=require('./md2html.cjs');

const assets=__dirname;
const base=path.resolve(assets,'..');
const stem='후공정_제조표준_설계_쉽게이해하기';

execFileSync(process.execPath,[path.join(assets,'build-figures.cjs')],{stdio:'inherit'});

const md=fs.readFileSync(path.join(base,stem+'.md'),'utf8');
const shortcuts='<nav class="reader-shortcuts" aria-label="추천 읽기 경로">'
 +'<strong>처음 읽는 분은 화면 다섯 블록에서 출발해 보세요.</strong>'
 +'<div><a href="#SEC_INTRO">그림 해설부터 보기</a>'
 +'<a href="#pp-explorer">조건별로 비교하기</a>'
 +'<a href="#SEC_DETAIL">상세 분석·코드 보기</a></div></nav>';

let {html,toc,ctx}=convert(md,{base,assets,shortcuts});

const intro=toc.find(t=>t.level===1&&t.title.startsWith('그림으로 먼저 이해하기'));
const detail=toc.find(t=>t.level===1&&t.title.startsWith('코드와 연결해서 읽는'));
if(!intro||!detail)throw new Error('Reader-shortcut anchors not found');
html=html.replace('#SEC_INTRO','#'+intro.id).replace('#SEC_DETAIL','#'+detail.id);

const slot=/<div id="pp-explorer-slot"><\/div>/g;
if((html.match(slot)||[]).length!==1)throw new Error('Explorer placeholder not found exactly once');
html=html.replace(slot,fs.readFileSync(path.join(assets,'explorer.html'),'utf8'));
html=html.replace('</body>','<script>\n'+fs.readFileSync(path.join(assets,'explorer.js'),'utf8')+'\n</script>\n</body>');

fs.writeFileSync(path.join(base,stem+'.html'),html);
console.log(`Built self-contained guide with ${ctx.images} diagrams and 6 scenario selections.`);
