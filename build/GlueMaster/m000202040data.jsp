<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ page import="com.poscoict.glue.master.common.PosMasterUtility" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : 업무기준 목록 >> 업무기준 기본속성 등록 >> 업무기준 레이아웃 수정 >> 업무기준 데이터 조회(일반)
 *                  업무기준 목록 >> 업무기준 기본속성 등록 >> 업무기준 데이터 조회(일반)
 * Open Issues    :
 * Change history
 * @2003-06-03 류진영 #1.0   최초 생성
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

    String fixIndex=request.getParameter("fixIndex");
    if(fixIndex==null||fixIndex.length()<1) fixIndex="-1";

    PosRowSet rowSet = (PosRowSet)ctx.get("Defind010HeaderRowResult");
    PosRow headerRow = rowSet.next();
    String UseTp =(String)headerRow.getAttribute("USE_TP");
    String MasterDataPrcTp = (String)headerRow.getAttribute("MASTER_DATA_PRC_TP");
    String MasterDataPrcTpStr = "";
    if("1A0".equals(MasterDataPrcTp))      MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0105",null,locale);
    else if("1A1".equals(MasterDataPrcTp)) MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0137",null,locale);
    else if("1A2".equals(MasterDataPrcTp)) MasterDataPrcTpStr=PosContext.getResourceMessage("GMResource","gm.label.0075",null,locale);
    String recordResp = headerRow.getAttribute("ATTRIBUTE3")==null?"N":(String)headerRow.getAttribute("ATTRIBUTE3");

    String SearchAttribute = request.getParameter("SearchAttribute");
    String SearchWord = request.getParameter("SearchWord");
    String curPage = request.getParameter("curPage")==null?"1":request.getParameter("curPage");
    String[] HSearchWord = (String[])ctx.get("HSearchWord");
    String sHSearchIs = PosMasterUtility.getParameter(ctx, "sHSearchIs");

    int    seq=0;

    int         keyCnt                  =   0;
    int         dataCnt                 =   0;
    ArrayList   fixFiled                =   new ArrayList();
    ArrayList   fixFiledId              =   new ArrayList();
    ArrayList   fixFiledFullName        =   new ArrayList();
    ArrayList   fixFiledTdLength        =   new ArrayList();
    ArrayList   unFixFiled              =   new ArrayList();
    ArrayList   unFixFiledId            =   new ArrayList();
    ArrayList   unFixFiledFullName      =   new ArrayList();
    ArrayList   unFixFiledTdLength      =   new ArrayList();

    HashMap     mapCdTpId               =   new HashMap();  /*CdTpId를 저장할 변수*/

    int         fixFiledTotalLength     =   0; // 90(checkbox/우선순위)
    int         unFixFiledTotalLength   =   0;
    int tmpLength = 0;

    double      ratio                   =   0.0;
    ArrayList   filedNams               =   new ArrayList();
    ArrayList   dbFiledName             =   new ArrayList();

    String MdlDefineDtNmDrivedVProc = "";
    String MdlDefineDtNmLen = "";
    String aliasName = "";
    String sModifyYn = "";

    rowSet = (PosRowSet)ctx.get("Defind020DataLayoutRowResult");
    PosRow row;
    while(rowSet.hasNext())
    {
        row = rowSet.next();
        MdlDefineDtNmDrivedVProc = (String)row.getAttribute("MDL_DEFINE_DT_NM_DRIVED_V_PROC");
        MdlDefineDtNmLen = row.getAttribute("MDL_DEFINE_DT_NM_LEN")==null?row.getAttribute("DT_NM_LEN").toString():row.getAttribute("MDL_DEFINE_DT_NM_LEN").toString();
        tmpLength = Integer.parseInt(MdlDefineDtNmLen)*10;

        dbFiledName.add(MdlDefineDtNmDrivedVProc);
        /* Title로 쓰일 한글명을 추출한다*/
        aliasName = row.getAttribute("MDL_DEFINE_DT_NM_ALIAS")==null?(String)row.getAttribute("STANDARD_KOREAN_NAME"):(String)row.getAttribute("MDL_DEFINE_DT_NM_ALIAS");
        if(row.getAttribute("OLSTATR_NM")!=null){
            aliasName = aliasName +"("+ row.getAttribute("OLSTATR_NM") +")";
        }
        filedNams.add(aliasName);

        /********************* 항목이 코드일 경우 CdTpId를 얻어온다**************/
        if("Y".equals(row.getAttribute("MDL_DEFINE_DT_NM_CD_F"))){
            mapCdTpId.put(MdlDefineDtNmDrivedVProc,row.getAttribute("CD_TP_ID"));
            tmpLength = tmpLength+20;
        }

        /********************* 고정시킬 필드들을 가져온다***************/
        if((Integer.parseInt(fixIndex)==-1&&"Y".equals(row.getAttribute("MDL_DEFINE_DT_NM_KEY_F")))||Integer.parseInt(fixIndex)>=seq){
            fixFiledId.add(MdlDefineDtNmDrivedVProc);
            fixFiled.add(aliasName);
            fixFiledFullName.add(row.getAttribute("MDL_DEFINE_DT_NM_MRK_NM"));
            fixFiledTdLength.add(String.valueOf(tmpLength));
            fixFiledTotalLength = fixFiledTotalLength+tmpLength;
        }else{
            unFixFiledId.add(MdlDefineDtNmDrivedVProc);
            unFixFiled.add(aliasName);
            unFixFiledFullName.add(row.getAttribute("MDL_DEFINE_DT_NM_MRK_NM"));
            unFixFiledTdLength.add(String.valueOf(tmpLength));
            unFixFiledTotalLength = unFixFiledTotalLength+tmpLength;
         }

        /********************* 출력값과 입력값을 CNT한다***************/
        if("Y".equals(row.getAttribute("MDL_DEFINE_DT_NM_KEY_F"))){
            keyCnt++;
        }else{
            dataCnt++;
        }
        seq++;
    }

    ratio = 1.0;
    if( (fixFiledTotalLength+unFixFiledTotalLength) < (960-25-65) ){
        ratio = (double)(960-25-65) / (double)(fixFiledTotalLength+unFixFiledTotalLength);
    }

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.056",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/checkSelectBoxChecked.js"></script>
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/showInsertableRow.js"></script>
<script type="text/javascript" src="js/showPopup.js"></script>
<script type="text/javascript">
<!--
function goPage(actionType){
	document.forms[0].sHSearchIs.value="";
    document.forms[0].action=document.forms[0].action+"?saveData=10&curPage=1&"+actionType+"=10";
    document.forms[0].submit();
}
function goLayout(){
    document.forms[0].action="m000202030.do<%="S".equals(UseTp)?"?inputLayout=10":""%>";
    document.forms[0].ServiceName.value="m000202030-service";
    document.forms[0].submit();
}
function goVersion(){
    document.form_rule_hitory.target = "_self";
    document.form_rule_hitory.submit();
}
function goSave(){
    if(!checkSelectbox(document.forms[0]) && document.forms[0].UseTp.value == "<%=UseTp%>"){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
        return;
    }
    document.forms[0].action=document.forms[0].action+"?save=10";
    document.forms[0].submit();
}
function goDelete(){
    if(!checkSelectbox(document.forms[0])){
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
        return false;
    }
    document.forms[0].action=document.forms[0].action+"?delete=10";
    document.forms[0].submit();
}
function cntCheckBox(form) {
    var cnt = 0;
    for(var i = 0; i < form.elements.length ; i++) {
       if ((form.elements[i].type == "checkbox")) {
           cnt++;
       }
    }
    return cnt;
}
function insRow2(table_id,eTable_id,esubTable_id,chkname,sub_table_id){
    var cnt=0;
       insertRowNochk2(table_id,eTable_id,sub_table_id,esubTable_id);
    cnt=cntCheckBox(document.forms[0]);
    return false;
}
function insertRow2(tdtag,subtdtag) {
   tdtag.nextSibling.firstChild.value='';
   var trtag = tdtag.parentElement;
   var oCloneswapallNode = trtag.cloneNode(true);
   trtag.parentElement.insertBefore(oCloneswapallNode,trtag);
   var subtrtag = subtdtag.parentElement;
   var suboCloneswapallNode = subtrtag.cloneNode(true);
   subtrtag.parentElement.insertBefore(suboCloneswapallNode,subtrtag);
   swapall2(trtag,getNextSibling(trtag),subtrtag,getNextSibling(subtrtag));
}
function swapall2(trtag,Ttag,subtrtag,subTtag) {
    var node;
    var chktag = getFirstChild(getFirstChild(trtag));

    // 다음 row가 존재시
    if (trtag.nextSibling) {
        for(var ch =0 ; ch <trtag.childNodes.length ; ch++){
            if(ch==0) chktag.value = Ttag.rowIndex-1;
            trtag.childNodes[ch].index = Ttag.rowIndex-1;
        }
        for(var ch =0 ; ch <subtrtag.childNodes.length ; ch++){
            subtrtag.childNodes[ch].index =Ttag.rowIndex-1;
        }
        swapall2(getNextSibling(trtag),getNextSibling(Ttag),getNextSibling(subtrtag),getNextSibling(subTtag));
    //다음 row가 미존재시(마지막 Row일때)
    } else {
        for(var ce =0 ; ce <trtag.childNodes.length ; ce++){
            if(ce==0) chktag.value =  trtag.rowIndex;
            trtag.childNodes[ce].index = trtag.rowIndex;
        }
        for(var ce =0 ; ce <subtrtag.childNodes.length ; ce++){
            subtrtag.childNodes[ce].index = subtrtag.rowIndex;
        }
    }
}
function insertRowNochk2(table_id,eTable_id,sub_table_id,esubTable_id){
    var hTrtag = eTable_id.rows[0];
    var oCloneNode = hTrtag.cloneNode(true);
    table_id.rows[0].parentNode.insertBefore(oCloneNode,null);
    var trtag=table_id.rows[0];

    var subhTrtag = esubTable_id.rows[0];
    var suboCloneNode = subhTrtag.cloneNode(true);
    sub_table_id.rows[0].parentNode.insertBefore(suboCloneNode,null);
    var subtrtag=sub_table_id.rows[0];
    swapall2(trtag,getNextSibling(trtag),subtrtag,getNextSibling(subtrtag));
}
function goCodeList(index,cdTpId,MdlDefineDtNmDrivedVProc){
    var cnt=cntCheckBox(document.forms[0]);
    if(cnt==1){
        document.form_code.FiledName.value="document.forms[0]."+MdlDefineDtNmDrivedVProc;
    }else{
        document.form_code.FiledName.value="document.forms[0]."+MdlDefineDtNmDrivedVProc+"["+index+"]";
    }
    document.form_code.Index.value=index;
    document.form_code.CdTpId.value=cdTpId;
    showPopup("","showCode_"+cdTpId,780,600,'1',0,0,1,1,1,0,0);
    document.form_code.target = "showCode_"+cdTpId;
    document.form_code.submit();
}
function gm_select_all(){
    if (document.forms[0].TbM00Datas010VO_chk.length >= 2){
        for(i=0; i<document.forms[0].TbM00Datas010VO_chk.length; i++){
            document.forms[0].TbM00Datas010VO_chk[i].checked = !document.forms[0].TbM00Datas010VO_chk[i].checked;
        }
    }else{
        document.forms[0].TbM00Datas010VO_chk.checked = !document.forms[0].TbM00Datas010VO_chk.checked;
    }
}
function goImport(){
    document.form_import.MdlDefineNm.value="<%=headerRow.getAttribute("MDL_DEFINE_NM")%>";
    showPopup("","m000202040_import",500,450,'1',0,0,1,1,1,0,0);
    document.form_import.target="m000202040_import";
    document.form_import.submit();
}
function divDataOnscroll(){
    //Chrome에서 '<SCRIPT FOR=divData EVENT=onscroll>'형식을 지원하지 않아 별도의 function으로 분리하여 호출하였음.
    document.all.divTop.scrollLeft = document.all.divData.scrollLeft;
}

