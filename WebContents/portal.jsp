<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "com.posdata.glue.context.PosContext" %>
<%@ page import = "com.posdata.glue.web.security.*" %>
<%@ page import = "java.util.*" %> 
<%@ page import = "java.text.SimpleDateFormat" %> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<title>Unionsteel Portal</title>

<%
	PosContext ctx = (PosContext)request.getAttribute("PosContext");

	PosUser user = (PosUser)session.getAttribute(PosSecurityConstants.USER);
	String userId;
	String userName;
	if(user != null){
		Map userInfoMap = user.getUserInfoMap();
		if(userInfoMap == null){
			System.out.println("userInfoMap is null");
		}
		userName = (String)userInfoMap.get("USER_NAME");
		userId = (String)userInfoMap.get("USER_ID").toString();
	} else {
		userName = ""; 
		userId ="";
	}
%>
<script src="./dhtmlx/codebase/glue.ui.bootstrap.js" type="text/javascript"></script>
<style type="text/css">	
	table.dhtmlxLayoutPolyContainer_dhx_skyblue td.dhtmlxLayoutSinglePoly div.dhtmlxPolyInfoBarCollapsedVer div.dhtmlxInfoButtonShowHide_hor {
    background-repeat: no-repeat;
    cursor: pointer;
    font-family: dotum,Tahoma;
    font-size: 2px;
    height: 16px;
    left: 1px;
    position: absolute;
    text-align: center;
    top: 300px;
    vertical-align: top;
    width: 16px;
	}
