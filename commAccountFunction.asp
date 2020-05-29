	var newAccountStartDate = "";
	var newAccountEndDate = "";
	var newAccountPrice = "";
	var accountCountUnit = 0;
	var refund = 0;

	function getAccountList(nodeID){
		$.get("accountControl.asp?op=getListByUnit&refID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = (unescape(re)).split("%%");
			$("#accountCover").empty();
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='accountTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='20%'>账单号</th>");
			arr.push("<th width='13%'>应付</th>");
			arr.push("<th width='13%'>已付</th>");
			arr.push("<th width='21%'>起始日期</th>");
			arr.push("<th width='21%'>截止日期</th>");
			arr.push("<th width='12%'>状态</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var c = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					c = 0;
					if(ar1[1]==1){c = 2;}
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td width='20%' class='link1'><a href='javascript:showAccountInfo(\"" + ar1[2] + "\");'>" + ar1[2] + "</a></td>");
					arr.push("<td width='13%' class='left'>" + ar1[4] + "</td>");
					arr.push("<td width='13%' class='center'>" + ar1[5] + "</td>");
					arr.push("<td width='21%' class='center'>" + ar1[7] + "</td>");
					arr.push("<td width='21%' class='center'>" + ar1[3] + "</td>");
					arr.push("<td width='12%' class='center'>" + ar1[6] + "</td>");
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
			$("#accountCover").html(arr.join(""));
			arr = [];
			$('#accountTab').dataTable({
				"aaSorting": [],
				"aLengthMenu": [[15, 25, 50, -1], [15, 25, 50, "All"]]
			});
		});
		getNewAccountBase(nodeID);
	}

	function getAccountDetailList(nodeID){
		$.get("accountControl.asp?op=getAccountDetailList&nodeID=" + nodeID + "&dk=0&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = ar0[1];
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='floatTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='8%'>No.</th>");
			arr.push("<th width='25%'>身份证号</th>");
			arr.push("<th width='12%'>姓名</th>");
			arr.push("<th width='15%'>起始日期</th>");
			arr.push("<th width='15%'>退档日期</th>");
			arr.push("<th width='15%'>截止日期</th>");
			arr.push("<th width='10%'>天数</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i=0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td width='8%' class='center'>" + i + "</td>");
					arr.push("<td width='25%' class='left'><a href='javascript:showAccountDetail(" + ar1[7] + ");'>" + ar1[1] + "</a></td>");
					arr.push("<td width='12%' class='left'>" + ar1[2] + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[3] + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[4] + "</td>");
					arr.push("<td width='15%' class='left'>" + ar1[5] + "</td>");
					arr.push("<td width='10%' class='left'>" + ar1[6] + "</td>");
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
			$("#floatCover").html(arr.join(""));
			arr = [];
			$('#floatTab').dataTable({
				"aaSorting": [],
				"aLengthMenu": [[15, 25, 50, -1], [15, 25, 50, "All"]]
			});
			floatLog = "  本期合计：" + floatCount + "人 " + floatSum + "天  单价:" + $("#accountPrice").val() + "元/人/月";
			floatSum = "本期费用:" + $("#account").val() + "元  结转:" + $("#debt").val() + "元  减免:" + $("#remit").val() + "元  已付:" + $("#completedPay").val() + "元  应付:" + $("#needPay").val() + "元";
			//floatKind[0] = "getAccountDetailList";
		});
	}

	function getNewAccountBase(nodeID){
		$.get("accountControl.asp?op=getNewAccountBase&refID=" + nodeID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar2 = new Array();
			ar2 = unescape(data).split("|");
			if(ar2>""){
				$("#new_accountCode").val(ar2[0]);
				$("#new_accountStartDate").html(ar2[1]);
				$("#new_accountEndDate").html(ar2[2]);
				$("#new_accountPrice").html(ar2[3]);
				newAccountStartDate = ar2[1];
				newAccountEndDate = ar2[2];
				newAccountPrice = ar2[3];
				$("#newAccount").show();
				$("#editNewAccount").show();
				$("#preNewAccount").show();
			}else{
				setNewAccountEmpty();
				$("#newAccount").hide();
				$("#editNewAccount").hide();
				$("#preNewAccount").hide();
			}
		});
	}

	function showNewAccountInfo(){
		if($("#new_accountCode").val() > ""){
			asyncbox.open({
				url:'newAccountInfo.asp?accountCode=' + $("#new_accountCode").val() + '&p=1&times=' + (new Date().getTime()),
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
	　　　　}
	　　　}
			});
			//ShowIframe("未出账单信息","newAccountInfo.asp?accountCode=" + $("#new_accountCode").val() + "&p=1&times=" + (new Date().getTime()),500,300);
		}
	}
	
	function getNewAccountInfo(nodeID){
		$.get("accountControl.asp?op=getNewAccount&refID=" + nodeID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar2 = new Array();
			ar2 = unescape(data).split("|");
			if(ar2>""){
				$("#new_accountCode").val(ar2[0]);
				$("#new_accountStartDate").html(ar2[1]);
				$("#new_accountEndDate").html(ar2[2]);
				$("#new_accountPrice").html(ar2[3]);
				$("#new_calBase").html(ar2[4]+"&nbsp;天");
				$("#new_account").html(ar2[5]+"元");
				$("#new_debt").html(ar2[6]);
				$("#newAccount").show();
				$("#editNewAccount").show();
			}else{
				setNewAccountEmpty();
				$("#newAccount").hide();
				$("#editNewAccount").hide();
			}
		});
	}

	function showAccountInfo(nodeID){
		var i = getAccountInfo(nodeID);
	}

	function getAccountInfo(nodeID){
		var result = 0;
		$.get("accountControl.asp?op=getNodeInfo&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar.length > 0){
				$("#accountID").val(ar[0]);
				$("#accountStatus").val(ar[1]);
				$("#accountStatus_old").val(ar[1]);
				$("#accountCode").val(ar[2]);
				$("#account_refID").val(ar[2]);
				$("#remitRefID").val(ar[2]);
				$("#targetPay").val(ar[4]);
				$("#completedPay").val(ar[5]);
				$("#accountStartDate").val(ar[6]);
				$("#accountEndDate").val(ar[7]);
				$("#calBase").val(ar[8]);
				$("#accountPrice").val(ar[9]);
				$("#account").val(ar[10]);
				$("#shouldPay").val(ar[11]);
				$("#remit").val(ar[12]);
				$("#debt").val(ar[13]);
				$("#accountMemo").val(ar[14]);
				$("#wouldPay").val(ar[15]+".00");
				$("#needPay").val(ar[15]+".00");
				$("#willPay").val(ar[15]+".00");
				$("#wouldPay1").val(ar[15]+".00");
				$("#noteDate").val(ar[17]);
				$("#billQty").val(ar[15]/ar[9]);
				$("#accountCountUnit").val(ar[20]);
				if(ar[21]==1){
					$("#mailReturn").attr("checked","true");
				}else{
					$("#mailReturn").attr("checked","");
				}
				setButton();
				if(ar[18]>0){  //有申请准减免记录的可以查看
					$("#showRemit").show();
				}else{
					$("#showRemit").hide();
				}
				if(ar[1]>1){  //已经结清的不能再修改状态
					$("#accountStatus").attr("disabled","disabled");
				}else{
					$("#accountStatus").attr("disabled","");
				}
				if(ar[1]==1 && ar[19]==0 && checkPermission("payment")){  //已经结清的或者已有待审核的减免申请，不能再申请减免
					$("#doRemit").show();
				}else{
					$("#doRemit").hide();
				}
				if(ar[19]==1){  //有待审核的减免申请，醒目颜色提示
					$("#remit").css("background","yellow");
				}else{
					$("#remit").css("background",colorReadOnly);
				}
				if(checkPermission("payment") && ar[1]==1){
					$("#reGenAccount").show();
					$("#reBuildAccount").show();
				}else{
					$("#reGenAccount").hide();
					$("#reBuildAccount").hide();
				}
				if(checkPermission("superPayment") && $("#completedPay").val()>"0"){
					$("#refund").show();
				}else{
					$("#refund").hide();
				}
				if(checkPermission("superPayment") && $("#accountStatus").val()=="1"){
					$("#accountPrice").attr("class","");
					$("#accountPrice").attr("readOnly","");
				}else{
					$("#accountPrice").attr("class","readOnly");
					$("#accountPrice").attr("readOnly","true");
				}
		
				getPayList(ar[2]);
			}
		});
		return result;
	}

	function getPayList(nodeID){
		$.get("accountControl.asp?op=getPayList&refID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("%%");
			$("#payList").empty();
			if(ar>""){
				arr = [];
	    	arr.push("<tr style='background:#f0f0f0;'>");
		    arr.push("<td width='25%'>支付日期</td>");
		    arr.push("<td width='25%'>支付金额</td>");
		    arr.push("<td width='15%'>类型</td>");
		    arr.push("<td width='35%'>发票号</td>");
	      arr.push("</tr>");
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
		      arr.push("<tr style='background:#f0fdf0;'>");
			    arr.push("<td width='25%' class='link1'><a href='javascript:showPayInfo(" + ar1[0] + ");'>" + ar1[1] + "</a></td>");
			    arr.push("<td width='25%'>" + ar1[2] + "</td>");
			    arr.push("<td width='15%'>" + ar1[3] + "</td>");
			    arr.push("<td width='35%'>" + ar1[4] + "</td>");
		      arr.push("</tr>");
				});
				$("#payList").html(arr.join(""));
				arr = [];
			}
		});
	}

	function showPayInfo(nodeID){
		$.get("accountControl.asp?op=getPayInfo&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			addNewPayment = 0;
			refund = 0;
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar.length > 0){
				$("#accountPayID").val(ar[0]);
				$("#realPay").val(ar[1]);
				$("#payDate").val(ar[2]);
				$("#payType").val(ar[3]);
				$("#checkNo").val(ar[4]);
				$("#billNo").val(ar[5]);
				$("#payMemo").val(ar[6]);
				$("#payOperator").val(ar[7]);
				$("#payOperatorName").val(ar[8]);
				$("#billDate").val(ar[9]);
				$("#billMan").val(ar[10]);
				$("#account_refID").show();
				$("#wouldPay").hide();
				$("#paySelect").html("账单编号");
				document.getElementById("payDetail").style.display="block";
				document.getElementById("fadePayDetail").style.display="block";
			}
			setPayButton();
		});
	}

	function showRemit(kind){
		$.get("commonControl.asp?op=setSession&sName=pagePara" + "&anyStr=" + escape($("#accountCode").val() + "|" + $("#unitName").val() + $("#accountCode").val() + "|" + kind) + "&times=" + (new Date().getTime()),function(re){
			asyncbox.open({
				url:'accountRemitList.asp?times=' + (new Date().getTime()),
				title: '费用减免申请',
	　　　width : 900,
	　　　height : 700,
	　　　callback : function(action){
	　　　　　if(action == 'close'){
	　　　　　　　getAccountInfo($("#accountCode").val());
	　　　　　}
	　　　}
			});
		});
	}

	function getNewBillNo(kind){
		$.get("accountControl.asp?op=getNewBillNo&keyID=" + kind + "&times=" + (new Date().getTime()),function(re){
			$("#billNo").val(unescape(re));
		});
	}

	function unitHasNoPayAccount(unitID){
		var num = 0;
		$.get("accountControl.asp?op=unitHasNoPayAccount&refID=" + unitID + "&times=" + (new Date().getTime()),function(re){
			num = re;
		});
		return num;
	}
	
	function setAccountEmpty(){
		$("#accountID").val(0);
		$("#accountStatus").val(0);
		$("#accountCode").val("");
		$("#account_refID").val("");
		$("#targetPay").val(0);
		$("#completedPay").val(0);
		$("#accountStartDate").val("");
		$("#accountEndDate").val("");
		$("#calBase").val(0);
		$("#accountPrice").val(0);
		$("#account").val(0);
		$("#shouldPay").val(0);
		$("#remit").val(0);
		$("#remitID").val(0);
		$("#debt").val(0);
		$("#accountMemo").val("");
		$("#wouldPay").val(0);
		$("#noteDate").val("");
		setButton();
		$("#payList").empty();
		$("#reGenAccount").hide();
		$("#reBuildAccount").hide();
	}
	
	function setNewAccountEmpty(){
		$("#new_accountCode").val("");
		$("#new_accountStartDate").html("&nbsp;");
		$("#new_accountEndDate").html("&nbsp;");
		$("#new_accountPrice").html("&nbsp;");
	}
	
	function setPayButton(){
		if(addNewPayment == 1){
			$("#realPay").attr("class","mustFill");
			$("#realPay").attr("readOnly","");
			$("#payDate").attr("class","mustFill");
			$("#payDate").attr("readOnly","");
			if(($("#payType").val()==1 && $("#checkNo").val()=="") || $("#realPay").val()=="" || $("#payDate").val()=="" || ($("#payType").val()<2 && $("#billNo").val()=="")){
				$("#savePay").attr("disabled","true");
			}else{
				$("#savePay").attr("disabled","");
			}
			if(refund==1){
				$("#savePay").attr("disabled","");
				$("#billNo").attr("class","");
				$("#billNo").attr("readOnly",true);
				$("#billDate").attr("class","");
				$("#billDate").attr("readOnly",true);
				$("#billDate").val("");
			}else{
				$("#billNo").attr("class","mustFill");
				$("#billNo").attr("readOnly","");
				$("#billDate").attr("class","mustFill");
				$("#billDate").attr("readOnly","");
			}
			if($("#realPay").val()>"" && $("#wouldPay").val()>"" && parseInt($("#realPay").val())>parseInt($("#wouldPay").val())){
				jConfirm("实际收取费用高于应收费用，确实要溢价收取吗", "确认对话框",function(r){
					if(r){
						//
					}else{
						$("#realPay").val($("#wouldPay").val());
					}
				});
			}
		}else{
			if(checkPermission("superPayment")){
				$("#realPay").attr("class","mustFill");
				$("#realPay").attr("readOnly","");
				$("#delPay").show();
			}else{
				$("#realPay").attr("class","readOnly");
				$("#realPay").attr("readOnly","true");
				$("#delPay").hide();
			}
			$("#payDate").attr("class","readOnly");
			$("#payDate").attr("readOnly","true");
			if(checkPermission("payment") || checkPermission("superPayment")){
				$("#savePay").attr("disabled","");
			}
		}
	}

	function showAccountDetail(id){
		document.getElementById("lightFloat").style.display="none";
		document.getElementById("fadeFloat").style.display="none";
		asyncbox.open({
			url:'accountDetailInfo.asp?nodeID=' + id + '&addNew=0&p=1&times=' + (new Date().getTime()),
			title: '账单明细信息',
　　　width : 360,
　　　height : 320,
			cover : {
        //透明度
         opacity : 0,
        //背景颜色
         background : '#000'
      },

			callback : function(action,iframe){
				if(action == 'close'){
					var uc = iframe.getUpdateCount();
					if(uc > 0){
						getAccountList(nCode);
						showAccountInfo($("#accountCode").val());
					}
　　　　}
　　　}
		});
	}
