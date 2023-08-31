	var userListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		getComList("searchUserDeptID","dbo.[getHostDeptList]('" + currHost + "')","deptID","deptName","1=1",1);
		getDicList("userStatus","searchUserStatus",1);
		$("#btnAddUser").hide();
		if(checkPermission("userAdd")){
			$("#btnAddUser").show();
		}
		$("#btnAddUser").click(function(){
			showUserInfo(0,0,1,1);	//showUserInfo(nodeID,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		});
		
		$("#btnSearchUser").click(function(){
			getUserList();
		});
		
		//getUserList();
	});

	function getUserList(){
		sWhere = $("#txtSearchUser").val();
		var deptID = $("#searchUserDeptID").val();
		if(deptID == null){deptID=0;}
		//alert((sWhere) + "&status=" + $("#searchUserStatus").val() + "&deptID=" + deptID);
		$.get("userControl.asp?op=getUserList&where=" + escape(sWhere) + "&status=" + $("#searchUserStatus").val() + "&deptID=" + deptID + "&dk=20&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#userCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='userTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='10%'>用户名</th>");
			arr.push("<th width='12%'>姓名</th>");
			arr.push("<th width='15%'>部门</th>");
			arr.push("<th width='10%'>有效期</th>");
			arr.push("<th width='6%'>状态</th>");
			arr.push("<th width='10%'>电话</th>");
			arr.push("<th width='15%'>邮箱</th>");
			arr.push("<th width='10%'>注册日期</th>");
			arr.push("<th width='10%'>注册人</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade" + ar1[1] + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showUserInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
					arr.push("<td class='left'>" + ar1[12] + "</td>");
					arr.push("<td class='left'>" + ar1[14] + "</td>");
					arr.push("<td class='left'>" + ar1[16] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#userCover").html(arr.join(""));
			arr = [];
			$('#userTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100],
				"iDisplayLength": 100,
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

	function pickupUser(p){
		var ar = getSession("userList").split("|");
		var ar1 = p.split("|");
		if(ar>""){
			var i = 0;
			var n = ar1.length;
			$.each(ar,function(iNum,val){
				if(i==n){i = 0;}
				alert(i);
				if(val>""){
					parent.$("#" + val).val(ar1[i]);
				}
				i += 1;
			});
		}
		parent.$.close("userList");
	}