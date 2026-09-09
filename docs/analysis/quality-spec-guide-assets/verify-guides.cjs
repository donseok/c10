const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const {pathToFileURL,fileURLToPath}=require('node:url');
const {chromium}=require('/Users/jerry/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const base=path.resolve(__dirname,'..');
(async()=>{
 const browser=await chromium.launch({headless:true,executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'});
 const page=await browser.newPage({viewport:{width:1280,height:900}});let errors=[],links=0,scenarios=0;page.on('pageerror',e=>errors.push(e.message));
 for(const title of ['성분설계','재질설계','인수도설계']){
  await page.goto(pathToFileURL(path.join(base,title+'_쉽게이해하기.html')).href);await page.evaluate(()=>document.fonts.ready);
  const check=await page.evaluate(()=>({imgs:[...document.images].map(i=>({ok:i.complete&&i.naturalWidth>0,src:i.src})),ids:[...document.querySelectorAll('[id]')].map(e=>e.id),hrefs:[...document.querySelectorAll('a[href]')].map(e=>e.href),external:document.querySelectorAll('script[src],link[rel=stylesheet]').length}));
  assert(check.imgs.length>=6);assert(check.imgs.every(i=>i.ok&&i.src.startsWith('data:')));assert.equal(new Set(check.ids).size,check.ids.length);assert.equal(check.external,0);
  for(const h of check.hrefs){const u=new URL(h);if(u.hash&&u.pathname===new URL(page.url()).pathname)assert(check.ids.includes(decodeURIComponent(u.hash.slice(1))));else if(u.protocol==='file:')assert(fs.existsSync(fileURLToPath(u)));links++;}
  const n=await page.locator('#spec-scenario option').count();for(let i=0;i<n;i++){await page.selectOption('#spec-scenario',String(i));assert((await page.locator('#spec-result').innerText()).length>0);scenarios++;}
  await page.selectOption('#spec-scenario','0');await page.locator('figure').nth(1).screenshot({path:'/tmp/'+title+'-diagram.png'});
  await page.setViewportSize({width:390,height:844});assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+2));await page.locator('.spec-explorer').screenshot({path:'/tmp/'+title+'-mobile.png'});await page.setViewportSize({width:1280,height:900});
 }
 let svgs=0;for(const f of fs.readdirSync(__dirname).filter(f=>f.endsWith('.svg'))){await page.goto(pathToFileURL(path.join(__dirname,f)).href);const bad=await page.evaluate(()=>[...document.querySelectorAll('text')].filter(e=>{let b=e.getBBox(),v=document.querySelector('svg').viewBox.baseVal;return b.x<0||b.y<0||b.x+b.width>v.width||b.y+b.height>v.height;}).map(e=>e.textContent));assert.deepEqual(bad,[],f);svgs++;}
 assert.deepEqual(errors,[]);await browser.close();console.log(JSON.stringify({guides:3,links,scenarios,svgs,browserErrors:errors.length,mobileOverflow:false}));
})().catch(e=>{console.error(e);process.exit(1)});
