// Code-authored diagrams for the 후공정 제조표준 guide. All numbers are illustrative, not operating data.
const fs = require('node:fs');
const path = require('node:path');
const C={ink:'#17324d',teal:'#007f86',muted:'#516579',line:'#b7c8d5',pale:'#eef7f8',gray:'#f2f5f8',warm:'#fff4e7',
 red:'#b3261e',rose:'#fdecea',green:'#1b6b54',mint:'#e4f4ef',lilac:'#eef0fa',amber:'#8a6100'};
const esc=s=>String(s).replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;');
const text=(x,y,s,size=22,color=C.ink,weight=400,anchor)=>`<text x="${x}" y="${y}" font-size="${size}" fill="${color}" font-weight="${weight}"${anchor?` text-anchor="${anchor}"`:''}>${esc(s)}</text>`;
const rect=(x,y,w,h,fill=C.gray,stroke=C.line,r=12)=>`<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="${r}" fill="${fill}" stroke="${stroke}"/>`;
const arrow=(d,color=C.teal,w=3)=>`<path d="${d}" fill="none" stroke="${color}" stroke-width="${w}" marker-end="url(#arrow)"/>`;
const dash=(d,color=C.muted)=>`<path d="${d}" fill="none" stroke="${color}" stroke-width="2" stroke-dasharray="6 5" marker-end="url(#arrowg)"/>`;
function box(x,y,w,h,title,lines=[],fill=C.gray,size=19,tsize=22){
 return rect(x,y,w,h,fill)+text(x+16,y+32,title,tsize,C.ink,700)+lines.map((s,i)=>text(x+16,y+62+26*i,s,size)).join('');
}
// 마름모(판단) 노드
function diamond(cx,cy,w,h,label,fill='#e2f1f0',size=19){
 const p=`${cx},${cy-h/2} ${cx+w/2},${cy} ${cx},${cy+h/2} ${cx-w/2},${cy}`;
 const lines=Array.isArray(label)?label:[label];
 return `<polygon points="${p}" fill="${fill}" stroke="${C.line}"/>`
  +lines.map((s,i)=>text(cx,cy+6-(lines.length-1)*11+22*i,s,size,C.ink,700,'middle')).join('');
}
function pill(x,y,w,h,label,fill=C.teal,color='#fff',size=19){
 return `<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="${h/2}" fill="${fill}"/>`+text(x+w/2,y+h/2+6,label,size,color,700,'middle');
}
function table(x,y,cols,rows,opts={}){
 const rh=opts.rh||44,hh=opts.hh||46,size=opts.size||19,W=cols.reduce((a,c)=>a+c.w,0);let p='';
 let cx=x;p+=`<rect x="${x}" y="${y}" width="${W}" height="${hh}" fill="#e3eef2"/>`;
 cols.forEach(c=>{p+=text(cx+10,y+30,c.h,size,C.ink,700);cx+=c.w;});
 rows.forEach((r,i)=>{const ry=y+hh+i*rh;const fill=r.fill||(i%2?'#fafcfd':'#fff');
  p+=`<rect x="${x}" y="${ry}" width="${W}" height="${rh}" fill="${fill}" stroke="${C.line}"/>`;
  let cx2=x;r.c.forEach((v,j)=>{p+=text(cx2+10,ry+rh/2+7,v,size,(r.color&&r.color[j])||C.ink,(r.bold&&r.bold[j])?700:400);cx2+=cols[j].w;});});
 return p;
}
function save(name,h,title,desc,parts){
 fs.writeFileSync(path.join(__dirname,name),
  `<svg xmlns="http://www.w3.org/2000/svg" width="1100" height="${h}" viewBox="0 0 1100 ${h}" role="img" aria-labelledby="title desc">`
  +`<title id="title">${esc(title)}</title><desc id="desc">${esc(desc)}</desc>`
  +`<defs><marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto"><path d="M0 0L10 5L0 10Z" fill="${C.teal}"/></marker>`
  +`<marker id="arrowg" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto"><path d="M0 0L10 5L0 10Z" fill="${C.muted}"/></marker>`
  +`<marker id="arrowr" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto"><path d="M0 0L10 5L0 10Z" fill="${C.red}"/></marker></defs>`
  +`<rect width="1100" height="${h}" fill="#fff"/><g font-family="Apple SD Gothic Neo, Noto Sans CJK KR, sans-serif">${parts.join('\n')}</g></svg>\n`);
}
let count=0;const done=()=>count++;
module.exports={C,text,rect,arrow,dash,box,diamond,pill,table,save};

// ── 01 후공정 탭의 자리 ──────────────────────────────────────────
{
 const p=[text(35,46,'후공정 제조표준은 “제품을 어떻게 잘라 포장해 내보낼지”를 다룹니다',30,C.ink,700),
  text(35,84,'제조표준 3개 탭 중 마지막 · 앞의 두 탭이 설비 작업조건이라면 여기는 제품 마무리 조건',21,C.muted)];
 const tabs=[['용융도금-제조표준','TAB05','PLTCM · CGL 소둔','도금량 · 수지 · 목표 Size',C.gray],
  ['전기도금-제조표준','TAB06','PLTCM · ECL · TM · ANN','EGL 도금량 · 목표 Size',C.gray],
  ['후공정-제조표준','TAB09','정전 Slit · 1T2C · S/T','SKID · 보호필름 · 포장',C.pale]];
 tabs.forEach(([t,id,a,b,f],i)=>{const x=35+i*345;p.push(rect(x,120,330,190,f,i===2?C.teal:C.line,12));
  p.push(text(x+18,158,t,23,C.ink,700));p.push(text(x+18,188,id,18,C.muted));
  p.push(text(x+18,228,a,19));p.push(text(x+18,258,b,19));
  p.push(text(x+18,292,i===2?'주문 단위 · 제조구분 1만 조회':'제조구분별 3행',17,i===2?C.teal:C.muted,700));});
 p.push(arrow('M550 315V355'));
 p.push(box(35,365,1030,120,'세 탭 모두 같은 행을 씁니다',
  ['TB_C10_QLT_DSN_MNF · 주문번호 + 주문행 + 제조구분','다만 후공정이 다루는 컬럼은 적정·차선이 같은 값이어야 하는 항목이라, 조회도 저장도 주문 단위로 움직입니다.'],C.warm));
 p.push(box(35,505,335,175,'다루는 것',['정전 Slit 조수와 조합폭 1~10','1T2C 유무 · S/T 유무','제품폭범위 상·하한','SKID 치수 · 보호필름 · 포장'],C.pale,18));
 p.push(box(385,505,335,175,'보여만 주는 것',['엠보스무늬 · SHEET 적치방법','방청유(도유코드)','SHL 작업 SIZE(조분할)','보호필름 7개 항목 전부'],C.gray,18));
 p.push(box(735,505,330,175,'다루지 않는 것',['두께 · 소둔 · 도금량','PLTCM 설정 · 원자재','→ TAB05 · TAB06 참조'],C.gray,18));
 save('01-where-is-postproc.svg',715,'후공정 탭의 자리','제조표준 세 탭 중 후공정은 정전 Slit, SKID, 보호필름, 포장을 다루며 주문 단위로 움직인다.',p);done();
}

