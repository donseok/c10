// Fixed explanatory cases, deliberately separate from production service execution.
const cases={
chem:[
 ['세 사양 모두 있음','C 보증 0.04 ~ 0.09','고객 0.03~0.10, 규격 0.02~0.12, 사내 0.04~0.09. 하한은 큰 값, 상한은 작은 값입니다.'],
 ['고객·사내행 없음','C 보증 0.02 ~ 0.12','보증 단계에 규격행만 남아 있으면 그 값을 적용합니다. 앞선 사내 조회 실패의 정상 여부와는 별개입니다.'],
 ['상한 0과 0.10 비교','상한 0.10','두 값이 있으면 numCompare는 0을 제외합니다. 엄격한 상한 0으로 해석하지 않습니다.'],
 ['범위 충돌','하한 0.12 > 상한 0.10','고객 0.12~0.18, 규격 0.02~0.10. 편성은 이 결과를 만들며 자동으로 범위를 뒤집지 않습니다.']
],
mech:[
 ['TS 보증 편성 직후','TS 300 ~ 390 MPa','고객 280~400, 규격 270~410, 사내 300~390의 비교 결과입니다. 후속 고객값 수정 전입니다.'],
 ['후속 고객값 수정 실행','TS 280 ~ 400 MPa','해당 상태 처리에서 cs_update가 실행되면 고객행의 non-null TS가 보증행을 덮어씁니다.'],
 ['시편 채취 길이','길이 80 유지','고객 80, 규격 100, 사내 120. 이 항목은 숫자 최대·최소 비교가 아니라 고객 우선입니다.'],
 ['후속 수정에서 고객 상한 0','TS 상한 0 적용','SQL NVL은 0을 null로 취급하지 않습니다. 초기 편성의 numCompare와 다릅니다.']
],
deli:[
 ['두께: 고객 한쪽만 있음','[빈값, +2] 유지','고객 [빈값,+2], 규격 [−2,+3]. 고객 양쪽이 모두 빈 경우에만 규격 쌍을 적용합니다.'],
 ['일반 폭: 고객 쌍 있음','[−3, +4] 유지','E/C/D 외 품명에서 고객 [−3,+4], 규격 [−2,+3]. 더 넓은 고객 공차도 편성 단계에서는 유지합니다.'],
 ['E/C/D 폭: 양쪽 유효값','[−1, +2] → 999 ~ 1,002mm','주문폭 1,000, 고객 [−1,+2], 규격 [−2,+3]. 하한 큰 유효값, 상한 작은 값을 적용합니다.'],
 ['E/C/D 폭: 고객 [0,0]','[−2, 0] → 998 ~ 1,000mm','규격 [−2,+3]. 하한 비교는 0 제외, 상한 Math.min은 0 포함입니다.'],
 ['형상: 고객 직선도 상한 있음','상한 5 유지','고객 5, 규격 3. 형상은 항목별 고객 우선이며 작은 값 비교가 아닙니다.']
]};
const select=document.getElementById('spec-scenario');
cases[guideKind].forEach((c,i)=>{const o=document.createElement('option');o.value=i;o.textContent=c[0];select.append(o);});
function show(){const c=cases[guideKind][Number(select.value)];document.getElementById('spec-result').textContent=c[1];document.getElementById('spec-why').textContent=c[2];}
select.addEventListener('change',show);show();
