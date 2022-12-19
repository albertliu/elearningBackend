<%
var event = "";
var msg = "";
if (String(Request.QueryString("event")) != "undefined" && 
    String(Request.QueryString("event")) != "") { 
  event = String(Request.QueryString("event"));
}
if (String(Request.QueryString("msg")) != "undefined" && 
    String(Request.QueryString("msg")) != "") { 
  msg = String(Request.QueryString("msg"));
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>电子证书</title>
<link href="css/style_main.css?v=1.3"  rel="stylesheet" type="text/css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript">
	$(document).ready(function (){
      nodeID = "<%=msg%>";
      //window.innerWidth = 86mm;
      //alert(nodeID);
      $.get("http://shznxfxx.cn:8081/public/getPDF2img?path=" + nodeID,function(data){
         //alert(data);
         $("#img").prop("src",data);
      });
      $.ajaxSetup({ 
			async: false 
		}); 
	});
</script>
</head>

<body>
<div id="layout">
   <div style="height:100%;">
      <img id="img" src="" style="display: flex; width:80%;padding:50px;margin:0 auto;-webkit-filter: drop-shadow(10px 10px 10px rgba(0, 0, 0, .5));filter: drop-shadow(10px 10px 10px rgba(0, 0, 0, .5));" />
   </div>
</div>

</body>
</html>
