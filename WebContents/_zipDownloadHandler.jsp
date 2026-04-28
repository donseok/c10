<%@page import="java.net.URLEncoder"%>
<%@ page contentType="application/octet-stream; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.zip.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%
/*
 * @FileName      : _zipDownloadHandler.jsp
 * @Description   : 첨부파일 전체 ZIP 다운로드
 * @CreateDate    : 2026.03.13
 * @Creator       : SJS
 */

String filesJson = request.getParameter("FILES_JSON");
String zipName   = request.getParameter("ZIP_NAME");
if (zipName == null || "".equals(zipName)) zipName = "files";

response.reset();
response.setContentType("application/octet-stream");
String encodedZipName = URLEncoder.encode(zipName + ".zip", "UTF-8").replaceAll("\\+", "%20");
response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedZipName);

ZipOutputStream zos = null;
try {
    zos = new ZipOutputStream(response.getOutputStream());
    zos.setLevel(ZipOutputStream.DEFLATED);

    if (filesJson != null && !"".equals(filesJson)) {
        JSONParser parser = new JSONParser();
        JSONArray arr = (JSONArray) parser.parse(filesJson);

        Set<String> usedNames = new HashSet<String>();

        for (int i = 0; i < arr.size(); i++) {
            JSONObject obj = (JSONObject) arr.get(i);
            String fileAdr = (String) obj.get("IMG_ADR");
            String fileNm  = (String) obj.get("IMG_NM");

            if (fileAdr == null || fileNm == null) continue;

            File f = new File(fileAdr, fileNm);
            if (!f.exists() || !f.isFile()) continue;

            // 중복 파일명 처리
            String entryName = fileNm;
            if (usedNames.contains(entryName)) {
                int dotIdx = entryName.lastIndexOf(".");
                String base = dotIdx > 0 ? entryName.substring(0, dotIdx) : entryName;
                String ext  = dotIdx > 0 ? entryName.substring(dotIdx) : "";
                int cnt = 1;
                while (usedNames.contains(entryName)) {
                    entryName = base + "_" + cnt + ext;
                    cnt++;
                }
            }
            usedNames.add(entryName);

            zos.putNextEntry(new ZipEntry(entryName));
            FileInputStream fis = new FileInputStream(f);
            byte[] buffer = new byte[4096];
            int len;
            while ((len = fis.read(buffer)) > 0) {
                zos.write(buffer, 0, len);
            }
            fis.close();
            zos.closeEntry();
        }
    }
    zos.flush();
    zos.close();
    out.clear();
    out = pageContext.pushBody();
} catch (Exception e) {
    e.printStackTrace();
}
%>
