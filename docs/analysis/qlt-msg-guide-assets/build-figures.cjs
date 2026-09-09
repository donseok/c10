// Code-authored diagrams for the 품질메세지 설계 guide. All numbers are illustrative, not operating data.
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


// ── 01 품질메세지 여섯 갈래 ─────────────────────────────────────
{
 const p=[text(35,46,'“품질메세지”라고 부르는 값은 여섯 갈래입니다',30,C.ink,700),
  text(35,84,'서로 다른 표에 살고, 만드는 기준도 고치는 화면도 다릅니다. 먼저 어느 갈래인지부터 가려야 합니다',21,C.muted)];
 const fam=[
  ['가. 제조구분별 품질메세지','TB_C10_QLT_DSN_MSG . QLT_MSG_NM','설계Key기준 C10B1040','적정·차선1·차선2 최대 3행','용융도금 TAB05 · 전기도금 TAB06',C.pale],
  ['나. 정전 품질메세지','TB_C10_QLT_DSN_MSG1 . QLT_MSG_NM','설계Key기준 C10B1040','주문당 항상 1행','후공정 TAB09',C.mint],
  ['다. 포장메세지','TB_C10_QLT_DSN_MSG_PKG . QLT_MSG_NM','이 저장소에 만드는 코드 없음','주문당 0 또는 1행','후공정 TAB09 (읽기 전용)',C.warm],
  ['라. CCL 공정품질메시지','TB_C10_QLT_DSN_CCL_BOM . CCL_QLT_MSG_TXT','칼라물성기준 TB_C10_CLR_MPR','칼라 BOM 행마다','칼라 TAB07',C.lilac],
  ['마. 지관발주메시지','TB_C10_QLT_DSN_CMN . PPR_RNG_PORD_TXT','지관발주메시지기준 C10B2290','주문당 1칸','주문정보 TAB01 (편집 가능)',C.gray],
  ['바. PE-FOAM 적용메시지','TB_C10_QLT_DSN_CMN . PE_FOAM_TXT','PE-FOAM적용메세지기준 C10B2300','주문당 1칸','주문정보 TAB01 (읽기 전용)',C.gray]];
 fam.forEach(([t,tb,src,cnt,scr,f],i)=>{
  const y=122+i*112;
  p.push(rect(35,y,1030,96,f));
  p.push(text(55,y+32,t,22,C.ink,700));
  p.push(text(55,y+64,tb,18,C.teal,700));
  p.push(text(55,y+88,'원천: '+src,17,C.muted));
  p.push(text(610,y+64,cnt,18));
  p.push(text(610,y+88,scr,17,C.muted));});
 p.push(box(35,806,505,150,'컬럼 이름이 갈래를 가리지 못합니다',
  ['가·나·다 는 컬럼 이름이 모두 QLT_MSG_NM 입니다.','SQL 로 그 이름을 찾으면 세 표가 함께 걸립니다.',
   '표 이름을 반드시 함께 보세요.'],C.rose,18));
 p.push(box(560,806,505,150,'이름은 메세지인데 아닌 것들',
  ['QLT_DSN_ERR_CD · QLT_DSN_ERR_MSG → 오류용','EAI 표의 QLT_DSN_MSG → 송신 플래그(A→B)',
   '자세한 것은 본문 12.5 절에.'],C.gray,18));
 save('01-six-families.svg',986,'품질메세지 여섯 갈래',
  '품질메세지는 제조구분별·정전·포장·CCL·지관발주·PE-FOAM 여섯 갈래로 나뉘며 표와 원천과 화면이 각각 다르다.',p);
}

// ── 02 한 주문이 만드는 행 ───────────────────────────────────────
{
 const p=[text(35,46,'자동설계 한 번이 만드는 메세지 행',30,C.ink,700),
  text(35,84,'설계Key 기준을 한 번 맞히면, 그 결과 한 줄에서 최대 네 행이 갈라져 나옵니다',21,C.muted)];
 p.push(rect(360,120,380,86,C.pale,C.teal));
 p.push(text(380,152,'설계Key기준 C10B1040',22,C.ink,700));
 p.push(text(380,184,'맞은 기준 한 줄',19,C.muted));
 p.push(arrow('M550 210V250'));
 p.push(rect(200,250,700,80,C.gray));
 p.push(text(220,282,'그 한 줄이 품고 있는 메세지 칸 네 개',21,C.ink,700));
 p.push(text(220,312,'QLT_MSG_NM1 · QLT_MSG_NM2 · QLT_MSG_NM3 · QLT_MSG_NM_COR',19,C.teal));
 [['QLT_MSG_NM1','제조구분 1','적정'],['QLT_MSG_NM2','제조구분 2','차선1'],
  ['QLT_MSG_NM3','제조구분 3','차선2'],['QLT_MSG_NM_COR','정전','주문당 1행']].forEach(([c,t,n],i)=>{
  const x=35+i*262;
  p.push(arrow(`M550 334V368H${x+110}V400`));
  p.push(rect(x,400,246,130,i===2?C.rose:(i===3?C.mint:C.gray)));
  p.push(text(x+16,434,c,19,C.teal,700));
  p.push(text(x+16,466,t,21,C.ink,700));
  p.push(text(x+16,498,n,18,C.muted));});
 p.push(rect(35,560,772,86,C.pale,C.teal));
 p.push(text(55,594,'TB_C10_QLT_DSN_MSG · 최대 3행',22,C.ink,700));
 p.push(text(55,624,'키: 주문번호 + 주문행 + 제조구분 · 원자재코드도 함께 들어감',18,C.muted));
 p.push(rect(823,560,242,86,C.mint,C.teal));
 p.push(text(843,594,'MSG1 · 항상 1행',22,C.ink,700));
 p.push(text(843,624,'키: 주문번호 + 주문행',18,C.muted));
 p.push(arrow('M158 530V560'));p.push(arrow('M420 530V560'));p.push(arrow('M682 530V560'));
 p.push(arrow('M944 530V560'));
 p.push(box(35,676,1030,110,'3행이 항상 다 생기지는 않습니다',
  ['제조구분 2·3 행은 그 구분의 제조표준번호(CRM_MNF_STD_NO1·2)가 있을 때만 만들어집니다.',
   '차선이 없는 주문이면 적정 1행만 남습니다. 반대로 정전 메세지 행은 조건 없이 항상 1행 넣습니다.'],C.warm));
 save('02-rows-per-order.svg',815,'한 주문이 만드는 메세지 행',
  '설계Key 기준 한 줄에서 제조구분별 최대 3행과 정전 1행이 갈라져 나온다.',p);
}

