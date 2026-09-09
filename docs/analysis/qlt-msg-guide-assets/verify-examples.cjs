// Independent JavaScript reproduction of every 품질메세지 rule stated in the guide.
// Mirrors DbSearchQualKeyMatch.java, C102100MSG-query.glue_sql and the three tab queries.
// If a number here disagrees with the guide, one of the two is wrong.
const assert=require('node:assert/strict');
let checks=0;
const eq=(a,b,m)=>{assert.deepEqual(a,b,m);checks++;};
const ok=(a,m)=>{assert.ok(a,m);checks++;};

// ── 1. 설계Key 조건 배열 ────────────────────────────────────────
const star=n=>'*'.repeat(n);
// 주문폭: Slit 조수가 0보다 크면 조합폭 1~10 의 합, 아니면 주문폭 컬럼
function keyWidth(slitGrpCnt,mix,ordExcWth){
 if(slitGrpCnt>0)return mix.reduce((a,b)=>a+b,0);
 return ordExcWth;
}
eq(keyWidth(3,[400,350,250,0,0,0,0,0,0,0],1000),1000,'조수 3 이면 조합폭 합');
eq(keyWidth(3,[400,350,260,0,0,0,0,0,0,0],1000),1010,'조합폭을 고치면 Key 의 폭이 달라진다');
eq(keyWidth(0,[0,0,0,0,0,0,0,0,0,0],1000),1000,'조수 0 이면 주문폭 그대로');

// 고객사양번호가 비면 별표 10 개로 대체하고 색상코드를 함께 정한다
function initialKey(cusBthPapNo,cclBomNo){
 if(cusBthPapNo===''){
  return{cus:star(10),clr:cclBomNo.length>4?cclBomNo.slice(0,5):star(5)};
 }
 return{cus:cusBthPapNo,clr:cclBomNo.length>4?cclBomNo.slice(0,5):''};
}
eq(initialKey('','AB123XYZ'),{cus:'**********',clr:'AB123'},'고객사양번호 미지정 + BOM 있음');
eq(initialKey('','ABC'),{cus:'**********',clr:'*****'},'고객사양번호 미지정 + BOM 짧음');
eq(initialKey('P0001','AB123XYZ'),{cus:'P0001',clr:'AB123'},'고객사양번호 지정');
eq(initialKey('P0001','ABC'),{cus:'P0001',clr:''},'고객사양번호 지정 + BOM 짧으면 색상코드는 빈 값');

// ── 2. 주문용도코드 세 단계 확장 ────────────────────────────────
function widenUsage(cur,original){
 if(cur===star(6))return null;                      // 더 넓힐 수 없음
 if(cur===cur.slice(0,cur.length-5)+star(5))return star(6);   // X***** → ******
 if(cur===cur.slice(0,cur.length-3)+star(3))return cur.slice(0,cur.length-5)+star(5); // XXX*** → X*****
 return original?original.slice(0,original.length-3)+star(3):'   '+star(3); // 원본 앞 3 자리 + ***
}
eq(widenUsage('ABCDEF','ABCDEF'),'ABC***','원래 값 → 앞 세 자리');
eq(widenUsage('ABC***','ABCDEF'),'A*****','앞 세 자리 → 앞 한 자리');
eq(widenUsage('A*****','ABCDEF'),'******','앞 한 자리 → 전부 별표');
eq(widenUsage('******','ABCDEF'),null,'전부 별표에서는 더 넓히지 않는다');
eq(widenUsage('ABCDEF',''),'   ***','주문용도코드가 비면 공백 세 칸 + 별표 세 개');
// 1 단계는 현재 값이 아니라 원본에서 자른다
eq(widenUsage('ZZZZZZ','ABCDEF'),'ABC***','원본에서 자르므로 현재 값과 무관');