</style>
<script type="text/javascript">
//<![CDATA[
		var uiLayoutInner1,uiLayout,uiTreeToolbar,uiTreeMenu,uiTree,uiFavoritesToolbar,favoritesMenu,favoritesTree,uiTabbar, lastUitabbarId;
		function help(){			
			alert("도움말 이벤트");
		}

		function logout(){		
			window.location = "./logout.do"			
		}
		
		//tab open
        function openTab(id) {
            if(uiTree.getUserData(id,"url")){
                if(uiTree.getUserData(id,"openType") == "newWin"){                     
                    openWindow(id);                    
                }else{
                    if(typeof(uiTabbar._tabs[id]) !== 'undefined'){
                    uiTabbar.setTabActive(id);
                    uiLayout.cells("a").collapse(); // 접기 Event	
                    }else{
                        addTab(id,"");
                    }
					   	lastUitabbarId = id;                
                }
                return true;
            }else{
                if(uiTree.getOpenState(id) == -1){
                    uiTree.openItem(id);            //tree open
                }else{
                    uiTree.closeItem(id);           //tree close
                }
            }
        }
		
		//add Tab 
		var tabs;
		function addTab(id,param){	
				tabs = getAllTabs();
				for(var i=0; i<tabs.length; i++){					
					if(tabs[i] =="fake"){
						 removeFakeTab.call(uiTabbar);
					}
				}
			//uiLayout.progressOn();
			var tab_text = uiTree.getItemText(id);
				uiTabbar.addTab(id,tab_text,"*");//addTab(id, text, size, position, row)			
				uiTabbar._tabs[id].title = tab_text;//Tabbar tooltip 설정;
				uiLayoutInner1 = uiTabbar.cells(id).attachLayout("1C","dhx_skyblue");
				uiLayoutInner1.cells("a").hideHeader();
				if(param != ""){
					if(uiTree.getUserData(id,"url").indexOf("?") == -1){
						uiLayoutInner1.cells("a").attachURL(uiTree.getUserData(id,"url")+"?"+param);
					}else{
						uiLayoutInner1.cells("a").attachURL(uiTree.getUserData(id,"url")+"&"+param);
					}
				}else{
					uiLayoutInner1.cells("a").attachURL(uiTree.getUserData(id,"url"));
				}
				uiTabbar.setTabActive(id);
				uiLayout.cells("a").collapse(); // 접기 Event	
				
				for(var i=0; i<tabs.length; i++){					
					if(tabs[i] =="fake"){
						 addFakeTab.call(uiTabbar);
					}
				}
		}	
		
		//custom add Tab 
		function customAddTab(tab_text,tab_id,url,customParam){	
			 if(typeof(uiTabbar._tabs[tab_id]) !== 'undefined'){
				 uiTabbar.setTabActive(tab_id);
			 }else{
				uiTabbar.addTab(tab_id,tab_text,"*");//addTab(id, text, size, position, row)			
				uiTabbar._tabs[tab_id].title = tab_text;//Tabbar tooltip 설정;
				uiLayoutInner1 = uiTabbar.cells(tab_id).attachLayout("1C","dhx_skyblue");
				uiLayoutInner1.cells("a").hideHeader();
				var _host = url.substring(1,4).toLowerCase();
				var _url = window.location.host.replace("m90",_host);
				if(customParam != ""){
					uiLayoutInner1.cells("a").attachURL(window.location.protocol+"//"+_url+url+"&"+customParam);

				}else{
					uiLayoutInner1.cells("a").attachURL(window.location.protocol+"//"+_url+url);
				}
				uiTabbar.setTabActive(tab_id);
			 }
			 uiLayout.cells("a").collapse(); // 접기 Event		
		}

      	//windowPopup open  
        function openWindow(id){
            var width = screen.width; //팝업창 넓이 
            var height = screen.height; //팝업창 높이 
            var url = uiTree.getUserData(id,"url");
            var text = uiTree.getItemText(id);
            window.open(url, "", "scrollbars=0,status=no,width="+width+",height="+height+",resizable=yes,status=yes");        
        }

		
		//tab close
		function onTabClose(id){
			if(uiTabbar.getNumberOfTabs() > 1){
				if(id == "notice"){
					alert("공지사항은 닫을 수 없습니다.");
					return;
				}
			}else{
				if(uiTabbar.getActiveTab() == "notice"){
					alert("공지사항은 닫을 수 없습니다.");
					return;
				}else{			
					uiTabbar.goToPrevTab();
				}
				if(uiTabbar.getNumberOfTabs() == 1){
					uiLayout.cells("a").expand();
				}
			}
			return true;
		}

		
		//tab close
		function tabClose(){
			if(uiTabbar.getActiveTab() == "notice"){
				alert("공지사항은 닫을 수 없습니다.");
				return;
			}else{							
				uiTabbar.removeTab(uiTabbar.getActiveTab(),true);
			}
			if(uiTabbar.getNumberOfTabs() == 1){
				uiLayout.cells("a").expand();
			}
			return true;
		}
		
		//Main Menu 마우스오른쪽 이벤트
		function onContextMianMenuClick(menuitemId, type) {
			if(menuitemId == "moveTtem"){
				if(!uiTree.getSelectedItemId()){
					alert("이동할 메뉴를 선택해주세요.");
					return;
				}else{
					alert("이동 후 저장버튼을 클릭해야 반영됩니다.");
					uiTree.moveItem(uiTree.getSelectedItemId(),"item_child","0",favoritesTree);
					favoritesTree.setUserData(uiTree.getSelectedItemId(),"url",uiTree.getUserData(uiTree.getSelectedItemId(),"url"));

				}			
			}
		}

		//즐겨찾기 마우스오른쪽 이벤트
		function onContextFavoritesMenuClick(menuitemId, type) {
			if(menuitemId == "deleteItem"){
				if(!favoritesTree.getSelectedItemId()){
					alert("삭제할 메뉴를 선택해주세요.");
					return;
				}else{
					var prgName = favoritesTree.getItemText(favoritesTree.getSelectedItemId());
					if(confirm("'"+prgName + "'를 삭제하시겠습니까?\n삭제 후 저장버튼을 클릭해야 반영됩니다.")){
						favoritesTree.deleteItem(favoritesTree.getSelectedItemId(), true);
					}
				}
			
			}
		}

		//new add tab
		function newOpenTab(id,param){		
			if(uiTree.getUserData(id,"url")){	
				if(typeof(uiTabbar._tabs[id]) !== 'undefined'){
					uiTabbar.setTabActive(id);
				}else{
					addTab(id,param);
				}
			}else{
				alert("해당페이지에 권한이 없습니다.");
				return;
			}	
			return true;
			
		}
		
		//remove after add tab
		function newRemoveOpenTab(id,param){
			if(uiTree.getUserData(id,"url")){					
				uiTabbar.removeTab(id,true);
				addTab(id,param);
			}else{
				alert("해당페이지에 권한이 없습니다.");
				return;
			}								
			return true;
		}
		
			

		var activeTab = "notice";
		function onSelect(id,last_id){
			activeTab = id;
			if(id !== "notice"){
				lastUitabbarId = id; 
				uiLayout.cells("a").collapse(); // 접기 Event			
			}else{
				uiLayout.cells("a").expand();			
			}			
			return true;		 
		}

		function doCollapse(itemId){  
			if(uiTabbar.getNumberOfTabs() > 1){
				uiTabbar.setTabActive(lastUitabbarId);			
			}else{
				if(activeTab !== "notice"){
					uiLayout.cells(itemId).collapse(); // 접기 Event			
				}else{
					uiLayout.cells(itemId).expand();			
				}
			}
		}

		function doExpand(itemId){
			uiTabbar.setTabActive(lastUitabbarId);	
			//uiTabbar.setTabActive("notice");
		}



		function findTree(id){  
			uiTree.findItem(uiTreeToolbar.getValue('menuSearchText'));
			return true;
		}

		function doBeforeDrag(sId,sobj){
			if(uiTree.hasChildren(sId) > 0){
				alert("상위폴더는 이동하실수 없습니다.");		
				return;
			}
			return true;
		}

		function doDragIn(sid,tid,sobj,tobj){
			if(sobj!=uiTree){
				return;
		    }else if(tobj != favoritesTree){
				return;
			}
		}

		 function dofavoritesClick(id){  
			if(id == "save"){					
				var ids = (favoritesTree.getSubItems(0)).split(",");
				for (var i=0; i<ids.length; i++){
					favoritesProcessor.setUpdated(ids[i], true, "updated");
					favoritesTree.setUserData(ids[i],"url",uiTree.getUserData(ids[i],"url"));
				}
				favoritesProcessor.sendData();
			}else if(id == "removeTree"){
				onContextFavoritesMenuClick("deleteItem","");
			}else if(id == "selectItemUp"){
				favoritesTree.moveItem(favoritesTree.getSelectedItemId(),"up");
				return true;					
			}else if(id == "selectItemDown"){
				favoritesTree.moveItem(favoritesTree.getSelectedItemId(),'down');
				return true;
			}		
		}

		function doFavoritesDrop(sId,tId,id,sObject,tObject){
			if(sObject.hasChildren(sId) > 0){
				alert("상위폴더는 이동하실수 없습니다.");						
				return false;
			}else{			
				var ids=tObject.getAllSubItems(0).split(",");
				var check={};
				for (var i=0; i<ids.length; i++){
					var label=tObject.getItemText(ids[i]);
					if (!check[label]){
						check[label]=true;
						favoritesTree.setUserData(sId,"url",uiTree.getUserData(sId,"url"));
						favoritesTree.setUserData(sId,"programId",uiTree.getUserData(sId,"programId"));
					}else{
						tObject.deleteItem(ids[i]); //delete duplicate
					}
				}				
				return true;
			}	
		}
		
		function treeOnSelect(id){
			if(uiTree.getUserData(id,"url")){
				uiTree.setItemColor(id,"black","#0000FF");
			}
			return true;
		}
