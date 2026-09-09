// Structural checks on the generated guide: local references, anchors, embedded assets,
// and the SQL keys / columns / claims quoted in the text.
const fs=require('node:fs');
const path=require('node:path');
const assert=require('node:assert/strict');

const base=path.dirname(__dirname);
const repo=path.resolve(base,'../..');
const stem=path.join(base,'품질메세지_설계_쉽게이해하기');
const md=fs.readFileSync(stem+'.md','utf8');
const html=fs.readFileSync(stem+'.html','utf8');
const read=f=>fs.readFileSync(path.join(repo,f),'utf8');

// 1. every local reference in the Markdown exists
const refs=[...md.matchAll(/!?\[[^\]]*\]\(([^)]+)\)/g)].map(m=>m[1]).filter(r=>!/^https?:/.test(r));
for(const ref of refs){
 const target=path.resolve(base,decodeURI(ref.split('#')[0]));
 assert.ok(fs.existsSync(target),'Missing local reference '+ref);
}

// 2. anchors unique, in-page links resolve
const idList=[...html.matchAll(/\bid="([^"]+)"/g)].map(m=>m[1]);
const ids=new Set(idList);
assert.equal(ids.size,idList.length,'Duplicate HTML ids');
for(const m of html.matchAll(/href="#([^"]+)"/g))assert.ok(ids.has(m[1]),'Broken anchor '+m[1]);

