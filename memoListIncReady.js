	var memoListLong = 0;		//0: 标准栏目  1：短栏目
	var ar_memoList = getSession("ar_memoList").split("|");	// unit/user ID
	var memoListRefID = 0;
	var memoListKindID = "";
	var memoListChk = 0;
	var searchMemoUnit = 0;
	var searchMemoUser = "";

	$(document).ready(function (){
		//getComList("searchMemoUnit","unitInfo","unitID","unitName","status=0",1);
		//setComUserList("searchMemoUser",0,0,0,1);
		//getComList("searchMemoUser","users","userName","realName","status=0",1);
		getDicList("private","searchMemoPrivate",1);
		//$("#searchMemoUnit").attr("disabled",true);
		//$("#searchMemoUser").val(currUser);
		$("#searchMemoStart").click(function(){WdatePicker();});
		$("#searchMemoEnd").click(function(){WdatePicker();});

		if(ar_memoList>""){
			memoListRefID = ar_memoList[0];		//unitID/userName
			memoListKindID = ar_memoList[1];		//unit/user
			memoListLong = ar_memoList[2];		//
			if(memoListKindID == "unit"){
				searchMemoUnit = memoListRefID;
				$("input[name=searchMemoKind][value=1]").attr("checked",true);
			} 
			if(memoListKindID == "user"){
				searchMemoUser = memoListRefID;
				$("input[name=searchMemoKind][value=0]").attr("checked",true);
			} 
		}

		$("#btnAddMemo").click(function(){
			showMemoInfo(0,searchMemoUnit,1,1);	//showMemoInfo(nodeID,ref,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		});
		
		$("#btnSearchMemo").click(function(){
			getMemoList();
		});
		/*
		$("#searchMemoPrivate").change(function(){
			if($("#searchMemoPrivate").val()==0){
				$("#searchMemoUser").val(currUser);
			}
			getMemoList();
		});
		*/
		$("#searchMemoUser").change(function(){
			if($("#searchMemoUser").val()!=currUser){
				$("#searchMemoPrivate").val(1);
			}
			getMemoList();
		});
		
		$("input[name='searchMemoKind']").click(function(){
			//alert($("input[name='searchMemoKind']:checked").val());
			getMemoList();
			var kind = $("input[name='searchMemoKind']:checked").val();
			if(kind==1){
				$("#searchMemoUnit").attr("disabled",false);
				$("#searchMemoUnit").focus();
			}else{
				$("#searchMemoUnit").attr("disabled",true);
				$("#searchMemoUnit").val("");
			}
		});
		
		$("input[name='searchMemoStatus']").click(function(){
			//alert($("input[name='searchMemoStatus']:checked").val());
			getMemoList();
		});
		
		if(memoListLong == 0){
			$("#memoListLongItem1").show();
		}else{
			$("#memoListLongItem1").hide();
			$("#searchMemoPrivate").val(1);		//公开
		}
		
		getMemoList();
	});

	function getMemoList(){
		//$.get("newsControl.asp?op=getCalenderData",function(re){
		//	jAlert(re);
		//});
		sWhere = $("#txtSearchMemo").val();
		var kind = $("input[name='searchMemoKind']:checked").val();
		var st = $("input[name='searchMemoStatus']:checked").val();
		//alert((sWhere) + "&kindID=" + kind + "&status=" + st + "&unitID=" +$("#searchMemoUnit").val() + "&userID=" + $("#searchMemoUser").val() + "&private=" + $("#searchMemoPrivate").val() + "&fStart=" + $("#searchMemoStart").val() + "&fEnd=" + $("#searchMemoEnd").val());
		$.get("memoControl.asp?op=getMemoList&where=" + escape(sWhere) + "&kindID=" + kind + "&status=" + st + "&unitID=" + searchMemoUnit + "&userID=" + searchMemoUser + "&private=" + $("#searchMemoPrivate").val() + "&fStart=" + $("#searchMemoStart").val() + "&fEnd=" + $("#searchMemoEnd").val() + "&dk=10&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#memoCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='memoTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='20%'>标题</th>");
			arr.push("<th width='12%'>标记日期</th>");
			arr.push("<th width='7%'>范围</th>");
			arr.push("<th width='7%'>类型</th>");
			arr.push("<th width='7%'>状态</th>");
			if(memoListLong == 0){
				arr.push("<th width='8%'>登记人</th>");
				arr.push("<th width='10%'>登记日期</th>");
			}
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade" + ar1[2] + "'>");
					arr.push("<td width='2%' class='center'>" + i + "</td>");
					arr.push("<td width='20%' class='link1'><a href='javascript:showMemoInfo(\"" + ar1[0] + "\"," + searchMemoUnit + ",0,1,\"\");'>" + ar1[1] + "</a></td>");
					arr.push("<td width='12%' class='left'>" + ar1[4] + "</td>");
					arr.push("<td width='7%' class='left'>" + ar1[16] + "</td>");
					arr.push("<td width='7%' class='left'>" + ar1[7] + "</td>");
					arr.push("<td width='7%' class='left'>" + ar1[3] + "</td>");
					if(memoListLong == 0){
						arr.push("<td width='8%' class='left'>" + ar1[13] + "</td>");
						arr.push("<td width='10%' class='left'>" + ar1[11] + "</td>");
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
			if(memoListLong == 0){
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
			}
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#memoCover").html(arr.join(""));
			arr = [];
			$('#memoTab').dataTable({
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
	
	