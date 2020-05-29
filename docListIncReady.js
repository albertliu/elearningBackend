	var docListLong = 0;		//0: 标准栏目  1：短栏目
	var kindID = 0;

	$(document).ready(function (){
		kindID = "<%=kindID%>";
		$("#searchDocKind" + kindID).attr("checked",true);
		
		$("#searchDocStartDate").click(function(){WdatePicker();});
		$("#searchDocEndDate").click(function(){WdatePicker();});
		
		$("#btnAddDoc").click(function(){
			showDocInfo(0,$("input[name='searchDocKind']:checked").val(),1,1);	//showDocInfo(nodeID,kindID,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		});
		
		$("#btnSearchDoc").click(function(){
			getDocList();
		});
		
		$("input[name='searchDocKind']").click(function(){
			//alert($("input[name='searchDocKind']:checked").val());
			getDocList();
		});
		
		$("input[name='searchDocStatus']").click(function(){
			//alert($("input[name='searchDocStatus']:checked").val());
			getDocList();
		});
		
		if(docListLong == 0){
			$("#docListLongItem1").show();
		}else{
			$("#docListLongItem1").hide();
		}
		
		getDocList();
	});

	function getDocList(){
		sWhere = $("#txtSearchDoc").val();
		var kind = $("input[name='searchDocKind']:checked").val();
		var st = $("input[name='searchDocStatus']:checked").val();
		//alert((sWhere) + "&kindID=" + kind + "&status=" + st + "&fStart=" + $("#searchDocStartDate").val() + "&fEnd=" + $("#searchDocEndDate").val());
		$.get("docControl.asp?op=getDocListByWhere&where=" + escape(sWhere) + "&kindID=" + kind + "&status=" + st + "&fStart=" + $("#searchDocStartDate").val() + "&fEnd=" + $("#searchDocEndDate").val() + "&dk=12&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#docCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='docTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='43%'>标题</th>");
			arr.push("<th width='8%'>状态</th>");
			arr.push("<th width='12%'>发布日期</th>");
			arr.push("<th width='10%'>发布人</th>");
			arr.push("<th width='10%'>访问</th>");
			arr.push("<th width='15%'>附件</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var gi = "";
				var p = "";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					gi = "";
					p = ar1[13];
					if(ar1[4]==1){p += "/" + ar1[12];}		//通知显示总人数及回执数，其他只显示回执。
					if(ar1[11]==0){gi = "<img src='images/new.gif' border='0'>&nbsp;&nbsp;";}
					arr.push("<tr class='grade" + ar1[3] + "'>");
					arr.push("<td width='2%' class='center'>" + i + "</td>");
					arr.push("<td width='43%' class='link1'><span id='newdoc" + ar1[0] + "'>" + gi + "</span><a href='javascript:showDocInfo(\"" + ar1[0] + "\"," + ar1[4] + ",0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td width='8%' class='left'>" + ar1[3] + "</td>");
					arr.push("<td width='12%' class='left'>" + ar1[7] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[9] + "</td>");
					arr.push("<td width='10%' class='left'>" + p + "</td>");
					arr.push("<td width='15%' class='center'>" + putAppendix(ar1[10]) + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#docCover").html(arr.join(""));
			arr = [];
			$('#docTab').dataTable({
				"aaSorting": [],
				"bFilter": false,
				"bPaginate": false,
				"bLengthChange": false,
				"bInfo": false,
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