// ── 03 설계Key 13개 조건 ────────────────────────────────────────
{
 const p=[text(35,46,'메세지를 결정하는 조건은 열세 개입니다',30,C.ink,700),
  text(35,84,'이 열세 값을 한 배열로 묶어 설계Key기준에 넘기고, 맞는 줄 하나를 받아 옵니다',21,C.muted)];
 const cols=[{h:'자리',w:80},{h:'조건 항목',w:300},{h:'주문에서 오는 값',w:380},{h:'Match 성격',w:270}];
 const rows=[
  {c:['0','품명','PRD_NM_CD','필수'],bold:[0,0,0,1]},
  {c:['1','제품형태','PRD_SHP','필수'],bold:[0,0,0,1]},
  {c:['2','규격약호','SPC_AVR','필수'],bold:[0,0,0,1]},
  {c:['3','주문용도코드','ORD_USG_CD','선택 · 3단계로 넓힘'],fill:'#fff8ee',bold:[0,0,0,1]},
  {c:['4','최종고객사코드','FNL_CUS_CD','선택 · * 로 넓힘'],fill:'#fff8ee',bold:[0,0,0,1]},
  {c:['5','고객사양번호','CUS_BTH_PAP_NO','선택 · * 로 넓힘'],fill:'#fff8ee',bold:[0,0,0,1]},
  {c:['6','엠보스무늬','EMBS_CD','필수'],bold:[0,0,0,1]},
  {c:['7','주문Spangle구분','ORD_SPNL_TP','필수'],bold:[0,0,0,1]},
  {c:['8','주문도금량지정코드','GW_ASG_CD','필수'],bold:[0,0,0,1]},
  {c:['9','주문표면처리코드','ORD_SUR_HND_CD','필수'],bold:[0,0,0,1]},
  {c:['10','색상코드','CCL BOM 번호 앞 5자리','선택 · * 로 넓힘'],fill:'#fff8ee',bold:[0,0,0,1]},
  {c:['11','주문두께','ORD_EXC_THK','필수 · 범위 비교'],bold:[0,0,0,1]},
  {c:['12','주문폭','아래 설명 참조','필수 · 범위 비교'],bold:[0,0,0,1]}];
 p.push(table(35,120,cols,rows,{rh:42,hh:46}));
 p.push(box(35,730,505,150,'주문폭은 그대로 쓰지 않습니다',
  ['Slit 조수가 0보다 크면 조합폭 1~10 을 모두 더한 값을 주문폭으로 씁니다.','그렇지 않을 때만 주문폭 컬럼을 그대로 씁니다.',
   '→ 조합폭을 고치면 맞는 기준 줄이 바뀔 수 있습니다.'],C.pale,18));
 p.push(box(560,730,505,150,'노란 네 줄이 “선택 조건”입니다',
  ['맞는 줄이 없으면 이 네 가지를 차례로 * 로 바꾸며','다시 찾습니다. 그래서 주문이 달라도 같은 메세지가',
   '붙을 수 있습니다. 넓히는 순서는 다음 그림에.'],C.warm,18));
 save('03-design-key.svg',910,'설계Key 열세 조건',
  '품질메세지를 결정하는 설계Key 조건 열세 개와 그중 넓힐 수 있는 선택 조건 네 개.',p);
}

// ── 04 우선순위 Match 하강 (순서도) ──────────────────────────────
{
 const p=[text(35,46,'맞는 줄이 없으면 조건을 넓혀 다시 찾습니다',30,C.ink,700),
  text(35,84,'자동차 주행거리계처럼 안쪽 자리부터 올리고, 다 차면 한 칸 위를 올린 뒤 안쪽을 되돌립니다',21,C.muted)];
 p.push(pill(430,120,240,48,'열세 조건으로 조회'));
 p.push(arrow('M550 168V206'));
 p.push(diamond(550,250,300,88,['맞는 줄이 있는가']));
 p.push(arrow('M700 250H900V300'));
 p.push(text(712,240,'있음',18,C.teal,700));
 p.push(rect(770,300,260,96,C.mint));
 p.push(text(790,336,'ctx 로 옮기고 종료',21,C.ink,700));
 p.push(text(790,368,'메세지 저장 단계로',18,C.muted));
 p.push(arrow('M550 294V330'));
 p.push(text(566,320,'없음',18,C.red,700));
 p.push(diamond(400,376,330,88,['고객사양번호가','주문에 지정돼 있는가'],C.rose));
 p.push(arrow('M565 376H700V420',C.red));
 p.push(text(578,366,'지정',18,C.red,700));
 p.push(rect(700,420,330,84,C.rose));
 p.push(text(720,454,'즉시 실패 · 에러코드 KK01',21,C.red,700));
 p.push(text(720,484,'넓히지 않습니다',18,C.muted));
 p.push(arrow('M400 420V456'));
 p.push(text(416,446,'미지정(********** 로 대체됨)',17,C.muted));
 p.push(rect(35,456,730,300,C.gray));
 p.push(text(55,492,'넓히는 순서 — 안쪽 자리부터',23,C.ink,700));
 const dial=[['③ 색상코드','가장 바깥','CCL BOM 앞 5자리 → *****'],
  ['② 최종고객사코드','가운데','실제 코드 → ******'],
  ['① 주문용도코드','가장 안쪽','3단계로 넓힘 (다음 그림)']];
 dial.forEach(([a,b,c],i)=>{const y=520+i*74;
  p.push(rect(55,y,690,62,i===2?C.warm:'#fff'));
  p.push(text(75,y+40,a,21,C.ink,700));
  p.push(text(300,y+40,b,18,C.muted));
  p.push(text(430,y+40,c,18));});
 p.push(text(55,742,'①이 끝까지 넓혀지면 ②를 한 칸 올리고 ①을 원래 값으로 되돌린 뒤 다시 시작합니다.',18,C.muted));
 p.push(arrow('M400 756V800'));
 p.push(pill(390,800,320,48,'넓힌 값으로 다시 조회','#5a6b7d'));
 p.push(arrow('M390 824H100V144H430',C.muted,2));
 p.push(text(112,136,'되돌아가 반복',18,C.muted,700));
 p.push(box(35,880,1030,100,'셋 다 끝까지 넓혔는데도 못 찾으면',
  ['주문용도코드가 ****** 이고 고객사코드도 ****** 이고 색상코드도 ***** 인 상태에서 실패하면 에러코드 KK01 로 끝납니다.',
   '반대로 맞는 줄이 두 줄 이상이면 에러코드 KK02 입니다. 기준이 중복 등록된 경우입니다.'],C.rose));
 save('04-match-cascade.svg',1010,'우선순위 Match 하강 순서',
  '맞는 기준 줄이 없으면 주문용도코드·고객사코드·색상코드를 안쪽부터 차례로 넓혀 다시 찾는다.',p);
}

