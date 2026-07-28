--=============================================================================
-- C106000050 원가내역서 첨부 예외 조합 관리 테이블
--   구매수지타입(RSN_TP) vs 품질수지타입(RSN_TP_QT_BR)이 상이한 경우
--   원가내역서(MFILE_YN='Y') 첨부를 필수로 요구하되,
--   본 테이블에 등록된 조합은 예외로 첨부 없이도 전송 가능.
--
--   추가/삭제/변경은 IT 담당자가 DB 직접 SQL로 수행.
--   현업(사용자)은 팝업(C106000050pop09)에서 조회만 가능.
--=============================================================================

--------------------------------------------------------
-- 1) TABLE
--------------------------------------------------------
CREATE TABLE C10APUSER.TB_C10_CLR_EXCEPT
(
    RSN_TP        VARCHAR2(4)  NOT NULL,     -- 구매수지타입
    RSN_TP_QT_BR  VARCHAR2(4)  NOT NULL,     -- 품질수지타입(BR)
    USE_YN        VARCHAR2(1)  DEFAULT 'Y' NOT NULL,
    RMRK          VARCHAR2(200),             -- 비고 (추가 사유, 정보처리의뢰서 등)
    RGS_PRS_ID    VARCHAR2(20),              -- 등록자
    RGS_DH        DATE         DEFAULT SYSDATE NOT NULL,
    MDF_PRS_ID    VARCHAR2(20),              -- 수정자
    MDF_DH        DATE,                      -- 수정일시
    CONSTRAINT PK_TB_C10_CLR_EXCEPT PRIMARY KEY (RSN_TP, RSN_TP_QT_BR)
);

COMMENT ON TABLE  C10APUSER.TB_C10_CLR_EXCEPT              IS '칼라코드관리 원가내역서 첨부 예외 조합';
COMMENT ON COLUMN C10APUSER.TB_C10_CLR_EXCEPT.RSN_TP       IS '구매수지타입';
COMMENT ON COLUMN C10APUSER.TB_C10_CLR_EXCEPT.RSN_TP_QT_BR IS '품질수지타입';
COMMENT ON COLUMN C10APUSER.TB_C10_CLR_EXCEPT.USE_YN       IS '사용여부 (Y/N)';
COMMENT ON COLUMN C10APUSER.TB_C10_CLR_EXCEPT.RMRK         IS '비고';
COMMENT ON COLUMN C10APUSER.TB_C10_CLR_EXCEPT.RGS_PRS_ID   IS '등록자';
COMMENT ON COLUMN C10APUSER.TB_C10_CLR_EXCEPT.RGS_DH       IS '등록일시';
COMMENT ON COLUMN C10APUSER.TB_C10_CLR_EXCEPT.MDF_PRS_ID   IS '수정자';
COMMENT ON COLUMN C10APUSER.TB_C10_CLR_EXCEPT.MDF_DH       IS '수정일시';


--------------------------------------------------------
-- 2) 초기 데이터 (이미지 기준 15조합)
--------------------------------------------------------
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('11', '05', 'Y', '초기 예외 조합', 'SYSTEM');
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('41', '07', 'Y', '초기 예외 조합', 'SYSTEM');
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('42', '07', 'Y', '초기 예외 조합', 'SYSTEM');
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('04', '2A', 'Y', '초기 예외 조합', 'SYSTEM');
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('52', 'SE', 'Y', '초기 예외 조합', 'SYSTEM');
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('FH', '55', 'Y', '초기 예외 조합', 'SYSTEM');
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('H7', 'H6', 'Y', '초기 예외 조합', 'SYSTEM');
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('R2', 'R1', 'Y', '초기 예외 조합', 'SYSTEM');
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('RJ', 'RH', 'Y', '초기 예외 조합', 'SYSTEM');
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('RL', 'RK', 'Y', '초기 예외 조합', 'SYSTEM');
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('D1', 'RN', 'Y', '초기 예외 조합', 'SYSTEM');
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('D2', 'RO', 'Y', '초기 예외 조합', 'SYSTEM');
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('G1', '54', 'Y', '초기 예외 조합', 'SYSTEM');
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('G2', '53', 'Y', '초기 예외 조합', 'SYSTEM');
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('G3', '52', 'Y', '초기 예외 조합', 'SYSTEM');
INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, USE_YN, RMRK, RGS_PRS_ID) VALUES ('RM', 'RI', 'Y', '초기 예외 조합', 'SYSTEM');

COMMIT;


--------------------------------------------------------
-- 3) MESAPUSER 계정에서 사용하기 위한 시노님/권한 (필요 시)
--------------------------------------------------------
-- GRANT SELECT ON C10APUSER.TB_C10_CLR_EXCEPT TO MESAPUSER;
-- CREATE OR REPLACE SYNONYM MESAPUSER.TB_C10_CLR_EXCEPT FOR C10APUSER.TB_C10_CLR_EXCEPT;


--------------------------------------------------------
-- 4) 예외 조합 추가/삭제 예시 (담당자용)
--------------------------------------------------------
-- 추가
-- INSERT INTO C10APUSER.TB_C10_CLR_EXCEPT (RSN_TP, RSN_TP_QT_BR, RMRK, RGS_PRS_ID)
-- VALUES ('XX', 'YY', '적용승인요청서 DKSYS-XXXX-000000', '사번');
-- COMMIT;

-- 소프트 삭제 (권장)
-- UPDATE C10APUSER.TB_C10_CLR_EXCEPT
--    SET USE_YN='N', MDF_PRS_ID='사번', MDF_DH=SYSDATE
--  WHERE RSN_TP='XX' AND RSN_TP_QT_BR='YY';
-- COMMIT;

-- 물리 삭제
-- DELETE FROM C10APUSER.TB_C10_CLR_EXCEPT WHERE RSN_TP='XX' AND RSN_TP_QT_BR='YY';
-- COMMIT;