// ── 02 화면 5블록 ────────────────────────────────────────────────
{
 const p=[text(35,46,'화면은 다섯 블록입니다. 편집할 수 있는 곳은 세 곳뿐입니다',30,C.ink,700),
  text(35,84,'노란 테두리 = 편집 가능 · 회색 = 조회 전용 · 각 블록은 세로형 그리드(한 줄에 한 주문)',21,C.muted)];
 const blocks=[
  ['① 정전  Grid_1','조수 · 조합폭 1~10 · 1T2C유무 · S/T유무 · 제품폭범위 하한·상한','편집',C.warm],
  ['② 후처리  Grid_2','엠보스무늬 · SHEET적치방법 · 방청유 · SHL 작업 SIZE(두께·폭·길이) · SKID(폭·길이)','조회',C.gray],
  ['③ 보호필름  Grid_3','관리점착력 · 상세코드 · 부착위치 · 두께 · 폭 · SUS점착력 · 제품점착력','조회',C.gray],
  ['④ 품질메세지  Grid_4','정전 공정 메세지 한 줄 (TB_C10_QLT_DSN_MSG1)','편집',C.warm],
  ['⑤ 포장  Grid_5','포장방법(조회) · 포장메세지(편집, 콤보)','일부 편집',C.warm]];
 blocks.forEach(([t,d,e,f],i)=>{const y=120+i*112;
  p.push(rect(35,y,1030,96,f,e==='조회'?C.line:'#e0a343'));
  p.push(text(55,y+36,t,23,C.ink,700));p.push(text(55,y+70,d,19));
  p.push(pill(925,y+22,120,34,e,e==='조회'?C.muted:C.teal));});
 p.push(text(35,700,'②③은 앞 단계 설계 결과와 주문 정보를 그대로 보여줍니다. 이 화면에서 고칠 수 없습니다.',20,C.ink,700));
 p.push(text(35,733,'저장 버튼은 ①의 헤더(Form_1)에 하나뿐이며, ①④⑤ 세 블록의 변경을 한 번에 처리합니다.',19,C.muted));
 save('02-screen-blocks.svg',765,'화면 다섯 블록','정전, 후처리, 보호필름, 품질메세지, 포장 다섯 블록 중 정전과 메세지, 포장메세지만 편집할 수 있다.',p);done();
}

// ── 03 값의 출처 지도 ────────────────────────────────────────────
{
 const p=[text(35,46,'화면의 값은 네 곳에서 옵니다',30,C.ink,700),
  text(35,84,'후공정 탭이 스스로 계산하는 값은 SKID 치수 두 개뿐입니다. 나머지는 가져오거나 조회한 값입니다.',21,C.muted)];
 const srcs=[['주문 접수','#e8eef8'],['자동설계','#e6f2ee'],['조회 SQL 계산','#fdf0e0'],['다른 시스템','#f3eef7']];
 srcs.forEach(([s,f],i)=>{const x=35+i*258;p.push(rect(x,118,245,52,f));p.push(text(x+122,151,s,21,C.ink,700,'middle'));});
 const rows=[
  ['엠보스무늬 · SHEET적치방법 · 포장방법','주문 접수','TB_C10_QLT_DSN_CMN'],
  ['보호필름 상세코드 · 폭 · 부착위치','주문 접수','CMN · 상세코드는 자리별로 쪼개 표시'],
  ['SHL 작업 SIZE(조분할 두께·폭·길이)','주문 접수','CMN · 조분할여부가 Y일 때만 의미'],
  ['1T2C 유무 · 포장메세지코드','주문 접수','CMN · 이 화면에서 수정 가능'],
  ['Slit 조수 · 조합폭 1~10 · 제품폭범위','자동설계 폭 단계','C103100080 결과를 MNF에 저장'],
  ['S/T 유무(정전 Edge)','자동설계 공정 Size','주문 Edge가 S 또는 C이면 Y'],
  ['방청유(도유코드)','자동설계 제조사양','C10B2170 · 품명 C·1만'],
  ['정전 품질메세지','자동설계 설계Key','C10B1040 의 정전메세지 열'],
  ['SKID 폭 · 길이','조회 SQL 계산','조분할·제품형태로 그때 계산'],
  ['보호필름 관리점착력','다른 시스템 우선','칼라 BOM 값이 있으면 그 값']];
 p.push(table(35,190,[{h:'화면 항목',w:430},{h:'출처',w:250},{h:'비고',w:350}],
  rows.map(r=>({c:r,fill:r[1]==='주문 접수'?'#f6f8fc':r[1]==='자동설계'?'#f4faf8':r[1]==='조회 SQL 계산'?'#fdf7ef':'#f8f5fb'})),{rh:44}));
 p.push(text(35,690,'“설계가 안 됐다”와 “주문에 안 적혔다”는 다른 문제입니다. 값이 비면 먼저 이 표에서 출처를 확인합니다.',20,C.ink,700));
 save('03-value-sources.svg',725,'값의 출처 지도','후공정 화면 항목이 주문 접수, 자동설계, 조회 SQL 계산, 다른 시스템 중 어디서 오는지 정리한 표.',p);done();
}

