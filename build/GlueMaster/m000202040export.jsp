<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 업무기준 목록 >> 업무기준 기본속성 등록 >> 업무기준 레이아웃 수정 >> 업무기준 데이터 조회(일반)(Export)
 *                  업무기준 목록 >> 업무기준 기본속성 등록 >> 업무기준 데이터 조회(일반)(Export)
 *                  업무기준 목록 >> 업무기준 내용상세_일반기준(Export)
 * Open Issues    :
 * Change history 
 * @LastModifyDate: 20080318
 * @Author        : 설계자 
 * @LastModifier  : 류진영
 * @LastVersion   :  1.1
 *    2008-03-18   류진영
 *        1.0      최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    PosRowSet rowSet = (PosRowSet)ctx.get("Defind010HeaderRowResult");
    PosRow headerRow = rowSet.next();

    rowSet = (PosRowSet)ctx.get("Defind020DataLayoutRowResult");
    PosRow row;

    int inputCnt=0;
    int outputCnt=0;
    ArrayList fixFiled = new ArrayList();
    ArrayList unFixFiled = new ArrayList();
    ArrayList fixFiledId = new ArrayList();
    ArrayList unFixFiledId = new ArrayList();
    String filedName = "";
    String aliasName = "";
    while(rowSet.hasNext())
    {
        row = rowSet.next();
        /********************* 출력할 java필드명을 생성한다***************/
        filedName = row.getAttribute("MDL_DEFINE_DT_NM_DRIVED_V_PROC").toString();
        /* Title로 쓰일 한글명을 추출한다*/
        aliasName = row.getAttribute("MDL_DEFINE_DT_NM_ALIAS")==null?(String)row.getAttribute("STANDARD_KOREAN_NAME"):(String)row.getAttribute("MDL_DEFINE_DT_NM_ALIAS");
        if(row.getAttribute("OLSTATR_NM")!=null)
        {
            aliasName = aliasName +"("+ (String)row.getAttribute("OLSTATR_NM") +")"; 
        }
        /********************* 고정시킬 필드들을 가져온다***************/
        if(("Y".equals(row.getAttribute("MDL_DEFINE_DT_NM_KEY_F"))))
        {
            fixFiledId.add(filedName);
            fixFiled.add(aliasName);
            inputCnt++;
        }else
        {
            unFixFiledId.add(filedName);
            unFixFiled.add(aliasName);
            outputCnt++;
        }
    }

    StringBuffer serverIP = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath()).append("/");
    response.setHeader("Content-Disposition", "attachment;filename=RuleData("+headerRow.getAttribute("MDL_DEFINE_NM")+").xls");
    out.clearBuffer();

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.054",null,locale)%> [export]</title>
<link rel="stylesheet" href="<%=serverIP%>css/pub.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
  <table border=1>
    <tr class=tbldb>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%></td>
      <td><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></td>
      <td colspan="2"><%=PosContext.getResourceMessage("GMResource","gm.label.0185",null,locale)%></td>
    </tr>
    <tr align=center>
      <td class="xls"><%=headerRow.getAttribute("MDL_DEFINE_NM")%></td>
      <td class="xls"><%=headerRow.getAttribute("MDL_DEFINE_VERSION")%></td>
      <td class="xls"><%=headerRow.getAttribute("MASTER_DATA_PRC_TP")%></td>
      <td class="xls"><%=headerRow.getAttribute("USE_TP")%></td>
      <td class="xls"><%=headerRow.getAttribute("START_ACTIVE_DATE_STR")%></td>
      <td class="xls" colspan="2"><%=headerRow.getAttribute("MDL_DEFINE_EXPLAIN")%></td>
    </tr>
  </table>
  <table border=1>
    <tr class=tbldb>
      <td rowspan=2>no.</td>
      <td colspan=<%=inputCnt%>><%=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale)%></td>
      <td colspan=<%=outputCnt%>><%=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale)%></td>
    </tr>
    <tr class=tbllb><%  for(int i=0;i<fixFiled.size();i++){   %>
      <td><%= fixFiled.get(i)%></td><%  }%><%  for(int i=0;i<unFixFiled.size();i++){   %>
      <td><%= unFixFiled.get(i)%></td><%  }%>
    </tr><%
    rowSet = (PosRowSet)ctx.get("Datas010RowResult");
    if(rowSet!=null){
        int rowCnt = 0;
        while(rowSet.hasNext()){
            row = rowSet.next();
%>
    <tr class="<%= (rowCnt%2==0) ? "tbllw" : "tbllg" %>"><%
            if("-1".equals(row.getAttribute("MD_MRG_BAS_DATA_SEQ").toString())){
%>
      <td class="xls">-1</td><%
            }else{
%>
      <td class="xls"><%=rowCnt+1%></td><%
                rowCnt++;
            }
            for(int i=0;i<fixFiled.size();i++){   %>
      <td class="xls"><%= row.getAttribute((String)fixFiledId.get(i)  )==null?"":row.getAttribute((String)fixFiledId.get(i)  ).toString()%></td><%
            }
            for(int i=0;i<unFixFiled.size();i++){
%>
      <td class="xls"><%= row.getAttribute((String)unFixFiledId.get(i))==null?"":row.getAttribute((String)unFixFiledId.get(i)).toString()%></td><%
            }
%>
    </tr><%
        }
    }
%>
  </table>
  <table>
    <tr>
      <td>END!</td>
    </tr>
  </table><br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0112",null,locale)%></b> ※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.msg.0094",null,locale)%> </b>※<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%> : </b>
<b>S</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale)%>)
<b>F</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale)%>)
<b>Y</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%>)
<b>N</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%>)<br>
※ <b><%=PosContext.getResourceMessage("GMResource","gm.label.0006",null,locale)%> : </b>
<b>1A0</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0105",null,locale)%>)
<b>1A1</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0137",null,locale)%>)
<b>1A2</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0075",null,locale)%>)
<b>1B0</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0191",null,locale)%>)
<b>1B1</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0151",null,locale)%>)<br>
※ <b>no. : </b>
<b>-1</b>(<%=PosContext.getResourceMessage("GMResource","gm.label.0091",null,locale)%>), 1,2,3.. data 순서<br>
※ <b>DATE TYPE 항목 : </b> yyyymmddhhmiss 형태의 문자열로 입력할것.
</BODY>
</HTML>