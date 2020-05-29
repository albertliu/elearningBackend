	var docArchiveListLong = 0;		//0: 标准栏目  1：短栏目
	var ar_docArchiveList = getSession("ar_docArchiveList").split("|");
	var docArchiveListVal = "";
	var docArchiveListRefID = 0;
	var docArchiveListKindID = "";
	var docArchiveListChk = 0;

	$(document).ready(function (){
		getComList("searchDocArchiveEngineering","engineeringInfo","ID","item","status>0",1);
		getDicList("docArchiveKind","searchDocArchiveKind",1);
		
		docArchiveListRefID = ar_docArchiveList[0];		//project ID
		docArchiveListKindID = ar_docArchiveList[1];	//order archive...
		$("#searchDocArchiveKind").val(docArchiveListKindID);
		docArchiveListChk = checkPermission("CA",docArchiveListRefID);

		//$("#searchDocArchiveEngineering").attr("disabled",true);
		$("#searchDocArchiveProject").attr("disabled",true);
		$("#btnAddDocArchive").attr("disabled",true);
		if(docArchiveListChk){
			$("#btnAddDocArchive").attr("disabled",false);
		}

		$("#btnAddDocArchive").click(function(){
			//alert(refID);
			showDocArchiveInfo(0,docArchiveListRefID,docArchiveListKindID,1,1);	//showDocArchiveInfo(nodeID,refID,op,mark) refID:order ID; op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		});
		
		$("#btnSearchDocArchive").click(function(){
			getDocArchiveList();
		});
		
		$("input[name='searchDocArchiveStatus']").click(function(){
			//alert($("input[name='searchDocArchiveStatus']:checked").val());
			getDocArchiveList();
		});
		
		$("#searchDocArchiveEngineering").change(function(){
			getComList("searchDocArchiveProject","projectInfo","ID","item","engineeringID=" + $("#searchDocArchiveEngineering").val() + " and status>0",1);
		});
		
		if(docArchiveListLong == 0){
			$("#docArchiveListLongItem1").show();
		}else{
			$("#docArchiveListLongItem1").hide();
		}
		
		getDocArchiveList();
	});

	function getDocArchiveList(){
		sWhere = $("#txtSearchDocArchive").val();
		var st = $("input[name='searchDocArchiveStatus']:checked").val();
		//alert((sWhere) + "&kindID=" + $("#searchDocArchiveKind").val() + "&status=" + st + "&refID=" + docArchiveListRefID + "&engineeringID=" + $("#searchDocArchiveEngineering").val() + "&projectID=" + nullNoDisp($("#searchDocArchiveProject").val()));
		$.get("docArchiveControl.asp?op=getDocArchiveListByWhere&where=" + escape(sWhere) + "&kindID=" + $("#searchDocArchiveKind").val() + "&status=" + st + "&refID=" + docArchiveListRefID + "&engineeringID=" + $("#searchDocArchiveEngineering").val() + "&projectID=" + nullNoDisp($("#searchDocArchiveProject").val()) + "&dk=11&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#docArchiveCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='docArchiveTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='34%'>资料名称</th>");
			arr.push("<th width='30%'>说明</th>");
			arr.push("<th width='10%'>页数</th>");
			arr.push("<th width='12%'>提交日期</th>");
			arr.push("<th width='12%'>资料类型</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var tn = "docArchiveInfo";
				var tc = "left";
				var tc1 = "link1";
				if(docArchiveListChk){
					tc = "editable"; 
					//tc1 = "editable";
				}
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td width='2%' class='center'>" + i + "</td>");
					arr.push("<td width='34%' class='" + tc1 + "' align='left'><a href='javascript:showDocArchiveInfo(\"" + ar1[0] + "\"," + ar1[1] + ",\"" + ar1[4] + "\",0,1);'>" + ar1[7] + "</a></td>");
					arr.push("<td width='30%' class='" + tc + "' align='left' alt='" + tn + "|item|" + ar1[0] + "|1'>" + ar1[8] + "</td>");
					arr.push("<td width='10%' class='" + tc + "' align='center' alt='" + tn + "|page|" + ar1[0] + "|1'>" + ar1[9] + "</td>");
					arr.push("<td width='12%' class='" + tc + "' align='center' alt='" + tn + "|dateReceive|" + ar1[0] + "|1'>" + ar1[10] + "</td>");
					arr.push("<td width='12%' align='left'>" + ar1[5] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#docArchiveCover").html(arr.join(""));
			arr = [];
			$("#docArchiveTab").dataTable({
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
			<!--#include file="js/commTabEdit.js"-->
		});
	}
	
	function getValList(){
		var s = "";
		if(kindID=="order"){
			$.get("orderControl.asp?op=getNodeInfo&nodeID=" + refID + "&times=" + (new Date().getTime()),function(re){
				//jAlert(unescape(re));
				var ar = new Array();
				ar = unescape(re).split("|");
				if(ar > ""){
					s = ar[43];
				}
			});
		}
		return s;
	}
	