// ── 04 저장 순서도 ───────────────────────────────────────────────
{
 const p=[text(35,46,'저장 버튼을 누르면 세 갈래를 순서대로 확인합니다',30,C.ink,700),
  text(35,84,'변경된 블록만 저장하고, 앞 저장이 끝나면 콜백이 다음 블록을 이어서 보냅니다',21,C.muted)];
 p.push(pill(430,115,240,44,'저장 버튼 클릭'));
 p.push(arrow('M550 162V196'));
 p.push(diamond(550,236,420,80,['① 정전 · ④ 메세지 · ⑤ 포장 중','하나라도 updated 인가?'],'#e2f1f0',19));
 p.push(arrow('M340 236H210',C.red));p.push(text(215,228,'아니오',18,C.red,700));
 p.push(rect(35,210,170,52,C.rose,'#e5b4b0'));p.push(text(120,242,'변경 없음 알림',19,C.red,700,'middle'));
 p.push(arrow('M550 278V312'));p.push(text(566,300,'예',18,C.teal,700));
 p.push(diamond(550,352,300,66,'저장 확인 창','#eef7f8',19));
 p.push(arrow('M550 386V420'));
 p.push(diamond(550,466,330,80,['① 정전이','updated 인가?'],'#e2f1f0',19));
 // 예 경로
 p.push(arrow('M385 466H255'));p.push(text(268,458,'예',18,C.teal,700));
 p.push(box(35,420,215,92,'COR_save',['이력기록(후공정)','→ 후공정 save','→ 이력기록(1T2C)','→ 1T2C save'],C.pale,15,20));
 p.push(arrow('M142 516V554'));
 p.push(diamond(142,594,215,66,['콜백이 ④ 확인'],'#e2f1f0',18));
 // 아니오 경로
 p.push(arrow('M550 508V548'));p.push(text(566,536,'아니오',18,C.red,700));
 p.push(diamond(550,588,300,72,['④ 메세지가','updated 인가?'],'#e2f1f0',18));
 p.push(arrow('M400 588H255V686'));p.push(text(300,578,'예',17,C.teal,700));
 p.push(box(35,690,300,92,'MSG_save',['이력기록(메세지)','→ 메세지 save (MSG1)'],C.pale,16,20));
 p.push(arrow('M142 628V686'));
 p.push(arrow('M550 626V676'));p.push(text(566,662,'아니오',17,C.red,700));
 p.push(diamond(550,716,300,72,['⑤ 포장메세지가','updated 인가?'],'#e2f1f0',18));
 p.push(arrow('M700 716H788'));p.push(text(716,706,'예',17,C.teal,700));
 p.push(box(795,672,270,92,'PKG_save',['이력기록(포장메세지)','→ 포장메세지수정 (CMN)'],C.pale,16,20));
 p.push(arrow('M185 786V812H393'));
 p.push(arrow('M930 770V812H707'));
 p.push(arrow('M550 754V820'));p.push(text(566,790,'아니오',17,C.red,700));
 p.push(pill(400,822,300,46,'화면 재조회','#005f67'));
 p.push(text(35,905,'①이 저장되면 그 콜백이 ④를, ④가 저장되면 그 콜백이 ⑤를 이어서 보냅니다. 세 블록을 동시에 고쳐도 한 번에 처리됩니다.',20,C.ink,700));
 p.push(text(35,938,'저장 실패는 각 단계에서 end 로 빠집니다. 앞 단계가 실패하면 뒤 단계는 아예 시도하지 않습니다.',19,C.muted));
 save('04-save-flow.svg',970,'저장 순서도','저장 버튼은 정전, 메세지, 포장 순서로 변경 여부를 확인해 각각의 저장 체인을 실행한다.',p);done();
}

// ── 05 Slit 표시 규칙 순서도 ────────────────────────────────────
{
 const p=[text(35,46,'조수와 조합폭1은 “S/T 유무”에 따라 보였다 숨었다 합니다',29,C.ink,700),
  text(35,84,'조회 SQL이 값을 그대로 내려주지 않고 S/T 유무를 먼저 봅니다. 조합폭 2~10은 이 규칙 밖입니다.',21,C.muted)];
 p.push(pill(400,118,300,44,'조회 SQL 시작'));
 p.push(arrow('M550 165V200'));
 p.push(diamond(550,242,360,78,['S/T 유무(COR_EDG_ASG_TP)가','Y 인가?'],'#e2f1f0',19));
 p.push(arrow('M370 242H240',C.red));p.push(text(250,234,'아니오 / 값 없음',17,C.red,700));
 p.push(rect(35,208,205,68,C.rose,'#e5b4b0'));
 p.push(text(137,238,'조수 = 빈칸',18,C.red,700,'middle'));p.push(text(137,264,'조합폭1 = 빈칸',18,C.red,700,'middle'));
 p.push(arrow('M550 282V320'));p.push(text(566,308,'예',18,C.teal,700));
 p.push(diamond(550,368,360,80,['조합폭1(MIX_WTH1) 이','0 이거나 비어 있는가?'],'#e2f1f0',19));
 p.push(arrow('M730 368H830'));p.push(text(742,358,'예',18,C.teal,700));
 p.push(box(835,330,230,80,'조합폭1 자리에',['정전폭목표값','(COR_WTH_TRV) 표시'],C.warm,17,20));
 p.push(arrow('M550 410V450'));p.push(text(566,438,'아니오',18,C.muted,700));
 p.push(box(370,450,360,80,'조합폭1 그대로 표시',['조수도 저장값 그대로'],C.pale,17,20));
 p.push(rect(35,560,1030,120,C.gray));
 p.push(text(55,596,'조합폭 2~10 은 이 판단을 거치지 않습니다',22,C.ink,700));
 p.push(text(55,630,'각각 0 이거나 비어 있으면 빈칸으로, 값이 있으면 그대로 보여줍니다. S/T 유무와 무관합니다.',19));
 p.push(text(55,660,'그래서 S/T 가 N 인데 조합폭 2~10 에만 숫자가 남아 보이는 화면이 나올 수 있습니다.',19,C.amber,700));
 p.push(text(35,720,'화면에서 조수가 비어 보인다고 DB의 조수가 0 이라는 뜻은 아닙니다. 먼저 S/T 유무를 확인합니다.',20,C.ink,700));
 save('05-slit-display.svg',755,'Slit 표시 규칙','S/T 유무가 Y가 아니면 조수와 조합폭1을 빈칸으로 표시하고, 조합폭1이 0이면 정전폭목표값으로 대체한다.',p);done();
}

