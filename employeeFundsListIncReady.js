	var nodeID = "";
	var refID = "";
	var fStart = "";
	var fEnd = "";
	var chk = 0;
	var cOrder = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//orderID
		refID = "<%=refID%>";			//unitID
		fStart = "<%=fStart%>";
		fEnd = "<%=fEnd%>";
		
		$("#searchEmployeeFundsStartDate").click(function(){WdatePicker();});
		$("#searchEmployeeFundsEndDate").click(function(){WdatePicker();});
		
		if(nodeID>0){
			getOrderInfo(nodeID);
		}
		
		$("#btnAddEmployeeFund").hide();
		if(checkPermission("orderCheck2",0)){
				$("#btnAddEmployeeFund").show();
		}

		if(refID==0 && nodeID>0){
			refID = getUnitIDByOrder(nodeID);
		}
		if(refID>0){
			$("#unitID").val(refID);
			$("#unitName").html(getUnitNameByCode(refID));
		}

		if(nodeID==0){
			var lastY = parseInt(currDate.substring(0,4)) - 1;
			$("#searchEmployeeFundsStartDate").css("background-color","yellow");
			$("#searchEmployeeFundsEndDate").css("background-color","yellow");
			if(fStart==""){
				$("#searchEmployeeFundsStartDate").val(lastY + "-01-01");
			}
			if(fEnd==""){
				$("#searchEmployeeFundsEndDate").val(lastY + "-12-31");
			}
		}else{
			$("#orderItem").html(getOrderItemByID(nodeID));
			getOrderInfo(nodeID);
			$("#searchEmployeeFundsStartDate").attr("readOnly",true);
			$("#searchEmployeeFundsStartDate").attr("class","readOnly");
			$("#searchEmployeeFundsEndDate").attr("readOnly",true);
			$("#searchEmployeeFundsEndDate").attr("class","readOnly");
		}
		
		$("#btnAddEmployeeFund").click(function(){
			showEmployeeFundsInfo("",nodeID,refID,"",1,1);	//showEmployeeFundsInfo(nodeID,refID,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		});
		
		$("#btnSearchEmployeeFund").click(function(){
			getEmployeeFundsList();
		});

		getEmployeeFundsList();
	});

	function getEmployeeFundsList(){
		fStart = $("#searchEmployeeFundsStartDate").val();
		fEnd = $("#searchEmployeeFundsEndDate").val();
		//alert("3.nodeID=" + nodeID + "&refID=" + refID + "&fStart=" + fStart + "&fEnd=" + fEnd);
		$.get("employeeFundsControl.asp?op=getEmployeeFundsList&nodeID=" + nodeID + "&refID=" + refID + "&fStart=" + fStart + "&fEnd=" + fEnd + "&dk=10&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#employeeFundsCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatSum = "";
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='employeeFundsTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th style='width:10px'>No</th>");
			if(nodeID>0 && (cOrder==3 || cOrder==4 || cOrder==5)){
				arr.push("<th style='width:10px'>选</th>");
			}
			arr.push("<th style='width:30px'>姓名</th>");
			arr.push("<th style='width:100px'>身份证号</th>");
			var arh = new Array();
			arh = ar0[4].split("$")
			var m = arh.length;
			var p = 0;
			var t = "";
			if(m>0){
				//p = parseInt(800/m)/10;
				$.each(arh,function(iNum,val){
					//arr.push("<th width='" + p + "%'>" + val + "</th>");
					if(t == val.substring(0,4)){
						arr.push("<th>" + val.substring(4,6) + "</th>");
					}else{
						arr.push("<th>" + val + "</th>");
						t = arh[iNum].substring(0,4);
					}
				});
			}else{
				arr.push("<th>社保缴费无记录</th>");
			}
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var t2 = "";
				var t3 = "";
				var c = 0;
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					if(ar1[1]=="1"){	
						c = 0;
					}else{
						c = 1;
					}
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td style='width:10px' class='center'>" + i + "</td>");
					if(nodeID>0 && (cOrder==3 || cOrder==4 || cOrder==5)){		//房补及社保费补贴需要员工缴金明细
						t2 = "";
						t3 = "disabled";
						if(ar1[1]=="1"){	
							t2 = " checked /";
						}
						if(checkPermission("orderCheck2",0)){
								t3 = "";
						}
						arr.push("<td style='width:10px' class='center'><input style='border:0px;' type='checkbox' id='i_chk" + ar1[3] + "'" + t2 + " onclick='setConfirm(\"" + ar1[3] + "\")' " + t3 + "></td>");
					}
					arr.push("<td style='width:30px' class='link1'><a href='javascript:showEmployeeFundsInfo(\"" + ar1[3] + "\"," + nodeID + "," + refID + ",\"\",1,1);'>" + ar1[2] + "</a></td>");
					arr.push("<td style='width:100px' class='left'>" + ar1[3] + "</td>");
					if(m>0){
						var ar2 = new Array();
						ar2 = ar1[4].split("$");
						$.each(ar2,function(iNum,val){
							//arr.push("<td width='" + p + "%' class='center'>" + val + "</td>");
							arr.push("<td class='center'><a href='javascript:showEmployeeFundsInfo(\"" + ar1[3] + "\"," + nodeID + "," + refID + ",\"" + arh[iNum] + "\",0,1);'>" + val + "</a></td>");
						});
					}else{
						arr.push("<td>&nbsp;</td>");
					}
					arr.push("</tr>");
				});
			}
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
			arr.push("<th>&nbsp;</th>");
			if(nodeID>0 && (cOrder==3 || cOrder==4 || cOrder==5)){
				arr.push("<th>&nbsp;</th>");
			}
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			if(m>0){
				$.each(arh,function(iNum,val){
					arr.push("<th>&nbsp;</th>");
				});
			}else{
				arr.push("<th>&nbsp;</th>");
			}
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#employeeFundsCover").html(arr.join(""));
			arr = [];
			$('#employeeFundsTab').dataTable({
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
	
	function setConfirm(id){
		var k = 0;
		var s = "";
		if($("#i_chk" + id).attr("checked")){
			k = 1;
			s = "你确定要将该员工加入申请名册吗？";
			//$("#i_tr" + id).css("background-color","");
		}else{
			k = 0;
			s = "你确定要将该员工从申请名册中撤销吗？";
			//$("#i_tr" + id).css("background","#EED2EE");
		}
		jConfirm(s, '确认对话框', function(r) {
			if(r){
				//alert(nodeID + "&refID=" + id + "&keyID=" + k);
				$.get("employeeFundsControl.asp?op=setOrderEmployeeConfirm&nodeID=" + nodeID + "&refID=" + id + "&keyID=" + k + "&times=" + (new Date().getTime()),function(re){
					//jAlert(re);
					getEmployeeFundsList();
					updateCount += 1;
				});
			}else{
				if($("#i_chk" + id).attr("checked")){
					$("#i_chk" + id).attr("checked",false);
				}else{
					$("#i_chk" + id).attr("checked",true);
				}
			}
		});
	}

	function getOrderInfo(id){
		//alert(id);
		$.get("orderControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				cOrder = ar[4];
				//cStreet = ar[41];
			}
		});
	}
	