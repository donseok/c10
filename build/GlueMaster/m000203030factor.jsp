<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.web.control.PosWebConstants" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<%@ taglib uri="/WEB-INF/glueglobaltag.tld" prefix="posglobalui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<posglobalui:setResourceName name="GMResource"/><%
/*
 * @FileName      : Factor 선택
 * Open Issues    :
 * Change history 
 * @2008-06-13 김정희 1.0 최초 생성
 */

    PosContext ctx = (PosContext)request.getAttribute(PosWebConstants.CONTEXT);
    Locale locale = (Locale)pageContext.getAttribute(PosWebConstants.PAGE_LOCALE);

    String UserEmpNo = request.getParameter("UserEmpNo");  //시큐리티 적용전 임시
    //부모의 인덱스
    String sOpenerTargetId = request.getParameter("opener_target_id")== null?"": request.getParameter("opener_target_id"); //opener_target_id

    //부모창에서 넘어온 연산자,비교식1,비교식2,결과식 의 리스트

    String sOperList="";
    String sComp1List="";
    String sComp2List="";
    String sResultList="";
    
    if(request.getParameter("oper_list")!=null)
        sOperList=request.getParameter("oper_list").toString();
    if(request.getParameter("comp1_list")!=null)
        sComp1List=request.getParameter("comp1_list").toString();
    if(request.getParameter("comp2_list")!=null)
        sComp2List=request.getParameter("comp2_list").toString();
    if(request.getParameter("result_list")!=null)
        sResultList=request.getParameter("result_list").toString();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=PosContext.getResourceMessage("GMResource","gm.title.080",null,locale)%></title>
<link rel="stylesheet" href="css/pub.css" type="text/css">
<script type="text/javascript" src="js/showInsertableRow.js"></script>
<script type="text/javascript">
<!--
/*--------------------------------------------------------------------------
행 삭제전에 체크를 하였는지 조사
--------------------------------------------------------------------------*/
function delRow_factor_before(table,chk)
{
    var ok=0;  
    if(document.forms[0].inputchk==null)
    {
        alert('<%=PosContext.getResourceMessage("GMResource","gm.msg.0022",null,locale)%>');//더이상 삭제할 수 없습니다
        return false;
    }
    if(document.forms[0].inputchk.length>=2)
    {
        for(var i=0;i<document.forms[0].inputchk.length;i++)
        {
            if(document.forms[0].inputchk[i].checked==true)
                ok=1;
        }
    } else
    {
        if(document.forms[0].inputchk.checked==true)
                ok=1;
    }

    if(ok==0)
        alert("<%=PosContext.getResourceMessage("GMResource","gm.msg.0035",null,locale)%>");// 선택된 Data가 없습니다.
    else
        delRow(table,chk);
}