function showHSearch(){
	document.getElementById('hSearchDiv').style.display='block';
}
function closeHSearch(){
	document.getElementById('hSearchDiv').style.display='none';
}
function goHSearch(){
    document.forms[0].action=document.forms[0].action+"?saveData=10&curPage=1&modifyFixFiled.x=10";
	document.forms[0].sHSearchIs.value="H";
    document.forms[0].submit();
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0"  onload="done_message(document.forms[0].alertMessage);setTableIndexNoHeader(maintable);" >
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
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.056",null,locale)%></div></td>
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
<form name="form_rule_data" method="post" action="m000202040.do"><!-- m000202010.do,m000202030.do -->
<input type="hidden" name="ServiceName" value="m000202040-service"><!-- m000202010-service,m000202030-service -->
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="LstUpdByIp" value="<%=request.getRemoteAddr()%>">
<input type="hidden" name="MdlDefineId" value="<%= request.getParameter("MdlDefineId")%>">
<input type="hidden" name="MasterDataPrcTp" value="<%=MasterDataPrcTp%>">
<input type="hidden" name="modifyFlag" value="true">
<input type="hidden" name="pageSize" value="15">
<input type="hidden" name="sHSearchIs" value="<%=sHSearchIs%>">
<div id="hSearchDiv" style="position:absolute;display: none;top:205px;left:270px;z-index:999;background:#fff;border:1px solid #000;">
<table border="0" cellspacing="0" cellpadding="0" align="center">
	<tbody>
		<tr style="height:30px;background:#B3cdee;padding-left:3px;" >
			<td colspan=2>
			<%=PosContext.getResourceMessage("GMResource","gm.label.0286",null,locale)%>
			</td>
		</tr>
<%
for(int i=0;i<filedNams.size();i++){
%>
		<tr style="height:27px;padding-right:5px;">
			<td style="padding-left:5px;" >
				<input type="hidden" name="HSearchAttr" value='<%= (String)dbFiledName.get(i)%>' >
				<%= ((String)filedNams.get(i)).length()>11
                      ? ((String)filedNams.get(i)).substring(0,12)
                      : filedNams.get(i)%>
			</td>
			<td>
				<input type="text" name="HSearchWord" value='<%=(HSearchWord==null?"":HSearchWord[i].trim())%>' class=adb1 >
			</td>
		</tr>
<%
}
%>
		<tr style="height:30px;">
			<td style="text-align:center;" colspan=2>
				<img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="goHSearch();" style="cursor:pointer" align='absmiddle'>
				<img src="<%=PosContext.getResourceMessage("GMResource","gm.img.close",null,locale)%>" onClick="closeHSearch();" style="cursor:pointer" align='absmiddle'>
			</td>
		</tr>
	</tbody>
</table>
</div>
      <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align="left">
            <table width="100%" border=1 cellspacing=0 cellpadding=0 bordercolorlight=66666 bordercolordark=ffffff>
              <tr height=20>
                <td class=tbldb width=120><%=PosContext.getResourceMessage("GMResource","gm.label.0035",null,locale)%></td>
                <td class=tbllw><input type="text" name="MdlDefineNm" value="<%=(String)headerRow.getAttribute("MDL_DEFINE_NM")%>" style="width:120" class=adg1 readonly></td>
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
                    <option value="N" <%="N".equals(UseTp)?"selected":""%>>[N]<%=PosContext.getResourceMessage("GMResource","gm.label.0093",null,locale)%></option>
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
        <tr>
          <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" align=center>
              <tr height="25">
                <td align="left">
                  <b><%=PosContext.getResourceMessage("GMResource","gm.label.0099",null,locale)%></b><b>:</b>&nbsp;
                  <select name="fixIndex" class=adf>
                    <option value="-1"><%=PosContext.getResourceMessage("GMResource","gm.label.0255",null,locale)%></option><%  for(int i=0, iz=dbFiledName.size()-1; i<iz; i++){%>
                    <option value="<%=i%>" <%= (Integer.parseInt(fixIndex)==i?"selected":"")%>><%= (i+1)%> 항목</option><% }%>
                  </select>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="goPage('modifyFixFiled.x')" style="cursor:pointer" align='absmiddle'>&nbsp;&nbsp;
                  <b><%=PosContext.getResourceMessage("GMResource","gm.label.0098",null,locale)%></b><b>:</b>
                  <select name="SearchAttribute" class=adf>
                    <option value=""><%=PosContext.getResourceMessage("GMResource","gm.label.0255",null,locale)%></option><% for(int i=0, iz=dbFiledName.size(); i<iz; i++){%>
                    <option <%=(((String)dbFiledName.get(i)).equals(SearchAttribute)==true?"selected":"")%> value="<%= (String)dbFiledName.get(i)%>"><%= ((String)filedNams.get(i)).length()>9?((String)filedNams.get(i)).substring(0,9):filedNams.get(i)%></option><% }%>
                  </select>
                  <input type="text" name="SearchWord" value='<%= (SearchWord==null?"":SearchWord.trim())%>' size=15 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1'>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.find",null,locale)%>" onClick="goPage('modifyFind.x')" style="cursor:pointer" align='absmiddle'>
                   <a href="javascript:showHSearch();" style="padding-left:10px;"><%=PosContext.getResourceMessage("GMResource","gm.label.0286",null,locale)%></a>
                </td>
                <td align="right"><% if(isAdmin){ %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.save",null,locale)%>" onClick="goSave()" style="cursor:pointer"><!-- save -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.delete",null,locale)%>" onClick="goDelete()" style="cursor:pointer"><!-- delete -->
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.import",null,locale)%>" onClick="goImport()" style="cursor:pointer"><!-- import --><% } %>
                  <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.export",null,locale)%>" onClick="document.form_export.submit()" style="cursor:pointer"><!-- export -->
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
          <td align=right>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.addrow",null,locale)%>" onClick="insRow2(maintable,hiddenTable,hiddenTableSub,document.forms[0].TbM00Datas010VO_chk,subtable)" style="cursor:pointer"><!-- add row -->
          </td>
        </tr>
        <tr>
          <td align="left" valign=top>
            <div id=divTop style="position:relative;overflow:hidden;width:960;top:0;left:0;"><% for(int i=0, iz=dbFiledName.size(); i<iz; i++){%>
            <input type="hidden" name="TB_M00_DATAS010.ColumnId" value="<%=dbFiledName.get(i)%>"><%}%>
            <table border=0 cellspacing=0 cellpadding=0>
              <tr>
                <td>
                  <table width="<%=(int)(fixFiledTotalLength*ratio+25+65)%>" border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff>
                    <tr class=tbldb height=20>
                      <td rowspan=2 width=25><img src="img/gm0004img.gif" onClick="gm_select_all()" style="cursor:pointer"></td>
                      <td rowspan=2 width=65><%=PosContext.getResourceMessage("GMResource","gm.label.0155",null,locale)%></td><%  if(fixFiled.size()>keyCnt){%>
                      <td colspan=<%= keyCnt%> ><%=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale)%></td>
                      <td colspan=<%= fixFiled.size()-keyCnt%>><%=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale)%></td><%  }else{%>
                      <td colspan=<%= fixFiled.size()%> ><%=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale)%></td><%  }%>
                    </tr>
                    <tr class=tbllb height=18><%  for(int i=0;i<fixFiled.size();i++){   %>
                      <td width=<%=(int)(Integer.parseInt((String)fixFiledTdLength.get(i))*ratio)%> title="<%= fixFiledFullName.get(i)%>"><%= fixFiled.get(i)%></td><%  }%>
                    </tr>
                  </table>
                </td>
                <td>
                  <table width=<%=(int)(unFixFiledTotalLength*ratio)%> border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff>
                    <tr class=tbldb height=20><%  if(unFixFiled.size()>dataCnt){%>
                      <td colspan=<%= unFixFiled.size()-dataCnt%> ><%=PosContext.getResourceMessage("GMResource","gm.label.0071",null,locale)%></td>
                      <td colspan=<%= dataCnt%> ><%=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale)%></td><%  }else{%>
                      <td colspan=<%= unFixFiled.size()%>><%=PosContext.getResourceMessage("GMResource","gm.label.0177",null,locale)%></td><%  }%>
                    </tr>
                    <tr class=tbllb height=18><%  for(int i=0;i<unFixFiled.size();i++){   %>
                      <td width=<%= (int)(Integer.parseInt((String)unFixFiledTdLength.get(i))*ratio)%> title="<%= unFixFiledFullName.get(i)%>"><%= unFixFiled.get(i)%></td><%  }%>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
            </div>
            <div id=divData style="position:relative;overflow:<%=(fixFiledTotalLength+unFixFiledTotalLength)*ratio>(960-25-65)?"scroll":"auto"%>;width:980;height:<%=(fixFiledTotalLength+unFixFiledTotalLength)*ratio>(960-25-65)?387:370%>;top:0;left:0;" onscroll="divDataOnscroll()">
            <table border=0 cellspacing=0 cellpadding=0>
              <tr>
                <td valign=top>
                  <table id=maintable width="<%=(int)(fixFiledTotalLength*ratio+25+65)%>" border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff>
                    <tr index=0 height=23 class=tblcm><%
        sModifyYn = ""; // checkbox disabled 용
