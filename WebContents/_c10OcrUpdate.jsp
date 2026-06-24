<%--
 * PROGRAM NAME : _c10OcrUpdate.jsp
 * DESCRIPTION  : C106000190 OCR 확정값 UPDATE (PROC_STS_CD='A' 확정)
 * METHOD       : POST (application/x-www-form-urlencoded)
--%>
<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.PosGenericDao" %>
<%@ page import="com.posdata.glue.dao.vo.PosParameter" %>
<%@ page import="com.posdata.glue.web.security.PosUser" %>
<%@ page import="com.posdata.glue.web.security.PosSecurityConstants" %>
<%!
    private static String s(javax.servlet.http.HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        if (v == null) return null;
        v = v.trim();
        if (v.length() == 0) return null;
        return v;
    }
    private static BigDecimal n(javax.servlet.http.HttpServletRequest req, String name) {
        String v = s(req, name);
        if (v == null) return null;
        StringBuffer b = new StringBuffer();
        boolean dotSeen = false;
        for (int i = 0; i < v.length(); i++) {
            char c = v.charAt(i);
            if (c >= '0' && c <= '9') b.append(c);
            else if (c == '-' && b.length() == 0) b.append(c);
            else if (c == '.' && !dotSeen) { b.append(c); dotSeen = true; }
        }
        String t = b.toString();
        if (t.length() == 0 || "-".equals(t) || ".".equals(t)) return null;
        try { return new BigDecimal(t); } catch (Exception e) { return null; }
    }
