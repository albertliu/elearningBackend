﻿<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css?v=1.8.6">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link href="css/jquery-confirm.css" rel="stylesheet" type="text/css" media="screen" />
<script language="javascript" src="js/jquery-1.12.4.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js?v=1.8.6"></script>
<script src="js/jquery-confirm.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>

<script language="javascript">
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//username
		refID = "<%=refID%>";	//enterID
		op = "<%=op%>";
		keyID = 0;  //private
		
		$.ajaxSetup({ 
			async: false 
		});
		
		$("#btnSearch").click(function(){
			getStudentServiceList();
		});
		
		$("#txtSearch").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearch").val()>""){
					getStudentServiceList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		
		$("#btnAdd").click(function(){
			showStudentServiceInfo(0,nodeID,refID,1,1);	//showClassInfo(nodeID,refID,op,mark) op:0 浏览 1 新增; mark:0 不动作  1 有修改时刷新列表
		});

		getStudentServiceList();
	});

	function getStudentServiceList(){
		//alert(refID + ":" + nodeID);
		if(checkRole("saler") || checkRole("leader")){
			keyID = 1;	//销售或领导可以查看所有记录，其他只能看公开记录
		}

		$.get("studentControl.asp?op=getStudentServiceList&nodeID=" + nodeID + "&refID=" + refID + "&keyID=" + keyID + "&dk=1011&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover").empty();
			arr = [];					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='4%'>No</th>");
			arr.push("<th width='15%'>服务日期</th>");
			arr.push("<th width='12%'>方式</th>");
			arr.push("<th width='40%'>服务内容</th>");
			arr.push("<th width='15%'>备注</th>");
			arr.push("<th width='12%'>登记人</th>");
			// arr.push("<th width='12%'>登记日期</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var imgChk = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showStudentServiceInfo(" + ar1[0] + ",\"" + nodeID + "\",\"" + refID + "\",0,1);'>" + ar1[6] + "</a></td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
					// arr.push("<td class='left'>" + ar1[8] + "</td>");
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
			// arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#cover").html(arr.join(""));
			arr = [];
			$('#cardTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100],
				"iDisplayLength": 100,
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
	
	function setButton(){
		$("#btnAdd").hide();
		if(checkPermission("studentEdit") || checkRole("saler") || checkRole("adviser")){
			$("#btnAdd").show();
		}
	}
</script>

</head>

<body>

<div id='layout' align='left' style="background:#f0f0f0;">
	<form><label>搜索：</label>
		<input type="text" id="txtSearch" name="txtSearchClass" size="15" title="服务内容" style="background:yellow;" />
		<input class="button" type="button" name="btnSearch" id="btnSearch" value="查找" />
		<input class="button" type="button" id="btnAdd" name="btnAdd" value="新增" />
		<span style="float:right;">
			<input class="button" type="button" id="btnDownLoad" onClick="outputFloat(1011,'file')" value="下载" />
		</span>
	</form>
	<div id="cover" style="float:left;width:100%;">
	</div>
</div>
</body>
