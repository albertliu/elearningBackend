<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/data_table.css" rel="stylesheet" type="text/css" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var refID = "";
	var item = "";
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		refID = "<%=refID%>";	//archiveID
		getDicList("archLogKind","kind",1);
		$.get("archivesControl.asp?op=getItemByID&nodeID=" + refID + "&times=" + (new Date().getTime()),function(re){
			item = unescape(re);
			if(item==""){
				item = "未知";
				jAlert("该档案在本系统中没有记录。","提示信息");
			}
			$("#item").html(item);
		});
			
		$("#kind").change(function(){
			getArchiveLogList();
		});
		getArchiveLogList();
	});
	
	function getArchiveLogList(){
		var kind = $("#kind").val();
		//alert( refID + "&kindID=" + kind);
		$.get("archiveLogControl.asp?op=getArchiveLogList&nodeID=" + refID + "&kindID=" + kind + "&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#listCover").empty();
			arr = [];					
			arr.push( "<table cellpadding='0' cellspacing='0' border='0' class='display' id='listTab' width='95%'>");
			arr.push( "<thead>");
			arr.push( "<tr align='center'>");
			arr.push( "<th width='12%'>操作项目</th>");
			arr.push( "<th width='15%'>操作日期</th>");
			arr.push( "<th width='10%'>操作人</th>");
			arr.push( "<th width='10%'>类型</th>");
			arr.push( "<th width='40%'>备注</th>");
			arr.push( "</tr>");
			arr.push( "</thead>");
			arr.push( "<tbody id='tbody'>");
			var i = 0;
			var c = "";
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push( "<tr class='grade0'>");
					arr.push( "<td width='12%' class='left'>" + ar1[4] + "</td>");
					arr.push( "<td width='15%' class='left'>" + ar1[6] + "</td>");
					arr.push( "<td width='10%' class='left'>" + ar1[7] + "</td>");
					arr.push( "<td width='10%' class='left'>" + ar1[3] + "</td>");
					c = ar1[5];
					if(c.length > 30){
						c = c.substr(0,30) + " ...";
						arr.push( "<td width='40%' class='link1'><a href='javascript:jAlert(\"" + ar1[5] + "\");'>" + c + "</a></td>");
					}else{
						arr.push( "<td width='40%' class='left'>" + ar1[5] + "</td>");
					}
					arr.push( "</tr>");
				});
			}
			arr.push( "</tbody>");
			arr.push( "<tfoot>");
			arr.push( "<tr>");
			arr.push( "<th>&nbsp;</th>");
			arr.push( "<th>&nbsp;</th>");
			arr.push( "<th>&nbsp;</th>");
			arr.push( "<th>&nbsp;</th>");
			arr.push( "<th>&nbsp;</th>");
			arr.push( "</tr>");
			arr.push( "</tfoot>");
			arr.push( "</table>");
			$("#listCover").html(arr.join(""));
			arr = [];					
			$('#listTab').dataTable({
				"aaSorting": [],
				"bLengthChange": true,
				"aLengthMenu": [[15, 25, 30, -1], [15, 25, 30, "All"]],
				"bFilter": true,
				"aoColumnDefs": []
			});
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
			<select id="kind" style="width:100px"></select>
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