%>
                      <td width=25><input type="checkbox" name="TbM00Datas010VO_chk" value=0></td>
                      <td width=65><%=PosContext.getResourceMessage("GMResource","gm.label.0091",null,locale)%></td><%
    rowSet = (PosRowSet)ctx.get("Datas010ExceptionCase");
    row = null;
    if(rowSet!=null && rowSet.hasNext()){
        row = rowSet.next();
        for(int i=0;i<fixFiled.size();i++){ %>
                      <td width=<%= (int)(Integer.parseInt((String)fixFiledTdLength.get(i))*ratio)%>><%
            if(i < keyCnt){
                      %><input type="hidden" name='<%=fixFiledId.get(i)%>'>&nbsp;<%
            }else if(mapCdTpId.get((String)fixFiledId.get(i))==null){
                      %><input type="text" name='<%=fixFiledId.get(i)%>' value="<%= row.getAttribute((String)fixFiledId.get(i))==null?"":row.getAttribute((String)fixFiledId.get(i))%>" style="width:<%=(int)(Integer.parseInt((String)fixFiledTdLength.get(i))*ratio)-15%>" class=adb1><%
            }else{
                      %><input type="text" name='<%=fixFiledId.get(i)%>' value="<%= row.getAttribute((String)fixFiledId.get(i))==null?"":row.getAttribute((String)fixFiledId.get(i))%>" style="width:<%=(int)(Integer.parseInt((String)fixFiledTdLength.get(i))*ratio)-35%>" class=adb1><img src="img/gm0003img.gif" onClick="javascript:goCodeList(this.parentElement.index,'<%= mapCdTpId.get((String)fixFiledId.get(i))%>','<%= (String)fixFiledId.get(i)%>');" style="cursor:pointer"><%
            }       %></td><%
        }
    }else{
        for(int i=0;i<fixFiled.size();i++){ %>
                      <td width=<%= (int)(Integer.parseInt((String)fixFiledTdLength.get(i))*ratio)%>><%
            if(i < keyCnt){
                      %><input type="hidden" name='<%=fixFiledId.get(i)%>'>&nbsp;<%
            }else if(mapCdTpId.get((String)fixFiledId.get(i))==null){
                      %><input type="text" name='<%=fixFiledId.get(i)%>' style="width:<%=(int)(Integer.parseInt((String)fixFiledTdLength.get(i))*ratio)-15%>" class=adb1><%
            }else{
                      %><input type="text" name='<%=fixFiledId.get(i)%>' style="width:<%=(int)(Integer.parseInt((String)fixFiledTdLength.get(i))*ratio)-35%>" class=adb1><img src="img/gm0003img.gif" onClick="javascript:goCodeList(0,'<%= mapCdTpId.get((String)fixFiledId.get(i))%>','<%= (String)fixFiledId.get(i)%>');" style="cursor:pointer"><%
            }
                    %></td><%
        }
    }
    if(row==null){
%>
                      <input type="hidden" name="MdMrgBasDataSeq" value="-1">
                      <input type="hidden" name="MdMrgBasId" value=<%=headerRow.getAttribute("MDL_DEFINE_ID")%>>
                      <input type="hidden" name="dmltype" value="insert"><%
    }else{
%>
                      <input type="hidden" name="MdMrgBasDataSeq" value="-1">
                      <input type="hidden" name="MdMrgBasId" value=<%=headerRow.getAttribute("MDL_DEFINE_ID")%>>
                      <input type="hidden" name="dmltype" value="update"><%
    }
