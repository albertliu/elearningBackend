	$(document).ready(function (){
		$("#rptPayInvoiceStartDate").datebox("setValue", new Date().format("yyyy-MM-dd"));
		$("#rptPayInvoiceEndDate").datebox("setValue", new Date().format("yyyy-MM-dd"));
		$("#btnRptPayInvoice").linkbutton({
			iconCls:'icon-search',
			width:70,
			height:25,
			text:'预览',
			onClick:function() {
				getRptPayInvoiceList("data");
			}
		});
		$("#btnRptPayInvoiceDownLoad").linkbutton({
			iconCls:'icon-download',
			width:70,
			height:25,
			text:'下载',
			onClick:function() {
				getRptPayInvoiceList("file");
			}
		});
		$("#rptPayInvoiceAutoPay").checkbox({
			onChange: function(val){
				if(val){
					getRptPayInvoiceList("data");
				}
			}
		});
		$("#rptPayInvoiceAutoInvoice").checkbox({
			onChange: function(val){
				if(val){
					getRptPayInvoiceList("data");
				}
			}
		});
	});

	function getRptPayInvoiceList(mark){
		let autoPay = 0;
		let autoInvoice = 0;
		if($("#rptPayInvoiceAutoPay").checkbox("options").checked){
			autoPay = 1;
		}
		if($("#rptPayInvoiceAutoInvoice").checkbox("options").checked){
			autoInvoice = 1;
		}
		$.getJSON(uploadURL + "/public/getRptList?op=payInvoice&mark=" + mark + "&autoPay=" + autoPay + "&autoInvoice=" + autoInvoice + "&host=znxf&&startDate=" + $("#rptPayInvoiceStartDate").val() + "&endDate=" + $("#rptPayInvoiceEndDate").val(),function(data){
			// jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}
			if(mark=="file" && data>""){
				jAlert("点击右侧链接，下载<a href='" + data + "'>统计报告</a>","下载文件");
			}
			
			if(mark=="data" && data.length>0){
				let i = 0;
				let imgChk = "<img src='images/attachment.png' style='width:14px;'>";
				$("#rptPayInvoiceCover").empty();
				arr = [];		
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptPayInvoiceCoverTab' width='100%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='2%'>No</th>");
				arr.push("<th width='14%'>身份证</th>");
				arr.push("<th width='6%'>姓名</th>");
				arr.push("<th width='6%'>金额</th>");
				arr.push("<th width='9%'>付款日期</th>");
				arr.push("<th width='6%'>类型</th>");
				arr.push("<th width='14%'>课程</th>");
				arr.push("<th width='6%'>应收</th>");
				arr.push("<th width='14%'>发票号码</th>");
				arr.push("<th width='9%'>开票日期</th>");
				arr.push("<th width='9%'>备注</th>");
				arr.push("<th width='6%'>发票</th>");
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				$.each(data,function(iNum,val){
					let j = 0;
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					for(let key in val){
						if(j>1){
							arr.push("<td" + (key == "invoicePDF" && val[key]>"" ? " class='link1'>" : " class='left' " + (val[key]=="1" && (key=="datePay" || key=="dateInvoice") ? "style='background:green;'" : "") + ">")
							 + (key == "invoicePDF" && val[key]>"" ? "<a href='javascript:showPDF(\"" + val["invoicePDF"] + "\",0,0,0);'>"
							 + imgChk : (j==9?nullNoDisp(val[key]).substring(0,10):nullNoDisp(val[key])))
							 + (key == "invoicePDF" && val[key]>"" ? "</a>" : "") + "</td>");
							j += 1;
						}
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
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				$("#rptPayInvoiceCover").html(arr.join(""));
				arr = [];
				$('#rptPayInvoiceCoverTab').dataTable({
					"aaSorting": [],
					"bFilter": true,
					"bPaginate": true,
					"bLengthChange": true,
					"aLengthMenu":[15,30,50,100,500],
					"iDisplayLength": 50,
					"bInfo": true,
					"aoColumnDefs": []
				});
	
			}
		});
	}