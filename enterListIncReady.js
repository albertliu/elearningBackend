	var enterListLong = 0;		//0: 标准栏目  1：短栏目
	var enterListChk = 0;
	var enterProjectStatus = 0;
	var examer_cart_memo = "";

	$(document).ready(function (){
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchEnterCourseID","v_courseInfo","courseID","shortName","status=0 and host='' order by courseID",1);
			getComList("searchEnterClassAdviser","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='adviser' and host='') order by realName",1);
			getComList("searchEnterHost","hostInfo","hostNo","title","status=0 order by hostName",1);
			getComList("searchEnterClassID","v_classInfo","classID","classIDName","1=1 order by cast(ID as int) desc",1);
			getComList("searchEnterProjectID","projectInfo","projectID","projectName","status>0 and status<9 order by cast(ID as int) desc",1);
		}else{
			getComList("searchEnterHost","hostInfo","hostNo","title","status=0 and hostNo='" + currHost + "'",0);
			getComList("searchEnterCourseID","[dbo].[getHostCourseList]('" + currHost + "')","courseID","courseName","1=1",1);
			getComList("searchEnterClassAdviser","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='adviser' and host='" + currHost + "') order by realName",1);
			getComList("searchEnterClassID","v_classInfo","classID","classIDName","host='" + currHost + "' order by cast(ID as int) desc",1);
			$("#searchEnterProjectID").hide();
		}
		//getComList("searchEnterCourseID","v_courseInfo","courseID","shortName","status=0 and type=0 order by courseID",1);
		//getComList("searchEnterClassAdviser","v_classAdviser","adviserID","adviserName","1=1",1);

		getDicList("student","searchEnterKind",1);
		getDicList("planStatus","searchEnterStatus",1);
		getDicList("statusCheck","searchEnterChecked",1);
		getDicList("statusNo","searchEnterMaterialChecked",1);
		getDicList("statusNo","searchEnterPasscard",1);
		getDicList("statusAsk","searchEnterPhotoStatus",1);
		getDicList("reexamine","searchEnterReexamine",1);
		$("#searchEnterStartDate").click(function(){WdatePicker();});
		$("#searchEnterEndDate").click(function(){WdatePicker();});
		//$("#searchEnterStartDate").val(currDate);

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
			$("#searchEnterPick").html(selCount);
		});
		
		$("#btnEnterBadPhoto").click(function(){
			getSelCart("visitstockchkEnterPhoto");
			if(selCount==0){
				jAlert("请选择要通知的名单。");
				return false;
			}
			jConfirm("确定通知将这" + selCount + "个学员提交电子照片吗？","确认",function(r){
				if(r){
					//alert($("#searchEnterProjectID").val() + "&status=1&host=" + $("#searchEnterHost").val() + "&keyID=" + selList);
					//jAlert(selList);
					//$.get("enterControl.asp?op=doStudentMaterial_resubmit&status=1&keyID=" + selList ,function(data){
					$.getJSON(uploadURL + "/public/send_message_submit_photo", {kind: "", selList: selList, SMS:1, registerID: currUser} ,function(data){
						//jAlert(data);
						getEnterList();
						alert("发送成功。");
					});
				}
			});
		});
		
		$("#btnEnterGoodPhoto").click(function(){
			getSelCart("visitstockchkEnterPhoto");
			if(selCount==0){
				jAlert("请选择要确认照片的名单。");
				return false;
			}
			jConfirm("确定接受这" + selCount + "个提交电子照片通知关闭吗？","确认",function(r){
				if(r){
					$.getJSON(uploadURL + "/public/send_message_submit_attention_close", {batchID: "", kindID:0, kind: "", selList: selList, SMS:1, registerID: currUser} ,function(data){
						//jAlert(data);
						getEnterList();
						alert("发送成功。");
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
		
		$("#searchEnterCourseID").change(function(){
			if($("#searchEnterCourseID").val()>""){
				getComList("searchEnterClassID","v_classInfo","classID","classIDName","certID in(select certID from courseInfo where courseID='" + $("#searchEnterCourseID").val() + "') order by cast(ID as int) desc",1);
			}
		});
		
		$("#searchEnterClassAdviser").change(function(){
			if($("#searchEnterClassAdviser").val()>""){
				getComList("searchEnterClassID","v_classInfo","classID","classIDName","adviserID ='" + $("#searchEnterClassAdviser").val() + "' order by cast(ID as int) desc",1);
			}else{
				if(currHost==""){
					getComList("searchEnterClassID","v_classInfo","classID","classIDName","1=1 order by cast(ID as int) desc",1);
				}else{
					getComList("searchEnterClassID","v_classInfo","classID","classIDName","host='" + currHost + "' order by cast(ID as int) desc",1);
				}
			}
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
		
		if(!checkPermission("studentAdd")){
			$("#btnSearchEnterAdd").hide();
		}
		
		$("#btnSearchEnterAdd").click(function(){
			showStudentInfo(0,0,1,1);
		});
		$("#btnEnterCheck").hide();
		//getEnterList();
		$("#cart_examer").click(function(){
			if(checkPermission("studentAdd")){
				showCartInfo("examer",0,0,1);
			}
		});

		$("#cart_examer_img").click(function(){
			if(checkPermission("studentAdd")){
				showCartInfo("examer",0,0,1);
			}else{
				jAlert("没有使用购物车的权限");
			}
		});

		$("#btnSearchEnterDownload").click(function(){
			getEnterList();
			outputFloat(101,'file');
		});
		
		$("#btnEnterCartAdd").click(function(){
			if(!checkPermission("studentAdd")){
				jAlert("没有使用购物车的权限");
				return false;
			}
			getSelCart("visitstockchkEnter");
			if(selCount==0){
				jAlert("请选择要加入购物车的人员。");
				return false;
			}
			jPrompt('添加备注:', examer_cart_memo, '购物车备注', function (r) {
				if(examer_cart_memo != r){
					examer_cart_memo = r;
				}
				add2Cart("visitstockchkEnter","examer",r);
			});
		});
		
		$("#btnEnterCall").click(function(){
			getSelCart("visitstockchkEnter");
			if(selCount==0){
				jAlert("请选择要通知的名单。");
				return false;
			}
			jConfirm("确定要通知这些(" + selCount + "个)人补交报名材料吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentCourseProjectID").val() + "&status=1&host=" + $("#searchStudentCourseHost").val() + "&keyID=" + selList);
					//jAlert(selList);
					jPrompt('材料内容:', '1张照片、学历证明复印件', '材料催缴通知', function (x) {
						if(x > ""){
							$.post(uploadURL + "/public/send_message_photo", {selList: selList, SMS:1, registerID: currUser} ,function(data){
								//jAlert(data);
								jAlert("发送成功。");
							});
						}
					});
				}
			});
		});
		//getExamerList();
		setCartNum("examer");
	});

	function getStudentCourseList(){
	}

	function getEnterList(){
		sWhere = $("#txtSearchEnter").val();
		var Old = 0;
        var mark = 1;
        if(checkRole("saler") && !checkRole("adviser")){
            mark = 3;
        }
		var photo = 0;
		if($("#searchEnterShowPhoto").prop("checked")){
			photo = 1;
		}
		//if($("#searchEnterOld").attr("checked")){Old = 1;}
		//alert($("#searchEnterDept").val() + "&refID=" + $("#searchEnterProjectID").val() + "&status=" + $("#searchEnterStatus").val() + "&photoStatus=" + $("#searchEnterPhotoStatus").val() + "&courseID=" + $("#searchEnterCourseID").val() + "&host=" + $("#searchEnterHost").val() + "&checked=" + $("#searchEnterChecked").val() + "&materialChecked=" + $("#searchEnterMaterialChecked").val() + "&classID=" + $("#searchEnterClassID").val());
		$.get("studentCourseControl.asp?op=getStudentCourseList&where=" + escape(sWhere) + "&mark=" + mark + "&kindID=" + $("#searchEnterDept").val() + "&refID=" + $("#searchEnterProjectID").val() + "&status=" + $("#searchEnterStatus").val() + "&reexamine=" + $("#searchEnterReexamine").val() + "&photoStatus=" + $("#searchEnterPhotoStatus").val() + "&courseID=" + $("#searchEnterCourseID").val() + "&host=" + $("#searchEnterHost").val() + "&checked=" + $("#searchEnterChecked").val() + "&materialChecked=" + $("#searchEnterMaterialChecked").val() + "&passcard=" + $("#searchEnterPasscard").val() + "&classID=" + $("#searchEnterClassID").val() + "&fStart=" + $("#searchEnterStartDate").val() + "&fEnd=" + $("#searchEnterEndDate").val() + "&completion1=" + $("#searchEnter_completion1").val() + "&score1=" + $("#searchEnter_score1").val() + "&dk=101&times=" + (new Date().getTime()),function(data){
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
			//$.get("certControl.asp?op=getCertNeedMaterialListByProjectID&refID=" + $("#searchEnterProjectID").val(),function(data1){
				//jAlert($("#searchEnterProjectID").val() + ":" + unescape(data1));
			//	ar2 = (unescape(data1)).split("%%");
			//});
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='enterTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='6%'>身份证</th>");
			arr.push("<th width='6%'>姓名</th>");
			if($("#searchEnterProjectID").val()>""){
				arr.push("<th width='9%'>班级名称</th>");
			}else{
				arr.push("<th width='9%'>课程名称</th>");
			}
			if(currHost==""){
				arr.push("<th width='7%'>公司</th>");
			}else{
				arr.push("<th width='7%'>部门</th>");
			}
			if(currHost==""){
				arr.push("<th width='10%'>经办人</th>");
			}else{
				arr.push("<th width='8%'>报名日期</th>");
			}
			//arr.push("<th width='6%'>单位</th>");
			//arr.push("<th width='7%'>电话</th>");
			arr.push("<th width='2%'>表</th>");
			arr.push("<th width='5%'>进度</th>");
			arr.push("<th width='5%'>练习</th>");
			if(role){
				arr.push("<th width='6%'>次数</th>");
			}else{
				arr.push("<th width='5%'>缺</th>");
			}
			arr.push("<th width='8%'>复训日期</th>");
			arr.push("<th width='5%'>准申</th>");
			arr.push("<th width='4%'>证书</th>");
			if(photo == 0){
				arr.push("<th width='5%'>成绩</th>");
				arr.push("<th width='4%'>补考</th>");
			}else{
				arr.push("<th width='10%'>照片</th>");
			}
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
				var backcolor = ["#F0F0F0","#FFFF00","#00FF00","#FF8888"];
				var bc = "";
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
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(" + ar1[0] + ",\"" + ar1[1] + "\",0,1,\"*\");'>" + ar1[1] + "</a></td>");
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
							arr.push("<td class='left' title='" + ar1[62] + "'>" + ar1[62].substring(0,8) + "</td>");
						}	
						if(currHost==""){
							if(ar1[56]=="znxf"){	//非集团客户，显示自己的单位和部门
								arr.push("<td class='left' title='" + ar1[54] + "'>" + ar1[54].substr(0,4) + "</td>");
							}else{
								arr.push("<td class='left' title='" + ar1[12] + "'>" + ar1[12].substr(0,4) + "</td>");
							}
						}else{
							arr.push("<td class='left' title='" + ar1[13] + "'>" + ar1[13].substr(0,5) + "</td>");
						}
						if(currHost==""){
							arr.push("<td class='left'>" + ar1[39] + ar1[67] + "</td>");
						}else{
							arr.push("<td class='left'>" + ar1[11] + "</td>");
						}
						
					}
					//arr.push("<td class='link1'><a href='javascript:window.open(\"entryform_" + ar1[60] + ".asp?keyID=0&nodeID=" + ar1[0] + "&refID=" + ar1[1] + ", \"_blank\");'>" + imgChk + "</a></td>");
					//arr.push("<td class='left'>" + ar1[69] + "</td>");
					arr.push("<td class='link1'><a href='javascript:openEntryForm(\"" + ar1[60] + "\"," + ar1[0] + ",\"" + ar1[1] + "\");'>" + imgChk + "</a></td>");
					c = ar1[10];
					if(c>0){
						c = c;
					}else{
						c = "";
					}
					arr.push("<td class='center'>" + c + "</td>");	//学习进度
					arr.push("<td class='link1' onclick='showStudentExamStat(" + ar1[0] + ",\"" + ar1[2] + "\",0,0);'>" + nullNoDisp(ar1[15]) + "</td>");
					if(role){
						arr.push("<td class='left'>" + ar1[59] + "</td>");
					}else{
						n = ar1[61].split(",").length;
						if(n>0 && ar1[61]>''){
							arr.push("<td class='left' title='" + ar1[61] + "'>" + n + "</td>");
						}else{
							arr.push("<td class='left'>&nbsp;</td>");
						}
					}

					bc = "";
					if(ar1[57]==1){
						if(ar1[83]>"" && ar1[3]<2){	//有复训日期且没有结束课程的
							let x = dateDiff(ar1[83],(new Date().format("yyyy-MM-dd")));
							if(x<=30 && x>0){bc = backcolor[1]}
							if(x>30 && x <= 60){bc = backcolor[2]}
							if(x>60){bc = backcolor[3]}
						}
					}
					arr.push("<td class='left' " + (ar1[57]==1 && bc>"" ? "style='background:" + bc + ";'" : "") + ">" + ar1[83] + "</td>");	// 复训日期
					/*申报*/
					if(ar1[65]>0 || ar1[53]>0){
						arr.push("<td class='center'>" + imgChk1 + "</td>");	//申报/准考证
					}else{
						arr.push("<td class='center'>&nbsp;</td>");
					}
					if(ar1[64]>""){
						arr.push("<td class='center'>" + imgChk1 + "</td>");	//证书
					}else{
						arr.push("<td class='center'>&nbsp;</td>");
					}
					if(photo == 0){
						arr.push("<td class='left'><a href='javascript:showStudentExamPaper(" + ar1[0] + ",\"" + ar1[2] + "\");'>" + nullNoDisp(ar1[66].replace(".00","")) + "</a></td>");
						arr.push("<td class='center'>" + nullNoDisp(ar1[68]) + "</td>");
					}else{
						if(ar1[18] > ""){
							arr.push("<td class='center'><img id='photoB" + ar1[1] + "' src='users" + ar1[18] + "?times=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[18] + "\",\"" + ar1[1] + "\",\"photo\",\"B\",0,1)' style='width:50px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						}else{
							arr.push("<td class='center'>&nbsp;</td>");
						}
					}
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
			if(photo == 0){
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
			$("#searchEnterPick").html(0);
			$('input[type=checkbox][name=visitstockchkEnter]').change(function(){
				getSelCart("visitstockchkEnter");
				$("#searchEnterPick").html(selCount);
			});
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
		if(c == "C21" || c == "C20A"){
			c = "C20";
		}
		window.open("entryform_" + c + ".asp?keyID=0&nodeID=" + n + "&refID=" + f, "_blank");
	}

	function getStudentCourseLists(id){
		//do nothing, just callback for entryform return's event
	}
	