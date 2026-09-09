// Isolated numerical/branch checks; not an integration test of GLUE, Java, MD or Oracle.
const assert=require('node:assert/strict');let checks=0;
const empty=x=>x===null||x===undefined||x==='';
function compare(a,b,max){if(empty(b))return a;if(empty(a))return b;if(Number(b)===0)return a;if(Number(a)===0)return b;return max?Math.max(a,b):Math.min(a,b);}
function merge(...rows){return rows.reduce((a,b)=>[compare(a[0],b[0],true),compare(a[1],b[1],false)],[null,null]);}
function pair(c,s){return c.every(empty)?s:c;}
function special(c,s){return[compare(c[0],s[0],true),empty(c[1])||empty(s[1])?compare(c[1],s[1],true):Math.min(c[1],s[1])];}
function test(actual,expected){assert.deepEqual(actual,expected);checks++;}
test(merge([.03,.10],[.02,.12],[.04,.09]),[.04,.09]);
test(merge([null,null],[.02,.12]),[.02,.12]);
test(merge([.12,.18],[.02,.10]),[.12,.10]);
test(compare(0,.10,false),.10);test(compare(null,0,false),0);test(compare(0,0,true),0);test(compare(0,-2,true),-2);
test(merge([280,400],[270,410],[300,390]),[300,390]);
test([80,100,120].find(x=>!empty(x)),80);test([null,100,120].find(x=>!empty(x)),100);
const sqlNvl=(customer,existing)=>empty(customer)?existing:customer;
test(sqlNvl(280,300),280);test(sqlNvl(400,390),400);test(sqlNvl(null,390),390);test(sqlNvl(0,390),0);
test(pair([null,2],[-2,3]),[null,2]);test(pair([-3,4],[-2,3]),[-3,4]);test(pair([null,null],[-2,3]),[-2,3]);test(pair([0,0],[-2,3]),[0,0]);
test(special([-1,2],[-2,3]),[-1,2]);test(special([0,0],[-2,3]),[-2,0]);test(special([null,null],[-2,3]),[-2,3]);test(special([-1,null],[-2,3]),[-1,3]);
test(special([-1,2],[-2,3]).map(x=>1000+x),[999,1002]);test(special([0,0],[-2,3]).map(x=>1000+x),[998,1000]);
console.log(`${checks} explanatory calculation and branch checks passed.`);
