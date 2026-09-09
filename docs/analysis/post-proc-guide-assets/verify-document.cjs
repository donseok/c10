// Structural checks on the generated guide: local references, anchors, embedded assets,
// and the SQL keys / columns / claims quoted in the text.
const fs=require('node:fs');
const path=require('node:path');
const assert=require('node:assert/strict');

const base=path.dirname(__dirname);
const repo=path.resolve(base,'../..');
const stem=path.join(base,'후공정_제조표준_설계_쉽게이해하기');
const md=fs.readFileSync(stem+'.md','utf8');
const html=fs.readFileSync(stem+'.html','utf8');

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
assert.ok(html.includes('id="pp-explorer"'),'Explorer must be inlined');
assert.ok(!html.includes('id="pp-explorer-slot"'),'Explorer placeholder must be replaced');

// 4. SQL keys quoted in the guide exist
const q=fs.readFileSync(path.join(repo,'src/query/C104000020TAB09-query.glue_sql'),'utf8');
const keys=['C104000020TAB09_MNF.select','C104000020TAB09_MSG.select','C104000020TAB09.MNFupdate',
 'C104000020TAB09.MSGupdate','C104000020TAB09.STSselect','C104000020TAB09.CHG_HSTinsert',
 'C104000020TAB09.PKG_MSGupdate','C104000020TAB09.CMN.OT_TC_YN_update'];
for(const k of keys)assert.ok(q.includes(`id="${k}"`),'Missing SQL key '+k);

// 5. files named in the guide exist
for(const f of ['src/query/C104000020TAB09-query.glue_sql','src/service/C104000020TAB09-service.xml',
 'WebContents/C104000020TAB09.jsp','src/query/C102100MSG-query.glue_sql','src/service/C102100000-service.xml',
 'src/com/unionsteel/mes/c10/activity/nui/DbSearchMnfData.java',
 'src/com/unionsteel/mes/c10/activity/nui/DbSearchWthSizeData.java',
 'src/com/unionsteel/mes/c10/activity/nui/DbSearchQualKeyMatch.java'])
 assert.ok(fs.existsSync(path.join(repo,f)),'Missing file '+f);
for(const g of ['Grid_1','Grid_2','Grid_3','Grid_5'])
 assert.ok(fs.existsSync(path.join(repo,`WebContents/header/kr/C104000020TAB09/C104000020TAB09_${g}.xml`)),'Missing header '+g);