/*--------------------------------------------------------------------------
등록버튼 누름시 전송 스트링 구성
--------------------------------------------------------------------------*/
function register()
{
    var i;
    var oper_list="";                //연산자리스트
    var comp1_list="";            //비교값1리스트 
    var comp2_list="";            //비교값1리스트 
    var result_list="";            //결과값리스트 

   //계산공식의 데이타들을 ";" 구분자를 이용해 목록으로 만든다.
    if(document.forms[0].inputchk==null) //행이 아에 없을때
    {
        oper_list="";
        comp1_list="";
        comp2_list="";
        result_list="";
    } else if(document.forms[0].inputchk.length>=2) //행이 둘이상일때
    { 
        for(i=0;i<document.forms[0].inputchk.length;i++)
        {
            oper_list  =oper_list  +"_"+document.forms[0].oper[i].value+"$";
            comp1_list =comp1_list +"_"+document.forms[0].comp1[i].value+"$";
            comp2_list =comp2_list +"_"+document.forms[0].comp2[i].value+"$";
            result_list=result_list+"_"+document.forms[0].result[i].value+"$";
        }
    } else //행이 하나 있을때... 있더라도 내용이 텅비어 있을때
    {
        oper_list  ="_"+document.forms[0].oper.value+"$";
        comp1_list ="_"+document.forms[0].comp1.value+"$";
        comp2_list ="_"+document.forms[0].comp2.value+"$";
        result_list="_"+document.forms[0].result.value+"$";
    }
    document.forms[0].oper_list.value  =oper_list;
    document.forms[0].comp1_list.value =comp1_list;
    document.forms[0].comp2_list.value =comp2_list;
    document.forms[0].result_list.value=result_list;

    if(window.opener.document.forms[0].DtNmId.length>=2)
    {
        window.opener.document.forms[0].oper_list['<%=sOpenerTargetId%>'].value  =document.forms[0].oper_list.value;
        window.opener.document.forms[0].comp1_list['<%=sOpenerTargetId%>'].value =document.forms[0].comp1_list.value;
        window.opener.document.forms[0].comp2_list['<%=sOpenerTargetId%>'].value =document.forms[0].comp2_list.value;
        window.opener.document.forms[0].result_list['<%=sOpenerTargetId%>'].value=document.forms[0].result_list.value;
    } else
    {
        window.opener.document.forms[0].oper_list.value  =document.forms[0].oper_list.value;
        window.opener.document.forms[0].comp1_list.value =document.forms[0].comp1_list.value;
        window.opener.document.forms[0].comp2_list.value =document.forms[0].comp2_list.value;
        window.opener.document.forms[0].result_list.value=document.forms[0].result_list.value;
    }
    self.close();
}
function gm_select_all(chkname){
    if(chkname=='inputchk' && document.forms[0].inputchk!=undefined){
        if (document.forms[0].inputchk.length >= 2){
            for(i=0; i<document.forms[0].inputchk.length; i++){
                document.forms[0].inputchk[i].checked = !document.forms[0].inputchk[i].checked;
            }
        }else{
            document.forms[0].inputchk.checked = !document.forms[0].inputchk.checked;
        }
    }
}
-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" scrolling="no" onload="">
<table width="490" border="0" cellspacing="0" cellpadding="0" align=left >
  <tr bgcolor="e5e5e5">
    <td id=gm_showDate><div align="right"><posui:showDate/></div></td>
  </tr>
  <tr>
    <td valign=top align="center"><form name="form_cal_factor">
      <table width="470" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr height=25 align=left>
          <td><div id=gm_title style="font-family:Verdana;font-size:16px;font-weight:bold;color:000033"><%=PosContext.getResourceMessage("GMResource","gm.title.080",null,locale)%></div></td>
        </tr>
        <tr>
          <td background="img/gm0006img.gif"><img src="img/gm0007img.gif" width=1 height=8></td>
        </tr>
        <tr>
          <td align=right>
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.addrow",null,locale)%>" onClick="insRow(factor,hidden_factor,document.forms[0].inputchk);" style="cursor:pointer"/><!-- add row -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.deleterow",null,locale)%>" onClick="delRow_factor_before(factor,document.forms[0].inputchk)" style="cursor:pointer"/><!-- delete row -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.insert",null,locale)%>" onclick="register()" style="cursor:pointer"><!-- register -->
            <img src="<%=PosContext.getResourceMessage("GMResource","gm.img.cancel",null,locale)%>" onclick="window.close()" style="cursor:pointer"><!-- cancel -->
          </td>
        </tr>
      </table>
      <table width=470 border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF" align="center">
        <tr class="tbldb" height=18>
          <td width='6%'><img src="img/gm0004img.gif" onClick="gm_select_all('inputchk')" style="cursor:pointer"></td>
          <td width='25%'><%=PosContext.getResourceMessage("GMResource","gm.label.0157",null,locale)%><input type="hidden" name=oper_list></td>
          <td width='23%'><%=PosContext.getResourceMessage("GMResource","gm.label.0069",null,locale)%><input type="hidden" name=comp1_list></td>
          <td width='23%'><%=PosContext.getResourceMessage("GMResource","gm.label.0070",null,locale)%><input type="hidden" name=comp2_list></td>
          <td width='23%'><%=PosContext.getResourceMessage("GMResource","gm.label.0178",null,locale)%><input type="hidden" name=result_list></td>
        </tr>
      </table>
      <table id=factor width=470 border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF><TBODY><%

              String sOper="";
              String sComp1="";
              String sComp2="";
              String sResult="";

              int n,o,p,q;
              int check_no_count=0; //시퀀스 카운트를 위해
              while(!"".equals(sOperList))
              {
                  //구분자위치파악
                  n=sOperList.indexOf("$",0);
                  o=sComp1List.indexOf("$",0);
                  p=sComp2List.indexOf("$",0);
                  q=sResultList.indexOf("$",0);

                  //처리할문장 얻어옴
                  sOper=sOperList.substring(1,n);
                  sComp1=sComp1List.substring(1,o);
                  sComp2=sComp2List.substring(1,p);
                  sResult=sResultList.substring(1,q);
%>
        <tr height=18 class=tblcw>
          <td width='6%'><input type="checkbox" name=inputchk></td>
          <td width='25%'><posui:showSelectList name="oper" staticNames="DEFAULT|=|!=|<|<=|>|>=|<=BETWEEN<=|<BETWEEN<=|<=BETWEEN<|<BETWEEN<|%LIKE%|LIKE%|%LIKE|IN|NOT_IN" staticValues="DEFAULT|=|!=|<|<=|>|>=|<=BETWEEN<=|&lt;BETWEEN<=|<=BETWEEN<|&lt;BETWEEN<|%LIKE%|LIKE%|%LIKE|IN|NOT_IN" defaultSelectionValues="<%=sOper%>"/></td>
          <td width='23%'><input type="text" name=comp1 value="<%=sComp1%>" class="adb1" size="15"></td>
          <td width='23%'><input type="text" name=comp2 value="<%=sComp2%>" class="adb1" size="15"></td>
          <td width='23%'><input type="text" name=result value="<%=sResult%>" class="adb1" size="15"></td>
        </tr><%
                  //다음문장
                  sOperList=sOperList.substring(n+1);
                  sComp1List=sComp1List.substring(o+1);
                  sComp2List=sComp2List.substring(p+1); 
                  sResultList=sResultList.substring(q+1);
              }
