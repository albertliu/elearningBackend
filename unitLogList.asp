<!--#include file="js/doc.js" -->
<%
var nodeID = "";
var kindID = 0;

if (String(Request.QueryString("nodeID")) != "undefined" && 
    String(Request.QueryString("nodeID")) != "" && String(Request.QueryString("nodeID")) != "null") { 
  nodeID = unescape(String(Request.QueryString("nodeID")));
}
if (String(Request.QueryString("kindID")) != "undefined" && 
    String(Request.QueryString("kindID")) != "" && String(Request.QueryString("kindID")) != "null") { 
  kindID = unescape(String(Request.QueryString("kindID")));
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table.css" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<script language="javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<!--#include file="js/correctPng.js"-->

<script language="javascript">
	var refID = "";
	var item = "";
	var kindID = 0;
	var lastRenameID = "";
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		refID = "<%=nodeID%>";
		kindID = "<%=kindID%>";
		
		$.get("unitControl.asp?op=getNameByCode&nodeID=" + refID + "&times=" + (new Date().getTime()),function(re){
			item = unescape(re);
			if(item==""){
				item = "未知";
				jAlert("该单位在本系统中没有记录。","提示信息");
			}
			$("#item").html(item + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + refID);
			$("#kindSelect").change(function(){
				getUnitLogList();
			});
			
			$("#userSelect").change(function(){
				getUnitLogList();
			});
			
			getUnitLogKindList();
			getUnitLogUserList();
			if(kindID > 0){
				$("#kindSelect").val(kindID);
			}
			getUnitLogList();
		});
	});
	
	function getUnitLogList(){
		var kind = $("#kindSelect").val();
		var operator = $("#userSelect").val();
		
		$.get("unitLogControl.asp?op=getLastRenameID&nodeID=" + refID + "&times=" + (new Date().getTime()),function(data){
			lastRenameID = data;
		});
		
		$.get("unitLogControl.asp?op=getUnitLogList&nodeID=" + refID + "&kind=" + kind + "&operator=" + operator + "&times=" + (new Date().getTime()),function(data){
			//alert("5:"+unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#listCover").empty();
			var s = "";					
			s += "<table cellpadding='0' cellspacing='0' border='0' class='display' id='listTab' width='95%'>";
			s += "<thead>";
			s += "<tr align='center'>";
			s += "<th width='12%'>操作项目</th>";
			s += "<th width='12%'>操作日期</th>";
			s += "<th width='10%'>操作人</th>";
			s += "<th width='40%'>备注</th>";
			s += "<th width='10%'>类型</th>";
			s += "<th width='8%'>属性</th>";
			s += "<th width='8%'>附件</th>";
			s += "</tr>";
			s += "</thead>";
			s += "<tbody id='tbody'>";
			var i = 0;
			var c = "";
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					s += "<tr class='grade0'>";
					if(ar1[7]==3 && ar1[0]==lastRenameID && (ar1[9]==currUser || checkPermission("admin"))){
						s += "<td width='12%' class='left'>" + ar1[2] + "<a href='javascript:void(0);' onClick='delUnitRename(\"" + ar1[0] + "\");' ><img src='images/cancel.png' border='0' width='18' height='12' title='撤销更名'></a></td>";
					}else{
						s += "<td width='12%' class='left'>" + ar1[2] + "</td>";
					}
					s += "<td width='12%' class='left'>" + ar1[3] + "</td>";
					s += "<td width='10%' class='left'>" + ar1[4] + "</td>";
					c = ar1[5];
					if(c.length > 30){
						c = c.substr(0,30) + " ...";
						s += "<td width='40%' class='link1'><a href='javascript:jAlert(\"" + ar1[5] + "\");'>" + c + "</a></td>";
					}else{
						s += "<td width='40%' class='left'>" + ar1[5] + "</td>";
					}
					s += "<td width='10%' class='left'>" + ar1[1] + "</td>";
					s += "<td width='8%' class='left'>" + ar1[6] + "</td>";
					if(kind==3){
						s += "<td width='8%' class='left'>" + ar1[10] + "</td>";
					}else{
						s += "<td width='8%' class='left'>&nbsp;</td>";
					}
					s += "</tr>";
				});
			}
			s += "</tbody>";
			s += "<tfoot>";
			s += "<tr>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "</tr>";
			s += "</tfoot>";
			s += "</table>";
			$("#listCover").html(s);
			$('#listTab').dataTable({
				"aaSorting": [],
				"bLengthChange": true,
				"aLengthMenu": [[15, 25, 30, -1], [15, 25, 30, "All"]],
				"bFilter": true,
				"aoColumnDefs": []
			});
		});
	}

	function getUnitLogKindList(){
		$.get("unitLogControl.asp?op=getUnitLogKindList&nodeID=" + refID + "&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#kindSelect").empty();
			$("<option value='99'>全部类型</option>").appendTo("#kindSelect");
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#kindSelect");
				});
			}
		});
	}

	function getUnitLogUserList(){
		$.get("unitLogControl.asp?op=getUnitLogUserList&nodeID=" + refID + "&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#userSelect").empty();
			$("<option value=''>全部操作人</option>").appendTo("#userSelect");
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#userSelect");
				});
			}
		});
	}

	function delUnitRename(nodeID){
		jConfirm('你确定要撤销这份更名函吗?相关的更名函并档也将撤销。', '确认对话框', function(r) {
			if(r){
				jPrompt("请输入操作原因：","","输入窗口",function(x){
					if(x && x.length>1){
						$.get("mergeControl.asp?op=delUnitRename&nodeID=" + nodeID + "&where=" + escape(x) + "&times=" + (new Date().getTime()),function(re){
							jAlert("成功撤销更名函","提示信息");
							getUnitLogList();
						});
					}else{
						jAlert("请认真填写撤销原因","信息提示");
					}
				});
			}
		});
	}
</script>

</head>

<body>

<div id='layout' align='left'>	
	<div class="comm" style="background:#dddddd;"><h2><span id="item"></span></h2></div>
	
	<div class="comm" align='left' style="background:#fdfdfd;">
		<form>
			<label>操作类型：</label>
			<select id="kindSelect" name="kindSelect" style="width:100px"></select>
      &nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;
			<label>操作人：</label>
			<select id="userSelect" name="userSelect" style="width:100px"></select>
    </form>
	</div>
	<hr size="1" noshadow>
	
	<div style="width:99%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div id="listCover" style="float:top;margin:3px;background:#f8fff8;">
			</div>
		</div>
	</div>
</div>
</body>
