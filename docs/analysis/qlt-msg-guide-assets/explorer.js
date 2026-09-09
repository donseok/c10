// Offline fixed scenarios grounded in the guide. No live rule lookup or user data.
(()=>{
 const root=document.getElementById('qm-explorer');
 if(!root)return;
 const select=root.querySelector('#qm-scenario');
 const steps=root.querySelector('#qm-steps');
 const rowsEl=root.querySelector('#qm-rows');
 const output=root.querySelector('#qm-result');
 const explanation=root.querySelector('#qm-explanation');

 // 자동설계의 메세지 저장 규칙을 그대로 재현한다.
 // std : 그 제조구분의 제조표준번호가 있는가 (행을 만들지 결정)
 // ctxKey : 저장 단계가 ctx 에서 찾는 이름
 // ctx : 기준값을 옮겨 담은 결과 (세 번째 갈래는 이름이 어긋나 비어 있다)
 function buildCtx(m){
  // 기준의 네 칸을 ctx 로 옮기는 실제 대응 관계
  return {QLT_MSG_NM:m.nm1, QLT_MSG_NM1:m.nm2, QLT_MSG_NM2:m.nm3, QLT_MSG_NM_COR:m.cor};
 }
 function msgRows(std,ctx){
  const plan=[['1',std.t1,'QLT_MSG_NM'],['2',std.t2,'QLT_MSG_NM1'],['3',std.t3,'QLT_MSG_NM3']];
  return plan.map(([tp,has,key])=>{
   if(!has)return{tp:tp,made:false,value:null,why:'제조표준번호가 없어 행을 만들지 않음'};
   const v=ctx[key];
   if(v===undefined)return{tp:tp,made:true,value:'',why:'찾는 이름('+key+')으로 담긴 값이 없어 빈 문자열'};
   if(!v)return{tp:tp,made:true,value:'',why:'기준에 문구가 없어 빈 문자열'};
   return{tp:tp,made:true,value:v,why:'기준의 문구를 그대로 저장'};
  });
 }
 function corRow(ctx){
  const v=ctx.QLT_MSG_NM_COR;
  return v?{made:true,value:v,why:'조건 없이 한 행 · 기준값 그대로'}
          :{made:true,value:'',why:'조건 없이 한 행 · 값이 없어 NULL'};
 }
 const show=v=>v?v:'빈칸';

 const S={
  full:{master:{nm1:'표면 흠 주의',nm2:'차선1 표면 흠 주의',nm3:'차선2 표면 흠 주의',cor:'정전 Slit 주의'},
   std:{t1:true,t2:true,t3:true},term:false,
   note:'기준에는 문구가 세 개 다 있는데 차선2 칸만 빕니다. 기준 등록이 아니라 값을 옮기는 이름이 어긋난 탓입니다.'},
  tier1:{master:{nm1:'표면 흠 주의',nm2:'차선1 표면 흠 주의',nm3:'차선2 표면 흠 주의',cor:'정전 Slit 주의'},
   std:{t1:true,t2:false,t3:false},term:false,
   note:'차선이 설계되지 않아 행 자체가 없습니다. 빈칸이 아니라 조회 결과가 없는 것입니다.'},
  nomsg:{master:{nm1:'',nm2:'',nm3:'',cor:''},
   std:{t1:true,t2:true,t3:true},term:false,
   note:'행은 세 개 다 생기지만 문구가 모두 비어 있습니다. 기준에 문구를 넣으면 적정과 차선1은 채워집니다.'},
  coronly:{master:{nm1:'',nm2:'',nm3:'',cor:'정전 Slit 주의'},
   std:{t1:true,t2:true,t3:true},term:false,
   note:'후공정 탭에는 문구가 보이는데 용융·전기 탭은 빕니다. 두 값이 서로 다른 표에서 오기 때문입니다.'},
  notier1:{master:{nm1:'표면 흠 주의',nm2:'차선1 표면 흠 주의',nm3:'차선2 표면 흠 주의',cor:'정전 Slit 주의'},
   std:{t1:false,t2:true,t3:true},term:false,
   note:'적정이 없으면 전기도금 탭은 아무것도 못 보여 줍니다. 그 탭의 조회가 적정에 고정돼 있기 때문입니다.'},
  term:{master:{nm1:'표면 흠 주의',nm2:'차선1 표면 흠 주의',nm3:'차선2 표면 흠 주의',cor:'정전 Slit 주의'},
   std:{t1:true,t2:true,t3:true},term:true,
   note:'표에는 행이 그대로 있습니다. 후공정 탭의 조회에만 종료주문 필터가 걸려 결과가 0건이 됩니다.'}};

 function render(key){
  const s=S[key];
  const ctx=buildCtx(s.master);
  const rows=msgRows(s.std,ctx);
  const cor=corRow(ctx);

  const cells=[...rows.map(r=>r.made?{v:show(r.value),w:r.why}:{v:'행 없음',w:r.why}),
   {v:show(cor.value),w:cor.why}];
  [...steps.children].forEach((li,i)=>{
   li.querySelector('strong').textContent=cells[i].v;
   li.querySelector('small').textContent=cells[i].w;});

  const made=rows.filter(r=>r.made);
  const filled=made.filter(r=>r.value);
  let state,summary;
  if(s.term){state='terminated';summary='표에는 행이 있지만 후공정 탭 조회는 0건';}
  else if(!made.length){state='blank';summary='제조구분별 메세지 행이 하나도 만들어지지 않음';}
  else if(!filled.length&&!cor.value){state='blank';summary='행은 '+made.length+'개 생겼지만 문구가 모두 빔';}
  else if(filled.length<made.length||!cor.value){state='partial';summary='행 '+made.length+'개 중 문구가 있는 것은 '+filled.length+'개';}
  else{state='ok';summary='행 '+made.length+'개 모두 문구가 채워짐';}
  output.textContent=summary;
  output.setAttribute('data-state',state);

  const t=s.term;
  const tab05=tp=>{const r=rows[tp-1];
   if(!r.made)return'조회 결과 없음 (행이 없음)';
   return r.value?r.value:'빈칸 (행은 있음)';};
  const list=[
   ['기준의 QLT_MSG_NM1',show(s.master.nm1)],
   ['기준의 QLT_MSG_NM2',show(s.master.nm2)],
   ['기준의 QLT_MSG_NM3',show(s.master.nm3)],
   ['기준의 QLT_MSG_NM_COR',show(s.master.cor)],
   ['MSG 표에 생긴 행',made.length+'행 (제조구분 '+(made.map(r=>r.tp).join('·')||'없음')+')'],
   ['용융도금 탭 · 적정 선택',tab05(1)],
   ['용융도금 탭 · 차선2 선택',tab05(3)],
   ['전기도금 탭 (적정 고정)',rows[0].made?(rows[0].value||'빈칸 (행은 있음)'):'조회 결과 없음 (적정 행이 없음)'],
   ['후공정 탭 (정전)',t?'조회 결과 없음 (종료주문 필터)':show(cor.value)],
   ['먼저 의심할 것',t?'종료주문 여부':(state==='ok'?'없음':'행이 없는지 문구가 빈지부터 구분')]];
  rowsEl.innerHTML=list.map(([k,v])=>'<tr><th scope="row">'+k+'</th><td>'+v+'</td></tr>').join('');
  explanation.textContent=s.note;
 }
 select.addEventListener('change',()=>render(select.value));
 render(select.value);
})();
