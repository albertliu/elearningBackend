	$(document).ready(function (){
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
				showRptDailyTotal();
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
				arr.push("<th width='6%'>金额</th>");
				arr.push("<th width='7%'>标识</th>");
				arr.push("<th width='1%'>票</th>");
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				$.each(data,function(iNum,val){
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + val["No"] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(\"" + val["ID"] + "\",\"" + val["username"] + "\",0,0);'>" + val["name"] + "</a></td>");
					arr.push("<td class='left'" + (val["autoPay"]=="1"?" style='background:#FFFF88;'" : "") + ">" + val["datePay"] + "</td>");
					arr.push("<td class='left'" + (val["autoInvoice"]=="1"?" style='background:#FFFF88;'" : "") + ">" + val["dateInvoice"] + "</td>");
					arr.push("<td class='left'>" + val["invoice"] + "</td>");
					arr.push("<td class='left'>" + val["title"] + "</td>");
					arr.push("<td class='left'>" + val["shortName"] + "</td>");
					arr.push("<td class='left'>" + val["pay_typeName"] + "</td>");
					// 合计为红色字体；红冲、历史发票、预收开票、重开发票为灰色背景，不计入合计金额。
					arr.push("<td class='left'" + (val["kindID"]>=3?" style='color:red;'":(val["kindID"]>=3?" style='color:gray;'":"")) + ">" + nullNoDisp(val["amount"]) + "</td>");
					arr.push("<td class='left'" + (val["kindID"]==1?" style='background:#ffe0e0;'":(val["kindID"]==3?" style='background:#e0ffff;'":"")) + ">" + val["mark"] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showPDF(\"" + val["invoicePDF"] + "\",0,0,0);'>" + (val["invoicePDF"]>""?imgChk:"") + "</td>");
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
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
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