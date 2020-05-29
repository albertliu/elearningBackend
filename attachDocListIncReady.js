	var attachDocListLong = 0;		//0: 标准栏目  1：短栏目
	var ar_attachDocList = getSession("ar_attachDocList").split("|");
	var attachDocListVal = "";
	var attachDocListRefID = 0;
	var attachDocListKindID = "";
	var attachDocListChk = 0;
	var unitID = 0;
	var updateCount = 0;
	var cStreet = 0;

	$(document).ready(function (){
		attachDocListRefID = ar_attachDocList[0];		//order/unit ID
		attachDocListKindID = ar_attachDocList[1];	//order/unit
		$("#searchAttachDocKind").val(attachDocListKindID);
		if(attachDocListKindID=="unit"){
			unitID = attachDocListRefID;
		}
		if(attachDocListKindID=="order"){
			unitID = getUnitIDByOrder(attachDocListRefID);
		}
		cStreet = getStreetIDbyUnit(unitID);
		attachDocListChk = checkPermission("orderCheck1",cStreet) + checkPermission("orderCheck2",0);

		$("#btnAddAttachDoc").attr("disabled",true);
		if(attachDocListChk){
			$("#btnAddAttachDoc").attr("disabled",false);
		}

		$("#btnAddAttachDoc").click(function(){
			//alert(refID);
			showAttachDocInfo(0,attachDocListRefID,attachDocListKindID,1,1);	//showAttachDocInfo(nodeID,refID,op,mark) refID:order ID; op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		});
		
		$("#btnSearchAttachDoc").click(function(){
			getAttachDocList();
		});
		
		$("input[name='searchAttachDocStatus']").click(function(){
			//alert($("input[name='searchAttachDocStatus']:checked").val());
			getAttachDocList();
		});
		
		if(attachDocListLong == 0){
			$("#attachDocListLongItem1").show();
		}else{
			$("#attachDocListLongItem1").hide();
		}
		
		getAttachDocList();
	});

	function getAttachDocList(){
		sWhere = $("#txtSearchAttachDoc").val();
		var st = $("input[name='searchAttachDocStatus']:checked").val();
		//alert((sWhere) + "&kindID=" + attachDocListKindID + "&status=" + st + "&refID=" + attachDocListRefID);
		$.get("attachDocControl.asp?op=getAttachDocList&where=" + escape(sWhere) + "&kindID=" + attachDocListKindID + "&status=" + st + "&refID=" + attachDocListRefID + "&dk=11&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#attachDocCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='attachDocTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='35%'>资料名称</th>");
			arr.push("<th width='10%'>纸质</th>");
			arr.push("<th width='14%'>确认</th>");
			arr.push("<th width='10%'>扫描</th>");
			arr.push("<th width='15%'>附件</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var t1 = "";
				var t2 = "";
				var t3 = "";
				var t4 = "";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					t1 = "";
					t2 = "";
					t3 = "";
					t4 = "disabled /";
					arr.push("<tr class='grade0'>");
					arr.push("<td width='2%' class='center'>" + i + "</td>");
					if(attachDocListChk){
						arr.push("<td width='35%' class='link1' align='left'><a href='javascript:showAttachDocInfo(" + ar1[0] + ",0,\"\",0,1);'>" + ar1[6] + "</a></td>");
					}else{
						arr.push("<td width='35%' class='link1' align='left'>" + ar1[6] + "</td>");
					}
					if(ar1[7]==1){		//需要纸质材料
						arr.push("<td width='10%' class='center'><img src='images/dot.png' border='0' width='16' /></td>");
					}else{
						arr.push("<td width='10%' class='center'>&nbsp;</td>");
					}
					if(ar1[7]==1 && ar1[11]==""){		//缺纸质材料
						t1 = "style='background:#EED2EE;'";
					}else{
						t1 = "";
					}
					if(ar1[11]>""){	
						t2 = " checked";
					}else{
						t2 = "";
					}
					if(attachDocListChk){
						t4 = "";
					}
					arr.push("<td width='14%' class='left' id='i_td" + ar1[0] + "' " + t1 + "><input style='border:0px;' type='checkbox' id='i_chk" + ar1[0] + "'" + t2 + " onclick='setConfirm(" + ar1[0] + ")' " + t4 + "></td>");
					if(ar1[9]==1){		//需要电子材料
						arr.push("<td width='10%' class='center'><img src='images/dot.png' border='0' width='16' /></td>");
					}else{
						arr.push("<td width='10%' class='center'>&nbsp;</td>");
					}
					t3 = putAppendix(ar1[18]);
					if(ar1[9]==1 && t3==""){		//缺电子材料
						t1 = "style='background:#EED2EE;'";
					}else{
						t1 = "";
					}
					arr.push("<td width='15%' class='left' " + t1 + ">" + t3 + "</td>");
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
			$("#attachDocCover").html(arr.join(""));
			arr = [];
			$("#attachDocTab").dataTable({
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
	
	function setConfirm(id){
		var k = 0;
		if($("#i_chk" + id).attr("checked")){
			k = 1;
			$("#i_td" + id).css("background-color","");
		}else{
			k = 0;
			$("#i_td" + id).css("background","#EED2EE");
		}
		$.get("attachDocControl.asp?op=setPaperConfirm&nodeID=" + id + "&keyID=" + k + "&times=" + (new Date().getTime()),function(re){
			updateCount += 1;
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
	