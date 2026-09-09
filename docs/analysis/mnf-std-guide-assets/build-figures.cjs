// Code-authored diagrams for the 용융·전기 제조표준 guide. All numbers are illustrative, not operating data.
const fs = require('node:fs');
const path = require('node:path');
const C={ink:'#17324d',teal:'#007f86',muted:'#516579',line:'#b7c8d5',pale:'#eef7f8',gray:'#f2f5f8',warm:'#fff4e7',red:'#b3261e',rose:'#fdecea'};
const esc=s=>String(s).replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;');
const text=(x,y,s,size=22,color=C.ink,weight=400)=>`<text x="${x}" y="${y}" font-size="${size}" fill="${color}" font-weight="${weight}">${esc(s)}</text>`;
const rect=(x,y,w,h,fill=C.gray,stroke=C.line)=>`<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="12" fill="${fill}" stroke="${stroke}"/>`;
const arrow=(d,color=C.teal)=>`<path d="${d}" fill="none" stroke="${color}" stroke-width="3" marker-end="url(#arrow)"/>`;
function box(x,y,w,h,title,lines=[],fill=C.gray,size=20){return rect(x,y,w,h,fill)+text(x+18,y+34,title,23,C.ink,700)+lines.map((s,i)=>text(x+18,y+66+28*i,s,size)).join('');}
function table(x,y,cols,rows,opts={}){
 const rh=opts.rh||44,hh=opts.hh||46,size=opts.size||19;let p='';
 let cx=x;p+=`<rect x="${x}" y="${y}" width="${cols.reduce((a,c)=>a+c.w,0)}" height="${hh}" fill="#e3eef2"/>`;
 cols.forEach(c=>{p+=text(cx+10,y+30,c.h,size,C.ink,700);cx+=c.w;});
 rows.forEach((r,i)=>{const ry=y+hh+i*rh;const fill=r.fill||(i%2?'#fafcfd':'#fff');p+=`<rect x="${x}" y="${ry}" width="${cols.reduce((a,c)=>a+c.w,0)}" height="${rh}" fill="${fill}" stroke="${C.line}"/>`;let cx2=x;r.c.forEach((v,j)=>{p+=text(cx2+10,ry+29,v,size,r.color&&r.color[j]?r.color[j]:C.ink,r.bold&&r.bold[j]?700:400);cx2+=cols[j].w;});});
 return p;
}
function save(name,h,title,desc,parts){fs.writeFileSync(path.join(__dirname,name),`<svg xmlns="http://www.w3.org/2000/svg" width="1100" height="${h}" viewBox="0 0 1100 ${h}" role="img" aria-labelledby="title desc"><title id="title">${esc(title)}</title><desc id="desc">${esc(desc)}</desc><defs><marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto"><path d="M0 0L10 5L0 10Z" fill="${C.teal}"/></marker></defs><rect width="1100" height="${h}" fill="#fff"/><g font-family="Apple SD Gothic Neo, Noto Sans CJK KR, sans-serif">${parts.join('\n')}</g></svg>\n`);}
let count=0;const done=()=>count++;

