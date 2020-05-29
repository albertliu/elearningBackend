	var unitListLong = 0;		//0: 标准栏目  1：短栏目
	var kindID = 0;

	$(document).ready(function (){
		kindID = "<%=kindID%>";

		getComList("searchUnitPark","parkInfo","parkID","parkName","status=0",1);
		getComList("searchUnitStreet","streetInfo","streetNo","streetName","status=0 order by streetNo",1);
		getDicList("unitKind","searchUnitKind",1);
		getDicList("unitType","searchUnitType",1);
		getDicList("yesno","searchUnitRestruction",1);
		getDicList("yesno","searchUnitHelpOpen",1);
		
		$("#btnAddUnit").click(function(){
			showUnitInfo(0,1,1);	//showUnitInfo(nodeID,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		});
		
		$("#btnSearchUnit").click(function(){
			getUnitList();
		});
		
		$("#searchUnitKind").change(function(){
			getUnitList();
		});
		$("#searchUnitStreet").change(function(){
			getUnitList();
		});
		$("#searchUnitPark").change(function(){
			getUnitList();
		});
		$("#searchUnitPark").change(function(){
			searchUnitType();
		});
		$("#searchUnitPark").change(function(){
			searchUnitRestruction();
		});
		$("#searchUnitPark").change(function(){
			searchUnitHelpOpen();
		});
		
		$("input[name='searchUnitStatus']").click(function(){
			//alert($("input[name='searchUnitStatus']:checked").val());
			getUnitList();
		});
		
		if(unitListLong == 0){
			$("#unitListLongItem1").show();
		}else{
			$("#unitListLongItem1").hide();
			getUnitList();
		}
		
	});

	function getUnitList(){
		sWhere = $("#txtSearchUnit").val();
		var kind = $("#searchUnitKind").val();
		var st = $("input[name='searchUnitStatus']:checked").val();
		//alert((sWhere) + "&kindID=" + kind + "&status=" + st + "&street=" + $("#searchUnitStreet").val() + "&park=" + $("#searchUnitPark").val());
		$.get("unitControl.asp?op=getUnitList&where=" + escape(sWhere) + "&kindID=" + kind + "&keyID=" + $("#searchUnitType").val() + "&helpOpen=" + $("#searchUnitHelpOpen").val() + "&restruction=" + $("#searchUnitRestruction").val() + "&status=" + st + "&street=" + $("#searchUnitStreet").val() + "&park=" + $("#searchUnitPark").val() + "&dk=2&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#unitCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='unitTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='24%'>单位名称</th>");
			if(unitListLong == 0){
				arr.push("<th width='12%'>组织机构</th>");
				arr.push("<th width='10%'>负责人</th>");
				arr.push("<th width='12%'>开业日期</th>");
				arr.push("<th width='12%'>性质</th>");
			}
			arr.push("<th width='18%'>园区</th>");
			arr.push("<th width='10%'>街道</th>");
			if(unitListLong == 1){
				arr.push("<th width='8%'>选择</th>");
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
					arr.push("<tr class='grade" + ar1[3] + "'>");
					arr.push("<td width='2%' class='center'>" + i + "</td>");
					arr.push("<td width='24%' class='link1'><a href='javascript:showUnitInfo(\"" + ar1[0] + "\",0,1);'>" + ar1[1] + "</a></td>");
					if(unitListLong == 0){
						arr.push("<td width='12%' class='left'>" + ar1[4] + "</td>");
						arr.push("<td width='10%' class='left'><a href='javascript:showBossInfo(\"" + ar1[24] + "\",0,1);'>" + ar1[25] + "</a></td>");
						arr.push("<td width='12%' class='left'>" + ar1[23] + "</td>");
						arr.push("<td width='12%' class='left'>" + ar1[7] + "</td>");
					}
					arr.push("<td width='18%' class='left'>" + ar1[9] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[11] + "</td>");
					if(unitListLong == 1){
						arr.push("<td width='8%' class='link1'>" + "<a href='javascript: pickupUnit(" + ar1[0] + ",\"" + ar1[1] + "\");'><img src='images/hand.png' border='0'></a></td>");
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
			if(unitListLong == 0){
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
			}
			if(unitListLong == 1){
				arr.push("<th>&nbsp;</th>");
			}
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#unitCover").html(arr.join(""));
			arr = [];
			$('#unitTab').dataTable({
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

	function pickupUnit(id,name){
		var keyID = "<%=keyID%>";
		var refID = "<%=refID%>";
		pickupID = id;
		pickupName = name;
		$("#txtSearchUnit").val(name);
		//parent.asyncbox.close("unitList");
		if(keyID>""){
			parent.$("#" + keyID).val(id);
		}
		if(refID>""){
			parent.$("#" + refID).val(name);
		}
		parent.$.close("unitList");
	}