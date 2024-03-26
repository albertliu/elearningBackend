	$(document).ready(function (){
		$("#searchRptDailyStart").click(function(){WdatePicker();});
		$("#searchRptDailyEnd").click(function(){WdatePicker();});
		$("#searchRptDailyStart").attr("value", new Date().format("yyyy-MM-dd"));
		$("#searchRptDailyEnd").attr("value", new Date().format("yyyy-MM-dd"));	

		$("#btnsearchRptDailyInvoice").click(function(){
			getRptDailyInvoiceList();
		});
		$("#btnsearchRptDailyNopy").click(function(){
			getRptDailyNopayList();
		});
		$("#btnsearchRptDailyReceipt").click(function(){
			getRptDailyReceiptList();
		});
		$("#btnsearchRptDailyShow").click(function(){
			getRptDailyIncomeList("data");
		});
		$("#btnsearchRptDailyShow1").click(function(){
			getRptDailyEnterList("data");
		});
		$("#btnsearchRptDailyUpload").click(function(){
			showLoadFile("invoice_list","","invoiceList",'');
		});
		$("#btnRptDailySel").click(function(){
			setSel("visitstockchkRptDailyNopay");
		});
		// if(!checkPermission("invoiceUpload")){
			$("#btnsearchRptDailyUpload").hide();
		// }
		
		$("#btnRptDailyCheck").click(function(){
			getSelCart("visitstockchkRptDailyNopay");
			if(selCount==0){
				jAlert("请选择要确认的发票名单。");
				return false;
			}
			jConfirm("确定将这" + selCount + "张应收发票标记为已收款吗？","确认",function(r){
				if(r){
					$.post(uploadURL + "/public/check_nopay_invoice", {selList: selList, registerID: currUser} ,function(data){
						//jAlert(data);
						getRptDailyNopayList();
						jAlert("操作成功。");
					});
				}
			});
		});
		
		$("#searchRptDailyYesterday").change(function(){
			if($("#searchRptDailyYesterday").prop("checked")){
				$("#searchRptDailyStart").attr("value", addDays(new Date().format("yyyy-MM-dd"), -1));
				$("#searchRptDailyEnd").attr("value", addDays(new Date().format("yyyy-MM-dd"), -1));
			}else{
				$("#searchRptDailyStart").attr("value", new Date().format("yyyy-MM-dd"));
				$("#searchRptDailyEnd").attr("value", new Date().format("yyyy-MM-dd"));	
			}
		});

		$("#rptDailyNopayItem").hide();
		//getRptDailyList();
	});

	function getRptDailyInvoiceList(){
		sWhere = $("#txtSearchRptDaily").val().replace(' ','');
		$("#rptDailyInvoiceCover").show();
		$("#rptDailyRptCover").hide();
		$("#rptDailyNopayCover").hide();
		$("#rptDailyNopayItem").hide();
		$("#rptDailyReceiptCover").hide();
		$.get("diplomaControl.asp?op=getRptDailyInvoiceList&where=" + escape(sWhere) + "&fStart=" + $("#searchRptDailyStart").val() + "&fEnd=" + $("#searchRptDailyEnd").val() + "&kindID=0&times=" + (new Date().getTime()),function(data){
			// jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#rptDailyInvoiceCover").empty();
			floatSum = "";
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='RptDailyInvoiceTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='10%'>发票代码</th>");
			arr.push("<th width='8%'>发票号码</th>");
			arr.push("<th width='8%'>购方名称</th>");
			arr.push("<th width='8%'>开票日期</th>");
			arr.push("<th width='8%'>收费项目</th>");
			arr.push("<th width='6%'>金额</th>");
			arr.push("<th width='6%'>类别</th>");
			arr.push("<th width='5%'>作废</th>");
			arr.push("<th width='8%'>作废日期</th>");
			arr.push("<th width='5%'>应收</th>");
			arr.push("<th width='6%'>备注</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showInvoiceInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[2] + "</a></td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left' title='" + ar1[5] + "'>" + ar1[5].substring(0,6) + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
					arr.push("<td class='left'>" + (ar1[9]==1?imgChk:'') + "</td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
					arr.push("<td class='left'>" + (ar1[12]==1?imgChk:'') + "</td>");
					arr.push("<td class='left'>" + ar1[14] + "</td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#rptDailyInvoiceCover").html(arr.join(""));
			arr = [];
			$('#RptDailyInvoiceTab').dataTable({
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

	function getRptDailyNopayList(){
		sWhere = $("#txtSearchRptDaily").val().replace(' ','');
		$("#rptDailyInvoiceCover").hide();
		$("#rptDailyRptCover").hide();
		$("#rptDailyNopayCover").show();
		$("#rptDailyNopayItem").show();
		$("#rptDailyReceiptCover").hide();
		$.get("diplomaControl.asp?op=getRptDailyInvoiceList&where=" + escape(sWhere) + "&fStart=" + $("#searchRptDailyStart").val() + "&fEnd=" + $("#searchRptDailyEnd").val() + "&kindID=1&times=" + (new Date().getTime()),function(data){
			// jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#rptDailyNopayCover").empty();
			floatSum = "";
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='RptDailyNopayTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='10%'>发票代码</th>");
			arr.push("<th width='8%'>发票号码</th>");
			arr.push("<th width='8%'>购方名称</th>");
			arr.push("<th width='8%'>开票日期</th>");
			arr.push("<th width='8%'>收费项目</th>");
			arr.push("<th width='6%'>金额</th>");
			arr.push("<th width='6%'>类别</th>");
			arr.push("<th width='5%'>作废</th>");
			arr.push("<th width='10%'>备注</th>");
			arr.push("<th width='6%'>开票人</th>");
			arr.push("<th width='1%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showInvoiceInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[2] + "</a></td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left' title='" + ar1[5] + "'>" + ar1[5].substring(0,6) + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
					arr.push("<td class='left'>" + (ar1[9]==1?imgChk:'') + "</td>");
					arr.push("<td class='left'>" + ar1[14] + "</td>");
					arr.push("<td class='left'>" + ar1[13] + "</td>");
					arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchkRptDailyNopay'>" + "</td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#rptDailyNopayCover").html(arr.join(""));
			arr = [];
			$('#RptDailyNopayTab').dataTable({
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

	function getRptDailyReceiptList(){
		sWhere = $("#txtSearchRptDaily").val().replace(' ','');
		$("#rptDailyInvoiceCover").hide();
		$("#rptDailyRptCover").hide();
		$("#rptDailyNopayCover").hide();
		$("#rptDailyNopayItem").hide();
		$("#rptDailyReceiptCover").show();
		$.get("diplomaControl.asp?op=getRptDailyReceiptList&where=" + escape(sWhere) + "&fStart=" + $("#searchRptDailyStart").val() + "&fEnd=" + $("#searchRptDailyEnd").val() + "&dk=33&times=" + (new Date().getTime()),function(data){
			// jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#rptDailyReceiptCover").empty();
			floatSum = "";
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='RptDailyReceiptTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='8%'>开票日期</th>");
			arr.push("<th width='8%'>收据编号</th>");
			arr.push("<th width='8%'>收据抬头</th>");
			arr.push("<th width='15%'>收费项目</th>");
			arr.push("<th width='6%'>金额</th>");
			arr.push("<th width='5%'>类别</th>");
			arr.push("<th width='6%'>备注</th>");
			arr.push("<th width='5%'>操作人</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					arr.push("<td class='left'>" + ar1[9] + "</td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("</tr>")/*;*/
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
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#rptDailyReceiptCover").html(arr.join(""));
			arr = [];
			$('#RptDailyReceiptTab').dataTable({
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

	function getRptDailyIncomeList(mark){
		$("#rptDailyInvoiceCover").hide();
		$("#rptDailyRptCover").show();
		$("#rptDailyNopayCover").hide();
		$("#rptDailyNopayItem").hide();
		$("#rptDailyReceiptCover").hide();
		$.getJSON(uploadURL + "/public/getRptList?op=dailyIncome&mark=" + mark + "&startDate=" + $("#searchRptDailyStart").val() + "&endDate=" + $("#searchRptDailyEnd").val(),function(data){
			//jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}
			if(mark=="file" && data>""){
				jAlert("点击右侧链接，下载<a href='" + data + "'>统计报告</a>","下载文件");
			}
			if(mark=="data"){
				$("#rptDailyRptCover1").empty();
				$("#rptDailyRptCover2").empty();
			}

			if(mark=="data" && data.length>0){
				arr = [];	
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptDailyRptCover1Tab' width='100%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='40%'>科目</th>");
				arr.push("<th width='30%'>金额</th>");
				arr.push("<th width='30%'>票据张数</th>");
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				$.each(data,function(iNum,val){
					i += 1;
					c = 0;
					let j = 0;
					arr.push("<tr class='grade0'>");
					for(let key in val){
						if(key != "mark"){
							// arr.push("<td" + (j>0 ? " class='link1'>" : " class='left'>") + (j>0 ? "<a href='javascript:getRptDailyIncomeDetailList(\"" + val["sales"] + "\"," + (j - 1) + ");'>" : "") + nullNoDisp(val[key]) + (j>0 ? "</a>" : "") + "</td>");
							c = (val["mark"] != 1 && key=='收入'? 1 : 0)
							arr.push("<td" + (c == 1 ? " class='link1'>" : " class='left'>") + (c == 1 ? "<a href='javascript:getRptDailyIncomeDetailList(\"" + val["科目"] + "\");'>" : "") + nullNoDisp(val[key]) + (c == 1 ? "</a>" : "") + "</td>");
						}
						j += 1
					}
					arr.push("</tr>");
				});
				arr.push("</tbody>");
				arr.push("<tfoot>");
				arr.push("<tr>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				arr.push("<div style='magin:10px; text-align:center;'><input class='button' type='button' onclick='javascript:getRptDailyIncomeList(\"file\");' value='打印' /></div>");
				$("#rptDailyRptCover1").html(arr.join(""));
				arr = [];
				$('#rptDailyRptCover1Tab').dataTable({
					"aaSorting": [],
					"bFilter": false,
					"bPaginate": false,
					"bLengthChange": false,
					"bInfo": false,
					"aoColumnDefs": []
				});
	
			}
		});
	}

	function getRptDailyIncomeDetailList(k){
		$.getJSON(uploadURL + "/public/getRptDetailList?op=dailyIncome&kind=" + k + "&startDate=" + $("#searchRptDailyStart").val() + "&endDate=" + $("#searchRptDailyEnd").val(),function(data){
			//jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}

			if(data.length>0){
				$("#rptDailyRptCover2").empty();
				let i = 0;
				arr = [];		
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptDailyRptCover2Tab' width='100%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='2%'>No</th>");
				arr.push("<th width='12%'>科目</th>");
				arr.push("<th width='10%'>金额</th>");
				arr.push("<th width='10%'>发票代码</th>");
				arr.push("<th width='12%'>发票号码</th>");
				arr.push("<th width='14%'>开票日期</th>");
				arr.push("<th width='15%'>收费项目</th>");
				arr.push("<th width='20%'>备注</th>");
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				$.each(data,function(iNum,val){
					i += 1;
					c = 0;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					for(let key in val){
						arr.push("<td class='left'>" + nullNoDisp(val[key]) + "</td>");
					}
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
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				$("#rptDailyRptCover2").html(arr.join(""));
				arr = [];
				$('#rptDailyRptCover2Tab').dataTable({
					"aaSorting": [],
					"bFilter": false,
					"bPaginate": true,
					"bLengthChange": false,
					"aLengthMenu":[15,30,50,100],
					"iDisplayLength": 50,
					"bInfo": false,
					"aoColumnDefs": []
				});
	
			}
		});
	}

	function getRptDailyEnterList(mark){
		$("#rptDailyInvoiceCover").hide();
		$("#rptDailyRptCover").show();
		$("#rptDailyNopayCover").hide();
		$("#rptDailyNopayItem").hide();
		$("#rptDailyReceiptCover").hide();
		$.getJSON(uploadURL + "/public/getRptList?op=dailyEnter&mark=" + mark + "&startDate=" + $("#searchRptDailyStart").val() + "&endDate=" + $("#searchRptDailyEnd").val(),function(data){
			//jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}
			if(mark=="file" && data>""){
				jAlert("点击右侧链接，下载<a href='" + data + "'>统计报告</a>","下载文件");
			}
			if(mark=="data"){
				$("#rptDailyRptCover1").empty();
				$("#rptDailyRptCover2").empty();
			}
			if(mark=="data" && data.length>0){
				arr = [];	
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptDailyRptCover1Tab' width='100%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='50%'>科目</th>");
				arr.push("<th width='20%'>人数</th>");
				arr.push("<th width='30%'>未开班人数</th>");
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				$.each(data,function(iNum,val){
					i += 1;
					c = 0;
					let j = 0;
					arr.push("<tr class='grade0'>");
					for(let key in val){
						if(key != "mark" && key != "courseID"){
							// arr.push("<td" + (j>0 ? " class='link1'>" : " class='left'>") + (j>0 ? "<a href='javascript:getRptDailyIncomeDetailList(\"" + val["sales"] + "\"," + (j - 1) + ");'>" : "") + nullNoDisp(val[key]) + (j>0 ? "</a>" : "") + "</td>");
							c = (val["mark"] != 1 && key=='报名人数'? 1 : 0)
							arr.push("<td" + (c == 1 ? " class='link1'>" : " class='left'>") + (c == 1 ? "<a href='javascript:getRptDailyEnterDetailList(\"" + val["courseID"] + "\");'>" : "") + nullNoDisp(val[key]) + (c == 1 ? "</a>" : "") + "</td>");
						}
						j += 1
					}
					arr.push("</tr>");
				});
				arr.push("</tbody>");
				arr.push("<tfoot>");
				arr.push("<tr>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				arr.push("<div style='magin:10px; text-align:center;'><input class='button' type='button' onclick='javascript:getRptDailyEnterList(\"file\");' value='打印' /></div>");
				$("#rptDailyRptCover1").html(arr.join(""));
				arr = [];
				$('#rptDailyRptCover1Tab').dataTable({
					"aaSorting": [],
					"bFilter": false,
					"bPaginate": false,
					"bLengthChange": false,
					"bInfo": false,
					"aoColumnDefs": []
				});
	
			}
		});
	}

	function getRptDailyEnterDetailList(k){
		$.getJSON(uploadURL + "/public/getRptDetailList?op=dailyEnter&kind=" + k + "&startDate=" + $("#searchRptDailyStart").val() + "&endDate=" + $("#searchRptDailyEnd").val(),function(data){
			//jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}

			if(data.length>0){
				$("#rptDailyRptCover2").empty();
				let i = 0;
				arr = [];		
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptDailyRptCover2Tab' width='100%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='2%'>No</th>");
				arr.push("<th width='12%'>学号</th>");
				arr.push("<th width='18%'>身份证</th>");
				arr.push("<th width='10%'>姓名</th>");
				arr.push("<th width='18%'>培训项目</th>");
				arr.push("<th width='14%'>报名日期</th>");
				arr.push("<th width='18%'>单位名称</th>");
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				$.each(data,function(iNum,val){
					i += 1;
					c = 0;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					for(let key in val){
						arr.push("<td class='left'>" + nullNoDisp(val[key]) + "</td>");
					}
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
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				$("#rptDailyRptCover2").html(arr.join(""));
				arr = [];
				$('#rptDailyRptCover2Tab').dataTable({
					"aaSorting": [],
					"bFilter": false,
					"bPaginate": true,
					"bLengthChange": false,
					"aLengthMenu":[15,30,50,100],
					"iDisplayLength": 50,
					"bInfo": false,
					"aoColumnDefs": []
				});
	
			}
		});
	}
