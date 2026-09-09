// Independent reproduction of documented formulas with illustrative positive inputs.
// Does not run GLUE/Java or query operating rule data.
const assert=require('node:assert/strict');
let checks=0;
function eq(actual,expected,label){assert.deepEqual(actual,expected,label);checks++;}
function product(w,mixes,n,e,cut=false){
 let b=0,p=0;
 if(cut&&n===2){b=w===mixes[0]?w:mixes[0];p=b+e;}
 else if(n>0){b=mixes.reduce((a,v)=>a+v,0);p=b+e*n;}
 else {b=w;p=w+e;}
 return {b,p};
}
function processWidths(xs,shr,cor){
 const bases=xs.map((x,i)=>x+shr[i]);
 const cap=Math.max(...bases);
 return {cap,pl:xs.map((x,i)=>Math.round(Math.min(cap,bases[i]+cor[i]))),pltcm:xs.map(Math.round)};
}
const galNames=new Set(['G','K','J','L','V','W','3','4','6','9','E','2','N','8']);
function raw(edge,prd,m,p,s,a){return Math.round(edge==='C'?m:edge==='N'?(galNames.has(prd)?m:p):m+s+a);}
const round1=x=>Math.round(x*10)/10;
function fh(m,tp,inputCode){return tp==='1'&&inputCode.startsWith('D')?m-3:m;}
eq(product(1000,[],0,2),{b:1000,p:1002},'GI product');
eq(product(600,[600,400],2,2),{b:1000,p:1004},'Slit uses sum');
eq(product(600,[600,600],2,2,true),{b:600,p:602},'Cut 2 same width');
eq(product(1200,[600,600],2,2,true),{b:600,p:602},'Cut 2 different width');
eq((602+1)*2,1206,'Middle finishing width');
eq(product(1000,Array(10).fill(0),2,2),{b:0,p:4},'Missing mix input consequence');
eq(product(400,[400,400,400],3,2,true),{b:1200,p:1206},'Cut three uses sum');
const p=product(1000,[],0,2).p,cgl=p+1+3;
eq(cgl,1006,'CGL width');
const preferred=processWidths([cgl+2],[3],[0]);
const alternate=processWidths([cgl+4],[5],[0]);
eq(preferred,{cap:1011,pl:[1011],pltcm:[1008]},'Preferred H process');
eq(alternate,{cap:1015,pl:[1015],pltcm:[1010]},'Alternate H process');
eq(raw('S','G',1008,p,3,5),1016,'Preferred H raw');
eq(raw('S','G',1010,p,5,7),1022,'Alternate H raw');
eq(round1(cgl-1),1005,'Purchased G raw');
eq(processWidths([1008],[3],[2]).pl,[1011],'Single route positive correction capped');
eq(processWidths([1008],[3],[-2]).pl,[1009],'Negative correction retained');
eq(processWidths([1008,1012],[3,4],[2,2]),{cap:1016,pl:[1013,1016],pltcm:[1008,1012]},'Figure 5 cap');
eq(raw('S','G',1012,p,4,5),1021,'Figure 5 raw');
eq(raw('C','G',1008,p,3,5),1008,'Coil Edge');
eq(raw('N','G',1008,p,3,5),1008,'No Slit GI');
eq(raw('N','C',1008,p,3,5),1002,'No Slit CR uses product');
eq(1008+20,1028,'C/N thickness-rule width only');
eq(fh(1008,'1','D32'),1005,'Preferred F/H -3');
eq(fh(1008,'2','D32'),1008,'Alternate 1 F/H unchanged');
eq(fh(1008,'3','D32'),1008,'Alternate 2 F/H unchanged');
eq(fh(1008,'1','H32'),1008,'Context H to D conversion does not change local input');
eq(round1(1008.24-3),1005.2,'Purchased CR decimal');
eq(Math.round(1008.24-3),1005,'Purchased CR for product E integer');
eq(round1(1006.24-1),1005.2,'Purchased coating decimal');
eq(processWidths([1008,1012],[10,1],[0,0]).cap,1018,'Max sum is not sum at max width');
eq(raw('S','G',1012,p,1,5),1018,'Counterexample actual raw');
eq(1018+5,1023,'Counterexample incorrect shortcut');
eq(processWidths([1008.4],[0.2],[0]),{cap:1008.6,pl:[1009],pltcm:[1008]},'Round only after ST calculation');
eq(raw('S','G',1008,p,0.2,0),1008,'Raw reuses stored rounded PLTCM width');
eq(1+2+3,6,'Beginner figure B shrink budget');
eq(3+5,8,'Beginner figure B margin budget');
eq(1002+6+8,1016,'Beginner figure B total from product');
const cutProduct=product(1200,[600,600],2,2,true).p;
const cutMiddle=(cutProduct+1)*2;
const cutCgl=cutMiddle+1+3;
const cutPltcm=Math.round(cutCgl+2);
eq(cutMiddle,1206,'Beginner figure G two strips');
eq(cutCgl,1210,'Beginner figure G coating');
eq(cutPltcm,1212,'Beginner figure G rolling');
eq(raw('S','3',cutPltcm,cutProduct,3,5),1220,'Beginner figure G raw material');
console.log(`PASS: ${checks} illustrative numeric and branch checks. No operating DB or Java/GLUE execution.`);
