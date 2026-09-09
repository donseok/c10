// Code-authored diagrams. All numeric inputs are illustrative, not operating data.
const fs = require('node:fs');
const path = require('node:path');
const C={ink:'#17324d',teal:'#007f86',muted:'#516579',line:'#b7c8d5',pale:'#eef7f8',gray:'#f2f5f8',warm:'#fff4e7'};
const esc=s=>String(s).replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;');
const text=(x,y,s,size=24,color=C.ink,weight=400)=>`<text x="${x}" y="${y}" font-size="${size}" fill="${color}" font-weight="${weight}">${esc(s)}</text>`;
const rect=(x,y,w,h,fill=C.gray)=>`<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="12" fill="${fill}" stroke="${C.line}"/>`;
const arrow=d=>`<path d="${d}" fill="none" stroke="${C.teal}" stroke-width="3" marker-end="url(#arrow)"/>`;
function box(x,y,w,h,title,lines=[],fill=C.gray){return rect(x,y,w,h,fill)+text(x+20,y+37,title,26,C.ink,700)+lines.map((s,i)=>text(x+20,y+75+31*i,s,22)).join('');}
function save(name,h,title,desc,parts){fs.writeFileSync(path.join(__dirname,name),`<svg xmlns="http://www.w3.org/2000/svg" width="1100" height="${h}" viewBox="0 0 1100 ${h}" role="img" aria-labelledby="title desc"><title id="title">${esc(title)}</title><desc id="desc">${esc(desc)}</desc><defs><marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto"><path d="M0 0L10 5L0 10Z" fill="${C.teal}"/></marker></defs><rect width="1100" height="${h}" fill="#fff"/><g font-family="Apple SD Gothic Neo, Noto Sans CJK KR, sans-serif">${parts.join('\n')}</g></svg>\n`);}
{
 const p=[text(35,48,'완제품에서 원자재 쪽으로 필요한 폭을 거슬러 계산합니다',31,C.ink,700),text(35,86,'설명용 GI · Slit Edge · 중간재 미적용 · 대체공정 없음 / 단위 mm',22,C.muted)];
 const rows=[['주문폭','1,000','고객 주문값'],['제품·정전 목표폭','1,002','제품폭여유 +2'],['CGL 목표폭','1,006','정전수축 +1, 정전마진 +3'],['PLTCM 목표폭','1,008','CGL수축 +2'],['원자재 목표폭','1,016','PLTCM수축 +3, 원자재마진 +5']];
 rows.forEach(([label,n,note],i)=>{const y=118+i*118;p.push(rect(35,y,1030,94,i===4?C.pale:C.gray),text(57,y+38,label,25,C.ink,700),text(440,y+58,n,38,C.teal,700),text(650,y+53,note,23));if(i<4)p.push(arrow(`M540 ${y+97}V${y+115}`));});
 p.push(text(35,755,'PL/ST 목표폭은 별도로 1,011입니다. 원자재 목표폭 1,016과 구별합니다.',24,C.ink,700));
 save('01-width-chain.svg',790,'주문폭에서 원자재폭까지','주문폭 1000, 제품폭 1002, CGL폭 1006, PLTCM폭 1008, 원자재폭 1016. PL/ST폭은 별도 1011.',p);
}
{
 const p=[text(35,48,'적정·차선은 행이고, 주공정·대체공정은 그 행 안의 경로입니다',30,C.ink,700),text(35,87,'아래 숫자는 구조 설명용 PLTCM 목표폭입니다. 단위 mm.',22,C.muted)];
 ['제조사양 행','주공정','대체공정 1','대체공정 2','원자재 계산용 최대폭'].forEach((s,i)=>p.push(text([35,245,430,625,810][i],144,s,i===4?21:23,C.ink,700)));
 const rows=[['적정 1','1,008','1,012','1,010','1,012'],['차선1 (2)','1,009','1,014','1,011','1,014']];
 rows.forEach((r,i)=>{const y=175+i*140;p.push(rect(35,y,1030,108,i?C.warm:C.pale));r.forEach((s,j)=>p.push(text([55,250,435,630,875][j],y+63,s,j===0?27:32,j===4?C.teal:C.ink,j===4?700:500)));p.push(arrow(`M747 ${y+53}H837`));});
 p.push(text(35,502,'각 행 안에서 PLTCM 폭 3개를 비교합니다. 적정과 차선을 합쳐 비교하지 않습니다.',23),text(35,544,'구매반제품 차선은 공정폭을 복사해도, 마지막 원자재폭은 소재 종류에 따라 계산합니다.',23));
 save('02-row-and-route.svg',582,'제조구분과 대체공정 구별','적정1과 차선2의 각 행 안에 주공정과 대체공정1,2가 있고 각 행의 최대 PLTCM폭을 계산한다.',p);
}
{
 const p=[text(35,48,'먼저 원자재가 어느 계산 경로를 타는지 확인합니다',31,C.ink,700)];
 p.push(box(35,95,1030,105,'제조구분: 적정(1) · 차선1(2) · 차선2(3)',['주문번호 + 주문행 + 제조구분으로 한 행을 특정합니다.'],C.pale),arrow('M550 203V242'));
 p.push(box(35,253,495,180,'적정 또는 열연 H/M 차선',['제품폭·공정폭 계산 실행','품명 5/7도 별도 예외로 계산']),box(570,253,495,180,'구매반제품 차선',['제조구분 ≠ 1, 원자재 H/M 아님','품명 5/7 제외','제품폭·공정폭은 적정에서 복사'],C.warm));
 p.push(arrow('M283 436V487'),arrow('M817 436V487'));
 p.push(box(35,500,1030,106,'원자재 Size 단계는 각 행에서 실행',['C10B2230 중간재 적용 여부와 원자재 첫 글자로 마지막 산식을 선택합니다.'],C.pale));
 p.push(arrow('M550 609V648'),box(35,660,320,147,'열연 일반 경로',['최대 PLTCM폭','+ 수축 + 마진','Edge C/N은 별도 산식']),box(390,660,320,147,'구매·중간재 경로',['D: 최대 PLTCM폭','C: TM폭 − 3','도금재: CGL/EGL폭 − 1']),box(745,660,320,147,'품명 5/7',['제품목표폭 반올림','알루미늄칼라','스테인레스칼라']));
 p.push(text(35,855,'적정 D* F/H는 조건 충족 시 최대 PLTCM폭에서 3mm를 뺍니다.',24,C.ink,700));
 save('03-design-path.svg',895,'적정과 차선의 설계 경로','구매반제품 차선은 제품폭과 공정폭을 복사하되 원자재 Size를 실행한다. 원자재 소재별로 마지막 산식이 다르다.',p);
}
{
 const p=[text(35,48,'Slit 조수가 있으면 조합폭을 먼저 확인합니다',31,C.ink,700),text(35,88,'설명용 폭여유 2mm / 나머지 조합폭은 0 / 재단선 2조 특례는 아래 별도',22,C.muted)];
 p.push(rect(35,125,618,115,C.pale),rect(653,125,412,115,C.warm),text(235,195,'조합폭 1 = 600',30,C.ink,700),text(715,195,'조합폭 2 = 400',30,C.ink,700),arrow('M550 245V280'));
 p.push(box(35,294,1030,124,'일반 Slit 2조 → 제품목표폭 1,004',['600 + 400 + (2 × 2) = 1,004','주문폭에 조수를 곱하는 과거 주석보다, 현재 조합폭 합산 코드를 우선합니다.'],C.pale));
 p.push(box(35,453,1030,184,'재단선 Y · 2조 · 주문폭 1,200 · 조합폭 1 = 600',['제품목표폭 = 600 + 2 = 602','CCL수축 1 가정 → 중간정전 목표폭 = (602 + 1) × 2 = 1,206','이 특례는 조합폭 1을 사용합니다. 조합폭 1+2로 바꾸어 계산하지 않습니다.'],C.warm));
 p.push(text(35,689,'제품폭 보증범위는 원래 주문폭 + 인수도공차입니다. 이 목표폭 합산과 별도입니다.',22));
 save('04-slit-width.svg',728,'조합폭과 재단선 2조 특례','일반 Slit은 600과 400에 조당 여유2를 더해1004. 재단선Y 2조 특례는602를 구한 뒤 수축1을 더하고 두배하여1206.',p);
}
{
 const p=[text(35,48,'원자재폭은 PL/ST 목표폭에 마진을 더한 값과 다를 수 있습니다',29,C.ink,700),text(35,89,'설명용: PLTCM 폭 1,008 / 1,012, PLTCM수축 3 / 4, ST보정 +2 / +2',22,C.muted)];
 p.push(box(35,126,495,144,'PL/ST 계산의 상한 = 1,016',['max(1,008+3, 1,012+4)','→ 수축을 더한 뒤 최대값을 고름'],C.pale),box(570,126,495,144,'원자재 계산의 기준폭 = 1,012',['max(1,008, 1,012)','→ PLTCM폭만 먼저 비교함'],C.warm));
 p.push(arrow('M280 273V318'),arrow('M815 273V318'));
 p.push(box(35,332,495,185,'저장 PL/ST 목표폭',['주공정: min(1,016, 1,011+2)','= 1,013','대체 1: min(1,016, 1,016+2)','= 1,016'],C.pale),box(570,332,495,185,'원자재 목표폭',['선택폭 1,012로 수축기준 재조회','수축 4, 마진 5 가정','1,012 + 4 + 5 = 1,021'],C.warm));
 p.push(text(35,579,'ST보정은 원자재폭 산식에 직접 들어가지 않습니다.',25,C.ink,700),text(35,622,'원자재폭은 “최대 PL/ST폭 + 마진”으로 계산하지 않습니다. 각 조회 입력을 확인합니다.',22));
 save('05-st-versus-raw.svg',660,'PL/ST와 원자재폭의 최대값 연산 비교','PL/ST는 폭수축 합의 최대값을 cap으로 쓴다. 원자재는 PLTCM폭 최대를 먼저 선택하고 수축을 다시 조회한다.',p);
}
{
 const p=[text(35,48,'같은 주문이라도 구매하는 소재에 따라 출발 폭이 바뀝니다',30,C.ink,700),text(35,88,'각 행은 독립 설명용 예제입니다. 서로 같은 주문의 실적을 뜻하지 않습니다.',22,C.muted)];
 const rows=[['적정 F/H · D*','최대 PLTCM 1,008 − 3','1,005'],['차선 F/H · D*','최대 PLTCM 1,008 그대로','1,008'],['구매 CR · C*','TM 1,008.24 − 3 → 소수 1자리','1,005.2'],['구매 GI 계열 · G/L/V/W','CGL 1,006.24 − 1 → 소수 1자리','1,005.2'],['구매 EGI 계열 · E/N','EGL 1,006.24 − 1 → 소수 1자리','1,005.2']];
 rows.forEach(([t,f,v],i)=>{const y=121+i*97;p.push(rect(35,y,1030,78,i===0?C.warm:C.gray),text(55,y+46,t,23,C.ink,700),text(390,y+46,f,22),text(905,y+47,v,28,C.teal,700));});
 p.push(text(35,647,'F/H는 두께기준 C10B2310 조회가 성공해야 폭도 지정됩니다.',23),text(35,689,'구매 CR에서 최종품명 E인 경우에는 소수 1자리 대신 정수 mm로 반올림합니다.',22));
 save('06-intermediate-width.svg',725,'구매 소재별 원자재폭 예제','적정FH -3과 차선FH 유지, 구매CR TM-3, 구매도금재 CGL/EGL-1 및 반올림의 차이.',p);
}
console.log('Generated 6 width-design SVG figures.');
module.exports={C,text,rect,arrow,box,save};
