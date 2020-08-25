/*
 * ==============================================================================
 * Copyright(c) 2011 UNIONSTEEL
 * @FileName : DbSearchPrdInqChkData.java
 * Change history
 * @LastModifyDate : 2012. 03. 02
 * @LastModifier : 박재영
 * @LastVersion : 1.0
 * 1.0 2012. 03. 02 박재영 최초 생성
 * ==============================================================================
 */
package com.unionsteel.mes.c10.activity.nui;

import java.util.ArrayList;

import com.posdata.glue.PosException;
import com.posdata.glue.biz.activity.PosActivity;
import com.posdata.glue.biz.activity.PosServiceParamIF;
import com.posdata.glue.biz.constants.PosBizControlConstants;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.PosGenericDao;
import com.posdata.glue.dao.vo.PosParameter;
import com.posdata.glue.dao.vo.PosRow;
import com.posdata.glue.dao.vo.PosRowSet;
import com.posdata.glue.master.easyaccess.common.MasterDataException;
import com.posdata.glue.master.easyaccess.easymaster.EasyAccess;
import com.posdata.glue.master.easyaccess.returnType.PosDecisionChecker;
import com.posdata.glue.master.easyaccess.returnType.PosDecisionRuleVO;
import com.posdata.glue.master.easyaccess.returnType.PosRuleVO;
import com.unionsteel.mes.c10.activity.common.DbCommonUtil;
import com.unionsteel.mes.c10.activity.common.constants.C10NuiConstantsIF;

/**
 * 이 Class는 생산가부요청건에 대해 품질설계Key사항,중요 Size 를 편성하는 Class이다.
 * <xmp>
 * 1. 편성정보: 품질설계Key사항
 * - 품잘설계KEY를 Master Data를 Match하여 원자재코드,재질코드를 편집한다.
 * - Master Data 정의명 : C10B1040
 * - 품질설계Key Master Data 조건항목 : 
 *   품명, 규격약호, 주문용도코드, 최종고객사, 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면, 주문두께, 주문폭
 * - 고객사양번호 등록시 우선순위
 * - 필수 Match 조건항목 : 
 *   품명, 규격약호, 주문용도코드, 최종고객사, 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면, 주문두께, 주문폭
 * -> Read Count = 1 이면 품질설계keY Master Data의 원자재코드,재질코드,통과공정번호,제조표준번호,품질메세지,정전메세지를 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 설계Key Match를 에러처리한다.
 * . 에러내용을 편집 "품질설계KEY 에러입니다"
 * . 해당주문요청번호,주문요청행번의 처리를 SKIP하고 "인터페이스테이블 수신처리" 수행한다.
 * - 고객사양번호 미등록시 우선순위 : 선순위 Data가 Match되면 적용하고 Match종료함.고객사양번호는 "**********"
 * - 첫번째 Match 조건 : 품명, 규격약호, 주문용도코드, 최종고객사, 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면, 주문두께, 주문폭
 * - 두번째 Match 조건 : 품명, 규격약호, 주문용도코드, 최종고객사 "******", 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면, 주문두께, 주문폭 
 * - 세번째 Match 조건 : 품명, 규격약호, 주문용도코드 중분류 동일 소분류 5자리 "*", 최종고객사 , 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면, 주문두께, 주문폭 
 * - 네번째 Match 조건 : 품명, 규격약호, 주문용도코드 중분류 동일 소분류 3자리 "***", 최종고객사 , 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면, 주문두께, 주문폭
 * - 다섯번째 Match 조건 : 품명, 규격약호, 주문용도코드 "******", 최종고객사 , 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면, 주문두께, 주문폭
 * - 여섯번째 Match 조건 : 품명, 규격약호, 주문용도코드 중분류 동일 소분류 5자리 "*", 최종고객사 "******", 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면, 주문두께, 주문폭
 * - 여섯번째 Match 조건 : 품명, 규격약호, 주문용도코드 중분류 동일 소분류 3자리 "***", 최종고객사 "******", 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면, 주문두께, 주문폭
 * - 일곱번째 Match 조건 : 품명, 규격약호, 주문용도코드 "******", 최종고객사 "******", 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면, 주문두께, 주문폭
 * - 여덟번째 Match 조건 : 품명, 규격약호, 주문용도코드, 최종고객사, 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면 "*****", 주문두께, 주문폭
 * - 아홉번째 Match 조건 : 품명, 규격약호, 주문용도코드, 최종고객사 "******", 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면 "*****", 주문두께, 주문폭 
 * - 열번째 Match 조건 : 품명, 규격약호, 주문용도코드 중분류 동일 소분류 5자리 "*", 최종고객사 , 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면 "*****", 주문두께, 주문폭 
 * - 열한번째 Match 조건 : 품명, 규격약호, 주문용도코드 중분류 동일 소분류 3자리 "***", 최종고객사 , 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면 "*****", 주문두께, 주문폭
 * - 열두번째 Match 조건 : 품명, 규격약호, 주문용도코드 "******", 최종고객사 , 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면 "*****", 주문두께, 주문폭
 * - 열세번째 Match 조건 : 품명, 규격약호, 주문용도코드 중분류 동일 소분류 5자리 "*", 최종고객사 "******", 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면 "*****", 주문두께, 주문폭
 * - 열네번째 Match 조건 : 품명, 규격약호, 주문용도코드 중분류 동일 소분류 3자리 "***", 최종고객사 "******", 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면 "*****", 주문두께, 주문폭
 * - 열다섯번째 Match 조건 : 품명, 규격약호, 주문용도코드 "******", 최종고객사 "******", 고객 사양번호, EMBOSS무늬, 주문Spangle구분, 주문도금량지정코드, 주문표면처리코드, 색상코드전면 "*****", 주문두께, 주문폭
 * -> 품질설계KEY가 Match된 경우는 품질설계keY Master Data의 원자재코드,재질코드,통과공정번호,제조표준번호,품질메세지,정전메세지를 편집한다.
 * -> 품질설계KEY가 Match된 경우는 이면 설계Key Match를 에러처리한다.
 * . 에러내용을 편집 "생산불가(품질설계KEY 없음)"
 * . 해당 주문요청번호,주문요청행번의 생산가부체크 처리를 SKIP하고 "인터페이스테이블 수신처리" 수행한다.
 * 2. 편성정보: CCL BOM 기준 (컬러제품군인 경우)
 * - Master Data 정의명 : CCL BOM 기준(TB_C10_CCL_BOM)
 * - CCL BOM 기준 Data 조건항목 : CCL_BOM_NO
 * -> Read Count = 1 이면 CCL BOM 기준 Data의 코팅방식, 도막두께, 광택도코드, 수지구분을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 CCL BOM 기준 에러처리한다.
 * . 에러내용을 편집 "CCL BOM 기준 없음"
 * . 해당 주문요청번호,주문요청행번의 생산가부체크 처리를 SKIP하고 "인터페이스테이블 수신처리" 수행한다.
 * 3. 편성정보: SP두께 보정 (알루미늄 칼라,스테인레스 칼라 제품군 제외)
 * - Master Data 정의명 : C10B2070
 * - SP두께 보정률 기준 Data 조건항목 : 품명코드, 재질코드, 주문Spangle, 두께, 폭
 * -> Read Count = 1 이면 SP두께 보정률 기준 Data의 두께보정률을 편집한다.
 * -> 없어도 에러처리 하지 않는다.
 * 4. 편성정보: 도금량 기준 (도금제품군인 경우)
 * - Master Data 정의명 : C10A1061
 * - 도금량 기준 Data 조건항목 : 품명(원판품명), 도금량지정코드
 * -> Read Count = 1 이면 도금량 기준 Data의 도금두께목표를 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 도금량 기준 에러처리한다.
 * . 에러내용을 편집 "생산불가 (도금량기준 없음)" 또는 "생산불가 (도금량기준 중복)"
 * . 해당 주문요청번호,주문요청행번의 생산가부체크 처리를 SKIP하고 "인터페이스테이블 수신처리" 수행한다.
 * 5. 편성정보: 고객사양공통 기준 (고객사양번호가 존재하는 경우)
 * - Master Data 정의명 : C10A1020
 * - 고객사양공통 기준 Data 조건항목 : 고객사양번호
 * -> Read Count = 1 이면 고객사양공통 기준 Data의 고객요청압연두께, 고객요청압연두께단위를 편집한다.
 *    - 편집한 고객요청압연두께가 존재하는 경우 다음과 같이 압연목표두께를 계산한다.
 *      - 고객요청압연두께단위가 "CRN"인 경우
 *        압연목표두께 = 주문두께(주문두께구분이 "3"경우 도막두께,도금두께를 빼준 값) + 고객요청압연두께치 + SP보정계산값
 *      - 고객요청압연두께단위가 "PCN"인 경우
 *        압연목표두께 = 주문두께(주문두께구분이 "3"경우 도막두께,도금두께를 빼준 값) + 고객요청압연두께 보정계산값 + SP보정계산값 
 *      - 고객요청압연두께단위가 "TRK"인 경우
 *        압연목표두께 = 고객요청압연두께 
 * -> 없어도 에러처리 하지 않는다.
 * 6. 편성정보: 압연두께Set치보정기준 (고객사양서번호가 없는 경우 또는 고객요청압연두께가 없는경우)
 * - Master Data 정의명 : C10B2060
 * - 압연두께Set치보정기준 Data 조건항목 : 품명코드, 규격기관, 규격약호, 주문용도코드, 최종고객사,주문두께구분, 두께관리코드, 도금량지정코드, 두께범위, 폭범위
 * -> Read Count = 1 이면 압연두께Set치보정기준 Data의 두께보정치, 두께보정단위를 편집한다.
 *    - 두께보정단위가 "CRN"인 경우
 *      압연목표두께 = 주문두께(주문두께구분이 "2"경우 도금두께를 빼준 값) + 두께보정치 + SP보정계산값
 *    - 두께보정단위가 "PCN"인 경우
 *      압연목표두께 = 주문두께(주문두께구분이 "2"경우 도금두께를 빼준 값) + 두께보정계산치값 + SP보정계산값 
 *    - 두께보정단위가 "TRK"인 경우
 *      압연목표두께 = 두께보정치 + SP보정계산값 
 * -> Read Count = 0 이거나 Read Count > 1 이면 압연두께Set치보정기준 에러처리한다.
 * . 에러내용을 편집 "압연두께Set치보정기준 없음" 또는 "압연두께Set치보정기준 중복"
 * . 해당 주문요청번호,주문요청행번의 생산가부체크 처리를 SKIP하고 "인터페이스테이블 수신처리" 수행한다.
 * 7. 편성된 압연목표두께에 소수점 반올림 및 X-Ray Set를 반영한다. (알미늄 칼라, 스테인레스 칼라인 경우 주문두께를 압연목표두께로 편성한다.)
 * 8. 편성정보: 제품폭여유기준 (알미늄 칼라, 스테인레스 칼라 제외)
 * - Master Data 정의명 : C10A1070
 * - 제품폭여유기준 Data 조건항목 : 폭관리코드
 * -> Read Count = 1 이면 제품폭여유기준 Data의 폭여유치를 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 제품폭여유기준 에러처리한다.
 * . 에러내용을 편집 "폭관리코드별 폭여유치기준 없음" 또는 "폭관리코드별 폭여유치기준 중복"
 * . 해당 주문요청번호,주문요청행번의 생산가부체크 처리를 SKIP하고 "인터페이스테이블 수신처리" 수행한다.
 * 9. 편성정보: 정전폭마진량
 * - Master Data 정의명 : C10B1079
 * - 정전폭마진량 기준 Data 조건항목 : 주문에지구분, 품명코드, 제품형태, 코팅방식, 수지타입
 * -> Read Count = 1 이면 정전폭마진량기준 Data의 마진폭을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 정전폭마진량기준 에러처리한다.
 * . 에러내용을 편집 "Size기준 없음(정전폭마진량)" 또는 "Size기준 중복(정전폭마진량)"
 * . 해당 주문요청번호,주문요청행번의 생산가부체크 처리를 SKIP하고 "인터페이스테이블 수신처리" 수행한다.
 * 10. 편성정보: 정전폭감소량
 * - Master Data 정의명 : C10B1077
 * - 정전폭감소량 기준 Data 조건항목 : 품명코드, 재질코드, 압연목표두께, 폭범위
 * -> Read Count = 1 이면 정전폭감소량기준 Data의 정전폭감소량을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 정전폭감소량기준 에러처리한다.
 * . 에러내용을 편집 "Size기준 없음(정전폭감소량)" 또는 "Size기준 중복(정전폭감소량)"
 * . 해당 주문요청번호,주문요청행번의 생산가부체크 처리를 SKIP하고 "인터페이스테이블 수신처리" 수행한다.
 * 10. 편성정보: CCL폭감소량 (칼라제품군인 경우)
 * - Master Data 정의명 : C10B1078
 * - CCL폭감소량 기준 Data 조건항목 : 품명코드, 재질코드, 압연목표두께, 폭범위
 * -> Read Count = 1 이면 CCL폭감소량기준 Data의 CCL폭감소량을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 CCL폭감소량기준 에러처리한다.
 * . 에러내용을 편집 "Size기준 없음(CCL폭감소량)" 또는 "Size기준 중복(CCL폭감소량)"
 * . 해당 주문요청번호,주문요청행번의 생산가부체크 처리를 SKIP하고 "인터페이스테이블 수신처리" 수행한다.
 * 11. 편성정보: 통과공정삭제기준
 * - Master Data 정의명 : C10B2010
 * - 통과공정삭제기준 Data 조건항목 : 품명코드, BackMarking여부, 주문내경, 주문내경링종류구분, 주문표면처리코드, 도금량지정코드, EMBOSS무늬, 주문포장단중하한값, 주문코일외경, 입측두께범위, 입측폭범위, 수지타입전면, 광택코드전면, 보호필름상세코드, 재질코드, 주문EDGE지정코드
 * -> Read Count = 1 이면 통과공정삭제기준 Data의 삭제공정을 편집한다.
 * -> 에러처리하지 않는다.
 * - PLTCM목표목표폭을 설계한다.
 * - 주문폭,주문두께,주문EDGE,폭공차로 제품목표폭을 계산한다.
 * - 주문폭공차,규격폭공차,폭관리코드로 폭공차를 편집한다
 * 12. 편성정보: 통과공정기준 (알미늄 칼라, 스테인레스 칼라 제외)
 * - Master Data 정의명 : C10A1054
 * - 통과공정기준 Data 조건항목 : 통과공정번호
 * -> Read Count = 1 이면 통과공정기준 Data의 도금(CGL/EGL)공정코드를 편집한다.
 * -> Read Count = 0 이면 통과공정기준 에러처리한다.
 * . 에러내용을 편집 "통과공정기준 없음"
 * . 해당 주문요청번호,주문요청행번의 생산가부체크 처리를 SKIP하고 "인터페이스테이블 수신처리" 수행한다.
 * 13. 편성정보: CGL폭감소량 (용융도금제품군인 경우)
 * - Master Data 정의명 : C10B1075
 * - CGL폭감소량 기준 Data 조건항목 : 품명코드, 재질코드, 압연목표두께, 폭범위
 * -> Read Count = 1 이면 CGL폭감소량 기준 Data의 CGL폭감소량을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 CGL폭감소량 기준 에러처리한다.
 * . 에러내용을 편집 "Size기준 없음(CGL폭감소량)" 또는 "Size기준 중복(CGL폭감소량)"
 * . 해당 주문요청번호,주문요청행번의 생산가부체크 처리를 SKIP하고 "인터페이스테이블 수신처리" 수행한다.
 * 14. 편성정보: 중간재적용기준 (전기도금제품군인 경우)
 * - Master Data 정의명 : C10B2230
 * - 중간재적용기준 Data 조건항목 : 품명코드, 주문두께, 주문폭범위
 * -> Read Count = 1 이면 중간재적용기준 Data의 EGL공정코드을 편집한다.
 * -> 없어도 에러처리 하지 않는다.
 * 15. 편성정보: EGL폭감소량 (전기도금제품군인 경우)
 * - Master Data 정의명 : C10B1076
 * - EGL폭감소량 기준 Data 조건항목 : 품명코드, 재질코드, 압연목표두께, 폭범위
 * -> Read Count = 1 이면 EGL폭감소량 기준 Data의 EGL폭감소량을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 EGL폭감소량 기준 에러처리한다.
 * . 에러내용을 편집 "Size기준 없음(EGL폭감소량)" 또는 "Size기준 중복(EGL폭감소량)"
 * . 해당 주문요청번호,주문요청행번의 생산가부체크 처리를 SKIP하고 "인터페이스테이블 수신처리" 수행한다.
 * 16. 편성정보: PLTCM 출측폭
 *   PLTCM 출측폭 = 주문폭 + 정전폭감소량 + CCL폭감소량(칼라제품) + CGL/EGL폭감소량(도금제품) + 정전폭마진량 + 제품폭여유치;
 * 17. 편성정보: 원자재두께기준 (알미늄칼라, 스테인레스 칼라 제외)
 * - Master Data 정의명 : C10B1071
 * - 원자재두께 기준 Data 조건항목 : 원자재코드, 압연목표두께, PLTCM폭
 * -> Read Count = 1 이면 원자재두께 기준 Data의 원자재목표두께을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 원자재두께 기준 에러처리한다.
 * . 에러내용을 편집 "Size기준 없음(원자재두께)" 또는 "Size기준 중복(원자재두께)"
 * . 해당 주문요청번호,주문요청행번의 생산가부체크 처리를 SKIP하고 "인터페이스테이블 수신처리" 수행한다.
 * 18. 편성정보: PLTCM폭수축량 (알미늄칼라, 스테인레스 칼라 제외)
 * - Master Data 정의명 : C10B1074
 * - PLTCM폭수축량 기준 Data 조건항목 : 원자재코드, 압연목표두께, PLTCM폭
 * -> Read Count = 1 이면 PLTCM폭수축량 기준 Data의 PLTCM폭수축량을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 PLTCM폭수축량 기준 에러처리한다.
 * . 에러내용을 편집 "Size기준 없음(PLTCM폭수축량)" 또는 "Size기준 중복(PLTCM폭수축량)"
 * . 해당 주문요청번호,주문요청행번의 생산가부체크 처리를 SKIP하고 "인터페이스테이블 수신처리" 수행한다.
 * 19. 편성정보: PLTCM폭마진량 (알미늄칼라, 스테인레스 칼라 제외)
 * - Master Data 정의명 : C10B1073
 * - PLTCM폭마진량 기준 Data 조건항목 : 원자재코드, 원자재두께, PLTCM폭
 * -> Read Count = 1 이면 PLTCM폭마진량 기준 Data의 PLTCM폭마진량을 편집한다.
 * -> Read Count = 0 이거나 Read Count > 1 이면 PLTCM폭마진량 기준 에러처리한다.
 * . 에러내용을 편집 "Size기준 없음(PLTCM폭마진량)" 또는 "Size기준 중복(PLTCM폭마진량)"
 * . 해당 주문요청번호,주문요청행번의 생산가부체크 처리를 SKIP하고 "인터페이스테이블 수신처리" 수행한다.
 * 20. 편성정보: 원자재목표폭
 * - 주문Edge가 'S' 또는 'M'
 *   원자재목표폭 = PLTCM목표폭 + PLTCM폭수축량 + PLTCM폭여유량
 * - 주문Edge가 'C'
 *   원자재목표폭 = PLTCM목표폭
 * - 주문Edge가 'N'
 *   원자재목표폭 = 주문폭 + CGL/EGL폭수축량
 * 21. 편성한 결과는 PosContext에 등록
 * 22. 정보가 존재하는 경우 transition='success', 아니면 'failure'로 Set
 * 사용 방법
 * <activity name="SEARCH_MD" class="com.unionsteel.mes.c10.activity.nui.DbSearchPrdInqchkData">
 * <transition name="success" value="SUBSERVICE1" />
 * <transition name="failure" value="ERROR_LOG" />
 * <property name="dao" value="m00dao" />
 * <property name="bind-result" value="RK_MAIN" />
 * </activity>
 * Property 설정
 * dao : applicationContext.xml의 DAO id
 * bind-result : 이전에 ctx에 저장된 result
 * </xmp>
 * 
 * @author 박재영
 * @see PosActivity
 * @version 1.0
 */