// ── 05 주문용도코드 3단 확장 (순서도) ────────────────────────────
{
 const p=[text(35,46,'주문용도코드는 세 단계로 넓힙니다',30,C.ink,700),
  text(35,84,'여섯 자리를 뒤에서부터 별표로 덮어 갑니다. 앞자리가 남아 있을수록 더 좁은 기준입니다',21,C.muted)];
 const steps=[['원래 값','ABCDEF','주문에 적힌 그대로 · 가장 좁음',C.pale],
  ['1단계','ABC***','앞 세 자리만 남김',C.gray],
  ['2단계','A*****','앞 한 자리만 남김',C.gray],
  ['3단계','******','용도를 아예 보지 않음 · 가장 넓음',C.warm]];
 steps.forEach(([t,v,d,f],i)=>{const y=125+i*128;
  p.push(rect(35,y,1030,108,f));
  p.push(text(55,y+42,t,22,C.ink,700));
  p.push(text(190,y+46,v,34,C.teal,700));
  p.push(text(430,y+42,d,20));
  p.push(text(430,y+78,i===0?'여기서 못 찾으면 ↓':(i===3?'여기서도 못 찾으면 고객사코드를 넓힙니다':'여기서 못 찾으면 ↓'),18,C.muted));
  if(i<3)p.push(arrow(`M550 ${y+108}V${y+128}`));});
 p.push(box(35,645,505,190,'코드가 한 번에 안 바뀝니다',
  ['현재 값의 모양을 보고 다음 단계를 정합니다.','“ABC***” 모양이면 → “A*****”',
   '“A*****” 모양이면 → “******”','그 외(별표 없음)면 → 원본 앞 세 자리 + “***”'],C.pale,18));
 p.push(box(560,645,505,190,'주의: 원본에서 다시 자릅니다',
  ['1단계로 갈 때는 현재 값이 아니라 ctx 의','원래 주문용도코드에서 앞 세 자리를 뜁니다.',
   '주문용도코드가 비어 있으면 공백 세 칸에','별표 세 개를 붙인 값을 씁니다.'],C.warm,18));
 save('05-usage-widening.svg',865,'주문용도코드 세 단계 확장',
  '주문용도코드는 원래 값에서 ABC***, A*****, ****** 순으로 넓혀 가며 기준을 다시 찾는다.',p);
}

// ── 06 기준값이 ctx 로 옮겨지는 경로 ─────────────────────────────
{
 const p=[text(35,46,'기준의 메세지 칸이 저장용 값으로 옮겨지는 경로',30,C.ink,700),
  text(35,84,'이 옮김이 한 칸 밀려 있습니다. 그래서 마지막 갈래가 저장 단계에서 길을 잃습니다',21,C.muted)];
 const cols=[{h:'기준(C10B1040)의 칸',w:280},{h:'→ 담기는 이름',w:280},{h:'저장할 때 찾는 이름',w:280},{h:'결과',w:190}];
 const rows=[
  {c:['QLT_MSG_NM1','QLT_MSG_NM','QLT_MSG_NM','맞음'],color:[C.ink,C.ink,C.ink,C.green],bold:[0,0,0,1]},
  {c:['QLT_MSG_NM2','QLT_MSG_NM1','QLT_MSG_NM1','맞음'],color:[C.ink,C.ink,C.ink,C.green],bold:[0,0,0,1]},
  {c:['QLT_MSG_NM3','QLT_MSG_NM2','QLT_MSG_NM3','어긋남'],fill:C.rose,color:[C.ink,C.red,C.red,C.red],bold:[0,1,1,1]},
  {c:['QLT_MSG_NM_COR','QLT_MSG_NM_COR','QLT_MSG_NM_COR','맞음'],color:[C.ink,C.ink,C.ink,C.green],bold:[0,0,0,1]}];
 p.push(table(35,120,cols,rows,{rh:52,hh:48}));
 p.push(box(35,360,1030,150,'세 번째 줄만 이름이 다릅니다',
  ['기준의 세 번째 메세지는 “QLT_MSG_NM2”라는 이름으로 담깁니다. 그런데 저장 단계는 “QLT_MSG_NM3”이라는 이름을 찾습니다.',
   '그 이름으로 담긴 값은 어디에도 없습니다. 저장소 전체를 찾아봐도 그 이름으로 값을 담는 곳이 없습니다.',
   '찾지 못하면 빈 문자열을 대신 넣습니다. 그리고 Oracle 은 빈 문자열을 NULL 로 저장합니다.'],C.rose));
 p.push(rect(35,530,1030,110,C.warm));
 p.push(text(55,566,'눈에 보이는 증상',23,C.ink,700));
 p.push(text(55,600,'차선2(제조구분 3) 행은 만들어지기는 하지만 메세지 칸이 늘 비어 있습니다. 기준에 문구를 넣어도 화면에 나타나지 않습니다.',19));
 p.push(text(55,628,'적정과 차선1 은 정상입니다. 그래서 “기준 등록이 잘못됐나” 하고 기준부터 들여다보기 쉽습니다.',19,C.muted));
 save('06-master-to-ctx.svg',670,'기준값이 저장값으로 옮겨지는 경로',
  '기준의 세 번째 메세지는 QLT_MSG_NM2 라는 이름으로 담기는데 저장 단계는 QLT_MSG_NM3 을 찾아 값을 잃는다.',p);
}

