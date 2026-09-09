// Independent reproduction of documented formulas with illustrative inputs.
// Does not run GLUE/Java or query operating rule data.
const assert=require('node:assert/strict');
let checks=0;
function eq(actual,expected,label){assert.deepEqual(actual,expected,label);checks++;}

// --- DbCommonUtil.pltcm_x_Ray: 소수 셋째 자리를 0 또는 5로 붙인다 ---
function xray(v){
 const s=v.toFixed(4);const i=s.indexOf('.');const head=s.slice(0,i);const dec=s.slice(i+1);
 if(dec.length<=2)return v;
 const d3=dec[2];const b=head+'.'+dec.slice(0,2);
 if(d3==='1'||d3==='2')return parseFloat(b+'0');
 if(d3==='3'||d3==='4'||d3==='6'||d3==='7')return parseFloat(b+'5');
 if(d3==='8'||d3==='9')return Math.round((parseFloat(b)+0.01)*1000)/1000;
 return parseFloat(b+d3);
}
eq(xray(0.542),0.540,'X-Ray 셋째 1,2 → 0');
eq(xray(0.541),0.540,'X-Ray 1 → 0');
eq(xray(0.544),0.545,'X-Ray 4 → 5');
eq(xray(0.543),0.545,'X-Ray 3 → 5');
eq(xray(0.546),0.545,'X-Ray 6 → 5');
eq(xray(0.547),0.545,'X-Ray 7 → 5');
eq(xray(0.548),0.550,'X-Ray 8 → 둘째 +0.01');
eq(xray(0.549),0.550,'X-Ray 9 → 둘째 +0.01');
eq(xray(0.545),0.545,'X-Ray 5 는 그대로');
eq(xray(0.540),0.540,'X-Ray 0 은 그대로');
eq(xray(0.598),0.600,'X-Ray 자리올림');

// --- DbCommonUtil.thk_dot: 소수 4자리 이하 절삭 ---
const thkDot=v=>Math.trunc(v*1000)/1000;
eq(thkDot(0.48985),0.489,'thk_dot 절삭 (반올림 아님)');
eq(thkDot(0.4899),0.489,'thk_dot 9 도 버림');
eq(thkDot(0.489),0.489,'thk_dot 변화 없음');

// --- DbSearchThkSizeData: 압연목표두께 (보정단위 x 두께구분 x 관리코드) ---
// tp: '1'=BMT, '2'=TCT / mng: '5'=TCT→BMT, '6'=BMT→TCT
function crm(unit,tp,mng,thk,gal,val){
 if(unit==='CRN'){
  if(tp==='2')return mng==='5'?thk:Math.round((thk-gal+val)*10000)/10000;
  return mng==='6'?thk-gal:thk+val;
 }
 if(unit==='PCN'){
  if((tp==='2'&&mng==='6')||(tp==='1'&&mng==='5'))return 'KK94';
  if(tp==='2')return mng==='5'?0:thk-gal+thk*val/100;
  return mng==='6'?0:thk+thk*val/100;
 }
 // TRK
 if((tp==='2'&&mng==='6')||(tp==='1'&&mng==='5'))return 'KK94';
 if(tp==='2')return mng==='5'?0:val-gal;
 return mng==='6'?0:val;
}
eq(crm('CRN','2','',0.500,0.020,0.005),0.485,'CRN TCT 기본');
eq(crm('CRN','2','5',0.500,0.020,0.005),0.500,'CRN TCT 관리코드5');
eq(crm('CRN','1','',0.800,0.003,0.005),0.805,'CRN BMT 기본');
eq(crm('CRN','1','6',0.800,0.003,0.005),0.797,'CRN BMT 관리코드6');
eq(Math.round(crm('PCN','1','',0.800,0.003,1)*1000)/1000,0.808,'PCN BMT 기본');
eq(Math.round(crm('PCN','2','',0.500,0.020,1)*1000)/1000,0.485,'PCN TCT 기본');
eq(crm('PCN','2','6',0.500,0.020,1),'KK94','PCN TCT 관리코드6 → KK94');
eq(crm('PCN','1','5',0.800,0.003,1),'KK94','PCN BMT 관리코드5 → KK94');
eq(crm('PCN','2','5',0.500,0.020,1),0,'PCN TCT 관리코드5 → 계산 없음');
eq(crm('PCN','1','6',0.800,0.003,1),0,'PCN BMT 관리코드6 → 계산 없음');
// Java 도 이 경로에서 반올림을 하지 않으므로 부동소수 오차가 그대로 남는다.
eq(Math.round(crm('TRK','2','',0.500,0.020,0.470)*1000)/1000,0.450,'TRK TCT 확정값 − 도금');
eq(crm('TRK','1','',0.800,0.003,0.810),0.810,'TRK BMT 확정값');
eq(crm('TRK','2','6',0.500,0.020,0.470),'KK94','TRK TCT 관리코드6 → KK94');
eq(crm('TRK','1','5',0.800,0.003,0.810),'KK94','TRK BMT 관리코드5 → KK94');
eq(crm('TRK','2','5',0.500,0.020,0.470),0,'TRK TCT 관리코드5 → 계산 없음');
eq(crm('TRK','1','6',0.800,0.003,0.810),0,'TRK BMT 관리코드6 → 계산 없음');

