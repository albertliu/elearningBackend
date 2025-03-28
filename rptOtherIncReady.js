	var rptOtherItem = 1;		//
	// let rptOtherOption = 0;

	$(document).ready(function (){
		$("#rptOtherStartDate").click(function(){WdatePicker();});
		$("#rptOtherEndDate").click(function(){WdatePicker();});
		
		/*$("#btnRptOther").click(function(){
			getRptOtherList("data");
		});*/
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
		
		setRptOtherOption(1);
	});

	function getRptOtherList(){
		if($("#rptOtherStartDate").val()==""){
			jAlert("请指定一个起始日期。")
			return false;
		}
		let value = $('input[name="rptOtherRadio"]:checked').val();
		//alert("op=other&mark=" + mark + "&host=" + $("#rptOtherHost").val() + "&kindID=" + $("#rptOtherKind").val() + "&startDate=" + $("#rptOtherStartDate").val() + "&endDate=" + $("#rptOtherEndDate").val() + "&groupHost=" + g1 + "&groupDept1=" + g2 + "&groupKindID=" + g3 + "&groupDate=" + g4);
		//@host varchar(50),@startDate varchar(50),@endDate varchar(50),@kindID varchar(20),@groupHost int,@groupDept1 int,@groupKindID int,@groupDate
		$.getJSON(uploadURL + "/public/getRptList?op=" + op + "&mark=" + mark + "&startDate=" + $("#rptOtherStartDate").val() + "&endDate=" + $("#rptOtherEndDate").val(),function(data){
			//jAlert(data);
			if(data==""){
				jAlert("没有符合要求的数据。","提示")
			}
			if(mark=="file" && data>""){
				jAlert("点击右侧链接，下载<a href='" + data + "'>统计报告</a>","下载文件");
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
	