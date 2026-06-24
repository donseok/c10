<%--
 * PROGRAM NAME : _c10OcrDetail.jsp
 * DESCRIPTION  : C106000190 OCR 단건 JSON 조회 (Form 채우기용)
 * PARAMS       : ocrNo
--%>
<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.PosGenericDao" %>
<%@ page import="com.posdata.glue.dao.vo.PosParameter" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%
JSONObject result = new JSONObject();
try {
    response.setHeader("Cache-Control", "no-store");
    String ocrNoStr = request.getParameter("ocrNo");
    if (ocrNoStr == null || ocrNoStr.length() == 0) ocrNoStr = request.getParameter("OCR_NO");
    if (ocrNoStr == null || ocrNoStr.length() == 0) {
        result.put("success", Boolean.FALSE);
        result.put("message", "ocrNo parameter required");
        out.print(result.toJSONString());
        return;
    }
    BigDecimal ocrNo = new BigDecimal(ocrNoStr);

    PosGenericDao dao = (PosGenericDao) PosContext.getBeanFactory().getBeanObject("mesdao");
    PosParameter p = new PosParameter();
    p.setNamedParamter("OCR_NO", ocrNo);
    PosRowSet rs = dao.find("C106000190.detail.select", p);
    if (!rs.hasNext()) {
        result.put("success", Boolean.FALSE);
        result.put("message", "OCR data not found: OCR_NO=" + ocrNoStr);
        out.print(result.toJSONString());
        return;
    }
    PosRow row = rs.next();

    String[] cols = new String[]{
        "OCR_NO", "PROC_STS_CD", "IMG_FILE_NM", "IMG_FILE_PATH", "CLR_SUB_MTL_CD",
        "OCR_CODE", "OCR_TYPE", "OCR_QT_TYPE", "OCR_MUNSELL", "OCR_GLOSS", "OCR_PRIMER",
        "OCR_DFT_1C", "OCR_DFT_2C", "OCR_DFT_3C", "OCR_COLOR", "OCR_UNFIXED_NO",
        "OCR_DELTA_E", "OCR_NV", "OCR_L", "OCR_A", "OCR_B", "OCR_SG", "OCR_VIS",
        "OCR_MAKER", "OCR_WORK_DT", "OCR_APPROVED_DT", "OCR_DISUSED_DT",
        "OCR_END_USER", "OCR_DURABILITY", "OCR_MEMO", "OCR_CHARGER",
        "OCR_M2_DE", "OCR_M2_DL", "OCR_M2_DA", "OCR_M2_DB",
        "OCR_P2_DE", "OCR_P2_DL", "OCR_P2_DA", "OCR_P2_DB"
    };
    for (int i = 0; i < cols.length; i++) {
        Object v = row.getAttribute(cols[i]);
        result.put(cols[i], v == null ? null : v.toString());
    }
    result.put("success", Boolean.TRUE);
    out.print(result.toJSONString());
} catch (Throwable e) {
    e.printStackTrace();
    JSONObject err = new JSONObject();
    err.put("success", Boolean.FALSE);
    err.put("message", e.getMessage() == null ? e.getClass().getName() : e.getMessage());
    out.print(err.toJSONString());
}
%>