// --- C10B2060 표 경로에 들어가는 조건: 고객요청압연두께 0 AND 두께구분 != 3 ---
const usesRuleTable=(cusReq,tp)=>cusReq===0&&tp!=='3';
eq(usesRuleTable(0,'2'),true,'고객요청 0 + TCT → 기준표 경로');
eq(usesRuleTable(0,'1'),true,'고객요청 0 + BMT → 기준표 경로');
eq(usesRuleTable(0,'3'),false,'칼라 TCT 는 고객요청 0 이어도 고객 경로');
eq(usesRuleTable(0.005,'2'),false,'고객요청 지정 → 고객 경로');

// --- 규격도금두께 0 처리: 두께구분과 규격기관 조합 ---
function spcGal(tp,spcAvr,v){
 if(tp==='2')return 0;
 if(tp==='3')return (spcAvr==='KS'||spcAvr==='JS')?v:0;
 return v;
}
eq(spcGal('2','KS',0.020),0,'TCT 는 규격기관 무관 0');
eq(spcGal('2','AS',0.020),0,'TCT 는 규격기관 무관 0 (2)');
eq(spcGal('3','KS',0.020),0.020,'칼라 TCT + KS 는 유지');
eq(spcGal('3','AS',0.020),0,'칼라 TCT + 비 KS/JS 는 0');
eq(spcGal('1','AS',0.020),0.020,'BMT 는 규격기관 무관 유지');

// --- PLTCM 출측두께와 X-Ray SET ---
function pltcm(unit,crmThk,sp){return thkDot(unit==='TRK'?crmThk:crmThk+crmThk*sp/100);}
eq(pltcm('CRN',0.485,1),0.489,'GI 출측두께');
eq(thkDot(xray(pltcm('CRN',0.485,1))),0.490,'GI X-Ray SET');
eq(pltcm('TRK',0.450,1),0.450,'TRK 은 SP보정 미적용');
eq(pltcm('PCN',0.808,0),0.808,'EGI 출측두께 (TRK 아닌 SP 0)');
eq(thkDot(xray(0.808)),0.810,'EGI X-Ray SET');

// --- 제품두께: 품명 그룹별 목표두께 ---
const GRP_CR=new Set(['C','A','B','D']),GRP_CRCOL=new Set(['1','5','7']);
const GRP_GAL=new Set(['E','N','G','K','J','L','V','W']),GRP_GALCOL=new Set(['2','3','4','6','8','9']);
// Java 는 이 단계에서 반올림하지 않는다. 비교를 위해 3자리로 맞춘다.
const r3=v=>Math.round(v*1000)/1000;
function corThk(prd,crmThk,ordThk,gal,film){
 if(GRP_CR.has(prd))return r3(crmThk);
 if(GRP_CRCOL.has(prd))return r3(prd==='1'?crmThk+film:ordThk+film);
 if(GRP_GAL.has(prd))return r3(crmThk+gal);
 if(GRP_GALCOL.has(prd))return r3(crmThk+film+gal);
 throw new Error('unknown '+prd);
}
eq(corThk('C',0.805,0.800,0,0),0.805,'CR 제품목표두께 = 압연목표');
eq(corThk('G',0.485,0.500,0.020,0),0.505,'GI 제품목표두께 = 압연 + 도금');
eq(corThk('E',0.808,0.800,0.003,0),0.811,'EGI 제품목표두께');
eq(corThk('3',0.485,0.500,0.020,0.025),0.530,'GI칼라 = 압연 + 도막 + 도금');
eq(corThk('1',0.805,0.800,0,0.025),0.830,'CR칼라 = 압연 + 도막');
eq(corThk('5',0.805,0.800,0,0.025),0.825,'알루미늄칼라 = 주문 + 도막');

// --- 제품두께범위: TCT 이면 상당도금두께 0 ---
function prdRange(ordThk,tp,gal,tolL,tolU){
 const g=tp==='2'?0:gal;
 return [Math.round((ordThk+g+tolL)*1000)/1000,Math.round((ordThk+g+tolU)*1000)/1000];
}
eq(prdRange(0.500,'2',0.020,-0.03,0.03),[0.470,0.530],'TCT 는 도금 미가산');
eq(prdRange(0.800,'1',0.003,-0.04,0.04),[0.763,0.843],'BMT 는 도금 가산');

// --- 공정별 목표두께 ---
const tmThk=(eglThk,galUm)=>Math.round((eglThk-galUm/1000)*1000)/1000;
eq(tmThk(0.811,3),0.808,'TM 두께 = EGL − 도금두께');
const midThk=(corT,filmUm)=>Math.round((corT-filmUm/1000)*1000)/1000;
eq(midThk(0.530,25),0.505,'중간정전 두께 = 제품목표 − 도막');
eq(midThk(0.530,25),0.505,'칼라 CGL 두께도 같은 식');