//]]>

</script>
</head>
<%
Calendar calendar = Calendar.getInstance();
SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyy/MM/dd HH:mm:ss");
String currentDate = dateFormat.format(calendar.getTime());

%>
<body style="background-image:url(/img/M9021_back.gif) ; background-repeat: repeat-x;"> 
<div align="center" style="white-space:nowrap; overflow:hidden; position:relative; top:10px;" >
	<table width="1008" height="673" border="0" cellpadding="0" cellspacing="0" style="text-align:center; position:relative; table-layout:fixed;">
		<tr height="49">
			<td>
				<!-- Header Start -->
				<table width="100%" border="0" cellpadding="0" cellspacing="0"  style="white-space:nowrap; overflow:hidden; position:relative; padding-left:0px; padding-right:0px; cursor:default; outline:none; text-align:left;">
					<tr>
						<td>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td background="/img/M9021_logo_back.gif"><img src="/img/M9021_logo.gif" width="279" height="49" /></td>
									<td align="right" background="/img/M9021_logo_back.gif">
										<table width="75%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="110" style="font-size: 12px;color: #333333;font-family: dotum,Tahoma;"><span style="color: #fffca7;font-weight: bold;"><%=userName%></span><span style="color: #ffffff;">님 안녕하세요.</span></td>
												<td><span style="font-size: 12px;color: #ffffff;font-family: dotum,Tahoma;">로그인 <%=currentDate%></span></td>
												<td width="70"><img src="./dhtmlx/codebase/imgs/icon_01.gif" width="18" height="18" align="absmiddle" onClick="javascript:help();"/>&nbsp;<a onclick='javascript:help();' style='cursor:pointer;'><span style="font-size: 12px;color: #ffffff;font-family:dotum,Tahoma;font-weight: bold;" >도움말</span></a></td>
												<td width="80" style="padding-left:10px;" align="left"><img src="./dhtmlx/codebase/imgs/icon_02.gif" width="18" height="18" align="absmiddle" onClick="javascript:logout();"/>&nbsp;<a onclick='javascript:logout();' style='cursor:pointer;'><span style="font-size: 12px;color: #ffffff;font-family:dotum,Tahoma;font-weight: bold;">로그아웃</span></a></td>
												<td width="10">&nbsp;</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<!-- Header End -->
			</td>
		</tr>
		<tr valign="top">
			<td>
				<!-- Contents Start -->
				<div id="contents" style="width:100%; height:624px; text-align:left; position:relative;"></div>
				<!-- Contents End -->
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript">