public class DbSearchPrdInqchkData extends PosActivity implements C10NuiConstantsIF
{

    /**
     * <p>
     * 이 메소드는 PosActivity에서 선언된 abstract Method에 대한 실질적인 구현부이다.
     * </p>
     * 
     * @throws PosException IO Exception 발생 시
     * @param ctx Service내의 Data를 관리하는 PosContext 객체
     * @return success - 성공적으로 끝났을 때 Route transition.
     *         nullpointer - NullPointerException 발생 시 Route transtion.
     *         faillue - 그 외 Exception 발생 시 Route transition.
     */

    public String runActivity( PosContext ctx )
    {
        PosGenericDao dao = this.getDao( this.getProperty( PosServiceParamIF.DAO ) );
        PosParameter param = new PosParameter(); // MD View param
        PosRowSet rowset = null;
        PosRow row = null;
        PosDecisionChecker checker = null;
        PosRuleVO result = null;

        String colValue[] = null; // 컬럼값
        boolean fnl_cus = false;

        String prd_nm_cd = C10STR_SPACE;
        String prd_shp = C10STR_SPACE;
        String spc_avr = C10STR_SPACE;
        String ord_usg_cd = C10STR_SPACE;
        String fnl_cus_cd = C10STR_SPACE;
        String cus_bth_pap_no = C10STR_SPACE;
        double ord_exc_thk = 0;
        double ord_exc_wth = 0;
        double ord_exc_lth = 0;
        String ord_thk_mng_cd = C10STR_SPACE;
        String ord_wth_mng_cd = C10STR_SPACE;
//        double wth_tln_llv = 0;
//        double wth_tln_ulv = 0;
        double wth_trv = 0;
        double pltcm_wth_trv = 0;
        String ord_edg_asg_tp = C10STR_SPACE;
        String gw_asg_cd = C10STR_SPACE;
        double gal_thk_trv = 0;
        double col_wth_mgn = 0;
        double col_wth_shr = 0;
        double ord_slit_grp_cnt = 0;
        double ord_mix_wth1 = 0;
        // 2016.08.17 SNW 추가 (폭계산 용) begin
        double ord_mix_wth2 = 0; 
        double ord_mix_wth3 = 0;
        double ord_mix_wth4 = 0;
        double ord_mix_wth5 = 0;
        double ord_mix_wth6 = 0;
        double ord_mix_wth7 = 0;
        double ord_mix_wth8 = 0;
        double ord_mix_wth9 = 0;
        double ord_mix_wth10 = 0;
        // 2016.08.17 SNW 추가 (폭계산 용) end
        double ccl_wth_shr = 0;
        String cgl_proc_cd = C10STR_SPACE;
        String egl_proc_cd = C10STR_SPACE;
        double gal_wth_shr = 0;
        double tcm_wth_shr_qty = 0;
        double mrg_wth = 0;
        double mng_mrg_wth = 0;
        String embs_cd = C10STR_SPACE;
        String ord_thk_tp = C10STR_SPACE;
        String ord_spnl_tp = C10STR_SPACE;
        double exc_wth = 0;
        double crm_thk = 0;
        double sp_thk = 0;
        String ord_coil_idia = C10STR_SPACE;
        String ord_slv_knd_tp = C10STR_SPACE;
        String ord_sur_hnd_cd = C10STR_SPACE;
        String ord_pak_unt_wgt_llv = C10STR_SPACE;
        String ord_coil_odia = C10STR_SPACE;
        String ccl_bom_no = C10STR_SPACE;
        String lus_rt_cd_frn = C10STR_SPACE;
        String rsn_tp_frn = C10STR_SPACE;
        String ptt_flm_dtl_cd = C10STR_SPACE;
        String cot_mth = C10STR_SPACE;
        String clr_cd = C10STR_SPACE;
        String rmtl_cd = " ";
        String rmtl_cd1 = " ";
        String rmtl_cd2 = " ";
        double pnt_flm_thk_frn_tot = 0;
        double pnt_flm_thk_bak_tot = 0;
        String IF_GRP_ID_REQ = C10STR_SPACE;
        String ord_coilg_mth = C10STR_SPACE;
        //String PAS_PROC_CD = C10STR_SPACE;
        
        // 생산가부I/F 변경
        // EAI Call방식 => OMS에서 직접call
        // 생산가부수신IF_GRP_ID를 가부결과에 넣어주기위해 _REQ항목 Set
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_IF_GRP_ID ) ) )
        	IF_GRP_ID_REQ = (String) ctx.get( COL_IF_GRP_ID );
        ctx.put( COL_IF_GRP_ID_REQ, IF_GRP_ID_REQ );
        logger.logDebug( "if_grp_id_req  : " + IF_GRP_ID_REQ );    
        
        if ( !DbCommonUtil.isNull( ctx.get( COL_XMSGS ) ) )  //주문항목 에러체크시 에러발생하면 빠져버림
        {
            ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
            ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
            ctx.put( COL_ORD_ERR_TXT, ctx.get( COL_XMSGS ) );
            ctx.put( COL_ERR_YN, C10STR_YES );
            logger.logError( ctx.get( COL_XMSGS ).toString() );
           
            return PosBizControlConstants.SUCCESS;
        }
        
        if ( !DbCommonUtil.isNull( ctx.get( COL_PRD_NM_CD ) ) )
            prd_nm_cd = ctx.get( COL_PRD_NM_CD ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_PRD_SHP ) ) )
            prd_shp = ctx.get( COL_PRD_SHP ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_SPC_AVR ) ) )
            spc_avr = ctx.get( COL_SPC_AVR ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_THK ) ) )
            ord_exc_thk = Double.parseDouble( ctx.get( COL_ORD_EXC_THK ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_WTH ) ) )
            ord_exc_wth = Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_WTH ) ) )
            ord_exc_lth = Double.parseDouble( ctx.get( COL_ORD_EXC_LTH ).toString() );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_CUS_BTH_PAP_NO ) ) )
            cus_bth_pap_no = (String) ctx.get( COL_CUS_BTH_PAP_NO );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_USG_CD ) ) )
            ord_usg_cd = (String) ctx.get( COL_ORD_USG_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_FNL_CUS_CD ) ) )
            fnl_cus_cd = (String) ctx.get( COL_FNL_CUS_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_THK_MNG_CD ) ) )
            ord_thk_mng_cd = (String) ctx.get( COL_ORD_THK_MNG_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_WTH_MNG_CD ) ) )
            ord_wth_mng_cd = (String) ctx.get( COL_ORD_WTH_MNG_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_EDG_ASG_TP ) ) )
            ord_edg_asg_tp = (String) ctx.get( COL_ORD_EDG_ASG_TP );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_GW_ASG_CD ) ) )
            gw_asg_cd = (String) ctx.get( COL_GW_ASG_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_SLIT_GRP_CNT ) ) )
            ord_slit_grp_cnt = Double.parseDouble( ctx.get( COL_ORD_SLIT_GRP_CNT ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH1 ) ) )
            ord_mix_wth1 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH1 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH2 ) ) )
            ord_mix_wth2 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH2 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH3 ) ) )
            ord_mix_wth3 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH3 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH4 ) ) )
            ord_mix_wth4 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH4 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH5 ) ) )
            ord_mix_wth5 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH5 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH6 ) ) )
            ord_mix_wth6 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH6 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH7 ) ) )
            ord_mix_wth7 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH7 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH8 ) ) )
            ord_mix_wth8 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH8 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH9 ) ) )
            ord_mix_wth9 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH9 ).toString() );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_MIX_WTH10 ) ) )
            ord_mix_wth10 = Double.parseDouble( ctx.get( COL_ORD_MIX_WTH10 ).toString() );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_EMBS_CD ) ) )
            embs_cd = (String) ctx.get( COL_EMBS_CD );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_THK_TP ) ) )
            ord_thk_tp = (String) ctx.get( COL_ORD_THK_TP );
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_SPNL_TP ) ) )
            ord_spnl_tp = (String) ctx.get( COL_ORD_SPNL_TP );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_COIL_IDIA ) ) )
            ord_coil_idia = ctx.get( COL_ORD_COIL_IDIA ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_SLV_KND_TP ) ) )
            ord_slv_knd_tp = (String) ctx.get( COL_ORD_SLV_KND_TP );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_SUR_HND_CD ) ) )
            ord_sur_hnd_cd = (String) ctx.get( COL_ORD_SUR_HND_CD );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_PAK_UNT_WGT_LLV ) ) )
            ord_pak_unt_wgt_llv = ctx.get( COL_ORD_PAK_UNT_WGT_LLV ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_COIL_ODIA ) ) )
            ord_coil_odia = ctx.get( COL_ORD_COIL_ODIA ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_CCL_BOM_NO ) ) )
            ccl_bom_no = ctx.get( COL_CCL_BOM_NO ).toString();
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_PTT_FLM_CD ) ) )
            ptt_flm_dtl_cd = ctx.get( COL_ORD_PTT_FLM_CD ).toString();
        if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_COILG_MTH ) ) )
        	ord_coilg_mth = (String) ctx.get( COL_ORD_COILG_MTH );
        if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_EXC_WTH ) ) )
        {
            //if ( ord_slit_grp_cnt > 0 && 
            //        Double.compare( 
            //                Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) , 
            //                ord_mix_wth1) == 0 )
            //    exc_wth = 
            //    Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) * ord_slit_grp_cnt;
            //else if ( ord_slit_grp_cnt > 0 && 
            //        Double.compare( 
            //                Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ), 
            //                ord_mix_wth1) != 0 )
            //    exc_wth = Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() );
            //else
            //    exc_wth = Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() );
            if ( ord_slit_grp_cnt > 0 ){
            	exc_wth = ord_mix_wth1 + ord_mix_wth2 + ord_mix_wth3 + ord_mix_wth4 + ord_mix_wth5 + 
            			     ord_mix_wth6 + ord_mix_wth7 + ord_mix_wth8 + ord_mix_wth9 + ord_mix_wth10;
            }else
            	exc_wth = Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() );
        }
 
        //고객사양번호가 Null이면 "*' Set 
        if ( cus_bth_pap_no.equals( C10STR_SPACE ) ){
            cus_bth_pap_no = DbCommonUtil.setAstar( 10 );

            if(ccl_bom_no.length() > 4)
                clr_cd = ccl_bom_no.substring( 0, 5 );
            else clr_cd = DbCommonUtil.setAstar( 5 );
        }else{
            if(ccl_bom_no.length() > 4)
                clr_cd = ccl_bom_no.substring( 0, 5 );            
        }

        while ( true )
        {
            // 로깅시작
            logger.logDebug( "=== 설계Key 기준 ===" );
            logger.logDebug( "조건값 - 품명                : " + prd_nm_cd );
            logger.logDebug( "조건값 - 제품형태            : " + prd_shp );
            logger.logDebug( "조건값 - 규격약호            : " + spc_avr );
            logger.logDebug( "조건값 - 주문용도코드        : " + ord_usg_cd );
            logger.logDebug( "조건값 - 최종고객사          : " + fnl_cus_cd );
            logger.logDebug( "조건값 - 고객 사양번호       : " + cus_bth_pap_no );
            logger.logDebug( "조건값 - EMBOSS무늬         : " + embs_cd );
            logger.logDebug( "조건값 - 주문Spangle구분    : " + ord_spnl_tp );
            logger.logDebug( "조건값 - 주문도금량지정코드  : " + gw_asg_cd );
            logger.logDebug( "조건값 - 주문표면처리코드    : " + ord_sur_hnd_cd );
            logger.logDebug( "조건값 - CCLBOM번호(1~5)   : " + clr_cd );
            logger.logDebug( "조건값 - 주문두께            : " + ord_exc_thk );
            logger.logDebug( "조건값 - 주문폭(폭조합인경우 합)  : " + exc_wth );
            // 로깅종료

            colValue = new String[13];
            colValue[0] = prd_nm_cd;
            colValue[1] = prd_shp;
            colValue[2] = spc_avr;
            colValue[3] = ord_usg_cd;
            colValue[4] = fnl_cus_cd;
            colValue[5] = cus_bth_pap_no;
            colValue[6] = embs_cd;
            colValue[7] = ord_spnl_tp;
            colValue[8] = gw_asg_cd;
            colValue[9] = ord_sur_hnd_cd;
            colValue[10] = clr_cd;
            colValue[11] = Double.toString( ord_exc_thk );
            colValue[12] = Double.toString( exc_wth );
            
            logger.logDebug( "=== 이돈석 확인 ===" );
            logger.logDebug( "조건값 - 품명                : " + colValue[0] );
            logger.logDebug( "조건값 - 제품형태            : " + colValue[1] );
            logger.logDebug( "조건값 - 규격약호            : " + colValue[2] );
            logger.logDebug( "조건값 - 주문용도코드        : " + colValue[3] );
            logger.logDebug( "조건값 - 최종고객사          : " + colValue[4] );
            logger.logDebug( "조건값 - 고객 사양번호       : " + colValue[5] );
            logger.logDebug( "조건값 - EMBOSS무늬         : " + colValue[6] );
            logger.logDebug( "조건값 - 주문Spangle구분    : " + colValue[7] );
            logger.logDebug( "조건값 - 주문도금량지정코드  : " + colValue[8] );
            logger.logDebug( "조건값 - 주문표면처리코드    : " + colValue[9] );
            logger.logDebug( "조건값 - CCLBOM번호(1~5)   : " + colValue[10] );
            logger.logDebug( "조건값 - 주문두께            : " + colValue[11] );
            logger.logDebug( "조건값 - 주문폭              : " + colValue[12] );

            try
            {
                checker = EasyAccess.getPosDecisionChecker( C10B1040, null );
                //result = null;
                // 결과값 잘 가져오는지 확인
                result = checker.getPosRule( colValue );
                logger.logError("catch go");
            } catch ( MasterDataException e )
            {
            	logger.logError("result");
            	result = null;
            }

            if ( result == null )
            {
                // 결과값이 null
            	logger.logError("result : " + result);
                if ( cus_bth_pap_no.endsWith( C10STR_STAR ) )
                {
                    // 고객사양번호가 미지정
                	logger.logError("11");
                    if( clr_cd.endsWith(C10STR_STAR) )
                    {
                        // 색상코드 "*****"
                    	logger.logError("22");
                        if ( fnl_cus_cd.endsWith( C10STR_STAR ) )
                        {
                            // 고객사코드 "******"
                        	logger.logError("33");
                            if ( ord_usg_cd.equals( DbCommonUtil.setAstar( 6 ) ) )
                            {
                                // 주문용도코드 "******"
                            	logger.logError("44");
                                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I01 );
                                ctx.put( COL_XMSGS, ERRMSG_I01 );
                                ctx.put( COL_ERR_YN, C10STR_YES );
                                logger.logError( ERRMSG_I01 );
                                logger.logError("1");
                                return PosBizControlConstants.SUCCESS;
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                    DbCommonUtil.setAstar( 5 ) ) )
                            {
                                // 주문용도코드 "X*****"
                                ord_usg_cd = DbCommonUtil.setAstar( 6 );
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 3 ) + 
                                    DbCommonUtil.setAstar( 3 ) ) )
                            {
                                // 주문용도코드 "XXX***"
                                ord_usg_cd = ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                        DbCommonUtil.setAstar( 5 );
                            }
                            else
                            {
                                // 주문용도코드 값에  "*"가 없음
                                if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
                                    ord_usg_cd = 
                                    ctx.get( COL_ORD_USG_CD ).toString().substring( 0, 
                                            ctx.get( COL_ORD_USG_CD ).toString().length() - 3 ) + 
                                            DbCommonUtil.setAstar( 3 );
                                else
                                    ord_usg_cd = C10STR_SPACE1 + C10STR_SPACE2 + 
                                    DbCommonUtil.setAstar( 3 );                                    
   
                            }   
                        } else
                        {
                            // 고객사코드 "******" 가 아님
                            if ( ord_usg_cd.equals( DbCommonUtil.setAstar( 6 ) ) )
                            {
                                // 주문용도코드 "******"
                                fnl_cus_cd = DbCommonUtil.setAstar( 6 );
                                if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
                                    ord_usg_cd = 
                                    ctx.get( COL_ORD_USG_CD ).toString();
                                else
                                    ord_usg_cd = C10STR_SPACE;
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                    DbCommonUtil.setAstar( 5 ) ) )
                            {
                                // 주문용도코드 "X*****"
                                ord_usg_cd = DbCommonUtil.setAstar( 6 );
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 3 ) + 
                                    DbCommonUtil.setAstar( 3 ) ) )
                            {
                                // 주문용도코드 "XXX***"
                                ord_usg_cd = ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                        DbCommonUtil.setAstar( 5 );
                            }
                            else
                            {
                                // 주문용도코드 값에  "*"가 없음
                                if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
                                    ord_usg_cd = 
                                    ctx.get( COL_ORD_USG_CD ).toString().substring( 0, 
                                            ctx.get( COL_ORD_USG_CD ).toString().length() - 3 ) + 
                                            DbCommonUtil.setAstar( 3 );
                                else
                                    ord_usg_cd = C10STR_SPACE1 + C10STR_SPACE2 + 
                                    DbCommonUtil.setAstar( 3 );                                    
                            }
                        }
                    }
                    else // 색상코드 "*****"가 아님
                    {    
                        
                        if ( fnl_cus_cd.endsWith( C10STR_STAR ) )
                        {
                            // 고객사코드 "******"
                            if ( ord_usg_cd.equals( DbCommonUtil.setAstar( 6 ) ) )
                            {
                                // 주문용도코드 "******"
                                clr_cd = DbCommonUtil.setAstar( 5 );
                                if ( !DbCommonUtil.isNull( (String) ctx.get( COL_ORD_USG_CD ) ) )
                                    ord_usg_cd = (String) ctx.get( COL_ORD_USG_CD );
                                else ord_usg_cd = C10STR_SPACE;
                                if ( !DbCommonUtil.isNull( (String) ctx.get( COL_FNL_CUS_CD ) ) )
                                    fnl_cus_cd = (String) ctx.get( COL_FNL_CUS_CD );
                                else fnl_cus_cd = C10STR_SPACE;
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                    DbCommonUtil.setAstar( 5 ) ) )
                            {
                                // 주문용도코드 "X*****"
                                ord_usg_cd = DbCommonUtil.setAstar( 6 );
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 3 ) + 
                                    DbCommonUtil.setAstar( 3 ) ) )
                            {
                                // 주문용도코드 "XXX***"
                                ord_usg_cd = ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                        DbCommonUtil.setAstar( 5 );
                            }    
                            else
                            {
                                // 주문용도코드 값에  "*"가 없음
                                if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
                                    ord_usg_cd = 
                                    ctx.get( COL_ORD_USG_CD ).toString().substring( 0, 
                                            ctx.get( COL_ORD_USG_CD ).toString().length() - 3 ) + 
                                            DbCommonUtil.setAstar( 3 );
                                else
                                    ord_usg_cd = C10STR_SPACE1 + C10STR_SPACE2 + 
                                    DbCommonUtil.setAstar( 3 );                                    
   
                            }   
                        } else  //고객사코드가 "*"가 아닌경우
                        {
                            if ( ord_usg_cd.equals( DbCommonUtil.setAstar( 6 ) ) )
                            {
                                fnl_cus_cd = DbCommonUtil.setAstar( 6 );
                                if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
                                    ord_usg_cd = 
                                    ctx.get( COL_ORD_USG_CD ).toString();
                                else
                                    ord_usg_cd = C10STR_SPACE;
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                    DbCommonUtil.setAstar( 5 ) ) )
                            {
                                // 주문용도코드 "X*****"
                                ord_usg_cd = DbCommonUtil.setAstar( 6 );
                            } else if ( ord_usg_cd.equals( 
                                    ord_usg_cd.substring( 0, ord_usg_cd.length() - 3 ) + 
                                    DbCommonUtil.setAstar( 3 ) ) )
                            {
                                // 주문용도코드 "XXX***"
                                ord_usg_cd = ord_usg_cd.substring( 0, ord_usg_cd.length() - 5 ) + 
                                        DbCommonUtil.setAstar( 5 );
                            }
                            else
                            {
                                if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_USG_CD ) ) )
                                    ord_usg_cd = 
                                    ctx.get( COL_ORD_USG_CD ).toString().substring( 0, 
                                            ctx.get( COL_ORD_USG_CD ).toString().length() - 3 ) + 
                                            DbCommonUtil.setAstar( 3 );
                                else
                                    ord_usg_cd = C10STR_SPACE1 + C10STR_SPACE2 + 
                                    DbCommonUtil.setAstar( 3 );                                    
                            }
                        }
                    }
                } else
                {
                    // 고객사양번호가 지정이고 결과값이 없으면 error
                    ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                    ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                    ctx.put( COL_XMSGS, ERRMSG_I01 );
                    ctx.put( COL_ORD_ERR_TXT, ERRMSG_I01 );
                    ctx.put( COL_ERR_YN, C10STR_YES );
                    logger.logError( ERRMSG_I01 );
                    logger.logError("2");
                    return PosBizControlConstants.SUCCESS;
                }
            } else
            {
                if ( result.getRecordCount() > 1 )
                {
                    ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                    ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                    ctx.put( COL_XMSGS, ERRMSG_I01 );
                    ctx.put( COL_ORD_ERR_TXT, ERRMSG_I01 );
                    ctx.put( COL_ERR_YN, C10STR_YES );
                    logger.logError( ERRMSG_I01 );
                    logger.logError("3");
                    return PosBizControlConstants.SUCCESS;
                } else
                {
                    ctx.put( COL_MQL_CD, result.getRuleValueAt( COL_MQL_CD ) );
                    ctx.put( COL_RMTL_CD, result.getRuleValueAt( COL_RMTL_CD1 ) );
                    ctx.put( COL_RMTL_CD1, result.getRuleValueAt( COL_RMTL_CD2 ) );
                    ctx.put( COL_CRM_MNF_STD_NO1, result.getRuleValueAt( COL_CRM_MNF_STD_NO2 ) );
                    ctx.put( COL_QLT_MSG_NM1, result.getRuleValueAt( COL_QLT_MSG_NM2 ) );
                    ctx.put( COL_RMTL_CD2, result.getRuleValueAt( COL_RMTL_CD3 ) );
                    ctx.put( COL_CRM_MNF_STD_NO2, result.getRuleValueAt( COL_CRM_MNF_STD_NO3 ) );
                    ctx.put( COL_QLT_MSG_NM2, result.getRuleValueAt( COL_QLT_MSG_NM3 ) );
                    ctx.put( COL_CRM_MNF_STD_NO, result.getRuleValueAt( COL_CRM_MNF_STD_NO1 ) );
                    ctx.put( COL_PAS_PROC_NO, result.getRuleValueAt( COL_PAS_PROC_NO ) );
                    ctx.put( COL_QLT_DSN_CFM_TP, result.getRuleValueAt( COL_QLT_DSN_CFM_TP ) );
                    ctx.put( COL_QLT_MSG_NM, result.getRuleValueAt( COL_QLT_MSG_NM1 ) );
                    ctx.put( COL_QLT_MSG_NM_COR, result.getRuleValueAt( COL_QLT_MSG_NM_COR ) );
                    ctx.put( COL_APR_INP_BAS_CD, result.getRuleValueAt( COL_APR_INP_BAS_CD ) );
                    
                    if ( !DbCommonUtil.isNull( result.getRuleValueAt( COL_RMTL_CD1 ).toString() ) )
                    	rmtl_cd = result.getRuleValueAt( COL_RMTL_CD1 ).toString();
                    if ( !DbCommonUtil.isNull( result.getRuleValueAt( COL_RMTL_CD2 ).toString() ) )
                        rmtl_cd1 = result.getRuleValueAt( COL_RMTL_CD2 ).toString();
                    if ( !DbCommonUtil.isNull( result.getRuleValueAt( COL_RMTL_CD3 ).toString() ) )
                        rmtl_cd2 = result.getRuleValueAt( COL_RMTL_CD3 ).toString();
                    logger.logDebug( "rmtl_cd - 적정               : " + rmtl_cd.toString());
                    logger.logDebug( "rmtl_cd - 적정               : " + rmtl_cd.toString().substring(0, 1));
                    logger.logDebug( "rmtl_cd1 - 차선1            : " + rmtl_cd1.toString());
                    logger.logDebug( "rmtl_cd1 - 차선1            : " + rmtl_cd1.toString().substring(0, 1));
                    logger.logDebug( "rmtl_cd2 - 차선2            : " + rmtl_cd2.toString());
                    logger.logDebug( "rmtl_cd2 - 차선2            : " + rmtl_cd2.toString().substring(0, 1));
                    
                    if ( (!rmtl_cd.toString().substring(0, 1).equals("H") && !rmtl_cd.toString().substring(0, 1).equals("M")) && 
                    	 (rmtl_cd1.toString().substring(0, 1).equals("H") || rmtl_cd1.toString().substring(0, 1).equals("M") || 
                    	   rmtl_cd2.toString().substring(0, 1).equals("H") || rmtl_cd2.toString().substring(0, 1).equals("M")) ) { //구매반제품 적정, H/C 차선 등록 시 오류
                            ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                            ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                            ctx.put( COL_XMSGS, ERRMSG_I38 );
                            ctx.put( COL_ORD_ERR_TXT, ERRMSG_I38 );
                            ctx.put( COL_ERR_YN, C10STR_YES );
                            logger.logError( ERRMSG_I38 );
                            logger.logError("3");
                            return PosBizControlConstants.SUCCESS;                    	
                    }
                    
                    break;
                }
            }
        }        
        //CCL BOM 기준
        if( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_1 ) 
                || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_2 ) 
                || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_3 )
                || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_4 )
                || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_5 )
                || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_6 )
                || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_7 )
                || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_8 )
                || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_9 ) )
        {
            param = new PosParameter(); // MD View param
            param.setWhereClauseParameter( 0, ccl_bom_no );
    
            try
            {
                // 결과값 잘 가져오는지 확인
                rowset = dao.find( SELECT_CCL_BOM, param ); // CCL-BOM 기준select
            } catch ( Exception e )
            {
                rowset = null;
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, e.getMessage() );
                ctx.put( COL_ORD_ERR_TXT, e.getMessage() );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.SUCCESS;
            }
    
            if ( rowset.count() == 1 )
            {
                row = rowset.next();
                //코팅방식
                cot_mth = DbCommonUtil.valueOf( row.getAttribute( COL_COT_MTH ) );
                //도막두께전면Total
                pnt_flm_thk_frn_tot = Double.parseDouble( 
                        DbCommonUtil.valueOf( row.getAttribute( COL_PNT_FLM_THK_FRN_TOT ) ) );
              //도막두께후면Total
                pnt_flm_thk_bak_tot = Double.parseDouble(
                        DbCommonUtil.valueOf( row.getAttribute( COL_PNT_FLM_THK_BAK_TOT ) ) );
              //광택도코드전면
                if ( !DbCommonUtil.isNull( row.getAttribute( COL_LUS_RT_CD_FRN ) ) )
                    lus_rt_cd_frn = DbCommonUtil.valueOf( row.getAttribute( COL_LUS_RT_CD_FRN ) );
              //수지구분전면Total
                if ( !DbCommonUtil.isNull( row.getAttribute( COL_RSN_TP_FRN ) ) )
                    rsn_tp_frn = DbCommonUtil.valueOf( row.getAttribute( COL_RSN_TP_FRN ) );
            } else if ( rowset.count() > 1 )
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I33 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I33 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I33 );
                return PosBizControlConstants.SUCCESS;
            } else
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I32 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I32 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I32 );
                return PosBizControlConstants.SUCCESS;
            }
        }
        
        if ( !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_5 ) && 
                !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_7 ) ) // &&
               // !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_8 ) )
        {

            // SP보정율 기준
            colValue = new String[5];
            colValue[0] = prd_nm_cd;
            colValue[1] = ctx.get( COL_MQL_CD ).toString();
            colValue[2] = ord_spnl_tp;
            colValue[3] = Double.toString( ord_exc_thk );
            //colValue[4] = Double.toString( ord_exc_wth );
            colValue[4] = Double.toString( exc_wth );
    
            try
            {
                // 결과값 잘 가져오는지 확인
                PosDecisionRuleVO result2 = EasyAccess.getPosDecisionRuleLov( C10B2070, colValue, null );
                result2.next();
                sp_thk = Double.parseDouble( result2.getRuleValueAt( COL_THK_CPS_RT ) );
    
            } catch ( MasterDataException e )
            {
                logger.logError( "SP보정율 기준 " + e.getMessage() );
            }
            
            //도금량 기준
            if (    ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_G ) || 
            		ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_K ) ||
                    ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_J ) || 
                    ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_L ) || 
                    ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_V ) || 
                    ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_W ) || 
                    ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_E ) ||
                    ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_N ) ||
                    ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_2 ) || 
                    ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_3 ) || 
                    ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_4 ) || 
                    ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_6 ) ||
                    ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_8 ) ||
                    ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_9 ) )
            {
                param = new PosParameter(); // MD View param
                if( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_G ) || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_3 ) ){
                    param.setWhereClauseParameter( 0, PRD_NM_CD_G );
                }else if( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_K)){
                	param.setWhereClauseParameter( 0, PRD_NM_CD_K );
                }else if( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_J ) ){
                    param.setWhereClauseParameter( 0, PRD_NM_CD_J );
                }else if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_L ) || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_4 ) ){
                    param.setWhereClauseParameter( 0, PRD_NM_CD_L );
                }else if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_V ) || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_6 ) ){
                    param.setWhereClauseParameter( 0, PRD_NM_CD_V );
                }else if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_W ) || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_9 ) ){
                    param.setWhereClauseParameter( 0, PRD_NM_CD_W );
                }else if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_E ) || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_2 ) ){
                    param.setWhereClauseParameter( 0, PRD_NM_CD_E );
                }else if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_N ) || ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_8 ) ){
                	param.setWhereClauseParameter( 0, PRD_NM_CD_N );
                }
    
                param.setWhereClauseParameter( 1, gw_asg_cd );
                try
                {
                    // 결과값 잘 가져오는지 확인
                    rowset = dao.find( VI_M00_C10A1061, param ); // 도금량View.select
                } catch ( MasterDataException e )
                {
                    rowset = null;
                    ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                    ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                    ctx.put( COL_XMSGS, e.getMessage() );
                    ctx.put( COL_ORD_ERR_TXT, e.getMessage() );
                    ctx.put( COL_ERR_YN, C10STR_YES );
                    logger.logError( e.getMessage() );
                    return PosBizControlConstants.SUCCESS;
                }
    
                if ( rowset.count() == 1 )
                {
                    row = rowset.next();
                    if ( !DbCommonUtil.valueOf( row.getAttribute( COL_GAL_THK_TRV ) ).equals( C10STR_SPACE ) )
                        gal_thk_trv = Double.parseDouble( row.getAttribute( COL_GAL_THK_TRV ).toString() ) / 1000;
                } else if ( rowset.count() > 1 )
                {
                    ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                    ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                    ctx.put( COL_XMSGS, ERRMSG_I08 );
                    ctx.put( COL_ORD_ERR_TXT, ERRMSG_I08 );
                    ctx.put( COL_ERR_YN, C10STR_YES );
                    logger.logError( ERRMSG_I08 );
                    return PosBizControlConstants.SUCCESS;
                } else
                {
                    ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                    ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                    ctx.put( COL_XMSGS, ERRMSG_I09 );
                    ctx.put( COL_ORD_ERR_TXT, ERRMSG_I09 );
                    ctx.put( COL_ERR_YN, C10STR_YES );
                    logger.logError( ERRMSG_I09 );
                    return PosBizControlConstants.SUCCESS;
                }
            }
    
            // PLTCM목표두께 설계
            if ( !cus_bth_pap_no.endsWith( C10STR_STAR ) )
            {
                // 수요가사양이 있는경우
    
                param = new PosParameter(); // MD View param
    
                param.setWhereClauseParameter( 0, cus_bth_pap_no );
    
                try
                {
                    // 결과값 잘 가져오는지 확인
                    rowset = dao.find( VI_M00_C10A1020, param ); // 고객공통View.select
                } catch ( Exception e )
                {
                    rowset = null;
                    ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                    ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                    ctx.put( COL_ORD_ERR_TXT, e.getMessage() );
                    ctx.put( COL_XMSGS, e.getMessage() );
                    ctx.put( COL_ERR_YN, C10STR_YES );
                    logger.logError( e.getMessage() );
                    return PosBizControlConstants.SUCCESS;
                }
    
                if ( rowset.count() == 1 )
                {
                    row = rowset.next();
                    if ( !DbCommonUtil.isNull( 
                            DbCommonUtil.valueOf( row.getAttribute( COL_CUS_REQ_ROL_THK ) ) ) )
                    {
                        if ( ord_thk_tp.equals( NUM3 ) )
                        {
                            ord_exc_thk = ord_exc_thk - pnt_flm_thk_frn_tot - pnt_flm_thk_bak_tot - gal_thk_trv;
                        }
                        
                        if ( DbCommonUtil.valueOf( row.getAttribute( COL_CUS_REQ_ROL_THK_UNT ) ).equals( UNIT_CRN ) )
                        {
                            crm_thk = ord_exc_thk + 
                                    Double.parseDouble( 
                                            DbCommonUtil.valueOf( row.getAttribute( COL_CUS_REQ_ROL_THK ) ) );
                            crm_thk = crm_thk + crm_thk * sp_thk / 100;
                        } else if ( DbCommonUtil.valueOf( row.getAttribute( COL_CUS_REQ_ROL_THK_UNT ) ).equals( UNIT_PCN ) )
                        {
                            crm_thk = ord_exc_thk + ord_exc_thk * 
                                    Double.parseDouble( 
                                            DbCommonUtil.valueOf( row.getAttribute( COL_CUS_REQ_ROL_THK ) ) ) / 100;
                            crm_thk = crm_thk + crm_thk * sp_thk / 100;
                        } else
                        {
                            crm_thk = Double.parseDouble( DbCommonUtil.valueOf( row.getAttribute( COL_CUS_REQ_ROL_THK ) ) );
                        }
                    }
                } else if ( rowset.count() > 1 )
                {
                    ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                    ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                    ctx.put( COL_XMSGS, ERRMSG_I02 );
                    ctx.put( COL_ORD_ERR_TXT, ERRMSG_I02 );
                    ctx.put( COL_ERR_YN, C10STR_YES );
                    logger.logError( ERRMSG_I02 );
                    return PosBizControlConstants.SUCCESS;
                } else
                {
                    ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                    ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                    ctx.put( COL_XMSGS, ERRMSG_I03 );
                    ctx.put( COL_ORD_ERR_TXT, ERRMSG_I03 );
                    ctx.put( COL_ERR_YN, C10STR_YES );
                    logger.logError( ERRMSG_I03 );
                    return PosBizControlConstants.SUCCESS;
                }
            }
    
            // 고객사양이 없거나 고객요청 압연두께 목표치가 0인경우
            if ( Double.compare( crm_thk, 0) == 0 )
            {
                colValue = new String[10];
                colValue[0] = prd_nm_cd;
                if(spc_avr.length() > 1)
                    colValue[1] = spc_avr.substring( 0, 2 );
                colValue[2] = spc_avr;
                colValue[3] = (String) ctx.get( COL_ORD_USG_CD );
                colValue[4] = (String) ctx.get( COL_FNL_CUS_CD );
                colValue[5] = ord_thk_tp;
                colValue[6] = ord_thk_mng_cd;
                colValue[7] = gw_asg_cd;
                colValue[8] = Double.toString( ord_exc_thk );
                //colValue[9] = Double.toString( ord_exc_wth );
                colValue[9] = Double.toString( exc_wth );
    
                checker = EasyAccess.getPosDecisionChecker( C10B2060, null );
                result = null;
                try
                {
                    // 결과값 잘 가져오는지 확인
                    result = checker.getPosRule( colValue );
                } catch ( MasterDataException e )
                {
                    result = null;
                    ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                    ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                    ctx.put( COL_XMSGS, ERRMSG_I29 );
                    ctx.put( COL_ORD_ERR_TXT, ERRMSG_I29 );
                    ctx.put( COL_ERR_YN, C10STR_YES );
                    logger.logError( e.getMessage() );
                    return PosBizControlConstants.SUCCESS;
                }
                if ( result.getRecordCount() == 1 )
                {
                    if ( result.getRuleValueAt( COL_THK_COR_UNT ).equals( UNIT_CRN ) )
                    {
                        if ( ord_thk_tp.equals( NUM2 ) )
                            crm_thk = ord_exc_thk - gal_thk_trv + 
                            Double.parseDouble( result.getRuleValueAt( COL_THK_COR_VAL ) );
                        else
                            crm_thk = ord_exc_thk + 
                            Double.parseDouble( result.getRuleValueAt( COL_THK_COR_VAL ) );
                    } else if ( result.getRuleValueAt( COL_THK_COR_UNT ).equals( UNIT_PCN ) )
                    {
                        if ( ord_thk_tp.equals( NUM2 ) )
                            crm_thk = ord_exc_thk - gal_thk_trv + ord_exc_thk * 
                            Double.parseDouble( result.getRuleValueAt( COL_THK_COR_VAL ) ) / 100;
                        else
                            crm_thk = ord_exc_thk + ord_exc_thk * 
                            Double.parseDouble( result.getRuleValueAt( COL_THK_COR_VAL ) ) / 100;
                    } else
                    {
                        if ( ord_thk_tp.equals( NUM2 ) )
                            crm_thk = Double.parseDouble( result.getRuleValueAt( COL_THK_COR_VAL ) ) - gal_thk_trv;
                        else
                            crm_thk = Double.parseDouble( result.getRuleValueAt( COL_THK_COR_VAL ) );
                    }
    
                    crm_thk = crm_thk + crm_thk * sp_thk / 100;
    
                } else if ( result.getRecordCount() > 1 )
                {
                    ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                    ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                    ctx.put( COL_XMSGS, ERRMSG_I30 );
                    ctx.put( COL_ORD_ERR_TXT, ERRMSG_I30 );
                    ctx.put( COL_ERR_YN, C10STR_YES );
                    logger.logError( ERRMSG_I30 );
                    return PosBizControlConstants.SUCCESS;
                } else
                {
                    ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                    ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                    ctx.put( COL_XMSGS, ERRMSG_I29 );
                    ctx.put( COL_ORD_ERR_TXT, ERRMSG_I29 );
                    ctx.put( COL_ERR_YN, C10STR_YES );
                    logger.logError( ERRMSG_I29 );
                    return PosBizControlConstants.SUCCESS;
                }
            }
    
            ctx.put( COL_ROL_TAR_THK, DbCommonUtil.thk_dot( DbCommonUtil.pltcm_x_Ray( crm_thk ) ) );
    