// ── 3. 우선순위 하강 (주행거리계) ──────────────────────────────
// 안쪽부터: 주문용도코드 → 최종고객사코드 → 색상코드
function nextKey(k,orig){
 if(!k.cus.endsWith('*'))return{done:true,err:'KK01',reason:'고객사양번호가 지정인데 못 찾음'};
 const u=widenUsage(k.usg,orig.usg);
 if(u)return{done:false,key:{...k,usg:u}};
 // 주문용도코드를 다 넓혔다 → 한 칸 위를 올리고 주문용도코드를 원본으로 되돌린다
 if(!k.cus2.endsWith('*'))return{done:false,key:{...k,cus2:star(6),usg:orig.usg||''}};
 if(!k.clr.endsWith('*'))return{done:false,key:{...k,clr:star(5),usg:orig.usg||'',cus2:orig.cus2||''}};
 return{done:true,err:'KK01',reason:'셋 다 넓혔는데 못 찾음'};
}
const orig={usg:'ABCDEF',cus2:'C00001'};
let k={cus:star(10),cus2:'C00001',clr:'AB123',usg:'ABCDEF'};
const trail=[];
for(let i=0;i<20;i++){
 const r=nextKey(k,orig);
 if(r.done){trail.push('ERR:'+r.err);break;}
 k=r.key;trail.push(`${k.clr}|${k.cus2}|${k.usg}`);
}
eq(trail,[
 'AB123|C00001|ABC***','AB123|C00001|A*****','AB123|C00001|******',
 'AB123|******|ABCDEF','AB123|******|ABC***','AB123|******|A*****','AB123|******|******',
 '*****|C00001|ABCDEF','*****|C00001|ABC***','*****|C00001|A*****','*****|C00001|******',
 '*****|******|ABCDEF','*****|******|ABC***','*****|******|A*****','*****|******|******',
 'ERR:KK01'],'하강 순서 전체');
eq(nextKey({cus:'P0001',cus2:'C00001',clr:'AB123',usg:'ABCDEF'},orig).err,'KK01',
 '고객사양번호가 지정이면 넓히지 않고 바로 실패');

// ── 4. 기준값 → ctx 이름 매핑 ──────────────────────────────────
// DbSearchQualKeyMatch 469~517 행의 실제 대응
function toCtx(master){
 return{QLT_MSG_NM:master.QLT_MSG_NM1,
        QLT_MSG_NM1:master.QLT_MSG_NM2,
        QLT_MSG_NM2:master.QLT_MSG_NM3,
        QLT_MSG_NM_COR:master.QLT_MSG_NM_COR};
}
const master={QLT_MSG_NM1:'적정문구',QLT_MSG_NM2:'차선1문구',QLT_MSG_NM3:'차선2문구',QLT_MSG_NM_COR:'정전문구'};
const ctx=toCtx(master);
eq(ctx.QLT_MSG_NM,'적정문구','적정은 기준 1 번 칸');
eq(ctx.QLT_MSG_NM1,'차선1문구','차선1 은 기준 2 번 칸');
eq(ctx.QLT_MSG_NM2,'차선2문구','기준 3 번 칸은 QLT_MSG_NM2 라는 이름으로 담긴다');
ok(!('QLT_MSG_NM3' in ctx),'QLT_MSG_NM3 이라는 이름은 ctx 에 담기지 않는다');

// ── 5. 제조구분별 메세지 행 생성 ───────────────────────────────
const SPACE='';           // C10STR_SPACE
function msgRows(std,ctx){
 const plan=[['1',std.no ,'QLT_MSG_NM'],
             ['2',std.no1,'QLT_MSG_NM1'],
             ['3',std.no2,'QLT_MSG_NM3']];   // 세 번째만 이름이 어긋난다
 const out=[];
 for(const [tp,stdNo,key] of plan){
  if(!stdNo)continue;                        // 제조표준번호가 없으면 행 자체를 만들지 않는다
  const v=ctx[key];
  out.push({tp:tp,msg:(v===undefined||v===null||v==='')?SPACE:v});
 }
 return out;
}
const all={no:'M1',no1:'M2',no2:'M3'};
eq(msgRows(all,ctx),[{tp:'1',msg:'적정문구'},{tp:'2',msg:'차선1문구'},{tp:'3',msg:''}],
 '기준에 세 문구가 다 있어도 차선2 는 빈다');
