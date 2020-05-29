<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table.css" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<!--#include file="js/correctPng.js"-->

<script language="javascript">
	var unitID = "";
	var projectID = "";
	var item = "";
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		unitID = "<%=nodeID%>";
		projectID = "<%=keyID%>";
		
		$.get("unitControl.asp?op=getNameByCode&nodeID=" + unitID + "&times=" + (new Date().getTime()),function(re){
			item = unescape(re);
			$("#item").html("[" + item + "] 联系人名单");
			if(projectID>0){
				$.get("projectControl.asp?op=getNameByCode&nodeID=" + projectID + "&times=" + (new Date().getTime()),function(data){
					$("#item").html("[" + item + "]-[" + unescape(data) + "] 联系人名单");
				});
			}
			getUnitLinkerList();
		});
		
		$("#btnAddNew").click(function(){
			showUnitLinkerInfo(0,1,1);	//showUnitInfo(nodeID,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		});
	});
	
	function getUnitLinkerList(){
		//alert("nodeID=" + unitID + "&keyID=" + projectID);
		$.get("unitLinkerControl.asp?op=getUnitLinkerList&nodeID=" + unitID + "&keyID=" + projectID + "&dk=101&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#listCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='listTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='4%'>No</th>");
			arr.push("<th width='10%'>姓名</th>");
			arr.push("<th width='12%'>职务</th>");
			arr.push("<th width='16%'>固定电话</th>");
			arr.push("<th width='16%'>移动电话</th>");
			arr.push("<th width='22%'>项目</th>");
			arr.push("<th width='10%'>状态</th>");
			arr.push("<th width='10%'>登记</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td width='4%' class='left'>" + i + "</td>");
					arr.push("<td width='10%' class='link1'><a href='javascript:getUnitLinkerInfo(\"" + ar1[0] + "\");'>" + ar1[4] + "</a></td>");
					arr.push("<td width='12%' class='left'>" + ar1[7] + "</td>");
					arr.push("<td width='16%' class='left'>" + ar1[8] + "</td>");
					arr.push("<td width='16%' class='left'>" + ar1[9] + "</td>");
					arr.push("<td width='22%' class='left'>" + ar1[15] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[6] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[19] + "</td>");
					arr.push("</tr>");
				});
			}
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#listCover").html(arr.join(""));
			arr = [];
			$('#listTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"bInfo": true,
				"aoColumnDefs": []
			});
			floatCount = i;
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "打印日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatModel = 1;
		});
	}
	
</script>

</head>

<body>

<div id='layout' align='left'>	
	<div class="comm" style="background:#dddddd;"><h2><span id="item"></span></h2></div>
	<hr size="1" noshadow>
	
	<div style="width:99%;float:left;margin:0;">
		<div class="comm" align='left' style="background:#fdfdfd;">
			<form><label>搜索：</label>
        <input type="text" id="txtSearch" name="txtSearch" size="20" title="姓名" style="background:yellow;" />
        <input class="button" type="button" name="btnSearch" id="btnSearch" value="查找">
	      &nbsp;&nbsp;|&nbsp;&nbsp;
	      <input class="button" type="button" id="btnAddNew" name="btnAddNew" value="新增" />
	      &nbsp;&nbsp;|&nbsp;&nbsp;
		    <input class="button" type="button" name="btnDownLoad" id="btnDownLoad" onClick="outputFloat(101,'file')" value="下载">
		    <input class="button" type="button" name="btnPrint" id="btnPrint" onClick="outputFloat(101,'print')" value="打印">
      </form>
		</div>
		<hr size="1" noshadow>
		<div style="border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div id="listCover" style="float:top;margin:3px;background:#f8fff8;">
			</div>
		</div>
	</div>
</div>
</body>