// 6. claims that must stay true against the source
assert.ok(/QLT_DSN_MNF_TP = '1'/.test(q),'조회의 제조구분 1 조건');
assert.ok(/VI_MES_TRM_CTL/.test(q),'종료주문 필터');
// MNFupdate 에는 제조구분 조건이 없어야 한다 (7장·부록 A 주장)
const mnfUpd=q.slice(q.indexOf('id="C104000020TAB09.MNFupdate"'));
const mnfUpdBody=mnfUpd.slice(0,mnfUpd.indexOf(']]>'));
assert.ok(!/QLT_DSN_MNF_TP/.test(mnfUpdBody),'MNFupdate 에 제조구분 조건이 생겼다면 7장을 갱신할 것');
assert.ok(/DECODE\(:COR_EDG_ASG_TP,'Y',:SLIT_GRP_CNT/.test(mnfUpdBody),'조수 보호 DECODE');
assert.ok(/DECODE\(:COR_EDG_ASG_TP,'Y',:MIX_WTH1/.test(mnfUpdBody),'조합폭1 보호 DECODE');
assert.ok(/,MIX_WTH2\s*=\s*:MIX_WTH2/.test(mnfUpdBody),'조합폭2 는 보호 없음');
assert.ok(/LEAST\(TB_C10_QLT_DSN_CMN.SUB_PTL_WTH, TB_C10_QLT_DSN_CMN.SUB_PTL_LTH\)/.test(q),'SKID 폭 LEAST');
assert.ok(/GREATEST\(TB_C10_QLT_DSN_CMN.SUB_PTL_WTH, TB_C10_QLT_DSN_CMN.SUB_PTL_LTH\)/.test(q),'SKID 길이 GREATEST');
assert.ok(/SUBSTR\(TB_C10_QLT_DSN_CMN.ORD_PTT_FLM_DTL_CD,2,1\)/.test(q),'보호필름 2번째 자리');
assert.ok(/SUBSTR\(TB_C10_QLT_DSN_CMN.ORD_PTT_FLM_DTL_CD,4,1\)/.test(q),'보호필름 4번째 자리');
assert.ok(/SUBSTR\(TB_C10_QLT_DSN_CMN.ORD_PTT_FLM_DTL_CD,5,1\)/.test(q),'보호필름 5번째 자리');
assert.ok(/PTT_FLM_MNG_ADH_TXT[\s\S]{0,200}TB_C10_QLT_DSN_CCL_BOM/.test(q),'관리점착력 칼라 BOM 우선');
assert.ok(/'C104000020TAB09'/.test(q),'이력에 화면 이름 문자열');

const jsp=fs.readFileSync(path.join(repo,'WebContents/C104000020TAB09.jsp'),'utf8');
assert.ok(/확정된 주문이라도 수정할수 있도록 수정 : 박성용요청 20140611/.test(jsp),
 '10장의 확정주문 주석이 사라졌다면 문서를 갱신할 것');
assert.ok(/code=CUT_LN_YN/.test(jsp),'S/T 유무 콤보가 CUT_LN_YN 을 읽는다');
assert.ok(/code=OT_TC_YN/.test(jsp),'1T2C 콤보');

// MSG_PKG 에 INSERT 하는 SQL 이 없어야 한다 (6장 주장)
const qdir=path.join(repo,'src/query');
let pkgInsert=0;
for(const f of fs.readdirSync(qdir).filter(f=>f.endsWith('.glue_sql'))){
 const t=fs.readFileSync(path.join(qdir,f),'utf8');
 if(/INSERT\s+INTO[\s\S]{0,120}TB_C10_QLT_DSN_MSG_PKG/i.test(t))pkgInsert++;
}
assert.equal(pkgInsert,0,'포장메세지 표에 INSERT 가 생겼다면 6장을 갱신할 것');

// 6b. 이력기록은 컬럼 단위 INSERT 를 쓴다 (9.2 주장)
const act=fs.readFileSync(path.join(repo,'src/com/unionsteel/mes/c10/activity/ui/C104000020ChgHstActivity.java'),'utf8');
assert.ok(/CHG_HST_INSERT_SQLKEY\s*=\s*"C104000020CHG_HST\.insert"/.test(act),'이력 액티비티의 SQL 키');
assert.ok(/String chgTxt\s*=\s*screenId \+ tabId/.test(act),'CHG_TXT = screenId + tabId');
const chg=fs.readFileSync(path.join(repo,'src/query/C104000020CHG_HST-query.glue_sql'),'utf8');
for(const c of ['COLUMN_NM','OLD_VAL','NEW_VAL','TARGET_TABLE_NM','TARGET_PK_INFO'])
 assert.ok(chg.includes(c),'변경이력 INSERT 에 '+c);
// TAB09.CHG_HSTinsert 는 서비스에서 호출되지 않아야 한다 (9.2 주장)
const svc=fs.readFileSync(path.join(repo,'src/service/C104000020TAB09-service.xml'),'utf8');
assert.ok(!/C104000020TAB09\.CHG_HSTinsert/.test(svc),'구버전 이력 INSERT 가 호출되기 시작했다면 9.2 를 갱신할 것');

// 6c. 종료 필터의 적용 범위 (2.2 주장): 용융·전기 탭에는 없고, 같은 화면 다른 탭에는 있다
for(const t of ['TAB05','TAB06'])
 assert.ok(!/VI_MES_TRM_CTL/.test(fs.readFileSync(path.join(repo,`src/query/C104000020${t}-query.glue_sql`),'utf8')),
  t+' 에 종료 필터가 생겼다면 2.2 를 갱신할 것');
for(const t of ['TAB02','TAB03','TAB04','TAB08'])
 assert.ok(/VI_MES_TRM_CTL/.test(fs.readFileSync(path.join(repo,`src/query/C104000020${t}-query.glue_sql`),'utf8')),
  t+' 의 종료 필터가 사라졌다면 2.2 를 갱신할 것');

// 6d. 공통코드 두 경로 (부록 B 주장)
assert.ok(/CATEGORY_GROUP_NM = 'SZ0000'/.test(q),'조회 SQL 의 공통코드 그룹');
for(const c of ['CUT_LN_YN','OT_TC_YN','PAK_MSG_CD'])
 assert.ok(new RegExp(`basicLovData\\.do\\?ServiceName=lov-service&category=SZ0000&code=${c}`).test(jsp),
  c+' 콤보가 lov-service 를 쓰지 않는다면 부록 B 를 갱신할 것');
const lov=fs.readFileSync(path.join(repo,'src/query/lov-query.glue_sql'),'utf8');
for(const t of ['TB_M00_CATEGORY_GR','TB_M00_CODES020','TB_M00_CODES030'])
 assert.ok(lov.includes(t),'lov 조회에 '+t);

// 6e. 정전 그리드 칸 수 (5.3 주장)
const g1=fs.readFileSync(path.join(repo,'WebContents/header/kr/C104000020TAB09/C104000020TAB09_Grid_1.xml'),'utf8');
assert.equal((g1.match(/<column /g)||[]).length,17,'정전 그리드 열 정의 17개');
assert.equal((g1.match(/hidden="true"/g)||[]).length,2,'정전 그리드 숨김 열 2개');
assert.equal((g1.match(/<cell>/g)||[]).length,13,'정전 그리드 초기 행 13칸');
const g3=fs.readFileSync(path.join(repo,'WebContents/header/kr/C104000020TAB09/C104000020TAB09_Grid_3.xml'),'utf8');
assert.equal((g3.match(/<column /g)||[]).length,7,'보호필름 그리드 열 정의 7개');
assert.equal((g3.match(/<cell>/g)||[]).length,5,'보호필름 그리드 초기 행 5칸');

// 6f. 편집 대상 일곱 항목 (1.1 주장)
const editTbl=md.slice(md.indexOf('### 1.1 편집 대상'),md.indexOf('**같은 그리드'));
assert.equal(editTbl.split('\n').filter(l=>/^\| /.test(l)&&!/^\|---/.test(l)).length-1,7,'1.1 표는 머리행 제외 7행');
assert.ok(/편집 대상 일곱 항목/.test(md)&&!/편집 대상 여섯 항목/.test(md),'1.1 제목의 항목 수');

// 7. every [근거 Sn] id defined in appendix D.1
const defined=new Set([...md.matchAll(/^\| (S\d+) \|/gm)].map(m=>m[1]));
const used=new Set();
for(const m of md.matchAll(/\[근거 ([^\]]+)\]/g))
 for(const id of m[1].matchAll(/S\d+/g))used.add(id[0]);
for(const id of used)assert.ok(defined.has(id),'Undefined evidence id '+id+' (부록 D.1 에 없음)');
assert.ok(defined.size>=10,'부록 D.1 근거 표가 비었음');

// 8. no invented names
assert.ok(!/SKID_WTH 컬럼|TB_C10_QLT_DSN_SKID|C104000020TAB09\.MNF_MDFinsert/.test(md),'Incorrect column or SQL name');

console.log(JSON.stringify({references:refs.length,anchors:ids.size,figures:18,sqlKeys:keys.length,evidenceIds:used.size}));
