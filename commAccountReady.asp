
    $("#accountStartDate").click(function(){
    	if(!$("#accountStartDate").attr("readOnly")){
	    	WdatePicker();
    	}
    });
    $("#accountEndDate").click(function(){
    	if(!$("#accountEndDate").attr("readOnly")){
	    	WdatePicker();
    	}
    });

		$("#formAccount").ajaxForm(function(re){
			//alert(re);
			var code = $("#accountCode").val();
			if(re == 0){
				$.get("accountControl.asp?op=updateItem&nodeID=" + code + "&memo=" + escape($("#accountMemo").val()) + "&times=" + (new Date().getTime()),function(data){
					jAlert("保存成功!");
				});
				getAccountList(nCode);
				showAccountInfo(code);
			}
			if(re == 1){
				jAlert("欠款未结清，不能修改状态!");
			}
			if(re == 2){
				jAlert("不能结转!");
			}
			if(re == 3){
				jAlert("不允许进行这样的逆向状态修改态!");
			}
			if(re == 4){
				jAlert("不允许直接关闭账单（需要通过审批）!");
			}
			if(re == 5){
				jAlert("无法打开新帐期，不能结转!");
			}
		});
		
		$("#formPay").ajaxForm(function(re){
			var ar = new Array();
			ar = re.split("|");
			var er = ar[0];
			if(er == 0){
				$("#accountPayID").val(ar[1]);
				var code = $("#account_refID").val();
				$.get("accountControl.asp?op=updatePayItem&nodeID=" + ar[1] + "&memo=" + escape($("#payMemo").val()) + "&times=" + (new Date().getTime()),function(data){
					jAlert("保存成功!");
					addNewPayment = 0;
					getAccountList(nCode);
					showAccountInfo(code);
					getPayList(code);
					document.getElementById("payDetail").style.display="none";
					document.getElementById("fadePayDetail").style.display="none";
				});
			}
			if(er == 1){
				jAlert("付款不能为0");
			}
			if(er == 2){
				jAlert("请填写退款原因");
			}
			
			return false;
		});
		
		$("#newAccount").click(function(){
			arr = [];
			arr.push("<div class='comm'><h2>本帐期还未结束，是否提前结算？</h2></div>");
			if(unitHasNoPayAccount(nID)==1){
				arr.push("<div class='redText'>建议退出本次操作，因为该单位已有一个欠款账单，应该调整该账单的帐期。</div>");
			}
			arr.push("<hr size='1' noshadow>");
			arr.push("<div>请输入截止日期：<input type='text' id='forgetOutDate' name='forgetOutDate' size='20' value='" + currDate + "' /></div>");
			asyncbox.open({
				html: arr.join(""),
				title: '提前结算',
	　　　width : 400,
	　　　height : 280,
				btnsbar : $.btn.OKCANCEL,
	　　　callback : function(action){
		　　　if(action == 'ok'){
						if($("#forgetOutDate").val()==""){
							jAlert("请填写正确的出库日期","信息提示");
							return false;
						}

						$.get("accountControl.asp?op=setAccountEndDate&nodeID=" + $("#new_accountCode").val() + "&keyID=" + $("#forgetOutDate").val() + "&times=" + (new Date().getTime()),function(re){
							$.get("accountControl.asp?op=calAccount&nodeID=" + $("#new_accountCode").val() + "&times=" + (new Date().getTime()),function(re){
								//alert(unescape(re));
								getAccountList(nCode);
								showAccountInfo(unescape(re));
								setNewAccountEmpty();
							});
							getNewAccountBase(nCode);
						});
		　　　}
	　　　}
			});
		});
		
		$("#editNewAccount").click(function(){
			jPrompt("请输入新的截止日：",$("#new_accountEndDate").html(),"输入窗口",function(x){
				if(x && x>"" && x != $("#new_accountEndDate").html()){
						jConfirm("确实要修改截止日期吗？", "确认对话框",function(r){
							if(r){
								$.get("accountControl.asp?op=setAccountEndDate&nodeID=" + $("#new_accountCode").val() + "&keyID=" + x + "&times=" + (new Date().getTime()),function(re){
									//alert(unescape(re));
									getNewAccountBase(nCode);
								});
							}
						});
				}
			});
		});
		
		$("#reGenAccount").click(function(){
			asyncbox.open({
				url:'newAccountInfo.asp?accountCode=' + $("#accountCode").val() + '&p=1&times=' + (new Date().getTime()),
				title: '账单试算',
	　　　width : 480,
	　　　height : 250,
				cover : {
	        //透明度
	         opacity : 0,
	        //背景颜色
	         background : '#000'
	      },
	
				callback : function(action,iframe){
					if(action == 'close'){
						var uc = iframe.getUpdateCount();
						if(uc > ""){
							jConfirm("确实要按照新的截止日期 <font color='red'>" + uc + "</font> 重新生成账单吗？原来的账单将作废。", "确认对话框",function(r){
								if(r){
									$.get("accountControl.asp?op=reGenAccount&nodeID=" + $("#accountCode").val() + "&where=" + escape(uc) + "&times=" + (new Date().getTime()),function(re){
										//alert(unescape(re));
										if(re>0){
											getAccountList(nCode);
											getAccountInfo($("#accountCode").val());
										}
										if(re==0){
											jAlert("不适合对该账单进行调整，请另行处理。","信息提示");
										}
										if(re==1){
											jAlert("该账单已经重新计算，编号未变。","信息提示");
										}
										if(re==2){
											jAlert("已经进行了调整，原账单作废，请使用新账单。","信息提示");
										}
									});
								}
							});
						}
	　　　　}
	　　　}
			});
		});
		
		$("#reBuildAccount").click(function(){
			jPrompt("请输入原因：","","输入窗口",function(x){
				if(x && x>""){
					jConfirm("确实要重新计算账单吗？原来的账单如果已经发出，请收回。", "确认对话框",function(r){
						if(r){
							$.get("accountControl.asp?op=reBuildAccount&nodeID=" + $("#accountCode").val() + "&where=" + escape(x) + "&times=" + (new Date().getTime()),function(re){
								getAccountList(nCode);
								getAccountInfo($("#accountCode").val());
							});
						}
					});
				}
			});
		});
		
		$("#delPay").click(function(){
			jPrompt("请输入原因：","","输入窗口",function(x){
				if(x && x>""){
					jConfirm("确实要删除这条收费记录吗？对应的账单状态可能会变成欠费，请注意查看。", "确认对话框",function(r){
						if(r){
							$.get("accountControl.asp?op=delAccountPay&nodeID=" + $("#accountPayID").val() + "&memo=" + escape(x) + "&times=" + (new Date().getTime()),function(re){
								document.getElementById("payDetail").style.display="none";
								document.getElementById("fadePayDetail").style.display="none";
								jAlert("删除成功!");
								addNewPayment = 0;
								getAccountList(nCode);
								showAccountInfo(code);
								getPayList(code);
								$("#savePay").attr("disabled",true);
								$("#delPay").attr("disabled",true);
							});
						}
					});
				}
			});
		});
		
		$("#preNewAccount").click(function(){
			showNewAccountInfo();
		});
		
		$("#showNewAccount").click(function(){
			if($("#new_accountCode").val()>""){
				showAccountInfo($("#new_accountCode").val());
				$.get("accountControl.asp?op=getNewAccount&nodeID=" + $("#new_accountCode").val() + "&keyID=" + $("#accountEndDate").val() + "&times=" + (new Date().getTime()),function(re){
					//alert(unescape(re));
					var ar = new Array();
					ar = unescape(re).split("|");
					if(ar.length > 0){
						$("#calBase").val(ar[0]);
						$("#account").val(ar[1]);
						$("#debt").val(ar[2]);
						$("#needPay").val(ar[3]);
						$("#targetPay").val(ar[3]);
						$("#completedPay").val(ar[4]);
						$("#billQty").val(ar[3]/ar[5]);
					}
				});
			}
		});
		
		$("#showAccountDetail").click(function(){
			floatContent = getAccountDetailList($("#accountCode").val());
			floatTitle = "档案保管清单";
			floatItem = "单位名称：" + $("#unitName").val() + "    起始日期：" + $("#accountStartDate").val() + "    截止日期：" + $("#accountEndDate").val();
			floatLog = "账单编号：" + $("#accountCode").val() + "&nbsp;&nbsp;&nbsp;&nbsp;打印日期：" + currDate + floatLog;
			floatKind[0] = "getAccountDetailList";
			floatKey = $("#unitName").val();
			showFloatCover();
		});
		
		$("#printAccount").click(function(){
			openWord(1,$("#accountCode").val(),"print");
			//openWord(1,$("#accountCode").val(),"file");
			setOperationLog("account","print",$("#accountCode").val(),"",currUser);
		});
		
		$("#doPayment").click(function(){
			addNewPayment = 1;
			refund = 0;
			if($("#accountCode").val()>"" && $("#wouldPay").val()>"0"){
				$("#accountPayID").val(0);  //new item
				$("#realPay").val($("#wouldPay").val());
				$("#payDate").val(currDate);
				$("#payType").val(0);
				$("#checkNo").val("");
				$("#payMemo").val("");
				$("#payOperator").val(currUser);
				$("#payOperatorName").val(currUserName);
				$("#billDate").val(currDate);
				$("#billMan").val(currUser);
				$("#account_refID").hide();
				$("#savePay").attr("disabled","true");
				$("#wouldPay").show();
				$("#paySelect").html("欠费金额");
				getNewBillNo(0);
				document.getElementById("payDetail").style.display="block";
				document.getElementById("fadePayDetail").style.display="block";
			}else{
				jAlert("不具备收费条件。");
			}
			setPayButton();
		});
		
		$("#refund").click(function(){
			addNewPayment = 1;
			if($("#accountCode").val()>"" && $("#completedPay").val()>"0"){
				$("#accountPayID").val(0);  //new item
				$("#realPay").val(-$("#completedPay").val());
				$("#payDate").val(currDate);
				$("#payType").val(0);
				$("#checkNo").val("");
				$("#payMemo").val("");
				$("#billNo").val("");
				$("#payOperator").val(currUser);
				$("#payOperatorName").val(currUserName);
				$("#billDate").val(currDate);
				$("#billMan").val(currUser);
				//$("#account_refID").show();
				$("#savePay").attr("disabled","");
				$("#delPay").hide();
				//$("#wouldPay").show();
				//$("#paySelect").html("欠费金额");
				//getNewBillNo(0);
				document.getElementById("payDetail").style.display="block";
				document.getElementById("fadePayDetail").style.display="block";
				refund = 1;
				setPayButton();
			}else{
				jAlert("不具备退款条件。");
			}
		});
		
		$("#doRemit").click(function(){
			showRemit(0);
		});
		
		$("#showRemit").click(function(){
			showRemit(1);
		});
		
		$("#accountStatus").change(function(){
			var err = 1;
			if($("#accountStatus_old").val()==1 && $("#accountStatus").val() == 3){	//只允许欠款转下期的操作
				err = 0;
			}
			if(err == 1){
				$("#accountStatus").val($("#accountStatus_old").val());
				jAlert("不允许这种修改。");
			}
		});
		
		$("#payType").change(function(){
			if($("#payType").val() == 1){
				$("#checkNo").attr("class","mustFill");
			}else{
				$("#checkNo").attr("class","");
			}
			if(addNewPayment == 1){
				getNewBillNo($("#payType").val());
			}
		});
		
		$("#billDate").blur(function(){
			if($("#billDate").val() == ""){
				$("#billMan").val("");
				jAlert("发票未领取","信息提示");
			}else{
				$("#billMan").val(currUser);
			}
		});
		$("#realPay").change(function(){
			setPayButton();
		});
		$("#payDate").blur(function(){
			setPayButton();
		});
		$("#checkNo").change(function(){
			setPayButton();
		});
		$("#billNo").change(function(){
			setPayButton();
		});
		
		
		$("#mailReturn").change(function(){
			if($("#accountCode").val()>""){
				var mark = 0;
				if($("#mailReturn").attr("checked")){
					mark = 1;
				}
				if(mark==1){
					//账单邮寄退回，写入备忘录
					jConfirm("该账单确实在邮寄后被退回了吗？", "确认对话框",function(r){
						if(r){
							$.get("accountControl.asp?op=setBillReturn&nodeID=" + $("#accountCode").val() + "&keyID=0&times=" + (new Date().getTime()),function(re){
								//alert(unescape(re));
								if(re=="0"){
									jAlert("已成功标记到备忘录中。");
									getNoticeList(nID);		//刷新备忘录列表
								}
							});
						}else{
							$("#mailReturn").attr("checked","");
						}
					});
				}else{
					//撤销账单邮寄退回标记，并修改相关备忘录
					jConfirm("确实要撤销该账单被退回的标记吗？", "确认对话框",function(r){
						if(r){
							$.get("accountControl.asp?op=setBillReturn&nodeID=" + $("#accountCode").val() + "&keyID=1&times=" + (new Date().getTime()),function(re){
								//alert(unescape(re));
								if(re=="0"){
									jAlert("已成功撤销退回标记。");
									getNoticeList(nID);		//刷新备忘录列表
								}
							});
						}else{
							$("#mailReturn").attr("checked","true");
						}
					});
				}
			}
		});
		document.getElementById("payDetail").style.display="none";
		document.getElementById("fadePayDetail").style.display="none";
		getDicList("accountStatus","");
		getDicList("payType","");
		$("#payType option[value='3']").remove();

    $("#payDate").click(function(){WdatePicker();});
    $("#billDate").click(function(){WdatePicker();});