// ── 06 저장 시 보호 규칙 ────────────────────────────────────────
{
 const p=[text(35,46,'저장할 때도 S/T 유무가 조수·조합폭1을 지켜 줍니다',29,C.ink,700),
  text(35,84,'UPDATE 문의 DECODE 가 S/T 가 Y 일 때만 새 값을 씁니다. 조합폭 2~10 에는 이 보호가 없습니다.',21,C.muted)];
 p.push(table(35,120,[{h:'저장 컬럼',w:300},{h:'S/T 유무 = Y',w:330},{h:'S/T 유무 ≠ Y',w:435}],[
  {c:['Slit 조수','화면 값으로 갱신','기존 DB 값 유지'],color:[C.ink,C.teal,C.amber],bold:[1,1,1]},
  {c:['조합폭1','화면 값으로 갱신','기존 DB 값 유지'],color:[C.ink,C.teal,C.amber],bold:[1,1,1]},
  {c:['조합폭 2~10','화면 값으로 갱신','화면 값으로 갱신 (보호 없음)'],color:[C.ink,C.teal,C.red],bold:[1,1,1]},
  {c:['S/T 유무','화면 값으로 갱신','화면 값으로 갱신']},
  {c:['제품폭범위 하한·상한','화면 값으로 갱신','화면 값으로 갱신']}],{rh:48}));
 p.push(rect(35,410,1030,150,C.rose,'#e5b4b0'));
 p.push(text(55,448,'여기서 생기는 어긋남',23,C.red,700));
 p.push(text(55,484,'S/T 가 N 이면 화면의 조수·조합폭1 칸은 빈칸입니다. 그 상태로 저장해도 DB 값은 그대로 남습니다.',19));
 p.push(text(55,514,'반면 조합폭 2~10 은 화면에 보이는 값이 그대로 덮어써집니다. 빈칸이면 빈 값이 들어갑니다.',19));
 p.push(text(55,544,'즉 S/T 를 N 으로 바꾸고 저장하면 조합폭 1 만 남고 2~10 이 지워질 수 있습니다.',19,C.red,700));
 p.push(box(35,585,1030,110,'확인 순서',
  ['① 저장 전 S/T 유무 값 · ② 화면에 보이는 조수·조합폭 1~10 · ③ 저장 후 DB 의 같은 열',
   '세 가지를 나란히 적어 두면 어느 칸이 보호되고 어느 칸이 덮어써졌는지 바로 보입니다.'],C.pale,19));
 save('06-save-protect.svg',730,'저장 시 보호 규칙','S/T 유무가 Y가 아니면 조수와 조합폭1은 기존 값을 유지하지만 조합폭 2~10은 화면 값으로 덮어쓴다.',p);done();
}

// ── 07 제조구분 없는 UPDATE ─────────────────────────────────────
{
 const p=[text(35,46,'후공정 저장은 적정·차선 세 행을 한꺼번에 바꿉니다',30,C.ink,700),
  text(35,84,'조회는 제조구분 1(적정) 한 행만 하지만, UPDATE 문에는 제조구분 조건이 없습니다',21,C.muted)];
 p.push(box(35,120,470,150,'조회 SQL',['WHERE 주문번호 = ?','  AND 주문행 = ?','  AND 제조구분 = \'1\'   ← 적정만'],C.pale,19,22));
 p.push(box(595,120,470,150,'저장 SQL (MNFupdate)',['WHERE 주문번호 = ?','  AND 주문행 = ?','  (제조구분 조건 없음)   ← 전체'],C.rose,19,22));
 p.push(arrow('M270 275V320'));p.push(arrow('M830 275V320'));
 p.push(text(35,355,'화면이 보여주는 행',20,C.ink,700));p.push(text(595,355,'저장이 바꾸는 행',20,C.red,700));
 [['적정  제조구분 1',true],['차선1  제조구분 2',false],['차선2  제조구분 3',false]].forEach(([t,sel],i)=>{
  const y=375+i*70;
  p.push(rect(35,y,470,58,sel?C.pale:'#fff',sel?C.teal:C.line));
  p.push(text(55,y+37,t+(sel?'   ← 조회·표시':'   (화면에 없음)'),19,sel?C.ink:C.muted,sel?700:400));
  p.push(rect(595,y,470,58,C.rose,'#e5b4b0'));
  p.push(text(615,y+37,t+'   ← 함께 갱신',19,C.red,700));});
 p.push(box(35,600,1030,130,'이 동작이 문제가 아닌 이유와, 그래도 알아야 하는 이유',
  ['후공정이 저장하는 일곱 항목은 자동설계에서도 적정·차선이 같은 값을 갖도록 만들어집니다. 그래서 함께 갱신하는 편이 일관됩니다.',
   '다만 화면은 적정 값만 보여주므로, 차선 행에 다른 값이 남아 있었다면 그 값은 확인 없이 사라집니다.',
   '차선 행의 후공정 값을 조사할 때는 화면이 아니라 DB 를 직접 봐야 합니다.'],C.warm,19));
 save('07-update-all-rows.svg',760,'제조구분 없는 저장','조회는 적정 한 행만 하지만 저장은 제조구분 조건 없이 적정과 차선 세 행을 모두 갱신한다.',p);done();
}

// ── 08 SKID 치수 순서도 ─────────────────────────────────────────
{
 const p=[text(35,46,'SKID 폭·길이는 저장된 값이 아니라 조회할 때 계산합니다',29,C.ink,700),
  text(35,84,'제품형태와 조분할 여부를 보고 세 갈래로 갈립니다. DB 에 SKID 컬럼은 없습니다.',21,C.muted)];
 p.push(pill(410,116,280,44,'SKID 칸 계산 시작'));
 p.push(arrow('M550 163V198'));
 p.push(diamond(550,240,340,76,['제품형태가','Sheet(S) 인가?'],'#e2f1f0',19));
 p.push(arrow('M380 240H250',C.red));p.push(text(258,232,'아니오 (코일 등)',17,C.red,700));
 p.push(rect(35,212,215,56,C.rose,'#e5b4b0'));p.push(text(142,247,'빈칸으로 표시',19,C.red,700,'middle'));
 p.push(arrow('M550 278V316'));p.push(text(566,304,'예',18,C.teal,700));
 p.push(diamond(550,368,420,90,['조분할여부 Y 이고','조분할 폭·길이가 모두 0 보다 큰가?'],'#e2f1f0',18));
 p.push(arrow('M760 368H845'));p.push(text(772,358,'예',18,C.teal,700));
 p.push(box(850,320,215,96,'조분할 값 사용',['폭 = 둘 중 작은 값','길이 = 둘 중 큰 값'],C.mint,17,20));
 p.push(arrow('M550 413V455'));p.push(text(566,442,'아니오',18,C.muted,700));
 p.push(box(335,455,430,96,'주문 치수 사용',['폭 = 주문폭·주문길이 중 작은 값','길이 = 주문폭·주문길이 중 큰 값'],C.pale,17,20));
 p.push(rect(35,585,1030,252,C.gray));
 p.push(text(55,622,'설명용 예제',23,C.ink,700));
 p.push(table(55,636,[{h:'상황',w:340},{h:'입력',w:340},{h:'SKID 폭 / 길이',w:310}],[
  {c:['Sheet · 조분할 N','주문폭 1,000 · 주문길이 2,000','1,000 / 2,000']},
  {c:['Sheet · 조분할 N (길이가 더 짧음)','주문폭 1,200 · 주문길이 900','900 / 1,200']},
  {c:['Sheet · 조분할 Y','조분할폭 500 · 조분할길이 1,800','500 / 1,800']},
  {c:['코일','제품형태 C','빈칸 / 빈칸'],color:[C.red,C.red,C.red]}],{rh:38,size:18,hh:38}));
 p.push(text(35,876,'항상 작은 값이 폭, 큰 값이 길이입니다. 주문에 적힌 폭·길이 이름과 뒤바뀔 수 있습니다.',20,C.ink,700));
 save('08-skid-flow.svg',910,'SKID 치수 계산','제품형태가 Sheet이고 조분할이 Y이면 조분할 값을, 아니면 주문 치수를 쓰고 코일은 빈칸이다.',p);done();
}

