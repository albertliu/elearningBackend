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
	let nodeID = "";
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//applyID
		
		$.ajaxSetup({ 
			async: false 
		}); 

		getApplyDetail();
	});

	function getApplyDetail(){
		$.post(uploadURL + "/public/postCommInfo", {proc:"getApplyDetail", params:{applyID: nodeID}}, function(data){
			if (data.length === 0) {
				$("#cover").html("无考试信息");
				return;
			}
			$("#cover").empty();
			arr = [];					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='4%'>No</th>");
			arr.push("<th width='18%'>准考证号</th>");
			arr.push("<th width='18%'>考试日期</th>");
			arr.push("<th width='26%'>考试地点</th>");
			arr.push("<th width='12%'>类型</th>");
			arr.push("<th width='12%'>成绩</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			var c = 0;
			$.each(data,function(iNum,val){
				i += 1;
				arr.push("<tr class='grade" + c + "'>");
				arr.push("<td class='center'>" + i + "</td>");
				arr.push("<td class='link1'><a href='javascript:showApplyDetailInfo(" + val["ID"] + ",0,1);'>" + val["examNo"] + "</a></td>");
				arr.push("<td class='left'>" + val["examDate"] + "</td>");
				arr.push("<td class='left'>" + val["examAddress"] + "</td>");
				arr.push("<td class='left'>" + val["kindName"] + "</td>");
				arr.push("<td class='left'>" + val["score"] + "</td>");
				arr.push("</tr>");
			});
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
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
				"aLengthMenu":[15,30,50],
				"iDisplayLength": 30,
				"bInfo": true,
				"aoColumnDefs": []
			});
 		});
	}
</script>

</head>

<body>

<div id='layout' align='left' style="background:#f0f0f0;">	
	<div id="cover" style="float:left;width:100%;">
	</div>
</div>
</body>
