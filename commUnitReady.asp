		$("#formUnit").ajaxForm(function(data){
			//alert(data);
			var ar = new Array();
			ar = data.split("|");
			var re = ar[1];
			if(ar[0]==0){
				if(re > 0){
					if(addNew==0 && $("#keepKind").val() != $("#keepKind_old").val() && $("#keepKind").val()==1){ 	//代管转为自管单位
						arr = [];
						arr.push('<div class="comm"><h2>您已经将该单位变更为自管单位</h2></div><div class="comm"><div>');
						var uArchCount = getUnitAgentCount($("#unitCode").val());
						if(uArchCount>0){
							arr.push('<div class="redAlert">该单位现有' + uArchCount + '份代保管档案，将自动转为自管档案，请选择去向：</div><hr size="1" noshadow>');
			  			arr.push('&nbsp;<input style="border:0px;" type="radio" id="box3" name="box" checked />单位取档<input style="border:0px;" type="radio" id="box0" name="box" />转自管库');
				  		var debt = getUnitDebtToday(nID);
				  		if(debt > 0){
				  			arr.push('<div class="redText">该单位尚需缴纳' + debt + '元保管费。</div>');
				  			arr.push('<div>该单位帐期将被关闭，请输入截止日期：<input type="text" id="unitAccountEndDate" size="8" value="' + currDate + '" /></div>');
				  		}
						}
						asyncbox.open({
							html: arr.join("") ,
							title: '操作确认',
				　　　width : 400,
				　　　height : 280,
							btnsbar : $.btn.OK,
				　　　callback : function(action){
					　　　if(action == 'ok'){
									if(uArchCount>0){
										if(debt>0){
											if($("#unitAccountEndDate").val()==""){
												alert("请填写截止日期");
												return false;
											}else{
												$.get("accountControl.asp?op=doUnitAccountClose&keyID=" + nID + "&refID=" + $("#unitAccountEndDate").val() + "&times=" + (new Date().getTime()),function(){
													getAccountList(nCode);
												});
											}
										}
										var mark = 3;	//3 单位取档  0 转自管库
										var s = "请在自管出库中进行【单位取档】操作。";
										if($("#box0").attr("checked")){
											mark = 0;
											s = "请在代管出库中进行【转新单位】操作。";
										}
										$.get("archivesControl.asp?op=doTurn2SelfByUnit&keyID=" + nID + "&mark=" + mark + "&times=" + (new Date().getTime()),function(){
											jAlert(uArchCount + "份档案已经待出库，" + s);
										});
									}
					　　　}
				　　　}
						});
					}
					if(addNew==0 && $("#keepKind").val() != $("#keepKind_old").val() && $("#keepKind").val()==0){ 	//自管转为代管单位
						arr = [];
						arr.push('<div class="comm"><h2>您已经将该单位变更为代管单位</h2></div><div class="comm"><div>');
						var uArchCount = getUnitSelfCount($("#unitCode").val());
						if(uArchCount>0){
							arr.push('<div class="redAlert">该单位现有' + uArchCount + '份自保管档案，是否转为代管档案？');
						}
						asyncbox.open({
							html: arr.join("") ,
							title: '操作确认',
				　　　width : 400,
				　　　height : 280,
							btnsbar : $.btn.OK,
				　　　callback : function(action){
					　　　if(action == 'ok'){
									if(uArchCount>0){
										$.get("archivesControl.asp?op=doTurn2AgentByUnit&keyID=" + nID + "&times=" + (new Date().getTime()),function(){
											jAlert(uArchCount + "份档案已经待出库，请在自管出库中进行【转新单位】操作。");
										});
									}
					　　　}
				　　　}
						});
					}
				
					$("#unitID").val(re);
					nID = re;
					nCode = $("#unitCode").val();
					$.get("unitControl.asp?op=updateItem&nodeID=" + re + "&unitName=" + escape($("#unitName").val()) + "&memo=" + escape($("#memo").val()) + "&address=" + escape($("#address").val()) + "&linker=" + escape($("#linker").val()) + "&times=" + (new Date().getTime()),function(data){
						if(addNew==1){
							where = "unitCode='" + nCode + "'";
							getUnitList();
							alert("保存成功!");
							if(addNewArchives==1){
								$("#addNewArchives").click();
								$('#container-1').triggerTab(2); // show Archives tab
								$("#archiveID").val(hArr[0]);
								$("#name").val(hArr[1]);
								$("#archID").val(hArr[2]);
								if($("#archiveID").val()>"" && $("#lastUnit").val()>""){
									$("#saveArchives").attr("disabled","");
									$("#saveArchives").focus();
								}
							}
						}else{
							alert("保存成功!");
							getNodeInfo(nID,0);
						}
					});
				}
			}
			if(ar[0]==1){
				jAlert("请填写自管标识","信息提示");
			}
			if(ar[0]==2){
				jAlert("组织机构代码错误，请检查","信息提示");
			}
			return false;
		});
		
		$("#addNew").click(function(){
			addNew = 1;
			$.get("commonControl.asp?op=getCurrParam&times=" + (new Date().getTime()),function(data){
				var ar = unescape(data).split("|");
				$("#map").html("当前单位：&nbsp;<font color='orange'>" + "新注册单位" + "</font>");
				$("#unitID").val(0);
				$("#status").val(0);
				$("#unitName").val('新注册单位');
				$("#unitCode").val('');
				$("#period").val(12);
				$("#accountDay").val(parseInt((ar[0]).substring(8)));
				$("#type").val(0);
				$("#price").val(144);
				$("#phone").val('');
				$("#linker").val('');
				$("#address").val('');
				$("#zip").val('');
				$("#email").val('');
				$("#fax").val('');
				$("#credit").val(1);
				$("#locMark").val('');
				$("#regDate").val(ar[0]);
				$("#regOperator").val(ar[1]);
				$("#regOperatorName").val(currUserName);
				$("#contractMark").val(0);
				$("#keepKind").val(0);
				$("#selfMode").val(0);
				$("#memo").val('');
				$("#hasChangeName").hide();
				nID = 0;
				nCode = "";
			});
			setButton();
			if(addNew==1){
				$("#price").attr("readOnly","");
				$("#period").attr("readOnly","");
			}
		});
		
		$("#del").click(function(){
			jConfirm('你确定要删除这个单位吗?', '确认对话框', function(r) {
				if(r){
					jPrompt("请给出删除原因","","信息输入",function(value){
						if(value.length >= 2){
							$.get("unitControl.asp?op=delNode&nodeID=" + $("#unitID").val() + "&where=" + escape(value) + "&times=" + (new Date().getTime()),function(data){
								setUnitEmpty();
								nID = 0;
								nCode = "";
								addNew = 0;
								setButton();
								getUnitList();
							});
						}else{
							jAlert("请认真填写删除原因");
						}
					});
				}
			});
		});
		
		$("#address").blur(function(){
			$("#address").val(dbc2sbc($("#address").val()));
		});
		$("#phone").blur(function(){
			$("#phone").val(dbc2sbc($("#phone").val()));
		});
		$("#zip").blur(function(){
			$("#zip").val(dbc2sbc($("#zip").val()));
		});
		$("#locMark").blur(function(){
			$("#locMark").val(dbc2sbc($("#locMark").val()));
		});
		
		$("#unitCode").blur(function(){
			$("#unitCode").val(dbc2sbc($("#unitCode").val()));
			if($("#unitCode").val() != "" && $("#unitCode").val().length != 9){
				jAlert("组织机构代码应为9位数。","信息提示");
				$("#unitCode").val($("#unitCode").val().substr(0,9));
			}
		});
		
		$("#unitCode").change(function(){
			if($("#unitCode").val()>"" && addNew==1){
				//$("#save").attr("disabled","");
				$.get("unitControl.asp?op=checkUnitCode&nodeID=" + $("#unitID").val() + "&keyID=" + $("#unitCode").val() + "&times=" + (new Date().getTime()),function(re){
					re = unescape(re);
					if(re>""){
						jAlert("<p style='font-size:16px;color:red;'>" + re + "</p>\n已使用这个组织机构代码，不能重复。","信息提示");
						$("#unitCode").val("");
						//addNew = 0;
						//setButton();
						//$("#save").attr("disabled","true");
					}
				});
			}
		});
		
		$("#unitName").change(function(){
			if($("#unitName").val()>"" && addNew==1){
				$.get("unitControl.asp?op=checkUnitNameCode&keyID=" + escape($("#unitName").val()) + "&times=" + (new Date().getTime()),function(re){
					re = unescape(re);
					if(re>""){
						jAlert("<p style='font-size:16px;color:red;'>机构代码：" + re + "</p>\n已有同样名称的单位，请检查。","信息提示");
						$("#unitName").val("");
					}
				});
			}
		});

		$("#type").change(function(){
			if(! checkPermission("regUnit")){
				$("#type").val($("#type_old").val());
				return false;
			}
			if(addNew==1){
				$.get("unitContractControl.asp?op=getPayPrice&keyID=" + $("#type").val() + "&times=" + (new Date().getTime()),function(re){
					$("#price").val(unescape(re));
				});
			}
		});

		$("#selfMode").change(function(){
			if(! checkPermission("regUnit")){
				$("#selfMode").val($("#selfMode_old").val());
				return false;
			}
			if(checkPermission("regUnit") && $("#selfMode").val()>"0" && $("#locMark").val()==""){
				jAlert("请填写自管标识","信息提示");
			}
		});

		$("#status").change(function(){
			if(! checkPermission("regUnit")){
				$("#status").val($("#status_old").val());
				return false;
			}
		});

		$("#keepKind").change(function(){
			if(! checkPermission("regUnit")){
				$("#keepKind").val($("#keepKind_old").val());
				return false;
			}
			dKeepKind = $("#keepKind").val();
			if(dKeepKind==1){
				$("#agent1").hide();
				$("#agent2").hide();
				$("#self1").show();
				$("#addNewContract").hide();
			}else{
				$("#agent1").show();
				$("#agent2").show();
				$("#addNewContract").show();
			}
			if(dKeepKind==0){
				$("#self1").hide();
			}
			if(addNew==0 && $("#keepKind").val() != $("#keepKind_old").val() && $("#keepKind").val()==1){ 	//代管转为自管单位
				jAlert("您准备将代管单位修改为自管","信息提示");
			}
			if(addNew==0 && $("#keepKind").val() != $("#keepKind_old").val() && $("#keepKind").val()==0 && $("#keepKind_old").val()==1){ 	//自管转为代管单位
				jAlert("您准备将自管单位修改为代管","信息提示");
			}
		});
		
    $("#hasChangeName").click(function(){
    	if($("#unitCode").val()>""){
    		showUnitLog($("#unitCode").val(),3);
    	}
    });
		
    $("#unitName").click(function(){
    	if(addNew == 1){
    		$("#unitName").val("");
    	}
    });
		
    $("#btnUnitLog1").click(function(){
    	if($("#unitCode").val()>""){
    		if(showUnitLog($("#unitCode").val(),0)){
					where = "unitCode='" + $("#unitCode").val() + "'";
					getUnitList();
    		}
    	}
    });
		
    $("#btnAgentList").click(function(){
    	if($("#unitCode").val()>""){
				asyncbox.open({
					url:"unitAgentList.asp?nodeID=" + $("#unitCode").val() + "&p=x&times=" + (new Date().getTime()),
					title: '自管档案委托单位列表',
		　　　width : 730,
		　　　height : 650,
		　　　callback : function(action){
		　　　　　if(action == 'close'){
		　　　　　}
		　　　}
				});
    	}
    });

		$("#receiveReNameDoc").click(function(){
			asyncbox.open({
				url:'mergeRenameDocInfo.asp?addNew=1&refID=' + $("#unitCode").val() + '&nodeID=' + $("#unitID").val() + '&name=' + escape($("#unitName").val()) + '&kind=2&p=1&times=' + (new Date().getTime()),
				title: '更名函接收',
	　　　width : 960,
	　　　height : 500,
				btnsbar : $.btn.OKCANCEL,
				callback : function(action,iframe){
					if(action == 'ok'){
						var re = iframe.saveMerge();
						if(re){
							$("#mergeDocKindSelect").val(2);
							where = "unitCode='" + $("#unitCode").val() + "'";
							getUnitList();
							jAlert("保存成功","信息提示");
						}else{
							return false;
						}
　　　　　}
	　　　}
			});
		});

		$("#reNameUnit").click(function(){
			var s = '<div class="comm"><h2>确实要修改单位名称吗？这将引起所有相关记录的变更。</h2></div>';
			s += '<div class="comm">当前名称：' + $("#unitName").val() + '</div>';
			s += '<div class="comm">请输入新的名称：<input type="text" id="newUnitName" size="50" value="" /></div>';
			asyncbox.open({
				html: s,
				title: '单位名称修改',
	　　　width : 380,
	　　　height : 230,
				cover : {
          //透明度
           opacity : 0,
          //背景颜色
           background : '#000'
        },

				btnsbar : $.btn.OKCANCEL,
				callback : function(action){
					if(action == 'ok'){
						$.get("unitControl.asp?op=doRenameUnit&nodeID=" + $("#unitCode").val() + "&where=" + escape($("#newUnitName").val()) + "&times=" + (new Date().getTime()),function(re){
							if(re==0){
								jAlert("单位名称修改成功");
								getNodeInfo(nID,1);
							}
							if(re==1){
								jAlert("新的单位名称不能为空，请核实");
							}
							if(re==2){
								jAlert("新的单位名称在当前系统中已经存在，请核实");
							}
						});
　　　　　}
	　　　}
			});
		});		

		$("#reCodeUnit").click(function(){
			var s = '<div class="comm"><h2>确实要修改单位机构代码吗？这将引起所有相关记录的变更。</h2></div>';
			s += '<div class="comm">当前机构代码：' + $("#unitCode").val() + '</div>';
			s += '<div class="comm">请输入新的代码：<input type="text" id="newUnitCode" size="50" value="" /></div>';
			asyncbox.open({
				html: s,
				title: '组织机构代码修改',
	　　　width : 380,
	　　　height : 230,
				cover : {
          //透明度
           opacity : 0,
          //背景颜色
           background : '#000'
        },

				btnsbar : $.btn.OKCANCEL,
				callback : function(action){
					if(action == 'ok'){
						$.get("unitControl.asp?op=doReCodeUnit&nodeID=" + $("#unitCode").val() + "&where=" + escape($("#newUnitCode").val()) + "&times=" + (new Date().getTime()),function(re){
							if(re==0){
								jAlert("组织机构代码修改成功");
								getNodeInfo(nID,1);
							}
							if(re==1){
								jAlert("新的组织机构代码不能为空，请核实");
							}
							if(re==2){
								jAlert("新的组织机构代码在当前系统中已经存在，请核实");
							}
						});
　　　　　}
	　　　}
			});
		});		
		