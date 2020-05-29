	function showMergeDocList(kindID,status,mark,nodeID){
		getMergeDocList(kindID,status,mark,nodeID,"mergeDocCover","mergeDocTab");
		setMergeDocEmpty();
	}

	function getMergeDocCount(){
		var kindID = $("#mergeDocKindSelect").val();
		var nodeID = $("#unitID").val();
		var status = 0;
		$.get("mergeControl.asp?op=getMergeDocCount&kind=" + kindID + "&status=" + status + "&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(data){
			$("#mergeDocCover").html("<div class='comm' style='padding:5px;'><br>资料数量：" + data + "<hr size='1' noshadow color='gray'>请查询<a href='#this' onClick='showMergeDocList(" + kindID + "," + status + ",\"" + nodeID + "\")'>&nbsp;详细列表。</a><br></div>");
		});
	}

	function getMergeDocList(kindID,status,mark,nodeID,coverName,tabName){
		//jAlert(kindID + "&status=" + status + "&keyID=" + mark + "&nodeID=" + nodeID);					
		$.get("mergeControl.asp?op=getMergeDocList&kind=" + kindID + "&status=" + status + "&keyID=" + mark + "&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			if(coverName==""){
				coverName = "floatCover";
			}
			if(tabName==""){
				tabName = "floatTab";
			}
			$("#" + coverName).empty();
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='" + tabName + "' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='10%'>No.</th>");
			if(kindID != 2){
				arr.push("<th width='20%'>姓名</th>");
				arr.push("<th width='30%'>档案编号</th>");
			}
			if(kindID == 2){ //更名函
				arr.push("<th width='50%'>修改后的名称</th>");
			}
			arr.push("<th width='25%'>接收日期</th>");
			arr.push("<th width='15%'>并档</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbodyMergeDoc'>");
			if(ar>""){
				var i = 0;
				$.each(ar,function(iNum,val){
					i += 1;
					var ar1 = new Array();
					ar1 = val.split("|");
					arr.push("<tr class='grade" + ar1[1] + "'>");
					arr.push("<td width='10%' class='center'>" + i + "</td>");
					if(kindID != 2){
						arr.push("<td width='20%' class='link1'><a href='javascript:getMergeDocInfo(" + kindID + ",\"" + ar1[0] + "\");'>" + ar1[4] + "</a></td>");
						arr.push("<td width='30%' class='left'>" + ar1[3] + "</td>");
					}else{
						arr.push("<td width='50%' class='link1'><a href='javascript:getMergeDocInfo(" + kindID + ",\"" + ar1[0] + "\");'>" + ar1[4] + "</a></td>");
					}
					arr.push("<td width='25%' class='center'>" + ar1[7] + "</td>");
					if(ar1[7]>""){		//资料已接收
						if(ar1[8]!=ar1[9]){
							arr.push("<td width='15%' class='center'><font color='red'>" + ar1[8] + "</font>/" + ar1[9] + "</td>");
						}else{
							arr.push("<td width='15%' class='center'>" + ar1[8] + "/" + ar1[9] + "</td>");
						}
					}else{						//还没有接收
					//alert(ar1[0]);
						arr.push("<td width='15%' class='link1'>");
						if(checkPermission("mergeIn")){
							arr.push("<a id='dr" + ar1[0] + "' href='javascript:doReceive(" + kindID + ",\"" + ar1[0] + "\");'><img src='images/green_check.png' border='0' width='13' height='15' title='接收'></a>");
							arr.push("<a id='dc" + ar1[0] + "' href='javascript:doClose(" + kindID + ",\"" + ar1[0] + "\");'><img src='images/cancel.png' border='0' width='21' height='14' title='关闭'></a>");
						}
						arr.push("</td>");
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
			if(kindID != 2){
				arr.push("<th>&nbsp;</th>");
			}
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#" + coverName).html(arr.join(""));
			arr = [];
			$("#" + tabName).dataTable({
				"bLengthChange": true,
				"aLengthMenu": [[15, 25, 30, -1], [15, 25, 30, "All"]],
				"bFilter": true,
				"aaSorting": []
			});
			
			if(coverName == "floatCover"){
				showFloatCover();
			}
		});
	}

	function getCheckoutCount(){
		$.get("mergeControl.asp?op=getCheckoutCount&times=" + (new Date().getTime()),function(){
			$("#btn" + nodeID).hide();
		});
	}

	function doMerge(nodeID){
		jConfirm("确实要执行并档操作吗？","确认对话框",function(r){
			if(r){
				$.get("mergeControl.asp?op=doMerge&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
					$("#checkoutCount").html(re);
				});
			}
		});
	}

	function doReceive(kind,nodeID){
		jConfirm("确实要接收这个资料吗？","确认对话框",function(r){
			if(r){
				$.get("mergeControl.asp?op=doReceive&kind=" + kind + "&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(){
					$("#dr" + nodeID).hide();
				});
			}
		});
	}

	function doReceive0(nodeID){
		asyncbox.open({
			url:'mergeDocInfo.asp?addNew=0&op=receive&nodeID=' + nodeID + '&name=' + escape($("#name_mergeDoc0").val()) + '&kind=1&p=1&times=' + (new Date().getTime()),
			title: '并档材料接收',
　　　width : 380,
　　　height : 350,
			cover : {
        //透明度
         opacity : 0,
        //背景颜色
         background : '#000'
      },

			btnsbar : $.btn.OKCANCEL,
			callback : function(action,iframe){
				if(action == 'ok'){
					var re = iframe.saveMerge();
					if(re){
						//jAlert("保存成功","信息提示");
						$.get("mergeControl.asp?op=doReceive&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
							//getReturnDocList("");
							getMergeDocInfo0(nodeID,0);
							//alert("iframe.waitOut=" + iframe.waitOut);
							if(iframe.waitOut==1){	//接收后做待出库
								//先定位到对应的档案和单位
								//alert("iframe.archiveID=" + iframe.archiveID);
								$("#searchUnit").val(iframe.archiveID);
								if(serachUnit()){
									//调用待出库接口
									doOut();
								}
							}
						});
					}else{
						return false;
					}
　　　　}
　　　}
		});
	}

	function doClose(kind,nodeID){
		jConfirm("关闭以后将不再显示该条信息，确实要关闭这吗？","确认对话框",function(r){
			if(r){
				//alert(kind + ":" + nodeID);
				$.get("mergeControl.asp?op=doClose&kind=" + kind + "&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(){
					$("#dc" + nodeID).hide();
					jAlert("已成功关闭","信息提示");
					getMergeDocInfo0(nodeID,0);
				});
			}
		});
	}
	
	function getMergeDocInfo(kindID,nodeID){
		$.get("mergeControl.asp?op=getMergeDocInfo&keyID=" + kindID + "&nodeID=" + escape(nodeID) + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			$("#uploadMergeDoc").hide();
			if(ar.length > 0){
				$("#mergeDocID").val(ar[0]);
				$("#archiveID_mergeDoc").val(ar[3]);
				$("#name_mergeDoc").val(ar[4]);
				$("#mergeDocKind").val(ar[1]);
				$("#mergeDocKindName").html(ar[6]);
				$("#mergeDocDate").val(ar[7]);
				$("#mergeDocOperator").val(ar[8]);
				$("#mergeDocOperatorName").val(ar[9]);
				$("#mergeDocMemo").val(ar[10]);
				if(kindID!=2){
					$("#showMergeKind0").show();
					$("#showMergeKind0a").show();
					$("#showMergeKind1").hide();
					$("#showOldUnitName").hide();
					$("#archiveID_mergeDoc").attr("disabled","true");
				}else{
					$("#showMergeKind0").hide();
					$("#showMergeKind0a").hide();
					$("#showMergeKind1").show();
					$("#showOldUnitName").show();
					$("#archiveID_mergeDoc").attr("disabled","");
					$("#oldUnitName").val(ar[11]);
				}
				getDownloadFile("mergeDocID");
				$("#uploadMergeDoc").show();
				$("#mergeDocMemoHelp").val("请选择...");
				addNewMergeDoc = 0;
				setMergeDocButton();
			}
		});
	}
	
	function getMergeDocInfo0(nodeID){
		$.get("mergeControl.asp?op=getReturnDocInfo&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			//$("#uploadMergeDoc0").hide();
			if(ar.length > 0){
				$("#mergeDocID0").val(ar[0]);
				$("#mergeDocKeepID0").val(ar[1]);
				$("#archiveID_mergeDoc0").val(ar[2]);
				$("#name_mergeDoc0").val(ar[3]);
				$("#mergeDocLocation0").val(ar[4]);
				$("#mergeDocOrderDate0").val(ar[5]);
				$("#mergeDocOrderManName0").val(ar[6]);
				$("#mergeDocMemo0").val(ar[8]);
				$("#mergeDocUnitName0").val(ar[9]);
				$("#mergeDocArchStatus0").val(ar[10]);
				$("#mergeDocOperatDate0").val(ar[11]);
				$("#mergeDocRegLinker0").val(ar[12]);
				$("#mergeDocDismissDate0").val(ar[13]);
				$("#mergeDocStatus0").val(ar[14]);
				$("#mergeDocStatusName0").val(ar[15] + " " + ar[16]);
				$("#mergeDocUnitID0").val(ar[17]);
				$("#mergeDocCurrUnitName0").val(ar[18]);
				$("#mergeDocKeepStatus0").val(ar[19]);
				$("#mergeDocOperatorName0").val(ar[20]);
				mergeDocChkHadMoved = ar[21];
				//getDownloadFile("mergeDocID");
				//$("#uploadMergeDoc0").show();
				
				setMergeDocButton0();
			}
		});
	}
	
	function setMergeDocEmpty(){
		$("#mergeDocID").val(0);
		$("#archiveID_mergeDoc").val("");
		$("#name_mergeDoc").val("");
		$("#mergeDocKind").val(0);
		$("#mergeDocKindName").val('');
		$("#mergeDocDate").val('');
		$("#mergeDocOperator").val('');
		$("#mergeDocOperatorName").val('');
		$("#mergeDocMemo").val('');
		$("#downloadFile_mergeDocID").html('');
		setMergeDocButton();
	}
	
	function setMergeDocEmpty0(){
		$("#mergeDocID0").val(0);
		$("#mergeDocKeepID0").val(0);
		$("#archiveID_mergeDoc0").val("");
		$("#name_mergeDoc0").val("");
		$("#mergeDocLocation0").val(0);
		$("#mergeDocOrderDate0").val('');
		$("#mergeDocOperatDate0").val('');
		$("#mergeDocArchStatus0").val(-1);
		$("#mergeDocStatus0").val(0);
		$("#mergeDocMemo0").val('');
		$("#mergeDocDismissDate0").val('');
		$("#mergeDocRegLinker0").val('');
		$("#mergeDocUnitID0").val(0);
		$("#mergeDocCurrUnitName0").val('');
		$("#mergeDocKeepStatus0").val(3);
		mergeDocChkHadMoved = 1;
		//$("#downloadFile_mergeDocID0").html('');
		setMergeDocButton0();
	}

	function setMergeDocButton(){
		$("#delMergeDoc").hide();
		$("#mergeDocArchives").hide();
		$("#btnArchiveLog2").hide();
		$("#addNewMergeDoc").hide();
		/*
		if(addNew == 0 && nID > 0){
			$("#btnArchiveLog2").show();
			if($("#mergeDocKindSelect").val()!=1){
				$("#addNewMergeDoc").show();
			}else{
				$("#addNewMergeDoc").hide();
			}
			if($("#mergeDocID").val()>"0"){
				$("#delMergeDoc").show();
				$("#mergeDocArchives").show();
			}
			if(addNewMergeDoc==1){
				$("#mergeDocArchives").show();
				$("#delMergeDoc").hide();
			}
			if(!checkPermission("mergeIn")){
				$("#delMergeDoc").hide();
				$("#mergeDocArchives").hide();
				$("#addNewMergeDoc").hide();
			}
		}
		*/
	}

	function setMergeDocButton0(){
		$("#inMergeDoc0").hide();
		$("#outMergeDoc0").hide();
		$("#closeMergeDoc0").hide();
		$("#btnArchiveLog3").hide();
		if($("#mergeDocID0").val() > 0){
			$("#btnArchiveLog3").show();
		}
		if($("#mergeDocID0").val() > 0 && $("#mergeDocOrderDate0").val() == "" && $("#mergeDocStatus0").val() == 0){
			if(mergeDocChkHadMoved==0){
				$("#inMergeDoc0").show();
				if($("#mergeDocKeepStatus0").val() == 1 && $("#mergeDocKeepID0").val() > 0){
					$("#outMergeDoc0").show();
				}
			}
			$("#closeMergeDoc0").show();
		}
	}

	function setMergeDocKindList(){
		if($("#mergeDocKindSelect").val()!=1){
			$("#addNewMergeDoc").show();
		}else{
			$("#addNewMergeDoc").hide();
		}
		if($("#mergeDocKindSelect").val()==0){
			$("#mergeDocMemoHelp").empty();
			$("<option value='请选择...'>请选择...</option>").appendTo("#mergeDocMemoHelp");
			$("<option value='学历文件'>学历文件</option>").appendTo("#mergeDocMemoHelp");
			$("<option value='仲裁文件'>仲裁文件</option>").appendTo("#mergeDocMemoHelp");
			$("<option value='薪资调整'>薪资调整</option>").appendTo("#mergeDocMemoHelp");
			$("<option value='退工单'>退工单</option>").appendTo("#mergeDocMemoHelp");
			$("<option value='奖励文件'>奖励文件</option>").appendTo("#mergeDocMemoHelp");
			$("<option value='处罚文件'>处罚文件</option>").appendTo("#mergeDocMemoHelp");
			$("<option value='其他资料'>其他资料</option>").appendTo("#mergeDocMemoHelp");
			$("#mergeDocMemoHelp").show();
		}
		if($("#mergeDocKindSelect").val()==1){
			$("#mergeDocMemoHelp").empty();
			$("#mergeDocMemo").val("退工单");
			$("<option value='请选择...'>请选择...</option>").appendTo("#mergeDocMemoHelp");
			$("<option value='退工单'>退工单</option>").appendTo("#mergeDocMemoHelp");
			$("<option value='退休文件'>退休文件</option>").appendTo("#mergeDocMemoHelp");
			$("<option value='死亡证明'>死亡证明</option>").appendTo("#mergeDocMemoHelp");
			$("#mergeDocMemoHelp").show();
		}
		if($("#mergeDocKindSelect").val()==2){
			$("#mergeDocMemoHelp").hide();
			$("#mergeDocMemo").val("更名函");
		}
	}