// ── 09 보호필름 상세코드 파싱 ──────────────────────────────────
{
 const p=[text(35,46,'보호필름 상세코드 한 줄을 자리별로 쪼개 다섯 칸에 나눠 보여줍니다',28,C.ink,700),
  text(35,84,'설명용 코드 A2B31 · 실제 자리 의미와 코드값은 운영 공통코드를 확인해야 합니다',21,C.muted)];
 const chars=['A','2','B','3','1'];
 const meanings=[['1자리','화면에 따로','쓰지 않음'],['2자리','보호필름','두께코드'],['3자리','화면에 따로','쓰지 않음'],['4자리','SUS','점착력'],['5자리','제품','점착력']];
 chars.forEach((ch,i)=>{const x=190+i*145;
  const used=i===1||i===3||i===4;
  p.push(rect(x,125,120,92,used?C.pale:'#f4f4f4',used?C.teal:C.line));
  p.push(text(x+60,198,ch,52,used?C.teal:'#9aa5ad',700,'middle'));
  p.push(text(x+60,143,String(i+1)+'자리',15,C.muted,400,'middle'));});
 p.push(text(35,180,'상세코드',22,C.ink,700));
 meanings.forEach((m,i)=>{const x=190+i*145;const used=i===1||i===3||i===4;
  if(used)p.push(arrow(`M${x+60} 222V258`));
  p.push(rect(x,262,120,90,used?C.warm:'#fafafa',used?'#e0a343':C.line));
  m.slice(1).forEach((t,j)=>p.push(text(x+60,296+26*j,t,15,used?C.ink:'#9aa5ad',used?700:400,'middle')));});
 p.push(rect(35,385,1030,120,C.gray));
 p.push(text(55,422,'화면 다섯 칸에 함께 놓이는 값',22,C.ink,700));
 p.push(text(55,456,'상세코드 원본 · 부착위치코드 · 보호필름 폭 — 이 셋은 주문 값을 그대로 씁니다.',19));
 p.push(text(55,486,'쪼갠 세 값은 각각 공통코드를 조회해 “코드 : 의미” 형태로 붙여 보여줍니다.',19));
 p.push(box(35,525,1030,120,'주의',
  ['상세코드가 짧거나 비어 있으면 그 칸은 코드와 의미가 함께 사라져 빈 값이 됩니다.',
   '화면의 두께·SUS점착력·제품점착력은 별도 컬럼이 아니라 이 코드에서 파생된 값입니다. DB 에서 그 이름의 컬럼을 찾지 마세요.'],C.warm,19));
 save('09-film-code-parse.svg',680,'보호필름 상세코드 파싱','상세코드의 2·4·5번째 자리를 각각 두께코드, SUS점착력, 제품점착력으로 쪼개 표시한다.',p);done();
}

// ── 10 관리점착력 이중 소스 ────────────────────────────────────
{
 const p=[text(35,46,'관리점착력만 다른 표에서 먼저 찾아옵니다',30,C.ink,700),
  text(35,84,'칼라 제조사양(CCL BOM)에 값이 있으면 그 값을, 없으면 상세코드에서 쪼갠 제품점착력을 씁니다',21,C.muted)];
 p.push(box(35,125,420,140,'① 먼저 본다',['칼라 제조사양 TB_C10_QLT_DSN_CCL_BOM','같은 주문번호·주문행의','보호필름 관리점착력 문구'],C.mint,18,21));
 p.push(diamond(660,195,300,90,['값이 있는가?'],'#e2f1f0',20));
 p.push(arrow('M460 195H505'));
 p.push(arrow('M810 195H900'));p.push(text(822,185,'예',18,C.teal,700));
 p.push(rect(905,163,160,64,C.mint,C.teal));p.push(text(985,202,'그 값 사용',19,C.ink,700,'middle'));
 p.push(arrow('M660 242V290'));p.push(text(676,278,'아니오',18,C.muted,700));
 p.push(box(440,290,440,120,'② 대신 쓴다',['상세코드 5번째 자리 = 제품점착력','공통코드로 의미를 붙여 표시'],C.warm,18,21));
 p.push(rect(35,450,1030,150,C.gray));
 p.push(text(55,488,'그래서 이런 일이 생깁니다',22,C.ink,700));
 p.push(text(55,524,'같은 화면의 “관리점착력”과 “제품점착력”이 서로 다른 값을 보일 수 있습니다. 칼라 주문이면 정상입니다.',19));
 p.push(text(55,554,'반대로 두 칸이 똑같다면 칼라 BOM 에 관리점착력이 비어 있다는 뜻일 수 있습니다.',19));
 p.push(text(55,584,'칼라가 아닌 주문은 CCL BOM 행 자체가 없어 항상 제품점착력이 그대로 보입니다.',19,C.muted));
 p.push(text(35,645,'두 칸이 다르다고 오류로 단정하지 말고, 먼저 그 주문에 칼라 제조사양이 있는지 확인합니다.',20,C.ink,700));
 save('10-adhesion-source.svg',680,'관리점착력 이중 소스','칼라 제조사양에 관리점착력이 있으면 그 값을, 없으면 상세코드에서 쪼갠 제품점착력을 쓴다.',p);done();
}