//            if ( ord_wth_mng_cd.equals( C10STR_Z ) )
//            {
//                if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_WTH_TLN_LLV ) ) )
//                    wth_tln_llv = Double.parseDouble( ctx.get( COL_ORD_WTH_TLN_LLV ).toString() );
//                if ( !DbCommonUtil.isNull( ctx.get( COL_ORD_WTH_TLN_ULV ) ) )
//                    wth_tln_ulv = Double.parseDouble( ctx.get( COL_ORD_WTH_TLN_ULV ).toString() );
//            }
    
            // 관리코드'NULL'
//            if ( ord_wth_mng_cd.equals( C10STR_SPACE ) )
//            {
//                param = new PosParameter(); // MD View param
//                param.setWhereClauseParameter( 0, cus_bth_pap_no );
//    
//                try
//                {
//                    rowset = dao.find( VI_M00_C10A1023, param ); // 고객인수도View.select
//                } catch ( Exception e )
//                {
//                    logger.logError( e.getMessage() );
//                }
//    
//                if ( rowset != null && rowset.count() != 0 )
//                {
//                    row = rowset.next();
//    
//                    if ( !DbCommonUtil.isNull( row.getAttribute( COL_ORD_WTH_TLN_LLV ).toString() ) )
//                        wth_tln_llv = Double.parseDouble( row.getAttribute( COL_ORD_WTH_TLN_LLV ).toString() );
//                    if ( !DbCommonUtil.isNull( row.getAttribute( COL_ORD_WTH_TLN_ULV ).toString() ) )
//                        wth_tln_ulv = Double.parseDouble( row.getAttribute( COL_ORD_WTH_TLN_ULV ).toString() );
//                }
//            }
    
