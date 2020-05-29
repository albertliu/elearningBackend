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
	<!--#include file="js/commFunction.js"-->
	var kindID = "";
	$(document).ready(function (){
		kindID = "<%=kindID%>";
		//alert(kindID);
		getDicList("newsKind","kindID",0);
		$("#btnSearch").click(function(){
			getNewsList();
		});
		
		$("#kindID").change(function(){
			//alert($("input[name='searchKind']:checked").val());
			getNewsList();
		});
		$("input[name='searchStatus']").click(function(){
			//alert($("input[name='searchStatus']:checked").val());
			getNewsList();
		});
		$("#kindID").val(kindID);
		getNewsList();
	});

	function getNewsList(){
		sWhere = $("#txtSearch").val();
		var status = $("input[name='searchStatus']:checked").val();
		kindID = $("#kindID").val();
		//alert((sWhere) + "&kindID=" + kindID);
		$.get("newsControl.asp?op=getNewsList&status=" + status + "&where=" + escape(sWhere) + "&kindID=" + kindID + "&dk=3&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
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
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='30%'>消息名称</th>");
			arr.push("<th width='10%'>性质</th>");
			arr.push("<th width='10%'>类型</th>");
			arr.push("<th width='6%'>状态</th>");
			arr.push("<th width='15%'>发布日期</th>");
			arr.push("<th width='8%'>接收人</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var ac = new Array();
				ac = ["Notice","Message","Comment","Memo","Check","Task","Plan","Grant"];
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					//alert(ac[ar1[8]]);
//ID, item, status, statusName, refID, scopeID, userKind, userName, receiverName, kindID, kindName, newsType, newsTypeName, newsMark, alertDays, datePlan, dateConfirm, memo, regDate, regOperator, registorName
					arr.push("<tr class='grade" + ar1[2] + "'>");
					arr.push("<td width='3%' class='center'>" + i + "</td>");
					if(ar1[9]=="check"){
						arr.push("<td width='30%' class='link1'><a href='javascript:show" + initialCapital(ar1[9]) + "Info(\"" + ar1[4] + "\",\"" + kindID + "\",0,0,2);'>" + ar1[1] + "</a></td>");
					}else{
						arr.push("<td width='30%' class='link1'><a href='javascript:show" + initialCapital(ar1[9]) + "Info(\"" + ar1[4] + "\",0,2);'>" + ar1[1] + "</a></td>");
					}
					arr.push("<td width='10%' class='left'>" + ar1[12] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[13] + "</td>");
					arr.push("<td width='6%' class='left'>" + ar1[3] + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[18] + "</td>");
					arr.push("<td width='8%' class='left'>" + ar1[8] + "</td>");
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
			$("#listCover").html(arr.join(""));
			arr = [];
			$('#listTab').dataTable({
				"aaSorting": [],
				"bFilter": false,
				"bPaginate": false,
				"bLengthChange": false,
				"bInfo": false,
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

	function pickupItem(id,name){
		var keyID = "<%=keyID%>";
		var refID = "<%=refID%>";
		pickupID = id;
		pickupName = name;
		$("#txtSearchUnit").val(name);
		//parent.asyncbox.close("unitList");
		if(keyID>""){
			parent.$("#" + keyID).val(id);
		}
		if(refID>""){
			parent.$("#" + refID).val(name);
		}
		parent.$.close("engineeringList");
	}
</script>

</head>

<body>

<div id='layout' align='left'>	
				  	<div style="width:100%;float:left;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索：</label>
				          <input type="text" id="txtSearch" size="20" title="名称、代码" style="background:yellow;" />
				          <input class="button" type="button" name="btnSearch" id="btnSearch" value="查找">
						      &nbsp;&nbsp;|&nbsp;&nbsp;
				          <input style="border:0px;" type="radio" id="searchStatus0" name="searchStatus" value="0" checked />活动&nbsp;
				          <input style="border:0px;" type="radio" id="searchStatus1" name="searchStatus" value="1" />关闭&nbsp;
				          <input style="border:0px;" type="radio" id="searchStatus99" name="searchStatus" value="99" />全部
						      &nbsp;&nbsp;|&nbsp;&nbsp;
				          <label>类别</label>&nbsp;<select id="kindID" style="width:80px"></select>
						      &nbsp;&nbsp;|&nbsp;&nbsp;
							    <input class="button" type="button" id="btnDownLoad" onClick="outputFloat(9,'file')" value="下载">
							    <input class="button" type="button" id="btnPrint" onClick="outputFloat(9,'print')" value="打印">
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="listCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
</div>
</body>