//<![CDATA[
	uiLayout = new dhtmlXLayoutObject("contents", "2U");//parameters("div","patternType")
	uiLayout.cells("a").setWidth(220);
	uiLayout.cells("a").setText("메뉴");
	uiLayout.cells("a").fixSize(false, true);
	uiLayout.cells("b").fixSize(false, true);
	uiLayout.cells("b").hideHeader();
	uiLayout.attachEvent("onCollapse", doCollapse);
	uiLayout.attachEvent("onExpand", doExpand);

	uiLayoutInner = uiLayout.cells("a").attachLayout("2E");//parameters("div","patternType")	
	uiLayoutInner.cells("a").hideHeader();
	uiLayoutInner.cells("a").setHeight(350);
	uiLayout.cells("a").showHeader();
	uiLayoutInner.cells("b").setText("즐겨찾기");
	uiLayoutInner.setCollapsedText("b", "즐겨찾기");

	 //왼쪽 메뉴 Toolbar
		uiTreeToolbar = uiLayoutInner.cells("a").attachToolbar();
	    uiTreeToolbar.setIconsPath("./dhtmlx/codebase/imgs/");
		uiTreeToolbar.setAlign("left");
    	//uiTreeToolbar.loadXML("./header/kr/portal/menu_toolbar.xml");
		uiTreeToolbar.attachEvent("onClick", findTree);

		
	//contextMenu 오른쪽 마우스 클릭시 나타나는 메뉴
		uiTreeMenu = new dhtmlXMenuObject();
		uiTreeMenu.setIconsPath("./dhtmlx/codebase/imgs/");
		//uiTreeMenu.loadXML("./header/kr/portal/menu_context.xml");
		uiTreeMenu.renderAsContextMenu();
		uiTreeMenu.attachEvent("onClick", onContextMianMenuClick);

	 //왼쪽 메뉴
		uiTree = uiLayoutInner.cells("a").attachTree(); // returns tree object
		uiTree.setSkin('dhx_skyblue'); //default skin
		uiTree.setImagePath("./dhtmlx/codebase/imgs/csh_vista/");// 폴더 이미지 변경
		uiTree.enableDragAndDrop(true,false); //Drag option mode(true:가능 false:불가능)
		uiTree.enableMercyDrag(true); //Drag option mode(target Tree로 이동시 remove 옵션(true:보존 false:삭제)
		uiTree.enableSmartXMLParsing(true);
		//uiTree.loadXML("./header/kr/portal/main_menu.xml"); //menu.xml  load
		uiTree.loadXML("./main_menu.xml");
		uiTree.enableContextMenu(uiTreeMenu);
		uiTree.attachEvent("onClick", openTab);
		uiTree.attachEvent("onSelect", treeOnSelect);		
		uiTree.attachEvent("onBeforeDrag", doBeforeDrag);		
		uiTree.attachEvent("onDragIn", doDragIn);
