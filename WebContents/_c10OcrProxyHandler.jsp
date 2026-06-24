<%--
 * PROGRAM NAME     : _c10OcrProxyHandler.jsp
 * DESCRIPTION      : OCR 결과 저장 핸들러 (C106000190)
 *                    - 브라우저에서 Upstage API 직접 호출 후 본 핸들러로 결과 전달
 *                    - multipart 수신 : image(파일), extracted_json(string), raw_json(string)
 *                    - 서버 디스크 저장 (/APP/WAS/FILES/C10/clr_std_ocr/YYYYMM/)
 *                    - TB_C10_CLR_STD_OCR INSERT
 *                    - JSON 응답 반환
 * NOTE             : Tomcat 5.5 + JSP 2.0 + Jasper Java 1.4 호환 (varargs/제네릭/오토박싱 사용 금지)
 * 이력             : 2026-05-20 SJS - 외부통신 정책 차단으로 브라우저 직접 호출 방식 전환,
 *                                     서버 측 Upstage API 호출 로직 제거
--%>
<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.FileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.PosGenericDao" %>
<%@ page import="com.posdata.glue.dao.PosJdbcDao" %>
<%@ page import="com.posdata.glue.dao.vo.PosParameter" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.posdata.glue.web.security.PosUser" %>
<%@ page import="com.posdata.glue.web.security.PosSecurityConstants" %>
<%!
    private static String pickStr(JSONObject o, String[] keys) {
        if (o == null || keys == null) return null;
        for (int i = 0; i < keys.length; i++) {
            Object v = o.get(keys[i]);
            if (v != null && v.toString().length() > 0) return v.toString();
        }
        return null;
    }

    private static BigDecimal pickNum(JSONObject o, String[] keys) {
        String t = pickStr(o, keys);
        if (t == null) return null;
        StringBuffer b = new StringBuffer();
        boolean dotSeen = false;
        for (int i = 0; i < t.length(); i++) {
            char c = t.charAt(i);
            if (c >= '0' && c <= '9') b.append(c);
            else if (c == '-' && b.length() == 0) b.append(c);
            else if (c == '.' && !dotSeen) { b.append(c); dotSeen = true; }
        }
        String s = b.toString();
        if (s.length() == 0 || "-".equals(s) || ".".equals(s)) return null;
        try { return new BigDecimal(s); } catch (Exception e) { return null; }
    }

    private static String normDate(String s) {
        if (s == null) return null;
        StringBuffer b = new StringBuffer();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c >= '0' && c <= '9') b.append(c);
        }
        String t = b.toString();
        if (t.length() == 6) t = "20" + t;
        if (t.length() >= 8) return t.substring(0, 8);
        return null;
    }

    private static String safeName(String s) {
        if (s == null) return "file";
        StringBuffer b = new StringBuffer();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '\\' || c == '/' || c == ':' || c == '*' || c == '?' || c == '"' || c == '<' || c == '>' || c == '|') b.append('_');
            else b.append(c);
        }
        return b.toString();
    }
