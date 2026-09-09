// Independent reproduction of the guide's display and save rules with illustrative inputs.
// Does not run GLUE/Java or query operating data.
const assert=require('node:assert/strict');
let checks=0;
function eq(actual,expected,label){assert.deepEqual(actual,expected,label);checks++;}

// --- 조회 SQL: 조수·조합폭1 표시 규칙 ---
function slitDisplay(st,cnt,mix1,corWth){
 if(st!=='Y')return{cnt:'',mix1:''};
 return{cnt:String(cnt),mix1:(!mix1||mix1===0)?corWth:mix1};
}
eq(slitDisplay('N',3,400,1002),{cnt:'',mix1:''},'S/T N 이면 두 칸 숨김');
eq(slitDisplay('',3,400,1002),{cnt:'',mix1:''},'S/T 빈값도 숨김');
eq(slitDisplay('Y',3,400,1002),{cnt:'3',mix1:400},'S/T Y 이고 조합폭1 있으면 그대로');
eq(slitDisplay('Y',0,0,1002),{cnt:'0',mix1:1002},'조합폭1 이 0 이면 정전폭목표값 대체');
eq(slitDisplay('Y',2,null,1002),{cnt:'2',mix1:1002},'조합폭1 이 비어도 대체');

// --- 조합폭 2~10 은 0/빈값만 숨긴다 (S/T 무관) ---
const mixN=v=>(!v||v===0)?'':v;
eq([mixN(0),mixN(null),mixN(350)],['','',350],'조합폭 2~10 표시 규칙');
eq(slitDisplay('N',3,400,1002).mix1===''&&mixN(350)===350,true,'S/T N 이어도 조합폭2 는 보인다');

// --- 저장 SQL: DECODE 보호 규칙 ---
function saveMnf(stNew,screen,db){
 return{
  cnt: stNew==='Y'?screen.cnt:db.cnt,
  mix1: stNew==='Y'?screen.mix1:db.mix1,
  mix2: screen.mix2,          // 보호 없음
  mix3: screen.mix3,          // 보호 없음
  st: stNew,
  rngL: screen.rngL, rngU: screen.rngU,
 };
}
const dbRow={cnt:3,mix1:400,mix2:350,mix3:250};
eq(saveMnf('Y',{cnt:4,mix1:500,mix2:300,mix3:200,rngL:997,rngU:1003},dbRow),
   {cnt:4,mix1:500,mix2:300,mix3:200,st:'Y',rngL:997,rngU:1003},'S/T Y 는 전부 화면 값');
eq(saveMnf('N',{cnt:'',mix1:'',mix2:'',mix3:'',rngL:997,rngU:1003},dbRow),
   {cnt:3,mix1:400,mix2:'',mix3:'',st:'N',rngL:997,rngU:1003},'S/T N 은 조수·조합폭1 만 유지');
eq(saveMnf('N',{cnt:'',mix1:'',mix2:'',mix3:'',rngL:997,rngU:1003},dbRow).mix2,'',
   'S/T N 에서 조합폭2 는 지워질 수 있다');

// --- SKID 치수 ---
function skid(shape,subYn,subW,subL,ordW,ordL){
 if(shape!=='S')return{w:'',l:''};
 if(subYn==='Y'&&subW>0&&subL>0)return{w:Math.min(subW,subL),l:Math.max(subW,subL)};
 return{w:Math.min(ordW,ordL),l:Math.max(ordW,ordL)};
}
eq(skid('S','N',0,0,1000,2000),{w:1000,l:2000},'Sheet 주문 치수');
eq(skid('S','N',0,0,1200,900),{w:900,l:1200},'주문길이가 짧으면 폭·길이 뒤바뀜');
eq(skid('S','Y',500,1800,1000,2000),{w:500,l:1800},'조분할 Y 는 조분할 값 사용');
eq(skid('S','Y',0,1800,1000,2000),{w:1000,l:2000},'조분할폭 0 이면 주문 치수로');
eq(skid('S','Y',500,0,1000,2000),{w:1000,l:2000},'조분할길이 0 이면 주문 치수로');
eq(skid('C','Y',500,1800,1000,2000),{w:'',l:''},'코일은 빈칸');
eq(skid('S','N',0,0,1000,1000),{w:1000,l:1000},'같으면 둘 다 같은 값');

// --- 조분할 세 칸은 값만 본다 (조분할여부 무관) ---
const subCell=v=>(!v||v===0)?'':v;
eq([subCell(0),subCell(500)],['',500],'SHL 작업 SIZE 는 0 이면 빈칸');