%>
                    </tr><%


    rowSet = (PosRowSet)ctx.get("Datas010RowResult");
    rowSet.reset();
    seq=1;
    while(rowSet.hasNext())
    {
        row = rowSet.next();
        sModifyYn = (String)row.getAttribute("MODIFY_YN");
        if("Y".equals(sModifyYn)){
            sModifyYn="";
        } else if("N".equals(recordResp))
        {
            sModifyYn="";
        }else{
            sModifyYn="disabled";
        }
%>
                    <tr index=<%=seq%> height=18 class=<%= (seq%2==1?"tblcw":"tblcg")%>>
                      <td><input type="checkbox" name="TbM00Datas010VO_chk" value=<%=(seq)%> <%=sModifyYn%>></td>
                      <td><%= Integer.parseInt(curPage)*15-15+seq%><input type="hidden" name="dmltype" value="update">
                        <input type="hidden" name="MdMrgBasDataSeq" value=<%=row.getAttribute("MD_MRG_BAS_DATA_SEQ")%>>
                        <input type="hidden" name="MdMrgBasId" value=<%=row.getAttribute("MD_MRG_BAS_ID")%>>
                      </td><%
        for(int i=0;i<fixFiled.size();i++){
            if(mapCdTpId.get((String)fixFiledId.get(i))==null){
%>
                      <td><input type="text" name='<%=fixFiledId.get(i)%>' value="<%= (row.getAttribute((String)fixFiledId.get(i)))==null?"":(row.getAttribute((String)fixFiledId.get(i)))%>" style="width:<%=(int)(Integer.parseInt((String)fixFiledTdLength.get(i))*ratio)-15%>" class=adb1></td><%
            }else{%>
                      <td><input type="text" name='<%=fixFiledId.get(i)%>' value="<%= (row.getAttribute((String)fixFiledId.get(i)))==null?"":(row.getAttribute((String)fixFiledId.get(i)))%>" style="width:<%=(int)(Integer.parseInt((String)fixFiledTdLength.get(i))*ratio)-35%>" class=adb1><img src="img/gm0003img.gif" onClick="javascript:goCodeList(<%=seq%>,'<%= mapCdTpId.get((String)fixFiledId.get(i))%>','<%= (String)fixFiledId.get(i)%>');" style="cursor:pointer"></td><%
            }
        }
        seq++;
%>
                    </tr><%
    }