// ── 07 메세지 3행 생성 조건 (순서도) ────────────────────────────
{
 const p=[text(35,46,'제조구분별 메세지 행이 만들어지는 조건',30,C.ink,700),
  text(35,84,'메세지가 있느냐가 아니라, 그 제조구분의 제조표준번호가 있느냐로 행을 만듭니다',21,C.muted)];
 const lanes=[['적정','CRM_MNF_STD_NO','QLT_MSG_NM','제조구분 1',C.pale,false],
  ['차선1','CRM_MNF_STD_NO1','QLT_MSG_NM1','제조구분 2',C.pale,false],
  ['차선2','CRM_MNF_STD_NO2','QLT_MSG_NM3 (없는 이름)','제조구분 3',C.rose,true]];
 lanes.forEach(([n,std,msg,tp,f,bad],i)=>{
  const y=125+i*220;
  p.push(text(35,y+38,n,26,C.ink,700));
  p.push(diamond(300,y+52,300,80,[std+' 이','비어 있지 않은가'],f==C.rose?'#fbe3e0':'#e2f1f0'));
  p.push(arrow(`M108 ${y+52}H146`));
  p.push(arrow(`M450 ${y+52}H560`));
  p.push(text(468,y+42,'예',18,C.teal,700));
  p.push(diamond(720,y+52,280,80,[msg,'값이 있는가'],f==C.rose?'#fbe3e0':'#e2f1f0',bad?17:19));
  p.push(arrow(`M860 ${y+52}H960`));
  p.push(text(872,y+42,'예',18,C.teal,700));
  p.push(rect(960,y+22,105,60,C.mint));
  p.push(text(978,y+58,'문구 저장',18,C.green,700));
  p.push(arrow(`M720 ${y+92}V${y+140}H960`,C.red));
  p.push(text(736,y+126,'아니오 → 빈 문자열',18,C.red,700));
  p.push(rect(960,y+112,105,58,C.rose));
  p.push(text(984,y+148,'빈칸',18,C.red,700));
  p.push(arrow(`M300 ${y+92}V${y+170}`,C.muted,2));
  p.push(text(316,y+160,'아니오 → 이 행 자체를 만들지 않음',18,C.muted));
  p.push(text(560,y+178,tp+' 행',18,C.muted,700));
  if(bad)p.push(text(35,y+78,'항상 빈칸',18,C.red,700));});
 p.push(box(35,790,1030,150,'그래서 두 가지가 서로 다릅니다',
  ['행이 없다 = 그 제조구분의 제조표준 자체가 설계되지 않았다. 화면에서 그 차선을 고를 수 없습니다.',
   '행은 있는데 메세지가 비었다 = 기준에 문구가 없거나, 차선2 처럼 옮기다 잃어버린 것입니다.',
   '조사할 때 이 둘을 먼저 갈라야 합니다. 표에 행이 있는지부터 확인하세요.'],C.warm));
 save('07-three-rows.svg',970,'제조구분별 메세지 행 생성 조건',
  '메세지 행은 그 제조구분의 제조표준번호가 있을 때만 만들어지고, 문구가 없으면 빈 문자열이 들어간다.',p);
}

// ── 08 정전메세지 저장 (순서도) ─────────────────────────────────
{
 const p=[text(35,46,'정전 메세지는 조건 없이 항상 한 행을 넣습니다',30,C.ink,700),
  text(35,84,'제조구분별 메세지와 달리 “있으면 넣는다”가 아니라 “무조건 넣는다”입니다',21,C.muted)];
 p.push(rect(35,120,500,290,C.pale));
 p.push(text(55,158,'제조구분별 메세지 (MSG)',24,C.ink,700));
 p.push(text(55,196,'① 제조표준번호가 있는 구분만 목록에 담고',19));
 p.push(text(55,228,'② 목록을 돌면서 한 행씩 INSERT',19));
 p.push(text(55,266,'행 수: 0 ~ 3',21,C.teal,700));
 p.push(text(55,304,'값이 없으면 빈 문자열',19,C.muted));
 p.push(text(55,342,'원자재코드도 함께 저장',19,C.muted));
 p.push(text(55,380,'제조구분 컬럼 있음',19,C.muted));
 p.push(rect(565,120,500,290,C.mint));
 p.push(text(585,158,'정전 메세지 (MSG1)',24,C.ink,700));
 p.push(text(585,196,'① 조건 검사 없음',19));
 p.push(text(585,228,'② 곧바로 한 행 INSERT',19));
 p.push(text(585,266,'행 수: 언제나 1',21,C.green,700));
 p.push(text(585,304,'값을 그대로 넘김 (빈 문자열로 안 바꿈)',19,C.muted));
 p.push(text(585,342,'원자재코드 없음',19,C.muted));
 p.push(text(585,380,'제조구분 컬럼 없음',19,C.muted));
 p.push(arrow('M285 410V450'));p.push(arrow('M815 410V450'));
 p.push(rect(35,450,500,96,C.gray));
 p.push(text(55,486,'적정·차선1·차선2 중 설계된 것만',20,C.ink,700));
 p.push(text(55,518,'차선이 없으면 1행뿐입니다',18,C.muted));
 p.push(rect(565,450,500,96,C.gray));
 p.push(text(585,486,'기준에 정전 문구가 없어도 행은 생깁니다',20,C.ink,700));
 p.push(text(585,518,'그때 저장되는 값은 NULL 입니다',18,C.muted));
 p.push(box(35,576,1030,164,'“코드 경로는 다른데 결과는 같다”',
  ['제조구분별 경로는 값이 없으면 빈 문자열을 만들어 넣고, 정전 경로는 없는 값을 그대로 넘깁니다.',
   '자바 코드만 보면 두 경로가 달라 보이지만, Oracle 은 빈 문자열을 NULL 로 저장합니다.',
   '그래서 표에 남는 결과는 둘 다 NULL 로 같습니다. 이 차이로 원인을 가릴 수는 없습니다.'],C.warm));
 p.push(box(35,760,1030,110,'한 곳이라도 INSERT 가 실패하면',
  ['에러코드 TB09 를 남기고 그 주문의 설계를 실패로 끝냅니다. 메세지만 빠진 채 나머지가 저장되지는 않습니다.',
   '다만 앞서 지운 행은 이미 지워진 뒤입니다. 다음 그림의 수명주기를 함께 보세요.'],C.rose));
 save('08-cor-insert.svg',900,'정전 메세지 저장 경로',
  '정전 메세지는 조건 없이 항상 한 행을 넣고, 제조구분별 메세지는 설계된 구분만 행을 만든다.',p);
}

