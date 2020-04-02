<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 전문레이아웃조회
 * Open Issues    :
 * Change history
 * @LastModifyDate: 20060522
 * @Author        : 불명
 * @LastModifier  : 서정범
 * @LastVersion   :  1.2
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    String fac_op_cd = request.getParameter("fac_op_cd")==null||"%".equals(request.getParameter("fac_op_cd"))||"".equals(request.getParameter("fac_op_cd"))?"":request.getParameter("fac_op_cd"); //공장공정코드

    //관리모드인지 조회모드인지 기억
    String sMode=(String)request.getParameter("mode");
    if (sMode==null) sMode = "ret";


%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.085",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/preventRetry.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript">
<!--
function goErrorCheck(){
    if(checkRetry()){
        document.forms[0].action = document.forms[0].action+"?check=10&mode=<%=sMode%>";
        document.forms[0].submit();
    }
}
function saveFAC_OP_CD(){
    var count;
    var kap="";
    if(confirm('<%=PosContext.getResourceMessage("GMResource","gm.msg.0055",null,locale)%>')){//에러체크 기준을 저장하시겠습니까?
        for(count=0;count<document.forms[0].i.length;count++){
          if(document.forms[0].k[count].checked==true){
            kap=kap+String(count+1)+"_"+"G";
          }else if(document.forms[0].i[count].checked==true){
            kap=kap+String(count+1)+"_"+"B";
          }else if(document.forms[0].j[count].checked==true){
            kap=kap+String(count+1)+"_"+"T";
          }else{
            kap=kap+String(count+1)+"_"+"N";
          }
          kap=kap+"|";
        }
        document.forms[0].kap.value=kap;
        document.forms[0].action = document.forms[0].action+"?modify=10&mode=<%=sMode%>";
        document.forms[0].submit();
    }
}
function goExcelImport(){
    showPopup("","m000204020_import",500,450,'1',0,0,1,1,1,0,0);
    document.form_import.target="m000204020_import";
    document.form_import.submit();
}
//BR체크박스클릭시(i)
function onBRclick(sel){
  if(document.forms[0].i[sel].checked==true&document.forms[0].j[sel].checked==true){
    document.forms[0].k[sel].checked=true;
  }else if(document.forms[0].i[sel].checked==false){
    document.forms[0].k[sel].checked=false;
  }
}
//TC체크박스클릭시(j)
function onTCclick(sel){
  if(document.forms[0].i[sel].checked==true&document.forms[0].j[sel].checked==true){
     document.forms[0].k[sel].checked=true;
  }else if(document.forms[0].j[sel].checked==false){
     document.forms[0].k[sel].checked=false;
  }
}
//GT체크박스클릭시(k)
function onGTclick(sel){
  if(document.forms[0].k[sel].checked==true){
     document.forms[0].i[sel].checked=true;
     document.forms[0].j[sel].checked=true;
  }else if(document.forms[0].k[sel].checked==false){
     document.forms[0].i[sel].checked=false;
     document.forms[0].j[sel].checked=false;
  }
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage);setTableIndexNoHeader(mainTable)">
<table width="1000" border="0" cellspacing="0" cellpadding="0">
  <tr id=gm_logo>
    <td><img src="/img/m000001img.gif" width="1000" height="40"></td>
  </tr>
  <tr>
    <td valign=top>
      <table width="1000" border="0" cellspacing="0" cellpadding="0" bgcolor="e5e5e5">
        <tr height="23">
          <td id=gm_BreadCrumbs valign="middle"><!--BreadCrumbs 네비게이션 링크 출력--></td>
          <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
        </tr>
      </table>
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.085",null,locale)%></div></td>
          <td align="right"><img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.attrcheck",null,locale)%>" onClick="goErrorCheck()" style="cursor:pointer"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td valign=top>
<form name="form_tc_detail" method="post" action="m000204020.do" >
<input type="hidden" name="ServiceName" value="m000204020-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">

<input type="hidden" name="mdl_define_id" value="<%=ctx.get("mdl_define_id")%>">

<input type="hidden" name="kap" value="">
<input type="hidden" name="" value="<%=request.getParameter("TbM00Interfaces_MdlDefineNm")%>">
<input type="hidden" name="TbM00Interfaces_FkMdlDefineId" value="<%=request.getParameter("TbM00Interfaces_FkMdlDefineId")%>">
<input type="hidden" name="TbM00Interfaces_MdlDefineId" value="<%=request.getParameter("TbM00Interfaces_MdlDefineId")%>"><!-- TB_M00_INTERFACES -->
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left"><%
    PosRowSet rowSet = (PosRowSet)ctx.get("TB_M00_INTERFACES");
    PosRow row = rowSet.next();