%>
                  </table>
                </td>
                <td>
                  <table id=subtable width=<%=(int)(unFixFiledTotalLength*ratio)%> border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff>
                    <tr index=0 height=18 class=tblcm><%

    rowSet = (PosRowSet)ctx.get("Datas010ExceptionCase");
    rowSet.reset();
    if(rowSet!=null && rowSet.hasNext()){
        row = rowSet.next();
        for(int i=0;i<unFixFiledId.size();i++){
%>
                      <td width=<%=(int)(Integer.parseInt((String)unFixFiledTdLength.get(i))*ratio)%>><%
            if(i+fixFiled.size() < keyCnt){
                      %><input type="hidden" name='<%=unFixFiledId.get(i)%>'>&nbsp;<%
            }else if(mapCdTpId.get((String)unFixFiledId.get(i))==null){
                      %><input type="text" name='<%=unFixFiledId.get(i)%>' value="<%= row.getAttribute((String)unFixFiledId.get(i))==null?"":row.getAttribute((String)unFixFiledId.get(i))%>" style="width:<%=(int)(Integer.parseInt((String)unFixFiledTdLength.get(i))*ratio)-15%>" class=adb1><%
            }else{
                      %><input type="text" name='<%=unFixFiledId.get(i)%>' value="<%= row.getAttribute((String)unFixFiledId.get(i))==null?"":row.getAttribute((String)unFixFiledId.get(i))%>" style="width:<%=(int)(Integer.parseInt((String)unFixFiledTdLength.get(i))*ratio)-35%>" class=adb1><img src="img/gm0003img.gif" onClick="javascript:goCodeList(0,'<%= mapCdTpId.get((String)unFixFiledId.get(i))%>','<%= (String)unFixFiledId.get(i)%>');" style="cursor:pointer"><%
            }
                    %></td><%
        }
    }else{
        for(int i=0;i<unFixFiledId.size();i++){
%>
                      <td width=<%=(int)(Integer.parseInt((String)unFixFiledTdLength.get(i))*ratio)%>><%
            if(i+fixFiled.size() < keyCnt){%>
                        <input type="hidden" name='<%=unFixFiledId.get(i)%>'>&nbsp;<%
            }else  if(mapCdTpId.get((String)unFixFiledId.get(i))==null){
%>
                        <input type="text" name='<%=unFixFiledId.get(i)%>' style="width:<%=(int)(Integer.parseInt((String)unFixFiledTdLength.get(i))*ratio)-15%>" class=adb1><%
            }else{
%>
                        <input type="text" name='<%=unFixFiledId.get(i)%>' style="width:<%=(int)(Integer.parseInt((String)unFixFiledTdLength.get(i))*ratio)-35%>" class=adb1>
                        <img src="img/gm0003img.gif" onClick="javascript:goCodeList(0,'<%= mapCdTpId.get((String)unFixFiledId.get(i))%>','<%= (String)unFixFiledId.get(i)%>');" style="cursor:pointer"><%
            }
%>
                      </td><%
        }
    }