// --- 보호필름 상세코드 파싱 (1-based 자리) ---
function filmParse(code){
 const at=n=>(code&&code.length>=n)?code.charAt(n-1):'';
 return{thk:at(2),sus:at(4),prd:at(5)};
}
eq(filmParse('A2B31'),{thk:'2',sus:'3',prd:'1'},'5자리 정상 파싱');
eq(filmParse('A2B'),{thk:'2',sus:'',prd:''},'짧으면 뒤 칸이 빈다');
eq(filmParse(''),{thk:'',sus:'',prd:''},'빈 코드');
eq(filmParse('A2B31').thk!=='A',true,'1번째 자리는 쓰지 않는다');

// --- 관리점착력 우선순위 ---
const mngAdh=(bomTxt,prdAdh)=>(bomTxt!==null&&bomTxt!==undefined&&bomTxt!=='')?bomTxt:prdAdh;
eq(mngAdh('강점착','1'),'강점착','칼라 BOM 값이 있으면 그 값');
eq(mngAdh(null,'1'),'1','BOM 값이 없으면 제품점착력');
eq(mngAdh('','1'),'1','BOM 값이 비면 제품점착력');

// --- 저장 경로 판단 (JSP save 함수) ---
function saveRoute(g1,g4,g5){
 if(g1!=='updated'&&g4!=='updated'&&g5!=='updated')return['변경없음'];
 if(g1==='updated')return['COR_save'];
 if(g4==='updated')return['MSG_save'];
 if(g5==='updated')return['PKG_save'];
 return['변경없음'];
}
eq(saveRoute('','',''),['변경없음'],'아무 변경 없으면 중단');
eq(saveRoute('updated','updated','updated'),['COR_save'],'정전이 있으면 정전부터');
eq(saveRoute('','updated','updated'),['MSG_save'],'정전 없으면 메세지부터');
eq(saveRoute('','','updated'),['PKG_save'],'포장만 바뀌면 포장부터');

// --- 콜백 체인이 이어지는 순서 ---
function chain(g1,g4,g5){
 const order=[];
 if(g1==='updated')order.push('COR_save');
 if(g4==='updated')order.push('MSG_save');
 if(g5==='updated')order.push('PKG_save');
 order.push('재조회');
 return order;
}
eq(chain('updated','updated','updated'),['COR_save','MSG_save','PKG_save','재조회'],'세 블록 모두 이어짐');
eq(chain('updated','','updated'),['COR_save','PKG_save','재조회'],'가운데를 건너뛴다');
eq(chain('','',''),['재조회'],'변경 없으면 재조회만');

// --- 조회 필터 ---
const visible=(mnfTp,terminated)=>mnfTp==='1'&&!terminated;
eq(visible('1',false),true,'적정 · 미종료는 조회됨');
eq(visible('2',false),false,'차선은 조회되지 않음');
eq(visible('1',true),false,'종료주문은 조회되지 않음');

// --- 저장 대상 행: 제조구분 조건 없음 ---
const rowsAffected=(all,ordNo,ordLn)=>all.filter(r=>r.ordNo===ordNo&&r.ordLn===ordLn).map(r=>r.tp);
const table=[{ordNo:'A',ordLn:'1',tp:'1'},{ordNo:'A',ordLn:'1',tp:'2'},{ordNo:'A',ordLn:'1',tp:'3'},{ordNo:'B',ordLn:'1',tp:'1'}];
eq(rowsAffected(table,'A','1'),['1','2','3'],'저장은 세 행 모두');
eq(table.filter(r=>r.ordNo==='A'&&r.ordLn==='1'&&r.tp==='1').length,1,'조회는 한 행만');

// --- 제품폭범위와 정전폭목표값은 다른 식 ---
const prdRange=(ordW,tolL,tolU)=>[ordW+tolL,ordW+tolU];
const corWth=(ordW,mrg)=>ordW+mrg;
eq(prdRange(1000,-3,3),[997,1003],'제품폭범위 = 주문폭 + 인수도공차');
eq(corWth(1000,2),1002,'정전폭목표 = 주문폭 + 폭여유');
eq(prdRange(1000,-3,3)[1]!==corWth(1000,2),true,'두 값은 다른 계산');

// --- 메세지 길이 제한 ---
const clip=(s,max=1000)=>Buffer.byteLength(s,'utf8')>max?s.slice(0,max):s;
eq(clip('가나다').length,3,'짧은 문구는 그대로');
eq(Buffer.byteLength(clip('가'.repeat(500)),'utf8')<=1500,true,'긴 문구는 잘린다');

console.log(`PASS: ${checks} checks on documented 후공정 rules.`);
