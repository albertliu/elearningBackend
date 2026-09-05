<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-1.12.4.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>

<script language="javascript">
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		
		$.ajaxSetup({ 
			async: false 
		});
		
		$("#btnSave").click(function(){
			saveNode();
		});

		getExamPlaceList();
	});

	function getExamPlaceList(){
		$.post(uploadURL + "/public/postCommInfo", {proc:"getWarningCourseList", params:{}}, function(data1){
			if(data1.length > 0){
				$.each(data1,function(iNum,ar){
					$("#" + ar["certID"]).prop("checked",ar["warning"]==0);
				});
			}
		});
		$.post(uploadURL + "/public/postCommInfo", {proc:"getExamPlaceFreeList", params:{}}, function(data){
			$("#cover").empty();
			arr = [];					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='4%'>No</th>");
			arr.push("<th width='16%'>考试项目</th>");
			arr.push("<th width='30%'>考点名称</th>");
			arr.push("<th width='18%'>考试日期</th>");
			arr.push("<th width='11%'>总位</th>");
			arr.push("<th width='11%'>空位</th>");
			arr.push("<th width='10%'>报警</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(data.length > 0){
				var i = 0;
				var c = 0;
				$.each(data,function(iNum,ar){
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showExamPlaceInfo(" + ar["ID"] + ",0,1);'>" + ar["courseName"] + "</a></td>");
					arr.push("<td class='left'>" + ar["examAddress"] + "</td>");
					arr.push("<td class='left'>" + ar["examDate"] + "</td>");
					arr.push("<td class='left'>" + ar["s_all"] + "</td>");
					arr.push("<td class='left'>" + ar["s_free"] + "</td>");
					arr.push("<td class='left'>" + (ar["warning"] == 0 ? imgChk : "") + "</td>");
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
		});
	}
	
	function saveNode(){
		let C12 = $("#C12").prop("checked") ? 0 : 1;
		let C15 = $("#C15").prop("checked") ? 0 : 1;
		let C24 = $("#C24").prop("checked") ? 0 : 1;
		let C25A = $("#C25A").prop("checked") ? 0 : 1;
		let C16 = $("#C16").prop("checked") ? 0 : 1;
		let C17 = $("#C17").prop("checked") ? 0 : 1;
		$.post(uploadURL + "/public/postCommInfo", {proc:"updatetWarningCourse", params:{C12:C12,C15:C15,C24:C24,C25A:C25A,C16:C16,C17:C17}}, function(data){
			jAlert("保存成功！","信息提示");
		});
	}
	
	function setButton(){
		$("#btnSave").hide();
		if(checkPermission("applyEdit") || checkPermission("studentAdd")){
			$("#btnSave").show();
		}
	}
</script>

</head>

<body>

<div id='layout' align='left' style="background:#f0f0f0;">
	<div style="text-align: center; color: #7e7d7d; font-size: 1.2em;">警告项目&nbsp;&nbsp;<input class="button" type="button" id="btnSave" value=" 保存 " /></div>
	<div id="warning-cover" style="float:left;width:100%; padding-left:30px; margin-top:5px; margin-bottom:5px;">
		<input style="border:0px;" type="checkbox" id="C12" value="" />&nbsp;低压电工&nbsp;&nbsp;
		<input style="border:0px;" type="checkbox" id="C15" value="" />&nbsp;高处作业&nbsp;&nbsp;
		<input style="border:0px;" type="checkbox" id="C24" value="" />&nbsp;焊工&nbsp;&nbsp;
		<input style="border:0px;" type="checkbox" id="C25A" value="" />&nbsp;涉氨制冷&nbsp;&nbsp;
		<input style="border:0px;" type="checkbox" id="C16" value="" />&nbsp;负责人&nbsp;&nbsp;
		<input style="border:0px;" type="checkbox" id="C17" value="" />&nbsp;管理人员&nbsp;&nbsp;
	</div>
	<hr size="1" noshadow />
	<div id="cover" style="float:left;width:100%;">
	</div>
</div>
</body>