// --- PLTCM 두께범위 = SET ± 공차 ---
const pltcmRange=(set,l,u)=>[Math.round((set+l)*1000)/1000,Math.round((set+u)*1000)/1000];
eq(pltcmRange(0.490,-0.010,0.010),[0.480,0.500],'PLTCM 두께범위');

// --- Edge 두 컬럼은 서로 다르다 ---
const stEdge=e=>e==='S'||e==='M'?'Y':'N';
const corEdge=e=>e==='S'||e==='C'?'Y':'N';
eq([stEdge('S'),corEdge('S')],['Y','Y'],'Edge S 는 둘 다 Y');
eq([stEdge('M'),corEdge('M')],['Y','N'],'Edge M 은 S/T 만 Y');
eq([stEdge('C'),corEdge('C')],['N','Y'],'Edge C 는 정전만 Y');
eq([stEdge('N'),corEdge('N')],['N','N'],'Edge N 은 둘 다 N');

// --- CGL Skin Pass: Spangle 4,5,7 만 Y ---
const skinPass=sp=>['4','5','7'].includes(sp)?'Y':'N';
eq(['1','2','3','4','5','6','7','8'].map(skinPass),['N','N','N','Y','Y','N','Y','N'],'Skin Pass 분기');

// --- 도금량 조회 품명: 칼라는 원판으로 ---
const galKey={G:'G','3':'G',K:'K',J:'J',L:'L','4':'L',V:'V','6':'V',W:'W','9':'W',E:'E','2':'E',N:'N','8':'N'};
eq(galKey['3'],'G','CCGI 는 G 로 조회');
eq(galKey['4'],'L','CCLI 는 L 로 조회');
eq(galKey['2'],'E','CCEI 는 E 로 조회');
eq(galKey['8'],'N','CCNI 는 N 으로 조회');
eq(Object.keys(galKey).length,14,'도금 편성 대상 품명 14종');

// --- 제조사양 편성 대상 품명과 하위 분기 ---
const MNF16=['C','1','2','E','N','G','K','J','L','V','W','3','4','6','8','9'];
const ECL=['C','E','N','1','2','8'];
const CGL=MNF16.filter(p=>!ECL.includes(p));
eq(MNF16.length,16,'제조사양 편성 대상 16종');
eq(CGL.sort().join(''),'3469GJKLVW','CGL 계열 10종 (5·7 은 편성 대상 밖)');
eq(ECL.includes('D'),false,'F/H 는 편성 대상 밖');
eq(['E','N'].filter(p=>ECL.includes(p)).length,2,'EGL 표면처리 대상은 E·N 뿐');
eq(ECL.filter(p=>['2','8'].includes(p)).length,2,'2·8 은 ECL 조회 대상이지만 EGL 표면처리는 못 받음');

// --- 원자재 후보 → 제조구분 ---
function mnfTypes(codes){return codes.filter(c=>c&&c.trim()).map((c,i)=>({code:c,tp:String(i+1)}));}
eq(mnfTypes(['H32','H41','']).map(r=>r.tp),['1','2'],'후보 2개면 1,2');
eq(mnfTypes(['H32','','D51']).map(r=>r.tp),['1','2'],'차선1 이 비면 차선2 가 제조구분 2');
eq(mnfTypes(['H32','','D51'])[1].code,'D51','두 번째 후보가 D51');

// --- 화면 원자재 폭 경고 범위 ---
const wthWarn=(v,std)=>v<std||v>std+25;
eq([wthWarn(1005,1005),wthWarn(1030,1005),wthWarn(1031,1005),wthWarn(1004,1005)],[false,false,true,true],'폭 경고 기준폭 ~ +25');

// --- 매중량 ---
const wgtAl=(t,w)=>Math.round(t*2.73*w/1000*1000)/1000;
const wgtSus=(t,w)=>Math.round(t*7.74*w/1000*1000)/1000;
const wgtGen=(set,frn,bak,tot,w)=>Math.round(((set*7.85+(frn+bak+tot)/1000)*w/1000)*1000)/1000;
eq(wgtAl(0.500,1000),1.365,'알루미늄칼라 매중량');
eq(wgtSus(0.500,1000),3.870,'스테인레스칼라 매중량');
eq(wgtGen(0.490,0,0,120,1000),3.967,'일반 매중량 (SET × 7.85 + 도금하한/1000) × 폭/1000');

// --- 정합성검사의 && 조건은 항상 거짓 ---
const cur='C';
eq(cur==='C'&&cur==='E'&&cur==='N',false,'품명 AND 조건은 항상 거짓');
eq(cur==='C'||cur==='E'||cur==='N',true,'OR 이면 참 (의도한 동작)');

console.log(`PASS: ${checks} checks on documented 제조표준 formulas.`);
