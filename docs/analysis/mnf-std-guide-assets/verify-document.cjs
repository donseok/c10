// Structural checks on the generated guide: local references, anchors, embedded assets,
// and the SQL keys / class names quoted in the text.
const fs=require('node:fs');
const path=require('node:path');
const assert=require('node:assert/strict');

const base=path.dirname(__dirname);
const repo=path.resolve(base,'../..');
const stem=path.join(base,'용융_전기_제조표준_설계_쉽게이해하기');
const md=fs.readFileSync(stem+'.md','utf8');
const html=fs.readFileSync(stem+'.html','utf8');

// 1. every local reference in the Markdown exists
const refs=[...md.matchAll(/!?\[[^\]]*\]\(([^)]+)\)/g)].map(m=>m[1]).filter(r=>!/^https?:/.test(r));
for(const ref of refs){
 const target=path.resolve(base,decodeURI(ref.split('#')[0]));
 assert.ok(fs.existsSync(target),'Missing local reference '+ref);
}

// 2. anchors are unique and every in-page link resolves
const idList=[...html.matchAll(/\bid="([^"]+)"/g)].map(m=>m[1]);
const ids=new Set(idList);
assert.equal(ids.size,idList.length,'Duplicate HTML ids');
for(const m of html.matchAll(/href="#([^"]+)"/g))assert.ok(ids.has(m[1]),'Broken anchor '+m[1]);