eq(msgRows({no:'M1',no1:'',no2:''},ctx),[{tp:'1',msg:'적정문구'}],'차선이 없으면 1행');
eq(msgRows({no:'',no1:'M2',no2:''},ctx),[{tp:'2',msg:'차선1문구'}],'적정이 없으면 차선1만');
eq(msgRows(all,toCtx({QLT_MSG_NM1:'',QLT_MSG_NM2:'',QLT_MSG_NM3:'',QLT_MSG_NM_COR:''})),
 [{tp:'1',msg:''},{tp:'2',msg:''},{tp:'3',msg:''}],'기준에 문구가 없으면 세 행 모두 빈다');
eq(msgRows({no:'',no1:'',no2:''},ctx),[],'설계된 구분이 없으면 행이 하나도 없다');

// ── 6. 정전 메세지는 조건 없이 항상 1행 ────────────────────────
function corRow(ctx){return[{msg:ctx.QLT_MSG_NM_COR}];}   // 값 검사 없이 그대로 넘긴다
eq(corRow(ctx),[{msg:'정전문구'}],'정전 문구가 있으면 그대로');
eq(corRow(toCtx({})).length,1,'정전 문구가 없어도 행은 만든다');
eq(corRow(toCtx({}))[0].msg,undefined,'정전 경로는 빈 문자열로 바꾸지 않고 없는 값을 그대로 넘긴다');
// Oracle 은 빈 문자열을 NULL 로 저장하므로 두 경로의 결과는 같아진다
const toOracle=v=>(v===undefined||v===null||v==='')?null:v;
eq(toOracle(''),toOracle(undefined),'빈 문자열과 없는 값은 표에서 구분되지 않는다');

// ── 7. 탭별 저장 범위 ──────────────────────────────────────────
function saveScope(tab,selectedTp){
 if(tab==='TAB05')return{table:'MSG',where:['ORD_NO','ORD_LN','QLT_DSN_MNF_TP='+selectedTp]};
 if(tab==='TAB06')return{table:'MSG',where:['ORD_NO','ORD_LN',"QLT_DSN_MNF_TP='1'"]};
 return{table:'MSG1',where:['ORD_NO','ORD_LN']};
}
eq(saveScope('TAB05','3').where[2],'QLT_DSN_MNF_TP=3','용융도금은 고른 구분을 따라간다');
eq(saveScope('TAB06','3').where[2],"QLT_DSN_MNF_TP='1'",'전기도금은 차선을 골라도 적정에 쓴다');
eq(saveScope('TAB09','1').table,'MSG1','후공정은 정전 표에 쓴다');
eq(saveScope('TAB09','1').where.length,2,'후공정 저장에는 제조구분 조건이 없다');

// ── 8. 탭별 조회 결과 ──────────────────────────────────────────
function selectMsg(tab,rows,cor,selectedTp,terminated){
 if(tab==='TAB09')return terminated?[]:cor;               // 종료주문 필터는 여기에만 있다
 if(tab==='TAB06')return rows.filter(r=>r.tp==='1');       // 적정 고정
 return rows.filter(r=>r.tp===selectedTp);                 // 화면이 넘긴 구분
}
const rows=msgRows(all,ctx),cor=corRow(ctx);
eq(selectMsg('TAB05',rows,cor,'3',false),[{tp:'3',msg:''}],'용융도금에서 차선2 를 고르면 빈칸 한 행');
eq(selectMsg('TAB06',rows,cor,'3',false),[{tp:'1',msg:'적정문구'}],'전기도금은 차선을 골라도 적정을 보여준다');
eq(selectMsg('TAB06',msgRows({no:'',no1:'M2',no2:''},ctx),cor,'2',false),[],'적정이 없으면 전기도금은 0건');
eq(selectMsg('TAB09',rows,cor,'1',true),[],'종료주문이면 후공정은 0건');
eq(selectMsg('TAB05',rows,cor,'1',true),[{tp:'1',msg:'적정문구'}],'종료주문이어도 용융도금은 보인다');