//		uiTree.setOnDblClickHandler(openTab);

	//왼쪽 즐겨찾기 Toolbar
		uiFavoritesToolbar = uiLayoutInner.cells("b").attachToolbar();
	    uiFavoritesToolbar.setIconsPath("./dhtmlx/codebase/imgs/");
		uiFavoritesToolbar.setAlign("right");
    	//uiFavoritesToolbar.loadXML("./header/kr/portal/favorites_toolbar.xml");
		uiFavoritesToolbar.attachEvent("onClick", dofavoritesClick);


	//왼쪽 즐겨찾기
	//contextMenu 오른쪽 마우스 클릭시 나타나는 메뉴
		favoritesMenu = new dhtmlXMenuObject();
		favoritesMenu.setIconsPath("./dhtmlx/codebase/imgs/");
		//favoritesMenu.loadXML("./header/kr/portal/favorites_context_menu.xml");
		favoritesMenu.renderAsContextMenu();
		favoritesMenu.attachEvent("onClick", onContextFavoritesMenuClick);

		favoritesTree =  uiLayoutInner.cells("b").attachTree(); // returns tree object
		favoritesTree.setSkin('dhx_skyblue');//default skin
		favoritesTree.setImagePath("./dhtmlx/codebase/imgs/csh_vista/");// 폴더 이미지 변경
		favoritesTree.enableDragAndDrop(true);//Drag option mode(true:가능 false:불가능)
		favoritesTree.enableSmartXMLParsing(true);
		favoritesTree.enableMercyDrag(false); //Drag option mode(target Tree로 이동시 remove 옵션(true:보존 false:삭제)
		favoritesTree.setDragBehavior("sibling");
		favoritesTree.enableContextMenu(favoritesMenu);		
		//favoritesTree.loadXML("favoritesMenu.do?ServiceName=favorites-service&find=1&USER_ID="+<%=userId%>);
		favoritesTree.attachEvent("onDrop", doFavoritesDrop);
		
		favoritesTree.attachEvent("onDblClick",openTab);
		
		favoritesProcessor = new dataProcessor("favoritesTreeHandle.do?ServiceName=favorites-service&save=1");
		favoritesProcessor.enableDataNames(true);				
		favoritesProcessor.setUpdateMode("off");				
		favoritesProcessor.setTransactionMode("POST", true);	
		favoritesProcessor.enableUTFencoding("true");
		favoritesProcessor.init(favoritesTree);
		favoritesProcessor.defineAction("appMsg", function(node){
			if(node != null){
				alert("정상적으로 저장되었습니다.");//alert(node.firstChild.data);
			}
        });
        
        favoritesProcessor.defineAction("errMsg", function(node){
			if(node != null){
				alert(node.firstChild.data);
			}
        });

	//오른쪽 tabbar
		uiTabbar = uiLayout.cells("b").attachTabbar();
		uiTabbar.setSkin("modern");//default skin
		uiTabbar.setImagePath("./dhtmlx/codebase/imgs/");//images path
		uiTabbar.enableTabCloseButton(true);//removeTab Option(true:가능 false:불가능)
		uiTabbar.setOffset("5");//Tab 간격
		uiTabbar.setMargin("8");		
		//uiTabbar.addTab("notice","공지사항","100px",0);//addTab(id, text, size, position, row)
		//uiTabbar._tabs["notice"].title = "공지사항";//Tabbar tooltip 설정;
		//uiTabbar.setTabActive("notice");//tab to active state 
		uiTabbar.attachEvent("onTabClose", onTabClose);//Tab close button event
		uiTabbar.attachEvent("onSelect", onSelect);
		/*events to hide/show a fake tab*/
		//uiTabbar.attachEvent("onBeforeShowScroll",addFakeTab);
		//uiTabbar.attachEvent("onBeforeHideScroll",removeFakeTab);		

		//uiLayoutInner1 = uiTabbar.cells("notice").attachLayout("1C","dhx_skyblue");
		//uiLayoutInner1.cells("a").hideHeader();
		//uiLayoutInner1.cells("a").attachURL("notice.do");

		function addFakeTab(){
			  window.setTimeout(function(){
					uiTabbar.enableTabCloseButton(false);
					uiTabbar.addTab("fake","","20px",uiTabbar.getAllTabs().length);
					uiTabbar.disableTab("fake");
					uiTabbar.enableTabCloseButton(true);
					/*removes styling for the fake item*/
					uiTabbar._tabs["fake"].className = "";
					uiTabbar._tabs["fake"].style.position = "absolute";
			},1);
		}
			
		function removeFakeTab(){
			window.setTimeout(function(){
				uiTabbar.removeTab("fake",true);
			},1);
		}

		function getAllTabs(){
			var tabs = [];
			for(var id in uiTabbar._tabs)
				tabs.push(id);
			return tabs;
		}
//]]>

</script>
</body>
</html>