// ── 11 메세지 세 테이블 ────────────────────────────────────────
{
 const p=[text(35,46,'“품질메세지”라는 이름의 표가 세 개 있습니다',30,C.ink,700),
  text(35,84,'후공정 탭이 다루는 것은 가운데 하나뿐입니다. 앞의 두 탭이 쓰는 표와 다릅니다.',21,C.muted)];
 const t=[['TB_C10_QLT_DSN_MSG','품질Message (공정공통)','주문 + 주문행 + 제조구분','적정·차선마다 1건','TAB05 · TAB06 이 편집',C.gray],
  ['TB_C10_QLT_DSN_MSG1','품질Message (정전공정)','주문 + 주문행','주문당 1건','TAB09 가 편집',C.pale],
  ['TB_C10_QLT_DSN_MSG_PKG','품질설계메세지_포장','주문 + 주문행','주문당 1건','TAB09 는 읽기만',C.gray]];
 t.forEach(([tb,nm,key,cnt,who,f],i)=>{const y=120+i*150;
  p.push(rect(35,y,1030,130,f,i===1?C.teal:C.line));
  p.push(text(55,y+38,tb,22,C.ink,700));
  p.push(text(55,y+70,nm,19,C.muted));
  p.push(text(430,y+38,'키: '+key,18));
  p.push(text(430,y+70,cnt,18));
  p.push(text(790,y+38,who,19,i===1?C.teal:C.ink,700));
  if(i===1)p.push(text(790,y+70,'← 이 문서가 다루는 표',17,C.teal));
  if(i===2)p.push(text(790,y+70,'이 저장소에 INSERT 없음',17,C.amber,700));});
 p.push(box(35,580,1030,140,'포장 블록의 두 값은 저장 위치가 다릅니다',
  ['화면의 “포장메세지” 칸은 포장메세지코드(PAK_MSG_CD)이며 설계공통 표에 저장됩니다.',
   '그 옆에 붙어 보이는 메세지 문구는 포장 메세지 표에서 외부조인으로 읽어 온 것이고, 이 화면은 그 표를 쓰지 않습니다.',
   '즉 한 칸에 보이는 글자가 두 표에서 합쳐진 값입니다.'],C.warm,19));
 save('11-message-tables.svg',750,'메세지 세 테이블','공정공통, 정전공정, 포장 세 개의 메세지 표가 있고 후공정 탭은 정전공정 표만 편집한다.',p);done();
}

// ── 12 메세지 생성 경로 ────────────────────────────────────────
{
 const p=[text(35,46,'정전 메세지는 설계 Key 기준 한 행에서 함께 나옵니다',30,C.ink,700),
  text(35,84,'같은 기준 행이 제조구분별 메세지와 정전 메세지를 동시에 내려줍니다',21,C.muted)];
 p.push(box(35,120,330,150,'설계 Key 기준 C10B1040',['품명 · 재질 · 규격 등으로 조회','결과 열에 메세지 문구가 들어 있음'],C.pale,18,21));
 p.push(arrow('M370 175H430'));p.push(arrow('M370 215H430'));
 p.push(rect(435,120,300,70,C.gray));
 p.push(text(451,150,'메세지 열 1',20,C.ink,700));
 p.push(text(451,176,'제조구분별 문구',17,C.muted));
 p.push(rect(435,200,300,70,C.warm));
 p.push(text(451,230,'정전 메세지 열',20,C.ink,700));
 p.push(text(451,256,'정전 공정 문구',17,C.muted));
 p.push(arrow('M740 155H800'));p.push(arrow('M740 235H800'));
 p.push(box(805,110,260,90,'MSG 표',['원자재 후보 수만큼','1~3건 INSERT'],C.gray,16,19));
 p.push(box(805,215,260,90,'MSG1 표',['주문당 1건 INSERT','← 후공정 탭이 편집'],C.pale,16,19));
 p.push(rect(35,335,1030,150,C.gray));
 p.push(text(55,373,'후공정 탭에서 메세지를 고치면',22,C.ink,700));
 p.push(text(55,409,'정전 메세지(MSG1) 한 건만 바뀝니다. 앞의 두 탭이 보여주는 제조구분별 메세지(MSG)는 그대로입니다.',19));
 p.push(text(55,439,'1,000바이트를 넘는 글자는 잘려서 저장됩니다.',19));
 p.push(text(55,469,'재설계하면 메인 서비스가 두 표를 모두 지우고 기준에서 다시 만듭니다. 손으로 고친 문구는 사라집니다.',19,C.amber,700));
 p.push(box(35,505,1030,140,'값이 비어 보일 때',
  ['정전 메세지 경로에는 빈 값 치환이 없습니다. 기준 열이 비어 있으면 NULL 이나 빈 값 그대로 INSERT 됩니다.',
   '제조구분별 메세지 경로에만 빈 문자열 치환이 있습니다. 두 경로의 처리가 다릅니다.',
   '행 자체가 없으면 화면 메세지 칸이 아예 뜨지 않습니다. 이때는 설계 Key 단계가 성공했는지 확인합니다.'],C.warm,19));
 save('12-message-origin.svg',680,'정전 메세지 생성 경로','설계 Key 기준 한 행에서 제조구분별 메세지와 정전 메세지가 함께 나오고 각각 다른 표에 저장된다.',p);done();
}

// ── 13 종료주문 필터 ───────────────────────────────────────────
{
 const p=[text(35,46,'주문이 종료되면 이 화면은 아무것도 보여주지 않습니다',30,C.ink,700),
  text(35,84,'조회 SQL 두 개 모두 종료 통제 목록에 있는 주문을 제외합니다',21,C.muted)];
 p.push(pill(400,118,300,44,'후공정 탭 조회'));
 p.push(arrow('M550 165V200'));
 p.push(diamond(550,248,460,86,['이 주문번호가 종료 통제 목록','(구분 O)에 있는가?'],'#e2f1f0',19));
 p.push(arrow('M780 248H870',C.red));p.push(text(792,238,'예',18,C.red,700));
 p.push(rect(875,212,190,72,C.rose,'#e5b4b0'));
 p.push(text(970,246,'조회 결과 0건',19,C.red,700,'middle'));
 p.push(text(970,272,'화면 전체 공백',17,C.red,400,'middle'));
 p.push(arrow('M550 291V330'));p.push(text(566,318,'아니오',18,C.teal,700));
 p.push(box(300,330,500,80,'정상 조회',['제조표준 · 설계공통 · 포장메세지를 조인'],C.pale,18,21));
 p.push(rect(35,440,1030,175,C.gray));
 p.push(text(55,478,'앞의 두 탭과 다른 점',22,C.ink,700));
 p.push(text(55,514,'제조표준 세 탭 중 후공정 탭에만 있습니다. 용융도금·전기도금 탭의 조회 SQL 에는 없습니다.',19));
 p.push(text(55,544,'그래서 같은 주문에서 TAB05·TAB06 은 값이 보이는데 TAB09 만 비어 보이는 상황이 생길 수 있습니다.',19,C.amber,700));
 p.push(text(55,574,'품질메세지 조회 SQL 에도 같은 필터가 걸려 있어 메세지 칸도 함께 사라집니다.',19));
 p.push(text(35,660,'화면이 통째로 비면 설계 오류부터 찾지 말고, 그 주문이 종료 처리되었는지 먼저 확인합니다.',20,C.ink,700));
 save('13-terminated-order.svg',695,'종료주문 필터','후공정 탭의 조회 SQL은 종료 통제 목록에 있는 주문을 제외해 화면이 통째로 비게 된다.',p);done();
}

