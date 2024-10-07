<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css?v=1.8.6">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery-confirm.css" rel="stylesheet" type="text/css" media="screen" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.21">
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.12.4.min.js"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.23"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script src="js/jquery-confirm.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/jQuery.print.js" type="text/javascript"></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var refID = 0;
	var keyID = "A";
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//classID
		refID = "<%=refID%>";
		keyID = "<%=keyID%>";	// mark: A apply, B class
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 

		$("#btnRptDailyTotal").linkbutton({
			iconCls:'icon-search',
			width:70,
			height:25,
			text:'预览',
			onClick:function() {
				getRptDailyTotalList("data");
			}
		});
		$("#btnRptDailyTotalDownLoad").linkbutton({
			iconCls:'icon-download',
			width:70,
			height:25,
			text:'下载',
			onClick:function() {
				getRptDailyTotalList("file");
			}
		});
		$("#btnRptDailyTotalPrint").linkbutton({
			iconCls:'icon-print',
			width:70,
			height:25,
			text:'打印',
			onClick:function() {
				resumePrint();
			}
		});

		$("#rptDailyTotalStartDate").datebox("setValue", new Date().format("yyyy-MM-dd"));
	});

	function getRptDailyTotalList(mark){
		if($("#rptDailyTotalStartDate").val() == ""){
			jAlert("请选择日期。");
			return false;
		}
		$.getJSON(uploadURL + "/public/getRptList?op=dailyTotal&mark=" + mark + "&host=znxf&startDate=" + $("#rptDailyTotalStartDate").val(),function(data){
			// jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}
			if(mark=="file" && data>""){
				jAlert("点击右侧链接，下载<a href='" + data + "'>统计报告</a>","下载文件");
			}
			if(mark=="data"){
				$("#rptDailyTotalCover").empty();
			}
			
			if(mark=="data" && data.length>0){
				let i = 0;
				let imgChk = "<img src='images/attachment.png' style='width:14px;'>";
				arr = [];		
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptDailyTotalCoverTab' width='100%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='1%'>No</th>");
				arr.push("<th width='6%'>姓名</th>");
				arr.push("<th width='8%'>付款日期</th>");
				arr.push("<th width='8%'>开票日期</th>");
				arr.push("<th width='8%'>数电票号</th>");
				arr.push("<th width='12%'>开票抬头</th>");
				arr.push("<th width='12%'>项目</th>");
				arr.push("<th width='7%'>付款方式</th>");
				// arr.push("<th width='6%'>单价</th>");
				arr.push("<th width='6%'>金额</th>");
				arr.push("<th width='7%'>标识</th>");
				arr.push("<th class='no-print' width='1%'>票</th>");
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				$.each(data,function(iNum,val){
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + val["No"] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(\"" + val["enterID"] + "\",\"" + val["username"] + "\",0,0);'>" + val["name"] + "</a></td>");
					arr.push("<td class='left'" + (val["autoPay"]=="1"?" style='background:#FFFF88;'" : "") + ">" + val["datePay"] + "</td>");
					arr.push("<td class='left'" + (val["autoInvoice"]=="1"?" style='background:#FFFF88;'" : "") + ">" + val["dateInvoice"] + "</td>");
					arr.push("<td class='left'>" + val["invoice"] + "</td>");
					arr.push("<td class='left'>" + val["title"] + "</td>");
					arr.push("<td class='left'>" + val["shortName"] + "</td>");
					arr.push("<td class='left'>" + val["pay_typeName"] + "</td>");
					// arr.push("<td class='left'>" + nullNoDisp(val["price"]) + (val["price"]>""?"*1":"") + "</td>");
					arr.push("<td class='left'" + (val["kindID"]>=5?" style='color:red;'":"") + ">" + nullNoDisp(val["amount"]) + "</td>");
					// arr.push("<td class='left' title='" + val["pay_memo"] + "'>" + nullNoDisp(val["pay_memo"]).substring(0,10) + "</td>");
					arr.push("<td class='left'" + (val["kindID"]==1?" style='background:#ffe0e0;'":(val["kindID"]==3?" style='background:#e0ffff;'":"")) + ">" + val["mark"] + "</td>");
					arr.push("<td class='no-print'><a href='javascript:showPDF(\"" + val["invoicePDF"] + "\",0,0,0);'>" + (val["invoicePDF"]>""?imgChk:"") + "</td>");
					arr.push("</tr>");
				});
				arr.push("</tbody>");
				arr.push("<tfoot>");
				arr.push("<tr>");
				// arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th class='no-print'>&nbsp;</th>");
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				$("#rptDailyTotalCover").html(arr.join(""));
				arr = [];
				$('#rptDailyTotalCoverTab').dataTable({
					"aaSorting": [],
					"bFilter": true,
					"bPaginate": true,
					"bLengthChange": true,
					"aLengthMenu":[15,30,50,100,500],
					"iDisplayLength": 100,
					"bInfo": true,
					"aoColumnDefs": []
				});
	
			}
		});
	}

	function resumePrint(){
		$("#resume_print").print({
			//Use Global styles
			globalStyles : true,
			//Add link with attrbute media=print
			mediaPrint : false,
			//Custom stylesheet
			stylesheet : "",
			//Print in a hidden iframe
			iframe : true,
			//Don't print this
			noPrintSelector : ".no-print",
			//Add this at top
			prepend : "",
			//Add this on bottom
			append : "<br/>"
		});
	}

</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	<div class="comm" align='left' style="background:#fdfdfd;">
		<form>
			<span>
				&nbsp;日期&nbsp;<input id="rptDailyTotalStartDate" class="easyui-datebox" data-options="height:22,width:100" />
			</span>
			<span style="padding-left:50px;">
				<a class="easyui-linkbutton" id="btnRptDailyTotal" href="javascript:void(0)"></a>&nbsp;&nbsp;
				<a class="easyui-linkbutton" id="btnRptDailyTotalDownLoad" href="javascript:void(0)"></a>&nbsp;&nbsp;
				<a class="easyui-linkbutton" id="btnRptDailyTotalPrint" href="javascript:void(0)"></a>
			</span>
		</form>
	</div>
	<hr size="1" noshadow />
	<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
		<div id="rptDailyTotalCover" style="border:none;width:100%;background:#ffffff;margin:0px;"></div>
	</div>
</div>
</body>
