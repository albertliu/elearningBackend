	var mergeWhere = "";
	var mergeGroup = 0;
	var mergeDocChkHadMoved = 1;
	setMergeDocEmpty0();
	$("#doMerge").hide();

		$("#formMergeDoc").ajaxForm(function(data){
			//alert($("#mergeDocID").val() + " --- " + $("#mergeDocRefID").val()) + " --- " + $("#mergeDocKind").val();
			//alert(data);
			var ar = data.split("|");
			var re = ar[0];
			if(re == 0){
				$.get("mergeControl.asp?op=updateItem&nodeID=" + ar[1] + "&keyID=" + $("#mergeDocKind").val() + "&item=" + escape($("#mergeDocMemo").val()) + "&name=" + escape($("#name_mergeDoc").val()) + "&times=" + (new Date().getTime()),function(data1){
					jAlert("保存成功!","信息提示");
				});
				showMergeDocList($("#mergeDocKind").val(),0,$("input[name='searchMergeType']:checked").val(),$("#unitID").val());
				getMergeDocInfo($("#mergeDocKind").val(),ar[1]);
			}
			if(re == 1){
				jAlert("!");
			}
			if(re == 2){
				jAlert("!");
			}
			if(re == 3){
				jAlert("操作失败!");
			}
			if(re == 4){
				jAlert("!");
			}
			if(re == 5){
				jAlert("!");
			}
			addNewMergeDoc = 0;
			return false;
		});
		
		
		$("#addNewMergeDoc").click(function(){
			addNewMergeDoc = 1;
			$("#mergeDocKind").val($("#mergeDocKindSelect").val());
			$("#downloadFile_mergeDocID").html("");
			$("#mergeDocID").val(0);  //new item
			$("#archiveID_mergeDoc").val("");
			$("#name_mergeDoc").val("");
			$("#mergeDocDate").val(currDate);
			$("#mergeDocOperator").val(currUser);
			$("#mergeDocOperatorName").val(currUserName);
			$("#uploadMergeDoc").hide();
			$("#mergeDocArchives").show();
			//$("#mergeDocArchives").attr("disabled","true");
			$("#archiveID_mergeDoc").attr("disabled","");
			if($("#mergeDocKindSelect").val()!="2"){  //退工单或个人资料
				$("#mergeDocRefID").val(0);
				$("#showMergeKind0").show();
				$("#showMergeKind0a").show();
				$("#showMergeKind1").hide();
				$("#showOldUnitName").hide();
				$("#mergeDocMemo").val("");
			}
			if($("#mergeDocKindSelect").val()=="2"){  //更名函
				$("#mergeDocRefID").val($("#unitCode").val());
				$("#name_mergeDoc").val("");
				$("#oldUnitName").val($("#unitName").val());
				$("#mergeDocMemo").val("更名函");
				$("#showMergeKind0").hide();
				$("#showMergeKind0a").hide();
				$("#showMergeKind1").show();
				$("#showOldUnitName").show();
			}
			setButton();
		});
		
		$("#delMergeDoc").click(function(){
			jConfirm('你确定要删除这份资料吗?', '确认对话框', function(r) {
				if(r){
					$.get("mergeControl.asp?op=delNode&nodeID=" + $("#mergeDocID").val() + "&times=" + (new Date().getTime()),function(data){
						jAlert("保存成功!","信息提示");
					});
					showMergeDocList($("#mergeDocKind").val(),0,$("input[name='searchMergeType']:checked").val(),$("#unitID").val());
					setMergeDocEmpty();
				}
			});
		});

		$("#mergeDocKindSelect").change(function(){
			setMergeDocKindList();
			showMergeDocList($("#mergeDocKindSelect").val(),0,$("input[name='searchMergeType']:checked").val(),$("#unitID").val());
		});

		$("input[name='searchMergeType']").change(function(){
			showMergeDocList($("#mergeDocKindSelect").val(),0,$("input[name='searchMergeType']:checked").val(),$("#unitID").val());
		});
		
		$("#archiveID_mergeDoc").change(function(){
			$("#mergeDocArchives").attr("disabled","true");
			if($("#archiveID_mergeDoc").val()>""){
				$.get("mergeControl.asp?op=checkDismiss&nodeID=" + $("#archiveID_mergeDoc").val() + "&keyID=" + $("#unitCode").val() + "&times=" + (new Date().getTime()),function(data){
					//alert(unescape(data));
					var ar = unescape(data).split("|");
					var re = ar[0];
					if(re == 0 || ($("#mergeDocKindSelect").val()==0 && re < 9) || ($("#mergeDocKindSelect").val()==1 && re == 1)){
						$("#name_mergeDoc").val(ar[1]);
						$("#mergeDocRefID").val(ar[2]);
						$("#mergeDocArchives").attr("disabled","");
					}
					if($("#mergeDocKindSelect").val()==1 && re == 2){
						jConfirm("该员工还没有退工，将自动退工，确实要接收退工单吗？","确认信息",function(r){
							if(r){
								$("#name_mergeDoc").val(ar[1]);
								$("#mergeDocRefID").val(ar[2]);
								$("#mergeDocArchives").attr("disabled","");
							}
						});
					}
					if(re == 9){
						jAlert("该档案不在当前单位中!");
					}
				});
			}
		});
		
		$("#name_mergeDoc").change(function(){
			if($("#mergeDocKind").val()==2){	//更名函
				if($("#name_mergeDoc").val()>""){
					if($("#name_mergeDoc").val() != $("#oldUnitName").val()){
						$("#mergeDocArchives").attr("disabled","");
						return true;
					}else{
						jAlert("与原名称重复，请检查","信息提示");
						return false;
					}
				}else{
					$("#mergeDocArchives").attr("disabled",true);
					jAlert("名称不能为空","信息提示");
					return false;
				}
			}
		});
		
		$("#mergeDocMemoHelp").change(function(){
			$("#mergeDocMemo").val($("#mergeDocMemoHelp").val());
		});
    
    $("input[name='searchMergeStatus']").click(function(){
    	$("#btnSearchReturnDoc").click();
    });
