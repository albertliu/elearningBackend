	var studentListLong = 0;		//0: 标准栏目  1：短栏目
	var studentListChk = 0;

	$(document).ready(function (){
		var w611 = "status=0 and hostNo='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("rptStudentHost","hostInfo","hostNo","title","status=0 order by hostName",1);
		}else{
			getComList("rptStudentHost","hostInfo","hostNo","title",w611,0);
		}
		getDicList("student","rptStudentKind",1);
		$("#rptStudentStartDate").click(function(){WdatePicker();});
		$("#rptStudentEndDate").click(function(){WdatePicker();});
		
		$("#btnRptStudent").click(function(){
			getRptStudentList("data");
		});
		
		$("#btnRptStudentDownLoad").click(function(){
			getRptStudentList("file");
		});
	});

	function getRptStudentList(mark){
		var g1 = 0;
		var g2 = 0;
		var g3 = 0;
		var g4 = "";
		if($("#rptStudentGroupHost").attr("checked")){g1 = 1;}
		if($("#rptStudentGroupDept").attr("checked")){g2 = 1;}
		if($("#rptStudentGroupKind").attr("checked")){g3 = 1;}
		g4 = $("input[name='rptStudentGroupDate']:checked").val();
		if(g1+g2+g3==0 && g4==""){
			jAlert("请至少指定一个汇总项目。")
			return false;
		}
		//alert("op=student&mark=" + mark + "&host=" + $("#rptStudentHost").val() + "&kindID=" + $("#rptStudentKind").val() + "&startDate=" + $("#rptStudentStartDate").val() + "&endDate=" + $("#rptStudentEndDate").val() + "&groupHost=" + g1 + "&groupDept1=" + g2 + "&groupKindID=" + g3 + "&groupDate=" + g4);
		//@host varchar(50),@startDate varchar(50),@endDate varchar(50),@kindID varchar(20),@groupHost int,@groupDept1 int,@groupKindID int,@groupDate
		$.getJSON(uploadURL + "/public/getRptList?op=student&mark=" + mark + "&host=" + $("#rptStudentHost").val() + "&kindID=" + $("#rptStudentKind").val() + "&startDate=" + $("#rptStudentStartDate").val() + "&endDate=" + $("#rptStudentEndDate").val() + "&groupHost=" + g1 + "&groupDept1=" + g2 + "&groupKindID=" + g3 + "&groupDate=" + g4,function(data){
			//jAlert(data);
			if(mark=="file" && data>""){
				jAlert("点击右侧链接，下载<a href='" + data + "'>统计报告</a>","下载文件");
			}

			if(mark=="data" && data.length>0){
				let ar = new Array();
				arr = [];
				arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='rptStudentTab' width='99%'>");
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
				$("#rptStudentCover").html(arr.join(""));
				arr = [];
				$('#rptStudentTab').dataTable({
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
	