// 3. self-contained
assert.equal((html.match(/<figure>/g)||[]).length,18,'Expected 18 figures');
assert.equal((html.match(/src="data:image\/svg\+xml/g)||[]).length,18,'Figures must be embedded');
assert.equal((html.match(/<script>/g)||[]).length,1,'Exactly one inline script');
assert.ok(!/<script[^>]+src=/.test(html),'No external script');
assert.ok(!/(?:src|href)="https?:\/\//.test(html),'No network dependency');
assert.ok(html.includes('id="qm-explorer"'),'Explorer must be inlined');
assert.ok(!html.includes('id="qm-explorer-slot"'),'Explorer placeholder must be replaced');

// 4. SQL keys quoted in the guide exist
const qMsg=read('src/query/C102100MSG-query.glue_sql');
for(const k of ['C102100MSG.select','C102100MSG.Insert','C102100MSG.update','C102100MSG.delete','C102100MSG.InsertCOR'])
 assert.ok(qMsg.includes(`id="${k}"`),'Missing SQL key '+k);
const q000=read('src/query/C102100000-query.glue_sql');
for(const k of ['C102100000.MSG_ADELETE','C102100000.MSG1_ADELETE','C102100000.MSG_DELETE','C102100000.MSG1_DELETE'])
 assert.ok(q000.includes(`id="${k}"`),'Missing SQL key '+k);
const q170=read('src/query/C102100170-query.glue_sql');
for(const k of ['C102100170.MSGinsert','C102100170.MSG1insert'])
 assert.ok(q170.includes(`id="${k}"`),'Missing SQL key '+k);
const q05=read('src/query/C104000020TAB05-query.glue_sql');
const q06=read('src/query/C104000020TAB06-query.glue_sql');
const q09=read('src/query/C104000020TAB09-query.glue_sql');
for(const [q,k] of [[q05,'C104000020TAB05_MSG.select'],[q05,'C104000020TAB05.MSGupdate'],
 [q06,'C104000020TAB06_MSG.select'],[q06,'C104000020TAB06.MSGupdate'],
 [q09,'C104000020TAB09_MSG.select'],[q09,'C104000020TAB09.MSGupdate'],[q09,'C104000020TAB09.PKG_MSGupdate']])
 assert.ok(q.includes(`id="${k}"`),'Missing SQL key '+k);
const sqlKeys=16;

// 5. files named in the guide exist
const FILES=['src/com/unionsteel/mes/c10/activity/nui/DbSearchQualKeyMatch.java',
 'src/com/unionsteel/mes/c10/activity/nui/DbSearchCclBomData.java',
 'src/com/unionsteel/mes/c10/activity/nui/DbQualDesignLoop.java',
 'src/com/unionsteel/mes/c10/activity/nui/DbSearchProcSizeData.java',
 'src/com/unionsteel/mes/c10/activity/common/DbSetCommit.java',
 'src/com/unionsteel/mes/c10/activity/ui/C104000020ChgHstActivity.java',
 'src/com/unionsteel/mes/c10/activity/common/constants/C10NuiConstantsIF.java',
 'src/service/C102100020-service.xml','src/service/C102100000-service.xml',
 'src/service/C102100170-service.xml','src/service/C102100180-service.xml',
 'src/service/B10R0030_sub-service.xml','src/service/C104000020TAB07-service.xml',
 'src/query/C102100CMN-query.glue_sql','src/query/C104000050-query.glue_sql',
 'src/query/C104000020-query.glue_sql','src/query/C104000020POP_HST-query.glue_sql',
 'src/query/C106000200-query.glue_sql','src/query/C102100CCL_BOM-query.glue_sql',
 'WebContents/C104000020TAB05.jsp','WebContents/C104000020TAB06.jsp','WebContents/C104000020TAB09.jsp',
 'WebContents/C104000020TAB07.jsp',
 'WebContents/header/kr/C104000020TAB01/C104000020TAB01_Form_1.xml'];
for(const f of FILES)assert.ok(fs.existsSync(path.join(repo,f)),'Missing file '+f);
for(const [t,g] of [['TAB05','Grid_7'],['TAB06','Grid_8'],['TAB09','Grid_4'],['TAB07','Grid_8']])
 assert.ok(fs.existsSync(path.join(repo,`WebContents/header/kr/C104000020${t}/C104000020${t}_${g}.xml`)),'Missing header '+t);

// 6. claims that must stay true against the source
const km=read('src/com/unionsteel/mes/c10/activity/nui/DbSearchQualKeyMatch.java');
assert.ok(/colValue = new String\[13\]/.test(km),'설계Key 조건은 13개');
assert.ok(/EasyAccess\.getPosDecisionChecker\( C10B1040, null \)/.test(km),'설계Key기준 C10B1040');
// 4장의 핵심 주장: 담을 때는 NM2, 꺼낼 때는 NM3
assert.ok(/ctx\.put\( COL_QLT_MSG_NM2, result\.getRuleValueAt\( COL_QLT_MSG_NM3 \) \)/.test(km),
 '기준 3번 칸을 QLT_MSG_NM2 로 담는다');
assert.ok(/ctx\.get\( COL_QLT_MSG_NM3 \)/.test(km),'저장 단계는 QLT_MSG_NM3 을 찾는다');
// ctx 에 QLT_MSG_NM3 을 담는 곳이 저장소 전체에 없어야 한다 (4.2 주장의 핵심)
const srcDir=path.join(repo,'src');
let putsNm3=0;
(function walk(d){for(const e of fs.readdirSync(d,{withFileTypes:true})){
 const f=path.join(d,e.name);
 if(e.isDirectory())walk(f);
 else if(/\.(java|xml|glue_sql)$/.test(e.name)){
  const t=fs.readFileSync(f,'utf8');
  if(/ctx\.put\(\s*COL_QLT_MSG_NM3/.test(t))putsNm3++;
  if(/\bQLT_MSG_NM3\b/.test(t)&&/SELECT/i.test(t)&&/\.glue_sql$/.test(e.name))putsNm3++;
 }}})(srcDir);
assert.equal(putsNm3,0,'QLT_MSG_NM3 을 ctx 에 담는 코드가 생겼다면 4.2 를 갱신할 것');
assert.ok(/public static final String C10STR_SPACE = "";/.test(
 read('src/com/unionsteel/mes/c10/activity/common/constants/C10NuiConstantsIF.java')),'빈 문자열 상수');

// 정전 INSERT 는 조건 없이 나간다 (6.1 주장)
const corBlock=km.slice(km.indexOf('// 정전메세지 저장'),km.indexOf('INSERT_MSG_COR'));
assert.ok(!/\bif\s*\(/.test(corBlock),'정전 INSERT 앞에 조건이 생겼다면 6.1 을 갱신할 것');

// KP06 검사는 메세지 INSERT 뒤에 있다 (5.5 주장)
assert.ok(km.indexOf('ERRCD_KP06')>km.indexOf('INSERT_MSG_COR'),
 'KP06 검사가 메세지 INSERT 앞으로 옮겨졌다면 5.5 를 갱신할 것');

// 탭별 제조구분 고정 (9.1·9.2 주장)
const upd=(q,k)=>{const i=q.indexOf(`id="${k}"`);return q.slice(i,q.indexOf(']]>',i));};
assert.ok(/QLT_DSN_MNF_TP = :QLT_DSN_MNF_TP/.test(upd(q05,'C104000020TAB05.MSGupdate')),'TAB05 저장은 바인드');
assert.ok(/QLT_DSN_MNF_TP = '1'/.test(upd(q06,'C104000020TAB06.MSGupdate')),'TAB06 저장은 1 고정');
assert.ok(/QLT_DSN_MNF_TP = '1'/.test(upd(q06,'C104000020TAB06_MSG.select')),'TAB06 조회도 1 고정');
assert.ok(!/QLT_DSN_MNF_TP/.test(upd(q09,'C104000020TAB09.MSGupdate')),'TAB09 저장에 제조구분 조건 없음');
assert.ok(/VI_MES_TRM_CTL/.test(upd(q09,'C104000020TAB09_MSG.select')),'TAB09 조회의 종료주문 필터');
for(const [q,k] of [[q05,'C104000020TAB05_MSG.select'],[q06,'C104000020TAB06_MSG.select']])
 assert.ok(!/VI_MES_TRM_CTL/.test(upd(q,k)),'도금 탭 메세지 조회에 종료주문 필터가 생겼다면 8.1 을 갱신할 것');
assert.ok(/whereExtra"\s+value="QLT_DSN_MNF_TP='1'"/.test(read('src/service/C104000020TAB06-service.xml')),
 'TAB06 이력의 제조구분 고정');

// 사장 쿼리 (7.1 주장): 저장소 어디서도 참조하지 않아야 한다
function refCount(key){
 let n=0;
 (function walk(d){for(const e of fs.readdirSync(d,{withFileTypes:true})){
  const f=path.join(d,e.name);
  if(e.isDirectory())walk(f);
  else if(/\.(java|xml)$/.test(e.name)&&fs.readFileSync(f,'utf8').includes(key))n++;
 }})(srcDir);
 return n;
}
for(const k of ['C102100MSG.select','C102100MSG.update','C102100MSG.delete','C102100000.MSG_DELETE','C102100000.MSG1_DELETE'])
 assert.equal(refCount(k),0,k+' 이 호출되기 시작했다면 7.1 과 부록 A 를 갱신할 것');

// MSG_PKG 에 쓰는 SQL 이 없어야 한다 (7.2 주장)
const qdir=path.join(repo,'src/query');
let pkgWrite=0;
for(const f of fs.readdirSync(qdir).filter(f=>f.endsWith('.glue_sql'))){
 const t=fs.readFileSync(path.join(qdir,f),'utf8');
 if(/(INSERT\s+INTO|UPDATE|DELETE\s+FROM)[\s\S]{0,120}TB_C10_QLT_DSN_MSG_PKG/i.test(t))pkgWrite++;
}
assert.equal(pkgWrite,0,'포장메세지 표에 쓰는 SQL 이 생겼다면 7.2 를 갱신할 것');

// 롤백이 주석 처리돼 있다 (11.6 주장)
const commit=read('src/com/unionsteel/mes/c10/activity/common/DbSetCommit.java');
assert.ok(/\/\/ this\.rollbackTransaction\(txName\);/.test(commit),'롤백이 되살아났다면 11.6 을 갱신할 것');
assert.equal((commit.match(/this\.commitTransaction\( txName \);/g)||[]).length,2,'양쪽 모두 커밋');

// 세 탭 모두 메세지 이력을 남긴다 (10.1 주장)
for(const t of ['TAB05','TAB06','TAB09']){
 const svc=read(`src/service/C104000020${t}-service.xml`);
 assert.ok(/C104000020ChgHstActivity/.test(svc)&&/trackColumns"\s+value="QLT_MSG_NM"/.test(svc),
  t+' 의 메세지 이력 추적이 사라졌다면 10.1 을 갱신할 것');
}
// 수정설계원 판정에서 메세지가 빠져 있다 (10.4 주장)
const q40=read('src/query/C104000020-query.glue_sql');
assert.ok(/TARGET_TABLE_NM IN \('TB_C10_QLT_DSN_MNF','TB_C10_QLT_DSN_RMT'\)/.test(q40),'수정설계원 대상 표');
assert.ok(!/TARGET_TABLE_NM IN \([^)]*TB_C10_QLT_DSN_MSG/.test(q40),
 '수정설계원 대상에 메세지 표가 추가됐다면 10.4 를 갱신할 것');

// 제조구분 1 이 적정이라는 근거 (1.1 주장)
assert.ok(/적정이 F\/H, 차선이 H\/C일 경우/.test(read('src/com/unionsteel/mes/c10/activity/nui/DbSearchProcSizeData.java')),
 '적정·차선 주석이 사라졌다면 1.1 의 용어 근거를 갱신할 것');

// EAI 의 QLT_DSN_MSG 는 송신 플래그 (12.5 주장)
const q50=read('src/query/C104000050-query.glue_sql');
assert.ok(/WHERE QLT_DSN_MSG = 'A'/.test(q50)&&/QLT_DSN_MSG = 'B'/.test(q50),
 'EAI 송신 플래그 사용이 바뀌었다면 12.5 를 갱신할 것');

// 지관발주·PE-FOAM 두 컬럼 (12.4 주장)
const ccl=read('src/com/unionsteel/mes/c10/activity/nui/DbSearchCclBomData.java');
for(const c of ['C10B2290','C10B2300','COL_PPR_RNG_PORD_TXT','COL_PE_FOAM_TXT'])
 assert.ok(ccl.includes(c),'CCL 편성에 '+c);

// 7. every [근거 Sn] id defined in appendix D.1
const defined=new Set([...md.matchAll(/^\| (S\d+) \|/gm)].map(m=>m[1]));
const used=new Set();
for(const m of md.matchAll(/\[근거 ([^\]]+)\]/g))
 for(const id of m[1].matchAll(/S\d+/g))used.add(id[0]);
for(const id of used)assert.ok(defined.has(id),'Undefined evidence id '+id+' (부록 D.1 에 없음)');
assert.ok(defined.size>=25,'부록 D.1 근거 표가 비었음');

// 8. no invented names
assert.ok(!/TB_C10_QLT_DSN_MSG2|(?<!CCL_)QLT_MSG_TXT|C102100MSG\.InsertPKG|TB_C10_QLT_DSN_PKG\b/.test(md),'Incorrect column or SQL name');

console.log(JSON.stringify({references:refs.length,anchors:ids.size,figures:18,sqlKeys,evidenceIds:used.size,evidenceDefined:defined.size}));