//            if ( ( !ord_wth_mng_cd.equals( C10STR_SPACE ) && !ord_wth_mng_cd.equals( C10STR_Z ) ) )
//            {
//                rowset = null;
//                row = null;
//    
//                param = new PosParameter(); // MD View param
//                param.setWhereClauseParameter( 0, ord_wth_mng_cd );
//                try
//                {
//                    rowset = dao.find( VI_M00_C10A2181, param ); // 폭공차View.select
//                } catch ( Exception e )
//                {
//                    rowset = null;
//                    ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
//                    ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
//                    ctx.put( COL_XMSGS, e.getMessage() );
//                    ctx.put( COL_ORD_ERR_TXT, e.getMessage() );
//                    ctx.put( COL_ERR_YN, C10STR_YES );
//                    logger.logError( e.getMessage() );
//                    return PosBizControlConstants.SUCCESS;
//                }
//    
//                if ( rowset.count() == 1 )
//                {
//                    row = rowset.next();
//                    // 주문폭관리코드가 NULL이나 Z가 아닌 경우엔 규격인수도 Master Data를 적용
//                    if ( !DbCommonUtil.isNull( row.getAttribute( COL_WTH_TLN_LLV ).toString() ) )
//                        wth_tln_llv = Double.parseDouble( row.getAttribute( COL_WTH_TLN_LLV ).toString() );
//                    if ( !DbCommonUtil.isNull( row.getAttribute( COL_WTH_TLN_ULV ).toString() ) )
//                        wth_tln_ulv = Double.parseDouble( row.getAttribute( COL_WTH_TLN_ULV ).toString() );
//                } else if ( rowset.count() > 1 )
//                {
//                    ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
//                    ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
//                    ctx.put( COL_XMSGS, ERRMSG_I10 );
//                    ctx.put( COL_ORD_ERR_TXT, ERRMSG_I10 );
//                    ctx.put( COL_ERR_YN, C10STR_YES );
//                    logger.logError( ERRMSG_I10 );
//                    return PosBizControlConstants.SUCCESS;
//                } else
//                {
//                    ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
//                    ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
//                    ctx.put( COL_XMSGS, ERRMSG_I11 );
//                    ctx.put( COL_ORD_ERR_TXT, ERRMSG_I11 );
//                    ctx.put( COL_ERR_YN, C10STR_YES );
//                    logger.logError( ERRMSG_I11 );
//                    return PosBizControlConstants.SUCCESS;
//                }                
//            }        

            // 제품폭여유
            param = new PosParameter(); // MD View param
            param.setWhereClauseParameter( 0, ord_wth_mng_cd );

            try
            {
                // 결과값 잘 가져오는지 확인
                rowset = dao.find( VI_M00_C10A1070, param ); // 제품폭여유치View.select
            } catch ( MasterDataException e )
            {
                rowset = null;
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, e.getMessage() );
                ctx.put( COL_ORD_ERR_TXT, e.getMessage() );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.SUCCESS;
            }

            if ( rowset.count() == 1 )
            {
                row = rowset.next();
                mng_mrg_wth = Double.parseDouble( DbCommonUtil.valueOf( row.getAttribute( COL_MRG_WTH ) ) );

                if ( ord_slit_grp_cnt > 0 && 
                        Double.compare( 
                                Double.parseDouble( ctx.get( COL_ORD_EXC_WTH ).toString() ) , 
                                ord_mix_wth1) == 0 )
                    mng_mrg_wth = 
                            mng_mrg_wth * ord_slit_grp_cnt;
            } else if ( rowset.count() > 1 )
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I34 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I34 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I34 );
                return PosBizControlConstants.SUCCESS;
            } else
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I35 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I35 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I35 );
                return PosBizControlConstants.SUCCESS;
            }            
        }
        else ctx.put( COL_ROL_TAR_THK, ord_exc_thk );

        
        wth_trv = exc_wth;

        // 정전폭마진
        colValue = new String[7];
        colValue[0] = ord_edg_asg_tp; // 주문에지구분
        colValue[1] = prd_nm_cd; // 품명코드
        colValue[2] = prd_shp; // 제품형태
        colValue[3] = cot_mth; // 코팅방식
        colValue[4] = rsn_tp_frn; // 수지구분 전면
        colValue[5] = Double.toString( ord_exc_thk );  //정전폭마진기준에서 주문두께 추가(2013.05.29 김태성대리 요청)
        colValue[6] = ccl_bom_no; //정전폭마진기준에서 ccl bom번호 추가(2015.09.03 김태훈사원 요청) 
        checker = EasyAccess.getPosDecisionChecker( C10B1079, null );
        result = null;
        try
        {
            result = checker.getPosRule( colValue );
        } catch ( MasterDataException e )
        {
            rowset = null;
            ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
            ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
            ctx.put( COL_XMSGS, ERRMSG_I12 );
            ctx.put( COL_ORD_ERR_TXT, ERRMSG_I12 );
            ctx.put( COL_ERR_YN, C10STR_YES );
            logger.logError( e.getMessage() );
            return PosBizControlConstants.SUCCESS;
        }

        if ( result.getRecordCount() == 1 )
        {
            col_wth_mgn = Double.parseDouble( result.getRuleValueAt( COL_MRG_WTH ) );

        } else if ( result.getRecordCount() > 1 )
        {
            ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
            ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
            ctx.put( COL_XMSGS, ERRMSG_I13 );
            ctx.put( COL_ORD_ERR_TXT, ERRMSG_I13 );
            ctx.put( COL_ERR_YN, C10STR_YES );
            logger.logError( ERRMSG_I13 );
            return PosBizControlConstants.SUCCESS;
        } else
        {
            ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
            ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
            ctx.put( COL_XMSGS, ERRMSG_I12 );
            ctx.put( COL_ORD_ERR_TXT, ERRMSG_I12 );
            ctx.put( COL_ERR_YN, C10STR_YES );
            logger.logError( ERRMSG_I12 );
            return PosBizControlConstants.SUCCESS;
        }        

        // 정전폭감소량
        colValue = new String[4];
        colValue[0] = prd_nm_cd; // 품명코드
        colValue[1] = ctx.get( COL_MQL_CD ).toString(); // 재질코드
        colValue[2] = ctx.get( COL_ROL_TAR_THK ).toString(); // 주문두께
        colValue[3] = Double.toString( exc_wth ); // 주문폭
        checker = EasyAccess.getPosDecisionChecker( C10B1077, null );
        result = null;
        try
        {
            result = checker.getPosRule( colValue );
        } catch ( MasterDataException e )
        {
            result = null;
            ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
            ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
            ctx.put( COL_XMSGS, ERRMSG_I14 );
            ctx.put( COL_ORD_ERR_TXT, ERRMSG_I14 );
            ctx.put( COL_ERR_YN, C10STR_YES );
            logger.logError( e.getMessage() );
            return PosBizControlConstants.SUCCESS;
        }

        if ( result.getRecordCount() == 1 )
        {
            col_wth_shr = Double.parseDouble( result.getRuleValueAt( COL_WTH_SHR_QTY ) );

        } else if ( result.getRecordCount() > 1 )
        {
            ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
            ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
            ctx.put( COL_XMSGS, ERRMSG_I15 );
            ctx.put( COL_ORD_ERR_TXT, ERRMSG_I15 );
            ctx.put( COL_ERR_YN, C10STR_YES );
            logger.logError( ERRMSG_I15 );
            return PosBizControlConstants.SUCCESS;
        } else
        {
            ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
            ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
            ctx.put( COL_XMSGS, ERRMSG_I14 );
            ctx.put( COL_ORD_ERR_TXT, ERRMSG_I14 );
            ctx.put( COL_ERR_YN, C10STR_YES );
            logger.logError( ERRMSG_I14 );
            return PosBizControlConstants.SUCCESS;
        }

        if ( ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_1 ) || 
                ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_2 ) || 
                ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_3 ) || 
                ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_4 ) || 
                ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_5 ) || 
                ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_6 ) ||
                ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_7 ) ||
                ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_8 ) ||
                ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_9 ) )
        {
            // CCL폭감소량
            colValue = new String[4];
            colValue[0] = prd_nm_cd; // 품명
            colValue[1] = ctx.get( COL_MQL_CD ).toString(); // 재질코드
            colValue[2] = ctx.get( COL_ROL_TAR_THK ).toString(); // 주문두께
            colValue[3] = Double.toString( exc_wth ); // 주문폭
            
            checker = EasyAccess.getPosDecisionChecker( C10B1078, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I16 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I16 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.SUCCESS;
            }

            if ( result.getRecordCount() == 1 )
            {
                ccl_wth_shr = Double.parseDouble( result.getRuleValueAt( COL_CCL_WTH_SHR_QTY ) );

            } else if ( result.getRecordCount() > 1 )
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I15 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I15 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I15 );
                return PosBizControlConstants.SUCCESS;
            } else
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I16 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I16 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I16 );
                return PosBizControlConstants.SUCCESS;
            }
        }

        if ( //!ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_N ) &&
        	 !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_5 ) && 
             !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_7 ))
        {
            String main_proc_cd = C10STR_SPACE;
            ArrayList<String> DEL_PROC = new ArrayList<String>();
            ArrayList<String> DATA_PROC = new ArrayList<String>();
            colValue = new String[22];
            colValue[0] = prd_nm_cd;
            colValue[1] = C10STR_SPACE;
            colValue[2] = ord_coil_idia;
            colValue[3] = ord_slv_knd_tp;
            colValue[4] = ord_sur_hnd_cd;
            colValue[5] = gw_asg_cd;
            colValue[6] = embs_cd;
            colValue[7] = ord_pak_unt_wgt_llv;
            colValue[8] = ord_coil_odia;
            colValue[9] = Double.toString( ord_exc_thk );
            colValue[10] = Double.toString( exc_wth );
            colValue[11] = rsn_tp_frn;
            colValue[12] = lus_rt_cd_frn;
            colValue[13] = ptt_flm_dtl_cd;
            colValue[14] = ctx.get( COL_MQL_CD ).toString();
            colValue[15] = ord_edg_asg_tp;                  //주문에지구분
            colValue[16] = Double.toString( ord_exc_lth );  //주문길이추가
            colValue[17] = prd_shp;                         //제품형태추가
            colValue[18] = ord_coilg_mth;                   //주문권취방법추가	
            colValue[19] = fnl_cus_cd;                      //최종수요가	
            colValue[20] = ord_usg_cd;                      //주문용도	
            colValue[21] = ord_spnl_tp;                     //spangle구분	

            try
            {
                // 결과값 잘 가져오는지 확인
                PosDecisionRuleVO result1 = EasyAccess.getPosDecisionRuleLov( C10B2010, colValue, null );
                result1.next();
                DEL_PROC.add( result1.getRuleValueAt( COL_PROC_CD ) );
                logger.logDebug( "DEL_PROC       : " + DEL_PROC );
                while ( result1.next() )
                {
                    DEL_PROC.add( result1.getRuleValueAt( COL_PROC_CD ) );
                    logger.logDebug( "DEL_PROC_WHILE       : " + DEL_PROC );
                }

            } catch ( MasterDataException e )
            {
                logger.logError( e.getMessage() );
            }            
            
            param = new PosParameter(); // MD View param
            param.setWhereClauseParameter( 0, ctx.get( COL_PAS_PROC_NO ).toString() );
    
            try
            {
                // 결과값 잘 가져오는지 확인
                rowset = dao.find( VI_M00_C10A1054, param ); // 통과공정기준View.select
            } catch ( Exception e )
            {
                rowset = null;
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, e.getMessage() );
                ctx.put( COL_ORD_ERR_TXT, e.getMessage() );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( e.getMessage() );
                return PosBizControlConstants.SUCCESS;
            }
    
            if ( rowset.count() == 0 )
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I22 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I22 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I22 );
                return PosBizControlConstants.SUCCESS;
            }
    
            while ( rowset.hasNext() )
            {
                row = rowset.next();
                
                // 통과공정 결정기준을 읽어 통과공정을 삭제한다.
                if ( DEL_PROC.size() > 0 )
                {
                    DATA_PROC = DelProc( DEL_PROC, 
                            DbCommonUtil.valueOf( row.getAttribute( COL_MAIN_PROC_CD ) ), 
                            DbCommonUtil.valueOf( row.getAttribute( COL_SUB_PROC_CD1 ) ), 
                            DbCommonUtil.valueOf( row.getAttribute( COL_SUB_PROC_CD2 ) ), 
                            DbCommonUtil.valueOf( row.getAttribute( COL_SUB_PROC_CD3 ) ) );
                    if ( DATA_PROC.get( 0 ).equals( C10STR_SPACE ) )
                    {
                        ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                        ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                        ctx.put( COL_XMSGS, ERRMSG_I31 );
                        ctx.put( COL_ORD_ERR_TXT, ERRMSG_I31 );
                        ctx.put( COL_ERR_YN, C10STR_YES );
                        logger.logError( ERRMSG_I31 );
                        return PosBizControlConstants.SUCCESS;
                    }
                    
                    main_proc_cd = DATA_PROC.get( 0 );
                }
                else main_proc_cd = DbCommonUtil.valueOf( row.getAttribute( COL_MAIN_PROC_CD ) );
                
                logger.logDebug( "1.공정코드       : " + main_proc_cd );
                
                if ( cgl_proc_cd.equals( C10STR_SPACE ) &&
                        main_proc_cd.substring( 0, 1 ).equals( NUM8 ) )
                {
                    // CGL 공정
                    cgl_proc_cd = main_proc_cd;
                } else if ( egl_proc_cd.equals( C10STR_SPACE ) &&
                        main_proc_cd.substring( 0, 1 ).equals( NUM9 ) )
                {
                    // EGL 공정
                    egl_proc_cd = main_proc_cd;
                } else if ( egl_proc_cd.equals( C10STR_SPACE ) &&
                        main_proc_cd.substring( 0, 1 ).equals( C10STR_CD_C ) )
                {   // R -> C로 변경 JKJ (2019.01.15)
                    // 품명 N인 Zn-Ni구매 반제품을 N으로 그대로 제품으로 만드는 경우(2016.01.27)
                    egl_proc_cd = main_proc_cd;
                }
            }
        
        }

        if (    prd_nm_cd.equals( PRD_NM_CD_G ) || 
        		prd_nm_cd.equals( PRD_NM_CD_K ) ||
                prd_nm_cd.equals( PRD_NM_CD_J ) || 
                prd_nm_cd.equals( PRD_NM_CD_L ) || 
                prd_nm_cd.equals( PRD_NM_CD_V ) || 
                prd_nm_cd.equals( PRD_NM_CD_W ) || 
                prd_nm_cd.equals( PRD_NM_CD_3 ) || 
                prd_nm_cd.equals( PRD_NM_CD_4 ) || 
                prd_nm_cd.equals( PRD_NM_CD_6 ) || 
                prd_nm_cd.equals( PRD_NM_CD_9 ) )
        {
            // CGL폭감소량
            colValue = new String[6];
            colValue[0] = cgl_proc_cd; // 공정코드
            colValue[1] = prd_nm_cd; // 품명
            colValue[2] = ctx.get( COL_MQL_CD ).toString(); // 재질코드
            colValue[3] = ctx.get( COL_RMTL_CD ).toString(); // 원자재코드
            colValue[4] = ctx.get( COL_ROL_TAR_THK ).toString(); // 주문두께
            colValue[5] = Double.toString( exc_wth ); // 주문폭
            checker = EasyAccess.getPosDecisionChecker( C10B1075, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I18 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I18 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError(ERRMSG_I18 +" "+ e.getMessage() );
                return PosBizControlConstants.SUCCESS;
            }

            if ( result.getRecordCount() == 1 )
            {
                gal_wth_shr = Double.parseDouble( result.getRuleValueAt( COL_GAL_WTH_SHR_QTY ) );

            } else if ( result.getRecordCount() > 1 )
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I19 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I19 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I19 );
                return PosBizControlConstants.SUCCESS;
            } else
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I18 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I18 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I18 );
                return PosBizControlConstants.SUCCESS;
            }
        }

        // EGL 제품,중간재적용기준 Zn-Ni 품명N은 향후 추가예정
        //if ( prd_nm_cd.equals( PRD_NM_CD_E ) || prd_nm_cd.equals( PRD_NM_CD_2 ) || prd_nm_cd.equals( PRD_NM_CD_N ))
        if ( prd_nm_cd.equals( PRD_NM_CD_E ) || prd_nm_cd.equals( PRD_NM_CD_2 ) || prd_nm_cd.equals( PRD_NM_CD_N ) || prd_nm_cd.equals( PRD_NM_CD_8 ))	
        {
            colValue = new String[3];
            colValue[0] = prd_nm_cd; // 품명
            colValue[1] = Double.toString( ord_exc_thk ); // 두께
            colValue[2] = Double.toString( exc_wth ); // 주문폭
            checker = EasyAccess.getPosDecisionChecker( C10B2230, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
                
                if ( result.getRecordCount() == 1 )
                {
                    egl_proc_cd = NUM9 + NUM2;
                } else if ( result.getRecordCount() > 1 )
                {
                    ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                    ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                    ctx.put( COL_XMSGS, ERRMSG_I36 );
                    ctx.put( COL_ORD_ERR_TXT, ERRMSG_I36 );
                    ctx.put( COL_ERR_YN, C10STR_YES );
                    logger.logError( ERRMSG_I36 );
                    return PosBizControlConstants.SUCCESS;
                }

            } catch ( MasterDataException e )
            {
                result = null;
            }

            // EGL폭수축량
            colValue = new String[6];
            colValue[0] = egl_proc_cd; // 공정코드
            colValue[1] = prd_nm_cd; // 품명
            colValue[2] = ctx.get( COL_MQL_CD ).toString(); // 재질코드
            colValue[3] = ctx.get( COL_RMTL_CD ).toString(); // 원자재코드
            colValue[4] = ctx.get( COL_ROL_TAR_THK ).toString(); // 주문두께
            colValue[5] = Double.toString( exc_wth ); // 주문폭
            
            logger.logDebug( "공정코드          : " + colValue[0] );
            logger.logDebug( "품명              : " + colValue[1] );
            logger.logDebug( "재질코드          : " + colValue[2] );
            logger.logDebug( "원자재코드        : " + colValue[3] );
            logger.logDebug( "주문두께          : " + colValue[4] );
            logger.logDebug( "주문폭            : " + colValue[5] );
            
            checker = EasyAccess.getPosDecisionChecker( C10B1076, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I20 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I20 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I20 +" "+ e.getMessage() );
                return PosBizControlConstants.SUCCESS;
            }

            if ( result.getRecordCount() == 1 )

            {
                gal_wth_shr = Double.parseDouble( result.getRuleValueAt( COL_EGL_WTH_SHR_QTY ) );

            } else if ( result.getRecordCount() > 1 )
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I21 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I21 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I21 );
                return PosBizControlConstants.SUCCESS;
            } else
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I20 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I20 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I20 );
                return PosBizControlConstants.SUCCESS;
            }
        }

        pltcm_wth_trv = wth_trv + col_wth_shr + ccl_wth_shr + gal_wth_shr + col_wth_mgn + mng_mrg_wth;
        ctx.put( COL_PLTCM_WTH_TRV, Math.round( pltcm_wth_trv ) );

        //품명이 N인경우 PLTCM사이즈 계산 안함(원자재 사이즈 = Zn-Ni 사이즈 동일하게 적용) -> 수정(계산함)
        if ( !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_5 ) && 
             !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_7 )) 
            // !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_8 ) &&
            // !ctx.get( COL_PRD_NM_CD ).equals( PRD_NM_CD_N ))
        {
       
            // 원자재두께
            colValue = new String[3];
            colValue[0] = ctx.get( COL_RMTL_CD ).toString(); // 원자재코드
            colValue[1] = ctx.get( COL_ROL_TAR_THK ).toString(); // PLTCM두께
            colValue[2] = ctx.get( COL_PLTCM_WTH_TRV ).toString(); // PLTCM폭
            checker = EasyAccess.getPosDecisionChecker( C10B1071, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I23 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I23 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I23 +" "+ e.getMessage() );
                logger.logError( "원자재코드         : " + colValue[0]);
                logger.logError( "PLTCM두께        : " + colValue[1]);
                logger.logError( "PLTCM폭          : " + colValue[2]);
                return PosBizControlConstants.SUCCESS;
            }
    
            if ( result.getRecordCount() == 1 )
            {
                ctx.put( COL_RMTL_TAR_THK, result.getRuleValueAt( COL_RMTL_TAR_THK ) );
            } else if ( result.getRecordCount() > 1 )
            {
                
            	ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I24 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I24 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I24 );
                logger.logError( "원자재코드         : " + colValue[0]);
                logger.logError( "PLTCM두께        : " + colValue[1]);
                logger.logError( "PLTCM폭          : " + colValue[2]);
                return PosBizControlConstants.SUCCESS;
            } else
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I23 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I23 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I23 );
                logger.logError( "원자재코드         : " + colValue[0]);
                logger.logError( "PLTCM두께        : " + colValue[1]);
                logger.logError( "PLTCM폭          : " + colValue[2]);
                return PosBizControlConstants.SUCCESS;
            }
    
            // PLTCM수축량
            colValue = new String[3];
            colValue[0] = ctx.get( COL_RMTL_CD ).toString(); // 원자재코드
            colValue[1] = ctx.get( COL_ROL_TAR_THK ).toString(); // PLTCM두께
            colValue[2] = ctx.get( COL_PLTCM_WTH_TRV ).toString(); // PLTCM폭
            checker = EasyAccess.getPosDecisionChecker( C10B1074, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I25 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I25 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I25 +" "+ e.getMessage() );
                return PosBizControlConstants.SUCCESS;
            }
    
            if ( result.getRecordCount() == 1 )
            {
                tcm_wth_shr_qty = Double.parseDouble( result.getRuleValueAt( COL_TCM_WTH_SHR_QTY ) );
            } else if ( result.getRecordCount() > 1 )
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I26 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I26 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I26 );
                return PosBizControlConstants.SUCCESS;
            } else
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I25 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I25 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I25 );
                return PosBizControlConstants.SUCCESS;
            }
    
            // PLTCM마진량
            colValue = new String[3];
            colValue[0] = ctx.get( COL_RMTL_CD ).toString(); // 원자재코드
            colValue[1] = ctx.get( COL_RMTL_TAR_THK ).toString(); // 원자재두께
            colValue[2] = ctx.get( COL_PLTCM_WTH_TRV ).toString(); // PLTCM폭
            checker = EasyAccess.getPosDecisionChecker( C10B1073, null );
            result = null;
            try
            {
                result = checker.getPosRule( colValue );
            } catch ( MasterDataException e )
            {
                result = null;
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I27 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I27 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError(ERRMSG_I27 +" "+ e.getMessage() );
                return PosBizControlConstants.SUCCESS;
            }
    
            if ( result.getRecordCount() == 1 )
            {
                mrg_wth = Double.parseDouble( result.getRuleValueAt( COL_MRG_WTH ) );
            } else if ( result.getRecordCount() > 1 )
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I28 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I28 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I28 );
                return PosBizControlConstants.SUCCESS;
            } else
            {
                ctx.put( COL_XSTAT, QLT_DSN_STS_CD_E );
                ctx.put( COL_XSTAT_CALLBACK, C10STR_R );
                ctx.put( COL_XMSGS, ERRMSG_I27 );
                ctx.put( COL_ORD_ERR_TXT, ERRMSG_I27 );
                ctx.put( COL_ERR_YN, C10STR_YES );
                logger.logError( ERRMSG_I27 );
                return PosBizControlConstants.SUCCESS;
            }
        }
        else ctx.put( COL_RMTL_TAR_THK, ord_exc_thk );

        if ( ord_edg_asg_tp.equals( SLIT_EDGE ) || ord_edg_asg_tp.equals( MILL_EDGE ) )
            ctx.put( COL_RMTL_TAR_WTH, Math.round( pltcm_wth_trv + tcm_wth_shr_qty + mrg_wth ) );
        else if ( ord_edg_asg_tp.equals( COIL_EDGE ) )
            ctx.put( COL_RMTL_TAR_WTH, Math.round( pltcm_wth_trv ) );
        else if ( ord_edg_asg_tp.equals( NO_SLIT ) )
            ctx.put( COL_RMTL_TAR_WTH, Math.round( wth_trv + gal_wth_shr ) );

        ctx.put( COL_XSTAT, C10STR_S );
        return PosBizControlConstants.SUCCESS;
    }
    
    /**
     * 통과공정을 편집(삭제)하는 함수이다.
     * <xmp>
     * </xmp>
     * 
     * @param DEL_PROC 삭제대상공정
     * @param MAIN_PROC 주공정
     * @param SUB_PROC_CD1 대체공정1
     * @param SUB_PROC_CD2 대체공정2
     * @param SUB_PROC_CD3 대체공정3
     * @return boolean
     */

    public ArrayList<String> DelProc( ArrayList<String> DEL_PROC, String MAIN_PROC, String SUB_PROC_CD1, String SUB_PROC_CD2, String SUB_PROC_CD3 )
    {
        ArrayList<String> DATA_PROC = new ArrayList<String>();
        ArrayList<String> RESULT_PROC = new ArrayList<String>();
        DATA_PROC.add( MAIN_PROC );
        DATA_PROC.add( SUB_PROC_CD1 );
        DATA_PROC.add( SUB_PROC_CD2 );
        DATA_PROC.add( SUB_PROC_CD3 );
        int RCNT = 0;

        for ( int CNT = 0; CNT < 4; CNT++ )
        {
            if ( !DATA_PROC.get( CNT ).equals( C10STR_SPACE ) )
            {
                for ( int DCNT = 0; DCNT < DEL_PROC.size(); DCNT++ )
                {
                    if ( DATA_PROC.get( CNT ).equals( DEL_PROC.get( DCNT ) ) )
                    {
                        break;
                    }

                    if ( DCNT == DEL_PROC.size() - 1 )
                    {
                        RESULT_PROC.add( DATA_PROC.get( CNT ) );
                    }
                }
            }
        }

        if ( RESULT_PROC.size() < 4 )
        {
            RCNT = RESULT_PROC.size();
            for ( int CNT = 0; CNT < 4 - RCNT; CNT++ )
            {
                RESULT_PROC.add( C10STR_SPACE );
            }
        }
        return RESULT_PROC;
    }
}
