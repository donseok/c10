// Offline fixed scenarios grounded in the guide. No live rule lookup or user data.
(()=>{
 const root=document.getElementById('pp-explorer');
 if(!root)return;
 const select=root.querySelector('#pp-scenario');
 const steps=root.querySelector('#pp-steps');
 const rowsEl=root.querySelector('#pp-rows');
 const output=root.querySelector('#pp-result');
 const explanation=root.querySelector('#pp-explanation');
 const f1=n=>n.toFixed(1);
 // 조회 SQL 의 표시 규칙 재현
 function slitDisplay(st,cnt,mix1,corWth){
  if(st!=='Y')return{cnt:'—',mix1:'—',why:'S/T 가 Y 가 아니라 두 칸 모두 숨김'};
  if(!mix1)return{cnt:String(cnt),mix1:f1(corWth),why:'조합폭1 이 0 이라 정전폭목표값으로 대체'};
  return{cnt:String(cnt),mix1:f1(mix1),why:'저장값 그대로'};
 }
 function skid(shape,subYn,subW,subL,ordW,ordL){
  if(shape!=='S')return{w:'—',l:'—',why:'제품형태가 Sheet 가 아니라 빈칸'};
  if(subYn==='Y'&&subW>0&&subL>0)
   return{w:f1(Math.min(subW,subL)),l:f1(Math.max(subW,subL)),why:'조분할 폭·길이 중 작은 값이 폭'};
  return{w:f1(Math.min(ordW,ordL)),l:f1(Math.max(ordW,ordL)),why:'주문폭·주문길이 중 작은 값이 폭'};
 }
 const S={
  'coil-st':{term:false,st:'Y',cnt:3,mix1:400,corWth:1002,shape:'C',subYn:'N',subW:0,subL:0,ordW:1000,ordL:0,
   rows:[['Slit 조수','3'],['조합폭1','400.0'],['조합폭 2·3','350.0 · 250.0'],['S/T 유무','Y'],['SKID 폭·길이','빈칸 (코일)'],['제품폭범위','997.0 ~ 1,003.0'],['보호필름','상세코드 있으면 5칸 표시'],['포장메세지','코드 + 문구']],
   note:'S/T 유무가 Y이므로 조수와 조합폭1이 그대로 보입니다. 코일이라 SKID 칸은 비어 있습니다.'},
  'coil-nost':{term:false,st:'N',cnt:3,mix1:400,corWth:1002,shape:'C',subYn:'N',subW:0,subL:0,ordW:1000,ordL:0,
   rows:[['Slit 조수','빈칸 (DB에는 3)'],['조합폭1','빈칸 (DB에는 400)'],['조합폭 2·3','350.0 · 250.0 — 그대로 보임'],['S/T 유무','N'],['SKID 폭·길이','빈칸 (코일)'],['제품폭범위','997.0 ~ 1,003.0'],['저장하면','조수·조합폭1 은 유지, 2~10 은 덮어씀'],['주의','화면 빈칸 ≠ DB 0']],
   note:'S/T 가 N 이면 앞의 두 칸만 숨깁니다. 조합폭 2~10 은 규칙이 달라 그대로 보이고, 저장하면 화면 값으로 덮어써집니다.'},
  sheet:{term:false,st:'Y',cnt:0,mix1:0,corWth:1002,shape:'S',subYn:'N',subW:0,subL:0,ordW:1000,ordL:2000,
   rows:[['Slit 조수','0'],['조합폭1','1,002.0 — 정전폭목표값 대체'],['S/T 유무','Y'],['SKID 폭','1,000.0'],['SKID 길이','2,000.0'],['SHL 작업 SIZE','빈칸 (조분할 값 0)'],['제품폭범위','997.0 ~ 1,003.0'],['주의','조합폭1 대체값은 저장된 값이 아님']],
   note:'조합폭1 이 0 이라 정전폭목표값 1,002 를 대신 보여줍니다. 이 값은 저장된 조합폭1 이 아닙니다.'},
  'sheet-narrow':{term:false,st:'Y',cnt:0,mix1:0,corWth:1202,shape:'S',subYn:'N',subW:0,subL:0,ordW:1200,ordL:900,
   rows:[['Slit 조수','0'],['조합폭1','1,202.0 — 정전폭목표값 대체'],['S/T 유무','Y'],['SKID 폭','900.0 ← 주문길이'],['SKID 길이','1,200.0 ← 주문폭'],['SHL 작업 SIZE','빈칸'],['제품폭범위','1,197.0 ~ 1,203.0'],['주의','폭·길이 이름이 뒤바뀜']],
   note:'주문길이가 주문폭보다 짧아 SKID 폭에 주문길이가, SKID 길이에 주문폭이 들어갑니다. 항상 작은 값이 폭입니다.'},
  'sheet-sub':{term:false,st:'Y',cnt:0,mix1:0,corWth:1002,shape:'S',subYn:'Y',subW:500,subL:1800,ordW:1000,ordL:2000,
   rows:[['Slit 조수','0'],['조합폭1','1,002.0 — 정전폭목표값 대체'],['S/T 유무','Y'],['SKID 폭','500.0 ← 조분할폭'],['SKID 길이','1,800.0 ← 조분할길이'],['SHL 작업 SIZE','두께·500.0·1,800.0'],['제품폭범위','997.0 ~ 1,003.0'],['주의','주문 치수 대신 조분할 값 사용']],
   note:'조분할여부가 Y 이고 폭·길이가 모두 0 보다 크므로 주문 치수 대신 조분할 값으로 SKID 를 계산합니다.'},
  term:{term:true,st:'Y',cnt:3,mix1:400,corWth:1002,shape:'S',subYn:'N',subW:0,subL:0,ordW:1000,ordL:2000,
   rows:[['Slit 조수','조회 결과 없음'],['조합폭 1~10','조회 결과 없음'],['S/T 유무','조회 결과 없음'],['SKID 폭·길이','조회 결과 없음'],['보호필름','조회 결과 없음'],['포장','조회 결과 없음'],['품질메세지','조회 결과 없음'],['다른 탭은','정상 표시될 수 있음']],
   note:'종료 통제 목록에 있는 주문은 조회 SQL 두 개가 모두 제외하므로 화면이 통째로 빕니다. 설계 오류가 아닙니다.'}
 };
 function render(){
  const c=S[select.value];
  let cells;
  if(c.term){
   cells=[['Slit 조수','—','종료주문'],['조합폭1','—','종료주문'],['SKID 폭','—','종료주문'],['SKID 길이','—','종료주문']];
   output.textContent='조회 결과 0건 · 화면 전체 공백';
   output.dataset.state='terminated';
  }else{
   const s=slitDisplay(c.st,c.cnt,c.mix1,c.corWth);
   const k=skid(c.shape,c.subYn,c.subW,c.subL,c.ordW,c.ordL);
   cells=[['Slit 조수',s.cnt,s.why],['조합폭1',s.mix1,s.why],['SKID 폭',k.w,k.why],['SKID 길이',k.l,k.why]];
   output.textContent=c.st==='Y'?'정상 조회 · 조수·조합폭1 표시':'정상 조회 · 조수·조합폭1 숨김';
   output.dataset.state=c.st==='Y'?'shown':'hidden';
  }
  steps.replaceChildren();
  for(const [label,v,why] of cells){
   const li=document.createElement('li');
   for(const [tag,val] of [['span',label],['strong',v],['small',why]]){const e=document.createElement(tag);e.textContent=val;li.append(e);}
   steps.append(li);
  }
  rowsEl.replaceChildren();
  for(const [k,v] of c.rows){
   const tr=document.createElement('tr');
   const th=document.createElement('th');th.scope='row';th.textContent=k;
   const td=document.createElement('td');td.textContent=v;
   tr.append(th,td);rowsEl.append(tr);
  }
  explanation.textContent=c.note;
 }
 select.addEventListener('change',render);
 render();
})();
