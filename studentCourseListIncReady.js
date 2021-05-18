	var studentCourseListLong = 0;		//0: 标准栏目  1：短栏目
	var studentCourseListChk = 0;
	var studentCourseProjectStatus = 0;

	$(document).ready(function (){
		var w1 = "status=0 and hostNo='" + currHost + "'";
		var w2 = "status=0 and (kindID=0 or host='" + currHost + "')";
		var w3 = " and deptID=" + currDeptID;
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchStudentCourseHost","hostInfo","hostNo","title","status=0 order by hostName",1);
			getComList("searchStudentCourseID","v_courseInfo","courseID","shortName","status=0 order by courseID",1);
			getComList("searchStudentCourseProjectID","projectInfo","projectID","projectName","status>0 and status<9 order by ID desc",1);
		}else{
			getComList("searchStudentCourseHost","hostInfo","hostNo","title",w1,0);
			getComList("searchStudentCourseID","v_courseInfo","courseID","shortName",w2,1);
			getComList("searchStudentCourseProjectID","projectInfo","projectID","projectName","host='" + currHost + "' and status>0 and status<9 order by ID desc",1);
			$("#studentCourseListLongItem1").hide();
			if(currDeptID>0){
				getComList("searchStudentCourseDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchStudentCourseHost").val() + "' and pID=0)" + w3,1);
			}else{
				getComList("searchStudentCourseDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchStudentCourseHost").val() + "' and pID=0) and dept_status<9",1);
			}
		}
		getDicList("student","searchStudentCourseKind",1);
		getDicList("planStatus","searchStudentCourseStatus",1);
		getDicList("statusCheck","searchStudentCourseChecked",1);
		getDicList("statusSubmit","searchStudentCourseSubmited",1);
		getDicList("statusAsk","searchStudentCoursePhotoStatus",1);
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
		
		$("#btnStudentCourseSel").click(function(){
			setSel("visitstockchkCourse");
		});
		
		$("#btnStudentCourseSel1").click(function(){
			setSel("visitstockchkCourse");
		});
		
		$("#btnStudentCourseBadPhoto").click(function(){
			getSelCart("visitstockchkCoursePhoto");
			if(selCount==0){
				jAlert("请选择要通知重新上传图片的名单。");
				return false;
			}
			jConfirm("确定通知将这些(" + selCount + "个)图片重新上传吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentCourseProjectID").val() + "&status=1&host=" + $("#searchStudentCourseHost").val() + "&keyID=" + selList);
					//jAlert(selList);
					//$.get("studentCourseControl.asp?op=doStudentMaterial_resubmit&status=1&keyID=" + selList ,function(data){
					$.getJSON(uploadURL + "/public/resubmit_student_materials", {status: 1, selList: selList, registerID: currUser} ,function(data){
						//jAlert(data);
						if(data["status"]==0){
							getStudentCourseList();
						}
						jAlert(data["msg"]);
					});
				}
			});
		});
		
		$("#btnStudentCourseGoodPhoto").click(function(){
			getSelCart("visitstockchkCoursePhoto");
			if(selCount==0){
				jAlert("请选择要确认图片的名单。");
				return false;
			}
			jConfirm("确定接受这些(" + selCount + "个)图片吗？","确认",function(r){
				if(r){
					$.getJSON(uploadURL + "/public/resubmit_student_materials", {status: 3, selList: selList, registerID: currUser} ,function(data){
						//jAlert(data);
						if(data["status"]==0){
							getStudentCourseList();
						}
						jAlert(data["msg"]);
					});
				}
			});
		});
		
		$("#searchStudentCourseHost").change(function(){
			getComList("searchStudentCourseDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchStudentCourseHost").val() + "' and pID=0) and dept_status<9",1);
			getComList("searchStudentCourseProjectID","projectInfo","projectID","projectID","host='" + $("#searchStudentCourseHost").val() + "' and status=1 or status=2 order by ID desc",1);
		});
		
		$("#searchStudentCourseProjectID").change(function(){
			setStudentCourseItem();
		});
		
		$("#searchStudentCourseShowPhoto").change(function(){
			setStudentCourseItem();
		});

		$("#studentCourseListLongItem3").hide();
		$("#studentCourseListLongItem4").hide();
		$("#studentCourseListLongItem5").hide();
		$("#studentCourseListLongItem7").hide();
		
		$("#btnStudentCourseCheck").click(function(){
			getSelCart("visitstockchkCourse");
			if($("#searchStudentCourseProjectID").val()==""){
				jAlert("请选择一个招生批号。");
				return false;
			}
			if(selCount==0){
				jAlert("请选择要确认的名单。");
				return false;
			}
			jConfirm("确定要确认这些(" + selCount + "个)人的报名吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentCourseProjectID").val() + "&status=1&host=" + $("#searchStudentCourseHost").val() + "&keyID=" + selList);
					//jAlert(selList);
					$.get("studentCourseControl.asp?op=doStudentCourse_check&refID=" + $("#searchStudentCourseProjectID").val() + "&status=1&host=" + $("#searchStudentCourseHost").val() + "&keyID=" + selList ,function(data){
						//jAlert(data);
						if(data=="0"){
							jAlert("确认成功");
							getStudentCourseList();
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});
		
		$("#btnStudentCourseRefuse").click(function(){
			getSelCart("visitstockchkCourse");
			if($("#searchStudentCourseProjectID").val()==""){
				jAlert("请选择一个招生批号。");
				return false;
			}
			if(selCount==0){
				jAlert("请选择剔除的名单。");
				return false;
			}
			jConfirm("确定要里剔除这些(" + selCount + "个)人吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					//jAlert(selList);
					$.get("studentCourseControl.asp?op=doStudentCourse_check&refID=" + $("#searchStudentCourseProjectID").val() + "&status=2&host=" + $("#searchStudentCourseHost").val() + "&keyID=" + selList ,function(data){
						//jAlert(data);
						if(data=="0"){
							jAlert("剔除成功");
							getStudentCourseList();
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});
		
		$("#btnStudentCourseSubmit").click(function(){
			getSelCart("visitstockchkCourse");
			if($("#searchStudentCourseProjectID").val()==""){
				jAlert("请选择一个招生批号。");
				return false;
			}
			if(selCount==0){
				jAlert("请选择要提交的名单。");
				return false;
			}
			jConfirm("确定要向教务处提交这些(" + selCount + "个)人的报名吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentCourseProjectID").val() + "&status=1&host=" + $("#searchStudentCourseHost").val() + "&keyID=" + selList);
					//jAlert(selList);
					$.get("studentCourseControl.asp?op=doStudentCourse_submit&refID=" + $("#searchStudentCourseProjectID").val() + "&status=1&host=" + $("#searchStudentCourseHost").val() + "&keyID=" + selList ,function(data){
						//jAlert(data);
						if(data=="0"){
							jAlert("提交成功");
							getStudentCourseList();
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});
		
		$("#btnStudentCourseCallback").click(function(){
			getSelCart("visitstockchkCourse");
			if($("#searchStudentCourseProjectID").val()==""){
				jAlert("请选择一个招生批号。");
				return false;
			}
			if(selCount==0){
				jAlert("请选择要提交的名单。");
				return false;
			}
			jConfirm("确定要拒绝提交这些(" + selCount + "个)人的报名吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentCourseProjectID").val() + "&status=1&host=" + $("#searchStudentCourseHost").val() + "&keyID=" + selList);
					//jAlert(selList);
					$.get("studentCourseControl.asp?op=doStudentCourse_submit&refID=" + $("#searchStudentCourseProjectID").val() + "&status=2&host=" + $("#searchStudentCourseHost").val() + "&keyID=" + selList ,function(data){
						//jAlert(data);
						if(data=="0"){
							jAlert("操作成功");
							getStudentCourseList();
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});

		//getStudentCourseList();
	});

	function getStudentCourseList(){
		sWhere = $("#txtSearchStudentCourse").val();
		var Old = 0;
		//if($("#searchStudentCourseOld").attr("checked")){Old = 1;}
		//alert($("#searchStudentCourseDept").val() + "&refID=" + $("#searchStudentCourseProjectID").val() + "&status=" + $("#searchStudentCourseStatus").val() + "&courseID=" + $("#searchStudentCourseID").val() + "&host=" + $("#searchStudentCourseHost").val());
		$.get("studentCourseControl.asp?op=getStudentCourseList&where=" + escape(sWhere) + "&kindID=" + $("#searchStudentCourseDept").val() + "&refID=" + $("#searchStudentCourseProjectID").val() + "&status=" + $("#searchStudentCourseStatus").val() + "&photoStatus=" + $("#searchStudentCoursePhotoStatus").val() + "&courseID=" + $("#searchStudentCourseID").val() + "&host=" + $("#searchStudentCourseHost").val() + "&checked=" + $("#searchStudentCourseChecked").val() + "&submited=" + $("#searchStudentCourseSubmited").val() + "&Old=" + Old + "&fStart=" + $("#searchStudentCourseStartDate").val() + "&fEnd=" + $("#searchStudentCourseEndDate").val() + "&dk=13&times=" + (new Date().getTime()),function(data){
		//$.getJSON("studentCourseControl.asp?op=getStudentCourseList",function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#studentCourseCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			var ar2 = new Array();
			$.get("certControl.asp?op=getCertNeedMaterialListByProjectID&refID=" + $("#searchStudentCourseProjectID").val(),function(data1){
				//jAlert($("#searchStudentCourseProjectID").val() + ":" + unescape(data1));
				ar2 = (unescape(data1)).split("%%");
			});
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='studentCourseTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='10%'>身份证</th>");
			arr.push("<th width='7%'>姓名</th>");
			if($("#searchStudentCourseProjectID").val()>"" && $("#searchStudentCourseShowPhoto").attr("checked")){
				$.each(ar2,function(iNum1,val1){
					var ar3 = new Array();
					ar3 = val1.split("|");
					arr.push("<th width='10%'>" + ar3[2] + "</th>");
				});
			}else{
				arr.push("<th width='12%'>课程名称</th>");
				if(currHost==""){
					arr.push("<th width='12%'>公司</th>");
				}else{
					arr.push("<th width='12%'>部门</th>");
				}
				arr.push("<th width='6%'>状态</th>");
				arr.push("<th width='8%'>报名日期</th>");
			}
			arr.push("<th width='6%'>确认</th>");
			arr.push("<th width='6%'>提交</th>");
			arr.push("<th width='3%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk1 = "<img src='images/green_check.png'>";
				var imgChk2 = "<img src='images/cancel.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					h = ar1[13];	//公司用户显示部门1名称
					//if(ar1[9]>=55){c = 2;}	//55岁红色
					if(currHost==""){h = ar1[12];}	//系统用户显示公司名称
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showStudentCourseInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[1] + "</a></td>");
					//arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showStudentInfo(0,\"" + ar1[1] + "\",0,1);'>" + ar1[2] + "</a></td>");
					if($("#searchStudentCourseProjectID").val()>"" && $("#searchStudentCourseShowPhoto").attr("checked")){
						$.each(ar2,function(iNum1,val1){
							var ar3 = new Array();
							ar3 = val1.split("|");
							var fn = "";
							var imgChk = "&nbsp;";
							var m = parseInt(ar3[0]);
							var bc = "#fff";
							if(ar1[23 + m*3] == 1){
								bc = "#f00";
							}
							if(ar1[23 + m*3] == 2){
								bc = "#ff0";
							}
							if(ar1[23 + m*3] == 3){
								bc = "#0f0";
							}
							fn = ar1[18 + m];
							if(fn>""){
								imgChk = "<img src='users" + fn + "' style='width:50px;background: #ccc;border:2px " + bc + " solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'>";
								imgChk += "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "|" + m + "' name='visitstockchkCoursePhoto'>";
							}
							arr.push("<td class='center'>" + imgChk + "</td>");
						});
					}else{
						arr.push("<td class='left'>" + ar1[6] + "</td>");
						if(currHost==""){
							arr.push("<td class='left'>" + ar1[12].substr(0,4) + "</td>");
						}else{
							arr.push("<td class='left'>" + ar1[13].substr(0,5) + "</td>");
						}
						arr.push("<td class='left'>" + ar1[4] + "</td>");
						arr.push("<td class='left'>" + ar1[11] + "</td>");
						
					}
					if(ar1[16]==0){
						arr.push("<td class='center'>&nbsp;</td>");
					}
					if(ar1[16]==1){
						arr.push("<td class='center'>" + imgChk1 + "</td>");
					}
					if(ar1[16]==2){
						arr.push("<td class='center'>" + imgChk2 + "</td>");
					}
					if(ar1[38]==0){
						arr.push("<td class='center'>&nbsp;</td>");
					}
					if(ar1[38]==1){
						arr.push("<td class='center'>" + imgChk1 + "</td>");
					}
					if(ar1[38]==2){
						arr.push("<td class='center'>" + imgChk2 + "</td>");
					}
					arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchkCourse'>" + "</td>");
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
			if($("#searchStudentCourseProjectID").val()>"" && $("#searchStudentCourseShowPhoto").attr("checked")){
				$.each(ar2,function(iNum1,val1){
					arr.push("<th>&nbsp;</th>");
				});
			}else{
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
			}
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
				"iDisplayLength": 100,
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

	function setStudentCourseItem(){
		if($("#searchStudentCourseProjectID").val()>""){
			$("#studentCourseListLongItem6").hide();
			$.get("projectControl.asp?op=getStatus&refID=" + $("#searchStudentCourseProjectID").val() ,function(data){
				studentCourseProjectStatus = data;
			});
			if($("#searchStudentCourseShowPhoto").attr("checked")){
				$("#studentCourseListLongItem4").show();
				$("#studentCourseListLongItem5").hide();
				$("#studentCourseListLongItem7").hide();
			}else{
				if(checkPermission("studentCourseCheck") && studentCourseProjectStatus<3){
					$("#studentCourseListLongItem5").show();
					$("#studentCourseListLongItem7").hide();
				}else{
					$("#studentCourseListLongItem5").hide();
				}
				if(checkPermission("studentCourseSubmit") && studentCourseProjectStatus==3){
					$("#studentCourseListLongItem7").show();
					$("#studentCourseListLongItem5").hide();
				}else{
					$("#studentCourseListLongItem7").hide();
				}
				$("#studentCourseListLongItem4").hide();
			}
		}else{
			$("#studentCourseListLongItem4").hide();
			$("#studentCourseListLongItem5").hide();
			$("#studentCourseListLongItem7").hide();
			$("#studentCourseListLongItem6").show();
		}
		getStudentCourseList();
	}
	