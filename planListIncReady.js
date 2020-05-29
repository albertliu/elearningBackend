	var planListLong = 0;		//0: 标准栏目  1：短栏目
	var ar_planList = getSession("ar_planList").split("|");	//refID | 0 normal  1 engineering  2 project
	var planListRefID = 0;
	var planListKindID = "";
	var planListChk = 0;
	var planListVal = "";

	$(document).ready(function (){
		getComList("searchPlanEngineering","engineeringInfo","ID","item","status>0",1);
		setComUserList("searchPlanUser",0,0,0,0);
		getDicList("private","searchPlanPrivate",1);
		$("#txtSearchPlanWeek").val(getPlanLastWeek(currUser));
		$("#searchPlanUser").val(currUser);

		$("#searchPlanEngineering").attr("disabled",true);
		$("#searchPlanProject").attr("disabled",true);

		planListRefID = ar_planList[0];		//ref ID
		planListKindID = ar_planList[1];	//0 normal  1 engineering  2 project
		
		if(planListRefID>"0" && planListKindID==2){
			$("#searchPlanKind2").attr("checked",true);
			getProjectInfo(planListRefID);
			//planListChk = checkPermission("CA",planListRefID);
		}

		$("#btnAddPlan").click(function(){
			showPlanInfo(0,1,1);	//showPlanInfo(nodeID,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		});
		
		$("#btnSearchPlan").click(function(){
			getPlanList();
		});
		
		$("#searchPlanPrivate").change(function(){
			if($("#searchPlanPrivate").val()==0){
				$("#searchPlanUser").val(currUser);
			}
			getPlanList();
		});
		
		$("#searchPlanUser").change(function(){
			if($("#searchPlanUser").val()!=currUser){
				$("#searchPlanPrivate").val(1);
			}
			getPlanList();
		});
		
		$("input[name='searchPlanKind']").click(function(){
			//alert($("input[name='searchPlanKind']:checked").val());
			getPlanList();
			var kind = $("input[name='searchPlanKind']:checked").val();
			if(kind==0 || kind==99){
				$("#searchPlanEngineering").attr("disabled",true);
				$("#searchPlanProject").attr("disabled",true);
				$("#searchPlanEngineering").val("");
				$("#searchPlanProject").val("");
			}
			if(kind==1){
				$("#searchPlanEngineering").attr("disabled",false);
				$("#searchPlanProject").attr("disabled",true);
				$("#searchPlanProject").val("");
				$("#searchPlanEngineering").focus();
			}
			if(kind==2){
				$("#searchPlanEngineering").attr("disabled",false);
				$("#searchPlanProject").attr("disabled",false);
				$("#searchPlanEngineering").change();
				$("#searchPlanEngineering").focus();
			}
		});
		
		$("input[name='searchPlanStatus']").click(function(){
			//alert($("input[name='searchPlanStatus']:checked").val());
			getPlanList();
		});
		
		$("#searchPlanEngineering").change(function(){
			var kind = $("input[name='searchPlanKind']:checked").val();
			//alert(kind + ":" + $("#searchPlanEngineering").val());
			if((kind==2) && $("#searchPlanEngineering").val()>0){
				getComList("searchPlanProject","projectInfo","ID","item","engineeringID=" + $("#searchPlanEngineering").val() + " and status>0",1);
			}else{
				$("#searchPlanProject").val("");
			}
		});
		
		if(planListLong == 0){
			$("#planListLongItem1").show();
		}else{
			$("#planListLongItem1").hide();
		}
		
		getPlanList();
	});

	function getPlanList(){
		sWhere = $("#txtSearchPlan").val();
		var kind = $("input[name='searchPlanKind']:checked").val();
		var st = $("input[name='searchPlanStatus']:checked").val();
		if(kind==1){ref = $("#searchPlanEngineering").val();}
		if(kind==2){ref = $("#searchPlanProject").val();}
		//alert((sWhere) + "&kindID=" + kind + "&refID=" + ref + "&status=" + st);
		$.get("planControl.asp?op=getPlanListByWhere&where=" + escape(sWhere) + "&kindID=" + kind + "&status=" + st + "&engineeringID=" +$("#searchPlanEngineering").val() + "&projectID=" + $("#searchPlanProject").val() + "&userID=" + escape($("#searchPlanUser").val()) + "&week=" + escape($("#txtSearchPlanWeek").val()) + "&private=" + $("#searchPlanPrivate").val() + "&dk=11&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#planCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='planTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='14%'>标题</th>");
			arr.push("<th width='9%'>计划周</th>");
			arr.push("<th width='11%'>开始日期</th>");
			arr.push("<th width='11%'>结束日期</th>");
			arr.push("<th width='11%'>实际完成</th>");
			arr.push("<th width='7%'>类型</th>");
			arr.push("<th width='7%'>状态</th>");
			if(planListLong == 0){
				arr.push("<th width='10%'>登记人</th>");
			}
			if(planListLong == 1){
				arr.push("<th width='10%'>登记人</th>");
				//arr.push("<th width='7%'>选择</th>");
			}
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
					if(ar1[2]>1){c = 1;}
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td width='2%' class='center'>" + i + "</td>");
					arr.push("<td width='14%' class='link1'><a href='javascript:showPlanInfo(\"" + ar1[0] + "\",0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td width='9%' class='left'>" + ar1[20] + "</td>");
					arr.push("<td width='11%' class='left'>" + ar1[6] + "</td>");
					if((ar1[8]=="" && ar1[7]<currDate) || ar1[8]>ar1[7]){
						arr.push("<td width='11%' class='left' title='超期'><font color='red'>" + ar1[7] + "</font></td>");	//超期
					}else{
						arr.push("<td width='11%' class='left'>" + ar1[7] + "</td>");
					}
					arr.push("<td width='11%' class='left'>" + ar1[8] + "</td>");
					arr.push("<td width='7%' class='left'>" + ar1[10] + "</td>");
					arr.push("<td width='7%' class='left'>" + ar1[3] + "</td>");
					if(planListLong == 0){
						arr.push("<td width='10%' class='left'>" + ar1[19] + "</td>");
					}
					if(planListLong == 1){
						arr.push("<td width='10%' class='left'>" + ar1[19] + "</td>");
						//arr.push("<td width='7%' class='link1'>" + "<a href='javascript: pickupPlan(" + ar1[0] + ",\"" + ar1[1] + "\");'><img src='images/hand.png' border='0'></a></td>");
					}
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
			if(planListLong == 0){
				arr.push("<th>&nbsp;</th>");
			}
			if(planListLong == 1){
				arr.push("<th>&nbsp;</th>");
			}
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#planCover").html(arr.join(""));
			arr = [];
			$('#planTab').dataTable({
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

	function getProjectInfo(id){
		//alert(id);
		$.get("projectControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#searchPlanEngineering").attr("disabled",false);
				$("#searchPlanEngineering").val(ar[20]);
				getComList("searchPlanProject","projectInfo","ID","item","engineeringID=" + ar[20] + " and status>0",1);
				//$("#engineeringName").val(ar[21]);
				$("#searchPlanProject").attr("disabled",false);
				$("#searchPlanProject").val(ar[0]);
				//$("#projectName").val(ar[1]);
			}
		});
	}

	