// ── 09 여섯 갈래 표 비교 ────────────────────────────────────────
{
 const p=[text(35,46,'여섯 갈래를 한자리에 놓고 보기',30,C.ink,700),
  text(35,84,'키가 다르면 “한 주문에 몇 행이냐”가 달라집니다. 조회 결과 건수를 읽을 때 먼저 확인할 것',21,C.muted)];
 const cols=[{h:'갈래',w:230},{h:'표',w:300},{h:'키',w:290},{h:'한 주문당',w:210}];
 const rows=[
  {c:['제조구분별','TB_C10_QLT_DSN_MSG','주문 + 주문행 + 제조구분','0 ~ 3행'],fill:C.pale},
  {c:['정전','TB_C10_QLT_DSN_MSG1','주문 + 주문행','항상 1행'],fill:'#eaf6f2'},
  {c:['포장','TB_C10_QLT_DSN_MSG_PKG','주문 + 주문행','0 또는 1행'],fill:C.warm},
  {c:['CCL 공정','TB_C10_QLT_DSN_CCL_BOM','주문 + 주문행 + BOM 순번','BOM 행마다'],fill:C.lilac},
  {c:['지관발주','TB_C10_QLT_DSN_CMN','주문 + 주문행','1칸'],fill:C.gray},
  {c:['PE-FOAM','TB_C10_QLT_DSN_CMN','주문 + 주문행','1칸'],fill:C.gray}];
 p.push(table(35,120,cols,rows,{rh:50,hh:48}));
 const cols2=[{h:'갈래',w:230},{h:'만드는 곳',w:340},{h:'화면',w:250},{h:'고칠 수 있나',w:210}];
 const rows2=[
  {c:['제조구분별','자동설계 설계Key 단계','TAB05 · TAB06','예'],fill:C.pale},
  {c:['정전','자동설계 설계Key 단계','TAB09','예'],fill:'#eaf6f2'},
  {c:['포장','이 저장소에 없음','TAB09','아니오 · 코드만'],fill:C.warm,color:[C.ink,C.red,C.ink,C.ink],bold:[0,1,0,0]},
  {c:['CCL 공정','자동설계 CCL제조사양 단계','TAB07','예'],fill:C.lilac},
  {c:['지관발주','자동설계 CCL제조사양 단계','TAB01','예'],fill:C.gray},
  {c:['PE-FOAM','자동설계 CCL제조사양 단계','TAB01','아니오'],fill:C.gray}];
 p.push(table(35,470,cols2,rows2,{rh:50,hh:48}));
 p.push(box(35,820,1030,132,'표 이름이 헷갈리기 쉽습니다',
  ['MSG 와 MSG1 은 이름이 한 글자 차이인데 담는 것이 다릅니다. MSG 는 제조구분별, MSG1 은 정전용입니다.',
   'MSG1 에는 제조구분 컬럼이 아예 없습니다. 그래서 후공정 화면에는 적정·차선 개념이 없습니다.',
   '지관발주와 PE-FOAM 은 별도 표가 아니라 설계공통 표의 컬럼입니다. 주문 한 건에 한 칸씩입니다.'],C.gray));
 save('09-tables.svg',982,'메세지 여섯 갈래 표 비교',
  '메세지 여섯 갈래의 표, 키, 주문당 행 수, 만드는 곳, 편집 화면을 나란히 비교한다.',p);
}

// ── 10 화면별 메세지 칸 ─────────────────────────────────────────
{
 const p=[text(35,46,'세 화면이 각각 다른 메세지를 보여줍니다',30,C.ink,700),
  text(35,84,'같은 품질설계결과 화면(C104000020)의 탭이지만, 읽는 표와 범위가 다릅니다',21,C.muted)];
 const scr=[
  ['용융도금 TAB05','Grid_7','TB_C10_QLT_DSN_MSG','화면에서 고른 적정·차선을 따라감','한 줄 입력칸',C.pale],
  ['전기도금 TAB06','Grid_8','TB_C10_QLT_DSN_MSG','적정(제조구분 1)에 고정','한 줄 입력칸',C.gray],
  ['후공정 TAB09','Grid_4','TB_C10_QLT_DSN_MSG1','제조구분 개념 없음','여러 줄 입력칸',C.mint]];
 scr.forEach(([t,g,tb,rng,ed,f],i)=>{const x=35+i*345;
  p.push(rect(x,120,330,250,f));
  p.push(text(x+18,158,t,23,C.ink,700));
  p.push(text(x+18,190,g,18,C.muted));
  p.push(text(x+18,232,tb,18,C.teal,700));
  p.push(text(x+18,272,'범위',17,C.muted));
  p.push(text(x+18,300,rng,18));
  p.push(text(x+18,336,'입력칸: '+ed,18,C.muted));});
 p.push(box(35,392,1030,140,'세 화면 모두 “메세지” 라벨 한 칸짜리 세로 그리드입니다',
  ['열 정의는 네댓 개지만 헤더를 쓰지 않고, 첫 칸은 “메세지”라는 글자를 박아 둔 라벨입니다.',
   '실제 데이터가 들어가는 칸은 품질Message 하나뿐입니다. 나머지는 주문번호·주문행 같은 숨김 열입니다.',
   '후공정 탭만 입력칸 종류가 여러 줄짜리라 긴 문구를 줄바꿈해 넣을 수 있습니다.'],C.gray));
 p.push(rect(35,552,1030,110,C.warm));
 p.push(text(55,588,'그리드 정의의 표 이름이 실제와 다릅니다',23,C.ink,700));
 p.push(text(55,622,'TAB05·TAB06 의 숨김 열은 표 이름이 원자재 표로 적혀 있고, TAB09 는 MSG 로 적혀 있지만 실제로 읽는 것은 MSG1 입니다.',18));
 p.push(text(55,650,'화면 정의 파일의 표 이름은 참고만 하고, 실제 표는 조회 SQL 로 확인하세요.',18,C.muted));
 save('10-screens.svg',692,'화면별 메세지 칸',
  '용융도금·전기도금·후공정 세 탭이 각각 다른 표와 범위로 메세지를 보여준다.',p);
}

// ── 11 저장 범위 (순서도) ──────────────────────────────────────
{
 const p=[text(35,46,'같은 칸을 고쳐도 저장되는 행이 다릅니다',30,C.ink,700),
  text(35,84,'세 탭의 저장 SQL 이 WHERE 절에서 제조구분을 다루는 방식이 제각각입니다',21,C.muted)];
 const lanes=[
  ['용융도금 TAB05','AND QLT_DSN_MNF_TP = :QLT_DSN_MNF_TP','화면에서 고른 그 구분 한 행',C.pale,'선택을 따라감'],
  ['전기도금 TAB06','AND QLT_DSN_MNF_TP = \'1\'','적정 한 행 (값이 박혀 있음)',C.gray,'차선을 골라도 적정이 바뀜'],
  ['후공정 TAB09','(제조구분 조건 없음)','그 주문의 MSG1 한 행',C.mint,'MSG1 에 제조구분이 없어 자연스러움']];
 lanes.forEach(([t,w,r,f,note],i)=>{const y=125+i*196;
  p.push(rect(35,y,1030,170,f));
  p.push(text(55,y+40,t,24,C.ink,700));
  p.push(text(55,y+80,'WHERE 주문번호 + 주문행',19,C.muted));
  p.push(text(55,y+112,w,20,i===1?C.red:C.teal,700));
  p.push(arrow(`M600 ${y+100}H680`));
  p.push(rect(700,y+66,345,72,'#fff'));
  p.push(text(718,y+110,r,19,C.ink,700));
  p.push(text(718,y+150,note,18,i===1?C.red:C.muted));});
 p.push(box(35,715,1030,158,'전기도금 탭은 조회도 적정에 고정돼 있습니다',
  ['조회 SQL 도 제조구분 1 로 박혀 있고, 변경이력을 남길 때 쓰는 조건도 제조구분 1 로 박혀 있습니다.',
   '세 군데가 모두 같은 방향이라 적정만 다루도록 만든 화면으로 읽힙니다. 다만 화면 스크립트는 고른 제조구분을 넘기고 있습니다.',
   '반면 용융도금 탭은 화면에서 고른 적정·차선을 그대로 따라가므로, 차선의 메세지를 따로 고칠 수 있습니다.'],C.warm));
 save('11-save-scope.svg',903,'탭별 메세지 저장 범위',
  '용융도금은 선택한 제조구분을, 전기도금은 적정만, 후공정은 정전 표의 한 행을 저장한다.',p);
}

