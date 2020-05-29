	var checkListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		getDicList("checkStatus","searchCheckStatus",1);
		getDicList("checkKind","searchCheckKind",1);
		$("#searchCheckStart").click(function(){WdatePicker();});
		$("#searchCheckEnd").click(function(){WdatePicker();});
		$("#searchCheckStatus").val(1)
		
		$("#btnSearchCheck").click(function(){
			getCheckList();
		});
		
		$("#searchCheckKind").change(function(){
			getCheckList();
		});
		
		$("#searchCheckStatus").change(function(){
			getCheckList();
		});
		
		$("input[name='searchCheckMy']").click(function(){
			getCheckList();
		});
		
		if(checkListLong == 0){
			$("#checkListLongItem1").show();
		}else{
			$("#checkListLongItem1").hide();
		}
		
		getCheckList();
	});

	function getCheckList(){
		sWhere = $("#txtSearchCheck").val();
		var kind = $("#searchCheckKind").val();
		var st = $("#searchCheckStatus").val();
		var my = $("input[name='searchCheckMy']:checked").val();
		//alert((sWhere) + "&kindID=" + kind + "&status=" + st + "&keyID=" +my + "&fStart=" + $("#searchCheckStart").val() + "&fEnd=" + $("#searchCheckEnd").val());
		$.get("checkControl.asp?op=getCheckList&where=" + escape(sWhere) + "&kindID=" + kind + "&status=" + st + "&keyID=" +my + "&fStart=" + $("#searchCheckStart").val() + "&fEnd=" + $("#searchCheckEnd").val() + "&dk=13&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#checkCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='checkTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='22%'>标题</th>");
			arr.push("<th width='8%'>节点</th>");
			arr.push("<th width='12%'>申请日期</th>");
			arr.push("<th width='12%'>批复日期</th>");
			arr.push("<th width='12%'>类型</th>");
			arr.push("<th width='8%'>状态</th>");
			if(checkListLong == 0){
				arr.push("<th width='8%'>周期</th>");
				arr.push("<th width='10%'>登记人</th>");
			}
			if(checkListLong == 1){
				arr.push("<th width='8%'>选择</th>");
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
					if(ar1[2]==2){c = 0;}	//已批复显示为绿色
					if(ar1[2]==0){c = 3;}	//待批复显示为黄色
					if(ar1[2]>2){c = 3;}	//未通过显示为红色
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td width='2%' class='center'>" + i + "</td>");
					arr.push("<td width='22%' class='link1'><a href='javascript:showCheckInfo(\"" + ar1[0] + "\",0,0,0,0,3);'>" + ar1[1] + "</a></td>");
					arr.push("<td width='8%' class='left'>" + ar1[10] + "</td>");
					arr.push("<td width='12%' class='left'>" + ar1[11] + "</td>");
					arr.push("<td width='12%' class='left'>" + ar1[12] + "</td>");
					arr.push("<td width='12%' class='left'>" + ar1[5] + "</td>");
					arr.push("<td width='8%' class='left'>" + ar1[3] + "</td>");
					if(checkListLong == 0){
						if(parseInt(ar1[18])>parseInt(ar1[17])){		//超期显示红色
							arr.push("<td width='8%' class='right'>" + ar1[17] + " / <font color='red'>" + ar1[18] + "</font></td>");
						}else{
							arr.push("<td width='8%' class='right'>" + ar1[17] + " / " + ar1[18] + "</td>");
						}
						arr.push("<td width='10%' class='left'>" + ar1[16] + "</td>");
					}
					if(checkListLong == 1){
						arr.push("<td width='8%' class='link1'>" + "<a href='javascript: pickupCheck(" + ar1[0] + ",\"" + ar1[1] + "\");'><img src='images/hand.png' border='0'></a></td>");
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
			if(checkListLong == 0){
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
			}
			if(checkListLong == 1){
				arr.push("<th>&nbsp;</th>");
			}
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#checkCover").html(arr.join(""));
			arr = [];
			$('#checkTab').dataTable({
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

	function pickupCheck(id,name){
		var keyID = "<%=keyID%>";
		var refID = "<%=refID%>";
		pickupID = id;
		pickupName = name;
		$("#txtSearchCheck").val(name);
		//parent.asyncbox.close("checkList");
		if(keyID>""){
			parent.$("#" + keyID).val(id);
		}
		if(refID>""){
			parent.$("#" + refID).val(name);
		}
		parent.$.close("checkList");
	}
	
	