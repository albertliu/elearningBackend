
	function getUnitList(){
		//alert("where=" + (where));
		var i = 0;
		$.get("unitControl.asp?op=getUnitListByWhere&where=" + escape(where) + "&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//alert(unescape(data));
			$("#unitCover").empty();
			//alert(ar);
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			var col = "标准";
			if(spUnitItem == "contractMark"){col = "合同";}
			if(spUnitItem == "lastOpDate"){col = "最后操作";}
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='unitTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='44%'>单位名称</th>");
			arr.push("<th width='18%'>" + col + "</th>");
			arr.push("<th width='12%'>档案</th>");
			arr.push("<th width='14%'>欠费</th>");
			arr.push("<th width='12%'>催单</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var c = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					nID = ar1[0];
					c = 0;
					if(ar1[9] > 0){c = 2;}
					if(ar1[10] > 0){c = 1;}
					if(ar1[1] > 0){c = 1;}
					var s = "";
					if(ar1[1]>0){
						s = "(已关闭)";
					}
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='link1'><a href='javascript:getNodeInfo(\"" + ar1[0] + "\",0);'>" + ar1[2] + s + "</a></td>");
					if(spUnitItem == "contractMark"){
						arr.push("<td class='left'>" + ar1[11] + "</td>");
					}
					if(spUnitItem == "lastOpDate"){
						arr.push("<td class='left'>" + ar1[12] + "</td>");
					}
					if(spUnitItem == ""){
						arr.push("<td class='left'>" + ar1[7] + "</td>");
					}
					arr.push("<td class='center'>" + nullNoDisp(ar1[5]) + "</td>");
					arr.push("<td class='center'>" + nullNoDisp(ar1[9]) + "</td>");
					arr.push("<td class='center'>" + nullNoDisp(ar1[10]) + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#unitCover").html(arr.join(""));
			arr = [];
			$('#unitTab').dataTable({
				"aaSorting": [],
				"aLengthMenu": [[15, 25, 50, -1], [15, 25, 50, "All"]]
			});
			if(fixPage==0){
				if(changeUnitByNewArch == 0){
					$('#container-1').triggerTab(1); // show unitList tab
				}
				if(i==1){
					getNodeInfo(nID,0);
				}
			}
			fixPage = 0;
			spUnitItem = "";
		});
		return i;
	}

	function getNodeInfo(nodeID,mark){
		if(nodeID==0){
			jAlert("暂时没有该单位的信息。","系统提示");
		}else{
			$.get("unitControl.asp?op=getNodeInfo&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
				//alert(unescape(re));
				var ar = new Array();
				ar = unescape(re).split("|");
				if(ar.length > 0){
					$("#map").html("当前单位：&nbsp;<font color='orange'>" + ar[2] + "</font>");
					$("#unitID").val(ar[0]);
					$("#status").val(ar[1]);
					unitStatus = ar[1];
					$("#status_old").val(ar[1]);
					$("#unitName").val(ar[2]);
					$("#unitCode").val(ar[3]);
					$("#period").val(ar[4]);
					$("#type").val(ar[5]);
					$("#type_old").val(ar[5]);
					$("#price").val(ar[6]);
					$("#phone").val(ar[7]);
					$("#linker").val(ar[8]);
					$("#address").val(ar[9]);
					$("#zip").val(ar[10]);
					$("#email").val(ar[11]);
					$("#fax").val(ar[12]);
					$("#credit").val(ar[13]);
					$("#locMark").val(ar[14]);
					$("#regDate").val(ar[15]);
					$("#regOperator").val(ar[16]);
					$("#memo").val(ar[17]);
					$("#regOperatorName").val(ar[18]);
					$("#contractMark").val(ar[19]);
					$("#currContract").val(ar[20]);
					$("#keepKind").val(ar[21]);
					$("#keepKind_old").val(ar[21]);
					$("#selfMode").val(ar[24]);
					$("#selfMode_old").val(ar[24]);
					$("#unitOldID").val(nullNoDisp(ar[26]));
					getDownloadFile2("contractID",ar[27],"contractFile");
					if(ar[23]>0){		//有更名记录
						$("#hasChangeName").val("更名 " + ar[23] + " 次");
						$("#hasChangeName").show();
					}else{
						$("#hasChangeName").hide();
					}
					nID = ar[0];
					nCode = ar[3];
					dKeepKind = ar[21];
					addNew = 0;
					$("#agent1").show();
					$("#agent2").show();
					$("#self1").show();
					if(dKeepKind==0){
						$("#searchArchivesType0").attr("disabled","");
						$("#searchArchivesType1").attr("disabled","true");
						$("#searchArchivesType0").attr("checked","ture");
						$("#self1").hide();
					}
					if(dKeepKind==1){
						$("#searchArchivesType1").attr("disabled","");
						$("#searchArchivesType0").attr("disabled","true");
						$("#searchArchivesType1").attr("checked","ture");
						$("#agent1").hide();
						$("#agent2").hide();
					}
					if(dKeepKind==2){
						$("#searchArchivesType0").attr("disabled","");
						$("#searchArchivesType1").attr("disabled","");
						$("#searchArchivesType0").attr("checked","ture");
					}
					if(mark == 0){
						//mark = 0表示需要更新该单位所有相关的信息显示  否则只更新基本信息
						$.get("commonControl.asp?op=setSession&sName=curUnit&anyStr=" + escape(ar[0]) + "&times=" + (new Date().getTime()),function(data){
						});
						$("#refID").val(ar[0]);
						$("#contractRefID").val(ar[0]);
						$("#archiveRefID").val(ar[0]);
						$("#archiveRefCode").val(ar[3]);
						refreshUnit();
						//alert(3);
						setButton();
					}
				}
			});
		}
	}

	function getUnitStatInfo(nodeID){
		if(nodeID>""){
			$.get("unitControl.asp?op=getUnitStatInfo&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
				var ar = new Array();
				ar = unescape(re).split(",");
				for (i = 0; i < ar.length; i++){
					var ar1 = new Object();
					ar1 = ar[i].split("|");
					$("#" + ar1[0]).html(nullNoDisp(ar1[1]));
					if(ar1[0]=="contractMarkAlert"){
						if(ar1[1]=="已签订"){
							$("#" + ar1[0]).attr("class","");
						}else{
							$("#" + ar1[0]).attr("class","redAlert");
						}
					}
					if(ar1[0]=="noticeAlert"){
						setNoticeTab(ar1[1]);
					}
				}
				if(dKeepKind==1){
					$("#contractMarkAlert").html("自管");
				}
			});
			
			getStoreCountByUnit();
		}
	}

	function getAlertUnitCount(){
		$.get("unitControl.asp?op=getAlertUnitCount&times=" + (new Date().getTime()),function(re){
			var ar = new Array();
			ar = unescape(re).split(",");
			for (i = 0; i < ar.length; i++){
				var ar1 = new Object();
				ar1 = ar[i].split("|");
				$("#" + ar1[0]).html(nullNoDisp(ar1[1]));
			}
		});
	}
	
	function getTypeList(){
		$.get("commonControl.asp?op=getDicList&keyID=unitType&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split(",");
			//alert(ar);
			$("#type").empty();
			$("#unitType").empty();
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#type");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#unitType");
				});
			}
		});
	}
	function getStatusList(){
		$.get("commonControl.asp?op=getDicList&keyID=unitStatus&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split(",");
			//alert(ar);
			$("#status").empty();
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#status");
				});
			}
		});
	}

	function checkFormUnit()
	{
		var re = true;
		if($("#unitName").val() == ""){
			$("#unitName").focus();
			re = false;
			alert("单位名称不能为空");
			return false;
		}
		if($("#unitCode").val() == "" || $("#unitCode").val() == null){
			$("#unitCode").focus();
			re = false;
			//alert("组织机构代码不能为空!");
		}
		if($("#price").val() < "0"){
			$("#price").focus();
			re = false;
			alert("收费标准必须大于0!");
		}
		if($("#period").val() < "0"){
			$("#period").focus();
			re = false;
			alert("缴费周期必须大于0!");
		}
		return re;  
	}

	function setUnitEmpty(){
		$("#map").html("当前单位：&nbsp;<font color='orange'>&nbsp;</font>");
		$("#unitID").val(0);
		$("#unitOldID").val(0);
		$("#status").val(0);
		$("#unitName").val('');
		$("#unitCode").val('');
		$("#period").val('');
		$("#accountDay").val('');
		$("#type").val(0);
		$("#price").val('');
		$("#phone").val('');
		$("#linker").val('');
		$("#address").val('');
		$("#zip").val('');
		$("#email").val('');
		$("#fax").val('');
		$("#credit").val(1);
		$("#locMark").val('');
		$("#regDate").val('');
		$("#regOperator").val('');
		$("#regOperatorName").val('');
		$("#contractMark").val(0);
		$("#keepKind").val(0);
		$("#selfMode").val(0);
		$("#memo").val('');
		$("#unitOldID").val('');
		$("#hasChangeName").hide();
		$("#receiveReNameDoc").hide();
	}