// ── 14 확정주문 검사 비활성 ────────────────────────────────────
{
 const p=[text(35,46,'확정된 주문도 후공정 탭에서는 수정됩니다',30,C.ink,700),
  text(35,84,'확정주문을 막는 코드가 있지만 2014-06-11 요청으로 주석 처리되어 실행되지 않습니다',21,C.muted)];
 p.push(table(35,120,[{h:'탭',w:280},{h:'확정주문일 때',w:400},{h:'근거',w:350}],[
  {c:['용융도금 TAB05','경고만 하고 저장 진행','return 이 주석 처리'],color:[C.ink,C.amber,C.muted],bold:[1,1,0]},
  {c:['전기도금 TAB06','알림 후 저장 중단','정상 동작'],color:[C.ink,C.teal,C.muted],bold:[1,1,0]},
  {c:['후공정 TAB09','검사 자체를 하지 않음','검사 블록 전체가 주석'],color:[C.ink,C.red,C.muted],bold:[1,1,0],fill:C.rose}],{rh:52}));
 p.push(box(35,320,1030,140,'남아 있는 주석',
  ['“확정된 주문이라도 수정할수 있도록 수정 : 박성용요청 20140611”',
   '주석 안에는 확정주문 조회와 “확정된 주문입니다!” 알림, 그리고 저장 중단 코드가 그대로 들어 있습니다.',
   '조회용 SQL(STSselect)과 서비스의 확정주문 액티비티도 남아 있지만 이 화면에서 호출하지 않습니다.'],C.warm,19));
 p.push(box(35,480,1030,150,'조사할 때 유의할 점',
  ['확정 이후에 후공정 값이 바뀐 흔적이 있어도 그것만으로 비정상 조작이라고 볼 수 없습니다.',
   '변경 이력 표(TB_C10_QLT_DSN_CHG_HST)에 이 화면 이름이 남으므로 언제 누가 고쳤는지는 추적할 수 있습니다.',
   '다만 이 화면의 이력에는 어떤 값이 어떻게 바뀌었는지가 아니라 화면 이름만 남습니다.'],C.pale,19));
 save('14-confirmed-order.svg',665,'확정주문 검사 비활성','후공정 탭은 확정주문 검사를 하지 않아 확정된 주문도 수정되며 관련 코드는 주석 처리되어 있다.',p);done();
}

// ── 15 저장 경로별 대상표 ──────────────────────────────────────
{
 const p=[text(35,46,'세 저장 경로가 서로 다른 표를 건드립니다',30,C.ink,700),
  text(35,84,'각 경로 앞에 이력기록이 붙어 컬럼마다 전·후 값을 남깁니다. 이력기록이 실패하면 저장은 실행되지 않습니다',21,C.muted)];
 p.push(table(35,118,[{h:'경로',w:200},{h:'바꾸는 표',w:300},{h:'바꾸는 값',w:340},{h:'키',w:190}],[
  {c:['COR_save','TB_C10_QLT_DSN_MNF','조수·조합폭 1~10·S/T·제품폭범위','주문 + 주문행'],fill:C.pale},
  {c:['(같은 경로 2단계)','TB_C10_QLT_DSN_CMN','1T2C 유무','주문 + 주문행'],fill:C.pale},
  {c:['MSG_save','TB_C10_QLT_DSN_MSG1','정전 품질메세지 문구','주문 + 주문행']},
  {c:['PKG_save','TB_C10_QLT_DSN_CMN','포장메세지코드','주문 + 주문행']}],{rh:46}));
 p.push(text(35,378,'COR_save 는 두 표를 잇달아 바꿉니다',21,C.ink,700));
 const chain=[['이력기록(후공정)','MNF 컬럼별 전·후 기록'],['후공정 save','MNF UPDATE'],['이력기록(1T2C)','CMN 컬럼별 전·후 기록'],['1T2C save','CMN UPDATE']];
 chain.forEach(([a,b],i)=>{const x=35+i*262;
  p.push(rect(x,400,240,86,i%2?C.warm:C.gray));
  p.push(text(x+16,433,a,19,C.ink,700));p.push(text(x+16,463,b,17,C.muted));
  if(i<3)p.push(arrow(`M${x+244} 443H${x+258}`));});
 p.push(box(35,515,1030,150,'네 단계 중 하나라도 실패하면',
  ['그 자리에서 멈추고 뒤 단계는 실행되지 않습니다. 앞 단계까지의 변경은 트랜잭션 설정에 따라 처리됩니다.',
   '따라서 정전 값만 바뀌고 1T2C 는 그대로인 상태가 남을 수 있습니다. 두 값을 함께 확인하세요.',
   '이력은 TB_C10_QLT_DSN_CHG_HST 에 컬럼마다 한 행씩, OLD_VAL·NEW_VAL 과 함께 남습니다.'],C.rose,19));
 save('15-save-targets.svg',700,'저장 경로별 대상표','세 저장 경로가 제조표준, 설계공통, 정전 메세지 표를 각각 바꾸고 이력기록이 컬럼별 전후 값을 남긴다.',p);done();
}

