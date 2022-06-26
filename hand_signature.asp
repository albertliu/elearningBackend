<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title></title>

<link href="css/style_inner1.css?v=1.3"  rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/jSignature.js"></script>

<script language="javascript">
	var nodeID = "";
	var refID = "";
	var op = 0;
	var updateCount = 0;

	<!--#include file="js/commFunction.js"-->

	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";	//username
		op = "<%=op%>";
		$("#signature").jSignature();
		$.ajaxSetup({ 
			async: false 
		}); 
	});
//输出签名图片
	function jSignatureTest(){
		var $sigdiv = $("#signature");
		var datapair = $sigdiv.jSignature("getData", "image")
//          datapair = ["image/svg+xml;base64","PD94bWwgdmVyc2lvbj0iMS4wIi
//          BlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+PCFET0NUWVBFIHN2Zy
//          BQVUJMSUMgIi0vL1czQy8vRFREIFNWRyAxLjEvL0VOIiAiaHR0cDovL3d3dy53My
//          5vcmcvR3JhcGhpY3MvU1ZHLzEuMS9EVEQvc3ZnMTEuZHRkIj48c3ZnIHhtbG5zPS
//          JodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgdmVyc2lvbj0iMS4xIiB3aWR0aD
//          0iMzEiIGhlaWdodD0iMzQiPjxwYXRoIGZpbGw9Im5vbmUiIHN0cm9rZT0iIzAwMD
//          AwMCIgc3Ryb2tlLXdpZHRoPSIyIiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm
//          9rZS1saW5lam9pbj0icm91bmQiIGQ9Ik0gMSAxIGMgMC4xMiAwLjExIDUuMDEgMy
//          43NiA3IDYgYyAzLjI1IDMuNjUgNS43MSA4LjM1IDkgMTIgYyAyLjY0IDIuOTMgNi
//          4zNyA1LjE2IDkgOCBjIDEuNTggMS43IDQgNiA0IDYiLz48L3N2Zz4="]
		var img = new Image();
		img.src = "data:" + datapair[0] + "," + datapair[1];
		$(img).appendTo($("#image"));

		jConfirm('确定要提交签名吗?', '确认对话框', function(r) {
			if(r){
				$.post(uploadURL + "/outfiles/uploadBase64img",{upID:"student_letter_signature",username:nodeID,currUser:currUser,imgData:datapair[1]},function(re){
					alert("签名成功。");
				});
			}
		});
	}

	function reset(){
		var $sigdiv = $("#signature");
		$sigdiv.jSignature("reset");
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	<div id="signature" style="height: 100%; border:1px solid #000"></div>
	<button type="button" onclick="jSignatureTest()">生成签名</button>
	<button type="button" onclick="reset()">重置签名</button>
	<div id="image" style="margin:20px"></div>
</div>
</body>
