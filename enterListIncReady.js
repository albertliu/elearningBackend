	var enterListLong = 0;		//0: 标准栏目  1：短栏目
	var enterListChk = 0;
	var enterProjectStatus = 0;

	$(document).ready(function (){
		getComList("searchEnterHost","hostInfo","hostNo","title","status=0 order by hostName",1);
		getComList("searchEnterCourseID","v_courseInfo","courseID","shortName","status=0 and type=0 order by courseID",1);
		getComList("searchEnterProjectID","projectInfo","projectID","projectName","status>0 and status<9 order by ID desc",1);
		getComList("searchEnterClassID","v_classInfo","classID","className","1=1 order by ID desc",1);

		getDicList("student","searchEnterKind",1);
		getDicList("planStatus","searchEnterStatus",1);
		getDicList("statusCheck","searchEnterChecked",1);
		getDicList("statusNo","searchEnterMaterialChecked",1);
		getDicList("statusNo","searchEnterPasscard",1);
		getDicList("statusAsk","searchEnterPhotoStatus",1);
		getDicList("reexamine","searchEnterReexamine",1);
		$("#searchEnterStartDate").click(function(){WdatePicker();});
		$("#searchEnterEndDate").click(function(){WdatePicker();});
		
		$("#btnSearchEnter").click(function(){
			getEnterList();
		});
		
		$("#txtSearchEnter").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchEnter").val()>""){
					getEnterList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});

		if(currHost==""){
			$("#searchEnterDateItem").html("报到日期");
		}else{
			$("#searchEnterDateItem").html("报名日期");
		}
		
		$("#btnEnterSel").click(function(){
			setSel("visitstockchkEnter");
		});
		
		$("#btnEnterBadPhoto").click(function(){
			getSelCart("visitstockchkEnterPhoto");
			if(selCount==0){
				jAlert("请选择要通知重新上传图片的名单。");
				return false;
			}
			jConfirm("确定通知将这些(" + selCount + "个)图片重新上传吗？","确认",function(r){
				if(r){
					//alert($("#searchEnterProjectID").val() + "&status=1&host=" + $("#searchEnterHost").val() + "&keyID=" + selList);
					//jAlert(selList);
					//$.get("enterControl.asp?op=doStudentMaterial_resubmit&status=1&keyID=" + selList ,function(data){
					$.getJSON(uploadURL + "/public/resubmit_student_materials", {status: 1, selList: selList, registerID: currUser} ,function(data){
						//jAlert(data);
						if(data["status"]==0){
							getEnterList();
						}
						jAlert(data["msg"]);
					});
				}
			});
		});
		
		$("#btnEnterGoodPhoto").click(function(){
			getSelCart("visitstockchkEnterPhoto");
			if(selCount==0){
				jAlert("请选择要确认图片的名单。");
				return false;
			}
			jConfirm("确定接受这些(" + selCount + "个)图片吗？","确认",function(r){
				if(r){
					$.getJSON(uploadURL + "/public/resubmit_student_materials", {status: 3, selList: selList, registerID: currUser} ,function(data){
						//jAlert(data);
						if(data["status"]==0){
							getEnterList();
						}
						jAlert(data["msg"]);
					});
				}
			});
		});
		
		$("#searchEnterHost").change(function(){
			getComList("searchEnterDept","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where host='" + $("#searchEnterHost").val() + "' and pID=0) and dept_status<9",1);
			getComList("searchEnterProjectID","projectInfo","projectID","projectName","host='" + $("#searchEnterHost").val() + "' and status=1 or status=2 order by ID desc",1);
		});
		
		$("#searchEnterProjectID").change(function(){
			setEnterItem();
		});
		
		$("#searchEnterShowPhoto").change(function(){
			setEnterItem();
		});
		
		$("#searchEnterClassID").change(function(){
			setEnterItem();
		});

		//$("#enterListLongItem3").hide();
		$("#enterListLongItem4").hide();
		$("#enterListLongItem5").hide();
		$("#enterListLongItem7").hide();
		
		$("#btnEnterCheck").click(function(){
			getSelCart("visitstockchkEnter");
			if(selCount==0){
				jAlert("请选择要确认的名单。");
				return false;
			}
			jConfirm("确定要确认这些(" + selCount + "个)人的报名材料合格吗？","确认",function(r){
				if(r){
					//alert($("#searchEnterProjectID").val() + "&status=1&host=" + $("#searchEnterHost").val() + "&keyID=" + selList);
					//jAlert(selList);
					$.get("studentCourseControl.asp?op=doMaterial_check_batch&keyID=" + selList ,function(data){
						//jAlert(data);
						if(data=="0"){
							jAlert("确认成功");
							getEnterList();
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});
		
		$("#btnEnterPasscard").click(function(){
			getSelCart("visitstockchkEnter");
			if(selCount==0){
				jAlert("请选择制作准考证的名单。");
				return false;
			}
			if($("#searchEnterClassID").val()==""){
				jAlert("请选择一个班级。");
				return false;
			}
			showGeneratePasscardInfo(0,selList,1,1,$("#searchEnterClassID").val(),selCount);
		});
		
		if(!checkPermission("studentAdd")){
			$("#btnSearchEnterAdd").hide();
		}
		
		$("#btnSearchEnterAdd").click(function(){
			showStudentInfo(0,0,1,1);
		});
		$("#btnRefundList").click(function(){
			getSelCart("visitstockchkEnter");
			if(selCount==0){
				jAlert("请选择制作退费单的人员。");
				return false;
			}
			if($("#searchEnterClassID").val()==""){
				jAlert("请选择一个班级。");
				return false;
			}
			$.getJSON(uploadURL + "/outfiles/generate_refund_list?class=" + $("#searchEnterClassID").find("option:selected").text() + "&selList=" + selList + "&price=10" ,function(data){
				if(data>""){
					asyncbox.alert("已生成 <a href='" + data + "' target='_blank'>下载文件</a>",'操作成功',function(action){
					　　//alert 返回action 值，分别是 'ok'、'close'。
					　　if(action == 'ok'){
					　　}
					　　if(action == 'close'){
					　　　　//alert('close');
					　　}
					});
					//getNodeInfo(nodeID);
				}else{
					alert("没有可供处理的数据。");
				}
			});
		});
		$("#btnEnterCheck").hide();
		//getEnterList();
	});

	function getEnterList(){
		sWhere = $("#txtSearchEnter").val();
		var Old = 0;
		//if($("#searchEnterOld").attr("checked")){Old = 1;}
		//alert($("#searchEnterDept").val() + "&refID=" + $("#searchEnterProjectID").val() + "&status=" + $("#searchEnterStatus").val() + "&photoStatus=" + $("#searchEnterPhotoStatus").val() + "&courseID=" + $("#searchEnterCourseID").val() + "&host=" + $("#searchEnterHost").val() + "&checked=" + $("#searchEnterChecked").val() + "&materialChecked=" + $("#searchEnterMaterialChecked").val() + "&classID=" + $("#searchEnterClassID").val());
		$.get("studentCourseControl.asp?op=getStudentCourseList&where=" + escape(sWhere) + "&mark=1&kindID=" + $("#searchEnterDept").val() + "&refID=" + $("#searchEnterProjectID").val() + "&status=" + $("#searchEnterStatus").val() + "&reexamine=" + $("#searchEnterReexamine").val() + "&photoStatus=" + $("#searchEnterPhotoStatus").val() + "&courseID=" + $("#searchEnterCourseID").val() + "&host=" + $("#searchEnterHost").val() + "&checked=" + $("#searchEnterChecked").val() + "&materialChecked=" + $("#searchEnterMaterialChecked").val() + "&passcard=" + $("#searchEnterPasscard").val() + "&classID=" + $("#searchEnterClassID").val() + "&fStart=" + $("#searchEnterStartDate").val() + "&fEnd=" + $("#searchEnterEndDate").val() + "&dk=101&times=" + (new Date().getTime()),function(data){
		//$.getJSON("enterControl.asp?op=getEnterList",function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#enterCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			var ar2 = new Array();
			var role = checkRole("teacher");
			//alert(role);
			$.get("certControl.asp?op=getCertNeedMaterialListByProjectID&refID=" + $("#searchEnterProjectID").val(),function(data1){
				//jAlert($("#searchEnterProjectID").val() + ":" + unescape(data1));
				ar2 = (unescape(data1)).split("%%");
			});
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='enterTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='9%'>身份证</th>");
			arr.push("<th width='7%'>姓名</th>");
			if($("#searchEnterProjectID").val()>"" && $("#searchEnterShowPhoto").attr("checked")){
				$.each(ar2,function(iNum1,val1){
					var ar3 = new Array();
					ar3 = val1.split("|");
					arr.push("<th width='10%'>" + ar3[2] + "</th>");
				});
			}else{
				if($("#searchEnterProjectID").val()>""){
					arr.push("<th width='12%'>班级名称</th>");
				}else{
					arr.push("<th width='12%'>课程名称</th>");
				}
				if(currHost==""){
					arr.push("<th width='8%'>公司</th>");
				}else{
					arr.push("<th width='8%'>部门</th>");
				}
				if(currHost==""){
					arr.push("<th width='9%'>提交日期</th>");
				}else{
					arr.push("<th width='9%'>报名日期</th>");
				}
			}
			//arr.push("<th width='6%'>单位</th>");
			arr.push("<th width='5%'>表</th>");
			if(role){
				arr.push("<th width='6%'>成绩</th>");
				arr.push("<th width='6%'>次数</th>");
			}else{
				arr.push("<th width='5%'>缺</th>");
				arr.push("<th width='5%'>编</th>");
			}
			arr.push("<th width='5%'>申</th>");
			arr.push("<th width='5%'>准</th>");
			arr.push("<th width='5%'>分</th>");
			arr.push("<th width='2%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var n = 0;
				var imgChk = "<img src='images/attachment.png' style='width:14px;'>";
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
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(" + ar1[0] + ",\"" + ar1[1] + "\",0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='link1'><a href='javascript:showStudentInfo(0,\"" + ar1[1] + "\",0,1);'>" + ar1[2] + "</a></td>");
					if($("#searchEnterProjectID").val()>"" && $("#searchEnterShowPhoto").attr("checked")){
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
								imgChk += "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "|" + m + "' name='visitstockchkEnterPhoto'>";
							}
							arr.push("<td class='center'>" + imgChk + "</td>");
						});
					}else{
						if($("#searchEnterProjectID").val()>""){
							arr.push("<td class='left'>" + ar1[52] + "</td>");
						}else{
							arr.push("<td class='left'>" + ar1[62] + "</td>");
						}	
						if(currHost==""){
							if(ar1[56]=="znxf"){	//非集团客户，显示自己的单位和部门
								arr.push("<td class='left'>" + ar1[54].substr(0,4) + "</td>");
							}else{
								arr.push("<td class='left'>" + ar1[12].substr(0,4) + "</td>");
							}
						}else{
							arr.push("<td class='left'>" + ar1[13].substr(0,5) + "</td>");
						}
						if(currHost==""){
							arr.push("<td class='left'>" + ar1[39] + "</td>");
						}else{
							arr.push("<td class='left'>" + ar1[11] + "</td>");
						}
						
					}
					//arr.push("<td class='link1'><a href='javascript:window.open(\"entryform_" + ar1[60] + ".asp?keyID=0&nodeID=" + ar1[0] + "&refID=" + ar1[1] + ", \"_blank\");'>" + imgChk + "</a></td>");
					arr.push("<td class='link1'><a href='javascript:openEntryForm(\"" + ar1[60] + "\"," + ar1[0] + ",\"" + ar1[1] + "\");'>" + imgChk + "</a></td>");
					if(role){
						arr.push("<td class='left'>" + ar1[15] + "</td>");
						arr.push("<td class='left'>" + ar1[59] + "</td>");
					}else{
						n = ar1[61].split(",").length;
						if(n>0 && ar1[61]>''){
							arr.push("<td class='left' title='" + ar1[61] + "'>" + n + "</td>");
						}else{
							arr.push("<td class='left'>&nbsp;</td>");
						}
						arr.push("<td class='left'>" + ar1[43] + "</td>");
					}
					/*申报*/
					if(ar1[65]>0){
						arr.push("<td class='center'>" + imgChk1 + "</td>");	//申报
					}else{
						arr.push("<td class='center'>&nbsp;</td>");
					}
					if(ar1[53]>0){
						arr.push("<td class='center'>" + imgChk1 + "</td>");	//准考证
					}else{
						arr.push("<td class='center'>&nbsp;</td>");
					}
					/*
					if(ar1[64]>""){
						arr.push("<td class='center'>" + imgChk1 + "</td>");	//证书
					}else{
						arr.push("<td class='center'>&nbsp;</td>");
					}*/
					arr.push("<td class='left'>" + ar1[66] + "</td>");
					arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchkEnter'>" + "</td>");
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
			if($("#searchEnterProjectID").val()>"" && $("#searchEnterShowPhoto").attr("checked")){
				$.each(ar2,function(iNum1,val1){
					arr.push("<th>&nbsp;</th>");
				});
			}else{
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
			}
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#enterCover").html(arr.join(""));
			arr = [];
			$('#enterTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"bInfo": true,
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 500,
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

	function setEnterItem(){
		if($("#searchEnterProjectID").val()>"" || $("#searchEnterClassID").val()>""){
			$.get("projectControl.asp?op=getStatus&refID=" + $("#searchEnterProjectID").val() ,function(data){
				enterProjectStatus = data;
			});
			if($("#searchEnterShowPhoto").attr("checked")){
				$("#enterListLongItem4").show();
				$("#enterListLongItem5").hide();
			}else{
				if(checkPermission("studentAdd")){
					if($("#searchEnterProjectID").val()>""){
						$("#btnEnterApply").show();
						$("#btnEnterApplyBack").show();
					}else{
						$("#btnEnterApply").hide();
						$("#btnEnterApplyBack").show();
					}
					$("#enterListLongItem5").show();
				}else{
					$("#enterListLongItem5").hide();
				}
				$("#enterListLongItem4").hide();
			}
		}else{
			$("#enterListLongItem4").hide();
			$("#enterListLongItem5").hide();
		}
		getEnterList();
	}

	function openEntryForm(c,n,f){
		if(c == "C21"){
			c = "C20";
		}
		window.open("entryform_" + c + ".asp?keyID=0&nodeID=" + n + "&refID=" + f, "_blank");
	}
	