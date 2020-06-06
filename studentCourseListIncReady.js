	var studentCourseListLong = 0;		//0: 标准栏目  1：短栏目
	var studentCourseListChk = 0;

	$(document).ready(function (){
		var w = "status=0 and hostNo='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchStudentCourseHost","hostInfo","hostNo","title","status=0 order by hostName",1);
		}else{
			getComList("searchStudentCourseHost","hostInfo","hostNo","title",w,0);
		}
		getDicList("student","searchStudentCourseKind",1);
		getDicList("planStatus","searchStudentCourseStatus",1);
		$("#searchStudentCourseStartDate").click(function(){WdatePicker();});
		$("#searchStudentCourseEndDate").click(function(){WdatePicker();});
		
		$("#btnSearchStudentCourse").click(function(){
			getStudentCourseList();
		});
		
		$("#txtSearchStudentCourse").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchStudentCourse").val()>""){
					getStudentCourseList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		
		$("#searchStudentCourseOld").change(function(){
			getStudentCourseList();
		});

		getStudentCourseList();
	});

	function getStudentCourseList(){
		sWhere = $("#txtSearchStudentCourse").val();
		var Old = 0;
		if($("#searchStudentCourseOld").attr("checked")){Old = 1;}
		//alert((sWhere) + "&kindID=" + $("#searchStudentCourseKind").val() + "&status=" + $("#searchStudentCourseStatus").val() + "&host=" + $("#searchStudentCourseHost").val() + "&Old=" + Old + "&fStart=" + $("#searchStudentCourseStartDate").val() + "&fEnd=" + $("#searchStudentCourseEndDate").val());
		$.get("studentCourseControl.asp?op=getStudentCourseList&where=" + escape(sWhere) + "&kindID=" + $("#searchStudentCourseKind").val() + "&status=" + $("#searchStudentCourseStatus").val() + "&host=" + $("#searchStudentCourseHost").val() + "&Old=" + Old + "&fStart=" + $("#searchStudentCourseStartDate").val() + "&fEnd=" + $("#searchStudentCourseEndDate").val() + "&dk=13&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#studentCourseCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='studentCourseTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='11%'>身份证</th>");
			arr.push("<th width='8%'>姓名</th>");
			arr.push("<th width='7%'>年龄</th>");
			arr.push("<th width='13%'>课程名称</th>");
			if(currHost==""){
				arr.push("<th width='12%'>公司</th>");
			}else{
				arr.push("<th width='12%'>部门</th>");
			}
			arr.push("<th width='7%'>课时</th>");
			arr.push("<th width='5%'>进度</th>");
			arr.push("<th width='6%'>状态</th>");
			arr.push("<th width='9%'>选课</th>");
			arr.push("<th width='6%'>成绩</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					h = ar1[13];	//公司用户显示部门1名称
					if(ar1[9]>=55){c = 2;}	//55岁红色
					if(currHost==""){h = ar1[12];}	//系统用户显示公司名称
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showStudentCourseInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					if(currHost==""){
						arr.push("<td class='left'>" + ar1[12] + "</td>");
					}else{
						arr.push("<td class='left'>" + ar1[13] + "</td>");
					}
					arr.push("<td class='left'>" + ar1[9] + "</td>");
					arr.push("<td class='left'>" + ar1[10] + "%</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
					arr.push("<td class='left'>" + ar1[15] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#studentCourseCover").html(arr.join(""));
			arr = [];
			$('#studentCourseTab').dataTable({
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
	