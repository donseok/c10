/**
 * Load the library located at the same path with this file
 *
 * - Current hostname is localhost
 * - Current protocol is "file:"
 *
 * Will load dhtmlx.css,json_sans_eval.js,dhtmlx.js,gluegun.ui.js (minified) otherwise
 * hostname is localhost dhtmlxdataprocessor_debug.js load (option)
 */
(function() {
	  window.uiVersion = "1.1";
	  window.dhx_globalImgPath="./dhtmlx/codebase/imgs/";
	  window.jsFileDirPath = "./dhtmlx/codebase/";
	  window.isServerMode = true;
	  window.master_combo_url = "basicLovData.do?ServiceName=lov-service";
	  var scripts = document.getElementsByTagName('script'),
        localhostTests = [
            /^localhost:8888$/,
            /^127.0.0.1:7001$/,
	       		/^localhost:7001$/
        ],
        host = window.location.host,
        isDevelopment = false,
        queryString = window.location.search,
        test, path, i, ln, scriptSrc, match;

    for (i = 0, ln = scripts.length; i < ln; i++) {
        scriptSrc = scripts[i].src;

        match = scriptSrc.match(/glue.ui.bootstrap\.js$/);

        if (match) {
            path = scriptSrc.substring(0, scriptSrc.length - match[0].length);
            break;
        }
    }
    if (isDevelopment === null) {
        for (i = 0, ln = localhostTests.length; i < ln; i++) {
            test = localhostTests[i];

            if (host.search(test) !== -1) {
                isDevelopment = true;
                break;
            }
        }
    }
    
    if (isDevelopment && window.location.protocol === "file:") {
       isServerMode = false;
    }else if (!isDevelopment && window.location.protocol === "http:" && (window.location.port == 80 || || window.location.port == 8080 || window.location.port == "")) {
    	 dhx_globalImgPath="/dhtmlx/codebase/imgs/";
    	 jsFileDirPath = "/dhtmlx/codebase/";
    }

    if(!isServerMode){
      document.write("<script src=\"" + jsFileDirPath + "dhtmlx_non_grid_all.js\" type=\"text/javascript\"></script>");
      document.write("<script src=\"" + jsFileDirPath + "dhtmlxgrid.js\" type=\"text/javascript\"></script>"); 
      document.write("<script src=\"" + jsFileDirPath + "dhtmlxgrid_srnd.js\" type=\"text/javascript\"></script>");
      document.write("<script src=\"" + jsFileDirPath + "dhtmlxgrid_splt.js\" type=\"text/javascript\"></script>"); 
      document.write("<script src=\"" + jsFileDirPath + "dhtmlxgrid_markers.js\" type=\"text/javascript\"></script>"); 
      document.write("<script src=\"" + jsFileDirPath + "dhtmlxgrid_undo.js\" type=\"text/javascript\"></script>"); 
      document.write("<script src=\"" + jsFileDirPath + "dhtmlxgrid_excell_combo_custom.js\" type=\"text/javascript\"></script>"); 
      document.write("<script src=\"" + jsFileDirPath + "dhtmlxgrid_excell_dhxcalendar.js\" type=\"text/javascript\"></script>"); 
      document.write("<script src=\"" + jsFileDirPath + "dhtmlxgrid_selection.js\" type=\"text/javascript\"></script>"); 
      document.write("<script src=\"" + jsFileDirPath + "dhtmlxgrid_nxml.js\" type=\"text/javascript\"></script>"); 
      document.write("<script src=\"" + jsFileDirPath + "dhtmlxgrid_export.js\" type=\"text/javascript\"></script>");
      document.write("<script src=\"" + jsFileDirPath + "dhtmlxgridcell.js\" type=\"text/javascript\"></script>"); 
	  document.write("<script src=\"" + jsFileDirPath + "dhtmlx.custom.js\" type=\"text/javascript\"></script>");
      document.write("<script src=\"" + jsFileDirPath + "dhtmlxgrid_json.js\" type=\"text/javascript\"></script>");
      document.write("<script src=\"" + jsFileDirPath + "json2-min.js\" type=\"text/javascript\"></script>"); 
      document.write("<script src=\"" + jsFileDirPath + "gluegun.ui.js\" type=\"text/javascript\"></script>"); 
    }  
    document.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"" + jsFileDirPath + "dhtmlx_custom.css?v=1.0\"/>");
    document.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"" + jsFileDirPath + "dhtmlx_message.css?v=1.1\"/>");	
    document.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"" + jsFileDirPath + "dhtmlx_grid_custom.css?v=1.0\"/>");
    
    if(!isDevelopment && window.location.protocol === "http:" && (window.location.port == 80 || window.location.port == 8080 || window.location.port == "")){
		  window.document.domain="unionsteel.co.kr";
	  }
})();
  importXhrJS = function(jsFile, alwaysReload){
   
        var url = jsFileDirPath + jsFile;
        var xhr = null;
        var jsSource = "";
     
        if (window.XMLHttpRequest) {
            xhr = new XMLHttpRequest();
        } else {
            xhr = new ActiveXObject("Microsoft.XMLHTTP");
        }
        if( xhr ){
            xhr.open('get', url, false);
            xhr.send(null);
            
            jsSource = xhr.responseText;
        }
          return jsSource;
  }  
  
  importJS = function(jsFile, alwaysReload) {
  
    if (typeof(document.js_list) == "undefined") {
            document.js_list = new Array();
        }
     
        var isExist = false;
        for (var i = 0; i < document.js_list.length; i++) {
            if (document.js_list[i] == jsFile) {
                isExist = true;
                break;
            }
        }
        if (!isExist) {
            document.js_list.push(jsFile);
            var param = (alwaysReload) ? "?v=" + uiVersion : "?v=1.0";
            return importXhrJS(jsFile + param, importJS);
        } else {
            return "";
        }  
  }
if(isServerMode){
  if(window.location.protocol){
    eval(importJS("dhtmlx_non_grid_all.js",true));
    eval(importJS("dhtmlxgrid.js",true));
    eval(importJS("dhtmlxgrid_srnd.js",true));
    eval(importJS("dhtmlxgrid_markers.js",true)); 
    eval(importJS("dhtmlxgrid_undo.js",true));
    eval(importJS("dhtmlxgrid_nxml.js",true));
    eval(importJS("dhtmlxgrid_oneheader_splt.js",true));
    eval(importJS("dhtmlxgrid_export.js",true));
    eval(importJS("dhtmlxgrid_selection.js",true)); 
    eval(importJS("dhtmlxgridcell.js",true));
    eval(importJS("dhtmlxgrid_excell_combo_custom.js",true));
    eval(importJS("dhtmlxgrid_excell_dhxcalendar.js",true));
    //eval(importJS("dhtmlxdataprocessor.js",true));
    //eval(importJS("dhtmlx.message.js",true));
    eval(importJS("dhtmlx.custom.js",true));
    eval(importJS("dhtmlxgrid_json.js",true));
    eval(importJS("json2-min.js",true));
    eval(importJS("gluegun.ui.js",true));
  }
}
