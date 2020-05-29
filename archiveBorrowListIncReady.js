	var archiveBorrowListLong = 0;		//0: 标准栏目  1：短栏目
	var archiveBorrowListChk = 0;

	$(document).ready(function (){
		getComList("searchArchiveBorrowKind","archiveKind","kindID","item","status=0",1);
		getDicList("borrowStatus","searchArchiveBorrowStatus",1);
		$("#searchArchiveBorrowStartDate").click(function(){WdatePicker();});
		$("#searchArchiveBorrowEndDate").click(function(){WdatePicker();});
		
		archiveBorrowListChk = checkPermission("borrowAdd",0);
		if(archiveBorrowListChk){
			$("#btnAddArchiveBorrow").show();
		}else{
			$("#btnAddArchiveBorrow").hide();
		}
		
		$("#btnAddArchiveBorrow").click(function(){
			showArchiveBorrowInfo(0,0,1,1);	//showArchiveBorrowInfo(nodeID,refID,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		});
		
		$("#btnSearchArchiveBorrow").click(function(){
			getArchiveBorrowList();
		});
		
		$("#searchArchiveBorrowKind").change(function(){
			getArchiveBorrowList();
		});
		
		$("#searchArchiveBorrowStatus").change(function(){
			getArchiveBorrowList();
		});
		
		$("#txtSearchArchiveBorrow").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchArchiveBorrow").val()>""){
					getArchiveBorrowList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		
		if(archiveBorrowListLong == 0){
			$("#archiveBorrowListLongItem1").show();
			//getArchiveBorrowList();
		}else{
			$("#archiveBorrowListLongItem1").hide();
			//getArchiveBorrowList();
		}
	});

	function getArchiveBorrowList(){
		sWhere = $("#txtSearchArchiveBorrow").val();
		//alert((sWhere) + $("#searchArchiveBorrowStatus").val() + "&kindID=" + $("#searchArchiveBorrowKind").val());
		$.get("archiveBorrowControl.asp?op=getArchiveBorrowList&where=" + escape(sWhere) + "&status=" + $("#searchArchiveBorrowStatus").val() + "&kindID=" + $("#searchArchiveBorrowKind").val() + "&fStart=" + $("#searchArchiveBorrowStartDate").val() + "&fEnd=" + $("#searchArchiveBorrowEndDate").val() + "&dk=31&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#archiveBorrowCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='archiveBorrowTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='4%'>No</th>");
			arr.push("<th width='10%'>借阅人</th>");
			arr.push("<th width='10%'>档案编号</th>");
			arr.push("<th width='30%'>档案标签</th>");
			arr.push("<th width='10%'>申请日期</th>");
			arr.push("<th width='10%'>借阅日期</th>");
			arr.push("<th width='10%'>归还期限</th>");
			arr.push("<th width='10%'>实际归还</th>");
			arr.push("<th width='6%'>状态</th>");
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
					if(ar1[3]==0){c = 1;}	//草稿 灰色
					if(ar1[3]==3){c = 2;}	//借出 红色
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td width='4%' class='center'>" + i + "</td>");
					arr.push("<td width='10%' class='link1'><a href='javascript:showArchiveBorrowInfo(" + ar1[0] + ",0,0,1);'>" + ar1[11] + "</a></td>");
					arr.push("<td width='10%' class='left'><a href='javascript:showArchiveInfo(" + ar1[22] + ",0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td width='30%' class='left'>" + ar1[2] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[19] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[7] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[8] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[12] + "</td>");
					arr.push("<td width='6%' class='left'>" + ar1[4] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#archiveBorrowCover").html(arr.join(""));
			arr = [];
			$('#archiveBorrowTab').dataTable({
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

	function showArchiveBorrowBindingArchiveList(key,id,no){
		archiveCartKeyID = key;
		archiveCartRefID = id;
		archiveCartRefNo = no;
		getArchiveBorrowArchiveList();
	}
	