// ── 9. 저장 시 1000 바이트 절단 ────────────────────────────────
const byteLen=s=>Buffer.byteLength(s,'utf8');
function truncate1000(s){
 if(byteLen(s)<=1000)return s;
 let b=Buffer.from(s,'utf8').subarray(0,1000);
 return b.toString('utf8').replace(/�$/,'');
}
eq(truncate1000('짧은 문구'),'짧은 문구','짧으면 그대로');
ok(byteLen(truncate1000('가'.repeat(400)))<=1000,'긴 문구는 1000 바이트로 자른다');
eq(byteLen('가'.repeat(334)),1002,'한글 334 자면 1002 바이트라 잘린다');
// 자동설계 INSERT 에는 절단이 없다
function autoInsert(msg){return msg;}
eq(autoInsert('가'.repeat(400)).length,400,'자동설계 INSERT 는 자르지 않는다');

// ── 10. 포장메세지 결합 ────────────────────────────────────────
function packMessage(code,text){
 // PAK_MSG_CD || MSG_PKG.QLT_MSG_NM · 바깥 조인이라 문구가 없을 수 있다
 const c=code===null||code===undefined?'':code;
 const t=text===null||text===undefined?'':text;
 const joined=c+t;
 return joined===''?null:joined;   // Oracle 에서 빈 문자열은 NULL
}
eq(packMessage('P01','비닐 포장'),'P01비닐 포장','코드와 문구를 이어 붙인다');
eq(packMessage('P01',null),'P01','문구가 없으면 코드만 보인다');
eq(packMessage(null,'비닐 포장'),'비닐 포장','코드가 없으면 문구만 보인다');
eq(packMessage(null,null),null,'둘 다 없으면 빈칸');

// ── 11. 반복주문 복사 ──────────────────────────────────────────
function copyDesign(src){
 // C102100170 은 MSG 와 MSG1 만 베낀다
 return{MSG:src.MSG.map(r=>({...r})),MSG1:src.MSG1.map(r=>({...r})),MSG_PKG:[],CCL_BOM:src.CCL_BOM?'별도 경로':undefined};
}
const copied=copyDesign({MSG:rows,MSG1:cor,MSG_PKG:[{msg:'포장문구'}]});
eq(copied.MSG,rows,'제조구분별 메세지는 그대로 복사된다');
eq(copied.MSG1,cor,'정전 메세지도 그대로 복사된다');
eq(copied.MSG_PKG,[],'포장메세지는 복사 대상이 아니다');
eq(copied.MSG[2].msg,'','대표주문의 빈 차선2 는 복사본에서도 빈다');

// ── 12. 수정설계원 판정 (10.4) ─────────────────────────────────
// 변경이력 중 화면 이름이 용융도금 탭이고 대상 표가 제조사양·원자재인 것만 센다
function countsForDesigner(h){
 return h.chgTxt==='C104000020TAB05'
     && (h.targetTable===null||['TB_C10_QLT_DSN_MNF','TB_C10_QLT_DSN_RMT'].includes(h.targetTable));
}
eq(countsForDesigner({chgTxt:'C104000020TAB05',targetTable:'TB_C10_QLT_DSN_MNF'}),true,'제조사양 수정은 포함');
eq(countsForDesigner({chgTxt:'C104000020TAB05',targetTable:'TB_C10_QLT_DSN_MSG'}),false,'메세지 수정은 제외');
eq(countsForDesigner({chgTxt:'C104000020TAB06',targetTable:'TB_C10_QLT_DSN_MNF'}),false,'전기도금 탭은 제외');
eq(countsForDesigner({chgTxt:'C104000020TAB09',targetTable:'TB_C10_QLT_DSN_MSG1'}),false,'후공정 탭은 제외');
eq(countsForDesigner({chgTxt:'C104000020TAB05',targetTable:null}),true,'대상 표가 비어 있으면 포함');