%>
<%
JSONObject result = new JSONObject();
File savedFile = null;
try {
    response.setHeader("Cache-Control", "no-store");

    String uploadBase= application.getInitParameter("c10.upstage.uploadDir");
    if (uploadBase == null || uploadBase.length() == 0) uploadBase = "/APP/WAS/FILES/C10/clr_std_ocr/";

    PosUser user = (PosUser) session.getAttribute(PosSecurityConstants.USER);
    String userNo = (user != null) ? (String) user.getUserInfo("USER_NO") : "SYSTEM";

    if (!ServletFileUpload.isMultipartContent(request)) {
        result.put("success", Boolean.FALSE);
        result.put("message", "multipart 요청이 아닙니다.");
        out.print(result.toJSONString());
        return;
    }
    DiskFileItemFactory factory = new DiskFileItemFactory();
    factory.setSizeThreshold(1024 * 1024);
    ServletFileUpload upload = new ServletFileUpload(factory);
    upload.setHeaderEncoding("UTF-8");
    upload.setSizeMax(20L * 1024L * 1024L);
    List parts = upload.parseRequest(request);
    FileItem fileItem = null;
    String extractedJsonStr = null;
    String rawJsonStr = null;
    Iterator it = parts.iterator();
    while (it.hasNext()) {
        FileItem fi = (FileItem) it.next();
        if (fi.isFormField()) {
            String fname = fi.getFieldName();
            if ("extracted_json".equals(fname)) extractedJsonStr = fi.getString("UTF-8");
            else if ("raw_json".equals(fname)) rawJsonStr = fi.getString("UTF-8");
        } else if (fi.getSize() > 0 && fileItem == null) {
            fileItem = fi;
        }
    }
    if (fileItem == null) {
        result.put("success", Boolean.FALSE);
        result.put("message", "이미지 파일이 없습니다.");
        out.print(result.toJSONString());
        return;
    }

    PosGenericDao dao = (PosGenericDao) PosContext.getBeanFactory().getBeanObject("mesdao");

    // GLUE 의 dao.find 가 SELECT 를 두 번 트리거하는 동작이 확인되어, NEXTVAL 채번은 native JDBC 로 직접 호출한다.
    // PreparedStatement.executeQuery() 는 표준 JDBC 라 한 번만 실행됨이 보장됨 → OCR_NO 갭 발생 안 함.
    // PosJdbcDao 에서 dataSource 직접 획득 (FactoryBean 캐스팅 문제 회피).
    long ocrNo = 0L;
    {
        DataSource _ds = ((PosJdbcDao) dao).getDataSource();
        Connection _conn = null;
        PreparedStatement _ps = null;
        ResultSet _rs = null;
        try {
            _conn = _ds.getConnection();
            _ps = _conn.prepareStatement("SELECT SQ_C10_CLR_STD_OCR.NEXTVAL FROM DUAL");
            _rs = _ps.executeQuery();
            if (_rs.next()) ocrNo = _rs.getLong(1);
        } finally {
            if (_rs != null) try { _rs.close(); } catch (Exception ignore) {}
            if (_ps != null) try { _ps.close(); } catch (Exception ignore) {}
            if (_conn != null) try { _conn.close(); } catch (Exception ignore) {}
        }
    }
    if (ocrNo <= 0L) {
        result.put("success", Boolean.FALSE);
        result.put("message", "OCR_NO 시퀀스 채번 실패");
        out.print(result.toJSONString());
        return;
    }

    String origName = fileItem.getName();
    int slash = origName.lastIndexOf('\\');
    if (slash < 0) slash = origName.lastIndexOf('/');
    if (slash >= 0) origName = origName.substring(slash + 1);
    origName = safeName(origName);

    int dot = origName.lastIndexOf('.');
    String fileExt = (dot >= 0) ? origName.substring(dot + 1).toLowerCase() : "";

    String yyyyMM = new SimpleDateFormat("yyyyMM").format(new java.util.Date());
    String savedDirPath = uploadBase + yyyyMM + "/";
    File savedDir = new File(savedDirPath);
    if (!savedDir.exists()) savedDir.mkdirs();
    String savedName = ocrNo + "_" + origName;
    savedFile = new File(savedDir, savedName);
    fileItem.write(savedFile);
    fileItem.delete();

    JSONParser parser = new JSONParser();
    JSONObject extracted = new JSONObject();
    if (extractedJsonStr != null && extractedJsonStr.length() > 0) {
        try { extracted = (JSONObject) parser.parse(extractedJsonStr); } catch (Exception ignore) { }
    }

    PosParameter param = new PosParameter();
    param.setNamedParamter("OCR_NO",          new BigDecimal(String.valueOf(ocrNo)));
    param.setNamedParamter("IMG_FILE_NM",     origName);
    param.setNamedParamter("IMG_FILE_PATH",   savedFile.getAbsolutePath().replace('\\','/'));
    param.setNamedParamter("IMG_FILE_SIZE",   new BigDecimal(String.valueOf(savedFile.length())));
    param.setNamedParamter("IMG_FILE_EXT",    fileExt);

    param.setNamedParamter("OCR_CODE",        pickStr(extracted, new String[]{"code"}));
    param.setNamedParamter("OCR_TYPE",        pickStr(extracted, new String[]{"type"}));
    param.setNamedParamter("OCR_QT_TYPE",     pickStr(extracted, new String[]{"qtType"}));
    param.setNamedParamter("OCR_MUNSELL",     pickStr(extracted, new String[]{"munsell"}));
    param.setNamedParamter("OCR_GLOSS",       pickNum(extracted, new String[]{"glossPercentage", "gloss"}));
    param.setNamedParamter("OCR_PRIMER",      pickStr(extracted, new String[]{"primer"}));
    param.setNamedParamter("OCR_DFT_1C",      pickNum(extracted, new String[]{"dft1c", "1C"}));
    param.setNamedParamter("OCR_DFT_2C",      pickNum(extracted, new String[]{"dft2c", "2C"}));
    param.setNamedParamter("OCR_DFT_3C",      pickNum(extracted, new String[]{"dft3c", "3C"}));
    param.setNamedParamter("OCR_COLOR",       pickStr(extracted, new String[]{"color"}));
    param.setNamedParamter("OCR_UNFIXED_NO",  pickStr(extracted, new String[]{"unfixedNumber", "unfixedNo"}));
    param.setNamedParamter("OCR_DELTA_E",     pickNum(extracted, new String[]{"deltaE"}));
    param.setNamedParamter("OCR_NV",          pickNum(extracted, new String[]{"nv", "N.V"}));
    param.setNamedParamter("OCR_L",           pickNum(extracted, new String[]{"l", "L"}));
    param.setNamedParamter("OCR_A",           pickNum(extracted, new String[]{"a"}));
    param.setNamedParamter("OCR_B",           pickNum(extracted, new String[]{"b"}));
    param.setNamedParamter("OCR_SG",          pickNum(extracted, new String[]{"sg", "S.G"}));
    // OCR_VIS: 추출값에 '±' 포함된 경우 (예: "350±50") base 만 저장 (WK_VISCO 가 NUMBER(3,0))
    String visRawIns = pickStr(extracted, new String[]{"vis"});
    if (visRawIns != null) {
        int pmIns = visRawIns.indexOf('±'); // ±
        if (pmIns >= 0) visRawIns = visRawIns.substring(0, pmIns);
    }
    BigDecimal visBdIns = null;
    if (visRawIns != null) {
        StringBuffer vbi = new StringBuffer();
        boolean vDoti = false;
        for (int vi = 0; vi < visRawIns.length(); vi++) {
            char vc = visRawIns.charAt(vi);
            if (vc >= '0' && vc <= '9') vbi.append(vc);
            else if (vc == '-' && vbi.length() == 0) vbi.append(vc);
            else if (vc == '.' && !vDoti) { vbi.append(vc); vDoti = true; }
        }
        String vsi = vbi.toString();
        if (vsi.length() > 0 && !"-".equals(vsi) && !".".equals(vsi)) {
            try { visBdIns = new BigDecimal(vsi); } catch (Exception ex) { visBdIns = null; }
        }
    }
    param.setNamedParamter("OCR_VIS",         visBdIns);
    param.setNamedParamter("OCR_MAKER",       pickStr(extracted, new String[]{"maker"}));
    param.setNamedParamter("OCR_WORK_DT",     normDate(pickStr(extracted, new String[]{"workDate"})));
    param.setNamedParamter("OCR_APPROVED_DT", normDate(pickStr(extracted, new String[]{"approvedDate"})));
    param.setNamedParamter("OCR_DISUSED_DT",  normDate(pickStr(extracted, new String[]{"disusedDate"})));
    param.setNamedParamter("OCR_END_USER",    pickStr(extracted, new String[]{"endUser"}));
    String dur = pickStr(extracted, new String[]{"durability"});
    if (dur != null) {
        String du = dur.trim().toUpperCase();
        if (du.startsWith("Y")) dur = "Y";
        else if (du.startsWith("N")) dur = "N";
        else dur = null;
    }
    param.setNamedParamter("OCR_DURABILITY",  dur);
    param.setNamedParamter("OCR_MEMO",        pickStr(extracted, new String[]{"memo"}));
    param.setNamedParamter("OCR_CHARGER",     pickStr(extracted, new String[]{"charger"}));

    param.setNamedParamter("OCR_M2_DE",       pickNum(extracted, new String[]{"minus2DE"}));
    param.setNamedParamter("OCR_M2_DL",       pickNum(extracted, new String[]{"minus2DL"}));
    param.setNamedParamter("OCR_M2_DA",       pickNum(extracted, new String[]{"minus2DA"}));
    param.setNamedParamter("OCR_M2_DB",       pickNum(extracted, new String[]{"minus2DB"}));
    param.setNamedParamter("OCR_P2_DE",       pickNum(extracted, new String[]{"plus2DE"}));
    param.setNamedParamter("OCR_P2_DL",       pickNum(extracted, new String[]{"plus2DL"}));
    param.setNamedParamter("OCR_P2_DA",       pickNum(extracted, new String[]{"plus2DA"}));
    param.setNamedParamter("OCR_P2_DB",       pickNum(extracted, new String[]{"plus2DB"}));

    param.setNamedParamter("ObjectType",      "WEB");
    param.setNamedParamter("ObjectId",        userNo);
    param.setNamedParamter("ProgramId",       "C106000190");

    int ins = dao.insert("C106000190.detail.insert", param);
    if (ins < 0) {
        result.put("success", Boolean.FALSE);
        result.put("message", "OCR 결과 DB INSERT 실패");
        out.print(result.toJSONString());
        return;
    }

    if (rawJsonStr != null && rawJsonStr.length() > 0) {
        // GLUE PosParameter 는 String 을 PreparedStatement.setString() 으로 바인딩하는데,
        // Oracle 11.2 thin 드라이버는 setString 으로 CLOB 에 바인딩 시 32KB(또는 4KB) 에서 잘림 발생.
        // → native JDBC + setCharacterStream(StringReader) 로 직접 바인딩해 전체 길이 저장 보장.
        DataSource _ds2 = ((PosJdbcDao) dao).getDataSource();
        Connection _conn2 = null;
        PreparedStatement _ps2 = null;
        try {
            _conn2 = _ds2.getConnection();
            _ps2 = _conn2.prepareStatement(
                "UPDATE TB_C10_CLR_STD_OCR SET OCR_RAW_JSON = ? WHERE OCR_NO = ?");
            _ps2.setCharacterStream(1, new java.io.StringReader(rawJsonStr), rawJsonStr.length());
            _ps2.setLong(2, ocrNo);
            _ps2.executeUpdate();
        } catch (Exception ce) {
            ce.printStackTrace();
        } finally {
            if (_ps2 != null) try { _ps2.close(); } catch (Exception ignore) {}
            if (_conn2 != null) try { _conn2.close(); } catch (Exception ignore) {}
        }
    }

    // OCR_EXTRACTED_JSON 저장: mapHtmlToFields 가 만든 매핑 결과를 그대로 보존 (사용자 수정 전 자동값).
    // 이후 사용자 SAVE/수정과 비교해 매핑 정확도 측정 근거로 사용.
    // CLOB 절단 회피 위해 native JDBC + setCharacterStream 사용 (OCR_RAW_JSON 와 동일 방식).
    if (extractedJsonStr != null && extractedJsonStr.length() > 0) {
        DataSource _ds3 = ((PosJdbcDao) dao).getDataSource();
        Connection _conn3 = null;
        PreparedStatement _ps3 = null;
        try {
            _conn3 = _ds3.getConnection();
            _ps3 = _conn3.prepareStatement(
                "UPDATE TB_C10_CLR_STD_OCR SET OCR_EXTRACTED_JSON = ? WHERE OCR_NO = ?");
            _ps3.setCharacterStream(1, new java.io.StringReader(extractedJsonStr), extractedJsonStr.length());
            _ps3.setLong(2, ocrNo);
            _ps3.executeUpdate();
        } catch (Exception ce) {
            ce.printStackTrace();
        } finally {
            if (_ps3 != null) try { _ps3.close(); } catch (Exception ignore) {}
            if (_conn3 != null) try { _conn3.close(); } catch (Exception ignore) {}
        }
    }

    result.put("success",    Boolean.TRUE);
    result.put("ocrNo",      new Long(ocrNo));
    result.put("imgFileNm",  origName);
    result.put("imgFilePath",savedFile.getAbsolutePath().replace('\\','/'));
    result.put("imgFileSize",new Long(savedFile.length()));
    result.put("extracted",  extracted);
    out.print(result.toJSONString());

} catch (Throwable e) {
    e.printStackTrace();
    JSONObject err = new JSONObject();
    err.put("success", Boolean.FALSE);
    String cls = (e.getClass() != null) ? e.getClass().getName() : "Throwable";
    err.put("message", "예외 발생: " + cls + " - " + (e.getMessage() == null ? "" : e.getMessage()));
    response.setStatus(200);
    out.print(err.toJSONString());
}
%>