%>
                    </tr><%

    rowSet = (PosRowSet)ctx.get("Datas010RowResult");
    rowSet.reset();
    seq=1;
    while(rowSet.hasNext())
    {
        row=rowSet.next();
%>
                    <tr index=<%=seq%> height=18 class=<%= (seq%2==1?"tblcw":"tblcg")%>><%
        for(int i=0;i<unFixFiledId.size();i++){
            if(mapCdTpId.get((String)unFixFiledId.get(i))==null){
%>
                      <td><input type="text" name='<%=unFixFiledId.get(i)%>' value="<%= (row.getAttribute((String)unFixFiledId.get(i)))==null?"":(row.getAttribute((String)unFixFiledId.get(i)))%>" style="width:<%=(int)(Integer.parseInt((String)unFixFiledTdLength.get(i))*ratio)-15%>" class=adb1></td><%
            }else{
%>
                      <td><input type="text" name='<%=unFixFiledId.get(i)%>' value="<%= (row.getAttribute((String)unFixFiledId.get(i)))==null?"":(row.getAttribute((String)unFixFiledId.get(i)))%>" style="width:<%=(int)(Integer.parseInt((String)unFixFiledTdLength.get(i))*ratio)-35%>" class=adb1><img src="img/gm0003img.gif" onClick="javascript:goCodeList(<%=seq%>,'<%= mapCdTpId.get((String)unFixFiledId.get(i))%>','<%= (String)unFixFiledId.get(i)%>');" style="cursor:pointer"></td><%
            }
        }
        seq++;
%>
                    </tr><%
    }