%>
<%
request.setCharacterEncoding("UTF-8");
JSONObject result = new JSONObject();
try {
    response.setHeader("Cache-Control", "no-store");

    String ocrNoStr = s(request, "OCR_NO");
    if (ocrNoStr == null) {
        result.put("success", Boolean.FALSE);
        result.put("message", "OCR_NO required");
        out.print(result.toJSONString());
        return;
    }

    PosUser user = (PosUser) session.getAttribute(PosSecurityConstants.USER);
    String userNo = (user != null) ? (String) user.getUserInfo("USER_NO") : "SYSTEM";

    PosGenericDao dao = (PosGenericDao) PosContext.getBeanFactory().getBeanObject("mesdao");
    PosParameter p = new PosParameter();
    p.setNamedParamter("OCR_NO",          new BigDecimal(ocrNoStr));
    p.setNamedParamter("OCR_CODE",        s(request, "OCR_CODE"));
    p.setNamedParamter("OCR_TYPE",        s(request, "OCR_TYPE"));
    p.setNamedParamter("OCR_QT_TYPE",     s(request, "OCR_QT_TYPE"));
    p.setNamedParamter("OCR_MUNSELL",     s(request, "OCR_MUNSELL"));
    p.setNamedParamter("OCR_GLOSS",       n(request, "OCR_GLOSS"));
    p.setNamedParamter("OCR_PRIMER",      s(request, "OCR_PRIMER"));
    p.setNamedParamter("OCR_DFT_1C",      n(request, "OCR_DFT_1C"));
    p.setNamedParamter("OCR_DFT_2C",      n(request, "OCR_DFT_2C"));
    p.setNamedParamter("OCR_DFT_3C",      n(request, "OCR_DFT_3C"));
    p.setNamedParamter("OCR_COLOR",       s(request, "OCR_COLOR"));
    p.setNamedParamter("OCR_UNFIXED_NO",  s(request, "OCR_UNFIXED_NO"));
    p.setNamedParamter("OCR_DELTA_E",     n(request, "OCR_DELTA_E"));
    p.setNamedParamter("OCR_NV",          n(request, "OCR_NV"));
    p.setNamedParamter("OCR_L",           n(request, "OCR_L"));
    p.setNamedParamter("OCR_A",           n(request, "OCR_A"));
    p.setNamedParamter("OCR_B",           n(request, "OCR_B"));
    p.setNamedParamter("OCR_SG",          n(request, "OCR_SG"));
    // OCR_VIS: 폼에서 "350±50" 형태로 와도 ± 뒷부분은 무시 (NUMBER 컬럼 + WK_VISCO 는 NUMBER(3,0))
    String visRaw = s(request, "OCR_VIS");
    if (visRaw != null) {
        int pmIdx = visRaw.indexOf('±'); // ±
        if (pmIdx >= 0) visRaw = visRaw.substring(0, pmIdx);
    }
    java.math.BigDecimal visBd = null;
    if (visRaw != null) {
        StringBuffer vb = new StringBuffer();
        boolean vDot = false;
        for (int vi = 0; vi < visRaw.length(); vi++) {
            char vc = visRaw.charAt(vi);
            if (vc >= '0' && vc <= '9') vb.append(vc);
            else if (vc == '-' && vb.length() == 0) vb.append(vc);
            else if (vc == '.' && !vDot) { vb.append(vc); vDot = true; }
        }
        String vs = vb.toString();
        if (vs.length() > 0 && !"-".equals(vs) && !".".equals(vs)) {
            try { visBd = new java.math.BigDecimal(vs); } catch (Exception ex) { visBd = null; }
        }
    }
    p.setNamedParamter("OCR_VIS",         visBd);
    p.setNamedParamter("OCR_MAKER",       s(request, "OCR_MAKER"));
    p.setNamedParamter("OCR_WORK_DT",     s(request, "OCR_WORK_DT"));
    p.setNamedParamter("OCR_APPROVED_DT", s(request, "OCR_APPROVED_DT"));
    p.setNamedParamter("OCR_DISUSED_DT",  s(request, "OCR_DISUSED_DT"));
    p.setNamedParamter("OCR_END_USER",    s(request, "OCR_END_USER"));
    p.setNamedParamter("OCR_DURABILITY",  s(request, "OCR_DURABILITY"));
    p.setNamedParamter("OCR_MEMO",        s(request, "OCR_MEMO"));
    p.setNamedParamter("OCR_CHARGER",     s(request, "OCR_CHARGER"));
    p.setNamedParamter("OCR_M2_DE",       n(request, "OCR_M2_DE"));
    p.setNamedParamter("OCR_M2_DL",       n(request, "OCR_M2_DL"));
    p.setNamedParamter("OCR_M2_DA",       n(request, "OCR_M2_DA"));
    p.setNamedParamter("OCR_M2_DB",       n(request, "OCR_M2_DB"));
    p.setNamedParamter("OCR_P2_DE",       n(request, "OCR_P2_DE"));
    p.setNamedParamter("OCR_P2_DL",       n(request, "OCR_P2_DL"));
    p.setNamedParamter("OCR_P2_DA",       n(request, "OCR_P2_DA"));
    p.setNamedParamter("OCR_P2_DB",       n(request, "OCR_P2_DB"));
    p.setNamedParamter("ObjectType",      "WEB");
    p.setNamedParamter("ObjectId",        userNo);
    p.setNamedParamter("ProgramId",       "C106000190");
    p.setNamedParamter("Timestamp",       new java.util.Date());

    int rows = dao.update("C106000190.detail.update", p);
    if (rows <= 0) {
        result.put("success", Boolean.FALSE);
        result.put("message", "UPDATE 영향 행 수=" + rows + " (OCR_NO=" + ocrNoStr + " 존재 여부 확인 필요)");
        result.put("rowsAffected", new Integer(rows));
    } else {
        result.put("success", Boolean.TRUE);
        result.put("rowsAffected", new Integer(rows));
    }
    out.print(result.toJSONString());
} catch (Throwable e) {
    e.printStackTrace();
    JSONObject err = new JSONObject();
    err.put("success", Boolean.FALSE);
    err.put("message", e.getMessage() == null ? e.getClass().getName() : e.getMessage());
    out.print(err.toJSONString());
}
%>
