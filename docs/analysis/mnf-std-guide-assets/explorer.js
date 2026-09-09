// Offline fixed scenarios grounded in the guide. No live rule lookup or user data.
(()=>{
 const root=document.getElementById('mnf-explorer');
 if(!root)return;
 const select=root.querySelector('#mnf-scenario');
 const steps=root.querySelector('#mnf-steps');
 const rowsEl=root.querySelector('#mnf-rows');
 const output=root.querySelector('#mnf-result');
 const explanation=root.querySelector('#mnf-explanation');
 const f3=n=>n.toFixed(3);
 // 셋째 자리를 0 또는 5로 붙이는 X-Ray SET 규칙 (DbCommonUtil.pltcm_x_Ray)
 function xray(v){
  const s=v.toFixed(4);const i=s.indexOf('.');const head=s.slice(0,i);const dec=s.slice(i+1);
  if(dec.length<=2)return v;
  const d3=dec[2];const base=head+'.'+dec.slice(0,2);
  if(d3==='1'||d3==='2')return parseFloat(base+'0');
  if(d3==='3'||d3==='4'||d3==='6'||d3==='7')return parseFloat(base+'5');
  if(d3==='8'||d3==='9')return Math.round((parseFloat(base)+0.01)*1000)/1000;
  return parseFloat(base+d3);
 }
 const trunc3=v=>Math.trunc(v*1000)/1000;
 const S={
  gi:{tab:'용융도금 탭 (TAB05)',thk:0.500,tp:'TCT',gal:0.020,cor:0.005,film:0,
   heat:'2·3·4·5 CGL 20개 항목',
   rows:[['CGL Leveler','Y (C10B2150)'],['Spangle / Skin Pass','4 / Y'],['작업도금량','전체 하한·상한 (TOT)'],['수지부착량','목표·하한·상한 (C10B2160)'],['조도 Ra','없음'],['ECL 약품·장력','없음'],['TM Pass수','없음'],['CGL 목표두께','제품목표두께 그대로']],
   note:'GI는 CGL Leveler·Spangle·수지부착량·CGL 소둔조건을 편성하고 ECL·ANN 항목은 비어 있습니다.'},
  ccgi:{tab:'용융도금 탭 (TAB05)',thk:0.500,tp:'TCT',gal:0.020,cor:0.005,film:25,
   heat:'2·3·4·5 CGL 20개 항목',
   rows:[['CGL Leveler','Y (C10B2150)'],['Spangle / Skin Pass','4 / Y'],['작업도금량','전체 하한·상한 (원판 G 기준)'],['수지부착량','없음 — 칼라는 편성 대상 밖'],['조도 Ra','없음'],['CCL 목표두께','제품목표두께'],['중간정전 목표두께','제품목표 − 도막 0.025'],['CGL 목표두께','제품목표 − 도막 0.025']],
   note:'칼라는 도금량을 원판(G) 기준으로 조회하지만 수지부착량·조도는 어느 쪽에도 들어가지 않습니다.'},
  egi:{tab:'전기도금 탭 (TAB06)',thk:0.800,tp:'BMT',gal:0.003,cor:0.005,film:0,
   heat:'일반ANN · H-C ANN 각 5개',
   rows:[['ECL C-D 방지약품','1 (C10B2130 · 주문두께)'],['ECL 권취장력','2 (C10B2140 · 품명)'],['EGL 표면처리코드','주문표면처리 복사'],['작업도금량','전면·후면 하한·상한 (FRN·BAK)'],['조도 Ra','0.8 ~ 1.2 (C10B2210)'],['조도 PPI·Rmax','자동설계에서 채우지 않음'],['TM Pass수','1 (기준과 무관하게 고정)'],['TM 목표두께','EGL 두께 − 도금 0.003']],
   note:'EGI는 ECL·조도·ANN을 편성합니다. TM 두께만 도금두께를 뺍니다.'},
  ccei:{tab:'전기도금 탭 (TAB06)',thk:0.800,tp:'BMT',gal:0.003,cor:0.005,film:25,
   heat:'일반ANN · H-C ANN 각 5개',
   rows:[['ECL C-D 방지약품','1 (C10B2130)'],['ECL 권취장력','2 (C10B2140)'],['EGL 표면처리코드','없음 — E·N만 편성'],['작업도금량','전면·후면 (원판 E 기준)'],['조도 Ra','0.8 ~ 1.2 (C10B2210)'],['TM Pass수','1'],['EGL 목표두께','제품목표 − 도막 0.025'],['TM 목표두께','EGL 두께 − 도금 0.003']],
   note:'EG 칼라(2·8)는 EGL 표면처리코드를 받지 못합니다. 화면에서는 빈 값으로 보입니다.'},
  cr:{tab:'전기도금 탭 (TAB06)',thk:0.800,tp:'BMT',gal:0,cor:0.005,film:0,
   heat:'일반ANN · H-C ANN 각 5개',
   rows:[['ECL C-D 방지약품','1 (C10B2130)'],['ECL 권취장력','2 (C10B2140)'],['도유코드','편성됨 (C10B2170 · C·1만)'],['작업도금량','없음 — 도금제품 아님'],['도금두께','없음'],['조도 Ra','0.8 ~ 1.2 (C10B2210)'],['TM Pass수','1'],['TM 목표두께','제품목표두께 그대로']],
   note:'CR은 도금량 단계를 건너뛰지만 ECL·조도·ANN·도유코드는 편성합니다.'},
  fh:{tab:'전기도금 탭 (TAB06)',thk:1.200,tp:'BMT',gal:0,cor:0.005,film:0,
   heat:'일반ANN · H-C ANN 각 5개',
   rows:[['ECL 약품·장력','없음 — 편성 품명 16종 밖'],['CGL Leveler','없음'],['도유코드','없음'],['작업도금량','없음'],['수지부착량 · 조도','없음'],['TM Pass수','없음 — 저장 대상 품명 아님'],['제품목표두께','압연목표두께 그대로'],['PLTCM 목표폭','제품목표폭 그대로']],
   note:'F/H(D)는 제조사양 편성의 품명 16종에 없어 조건 코드가 거의 비어 있습니다. 두께와 PLTCM 설정만 채워집니다.'}
 };
 function render(){
  const c=S[select.value];
  const crm=c.tp==='TCT'?c.thk-c.gal+c.cor:c.thk+c.cor;
  const out=trunc3(crm*1.01);
  const set=trunc3(xray(out));
  const rows=[['주문두께',f3(c.thk),c.tp],
   ['압연목표두께',f3(crm),c.tp==='TCT'?`− 도금 ${f3(c.gal)} + 보정 ${f3(c.cor)}`:`+ 보정 ${f3(c.cor)}`],
   ['PLTCM 출측',f3(out),'× 1.01 후 3자리 절삭'],
   ['X-Ray SET',f3(set),'셋째 자리 0/5 규칙']];
  steps.replaceChildren();
  for(const [label,n,reason] of rows){
   const li=document.createElement('li');
   for(const [tag,val] of [['span',label],['strong',n],['small',reason]]){const e=document.createElement(tag);e.textContent=val;li.append(e);}
   steps.append(li);
  }
  rowsEl.replaceChildren();
  for(const [k,v] of c.rows){
   const tr=document.createElement('tr');
   const th=document.createElement('th');th.scope='row';th.textContent=k;
   const td=document.createElement('td');td.textContent=v;
   tr.append(th,td);rowsEl.append(tr);
  }
  output.textContent=`${c.tab} · 소둔은 ${c.heat}`;
  output.dataset.set=f3(set);
  explanation.textContent=c.note;
 }
 select.addEventListener('change',render);
 render();
})();