// 3. fully self-contained: figures embedded, one inline script, no network assets
assert.equal((html.match(/<figure>/g)||[]).length,14,'Expected 14 figures');
assert.equal((html.match(/src="data:image\/svg\+xml/g)||[]).length,14,'Figures must be embedded');
assert.equal((html.match(/<script>/g)||[]).length,1,'Exactly one inline script');
assert.ok(!/<script[^>]+src=/.test(html),'No external script');
assert.ok(!/(?:src|href)="https?:\/\//.test(html),'No network dependency');
assert.ok(html.includes('id="mnf-explorer"'),'Explorer must be inlined');
assert.ok(!html.includes('id="mnf-explorer-slot"'),'Explorer placeholder must be replaced');

// 4. SQL keys quoted in the guide exist in the query files
const sqlFiles={
 'C102100MNF-query.glue_sql':['C102100MNF.insert','C102100MNF.gw_update','C102100MNF.RR_update',
  'C102100MNF.THK_MNFupdate','C102100MNF.THK_MNFupdate1','C102100MNF.PROCupdate','C102100MNF.PROCupdate1'],
 'C104000020TAB05-query.glue_sql':['C104000020TAB05.MNF_CGLupdate','C104000020TAB05.RMTupdate',
  'C104000020TAB05.MSGupdate','C104000020TAB05.MNF_MDFinsert','C104000020TAB05.PLTCM_update'],
 'C104000020TAB06-query.glue_sql':['C104000020TAB06.EGL_MNFupdate','C104000020TAB06.ANN_saveUpdate',
  'C104000020TAB06.RMTupdate','C104000020TAB06.MSGupdate','C104000020TAB06.MNF_MDFinsert'],
 'C102100PROC-query.glue_sql':['C102100PROC.MNFupdate'],
 'C102100RMTL-query.glue_sql':['C102100RMTL.update'],
};
let keys=0;
for(const [file,list] of Object.entries(sqlFiles)){
 const xml=fs.readFileSync(path.join(repo,'src/query',file),'utf8');
 for(const key of list){assert.ok(xml.includes(`id="${key}"`),'Missing SQL key '+key+' in '+file);keys++;}
}

// 5. classes and services named in the guide exist
const classes=['DbSearchMnfData','DbSearchGwTotData','DbSearchRsnRouData','DbSearchProcData',
 'DbSearchThkSizeData','DbSearchProcSizeData','DbSearchDsnValidData','DbSearchRmtlCdData'];
for(const c of classes)assert.ok(fs.existsSync(path.join(repo,'src/com/unionsteel/mes/c10/activity/nui',c+'.java')),'Missing class '+c);
assert.ok(fs.existsSync(path.join(repo,'src/com/unionsteel/mes/c10/activity/ui/C104000020ChgHstActivity.java')));
for(const s of ['C102100000','C103100020','C103100030','C103100040','C103100050','C103100070','C103100090','C103100130','C104000020TAB05','C104000020TAB06','C104000040'])
 assert.ok(fs.existsSync(path.join(repo,'src/service',s+'-service.xml')),'Missing service '+s);

// 6. rule ids quoted in the guide appear in the constants file
const consts=fs.readFileSync(path.join(repo,'src/com/unionsteel/mes/c10/activity/common/constants/C10NuiConstantsIF.java'),'utf8');
const rules=['C10B2130','C10B2140','C10B2150','C10B2170','C10B2160','C10B2210','C10B2240',
 'C10B2070','C10B2060','C10B1051','C10B2190','C10B2110','C10B2120'];
for(const r of rules)assert.ok(consts.includes(`String ${r} = "${r}"`),'Missing rule constant '+r);
assert.ok(consts.includes('VI_M00_C10A1061 = "C10A1061"'),'Missing 도금량 view constant');

// 7. claims that must stay true against the source
const thk=fs.readFileSync(path.join(repo,'src/com/unionsteel/mes/c10/activity/nui/DbSearchThkSizeData.java'),'utf8');
assert.ok(thk.includes('ERRCD_KK94'),'KK94 branch must exist');
const proc=fs.readFileSync(path.join(repo,'src/com/unionsteel/mes/c10/activity/nui/DbSearchProcData.java'),'utf8');
assert.ok(/TM의 경우는 무조건 1PASS임/.test(proc),'TM Pass 고정 주석이 사라졌다면 6장을 갱신할 것');
const valid=fs.readFileSync(path.join(repo,'src/com/unionsteel/mes/c10/activity/nui/DbSearchDsnValidData.java'),'utf8');
assert.ok(/PRD_NM_CD\.equals\( PRD_NM_CD_C \) && PRD_NM_CD\.equals\( PRD_NM_CD_E \)/.test(valid),
 '11.2절의 && 조건이 수정되었다면 문서를 갱신할 것');
const tab05=fs.readFileSync(path.join(repo,'WebContents/C104000020TAB05.jsp'),'utf8');
assert.ok(/grid2\.setCellByIndexValue\(0,43,""\);\/\/HT\(2CGL\)/.test(tab05),
 '11.1절의 열 번호 불일치가 수정되었다면 문서를 갱신할 것');
assert.ok(/\/\/return;\s*\n/.test(tab05.slice(tab05.indexOf('APS에서 반드시 설계 상속'))),
 'TAB05 확정주문 return 이 주석 해제되었다면 10.3절을 갱신할 것');

// 8. every [근거 Sn] id must be defined in appendix D.1
const defined=new Set([...md.matchAll(/^\| (S\d+b?) \|/gm)].map(m=>m[1]));
const used=new Set();
for(const m of md.matchAll(/\[근거 ([^\]]+)\]/g))
 for(const id of m[1].matchAll(/S\d+b?/g))used.add(id[0]);
for(const id of used)assert.ok(defined.has(id),'Undefined evidence id '+id+' (부록 D.1 에 없음)');
assert.ok(defined.size>=18,'부록 D.1 근거 표가 비었음');

// 9. text must not name fields or SQL that do not exist
assert.ok(!/C102100MNF\.MNFupdate|C104000020TAB05\.EGL_MNFupdate|RMTL_TAR_WTH_UVL_STD/.test(md),'Incorrect SQL or field name');

console.log(JSON.stringify({references:refs.length,anchors:ids.size,figures:14,sqlKeys:keys,rules:rules.length,classes:classes.length,evidenceIds:used.size}));
