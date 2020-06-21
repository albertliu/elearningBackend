	var trainningListLong = 0;		//0: 标准栏目  1：短栏目
	var trainningListChk = 0;

	$(document).ready(function (){
		var w621 = "status=0 and hostNo='" + currHost + "'";
		var w622 = "status=0 and (kindID=0 or host='" + currHost + "')";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("rptTrainningHost","hostInfo","hostNo","title","status=0 order by hostName",1);
			getComList("rptTrainningCourse","courseInfo","courseID","courseName","status=0 order by courseID",1);
		}else{
			getComList("rptTrainningHost","hostInfo","hostNo","title",w621,0);
			getComList("rptTrainningCourse","courseInfo","courseID","courseName",w622,1);
		}
		getDicList("student","rptTrainningKind",1);
		getDicList("planStatus","rptTrainningStatus",1);
		$("#rptTrainningStartDate").click(function(){WdatePicker();});
		$("#rptTrainningEndDate").click(function(){WdatePicker();});
		
		$("#btnRptTrainning").click(function(){
			getRptTrainningList("data");
		});
		
		$("#btnRptTrainningDownLoad").click(function(){
			getRptTrainningList("file");
		});
	});

	function getRptTrainningList(mark){
		var g1 = 0;
		var g2 = 0;
		var g3 = 0;
		var g4 = 0;
		var g5 = 0;
		var g11 = "";
		if($("#rptTrainningGroupHost").attr("checked")){g1 = 1;}
		if($("#rptTrainningGroupDept").attr("checked")){g2 = 1;}
		if($("#rptTrainningGroupKind").attr("checked")){g3 = 1;}
		if($("#rptTrainningGroupCourse").attr("checked")){g4 = 1;}
		if($("#rptTrainningGroupStatus").attr("checked")){g5 = 1;}
		g11 = $("input[name='rptTrainningGroupDate']:checked").val();
		if(g1+g2+g3+g4+g5==0 && g11==""){
			jAlert("请至少指定一个汇总项目。")
			return false;
		}
		//alert("op=trainning&mark=" + mark + "&host=" + $("#rptTrainningHost").val() + "&kindID=" + $("#rptTrainningKind").val() + "&startDate=" + $("#rptTrainningStartDate").val() + "&endDate=" + $("#rptTrainningEndDate").val() + "&groupHost=" + g1 + "&groupDept1=" + g2 + "&groupKindID=" + g3 + "&groupDate=" + g4);
		//@host varchar(50),@startDate varchar(50),@endDate varchar(50),@kindID varchar(20),@groupHost int,@groupDept1 int,@groupKindID int,@groupDate
		$.getJSON(uploadURL + "/public/getRptList?op=trainning&mark=" + mark + "&host=" + $("#rptTrainningHost").val() + "&kindID=" + $("#rptTrainningKind").val() + "&courseID=" + $("#rptTrainningCourse").val() + "&status=" + $("#rptTrainningStatus").val() + "&startDate=" + $("#rptTrainningStartDate").val() + "&endDate=" + $("#rptTrainningEndDate").val() + "&groupHost=" + g1 + "&groupDept1=" + g2 + "&groupKindID=" + g3 + "&groupCourseID=" + g4 + "&groupStatus=" + g5 + "&groupDate=" + g11,function(data){
			//jAlert(data);
			if(mark=="file" && data>""){
				jAlert("点击右侧链接，下载<a href='" + data + "'>统计报告</a>","下载文件");
			}

			if(mark=="data" && data.length>0){
				let ar = new Array();
				arr = [];
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptTrainningTab' width='99%'>");
				arr.push("<thead>");
				arr.push("<tr align='center'>");
				arr.push("<th width='3%'>No</th>");
				let line = data[0];
				for(let key in line){
					arr.push("<th class='center'>" + key + "</th>");
				}
				arr.push("</tr>");
				arr.push("</thead>");
				arr.push("<tbody id='tbody'>");
				var i = 0;
				var c = 0;
				var h = "";
				$.each(data,function(iNum,val){
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					for(let key in val){
						arr.push("<td class='left'>" + val[key] + "</td>");
					}
					arr.push("</tr>");
				});
				arr.push("</tbody>");
				arr.push("<tfoot>");
				arr.push("<tr>");
				for(let j=0; j<data[0].length+1; j++){
					arr.push("<th>&nbsp;</th>");
				}
				arr.push("</tr>");
				arr.push("</tfoot>");
				arr.push("</table>");
				$("#rptTrainningCover").html(arr.join(""));
				arr = [];
				$('#rptTrainningTab').dataTable({
					"aaSorting": [],
					"bFilter": true,
					"bPaginate": true,
					"bLengthChange": true,
					"bInfo": true,
					"aoColumnDefs": []
				});
			}
		});
	}
	