%>
                  </table>
                </td>
              </tr>
            </table>
            </div><% if("1A0".equals(MasterDataPrcTp)){%>
            <div align="center">
            <posui:showPageSet infoName="Datas010RowResult" formName="document.forms[0]" curPageName="curPage" paramNames="saveData" paramValues="1"/>
            </div><%}%>
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
<input type="hidden" name="MdlDefineId" value="<%=headerRow.getAttribute("MDL_DEFINE_ID")%>">
</form>
<form name="form_import" method="post" action="m000202040.do"><!-- import -->
<input type="hidden" name="ServiceName" value="m000202040-service">
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="isAdmin" value="<%=isAdmin%>">
<input type="hidden" name="import" value="10"><!-- event -->
<input type="hidden" name="MdlDefineNm">
<input type="hidden" name="MdlDefineId" value="<%=headerRow.getAttribute("MDL_DEFINE_ID")%>">
</form>
<form name="form_code" method="post" action="m000201010.do"><!-- codeRef -->
<input type="hidden" name="ServiceName" value="m000201010-service"/>
<input type="hidden" name="pageID" value="<%=request.getParameter("pageID")==null?"SecurityError":request.getParameter("pageID")%>">
<input type="hidden" name="UserEmpNo" value="<%=UserEmpNo%>">
<input type="hidden" name="codeRef" value="10"><!-- event -->
<input type="hidden" name="CdTpId">
<input type="hidden" name="Type" value="INSERT">
<input type="hidden" name="Index">
<input type="hidden" name="FiledName">
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
    </td>
  </tr>
