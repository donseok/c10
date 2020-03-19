<%@ page contentType="text/html;charset=UTF-8"%><%
/*
 *Change history
 *@LastModifyDate : 20120705
 *@LastModifier   : 강길섭
 *@LastVersion    : 1.0
 *    2012-07-05    강길섭
 */

String closeCase = request.getParameter("case");
String loginSrc = com.posdata.glue.context.PosContext.getGlueProperty(com.poscoict.glue.master.common.PosMasterConstants.GLUE_PROP_LOGIN_SOURCE);
StringBuilder msg = new StringBuilder();
if ("cookie".equalsIgnoreCase(loginSrc)) {
    if("1".equals(closeCase)){
        msg.append("Your session has expired. Please access again from MENU.");
    }else{
        msg.append("check ["
            ).append(com.poscoict.glue.master.common.PosMasterConstants.GLUE_PROP_COOKIE_LOGIN
            ).append("] in glue.properties");
    }
} else if ("class".equalsIgnoreCase(loginSrc)) {
    if("1".equals(closeCase)){
        msg.append("Your session has expired. Please access again from MENU.");
    }else{
        msg.append("check ["
            ).append(com.poscoict.glue.master.common.PosMasterConstants.GLUE_PROP_CLASS_LOGIN
            ).append(","
            ).append(com.poscoict.glue.master.common.PosMasterConstants.LOGIN_CLASS_METHOD
            ).append("] in glue.properties");
    }
}else{
    msg.append("unknown status");
}
%> 
<script>
  SelfClose();
  function SelfClose()
  {
    alert("<%=msg.toString()%>");
    window.opener = self; 
    self.close(); 
  }
</script>