// ── 12 조회 필터 차이 ──────────────────────────────────────────
{
 const p=[text(35,46,'메세지가 안 보일 때 — 조회 필터부터 봅니다',30,C.ink,700),
  text(35,84,'세 탭의 메세지 조회 SQL 은 WHERE 절이 서로 다릅니다. 종료주문 필터는 한 곳에만 있습니다',21,C.muted)];
 const cols=[{h:'탭',w:230},{h:'읽는 표',w:250},{h:'제조구분 조건',w:290},{h:'종료주문 필터',w:260}];
 const rows=[
  {c:['용융도금 TAB05','MSG','화면이 넘긴 값','없음'],fill:C.pale},
  {c:['전기도금 TAB06','MSG','\'1\' 로 고정','없음'],fill:C.gray},
  {c:['후공정 TAB09','MSG1','(컬럼 자체가 없음)','있음'],fill:C.mint,color:[C.ink,C.ink,C.ink,C.red],bold:[0,0,0,1]}];
 p.push(table(35,120,cols,rows,{rh:58,hh:50}));
 p.push(rect(35,320,1030,120,C.rose));
 p.push(text(55,356,'후공정 탭에만 걸린 필터',23,C.ink,700));
 p.push(text(55,392,'주문이 종료 처리되어 있으면 조회 결과가 0건이 됩니다. 설계가 정상이어도 메세지 칸이 통째로 빕니다.',19));
 p.push(text(55,422,'같은 주문에서 용융·전기 탭은 메세지가 보이는데 후공정 탭만 비어 보이는 상황이 이 때문입니다.',19,C.muted));
 p.push(diamond(280,510,420,80,['같은 주문인데 후공정 탭만 비었는가'],'#fbe3e0',19));
 p.push(arrow('M490 510H700'));
 p.push(rect(700,470,365,80,C.warm));
 p.push(text(718,518,'종료주문 여부부터 확인',21,C.ink,700));
 p.push(arrow('M280 550V610',C.muted,2));
 p.push(text(296,596,'아니오',18,C.muted));
 p.push(rect(35,610,630,80,C.gray));
 p.push(text(55,658,'세 탭 모두 비었다면 표에 행이 없는 것입니다',21,C.ink,700));
 p.push(box(35,710,1030,132,'전기도금 탭이 비어 보이는 다른 이유',
  ['전기도금 탭은 적정(제조구분 1)만 읽습니다. 적정 행이 없고 차선만 있는 주문이면 이 탭에서는 아무것도 안 보입니다.',
   '그런 주문에서도 용융도금 탭은 차선을 골라 메세지를 볼 수 있습니다.',
   '탭마다 보이는 범위가 다르다는 점을 기억하면 “화면 버그”로 오해하지 않습니다.'],C.gray));
 save('12-select-filters.svg',872,'탭별 메세지 조회 필터',
  '세 탭의 메세지 조회 조건이 다르고, 종료주문 필터는 후공정 탭에만 있다.',p);
}

// ── 13 수명주기 (순서도) ───────────────────────────────────────
{
 const p=[text(35,46,'메세지 행의 수명 — 지우고 다시 만듭니다',30,C.ink,700),
  text(35,84,'자동설계는 고쳐 쓰지 않습니다. 통째로 지운 뒤 처음부터 다시 넣습니다',21,C.muted)];
 const steps=[['① JOB 시작','설계 대상 주문을 잡습니다',C.gray],
  ['② 상태를 J 로 바꾸고 커밋','여기까지가 한 덩어리',C.pale],
  ['③ 설계 결과를 표별로 삭제','성분·재질·인수도·제조사양·원자재·BOM·통과공정 다음이 메세지입니다',C.rose],
  ['④ 메세지 삭제 · 정전메세지 삭제','상태가 J 인 주문의 행을 모두 지웁니다',C.rose],
  ['⑤ 설계Key 단계에서 다시 생성','기준을 맞히고 메세지 행을 새로 넣습니다',C.mint],
  ['⑥ 나머지 설계 단계 진행','규격·고객·보증·원자재·제조사양·폭 …',C.gray],
  ['⑦ 다음 주문으로 되돌아감','대상이 남아 있으면 ② 로',C.gray]];
 steps.forEach(([t,d,f],i)=>{const y=120+i*106;
  p.push(rect(35,y,1030,88,f));
  p.push(text(55,y+38,t,22,C.ink,700));
  p.push(text(55,y+70,d,18,C.muted));
  if(i<6)p.push(arrow(`M550 ${y+88}V${y+106}`));});
 p.push(box(35,880,505,180,'③④ 와 ⑤ 사이가 위험 구간입니다',
  ['지우는 것과 다시 넣는 것이 서로 다른 커밋 단위에','들어 있습니다. 중간에 설계가 실패하면 메세지가',
   '지워진 채로 남을 수 있습니다.','재설계 직후 메세지가 비어 있다면 이 구간을 의심하세요.'],C.warm,18));
 p.push(box(560,880,505,180,'삭제 조건은 상태값 하나뿐입니다',
  ['주문번호를 지정하지 않고, 설계공통 표의 상태가','J 인 주문 전체를 지웁니다.',
   '그래서 특정 주문만 골라 메세지를 되살리는 경로는','자동설계 안에 없습니다.'],C.gray,18));
 save('13-lifecycle.svg',1090,'메세지 행의 수명주기',
  '자동설계는 상태가 J 인 주문의 메세지를 모두 지운 뒤 설계Key 단계에서 다시 만든다.',p);
}