%>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td><img src="img/gm0008img.gif">&nbsp;<b>Format ID</b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name="format_name" value='<%=request.getParameter("format_name")%>' class=adb1 style="width:100px"></td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0213",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name="TbM00Interfaces_MdlDefineNm" value='<%=row.getAttribute("MDL_DEFINE_NM")%>' class=adb1 style="width:100px"></td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0188",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name='dummy' value='<%=row.getAttribute("PROCESS_CHAIN_CODE1")%>' class=adb1 style="width:70px">&nbsp</td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name="dummy" value='<%=row==null||row.getAttribute("MDL_DEFINE_OWNER_EMP_NO")==null?"":(String)row.getAttribute("MDL_DEFINE_OWNER_EMP_NO")%>' class=adb1 style="width:120px">&nbsp</td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0199",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name="dummy" value='<%=row.getAttribute("START_ACTIVE_DATE")%>' class=adb1 style="width:120px"></td>
              </tr>
              <tr>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0214",null,locale)%></b></td>
                <td colspan=3><b>:</b>&nbsp;<input type="text" readonly name="TbM00Interfaces_MdlDefineExplain" value='<%=row.getAttribute("MDL_DEFINE_EXPLAIN")%>' class=adb1 style="width:350px"></td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0171",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name='dummy' value='<%=row.getAttribute("PROCESS_CHAIN_CODE2")%>' class=adb1 style="width:70px">&nbsp</td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0173",null,locale)%></b> </td>
                <td><b>:</b>&nbsp;<input type="text" readonly name='dummy' value="<%=row.getAttribute("LAST_UPDATE_TIMESTAMP")%>" class=adb1 style="width:120px">&nbsp</td>
                <td><img src="img/gm0008img.gif">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0092",null,locale)%></b></td>
                <td><b>:</b>&nbsp;<input type="text" readonly name='dummy' value='<%=row.getAttribute("END_ACTIVE_DATE")%>' class=adb1 style="width:120px"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr height="18">
                <td>
  <img src="img/gm0008img.gif" border="0">&nbsp;<b><%=PosContext.getResourceMessage("GMResource","gm.label.0163",null,locale)%>&nbsp;:&nbsp;</b>
  <posui:showSelectList infoName="TcErrCheckOpCdVOResults" name="fac_op_cd" nameAttribute="FAC_OP_CD" valueAttribute="CD_V_MEANING" totalName="%" totalValue="-- 공  통 --" isRequestFirst="true"/>
  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="document.forms[0].submit()" style="cursor:pointer" align="absmiddle">
                </td>
                <td align="right"><% if(isAdmin){ %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.import",null,locale)%>" onclick="goExcelImport()" style="cursor:pointer"><!-- import -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.save",null,locale)%>" onclick="saveFAC_OP_CD()" style="cursor:pointer"><!-- save --><% } %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onclick="document.form_export.submit()" style="cursor:pointer"><!-- export -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.help",null,locale)%>" style="cursor:pointer"><!-- help -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer">
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align=left valign=top>
            <table width=960 border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF>
              <tr class=tbldb height=18>
                <td rowspan=2 width=3.061%>no.</td>
                <td rowspan=2 width=8.163%><%=PosContext.getResourceMessage("GMResource","gm.label.0155",null,locale)%></td>
                <td rowspan=2 width=24.49%><%=PosContext.getResourceMessage("GMResource","gm.label.0030",null,locale)%></td>
                <td rowspan=2 width=24.49%><%=PosContext.getResourceMessage("GMResource","gm.label.0118",null,locale)%></td>
                <td rowspan=2 width=9.184%><%=PosContext.getResourceMessage("GMResource","gm.label.0222",null,locale)%></td>
                <td rowspan=2 width=5.102%><%=PosContext.getResourceMessage("GMResource","gm.label.0124",null,locale)%></td>
                <td rowspan=2 width=5.102%><%=PosContext.getResourceMessage("GMResource","gm.label.0225",null,locale)%></td>
                <td rowspan=2 width=6.122%><%=PosContext.getResourceMessage("GMResource","gm.label.0125",null,locale)%></td>
                <td colspan=3 width=5.102%><%=PosContext.getResourceMessage("GMResource","gm.label.0088",null,locale)%></td>
              </tr>
              <tr class=tbllb height=18>
                <td width=5.102%><%=PosContext.getResourceMessage("GMResource","gm.label.0034",null,locale)%></td>
                <td width=5.102%>TC</td>
                <td width=4.082%><%=PosContext.getResourceMessage("GMResource","gm.label.0068",null,locale)%></td>
              </tr>
            </table>
            <div style="position:relative;overflow-y:scroll;width:980;height:355;top:0;left:0;">
            <table id=mainTable width=960 border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF><%
                                            PosRowSet GetTCDetailResultsRow = (PosRowSet)ctx.get("GetTCDetailResults");
                                            PosRow row2 = null;
                                            GetTCDetailResultsRow.reset();
                                            int seq=0;
                                            String MdlDefineDtNmGroupTpStr = null;;
                                            while(GetTCDetailResultsRow.hasNext())
                                            {
                                                row2=GetTCDetailResultsRow.next();
                                                MdlDefineDtNmGroupTpStr = row.getAttribute("MDL_DEFINE_DT_NM_GROUP_TP")==null?"&nbsp":(String)row.getAttribute("MDL_DEFINE_DT_NM_GROUP_TP");
                                                if("E".equals(MdlDefineDtNmGroupTpStr))       MdlDefineDtNmGroupTpStr="항목";
                                                else if("G".equals(MdlDefineDtNmGroupTpStr))  MdlDefineDtNmGroupTpStr="그룹";
                                                else if("GE".equals(MdlDefineDtNmGroupTpStr)) MdlDefineDtNmGroupTpStr="그룹항목";
%>
              <tr class=<%= seq%2==0?"tblcg":"tblcw"%> height=18>
                <td index=<%=seq%> id=a width=30><%= row2.getAttribute("MDL_DEFINE_DT_NM_SEQ")%></td>
                <td index=<%=seq%> id=b width=80><%= MdlDefineDtNmGroupTpStr %></td>
                <td index=<%=seq%> id=c width=240><%= row2.getAttribute("STANDARD_KOREAN_NAME")%></td>
                <td index=<%=seq%> id=d width=240><%= row2.getAttribute("STANDARD_ENGLISH_ID")%></td>
                <td index=<%=seq%> id=e width=90><%= row2.getAttribute("DATA_TP")%></td>
                <td index=<%=seq%> id=f width=50><%= row2.getAttribute("MDL_DEFINE_DT_NM_LEN")%></td>
                <td index=<%=seq%> id=g width=50><%= row2.getAttribute("DT_NM_UOM_CD")==null?"&nbsp;":row2.getAttribute("DT_NM_UOM_CD")%></td>
                <td index=<%=seq%> id=h width=60><%= row2.getAttribute("MDL_DEFINE_DT_NM_V_DECI_PREC")%></td><% if(isAdmin){ %>
                <td index=<%=seq%> width=50><input type="checkbox" name=i value='<%= row2.getAttribute("BR_CHECK_FLAG") %>' onClick='onBRclick(this.parentElement.index)' <%= (Integer.parseInt(row2.getAttribute("BR_CHECK_FLAG").toString())==0?"":"checked")%>></td>
                <td index=<%=seq%> width=50><input type="checkbox" name=j value='<%= row2.getAttribute("BL_CHECK_FLAG") %>' onClick='onTCclick(this.parentElement.index)' <%= (Integer.parseInt(row2.getAttribute("BL_CHECK_FLAG").toString())==0?"":"checked")%>></td>
                <td index=<%=seq%> width=40><input type="checkbox" name=k value='<%= row2.getAttribute("ALL_CHECK_FLAG")%>' onClick='onGTclick(this.parentElement.index)' <%= (Integer.parseInt(row2.getAttribute("ALL_CHECK_FLAG").toString())==0?"":"checked")%>></td><% }else { %>
                <td index=<%=seq%> width=50><input type="checkbox" name=i value='<%= row2.getAttribute("BR_CHECK_FLAG") %>' disabled <%= (Integer.parseInt(row2.getAttribute("BR_CHECK_FLAG").toString())==0?"":"checked")%>></td>
                <td index=<%=seq%> width=50><input type="checkbox" name=j value='<%= row2.getAttribute("BL_CHECK_FLAG") %>' disabled <%= (Integer.parseInt(row2.getAttribute("BL_CHECK_FLAG").toString())==0?"":"checked")%>></td>
                <td index=<%=seq%> width=40><input type="checkbox" name=k value='<%= row2.getAttribute("ALL_CHECK_FLAG")%>' disabled <%= (Integer.parseInt(row2.getAttribute("ALL_CHECK_FLAG").toString())==0?"":"checked")%>></td><% } %>
              </tr><%
                                                seq++;
                                            }
%>
            </table>
            </div>
          </td>
        </tr>
      </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
<form name="form_import" method="post" action="m000204020.do"><!-- import -->
<input type="hidden" name="ServiceName" value="m000204020-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="import" value="10"><!-- event -->
</form>
<form name="form_export" method="post" action="m000204020.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000204020-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
<input type="hidden" name="TbM00Interfaces_FkMdlDefineId" value="<%=request.getParameter("TbM00Interfaces_FkMdlDefineId")%>">
<input type="hidden" name="TbM00Interfaces_MdlDefineId" value="<%=request.getParameter("TbM00Interfaces_FkMdlDefineId")%>">
<input type="hidden" name="TbM00Interfaces_MdlDefineNm" value="<%=request.getParameter("TbM00Interfaces_MdlDefineNm")%>">
<input type="hidden" name="fac_op_cd" value="<%=fac_op_cd%>">
</form>
    </td>
  </tr>
</table>
</body>
</html>