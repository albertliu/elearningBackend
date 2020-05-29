	var checkFlowBar_kind = 0;
	var checkFlowBar_refID = 0;
	var checkFlowBar_checkID = 0;
	
	$(document).ready(function (){
		$("#btnCommit4Check").click(function(){
			showCheckInfo(0,checkFlowBar_kind,checkFlowBar_refID,0,0,1)   //showCheckInfo(nodeID,kindID,refID,newsID,op,mark)
		});
	});

	function getCheckFlowBar(kind,ref){		//kind: 0 合同 1 项目登记  2 成果报告  3 发票  4归档  5 工作评价  6 收费计算表  9 请假
		//alert(id);
		checkFlowBar_kind = kind;
		checkFlowBar_refID = ref;
		//alert("1:" + kind+":"+ref);
		$.get("checkControl.asp?op=getCheckIDbyRef&kindID=" + kind + "&refID=" + ref + "&times=" + (new Date().getTime()),function(re){
			checkFlowBar_checkID = re;
			$.get("checkControl.asp?op=getNodeInfo&nodeID=" + checkFlowBar_checkID + "&times=" + (new Date().getTime()),function(data){
				//alert(unescape(data));
				var ar = new Array();
				ar = unescape(data).split("|");
				if(ar > ""){
					$("#checkStatusName").html(ar[3]);
					$("#checkDateStart").html(ar[11]);
					$("#checkDateEnd").html(ar[12]);
				}				
			});
		});
		//alert("2:" + checkFlowBar_checkID);
		$.get("checkFlowControl.asp?op=getCheckFlowList&refID=" + checkFlowBar_checkID + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("%%");
			if(ar > ""){
				arr = [];
				arr.push("<table>");					
	      arr.push("<tr style='height:5mm;'>");
				var i = 0;
				var bc = new Array();
				bc[0] = "#cccccc";//bc[ar1[3]]
				bc[1] = "#FF8888";
				bc[2] = "#00FF00";
				bc[3] = "#FF8888";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
	        arr.push("<td style='width:15mm;text-align:center;background:" + bc[ar1[3]] + ";'>" + ar1[2] + "</td>");
				});
	      arr.push("</tr>");
				arr.push("</table>");					
				$("#checkFlowBar").html(arr.join(""));
				arr = [];
				$("#commCheckFlowBar").show();
			}else{
				jAlert("该审批流程还未启动！","信息提示");
				$("#commCheckFlowBar").hide();
			}
		});
	}