%>
      </TBODY></table>
</form>
    </td>
  </tr>
</table>
<!--Input처리를 체크박스를 선택하지 않고 행추가시 가장 아래에 추가되는 행-->
<div STYLE=display:none>
<table id=hidden_factor width=470 border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF>
  <tr height=18 class=tblcw>
    <td width='6%'><input type="checkbox" name=inputchk></td>
    <td width='25%'><posui:showSelectList name="oper" staticNames="DEFAULT|=|!=|<|<=|>|>=|<=BETWEEN<=|<BETWEEN<=|<=BETWEEN<|<BETWEEN<|%LIKE%|LIKE%|%LIKE|IN|NOT_IN" staticValues="DEFAULT|=|!=|<|<=|>|>=|<=BETWEEN<=|&lt;BETWEEN<=|<=BETWEEN<|&lt;BETWEEN<|%LIKE%|LIKE%|%LIKE|IN|NOT_IN" /></td>
    <td width='23%'><input type="text" name="comp1" size="15" class="adb1" onBlur="this.className='adb1'" onFocus="this.className='adf1'"></td>
    <td width='23%'><input type="text" name="comp2" size="15" class="adb1" onBlur="this.className='adb1'" onFocus="this.className='adf1'"></td>
    <td width='23%'><input type="text" name="result" size="15" class="adb1" onBlur="this.className='adb1'" onFocus="this.className='adf1'"></td>
  </tr>
</table>
</div>
</body>
</html>