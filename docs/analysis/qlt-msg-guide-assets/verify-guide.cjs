// Browser checks with local Playwright + Chrome: figure rendering, text bounds,
// scenario selections, mobile overflow, console errors.
// Playwright/Chrome paths follow this workstation; change them elsewhere.
const assert=require('node:assert/strict');
const fs=require('node:fs');
const path=require('node:path');
const {pathToFileURL,fileURLToPath}=require('node:url');

const PLAYWRIGHT=process.env.PLAYWRIGHT_PATH||'/Users/jerry/prj-manager/node_modules/playwright';
const CHROME=process.env.CHROME_PATH||'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const {chromium}=require(PLAYWRIGHT);
const base=path.resolve(__dirname,'..');
const file=path.join(base,'품질메세지_설계_쉽게이해하기.html');

(async()=>{
 const browser=await chromium.launch({headless:true,executablePath:CHROME});
 const page=await browser.newPage({viewport:{width:1280,height:900}});
 const errors=[];page.on('pageerror',e=>errors.push(e.message));
 await page.goto(pathToFileURL(file).href);
 await page.evaluate(()=>document.fonts.ready);

 const check=await page.evaluate(()=>({
  imgs:[...document.images].map(i=>({ok:i.complete&&i.naturalWidth>0,src:i.src.slice(0,32)})),
  ids:[...document.querySelectorAll('[id]')].map(e=>e.id),
  hrefs:[...document.querySelectorAll('a[href]')].map(e=>e.href),
  external:document.querySelectorAll('script[src],link[rel=stylesheet]').length,
  tables:document.querySelectorAll('table').length,
 }));
 assert.equal(check.imgs.length,18,'18 figures rendered');
 assert.ok(check.imgs.every(i=>i.ok&&i.src.startsWith('data:')),'All figures embedded and decoded');
 assert.equal(new Set(check.ids).size,check.ids.length,'Unique ids');
 assert.equal(check.external,0,'No external assets');
 let links=0;
 for(const h of check.hrefs){
  const u=new URL(h);
  if(u.hash&&u.pathname===new URL(page.url()).pathname)assert.ok(check.ids.includes(decodeURIComponent(u.hash.slice(1))),'Anchor '+u.hash);
  else if(u.protocol==='file:')assert.ok(fs.existsSync(fileURLToPath(u)),'Local file '+u.pathname);
  links++;
 }

 // no horizontal overflow on desktop
 assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+2),'No desktop overflow');

 // every scenario renders four steps and a non-empty summary
 const n=await page.locator('#qm-scenario option').count();
 assert.equal(n,6,'6 scenarios');
 const seen=new Set();
 for(let i=0;i<n;i++){
  const value=await page.locator('#qm-scenario option').nth(i).getAttribute('value');
  await page.selectOption('#qm-scenario',value);
  const steps=await page.locator('#qm-steps li').count();
  assert.equal(steps,4,'4 steps for '+value);
  const state=await page.locator('#qm-result').getAttribute('data-state');
  assert.ok(['ok','partial','blank','terminated'].includes(state),'state set for '+value);
  assert.ok((await page.locator('#qm-result').innerText()).length>0,'Summary for '+value);
  assert.ok(await page.locator('#qm-rows tr').count()>=10,'Condition rows for '+value);
  seen.add(value);
 }
 assert.equal(seen.size,6,'All scenarios distinct');
 await page.selectOption('#qm-scenario','full');

 // mobile: no horizontal overflow
 await page.setViewportSize({width:390,height:844});
 assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+2),'No mobile overflow');
 await page.setViewportSize({width:1280,height:900});

 // figure text must stay inside the viewBox
 let svgs=0;
 for(const f of fs.readdirSync(__dirname).filter(f=>f.endsWith('.svg'))){
  await page.goto(pathToFileURL(path.join(__dirname,f)).href);
  const bad=await page.evaluate(()=>[...document.querySelectorAll('text')].filter(e=>{
   const b=e.getBBox(),v=document.querySelector('svg').viewBox.baseVal;
   return b.x<0||b.y<0||b.x+b.width>v.width||b.y+b.height>v.height;
  }).map(e=>e.textContent));
  assert.deepEqual(bad,[],'Text outside viewBox in '+f);
  svgs++;
 }
 assert.deepEqual(errors,[],'No browser errors');
 await browser.close();
 console.log(JSON.stringify({figures:check.imgs.length,tables:check.tables,links,scenarios:n,svgs,browserErrors:errors.length,mobileOverflow:false}));
})().catch(e=>{console.error(e);process.exit(1)});
