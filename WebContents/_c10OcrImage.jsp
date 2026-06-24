<%--
 * PROGRAM NAME : _c10OcrImage.jsp
 * DESCRIPTION  : C106000190 OCR 이미지 인라인 스트리밍 (img 태그용)
 *                /APP/WAS/FILES/C10/clr_std_ocr 하위만 허용 (path traversal 차단)
 * PARAMS       : ocrNo (TB_C10_CLR_STD_OCR.OCR_NO)
--%>
<%@ page contentType="image/png" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.io.*, java.math.BigDecimal" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.PosGenericDao" %>
<%@ page import="com.posdata.glue.dao.vo.PosParameter" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%
    String ocrNoStr = request.getParameter("ocrNo");
    if (ocrNoStr == null || ocrNoStr.length() == 0) { response.sendError(400); return; }
    BigDecimal ocrNo;
    try { ocrNo = new BigDecimal(ocrNoStr); } catch (Exception e) { response.sendError(400); return; }

    String allowedRoot = application.getInitParameter("c10.upstage.uploadDir");
    if (allowedRoot == null || allowedRoot.length() == 0) allowedRoot = "/APP/WAS/FILES/C10/clr_std_ocr/";

    PosGenericDao dao = (PosGenericDao) PosContext.getBeanFactory().getBeanObject("mesdao");
    PosParameter p = new PosParameter();
    p.setNamedParamter("OCR_NO", ocrNo);
    PosRowSet rs = dao.find("C106000190.detail.select", p);
    if (!rs.hasNext()) { response.sendError(404); return; }
    PosRow row = rs.next();

    String imgPath = (String) row.getAttribute("IMG_FILE_PATH");
    String imgName = (String) row.getAttribute("IMG_FILE_NM");
    if (imgPath == null || imgPath.length() == 0) { response.sendError(404); return; }

    String normalized = imgPath.replace('\\','/');
    String allowedNorm = allowedRoot.replace('\\','/');
    if (!normalized.startsWith(allowedNorm)) { response.sendError(403); return; }

    File f = new File(imgPath);
    if (!f.exists() || !f.isFile()) { response.sendError(404); return; }

    String lower = (imgName != null) ? imgName.toLowerCase() : "";
    String ct = "image/png";
    if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) ct = "image/jpeg";
    else if (lower.endsWith(".gif")) ct = "image/gif";
    else if (lower.endsWith(".bmp")) ct = "image/bmp";
    else if (lower.endsWith(".webp")) ct = "image/webp";

    response.reset();
    response.setHeader("Content-Type", ct);
    response.setHeader("Cache-Control", "private, max-age=600");
    response.setContentLength((int) f.length());

    BufferedInputStream in = new BufferedInputStream(new FileInputStream(f));
    OutputStream os = response.getOutputStream();
    try {
        byte[] buf = new byte[8192];
        int n;
        while ((n = in.read(buf)) > 0) os.write(buf, 0, n);
        os.flush();
    } finally {
        try { in.close(); } catch (Exception e) {}
    }
%>