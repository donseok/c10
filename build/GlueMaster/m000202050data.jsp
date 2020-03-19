<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.poscoict.glue.master.common.PosMasterUtility" %>
<%@ page import="com.poscoict.glue.master.ui.rule.etc.PosMatrixRuleData" %>
<%@ page import="com.poscoict.glue.master.ui.rule.etc.PosRuleData" %>
<%@ page import="com.poscoict.glue.master.ui.rule.etc.PosRuleItemStruct" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 메트릭스 기준 입력
 * Open Issues    :
 * Change history 
 * @2008-06-23 김찬오 #1.0   최초 생성
 * @2012-08-09 황유진 #1.4.2 HIERARCHY_OP_TP,HIERARCHY_OWNER_SHIP_TP 출력방식 변경 
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    boolean isAdmin = Boolean.parseBoolean(request.getParameter("isAdmin"));

    boolean isError = ctx.getExceptionMessage()!=null; //<posui:showMessage/>
    String errorMsg = isError ? ctx.getExceptionMessage() : "";

    // Caching Data
    List HierarchyOpTpList = (List) ctx.get("HIERARCHY_OP_TP");
    HashMap<String, String> HierarchyOpTpMap = new HashMap<String, String>();
    for (int i = 0, iz = HierarchyOpTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOpTpList.get(i);
        HierarchyOpTpMap.put(value[0], value[1]);
    }
    List HierarchyOwnerShipTpList = (List) ctx.get("HIERARCHY_OWNER_SHIP_TP");
    HashMap<String, String> HierarchyOwnerShipTpMap = new HashMap<String, String>();
    for (int i = 0, iz = HierarchyOwnerShipTpList.size(); i < iz; i++) {
        String[] value = (String[]) HierarchyOwnerShipTpList.get(i);
        HierarchyOwnerShipTpMap.put(value[0], value[1]);
    }

    PosRowSet rowset = (PosRowSet)ctx.get("Defind010HeaderRowResult");
    PosRow headerRow = rowset.next();
    String UseTp = (String)headerRow.getAttribute("USE_TP");
    String MasterDataPrcTp = (String)headerRow.getAttribute("MASTER_DATA_PRC_TP");
    String MasterDataPrcTpStr = "";
    if("1A0".equals(MasterDataPrcTp))      MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0105",null,locale);
    else if("1A1".equals(MasterDataPrcTp)) MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0137",null,locale);
    else if("1A2".equals(MasterDataPrcTp)) MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0075",null,locale);

    PosMatrixRuleData   posMatrixRuleData       =   (PosMatrixRuleData)ctx.get("MatrixRuleData");
    HashMap             mapHeigthDbFiled        =   posMatrixRuleData.getHeigthDbFiled();
    HashMap             mapWidthDbFiled         =   posMatrixRuleData.getWidthDbFiled();
    HashMap             mapDataDbFiled          =   posMatrixRuleData.getDataDbFiled();
    ArrayList           arryHeightRecordeData   =   posMatrixRuleData.getHeightRecordeData(); 
    ArrayList           arryWidthRecordeData    =   posMatrixRuleData.getWidthRecordeData(); 
    PosRuleData         posRuleData             =   null;
    PosRuleItemStruct   posRuleItemStruct       =   null;
    int                 fixFiledTotalLength     =   0;
    int                 unFixFiledTotalLength   =   0;
    int                 totalLength             =   0;
    int                 length                  =   0;
    double              ratio                   =   0.0;
    String              dbFiledName             =   "";
    String              tmpFiledName            =   "";
    String              javaFiledName           =   "";
    String[]            tmpDatas                =   null; 
    String[]            tmpHeightDatas          =   null;
    String[]            tmpWidthDatas           =   null;
    String              sModifyYn               =   "";
    int                 scrollLen               =   0;

    if(arryHeightRecordeData.size()>16){
        scrollLen=0;
    }else{
        scrollLen=20;
    }
    /* 높이의 총 넓이를 계산한다*/ 
    for(int i=0;i<mapHeigthDbFiled.size();i++){
        dbFiledName       = (String)mapHeigthDbFiled.get(String.valueOf(i+1));
        posRuleItemStruct = (PosRuleItemStruct)posMatrixRuleData.getItemStruct(dbFiledName);
        if(posRuleItemStruct.getDtNmNm().getBytes().length>posRuleItemStruct.getLength()){
            length=posRuleItemStruct.getDtNmNm().getBytes().length*8;
        }else{
            length=posRuleItemStruct.getLength()*8;
        }
        posRuleItemStruct.setRatioLength(length);
        fixFiledTotalLength=fixFiledTotalLength+length;
    }


    /* 넓이의 총 넓이를 계산한다*/
    dbFiledName           = (String)mapDataDbFiled.get(String.valueOf(posMatrixRuleData.getDataCnt()));
    posRuleItemStruct   = (PosRuleItemStruct)posMatrixRuleData.getItemStruct(dbFiledName);

    if(posRuleItemStruct.getDtNmNm().getBytes().length>posRuleItemStruct.getLength()){
        length=posRuleItemStruct.getDtNmNm().getBytes().length*8;
    }else{
        length=posRuleItemStruct.getLength()*8;
    }

    if(length<40){
        length=40;
    }

    for(int i=0;i<arryWidthRecordeData.size();i++){
        for(int j=0;j<posMatrixRuleData.getDataCnt();j++){
            unFixFiledTotalLength=unFixFiledTotalLength+length;
        }
    }

    /* 레코드별 권한, 체크박스가 들어가는 크기를 더한다*/
    fixFiledTotalLength=fixFiledTotalLength+60;
    unFixFiledTotalLength=unFixFiledTotalLength+(arryWidthRecordeData.size()*30);


    /* 총 넓이를 구한다*/
    totalLength=fixFiledTotalLength+unFixFiledTotalLength;


    /* 화면에 출력할 비율을 구한다*/
    if(totalLength<968){
        ratio=(968/(double)totalLength);
    }else{
        ratio=1.0;
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.057",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript" src="js/messcript.js"></script>
<script type="text/javascript">
<!--
function goLayout(){
    document.forms[0].action="m000202030.do<%="S".equals(UseTp)?"?inputLayout=10":""%>";
    document.forms[0].ServiceName.value="m000202030-service";
    document.forms[0].submit();
}
function goVersion(){
    document.form_rule_hitory.target = "_self";
    document.form_rule_hitory.submit();
}
function goImport(){
    document.form_import.MdlDefineNm.value="<%=headerRow.getAttribute("MDL_DEFINE_NM")%>";
    showPopup("","m000202050_import",500,450,'1',0,0,1,1,1,0,0);
    document.form_import.target="m000202050_import";
    document.form_import.submit();
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onload="done_message(document.forms[0].alertMessage)">
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.057",null,locale)%></div></td>
          <td align="right">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.layout",null,locale)%>" onClick="goLayout()" style="cursor:pointer">
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.blue.img.history",null,locale)%>" onClick="goVersion()" style="cursor:pointer">
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td valign=top>
<form name="form_rule_data" method="post" action="m000202050.do"><!-- m000202010.do,m000202030.do -->
<input type="hidden" name="ServiceName" value="m000202050-service"><!-- m000202010-service,m000202030-service -->
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="LstUpdByIp" value="<%=request.getRemoteAddr()%>">
<input type="hidden" name="MdlDefineId" value="<%=headerRow.getAttribute("MDL_DEFINE_ID")%>">
<input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>">
<input type="hidden" name="modifyFlag" value="true">
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr> 
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td>
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></td>
                <td class=tbllw><input type="text" value="<%=(String)headerRow.getAttribute("MDL_DEFINE_NM")%>" style="width:120" class=adg1 readonly></td>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0036",null,locale)%></td>
                <td class=tbllw width=190><input type="text" value="<%=(String)headerRow.getAttribute("MDL_DEFINE_EXPLAIN")%>" style="width:180" class=adg1 readonly></td>
                <td class=tbldb width=140><%=PosContext.getResourceMessage("GMResource","gm.label.0262",null,locale)%></td>
                <td class=tbllw width=200><input type="text" value="<%=MasterDataPrcTpStr%>" style="width:150" class=adg1 readonly></td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0215",null,locale)%></td>
                <td class=tbllw colspan=3>
                  <input type="text" name="StartActiveDate" value="<%=(String)headerRow.getAttribute("START_ACTIVE_DATE_STR")%>" style="width:120" class=adg1 readonly> ~
                  <input type="text" name="EndActiveDate" value="<%=headerRow.getAttribute("END_ACTIVE_DATE_STR")==null?"2999-12-31 23:59:59":(String)headerRow.getAttribute("END_ACTIVE_DATE_STR")%>" style="width:120" class=adg1 readonly>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0232",null,locale)%>/<%=PosContext.getResourceMessage("GMResource","gm.label.0227",null,locale)%>/<%=PosContext.getResourceMessage("GMResource","gm.label.0106",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=(String)headerRow.getAttribute("MDL_DEFINE_VERSION")%>" style="width:50" class=adg1 readonly><%
    if("Y".equals(UseTp)){
%>
                  <select name="UseTp" class="adf">
                    <option value="Y" <%="Y".equals(UseTp)?"selected":""%>>[Y]<%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%></option>
                  </select><%
    }else if("N".equals(UseTp)){
%>
                  <select name="UseTp" class="adf">
                    <option value="N" <%="N".equals(UseTp)?"selected":""%>>[N]<%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%></option>
                  </select><%
    }else{
%>
                  <select name="UseTp" class="adf">
                    <option value="S" <%="S".equals(UseTp)?"selected":""%>>[S]<%=PosContext.getResourceMessage("GMResource","gm.label.0114",null,locale)%></option>
                    <option value="F" <%="F".equals(UseTp)?"selected":""%>>[F]<%=PosContext.getResourceMessage("GMResource","gm.label.0175",null,locale)%></option>
                    <option value="Y" <%="Y".equals(UseTp)?"selected":""%>>[Y]<%=PosContext.getResourceMessage("GMResource","gm.label.0032",null,locale)%></option>
                  </select><%
    }
%>
                  <input type="text" value="<%=(String)headerRow.getAttribute("MDL_DEFINE_CNG_GD")%>" style="width:50" class=adg1 readonly>
                </td>
              </tr>
              <tr height=20>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0161",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=headerRow.getAttribute("MDL_DEFINE_OWNER_EMP_NO")%>" style="width:70" class=adg1 readonly>
                  (<input type="text" value="<%=headerRow.getAttribute("USER_NAME")%>" style="width:100" class=adg1 readonly>)
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0083",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=HierarchyOwnerShipTpMap.get((String)headerRow.getAttribute("HIERARCHY_OWNER_SHIP_TP"))%>" style="width:50" class=adg1 readonly>
                  <input type="text" value="<%=HierarchyOpTpMap.get((String)headerRow.getAttribute("HIERARCHY_OP_TP"))%>" style="width:50" class=adg1 readonly>
                </td>
                <td class=tbldb><%=PosContext.getResourceMessage("GMResource","gm.label.0123",null,locale)%></td>
                <td class=tbllw>
                  <input type="text" value="<%=(String)headerRow.getAttribute("LAST_UPDATE_TIMESTAMP_STR")%>" style="width:120" class=adg1 readonly>
                  <input type="text" value="<%=(String)headerRow.getAttribute("LAST_UPDATED_OBJECT_ID")%>" style="width:70" class=adg1 readonly>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr height=18>
          <td align="right"><% if(isAdmin){ %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.import",null,locale)%>" onClick="goImport()" style="cursor:pointer"><!-- import --><% } %>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onClick="document.form_export.submit()" style="cursor:pointer"><!-- export -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="window.close()" style="cursor:pointer">
          </td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left" valign=top>
            <DIV ID=divTop STYLE="position:relative;overflow:auto;width:980;height:400;top:0;left:0">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td>
<!-- *****************************  틀고정된 필드명 출력 ***************************** -->
                  <TABLE WIDTH="<%=fixFiledTotalLength*ratio%>" BORDER=1 CELLSPACING=0 CELLPADDING=0 BORDERCOLORLIGHT=666666 BORDERCOLORDARK=ffffff>
                    <TR CLASS=tbldb HEIGHT='<%= 18*(mapWidthDbFiled.size()+posMatrixRuleData.getDataCnt())%>'>
                     <TD width=20><%=PosContext.getResourceMessage("GMResource","gm.label.0255",null,locale)%></TD>
                     <TD width=40><%=PosContext.getResourceMessage("GMResource","gm.label.0155",null,locale)%></TD><%
    for(int i=0;i<mapHeigthDbFiled.size();i++)
    {
        dbFiledName = (String)mapHeigthDbFiled.get(String.valueOf(i+1));
        posRuleItemStruct = (PosRuleItemStruct)posMatrixRuleData.getItemStruct(dbFiledName);
%>
                      <TD width='<%=posRuleItemStruct.getRatioLength()*ratio%>' ><%= posRuleItemStruct.getDtNmNm()%></TD><%
    }
%>
                    </TR>
                  </TABLE>
                </TD>
                <TD>
<!-- *****************************  틀고정안된 필드명 출력 ***************************** -->
                  <TABLE WIDTH=<%=unFixFiledTotalLength*ratio%> BORDER=1 CELLSPACING=0 CELLPADDING=0 BORDERCOLORLIGHT=666666 BORDERCOLORDARK=ffffff>
                    <tr CLASS=tbldb HEIGHT=18><%
    for(int i=0;i<mapWidthDbFiled.size();i++)
    {
        dbFiledName = (String)mapWidthDbFiled.get(String.valueOf(i+1));
        posRuleItemStruct = (PosRuleItemStruct)posMatrixRuleData.getItemStruct(dbFiledName);
        if(i==0){
            tmpFiledName = posRuleItemStruct.getDtNmNm();
        }else{
            tmpFiledName = tmpFiledName+"/"+posRuleItemStruct.getDtNmNm();
        }
    }
%>
                      <TD colspan='<%= arryWidthRecordeData.size()*posMatrixRuleData.getDataCnt()+arryWidthRecordeData.size()%>'><%= tmpFiledName%></TD>
                    </TR>
<!-- *****************************  틀고정 Matrix  title data 출력 ***************************** -->
                    <tr CLASS=tbldb HEIGHT=18><%
    for(int i=0;i<arryWidthRecordeData.size();i++){
        tmpWidthDatas = (String[]) arryWidthRecordeData.get(i);
        for(int j=0;j<tmpWidthDatas.length;j++){
            dbFiledName =  (String)mapWidthDbFiled.get(String.valueOf(j+1));
            javaFiledName = PosMasterUtility.getJavaFiledName(dbFiledName);
%>
                      <input type="hidden" name='<%= javaFiledName%>' value='<%= tmpWidthDatas[j]%>'>
                      <TD width=<%= length*ratio*posMatrixRuleData.getDataCnt()%> colspan='<%=posMatrixRuleData.getDataCnt()%>'><%= tmpWidthDatas[j]%></TD><%
        }
    }
%>
                    </TR>
<!-- *****************************  Matrix 데이타부가 1개이상일경우 타이틀 출력 ***************************** --><%
    if(posMatrixRuleData.getDataCnt()>1){
%>
                    <tr CLASS=tbldb HEIGHT=18><%
        for(int i=0;i<arryWidthRecordeData.size();i++){
            for(int j=0;j<posMatrixRuleData.getDataCnt();j++){
                dbFiledName = (String)mapDataDbFiled.get(String.valueOf((j%posMatrixRuleData.getDataCnt())+1));
                posRuleItemStruct = (PosRuleItemStruct)posMatrixRuleData.getItemStruct(dbFiledName);
%>
                      <TD width=<%= length*ratio%>><%= posRuleItemStruct.getDtNmNm()%></TD><%
            }
        }
%>
                    </TR><%
    }
%>
                  </TABLE>
                </TD>
              </TR>
              <TR>
                <TD valign=top>
<!-- *****************************  틀고정된 필드데이타 출력 ***************************** -->     
                  <TABLE WIDTH="<%=fixFiledTotalLength*ratio%>" BORDER=1 CELLSPACING=0 CELLPADDING=0 BORDERCOLORLIGHT=666666 BORDERCOLORDARK=ffffff><%

    for(int i=0;i<arryHeightRecordeData.size();i++){
        tmpHeightDatas = (String[]) arryHeightRecordeData.get(i);
        for(int j=0;j<tmpHeightDatas.length;j++){
        }
%>
                    <TR CLASS=tblcw HEIGHT=18>
                      <TD width=20><input type="checkbox" name="Recorde_chk" value=<%=(i)%>></td>
                      <TD width=40><%= i+1%></td><%
        for(int j=0;j<tmpHeightDatas.length;j++){
            dbFiledName = (String)mapHeigthDbFiled.get(String.valueOf(j+1));
            posRuleItemStruct = (PosRuleItemStruct)posMatrixRuleData.getItemStruct(dbFiledName);
            javaFiledName = PosMasterUtility.getJavaFiledName(dbFiledName);
%>
                      <input type="hidden" name='<%= javaFiledName%>' value='<%= tmpHeightDatas[j]%>'>
                      <TD width='<%= posRuleItemStruct.getRatioLength()*ratio%>'><input type="text" name='' value='<%= tmpHeightDatas[j]%>' size='<%= (posRuleItemStruct.getRatioLength()/8)*ratio%>' class=adb1 disabled></TD><%
        }
%>
                    </tr><%
    }
%>
                  </TABLE>
                </TD>
                <TD>
<!-- *****************************  틀고정안된 필드데이타 출력 ***************************** --> 
                  <TABLE WIDTH=<%=unFixFiledTotalLength*ratio%> BORDER=1 CELLSPACING=0 CELLPADDING=0 BORDERCOLORLIGHT=666666 BORDERCOLORDARK=ffffff><%
    for(int i=0;i<posMatrixRuleData.getRecordCnt();i++)
    {
%>
                    <TR HEIGHT=18 CLASS=tblcw><%

        for(int j=0;j<posMatrixRuleData.getColumnCnt();j++){
            posRuleData         =   posMatrixRuleData.getRuleData(i,j);
            tmpDatas            =  (String[]) posRuleData.getValueData();
            sModifyYn           =   posRuleData.getModifyFlag();

            if("Y".equals(sModifyYn)){
                sModifyYn="Y";
            }else{
                sModifyYn="N";
            }

            for(int k=0;k<posMatrixRuleData.getDataCnt();k++){
                dbFiledName         = (String)mapDataDbFiled.get(String.valueOf(k+1));
                posRuleItemStruct   = (PosRuleItemStruct)posMatrixRuleData.getItemStruct(dbFiledName);
                javaFiledName       = PosMasterUtility.getJavaFiledName(dbFiledName);
                if(tmpDatas==null){
%>
                      <TD width='<%= length*ratio%>'><input type="text" <%= "Y".equals(sModifyYn)==true?"":"readonly"%> name='<%= javaFiledName%>' value='' size='<%= (length/8)*ratio%>' class=adb1 onBlur=this.className='adb1'></TD><%
                }else{
%>
                      <TD width='<%= length*ratio%>'><input type="text" <%= "Y".equals(sModifyYn)==true?"":"readonly"%> name='<%= javaFiledName%>' value='<%= (tmpDatas[k]==null?"":tmpDatas[k])%>' size='<%=(length/8)*ratio%>' class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'></TD><%
                }
            }
        }
%>
<input type="hidden" name='MdMrgBasDataSeq' value='<%= (posRuleData.getDataSeq()==null?"":posRuleData.getDataSeq())%>'>
<input type="hidden" name='MdMrgBasId' value='<%=headerRow.getAttribute("MDL_DEFINE_ID")%>'>
<input type="hidden" name='RecordeIndex' value=<%=(i)%>>
<input type="hidden" name='ModifyFalg' value='<%= sModifyYn%>'><%
%>
                      </tr><%
    }
%>
                    </table>
                </td>
              </tr>
            </table>
<input type="hidden" name="alertMessage" value="<%=errorMsg.replace('"', '`')%>"/>
</form>
<form name="form_export" method="post" action="m000202040.do"><!-- export -->
<input type="hidden" name="ServiceName" value="m000202040-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="export" value="10"><!-- event -->
<input type="hidden" name="MdlDefineId" value='<%=headerRow.getAttribute("MDL_DEFINE_ID")%>'>
</form>
<form name="form_import" method="post" action="m000202040.do"><!-- import -->
<input type="hidden" name="ServiceName" value="m000202040-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="import" value="10"><!-- event -->
<input type="hidden" name="MdlDefineId" value='<%=headerRow.getAttribute("MDL_DEFINE_ID")%>'>
<input type="hidden" name="MdlDefineNm">
</form>
<form name="form_rule_hitory" method="post" action="m000202010.do"><!-- History -->
<input type="hidden" name="ServiceName" value="m000202010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="history" value="10"><!-- event -->
<input type="hidden" name="SearchUseTp" value="%">
<input type="hidden" name="SearchMasterDataPrcTp" value="%">
<input type="hidden" name="SearchWord" value="<%=(String)headerRow.getAttribute("MDL_DEFINE_NM")%>">
<input type="hidden" name="SearchAttribute" value="MD_NM">
<input type="hidden" name="modifyFlag" value="true">
<input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>">
</form>
</body>
</html>