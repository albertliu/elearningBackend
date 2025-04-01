	var rptOtherItem = 1;		//
	// let rptOtherOption = 0;

	$(document).ready(function (){
		$("#rptOtherStartDate").click(function(){WdatePicker();});
		$("#rptOtherEndDate").click(function(){WdatePicker();});
		
      	$("#rptOtherStartDate").val(new Date().format("yyyy-MM") + '-01');
		// $("#rptOtherStartDate").datebox("setValue", new Date().format("yyyy-MM") + '-01');
      	$("#rptOtherEndDate").val(currDate);
		
		$("#btnRptOther1").click(function(){
			setRptOtherOption(1);
		});
		$("#btnRptOther2").click(function(){
			setRptOtherOption(2);
		});
		$("#btnRptOther3").click(function(){
			setRptOtherOption(3);
		});

		$("#btnRptOther").linkbutton({
			iconCls:'icon-search',
			width:70,
			height:25,
			text:'预览',
			onClick:function() {
				getRptOtherList("data");
			}
		});
		$("#btnRptOtherDownLoad").linkbutton({
			iconCls:'icon-download',
			width:70,
			height:25,
			text:'下载',
			onClick:function() {
				getRptOtherList("file");
			}
		});
		$("#btnRptOtherPrint").linkbutton({
			iconCls:'icon-print',
			width:70,
			height:25,
			text:'打印',
			onClick:function() {
				divPrint("rptOtherCoverTab");
			}
		});
		
		setRptOtherOption(1);
	});

	function getRptOtherList(mark){
		if($("#rptOtherStartDate").val()==""){
			jAlert("请指定一个起始日期。")
			return false;
		}
		let value = $('input[name="rptOtherRadio"]:checked').val();
		let param = {startDate:$("#rptOtherStartDate").val(), endDate:$("#rptOtherEndDate").val(), mark:mark};
		if(rptOtherItem===1){
			op = "getRptNewClass";
		}
		if(rptOtherItem===2){
			op = "getRptWorkload";
			param["opt"] = value;
		}
		if(rptOtherItem===3){
			op = "getRptPassRate";
			param["opt"] = value;
		}
		//alert("op=other&mark=" + mark + "&host=" + $("#rptOtherHost").val() + "&kindID=" + $("#rptOtherKind").val() + "&startDate=" + $("#rptOtherStartDate").val() + "&endDate=" + $("#rptOtherEndDate").val() + "&groupHost=" + g1 + "&groupDept1=" + g2 + "&groupKindID=" + g3 + "&groupDate=" + g4);
		//@host varchar(50),@startDate varchar(50),@endDate varchar(50),@kindID varchar(20),@groupHost int,@groupDept1 int,@groupKindID int,@groupDate
		$.post(uploadURL + "/public/postCommInfo?mark=" + mark, {proc:op, params:param}, function(data){
			//jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}
			if(mark=="file" && data>""){
				jAlert("点击右侧链接，下载<a href='" + data + "'>统计报告</a>","下载文件");
			}
			if(mark=="data"){
				$("#rptOtherCover").empty();
			}
			
			if(mark=="data" && data.length>0){
				let i = 0;
				arr = [];		
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptOtherCoverTab' width='100%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='2%'>No</th>");
				if(rptOtherItem===1){
					arr.push("<th width='7%'>编号</th>");
					arr.push("<th width='15%'>班级名称</th>");
					arr.push("<th width='6%'>人数</th>");
					arr.push("<th width='9%'>开班日期</th>");
					arr.push("<th width='7%'>教师</th>");
					arr.push("<th width='7%'>班主任</th>");
					arr.push("<th width='12%'>教室</th>");
					arr.push("<th width='22%'>备注</th>");
				}
				if(rptOtherItem===2){
					arr.push("<th width='7%'>项目</th>");
					arr.push("<th width='7%'>编号</th>");
					arr.push("<th width='15%'>班级名称</th>");
					arr.push("<th width='6%'>人数</th>");
					arr.push("<th width='7%'>天数</th>");
					arr.push("<th width='12%'>工作量</th>");
					arr.push("<th width='9%'>结课日期</th>");
					arr.push("<th width='22%'>备注</th>");
				}
				if(rptOtherItem===3){
					arr.push("<th width='7%'>项目</th>");
					arr.push("<th width='7%'>编号</th>");
					arr.push("<th width='15%'>" + (value===2?"课程名称":"班级名称") + "</th>");
					arr.push("<th width='6%'>总人数</th>");
					arr.push("<th width='7%'>考试</th>");
					arr.push("<th width='12%'>通过</th>");
					arr.push("<th width='12%'>通过率</th>");
					arr.push("<th width='9%'>发布日期</th>");
					arr.push("<th width='22%'>备注</th>");
				}
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				$.each(data,function(iNum,val){
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + val["No"] + "</td>");
					if(rptOtherItem===1){
						arr.push("<td class='left'>" + val["classID"] + "</td>");
						arr.push("<td class='link1'><a href='javascript:" + (val["kindID"]==0?"showClassInfo":"showGenerateApplyInfo") + "(" + val["classID"] + ",0,0,0,1);'>" + val["className"] + "</a></td>");
						arr.push("<td class='left'>" + val["qty"] + "</td>");
						arr.push("<td class='left'>" + val["dateStart"] + "</td>");
						arr.push("<td class='left'>" + val["teacherName"] + "</td>");
						arr.push("<td class='left'>" + val["adviserName"] + "</td>");
						arr.push("<td class='left'>" + val["classRoom"] + "</td>");
						arr.push("<td class='left'>" + val["memo"] + "</td>");
					}
					if(rptOtherItem===2){
						arr.push("<td class='left'>" + val["teacherName"] + "</td>");
						arr.push("<td class='left'>" + val["classID"] + "</td>");
						arr.push("<td class='link1'><a href='javascript:" + (val["kindID"]==0?"showClassInfo":"showGenerateApplyInfo") + "(" + val["classID"] + ",0,0,0,1);'>" + val["className"] + "</a></td>");
						arr.push("<td class='left'>" + val["qty"] + "</td>");
						arr.push("<td class='left'>" + val["workDays"] + "</td>");
						arr.push("<td class='left'>" + val["workload"] + "</td>");
						arr.push("<td class='left'>" + val["dateEnd"] + "</td>");
						arr.push("<td class='left'>" + val["memo"] + "</td>");
					}
					if(rptOtherItem===3){
						arr.push("<td class='left'>" + val["teacherName"] + "</td>");
						arr.push("<td class='left'>" + val["classID"] + "</td>");
						if(value===2){
							arr.push("<td class='left'>" + val["className"] + "</td>");
						}else{
							arr.push("<td class='link1'><a href='javascript:" + (val["kindID"]==0?"showClassInfo":"showGenerateApplyInfo") + "(" + val["classID"] + ",0,0,0,1);'>" + val["className"] + "</a></td>");
						}
						arr.push("<td class='left'>" + val["qty"] + "</td>");
						arr.push("<td class='left'>" + val["qtyExam"] + "</td>");
						arr.push("<td class='left'>" + val["qtyPass"] + "</td>");
						arr.push("<td class='left'>" + val["passRate"] + "</td>");
						arr.push("<td class='left'>" + val["dateEnd"] + "</td>");
						arr.push("<td class='left'>" + val["memo"] + "</td>");
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
				if(rptOtherItem===3){
					arr.push("<th>&nbsp;</th>");
				}
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				$("#rptOtherCover").html(arr.join(""));
				arr = [];
				$('#rptOtherCoverTab').dataTable({
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

	function setRptOtherOption(mark){
		rptOtherItem = mark;
		if(mark===1){	//开班统计
			$("#rptOtherItem1").hide();
			$("#rptOtherItem2").hide();
			$("#btnRptOther1").css("background-color", "yellow");
			$("#btnRptOther2").css("background-color", "#fcfcfc");
			$("#btnRptOther3").css("background-color", "#fcfcfc");
			return false;
		}
		if(mark===2){	//工作量统计
			$("#rptOtherItem1").show();
			$("#rptOtherItem2").hide();
			$("#btnRptOther2").css("background-color", "yellow");
			$("#btnRptOther1").css("background-color", "#fcfcfc");
			$("#btnRptOther3").css("background-color", "#fcfcfc");
			return false;
		}
		if(mark===3){	//通过率统计
			$("#rptOtherItem1").show();
			$("#rptOtherItem2").show();
			$("#btnRptOther3").css("background-color", "yellow");
			$("#btnRptOther2").css("background-color", "#fcfcfc");
			$("#btnRptOther1").css("background-color", "#fcfcfc");
			return false;
		}
	}
	