// ── 13. 확정 주문 저장 차단 (9.4) ─────────────────────────────
function blocksOnConfirmed(tab,changed){
 // 확정 확인 자체를 메세지만 고쳤을 때는 하지 않는다
 if(!changed.rmtl&&!changed.mnf)return{checked:false,blocked:false};
 if(tab==='TAB06')return{checked:true,blocked:true};
 if(tab==='TAB05')return{checked:true,blocked:false};  // 중단 코드가 주석 처리됨
 return{checked:false,blocked:false};                   // TAB09 는 검사 블록 자체가 주석
}
eq(blocksOnConfirmed('TAB05',{msg:true,rmtl:false,mnf:false}),{checked:false,blocked:false},'메세지만 고치면 확정 확인 안 함');
eq(blocksOnConfirmed('TAB06',{msg:true,rmtl:false,mnf:false}),{checked:false,blocked:false},'전기도금도 메세지만이면 확인 안 함');
eq(blocksOnConfirmed('TAB06',{msg:false,rmtl:true,mnf:false}),{checked:true,blocked:true},'전기도금은 원자재 변경 시 막는다');
eq(blocksOnConfirmed('TAB05',{msg:false,rmtl:true,mnf:false}),{checked:true,blocked:false},'용융도금은 알림만 띄운다');
eq(blocksOnConfirmed('TAB09',{msg:false,rmtl:true,mnf:true}),{checked:false,blocked:false},'후공정은 검사 자체가 없다');

// ── 14. 메세지 저장 뒤 수정로그 (10.3) ────────────────────────
const afterMsgSave={TAB05:'end',TAB06:'전기도금이력저장',TAB09:'end'};
eq(afterMsgSave.TAB06,'전기도금이력저장','전기도금만 수정로그로 이어진다');
eq(afterMsgSave.TAB05,'end','용융도금은 수정로그를 남기지 않는다');

// ── 15. 지관발주메시지 · PE-FOAM (12.4) ───────────────────────
function pprText(rule){
 // 기준 결과가 없으면 빈 문자열을 넣고, 조회 자체가 실패하면 에러
 if(rule===undefined)return{err:'KT35'};
 if(rule===null)return{value:''};
 return{value:rule};
}
eq(pprText('지관 3인치'),{value:'지관 3인치'},'기준값을 그대로');
eq(pprText(null),{value:''},'맞는 줄이 없으면 빈 문자열');
eq(pprText(undefined),{err:'KT35'},'조회 실패면 에러코드');

// ── 16. 이름은 메세지인데 아닌 것 (12.5) ──────────────────────
const notQualityMessage={
 'QLT_DSN_ERR_CD':'오류코드',
 'QLT_DSN_ERR_MSG':'오류 송신 문구 (표에 저장 안 함)',
 'EAIAPUSER.TB_C10_B10S1010.QLT_DSN_MSG':'송신 플래그'};
function sendFlagNext(cur){return cur==='A'?'B':cur;}   // 송신하면 A → B
eq(sendFlagNext('A'),'B','송신 대상은 A, 송신 후 B');
eq(sendFlagNext('B'),'B','이미 보낸 것은 그대로');
ok(!('QLT_MSG_NM' in notQualityMessage),'품질메세지 컬럼은 이 목록에 없다');

// ── 17. 재설계 JOB 이 한 번에 잡는 건수 (11.7) ────────────────
function pickForRedesign(orders){
 return orders.filter(o=>o.sts==='I').slice(0,10).map(o=>({...o,sts:'J'}));
}
function deleteMessages(orders){
 // 삭제 쿼리에는 주문 조건이 없다. 상태가 J 인 것 전부.
 return orders.filter(o=>o.sts!=='J');
}
const many=Array.from({length:15},(_,i)=>({no:'O'+i,sts:'I'}));
eq(pickForRedesign(many).length,10,'한 번에 최대 10건');
const mixed=[{no:'A',sts:'J'},{no:'B',sts:'J'},{no:'C',sts:'A'}];
eq(deleteMessages(mixed).map(o=>o.no),['C'],'상태가 J 인 주문의 메세지는 모두 지운다');

// ── 18. 재질코드 검사 순서 (5.5) ──────────────────────────────
function designOrder(mtlCd,std,ctx){
 const inserted={MSG:msgRows(std,ctx),MSG1:corRow(ctx)};   // 먼저 넣고
 if(mtlCd==='')return{err:'KP06',inserted};                 // 그 다음에 검사
 return{ok:true,inserted};
}
const failed=designOrder('',all,ctx);
eq(failed.err,'KP06','재질코드가 없으면 실패');
eq(failed.inserted.MSG.length,3,'실패해도 메세지 3행은 이미 들어가 있다');
eq(failed.inserted.MSG1.length,1,'정전 메세지도 이미 들어가 있다');

console.log(`PASS: ${checks} checks on documented 품질메세지 rules.`);