// ── 14 반복주문 설계복사 ────────────────────────────────────────
{
 const p=[text(35,46,'반복주문은 기준을 다시 맞히지 않고 그대로 베낍니다',30,C.ink,700),
  text(35,84,'대표주문의 메세지 행을 골라 새 주문번호만 갈아 끼워 넣습니다',21,C.muted)];
 p.push(rect(35,120,440,230,C.pale));
 p.push(text(55,158,'대표주문',24,C.ink,700));
 p.push(text(55,196,'MSG · 제조구분별 행 그대로',19));
 p.push(text(55,228,'MSG1 · 정전 행 그대로',19));
 p.push(text(55,268,'사람이 화면에서 고친 문구도',18,C.muted));
 p.push(text(55,296,'그대로 따라옵니다',18,C.muted));
 p.push(text(55,332,'원자재코드·제조구분도 복사',18,C.muted));
 p.push(arrow('M475 235H620'));
 p.push(text(547,215,'복사',18,C.teal,700,'middle'));
 p.push(rect(620,120,445,230,C.mint));
 p.push(text(640,158,'새 주문',24,C.ink,700));
 p.push(text(640,196,'같은 문구가 그대로 들어감',19));
 p.push(text(640,228,'주문번호·주문행만 갈아 끼웁니다',19));
 p.push(text(640,268,'설계Key 기준을 다시 맞히지 않습니다',18,C.muted));
 p.push(text(640,296,'생성자 표시는 배치 이름으로 남습니다',18,C.muted));
 p.push(box(35,375,1030,150,'좋은 점과 조심할 점이 같은 뿌리입니다',
  ['좋은 점: 대표주문에서 손으로 다듬은 문구가 반복주문마다 그대로 재현됩니다.',
   '조심할 점: 대표주문의 메세지가 비어 있으면 새 주문도 빕니다. 기준을 고쳐도 복사본에는 오지 않습니다.',
   '차선2 메세지가 비는 문제도 복사로 그대로 번집니다. 원인은 새 주문이 아니라 대표주문에 있습니다.'],C.warm));
 p.push(rect(35,545,1030,110,C.rose));
 p.push(text(55,581,'포장메세지와 CCL 메세지는 이 복사 경로에 없습니다',23,C.ink,700));
 p.push(text(55,617,'복사되는 것은 MSG 와 MSG1 두 표뿐입니다. 포장메세지 표는 복사 대상 목록에 아예 없습니다.',19));
 save('14-copy.svg',685,'반복주문 설계복사',
  '반복주문은 대표주문의 메세지 행을 그대로 베끼며 설계Key 기준을 다시 맞히지 않는다.',p);
}

// ── 15 변경이력 기록 ───────────────────────────────────────────
{
 const p=[text(35,46,'화면에서 고친 메세지는 이력에 남습니다',30,C.ink,700),
  text(35,84,'세 탭 모두 저장 앞에 이력기록 액티비티가 붙어 있고, 추적 대상 컬럼이 품질Message 입니다',21,C.muted)];
 p.push(pill(60,130,200,48,'저장 버튼'));
 p.push(arrow('M260 154H340'));
 p.push(rect(340,118,330,72,C.pale,C.teal));
 p.push(text(358,164,'이력기록 액티비티',22,C.ink,700));
 p.push(arrow('M670 154H750'));
 p.push(rect(750,118,315,72,C.gray));
 p.push(text(768,164,'메세지 저장 SQL',22,C.ink,700));
 p.push(dash('M505 190V240'));
 p.push(rect(200,240,700,110,C.mint));
 p.push(text(220,278,'TB_C10_QLT_DSN_CHG_HST 에 컬럼 단위로 한 행',23,C.ink,700));
 p.push(text(220,312,'대상 표 · 키 · 컬럼명(QLT_MSG_NM) · 이전값 · 새값 · 화면 이름',19,C.muted));
 const cols=[{h:'탭',w:230},{h:'이력의 대상 표',w:290},{h:'이력이 쓰는 키',w:330},{h:'추적 컬럼',w:180}];
 const rows=[
  {c:['용융도금 TAB05','TB_C10_QLT_DSN_MSG','주문 + 주문행 + 제조구분','QLT_MSG_NM'],fill:C.pale},
  {c:['전기도금 TAB06','TB_C10_QLT_DSN_MSG','주문 + 주문행 (구분은 1 고정)','QLT_MSG_NM'],fill:C.gray},
  {c:['후공정 TAB09','TB_C10_QLT_DSN_MSG1','주문 + 주문행','QLT_MSG_NM'],fill:C.mint}];
 p.push(table(35,380,cols,rows,{rh:56,hh:50}));
 p.push(box(35,620,505,190,'남는 것',
  ['누가 언제 고쳤는지','어느 화면·어느 탭에서 고쳤는지','바꾸기 전 문구와 바꾼 뒤 문구','값이 실제로 달라진 컬럼만 한 행씩'],C.mint,18));
 p.push(box(560,620,505,190,'남지 않는 것',
  ['자동설계가 처음 만들어 넣은 값','자동설계가 지운 사실','반복주문 복사로 들어온 값',
   '→ 이력이 없다고 “고친 적 없다”가 아닙니다'],C.warm,18));
 save('15-history.svg',840,'메세지 변경이력 기록',
  '세 탭 모두 저장 앞에 이력기록이 붙어 품질Message 의 변경 전후를 컬럼 단위로 남긴다.',p);
}

// ── 16 포장메세지 두 조각 ───────────────────────────────────────
{
 const p=[text(35,46,'포장메세지 한 칸은 두 표에서 옵니다',30,C.ink,700),
  text(35,84,'후공정 탭이 코드와 문구를 이어 붙여 한 칸에 보여 줍니다. 저장되는 것은 코드뿐입니다',21,C.muted)];
 p.push(rect(35,120,480,180,C.pale));
 p.push(text(55,158,'앞 조각 — 코드',23,C.ink,700));
 p.push(text(55,196,'TB_C10_QLT_DSN_CMN.PAK_MSG_CD',19,C.teal,700));
 p.push(text(55,232,'화면 콤보에서 고르는 값',18,C.muted));
 p.push(text(55,268,'저장 대상입니다',19,C.green,700));
 p.push(rect(585,120,480,180,C.warm));
 p.push(text(605,158,'뒤 조각 — 문구',23,C.ink,700));
 p.push(text(605,196,'TB_C10_QLT_DSN_MSG_PKG.QLT_MSG_NM',19,C.teal,700));
 p.push(text(605,232,'바깥 조인으로 붙습니다',18,C.muted));
 p.push(text(605,268,'저장 대상이 아닙니다',19,C.red,700));
 p.push(arrow('M275 300V345H520'));
 p.push(arrow('M825 300V345H580'));
 p.push(rect(370,345,360,80,C.gray));
 p.push(text(390,393,'화면의 포장메세지 한 칸',22,C.ink,700));
 p.push(box(35,455,1030,164,'세 가지를 구분해야 합니다',
  ['코드는 있는데 문구가 없다 = 포장메세지 표에 그 주문 행이 없습니다. 바깥 조인이라 조회는 정상입니다.',
   '코드도 문구도 없다 = 설계공통 표의 포장메세지코드가 비어 있습니다.',
   '문구를 고치고 싶다 = 이 화면으로는 안 됩니다. 저장 SQL 이 코드만 씁니다.'],C.gray));
 p.push(rect(35,639,1030,120,C.rose));
 p.push(text(55,675,'포장메세지 표에 행을 넣는 코드가 이 저장소에 없습니다',23,C.ink,700));
 p.push(text(55,711,'조회 한 곳에서만 참조합니다. 자동설계도 이 표를 만들지 않고, 반복주문 복사 대상에도 없습니다.',19));
 p.push(text(55,739,'문구가 비어 있다면 이 저장소 밖에서 채워지는 값인지 먼저 확인해야 합니다.',19,C.muted));
 save('16-pack-message.svg',789,'포장메세지의 두 조각',
  '포장메세지 칸은 설계공통의 코드와 포장메세지 표의 문구를 이어 붙인 것이며 저장되는 것은 코드뿐이다.',p);
}

