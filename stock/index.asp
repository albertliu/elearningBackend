<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="edge" />
<title>股票信息</title>

<link href="../css/style_inner1.css?v=1.0"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="../css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="../css/easyui/icon.css">
<link rel="stylesheet" href="../css/tab-view.css?v=1.0" type="text/css" media="screen">
<link rel="stylesheet" href="../css/jquery.tabs.css" type="text/css" media="print, projection, screen">
<link href="../css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="../css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="../css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="../css/jquery.autocomplete.css" />
<link rel="stylesheet" type="text/css" href="../js/easyui/themes/default/easyui.css?v=1.11">
<link rel="stylesheet" type="text/css" href="../js/easyui/themes/icon.css?v=1.11">
<script language="javascript" src="../js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="../js/easyui/jquery.easyui.min.js?v=1.23"></script>
<script type="text/javascript" src="../js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
<script language="javascript" src="../js/jquery.form.js"></script>
<script type="text/javascript" src="../js/jquery.easyui.min.js"></script>
<script src="../js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="../js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="../js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="../js/tab-view.js"></script>
<script src="../js/datepicker/WdatePicker.js" type="text/javascript"></script>

<script language="javascript">
	<!--#include file="stockListIncReady.js"-->

	$(document).ready(function (){
		$.ajaxSetup({ 
			async: false 
		});
		$('#container-1').tabs({ 
			fxAutoHeight: true
		});
	});

</script>

</head>

<body>
<div id="layout">
	<table border="0" cellpadding="0" cellspacing="0" valign="top" width="100%">
		<tr>
			<td valign="top" style="height:400px; text-align: left;">
				<div id="container-1" align="left">
					<ul class="tabs-nav">
						<li id="menu0"><a href="#fragment-0"><span>股票列表</span></a></li>
						<li id="menu1"><a href="#fragment-1"><span>用户管理</span></a></li>
					</ul>
					<div id="fragment-0">
						<!--#include file="stockListIncDetail.js"-->
					</div>
					
					<div id="fragment-1">
						
					</div>
				</div>
			</td>
		</tr>
	</table>
	<div class="clear"></div>
</div>
  
</body>
</html>