// ── 16 빈칸 진단 순서도 ────────────────────────────────────────
{
 const p=[text(35,46,'값이 비어 보일 때 이 순서로 좁힙니다',30,C.ink,700),
  text(35,84,'후공정 탭의 빈칸은 원인이 다섯 가지입니다. 위에서부터 확인하면 대부분 첫 두 단계에서 끝납니다.',21,C.muted)];
 const steps=[
  ['① 화면 전체가 비었나?','그렇다','종료 처리된 주문 · 조회 SQL이 제외',C.rose],
  ['② 조수·조합폭1 만 비었나?','그렇다','S/T 유무가 Y 가 아님 · 표시 규칙',C.warm],
  ['③ SKID 칸이 비었나?','그렇다','제품형태가 Sheet 가 아님',C.warm],
  ['④ 보호필름 칸이 비었나?','그렇다','주문에 상세코드가 없거나 5자리 미만',C.pale],
  ['⑤ 메세지 칸이 비었나?','그렇다','설계 Key 의 정전 메세지 열이 비었거나 행 없음',C.pale]];
 steps.forEach(([q,y,a,f],i)=>{const yy=120+i*112;
  p.push(rect(35,yy,470,92,'#eef7f8',C.line));
  p.push(text(55,yy+40,q,21,C.ink,700));
  p.push(text(55,yy+72,'아니오 → 다음으로',17,C.muted));
  p.push(arrow(`M510 ${yy+46}H570`));
  p.push(rect(575,yy,490,92,f));
  p.push(text(595,yy+40,a,19,C.ink,700));
  if(i<4)p.push(arrow(`M270 ${yy+94}V${yy+118}`));});
 p.push(rect(35,690,1030,120,C.gray));
 p.push(text(55,728,'다섯 가지 모두 아니라면',22,C.ink,700));
 p.push(text(55,764,'앞 단계 자동설계가 그 컬럼까지 도달하지 못했을 수 있습니다. 폭 단계(C103100080) 오류부터 확인합니다.',19));
 p.push(text(55,794,'제품폭범위가 비었다면 폭여유 기준 조회 실패(KT03)로 그 앞에서 멈췄을 가능성이 큽니다.',19));
 save('16-blank-diagnosis.svg',845,'빈칸 진단 순서도','화면 전체, 조수와 조합폭, SKID, 보호필름, 메세지 순서로 빈칸의 원인을 좁힌다.',p);done();
}

// ── 17 폭 값의 계보 ────────────────────────────────────────────
{
 const p=[text(35,46,'후공정 화면의 폭 값 네 가지는 계보가 다릅니다',30,C.ink,700),
  text(35,84,'설명용 · 주문폭 1,000 · 폭여유 2 · 인수도 폭공차 −3 / +3 · Slit 없음',21,C.muted)];
 p.push(rect(35,120,240,90,'#e8eef8'));p.push(text(55,158,'주문폭',20,C.ink,700));p.push(text(55,190,'1,000',28,C.ink,700));
 p.push(arrow('M280 145H345'));p.push(arrow('M280 185H345'));
 p.push(rect(350,110,330,80,C.pale));p.push(text(370,142,'제품폭범위 하한·상한',19,C.ink,700));
 p.push(text(370,172,'997 ~ 1,003   = 주문폭 + 인수도공차',18));
 p.push(rect(350,200,330,80,C.mint));p.push(text(370,232,'정전폭목표값',19,C.ink,700));
 p.push(text(370,262,'1,002   = 주문폭 + 폭여유',18));
 p.push(arrow('M685 150H745'));p.push(arrow('M685 240H745'));
 p.push(rect(750,110,315,80,C.warm));p.push(text(770,142,'후공정 화면 “제품폭범위”',18,C.ink,700));
 p.push(text(770,172,'편집 가능 · MNF 에 저장',17,C.muted));
 p.push(rect(750,200,315,80,C.gray));p.push(text(770,232,'조합폭1 이 0 일 때 대체값',18,C.ink,700));
 p.push(text(770,262,'화면에만 쓰이고 저장 안 됨',17,C.muted));
 p.push(rect(35,310,1030,110,C.gray));
 p.push(text(55,348,'조합폭 1~10 은 또 다른 축입니다',22,C.ink,700));
 p.push(text(55,382,'Slit 주문에서 한 코일을 몇 갈래로 자를지와 각 갈래의 폭입니다. 제품폭범위·정전폭목표와 계산 관계가 없습니다.',19));
 p.push(rect(35,440,1030,190,C.pale));
 p.push(text(55,478,'헷갈리기 쉬운 세 가지',22,C.ink,700));
 p.push(table(55,496,[{h:'이름',w:300},{h:'뜻',w:400},{h:'후공정에서',w:290}],[
  {c:['제품폭범위','납품 허용 폭 구간','편집·저장 대상']},
  {c:['정전폭목표값','정전 공정에서 만들 폭','조회만 · 조합폭1 대체용']},
  {c:['조합폭 1~10','Slit 갈래별 폭','편집·저장 대상']}],{rh:40,size:18,hh:40}));
 save('17-width-lineage.svg',665,'폭 값의 계보','제품폭범위는 주문폭에 인수도 공차를, 정전폭목표는 폭여유를 더한 값이며 조합폭은 별개 축이다.',p);done();
}

// ── 18 추적 체크리스트 ─────────────────────────────────────────
{
 const p=[text(35,46,'실제 주문의 후공정 값을 추적하는 순서',30,C.ink,700),
  text(35,84,'왼쪽을 채운 뒤 오른쪽을 확인하면 어디서 값이 갈라졌는지 드러납니다',21,C.muted)];
 const rows=[
  ['1','주문을 고정한다','주문번호 · 주문행 · 제품형태 · 주문 Edge'],
  ['2','종료 여부를 본다','종료 통제 목록에 있으면 화면이 통째로 빔'],
  ['3','주문 값을 적는다','엠보스 · 적치방법 · 보호필름 상세코드 · 포장방법 · 조분할 세 값'],
  ['4','자동설계 결과를 적는다','S/T 유무 · 조수 · 조합폭 1~10 · 제품폭범위 · 방청유'],
  ['5','화면 표시를 대조한다','조수·조합폭1 이 숨겨졌는지, SKID 가 어느 갈래로 계산됐는지'],
  ['6','저장 이력을 본다','변경 이력 표에 이 화면 이름이 있는지, 시각이 확정 이후인지'],
  ['7','차선 행을 직접 본다','화면에 없는 제조구분 2·3 의 같은 컬럼 값'],
  ['8','재설계 여부를 확인한다','재설계했다면 손으로 고친 값과 메세지가 사라졌을 수 있음']];
 rows.forEach(([n,a,b],i)=>{const y=120+i*76;
  p.push(rect(35,y,1030,64,i%2?'#fafcfd':C.pale));
  p.push(pill(50,y+15,36,34,n,C.teal));
  p.push(text(102,y+40,a,20,C.ink,700));
  p.push(text(390,y+40,b,18));});
 p.push(box(35,740,1030,110,'기록해 둘 것',
  ['각 항목의 값과 함께 “어디서 봤는지”(화면 / DB / 로그)를 같이 적습니다.',
   '이 화면은 표시 규칙이 값을 감추기 때문에, 화면만 보고 적은 값은 DB 값과 다를 수 있습니다.'],C.warm,19));
 save('18-tracking-checklist.svg',885,'추적 체크리스트','주문 고정, 종료 확인, 주문 값, 설계 결과, 화면 대조, 이력, 차선 행, 재설계 순서로 추적한다.',p);done();
}
console.log(`Generated ${count} 후공정 SVG figures.`);