// ── 17 CCL 공정품질메시지 ───────────────────────────────────────
{
 const p=[text(35,46,'칼라 제품에는 메세지가 하나 더 있습니다',30,C.ink,700),
  text(35,84,'앞의 세 갈래와 표도 컬럼도 만드는 단계도 다릅니다. 이름만 “품질메시지”로 같습니다',21,C.muted)];
 const cols=[{h:'',w:230},{h:'앞의 세 갈래',w:400},{h:'CCL 공정품질메시지',w:430}];
 const rows=[
  {c:['표','MSG · MSG1 · MSG_PKG','TB_C10_QLT_DSN_CCL_BOM']},
  {c:['컬럼','QLT_MSG_NM','CCL_QLT_MSG_TXT'],bold:[0,1,1]},
  {c:['만드는 단계','설계Key (C102100020)','CCL제조사양 (C102100160)']},
  {c:['한 주문당','제조구분별 · 정전 · 포장','칼라 BOM 행마다']},
  {c:['편집 화면','TAB05 · TAB06 · TAB09','TAB07']},
  {c:['변경이력','남음','남음']},
  {c:['반복주문 복사','MSG · MSG1 만 복사','별도 경로로 복사']}];
 p.push(table(35,120,cols,rows,{rh:50,hh:48}));
 p.push(box(35,520,1030,150,'왜 헷갈리는가',
  ['화면에서는 둘 다 “품질메시지”라는 라벨을 답니다. 그런데 컬럼 이름이 다르므로 SQL 로 찾을 때는 헷갈리지 않습니다.',
   '반대로 화면만 보고 “메세지를 고쳤는데 반영이 안 된다”고 하면, 어느 탭에서 고쳤는지부터 물어야 합니다.',
   '칼라 탭에서 고친 문구는 MSG 표에 들어가지 않고, 도금 탭에서 고친 문구는 칼라 BOM 에 들어가지 않습니다.'],C.lilac));
 save('17-ccl-message.svg',700,'CCL 공정품질메시지',
  'CCL 공정품질메시지는 칼라 BOM 표의 다른 컬럼이며 만드는 단계와 편집 화면이 앞의 세 갈래와 다르다.',p);
}

// ── 18 빈칸 진단 (순서도) ──────────────────────────────────────
{
 const p=[text(35,46,'메세지 칸이 비었을 때 — 순서대로 좁힙니다',30,C.ink,700),
  text(35,84,'화면 → 조회 → 행 → 값 순으로 내려갑니다. 기준부터 열어 보는 것은 대개 마지막입니다',21,C.muted)];
 p.push(pill(420,120,260,48,'메세지 칸이 비었다'));
 p.push(arrow('M550 168V200'));

 p.push(diamond(300,244,420,80,['어느 탭에서 보고 있는가'],'#e2f1f0'));
 p.push(arrow('M510 244H760'));
 p.push(rect(760,204,305,80,C.lilac));
 p.push(text(778,238,'칼라 TAB07 이면',19,C.ink,700));
 p.push(text(778,266,'다른 표입니다 (그림 17)',18,C.muted));
 p.push(arrow('M300 284V320'));

 p.push(diamond(300,364,420,80,['후공정 탭인가'],'#e2f1f0'));
 p.push(arrow('M510 364H760'));
 p.push(rect(760,324,305,80,C.rose));
 p.push(text(778,358,'종료주문인지 먼저 확인',19,C.ink,700));
 p.push(text(778,386,'맞으면 조회가 0건입니다',18,C.muted));
 p.push(arrow('M300 404V440'));
 p.push(text(316,430,'아니오 (도금 탭)',18,C.muted));

 p.push(diamond(300,484,420,80,['전기도금 탭인가'],'#e2f1f0'));
 p.push(arrow('M510 484H760'));
 p.push(rect(760,444,305,80,C.warm));
 p.push(text(778,478,'적정 행이 있는지 확인',19,C.ink,700));
 p.push(text(778,506,'이 탭은 적정만 읽습니다',18,C.muted));
 p.push(arrow('M300 524V560'));

 p.push(diamond(300,604,420,88,['메세지 표에 그 행이','있는가'],'#e2f1f0'));
 p.push(arrow('M510 604H760',C.red));
 p.push(rect(760,564,305,80,C.rose));
 p.push(text(778,598,'행이 없다 → 그 제조구분의',19,C.ink,700));
 p.push(text(778,626,'제조표준이 설계되지 않았습니다',18,C.muted));
 p.push(arrow('M300 648V690'));
 p.push(text(316,680,'행은 있음',18,C.muted));

 p.push(diamond(300,734,420,88,['제조구분 3(차선2)','인가'],'#fbe3e0'));
 p.push(arrow('M510 734H760',C.red));
 p.push(rect(760,694,305,80,C.rose));
 p.push(text(778,728,'값을 옮기는 이름이 어긋나',19,C.red,700));
 p.push(text(778,756,'늘 비어 있습니다 (그림 6)',18,C.muted));
 p.push(arrow('M300 778V820'));

 p.push(rect(35,820,730,86,C.mint));
 p.push(text(55,856,'여기까지 왔으면 기준을 봅니다',22,C.ink,700));
 p.push(text(55,888,'설계Key 기준에서 맞은 줄의 메세지 칸이 실제로 비어 있는지 확인합니다',18,C.muted));

 p.push(box(35,926,1030,132,'기준을 확인할 때 주의할 것',
  ['조건을 넓혀 가며 찾기 때문에, 주문의 값과 정확히 같은 줄이 아니라 별표가 섞인 넓은 줄이 맞았을 수 있습니다.',
   '조합폭을 고치면 Key 의 주문폭이 달라져 맞는 줄이 바뀝니다. 폭을 고친 뒤 메세지가 달라졌다면 이 때문입니다.',
   '반복주문이면 기준을 아예 보지 않습니다. 대표주문의 값이 그대로 복사된 것입니다 (그림 14).'],C.warm));
 save('18-blank-diagnosis.svg',1088,'메세지 빈칸 진단 순서',
  '메세지가 비었을 때 탭·종료주문·제조구분·행 유무·차선2 여부를 차례로 좁힌 뒤 마지막에 기준을 확인한다.',p);
}
console.log(`Generated ${require("node:fs").readdirSync(__dirname).filter(f=>f.endsWith(".svg")).length} 품질메세지 SVG figures.`);
