// Offline fixed scenarios grounded in the guide. No live rule lookup or user data.
(()=>{
 const root=document.getElementById('width-explorer');
 if(!root)return;
 const select=root.querySelector('#width-scenario');
 const steps=root.querySelector('#width-steps');
 const output=root.querySelector('#width-result');
 const explanation=root.querySelector('#width-explanation');
 const fmt=n=>new Intl.NumberFormat('ko-KR',{maximumFractionDigits:1}).format(n);
 const scenarios={
  hot:{g:2,t:3,m:5,end:'hot',note:'제품 1,002 → 도금 1,006 → 압연 1,008 → 열연 원자재 1,016. 수축·마진을 거슬러 더하는 기본 예제입니다.'},
  'hot-alt':{g:4,t:5,m:7,end:'hot',note:'제품목표폭은 같아도 차선 원자재에 도금수축 4·압연수축 5·원자재마진 7이 조회되었다고 가정하면 1,022가 됩니다. 차선이라는 이름 때문에 넓어지는 것은 아닙니다.'},
  gal:{g:2,end:'gal',note:'차선 구매 GI는 적정에서 복사한 도금 목표폭 1,006을 기준으로 1을 뺍니다. 압연폭에 열연의 수축·마진을 더하는 경로를 사용하지 않습니다.'},
  'fh-main':{g:2,end:'fh-main',note:'적정 F/H의 입력 원자재코드가 D로 시작하고 F/H 두께기준이 성공했다면 최대 압연폭 1,008에서 3을 뺍니다. 이 −3은 현행 코드의 지정 규칙입니다.'},
  'fh-alt':{g:2,end:'fh-alt',note:'차선 F/H는 공정폭 복사와 F/H 두께기준 조회가 정상이라는 가정에서 압연폭 1,008을 그대로 사용합니다. 적정 F/H의 −3을 적용하지 않습니다.'},
  edge:{g:2,end:'edge',note:'중간재 미적용 GI의 Edge C/N 최종 분기는 최대 압연폭을 그대로 반올림합니다. 실제 Edge 변경 재설계에서는 앞 단계 기준도 바뀔 수 있습니다. 두께조회용 +20은 여기에 더하지 않습니다.'}
 };
 function render(){
  const cfg=scenarios[select.value],p=1002,cgl=p+1+3,pltcm=Math.round(cgl+cfg.g);
  const rows=[['제품목표폭',p,'여기에서 출발'],['도금 목표폭',cgl,'+ 정전수축 1 + 마진 3']];
  let raw;
  if(cfg.end==='gal'){raw=Math.round((cgl-1)*10)/10;rows.push(['원자재 목표폭',raw,'− 구매 도금재 차감 1']);}
  else{
   rows.push(['압연 목표폭',pltcm,`+ 도금수축 ${cfg.g}`]);
   if(cfg.end==='hot'){raw=Math.round(pltcm+cfg.t+cfg.m);rows.push(['원자재 목표폭',raw,`+ 압연수축 ${cfg.t} + 마진 ${cfg.m}`]);}
   else if(cfg.end==='fh-main'){raw=pltcm-3;rows.push(['원자재 목표폭',raw,'− 적정 F/H 차감 3']);}
   else{raw=pltcm;rows.push(['원자재 목표폭',raw,cfg.end==='edge'?'Edge C/N: 최대폭 그대로':'차선 F/H: 최대폭 그대로']);}
  }
  steps.replaceChildren();
  for(const [label,n,reason] of rows){
   const li=document.createElement('li');
   for(const [tag,val] of [['span',label],['strong',fmt(n)],['small',reason]]){const e=document.createElement(tag);e.textContent=val;li.append(e);}
   steps.append(li);
  }
  output.textContent=`원자재 ${fmt(raw)} mm · 제품목표폭 대비 ${raw-p>=0?'+':''}${fmt(raw-p)} mm`;
  output.dataset.raw=String(raw);
  explanation.textContent=cfg.note;
 }
 select.addEventListener('change',render);
 render();
})();