// 01 overview
{
 const p=[text(35,46,'제조표준은 주문 한 건에서 적정·차선별로 만들어지는 공정 작업조건 묶음입니다',29,C.ink,700),
  text(35,84,'자동설계 6단계가 TB_C10_QLT_DSN_MNF 한 행을 차례로 채우고, 화면 두 탭이 같은 행을 보여줍니다',21,C.muted)];
 p.push(box(35,120,300,250,'주문·설계 Key',['품명코드 · 재질코드','주문두께 · 주문폭','도금량지정코드','표면처리 · Spangle · 조도','냉연제조표준번호','원자재 후보 1~3'],C.pale));
 p.push(arrow('M340 245H390'));
 p.push(box(395,120,330,250,'자동설계 6단계',['① 제조사양  ② 도금량','③ 수지·조도  ④ 통과공정·TM Pass','⑤ 두께·소둔  ⑥ 공정별 Size','각 단계가 자기 컬럼만 채웁니다','실패하면 오류코드를 남기고 멈춥니다'],C.gray));
 p.push(arrow('M730 245H780'));
 p.push(rect(785,120,280,250,C.warm));p.push(text(803,154,'TB_C10_QLT_DSN_MNF',23,C.ink,700));
 [['적정','QLT_DSN_MNF_TP = 1'],['차선1','QLT_DSN_MNF_TP = 2'],['차선2','QLT_DSN_MNF_TP = 3']].forEach(([a,b],i)=>{p.push(rect(803,175+i*60,244,48,'#fff'));p.push(text(818,206+i*60,a,21,C.ink,700));p.push(text(895,206+i*60,b,18,C.muted));});
 p.push(arrow('M925 375V420'));
 p.push(box(35,430,505,170,'용융도금-제조표준 (TAB05)',['품명 G·K·J·L·V·W·3·4·6·9 (5·7 조회만)','PLTCM · 2~5 CGL 소둔조건 · 도금부착량','수지부착량 · CGL 목표 Size · 품질메세지'],C.pale));
 p.push(box(560,430,505,170,'전기도금-제조표준 (TAB06)',['품명 A·B·C·D·E·N·1·2·8 (4·9도 조회)','PLTCM · ECL · TM 조도·Pass · ANN 소둔','EGL 도금량 · EGL 목표 Size · 품질메세지'],C.pale));
 p.push(text(35,650,'같은 128개 컬럼의 한 행을 두 탭이 서로 다른 부분집합으로 보여줍니다. 두 탭이 별도 테이블을 쓰는 것이 아닙니다.',21,C.ink,700));
 save('01-mnf-overview.svg',690,'제조표준 전체 구조','주문과 설계 Key가 자동설계 6단계를 거쳐 제조표준 행 3개를 만들고, 용융도금 탭과 전기도금 탭이 같은 행을 보여준다.',p);done();
}
// 02 product split
{
 const p=[text(35,46,'어느 탭에 보이는지는 품명코드가 정합니다',29,C.ink,700),text(35,84,'조회 SQL의 품명 필터 기준 · 4(CCLI)·9(CCLX)는 두 탭 모두에서 조회됩니다',21,C.muted)];
 p.push(rect(35,115,505,420,C.pale));p.push(text(55,150,'용융도금-제조표준 TAB05',24,C.ink,700));p.push(text(55,180,'PRD_NM_CD NOT IN (A,B,C,D,E,1,2,N,8)',18,C.muted));
 [['G  GI','K  Hot GI'],['J  G/A','L  G/L'],['V  GIX','W  GLX'],['3  CCGI','4  CCLI'],['6  CCGX','9  CCLX'],['5  CCAI','7  CCUS']].forEach(([a,b],i)=>{const y=205+i*50;p.push(rect(55,y,225,40,i>=5?C.warm:'#fff'));p.push(text(70,y+27,a,20));p.push(rect(295,y,225,40,i>=5?C.warm:'#fff'));p.push(text(310,y+27,b,20));});
 p.push(text(55,522,'5·7은 조회되지만 소둔·도금 기준은 대부분 건너뜁니다',17,C.muted));
 p.push(rect(560,115,505,420,C.pale));p.push(text(580,150,'전기도금-제조표준 TAB06',24,C.ink,700));p.push(text(580,180,'PRD_NM_CD IN (A,B,C,D,E,1,2,4,N,8,9)',18,C.muted));
 [['E  EGI','N  ZnNi'],['2  CCEI','8  CCNI'],['C  CR','1  CCI'],['A  P/O SkinPass','B  P/O No SP'],['D  F/H','4·9  GL 칼라'],['','']].forEach(([a,b],i)=>{const y=205+i*50;if(!a)return;p.push(rect(580,y,225,40,i===4?C.warm:'#fff'));p.push(text(595,y+27,a,20));p.push(rect(820,y,225,40,i===4?C.warm:'#fff'));p.push(text(835,y+27,b,20));});
 p.push(text(580,472,'CR·P/O·F/H는 도금이 없어도 PLTCM·TM·ANN 항목 때문에 이 탭입니다',17,C.muted));
 p.push(text(35,578,'설계 로직도 같은 축으로 갈립니다. 용융계는 CGL Leveler·Spangle·수지·CGL 소둔을,',20,C.ink,700));
 p.push(text(35,608,'전기·냉연계는 ECL·TM 조도·ANN 소둔을 편성합니다.',20,C.ink,700));
 save('02-product-split.svg',640,'품명별 탭 구분','용융도금 탭은 G K J L V W 3 4 6 9와 5 7, 전기도금 탭은 E N 2 8 C 1 A B D와 4 9를 보여준다.',p);done();
}
// 03 design steps
{
 const p=[text(35,46,'자동설계 6단계가 제조표준 행의 서로 다른 컬럼을 채웁니다',29,C.ink,700),text(35,84,'C102100000 메인 서비스의 실행 순서 · 앞 단계 값을 뒤 단계가 다시 읽습니다',21,C.muted)];
 const rows=[['① 제조사양','C103100020 · DbSearchMnfData','원자재·제조표준번호, ECL 약품·장력, CGL Leveler·Spangle·SkinPass·표면처리, 도유코드','C10B2130·2140·2150·2170'],
  ['② 도금량','C103100040 · DbSearchGwTotData','작업도금량 목표·전면·후면·전체 상하한, 도금두께 하한·상한·목표, 사양도금두께','C10A1061 View'],
  ['③ 수지·조도','C103100050 · DbSearchRsnRouData','수지부착량 목표·상하한(용융) 또는 조도 Ra 상하한(TM 통과)','C10B2160 · C10B2210'],
  ['④ 통과공정','C103100030 · DbSearchProcData','TM Pass수 (통과공정 편성의 부산물)','C10B2240'],
  ['⑤ 두께·소둔','C103100070 · DbSearchThkSizeData','압연·PLTCM·X-Ray SET 두께, 제품두께범위, ANN 2종 또는 2~5 CGL 소둔조건, 매중량','C10B2060·2070·1051'],
  ['⑥ 공정별 Size','C103100090 · DbSearchProcSizeData','CGL/EGL/TM 목표두께·폭, PLTCM 두께공차·폭, 5Stand WR, 내경링, S/T 유무','C10B2190·2110·2120 + 폭기준']];
 rows.forEach((r,i)=>{const y=115+i*112;p.push(rect(35,y,1030,98,i%2?C.gray:C.pale));p.push(text(55,y+36,r[0],23,C.ink,700));p.push(text(55,y+66,r[1],17,C.muted));p.push(text(330,y+36,r[2].length>44?r[2].slice(0,44):r[2],19));if(r[2].length>44)p.push(text(330,y+64,r[2].slice(44),19));p.push(text(330,y+90,'기준: '+r[3],17,C.teal,700));if(i<5)p.push(arrow(`M150 ${y+100}V${y+112}`));});
 p.push(text(35,812,'②~④ 사이의 ‘수지·조도’와 ‘TM Pass’는 주문 단위로 한 번 계산해 적정·차선 행을 모두 같은 값으로 갱신합니다.',20,C.ink,700));
 p.push(text(35,845,'계산 전에 컬럼을 비우는 CLEAR 액티비티는 ①②③⑤ 네 단계에만 있습니다. 재설계는 메인 서비스가 행 자체를 지운 뒤 다시 만듭니다.',19,C.muted));
 save('03-design-steps.svg',880,'자동설계 6단계','제조사양, 도금량, 수지 조도, 통과공정, 두께 소둔, 공정별 Size 순서로 제조표준 컬럼을 채운다.',p);done();
}
// 04 GI card
{
 const p=[text(35,46,'설명용 GI 주문 한 건의 용융도금 제조표준: 값은 모두 가정입니다',29,C.ink,700),text(35,84,'GI · 주문두께 0.500 TCT · 도금량코드 Z1 · Spangle 4 · Edge S · 통과 2 CGL',21,C.muted)];
 p.push(table(35,110,[{h:'항목',w:250},{h:'설명용 값',w:330},{h:'어디서 오나',w:450}],[
  {c:['CGL Leveler 사용여부','Y','C10B2150 · 품명']},
  {c:['Spangle / Skin Pass','4 / Y','주문 Spangle 복사 · 4·5·7이면 Y']},
  {c:['CGL 표면처리코드','주문표면처리 그대로','주문표면처리코드 복사']},
  {c:['작업도금량 전체','하한 120 · 상한 150 · 목표 137','C10A1061 · 품명 + 도금량코드']},
  {c:['도금두께','목표 20 μm · 하한 17 · 상한 23','C10A1061 같은 행']},
  {c:['수지부착량','목표 800 · 700~900','C10B2160 · 품명 + 표면처리']},
  {c:['소둔조건 2·3·4·5 CGL','Cycle A1 · HT 780 · CT 460 · ST 60 · Speed 120','C10B1051 · 제조표준번호·품명·재질·SET·폭']},
  {c:['CGL 목표 Size','두께 0.505 · 폭 1,006','두께=정전목표두께 · 폭=폭설계']},
  {c:['PLTCM','SET 0.490 · WR Type A · 내경링 N · S/T Y','C10B2110·2120 · Edge S/M → Y']},
  {c:['도유코드 · ECL 항목','없음','CR·EG 계열에만 편성']}],{rh:46}));
 p.push(text(35,650,'이 값들은 조회 결과이지 계산 결과가 아닙니다. 어떤 기준 행이 선택되었는지는 운영 MD를 봐야 합니다.',20,C.ink,700));
 save('04-gi-card.svg',690,'GI 제조표준 카드','설명용 GI 주문의 CGL Leveler, Spangle, 도금량, 도금두께, 수지부착량, 소둔조건, 목표 Size, PLTCM 값과 출처.',p);done();
}
// 05 EGI card
{
 const p=[text(35,46,'설명용 EGI 주문 한 건의 전기도금 제조표준: 값은 모두 가정입니다',29,C.ink,700),text(35,84,'EGI · 주문두께 0.800 BMT · 도금량코드 E3 · 주문조도코드 R1 · 통과 EGL(91) · 일반ANN(43) · TM(51)',21,C.muted)];
 p.push(table(35,110,[{h:'항목',w:250},{h:'설명용 값',w:330},{h:'어디서 오나',w:450}],[
  {c:['ECL C-D 방지약품','1','C10B2130 · 주문두께']},
  {c:['ECL 권취장력','2','C10B2140 · 품명']},
  {c:['EGL 표면처리코드','주문표면처리 그대로','E·N만 복사 (2·8 칼라는 비움)']},
  {c:['작업도금량 전면·후면','전면 20~30 · 후면 20~30 · 목표 25','C10A1061 · 품명 + 도금량코드']},
  {c:['도금두께','목표 3 μm','C10A1061 같은 행']},
  {c:['조도 Ra','0.8 ~ 1.2 (PPI·Rmax는 미설계)','C10B2210 · 품명 + 주문조도코드']},
  {c:['TM Pass수','1','C10B2240 조회 후 TM 공정이 있으면 1로 고정']},
  {c:['일반ANN / H-C ANN','Cycle B2 · 보정 5 · 코일 650 · 냉각 120','C10B1051 · 제조표준번호·품명·재질·SET·폭']},
  {c:['EGL·TM 목표 Size','EGL 두께 0.811 · 폭 1,006 · TM 두께 0.808','두께=정전목표두께 · TM=EGL−도금두께']},
  {c:['PLTCM','SET 0.810 · WR Type B · 내경링 N · S/T Y','C10B2110·2120 · Edge S/M → Y']}],{rh:46}));
 p.push(text(35,650,'같은 행에 CGL 소둔 컬럼도 있지만 EGI에서는 비어 있습니다. 화면도 그 컬럼을 숨깁니다.',20,C.ink,700));
 save('05-egi-card.svg',690,'EGI 제조표준 카드','설명용 EGI 주문의 ECL, 도금량, 조도, TM Pass, ANN 소둔, EGL 목표 Size, PLTCM 값과 출처.',p);done();
}
// 06 thickness chain (GI)
{
 const p=[text(35,46,'두께는 주문두께에서 출발해 압연 → PLTCM 출측 → X-Ray SET → 두께범위 순서로 만들어집니다',27,C.ink,700),text(35,84,'설명용 GI · 주문두께 0.500 TCT · 도금두께 목표 20 μm · 보정단위 CRN +0.005 · SP보정률 1% · PLTCM 공차 ±0.010',20,C.muted)];
 const steps=[['주문두께','0.500','TCT: 도금 포함 두께'],['압연목표두께','0.485','0.500 − 0.020 + 0.005'],['PLTCM 출측두께','0.489','0.485 × 1.01 = 0.48985 → 3자리 절삭'],['X-Ray SET','0.490','셋째 자리 9 → 0.48 + 0.01'],['PLTCM 두께범위','0.480 ~ 0.500','SET ± 공차 0.010']];
 steps.forEach(([a,b,c],i)=>{const x=35+i*210;p.push(rect(x,120,195,175,i===3?C.warm:C.pale));p.push(text(x+14,152,a,19,C.ink,700));p.push(text(x+14,208,b,i===4?24:32,C.teal,700));p.push(text(x+14,246,c.length>17?c.slice(0,17):c,15,C.muted));if(c.length>17)p.push(text(x+14,268,c.slice(17),15,C.muted));if(i<4)p.push(arrow(`M${x+197} 208H${x+208}`));});
 p.push(box(35,330,505,150,'제품 쪽 두께 (도금을 더한다)',['제품목표두께 COR_THK_TRV = 0.485 + 0.020 = 0.505','CGL 목표두께 CGL_THK_TRV = 0.505 (GI는 정전목표두께 그대로)','제품두께범위 = 주문 0.500 + 인수도공차 (TCT는 도금 미가산)'],C.gray,18));
 p.push(box(560,330,505,150,'압연 쪽 두께 (도금을 뺀다)',['PLTCM 두께목표 PLTCM_THK_TRV = 0.489','PLTCM_SET_THK_TRV = 0.490 이 X-Ray Set 값','PLTCM_THK_LLV/ULV = 0.480 / 0.500'],C.gray,18));
 p.push(text(35,525,'SET 값 0.490은 소둔조건(C10B1051)·PLTCM 공차·5Stand WR·내경링 기준의 조회 입력이기도 합니다.',20,C.ink,700));
 save('06-thickness-chain.svg',560,'두께 사슬','주문두께 0.500에서 압연 0.485, PLTCM 출측 0.489, X-Ray SET 0.490, 두께범위 0.480~0.500이 만들어진다.',p);done();
}
// 07 heat cycle source
{
 const p=[text(35,46,'소둔조건은 계산하지 않고 제조표준기준 C10B1051 한 행에서 복사합니다',29,C.ink,700),text(35,84,'조회 입력 5개로 정확히 1건을 찾아야 하며, 품명 그룹에 따라 ANN 2종 또는 CGL 4라인을 채웁니다',21,C.muted)];
 p.push(box(35,120,300,230,'조회 입력 5개',['냉연제조표준번호 CRM_MNF_STD_NO','품명코드','재질코드','PLTCM X-Ray SET 두께','적용폭 (Slit이면 조합폭 합)'],C.pale,18));
 p.push(arrow('M340 235H390'));
 p.push(box(395,120,250,230,'기준 1건',['0건 → KK13','2건 이상 → KK14','결과열 최대 30개','(관리화면 C107000030 tab18)'],C.warm,18));
 p.push(arrow('M650 180H700'));p.push(arrow('M650 290H700'));
 p.push(box(705,105,360,120,'CR·EG 계열 C·E·N·1·2·8',['일반ANN: 로유형·Cycle·보정시간·코일온도·냉각종료','H-C ANN: 같은 5개'],C.gray,17));
 p.push(box(705,240,360,120,'용융 계열 G·K·J·L·V·W·3·4·6·9',['2·3·4·5 CGL 각각: Cycle·가열·냉각·','ShockingTime·LineSpeed = 20개'],C.gray,17));
 p.push(box(35,385,1030,120,'통과공정과의 관계',['4개 CGL 라인 값이 모두 저장되지만 실제로 쓰이는 라인은 통과공정(82~85)에 있는 라인입니다.','화면은 라인별로 나눠 보여주고, 정합성검사의 라인별 누락 검사는 현행 코드에서 실행되지 않습니다(9장).'],C.pale,18));
 p.push(text(35,545,'5·7(CCAI·CCUS)은 이 조회를 건너뜁니다. 구매반제품 차선은 적정 행의 소둔조건을 그대로 복사합니다.',20,C.ink,700));
 save('07-heat-cycle.svg',580,'소둔조건 출처','C10B1051 제조표준기준을 5개 입력으로 조회해 ANN 2종 또는 CGL 4라인 소둔조건을 복사한다.',p);done();
}
// 08 screen save path
{
 const p=[text(35,46,'화면 저장은 다시 설계하지 않습니다. 편집값을 그대로 UPDATE 하고 이력 두 곳에 남깁니다',28,C.ink,700),text(35,84,'TAB05·TAB06 공통 구조 · 마스터 그리드 한 번의 전송으로 하위 그리드 값까지 저장',21,C.muted)];
 p.push(box(35,120,240,200,'① 하위 그리드 편집',['CGL 소둔 Grid_3·4','도금 Grid_5 (TAB05)','ECL·TM·ANN·EGL','Grid_4~7 (TAB06)'],C.pale,18));
 p.push(arrow('M280 220H320'));
 p.push(box(325,120,240,200,'② 마스터 숨김열 동기화',['TAB05 Grid_2 / TAB06 Grid_3','편집 즉시 setCellByIndexValue','행 상태를 updated로 표시','(여기서 열 번호가 틀리면 다른 값이 바뀜)'],C.gray,17));
 p.push(arrow('M570 220H610'));
 p.push(box(615,120,450,200,'③ 저장 버튼 검증',['변경 없음 → 중단 · 확정주문: TAB05 경고만, TAB06 중단','S/T Set값 < 주문폭이면 중단 (Slit 조수 0일 때)','TAB06: 대체공정·ANN Cycle을 지우면 통과공정 확인','확인창 → 원자재 → PLTCM/제조사양 → 메세지 순서'],C.gray,17));
 p.push(arrow('M840 325V365'));
 p.push(box(35,375,330,190,'④ 이력기록 Activity',['C104000020ChgHstActivity','변경 전후 값 비교 → CHG_HST 텍스트','실패하면 저장 자체를 하지 않음'],C.pale,17));
 p.push(box(385,375,330,190,'⑤ UPDATE',['TAB05: MNF_CGLupdate 업무 43개','TAB06: EGL_MNFupdate 업무 39개','원자재: RMTupdate · 메세지: MSGupdate','키: 주문번호·주문행·제조구분'],C.warm,17));
 p.push(box(735,375,330,190,'⑥ 수정로그 · 재조회',['TB_C10_QLT_DSN_MNF_MDF_LOG','원자재·PLTCM 7개와 그 _BF 7개만 INSERT','TAB05 는 메세지 저장 뒤 이 단계가 없습니다'],C.pale,17));
 p.push(arrow('M370 470H380'));p.push(arrow('M720 470H730'));
 p.push(text(35,610,'시스템 설계값으로 되돌리려면 ‘재설계’(C104000040)를 써야 합니다. 재설계는 제조표준 행을 지우고 6단계를 다시 실행합니다.',20,C.ink,700));
 save('08-screen-save.svg',645,'화면 저장 경로','하위 그리드 편집이 마스터 숨김열로 동기화되고, 검증 후 이력기록과 UPDATE, 수정로그, 재조회가 이어진다.',p);done();
}
// 09 TAB05 layout
{
 const p=[text(35,46,'용융도금-제조표준 탭(TAB05)의 화면 구성',29,C.ink,700),text(35,84,'노란 셀은 편집 가능 · 회색 글씨는 조회 전용 · 모두 같은 제조표준 행의 컬럼',21,C.muted)];
 p.push(rect(35,115,1030,95,C.pale));p.push(text(55,145,'Grid_1 원자재 (적정·차선1·차선2 3행)',21,C.ink,700));p.push(text(55,180,'원자재코드 · 등급 · 목표두께 · 하한 · 상한 · 목표폭  → TB_C10_QLT_DSN_RMT',18));
 p.push(rect(35,225,1030,130,C.gray));p.push(text(55,255,'Form_1 PLTCM  [압연Set지정 □] [폭수축] [저장]      Grid_2 PLTCM',21,C.ink,700));
 p.push(text(55,290,'5Stand WRType · 내경링 · S/T유무 · X-Ray SET(조회) · Side Trimming Set값 주/대체1/대체2',18));
 p.push(text(55,318,'폭수축값(PL−PLTCM) · BigData 분석값(FC_NECKING_CAL) · 두께 목표/하한/상한 · 폭 목표/대체1/대체2',18));
 p.push(text(55,344,'숨김열 100여 개(변경 전 _BF 포함): CGL 소둔·도금·수지 값이 모여 MNF_CGLupdate 로 저장됩니다',17,C.muted));
 p.push(rect(35,370,505,130,C.pale));p.push(text(55,400,'Grid_3 CGL: 2 CGL · 4 CGL 행',21,C.ink,700));p.push(text(55,435,'소둔Cycle(콤보) · HT · CT · ST · Line Speed',18));p.push(text(55,463,'Cycle 콤보 변경 → Grid_2 즉시 반영',17,C.muted));
 p.push(rect(560,370,505,130,C.pale));p.push(text(580,400,'Grid_4 CGL: 3 CGL · 5 CGL 행',21,C.ink,700));p.push(text(580,435,'같은 5개 항목',18));p.push(text(580,463,'LOV: HEAT_CYL_CD (SC0000)',17,C.muted));
 p.push(rect(35,515,1030,110,C.pale));p.push(text(55,545,'Grid_5 도금',21,C.ink,700));p.push(text(55,580,'도금부착량 하한/상한(전체) · 도금목표 도금량/두께 · Spangle(조회) · L/V(콤보) · Skin Pass(조회) · 표면처리(조회)',18));p.push(text(55,608,'수지부착량 목표/하한/상한 · 목표 Size 두께/폭(=CGL_THK_TRV·CGL_WTH_TRV)',18));
 p.push(rect(35,640,505,80,C.gray));p.push(text(55,670,'Grid_6 Back마킹 (조회, TB_C10_QLT_DSN_CMN)',20,C.ink,700));p.push(text(55,700,'품명 1~9 칼라가 아니고 BACK로 시작할 때만 표시',17,C.muted));
 p.push(rect(560,640,505,80,C.gray));p.push(text(580,670,'Grid_7 품질메세지 (편집)',20,C.ink,700));p.push(text(580,700,'TB_C10_QLT_DSN_MSG · 제조구분별 1건 · 1,000바이트 절단',17,C.muted));
 save('09-tab05-layout.svg',745,'TAB05 화면 구성','원자재, PLTCM, CGL 2·4와 3·5, 도금, Back마킹, 품질메세지 그리드로 구성된다.',p);done();
}
// 10 TAB06 layout
{
 const p=[text(35,46,'전기도금-제조표준 탭(TAB06)의 화면 구성',29,C.ink,700),text(35,84,'Grid_3 이 마스터 · ECL·TM·ANN·EGL 편집값은 Grid_3 숨김열로 모여 EGL_MNFupdate 로 저장',21,C.muted)];
 p.push(rect(35,115,200,95,C.gray));p.push(text(55,145,'Grid_1 적차선',21,C.ink,700));p.push(text(55,180,'선택 표시용',18));
 p.push(rect(250,115,815,95,C.pale));p.push(text(270,145,'Grid_2 원자재 (적정·차선1·차선2)',21,C.ink,700));p.push(text(270,180,'원자재코드(콤보) · 등급 · 목표두께 · 하한 · 상한 · 목표폭 → RMTupdate',18));
 p.push(rect(35,225,1030,110,C.gray));p.push(text(55,255,'Form_1 PLTCM  [압연Set지정 □] [폭수축] [저장]      Grid_3 PLTCM (마스터)',21,C.ink,700));
 p.push(text(55,290,'TAB05 Grid_2 와 같은 15개 표시열 + ECL·TM·ANN·EGL 숨김열 (X-Ray SET 은 조회 전용)',18));
 p.push(text(55,318,'두께목표값을 고치면 X-Ray SET 을 0/5 규칙으로 다시 계산해 넣습니다',17,C.muted));
 p.push(rect(35,350,330,100,C.pale));p.push(text(55,380,'Grid_4 ECL',21,C.ink,700));p.push(text(55,412,'C-D방지 약품(콤보) · 권취장력(콤보)',17));
 p.push(rect(380,350,685,100,C.pale));p.push(text(400,380,'Grid_5 TM',21,C.ink,700));p.push(text(400,412,'Pass수 · RA 하한/상한 · PPI 하한/상한 · RMAX(조회) · 엠보스무늬(조회) · 폭목표 주/대체1/대체2',17));
 p.push(rect(35,465,1030,100,C.pale));p.push(text(55,495,'Grid_6 ANN  [소둔 저장: 품명 첫 글자 4일 때만 표시]',21,C.ink,700));p.push(text(55,527,'일반 ANN: Cycle(콤보 SG0000) · 보정시간 · 코일온도 · 냉각온도   H-C ANN: Cycle(콤보 SH0000) · 보정시간 · 코일온도 · 냉각온도',17));
 p.push(rect(35,580,1030,100,C.pale));p.push(text(55,610,'Grid_7 EGL',21,C.ink,700));p.push(text(55,642,'작업도금량 전면하한/상한 · 후면하한/상한 · 도금목표 도금량/두께 · EGL표면처리코드(조회) · 목표 Size 두께/폭',17));
 p.push(rect(35,695,1030,70,C.gray));p.push(text(55,725,'Grid_8 품질메세지 (편집) · TB_C10_QLT_DSN_MSG 의 제조구분 1 행만 조회·저장',20,C.ink,700));
 save('10-tab06-layout.svg',790,'TAB06 화면 구성','적차선, 원자재, PLTCM 마스터, ECL, TM, ANN, EGL, 품질메세지 그리드로 구성된다.',p);done();
}
// 11 CGL clear mismatch
{
 const p=[text(35,46,'TAB05에서 CGL 값을 지우면 마스터의 다른 숨김열이 비워지는 경우가 있습니다',28,C.ink,700),text(35,84,'값을 입력할 때의 열 번호와 빈값으로 지울 때의 열 번호가 다른 조합 · JSP 987~1001행, 1097~1111행 기준',20,C.muted)];
 p.push(table(35,115,[{h:'지운 셀 (그리드 · 행 · 열)',w:300},{h:'의도한 숨김열',w:250},{h:'실제로 비워지는 숨김열',w:280},{h:'결과',w:200}],[
  {c:['Grid_3 · 2 CGL · HT','HTG_TEM_2CGL','SHK_TM_2CGL','불일치'],color:[C.ink,C.ink,C.red,C.red],bold:[0,0,1,1]},
  {c:['Grid_3 · 2 CGL · CT','CLG_TEM_2CGL','LN_SPD_2CGL','불일치'],color:[C.ink,C.ink,C.red,C.red],bold:[0,0,1,1]},
  {c:['Grid_3 · 2 CGL · Line Speed','LN_SPD_2CGL','HEAT_CYL_NO_3CGL','불일치'],color:[C.ink,C.ink,C.red,C.red],bold:[0,0,1,1]},
  {c:['Grid_3 · 4 CGL · HT / CT / Line Speed','HTG·CLG·LN_SPD_4CGL','같은 열','정상']},
  {c:['Grid_4 · 3 CGL · HT / CT','HTG·CLG_TEM_3CGL','같은 열','정상']},
  {c:['Grid_4 · 3 CGL · Line Speed','LN_SPD_3CGL','SHK_TM_3CGL','불일치'],color:[C.ink,C.ink,C.red,C.red],bold:[0,0,1,1]},
  {c:['Grid_4 · 5 CGL · HT / CT','HTG·CLG_TEM_5CGL','같은 열','정상']},
  {c:['Grid_4 · 5 CGL · Line Speed','LN_SPD_5CGL','SHK_TM_5CGL','불일치'],color:[C.ink,C.ink,C.red,C.red],bold:[0,0,1,1]},
  {c:['ST (ShockingTime) 전 라인','SHK_TM_xCGL','같은 열','정상']}],{rh:44,size:18}));
 p.push(text(35,590,'값을 새로 입력할 때(빈값이 아닐 때)는 모든 열이 정확히 맞습니다. 지운 뒤 저장하면 지운 값은 남고 이웃 값이 사라질 수 있습니다.',19,C.ink,700));
 p.push(text(35,622,'소스에서 확인한 열 번호 불일치이며, 운영 화면에서 재현했다는 뜻은 아닙니다. TAB06 의 동기화 열 번호는 모두 맞습니다.',18,C.muted));
 save('11-cgl-clear-mismatch.svg',650,'CGL 값 삭제 시 열 불일치','2CGL HT CT Line Speed와 3CGL 5CGL Line Speed를 지우면 다른 숨김열이 비워진다.',p);done();
}
// 12 validation coverage
{
 const p=[text(35,46,'정합성검사가 제조표준에서 실제로 확인하는 것과 확인하지 못하는 것',29,C.ink,700),text(35,84,'DbSearchDsnValidData.CheckMnf · 제조구분 정렬 첫 행(보통 적정 1)만 검사 · 5·7은 제조사양 블록에서만 제외',21,C.muted)];
 p.push(rect(35,115,505,470,C.pale));p.push(text(55,148,'검사한다',24,C.ink,700));
 ['제품두께범위 누락·역전  CF07 / CF08','PLTCM X-Ray SET 누락  CF25','PLTCM 두께목표 누락  CF26','PLTCM 폭목표 누락  CF72','도금제품(도금량코드 있음)일 때:','  도금두께 목표·상하한  CF18 / CF19 / CF20','  CGL·EGL 두께·폭 누락  CF21 ~ CF24','  작업도금량 목표  CF11','  EG계 전면·후면 상하한  CF12 ~ CF15','  GI계 전체 상하한  CF16 / CF17'].forEach((s,i)=>p.push(text(55,190+i*38,s,19)));
 p.push(rect(560,115,505,470,C.rose,'#e5b4b0'));p.push(text(580,148,'실행되지 않거나 없다',24,C.red,700));
 ['ANN 소둔조건 누락  CF36 ~ CF43','2·3·4·5 CGL 소둔조건 누락  CF44 ~ CF63','→ 품명 조건이 && 로 묶여 항상 거짓 (1949·1994행)','PLTCM 두께 상하한  CF27 / CF28 → 주석 처리','ECL 약품·장력, 수지부착량, 조도 Ra','TM Pass수, Leveler, Spangle, 표면처리, 도유코드','차선 행(제조구분 2·3)의 제조표준 전체','CGL·EGL 목표두께가 0 인 경우 (NULL 이 아니므로 통과)'].forEach((s,i)=>p.push(text(580,190+i*44,s,19,i<3?C.red:C.ink,i<3?700:400)));
 p.push(text(35,625,'따라서 소둔조건이 비어 있어도 설계 오류로 잡히지 않습니다. 화면과 통과공정을 함께 확인해야 합니다.',20,C.ink,700));
 save('12-validation-coverage.svg',660,'정합성검사 범위','제품두께범위, PLTCM SET, 도금량, CGL EGL 두께 폭은 검사하지만 소둔조건 검사는 조건식 오류로 실행되지 않는다.',p);done();
}
// 13 TCT vs BMT
{
 const p=[text(35,46,'주문두께구분이 TCT 인지 BMT 인지에 따라 압연목표두께에서 도금두께를 빼는지가 갈립니다',27,C.ink,700),text(35,84,'설명용 · CRN 보정 +0.005 (GI) · PCN 보정 +1% (EGI) · 도금두께는 μm 를 1,000 으로 나눠 mm 로 씁니다',20,C.muted)];
 p.push(text(35,140,'TCT (ORD_THK_TP = 2) · GI 주문두께 0.500 = 도금 포함',22,C.ink,700));
 p.push(rect(35,155,760,60,'#d8e6ee'));p.push(rect(795,155,40,60,'#a4dbd4'));p.push(text(55,193,'소지 0.480',20));p.push(text(640,193,'주문두께 0.500',20,C.ink,700));p.push(text(845,193,'도금 0.020',18,C.muted));
 p.push(text(35,250,'압연목표 = 0.500 − 0.020 + 0.005 = 0.485   → 제품목표두께 = 0.485 + 0.020 = 0.505',20,C.teal,700));
 p.push(text(35,320,'BMT (ORD_THK_TP = 1) · EGI 주문두께 0.800 = 소지 두께',22,C.ink,700));
 p.push(rect(35,335,900,60,'#d8e6ee'));p.push(rect(935,335,30,60,'#a4dbd4'));p.push(text(55,373,'주문두께 0.800 = 소지',20,C.ink,700));p.push(text(970,373,'+ 도금 0.003',18,C.muted));
 p.push(text(35,430,'압연목표 = 0.800 + 0.800 × 1% = 0.808   → 제품목표두께 = 0.808 + 0.003 = 0.811   → TM 목표두께 = 0.811 − 0.003 = 0.808',20,C.teal,700));
 p.push(box(35,470,1030,175,'같은 흐름에서 갈리는 예외',['CRN: 관리코드 5 (TCT→BMT) 면 압연목표 = 주문두께, 관리코드 6 (BMT→TCT) 면 주문두께 − 도금두께','PCN·TRK: 두께구분 2 + 관리코드 6, 두께구분 1 + 관리코드 5 는 KK94 로 설계가 멈춥니다.','PCN·TRK: 두께구분 2 + 관리코드 5, 두께구분 1 + 관리코드 6 은 계산식이 주석 처리되어 0 으로 남습니다.','위 표는 고객요청압연두께가 0 이고 두께구분이 3(칼라 TCT)이 아닐 때만 적용됩니다.'],C.warm,18));
 save('13-tct-bmt.svg',675,'TCT와 BMT','TCT는 주문두께에서 도금두께를 빼 압연목표를 만들고, BMT는 주문두께에 보정만 더한다.',p);done();
}
// 14 copy path
{
 const p=[text(35,46,'적정·차선 행마다 계산하는 단계와 적정 값을 복사하는 단계가 다릅니다',29,C.ink,700),text(35,84,'구매반제품 차선 = 제조구분 ≠ 1 이고 원자재 첫 글자가 H/M 이 아니며 품명이 5·7 이 아닌 행',21,C.muted)];
 p.push(table(35,115,[{h:'단계',w:220},{h:'적정 1 행',w:285},{h:'구매반제품 차선 행',w:295},{h:'저장 SQL',w:230}],[
  {c:['① 제조사양','후보 원자재별 INSERT','같은 규칙으로 별도 INSERT','C102100MNF.insert']},
  {c:['② 도금량','품명·도금량코드로 조회','같은 조회 → 같은 값','gw_update (제조구분별)']},
  {c:['③ 수지·조도','주문 단위 1회 계산','적정과 같은 값으로 갱신','RR_update (제조구분 없음)'],fill:C.warm},
  {c:['④ TM Pass수','주문 단위 1회','적정과 같은 값으로 갱신','C102100PROC.MNFupdate'],fill:C.warm},
  {c:['⑤ 두께·소둔','계산 + C10B1051 조회','SEM_RMTL_YN=Y → 적정 복사','THK_MNFupdate(1)']},
  {c:['⑥ 공정별 Size','계산 + 기준 조회','SEM_RMTL_YN=Y → 적정 복사','PROCupdate(1)']},
  {c:['원자재 Size (참고)','원자재별 계산','차선 행에서도 별도 계산','C102100RMTL.update']}],{rh:46,size:18}));
 p.push(text(35,510,'열연 H/M 차선은 적정과 같은 계산을 자기 원자재코드로 다시 합니다. 복사 경로는 구매반제품 차선에만 있습니다.',20,C.ink,700));
 p.push(text(35,545,'주황 행은 적정·차선 구분 없이 모든 행이 같은 값을 받습니다. 차선만 다른 조도·수지 값을 가질 수 없습니다.',19,C.muted));
 save('14-copy-path.svg',580,'적정과 차선의 계산·복사','제조사양과 도금량은 행별로, 수지 조도와 TM Pass는 주문 단위로, 두께 소둔과 공정별 Size는 구매반제품 차선에서 적정을 복사한다.',p);done();
}
console.log(`Generated ${count} 제조표준 SVG figures.`);
