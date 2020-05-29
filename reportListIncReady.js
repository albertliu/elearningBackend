	var reportListLong = 0;		//0: 标准栏目  1：短栏目
	var reportListChk = 0;
	var reportListKeyID = "";		//volume,move,disposal
	var reportListRefID = "";		//volumeID,moveID,disposalID
	var reportListItem = "";

	$(document).ready(function (){
		getDicList("archiveStatus","searchReportStatus",1);
		getComList("searchReportKind","archiveKind","kindID","item","status=0 order by kindID",1);
		getComList("searchReportType","archiveSubKind","subKindID","item","kindID='" + nullNoDisp($("#searchReportKind").val()) + "' order by subKindID",1);
		//emptyList("searchReportType");
		$("#searchReportStartDate").click(function(){WdatePicker();});
		$("#searchReportEndDate").click(function(){WdatePicker();});
		$("#searchReportBox1").hide();
		$("#searchReportBoxTitle1").hide();
		$("#reportListItem1").hide();
		$("#reportListItem3").hide();
		$("#searchReportGroup1").attr("disabled",true);
		$("#searchReportGroup2").attr("disabled",true);
		
		$("#btnDownLoadReport").click(function(){
			outputFloat(51,'file');	//
		});
		
		$("#btnSearchReport").click(function(){
			doSearch();
		});
		
		$("#c_report1").click(function(){
			reportListItem="Exp";
			doSearch();
			$("#searchReportStartDate").val("");		//
		});
		$("#c_report2").click(function(){
			reportListItem="Group";
			$("#searchReportStartDate").val("");		//
			doSearch();
		});
		$("#c_report3").click(function(){
			reportListItem="Daily";
			$("#searchReportStartDate").val(currDate);		//
			doSearch();
		});
		
		$("#searchReportKind").change(function(){
			getComList("searchReportType","archiveSubKind","subKindID","item","kindID='" + nullNoDisp($("#searchReportKind").val()) + "' order by subKindID",1);
			doSearch();
		});
		$("#searchReportType").change(function(){
			doSearch();
		});
		
		$("#searchReportStatus").change(function(){
			doSearch();
		});
		
		$("#txtSearchReport").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchReport").val()>""){
					doSearch();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		
		$("#searchReportBox1").change(function(){
			doSearch();
		});
	});

	function getReportListExp(){
		sWhere = $("#txtSearchReport").val();
		//alert((sWhere) + "&status=" + $("#searchReportStatus").val() + "&kindID=" + $("#searchReportKind").val() + "&type=" + nullNoDisp($("#searchReportType").val()) + "&fStart=" + $("#searchReportStartDate").val() + "&fEnd=" + $("#searchReportEndDate").val());
		$.get("rptControl.asp?op=getReportListExp&where=" + escape(sWhere) + "&status=" + $("#searchReportStatus").val() + "&kindID=" + $("#searchReportKind").val() + "&type=" + nullNoDisp($("#searchReportType").val()) + "&fStart=" + $("#searchReportStartDate").val() + "&fEnd=" + $("#searchReportEndDate").val() + "&dk=51&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#reportCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='reportTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='18%'>档案编号</th>");
			arr.push("<th width='30%'>档案标签</th>");
			arr.push("<th width='8%'>库位</th>");
			arr.push("<th width='12%'>保存期限</th>");
			arr.push("<th width='29%'>科目</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					if(ar1[3]==0){c = 2;}	//未入库前红色
					if(ar1[3]==2){c = 1;}	//销毁后灰色
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td width='3%' class='center'>" + i + "</td>");
					arr.push("<td width='18%' class='link1'><a href='javascript:showArchiveInfo(\"" + ar1[0] + "\",0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td width='30%' class='left'>" + ar1[2] + "</td>");
					arr.push("<td width='8%' class='left'>" + ar1[10] + "</td>");
					arr.push("<td width='12%' class='left'>" + ar1[18] + "</td>");
					arr.push("<td width='29%' class='left'>" + ar1[17] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#reportCover").html(arr.join(""));
			arr = [];
			$('#reportTab').dataTable({
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
	
	function getReportListGroup(){
		//alert((sWhere) + "&status=" + $("#searchReportStatus").val() + "&kindID=" + $("#searchReportKind").val() + "&type=" + nullNoDisp($("#searchReportType").val()) + "&fStart=" + $("#searchReportStartDate").val() + "&fEnd=" + $("#searchReportEndDate").val());
		$.get("rptControl.asp?op=getReportListGroup&status=" + $("#searchReportStatus").val() + "&kindID=" + $("#searchReportKind").val() + "&type=" + nullNoDisp($("#searchReportType").val()) + "&fStart=" + $("#searchReportStartDate").val() + "&fEnd=" + $("#searchReportEndDate").val() + "&dk=51&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#reportCover").empty();
			floatSum = "";
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='reportTab' width='70%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='5%'>No</th>");
			arr.push("<th width='20%'>档案分类</th>");
			arr.push("<th width='40%'>科目名称</th>");
			arr.push("<th width='20%'>年度</th>");
			arr.push("<th width='15%'>数量</th>");
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
					arr.push("<td width='5%' class='center'>" + i + "</td>");
					arr.push("<td width='20%' class='link1'>" + ar1[0] + "</td>");
					arr.push("<td width='40%' class='left'>" + ar1[1] + "</td>");
					arr.push("<td width='20%' class='left'>" + ar1[2] + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[3] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#reportCover").html(arr.join(""));
			arr = [];
			$('#reportTab').dataTable({
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
	
	function getReportListDaily(){
		//alert((sWhere) + "&status=" + $("#searchReportStatus").val() + "&kindID=" + $("#searchReportKind").val() + "&type=" + nullNoDisp($("#searchReportType").val()) + "&fStart=" + $("#searchReportStartDate").val() + "&fEnd=" + $("#searchReportEndDate").val());
		$.get("rptControl.asp?op=getReportListDaily&status=" + $("#searchReportStatus").val() + "&kindID=" + $("#searchReportKind").val() + "&type=" + nullNoDisp($("#searchReportType").val()) + "&fStart=" + $("#searchReportStartDate").val() + "&fEnd=" + $("#searchReportEndDate").val() + "&dk=51&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#reportCover").empty();
			floatSum = "";
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='reportTab' width='70%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='5%'>No</th>");
			arr.push("<th width='20%'>档案分类</th>");
			arr.push("<th width='40%'>科目名称</th>");
			arr.push("<th width='20%'>操作内容</th>");
			arr.push("<th width='15%'>数量</th>");
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
					arr.push("<td width='5%' class='center'>" + i + "</td>");
					arr.push("<td width='20%' class='link1'>" + ar1[0] + "</td>");
					arr.push("<td width='40%' class='left'>" + ar1[1] + "</td>");
					arr.push("<td width='20%' class='left'>" + ar1[2] + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[3] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#reportCover").html(arr.join(""));
			arr = [];
			$('#reportTab').dataTable({
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
	
	function doSearch(){
		//$("#searchReportStartDate").val("");		//
		$("#searchReportEndDate").val("");		//
		$("#searchReportBox1").hide();
		$("#searchReportBoxTitle1").hide();
		$("#searchReportStatus").val("");		//
		$("#reportListItem1").hide();
		$("#reportListItem3").hide();
		$("#reportListItem4").hide();
		if(reportListItem=="Exp"){
			$("#searchReportStatus").val(1);		//在库状态
			$("#reportListItem3").hide();
			getReportListExp();
		}
		if(reportListItem=="Group"){
			$("#reportListItem3").show();
			$("#reportListItem4").show();
			getReportListGroup();
		}
		if(reportListItem=="Daily"){
			getReportListDaily();
		}
	}
	
	