</table>
<!-- HIDDEN TABLE -->
<div STYLE=display:none>
<table id=hiddenTable border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff>
  <TR index=0 HEIGHT=18 CLASS="tblcw">
    <td><input type="checkbox" name="TbM00Datas010VO_chk" value=0 checked></td>
    <td><input type="hidden" name="dmltype" value="insert">
      <input type="hidden" name="MdMrgBasDataSeq">
      <input type="hidden" name="MdMrgBasId" value="<%=headerRow.getAttribute("MDL_DEFINE_ID")%>">
    </td><%
    for(int i=0;i<fixFiled.size();i++){
%>
    <td><input type=text name='<%=fixFiledId.get(i)%>'  style="width:<%=(int)(Integer.parseInt((String)fixFiledTdLength.get(i))*ratio)-15%>" class=adb1></td><%
    }
%>
  </tr>
</table>
<table id=hiddenTableSub border=1 cellspacing=0 cellpadding=0 bordercolorlight=666666 bordercolordark=ffffff>
  <tr index=0 height=18 class="tblcw"><%
    for(int i=0;i<unFixFiled.size();i++){
%>
    <td><input type="text" name='<%=unFixFiledId.get(i)%>' style="width:<%=(int)(Integer.parseInt((String)unFixFiledTdLength.get(i))*ratio)-15%>" class=adb1></td><%
    }
%>
  </tr>
</table>
</div>
</body>
</html>