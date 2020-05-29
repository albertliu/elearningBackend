<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = "";
	var op = 0;
	var updateCount = 0;
	var cStreet = 0;
	var cItemsR = "unitCode|unitName|regTime|openDate|regNo|regFund|regAddress|bank0|accountBank0|accountTitle0|bank1|accountBank1|accountTitle1|bank2|accountBank2|accountTitle2|accountTax";
	cItemsR += "|kind|park|mainKind|street";
	var cItemsM = "unitCode|unitName|regTime|openDate|regAddress";
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = <%=op%>;

		getDicList("status","",0);
		getComList("park","parkInfo","parkID","parkName","status=0",1);
		getComList("street","streetInfo","streetNo","streetName","status=0",1);
		getDicList("unitKind","kind",0);
		getDicList("unitType","type",0);
		getDicList("mainKind","",1);
		getDicList("yesno","restruction",0);
		getDicList("yesno","helpOpen",0);
		//getComList("subKind","subKindInfo","subKindID","subKindName","refID="+$("#mainKind").val(),1);
		
		$("#regTime").click(function(){WdatePicker();});
		$("#openDate").click(function(){WdatePicker();});
		$("#parkDate").click(function(){WdatePicker();});
    $.ajaxSetup({ 
  		async: false 
  	}); 
  	$("#img_pass0").hide();
  	$("#img_pass1").hide();
  	$("#img_pass2").hide();
		if(op==1){
			setButton();
			$("#unitID").val(nodeID);
	  	cStreet = getUserStreet(currUser);
	  	if(cStreet>0){
	  		$("#street").val(cStreet);
	  		$("#street").attr("disabled",true);
	  	}
		}
		if(op!=1){
			getNodeInfo(nodeID);
		}

		$("#addNew").click(function(){
			op = 1;
			setButton();
		});

		$("#unitName").change(function(){
			$("#accountTitle0").val($("#unitName").val());
			$("#accountTitle2").val($("#unitName").val());
		});

		$("#regTime").blur(function(){
			if($("#regTime").val()>"" && $("#openDate").val()==""){
				$("#openDate").val($("#regTime").val());
			}
		});

		$("#fnMemo").click(function(){
			setSession("ar_memoList",$("#unitID").val() + "|unit|1");
			showMemoList($("#unitID").val(),1);
		});

		$("#btnPickBoss").click(function(){
			var id = 0;
			if($("#bossID").val()=="" && (checkPermission("unitEditN",cStreet) || checkPermission("unitEditS",0))){
				id = 1;
			}
			setSession("boss","bossID|bossName");
			showBossInfo($("#bossID").val(),$("#unitID").val(),id,2);
		});

		$("#fnAttachFile").click(function(){
			setSession("ar_attachDocList",$("#unitID").val() + "|unit");
			showAttachDocList($("#unitID").val(),"unit",1);
		});

		$("#fnEmployeeFunds").click(function(){
			showEmployeeFundsList(0,$("#unitID").val(),"","",0);
		});
		//账号需要验证一次
		$("#accountBank0").change(function(){
			checkAccount(0);
		});
		$("#accountBank1").change(function(){
			checkAccount(1);
		});
		$("#accountBank2").change(function(){
			checkAccount(2);
		});

		$("#unitCode").blur(function(){
			var id = $("#unitCode").val();

			if(id > ""){
				$.get("unitControl.asp?op=checkID&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
					//alert(re);
					if(re == 0){
						//
					}
					if(re == 1){
						jAlert("组织机构代码应为9位，请检查。","信息提示");
					}
					if(re == 2){
						op = 0;
						getNodeInfo(id);
						jAlert("该单位已经存在!","信息提示");
					}
				});
			}
		});

		$("#save").click(function(){
			//alert($("#unitID").val() + "&unitCode=" + $("#unitCode").val() + "&unitName=" + ($("#unitName").val()) + "&regNo=" + ($("#regNo").val()) + "&kindID=" + $("#kind").val() + "&keyID=" + $("#type").val() + "&park=" + $("#park").val() + "&street=" + $("#street").val() + "&mainKind=" + $("#mainKind").val() + "&subKind=" + $("#subKind").val() + "&restruction=" + $("#restruction").val() + "&helpOpen=" + $("#helpOpen").val() + "&regFund=" + $("#regFund").val() + "&regTime=" + $("#regTime").val() + "&openDate=" + $("#openDate").val() + "&bossID=" + $("#bossID").val() + "&regAddress=" + ($("#regAddress").val()) + "&linker=" + ($("#linker").val()) + "&phone=" + ($("#phone").val()) + "&email=" + ($("#email").val()) + "&address=" + ($("#address").val()) + "&bank0=" + ($("#bank0").val()) + "&bank1=" + ($("#bank1").val()) + "&bank2=" + ($("#bank2").val()) + "&accountBank0=" + ($("#accountBank0").val()) + "&accountBank1=" + ($("#accountBank1").val()) + "&accountBank2=" + ($("#accountBank2").val()) + "&accountTitle0=" + ($("#accountTitle0").val()) + "&accountTitle1=" + ($("#accountTitle1").val()) + "&accountTitle2=" + ($("#accountTitle2").val()) + "&accountTax=" + ($("#accountTax").val()) + "&memo=" + ($("#memo").val()) + "&regOperator=" + ($("#regOperator").val()));
			$.get("unitControl.asp?op=update&nodeID=" + $("#unitID").val() + "&unitCode=" + $("#unitCode").val() + "&unitName=" + escape($("#unitName").val()) + "&status=" + $("#status").val() + "&regNo=" + escape($("#regNo").val()) + "&kindID=" + $("#kind").val() + "&type=" + $("#type").val() + "&park=" + $("#park").val() + "&parkDate=" + $("#parkDate").val() + "&street=" + $("#street").val() + "&mainKind=" + $("#mainKind").val() + "&subKind=" + $("#subKind").val() + "&restruction=" + $("#restruction").val() + "&helpOpen=" + $("#helpOpen").val() + "&regFund=" + $("#regFund").val() + "&regTime=" + $("#regTime").val() + "&openDate=" + $("#openDate").val() + "&bossID=" + $("#bossID").val() + "&regAddress=" + escape($("#regAddress").val()) + "&linker=" + escape($("#linker").val()) + "&phone=" + escape($("#phone").val()) + "&email=" + escape($("#email").val()) + "&address=" + escape($("#address").val()) + "&bank0=" + escape($("#bank0").val()) + "&bank1=" + escape($("#bank1").val()) + "&bank2=" + escape($("#bank2").val()) + "&accountBank0=" + escape($("#accountBank0").val()) + "&accountBank1=" + escape($("#accountBank1").val()) + "&accountBank2=" + escape($("#accountBank2").val()) + "&accountTitle0=" + escape($("#accountTitle0").val()) + "&accountTitle1=" + escape($("#accountTitle1").val()) + "&accountTitle2=" + escape($("#accountTitle2").val()) + "&accountTax=" + escape($("#accountTax").val()) + "&memo=" + escape($("#memo").val()) + "&regOperator=" + escape($("#regOperator").val()) + "&times=" + (new Date().getTime()),function(re){
				//jAlert(unescape(re));
				var ar = new Array();
				ar = unescape(re).split("|");
				if(ar[0] == 0){
					getNodeInfo(ar[1]);
					jAlert("保存成功!","信息提示");
					if(op==1){	//新增
						op = 0;
					}
					updateCount += 1;
				}
				if(ar[0] == 1){
					jAlert("组织机构代码不能为空。","信息提示");
					$("#unitCode").focus();
				}
				if(ar[0] == 2){
					jAlert("单位名称不能为空。","信息提示");
					$("#unitName").focus();
				}
				if(ar[0] == 3){
					jAlert("必须填写联系人。","信息提示");
					$("#linker").focus();
				}
				if(ar[0] == 4){
					jAlert("必须填写单位地址。","信息提示");
					$("#address").focus();
				}
				if(ar[0] == 5){
					jAlert("必须填写联系电话。","信息提示");
					$("#phone").focus();
				}
				if(ar[0] == 6){
					jAlert("该单位已经存在，请核实。","信息提示");
					getNodeInfo(ar[1]);
				}
			});
			return false;
		});

		$("#del").click(function(){
			jConfirm('你确定要删除这个单位吗?', '确认对话框', function(r) {
				if(r){
					$.get("unitControl.asp?op=delNode&nodeID=" + $("#unitID").val() + "&times=" + (new Date().getTime()),function(data){
						jAlert("删除成功！","信息提示");
						op = 1;
						setButton();
						updateCount += 1;
					});
				}
			});
		});
		
  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		//alert(id);
		$.get("unitControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#unitID").val(ar[0]);
				$("#unitName").val(ar[1]);
				$("#status").val(ar[2]);
				$("#unitCode").val(ar[4]);
				$("#regNo").val(ar[5]);
				$("#kind").val(ar[6]);
				$("#park").val(ar[8]);
				$("#street").val(ar[10]);
				cStreet = ar[10];
				$("#mainKind").val(ar[12]);
				$("#subKind").val(ar[14]);
				$("#restruction").val(ar[16]);
				$("#helpOpen").val(ar[18]);
				$("#regFund").val(ar[20]);
				$("#regTime").val(ar[21]);
				$("#regAddress").val(ar[22]);
				$("#openDate").val(ar[23]);
				$("#bossID").val(ar[24]);
				$("#bossName").val(ar[25]);
				$("#address").val(ar[26]);
				$("#linker").val(ar[27]);
				$("#phone").val(ar[28]);
				$("#email").val(ar[29]);
				$("#bank0").val(ar[30]);
				$("#bank1").val(ar[31]);
				$("#bank2").val(ar[32]);
				$("#accountBank0").val(ar[33]);
				$("#accountBank1").val(ar[34]);
				$("#accountBank2").val(ar[35]);
				$("#accountTitle0").val(ar[36]);
				$("#accountTitle1").val(ar[37]);
				$("#accountTitle2").val(ar[38]);
				$("#accountTax").val(ar[39]);
				$("#memo").val(ar[40]);
				$("#regDate").val(ar[41]);
				$("#regOperator").val(ar[42]);
				$("#registorName").val(ar[43]);
				$("#parkDate").val(ar[44]);
				$("#fxAttachFile").val(ar[45]);
				$("#fxEmployeeFunds").val(ar[46]+"/"+ar[47]);
				getUnitStat(ar[0]);
				getDownloadFile("unitID");
			}else{
				jAlert("该单位信息未找到！","信息提示");
				setEmpty();
			}
			op = 0;
			setButton();
		});
	}

	function getUnitStat(id){
		$.get("unitControl.asp?op=getUnitStat&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			var ar = new Array();
			ar = unescape(re).split("%%");
			//jAlert(ar);
			if(ar>""){
				//var s = "";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					//s = "<a href='javascript:void();'>" + ar1[1] + "&nbsp;&nbsp;&nbsp;&nbsp;" + s + "</a>";
					$("#c_" + ar1[0]).html(ar1[1]);
				});
			}
		});
	}

	function checkAccount(id){
		if($("#accountBank" + id).val()>""){
			asyncbox.prompt("重复验证","账号很重要","请再输一次","text",function(action,val){
	　　　if(action == 'ok'){
					if($("#accountBank" + id).val()==val){
						//显示对勾三秒钟
						$("#img_pass" + id).show();
						$("#img_pass" + id).delay(3000).hide(0);
					}else{
						jAlert("两次输入不一致，请重新输入。");
						$("#accountBank" + id).val("");
					}
				}else{
					$("#accountBank" + id).val("");
				}
			});
		}
	}

	function setButton(){
		$("#status").attr("disabled",true);
		$("#btnLinker").hide();
		$("#addNew").hide();
		$("#save").hide();
		$("#del").hide();
		$("#btnLoadFile").attr("disabled",true);
		$("#fnModify").attr("disabled",true);
		//$("#fnMemo").attr("disabled",true);
		$("#fnWorklog").attr("disabled",true);
		if(op ==1){
			setEmpty();
			$("#unitCode").attr("readOnly",false);
			$("#unitCode").attr("class","mustFill");
			$("#save").show();
			$("#del").hide();
			$("#btnLoadFile").attr("disabled",true);
			$("#unitName").focus();
		}
		if(op ==0){
			if(checkPermission("unitEditS",0)){
				$("#save").show();
				$("#del").show();
				$("#btnPickBoss").show();
				$("#btnLoadFile").attr("disabled",false);
			}
			//alert(checkPermission("unitEditN",cStreet));
			if(checkPermission("orderCheck1",cStreet)){
				setObjReadOnly(cItemsR,1,1);
				$("#save").show();
				$("#btnPickBoss").show();
				$("#btnLoadFile").attr("disabled",false);
			}
			if(checkPermission("unitAdd",0)){
				$("#addNew").show();
			}
		}
	}
	
	function setEmpty(){
		$("#unitID").val(0);
		$("#unitCode").val("");  //new item
		$("#status").val(0);
		$("#unitName").val("");
		$("#regNo").val("");
		$("#openDate").val("");
		$("#regTime").val("");
		$("#regFund").val(0);
		$("#restruction").val(0);
		$("#helpOpen").val(0);
		$("#mainKind").val(0);
		$("#subKind").val(0);
		$("#address").val("");
		$("#email").val("");
		$("#linker").val("");
		$("#phone").val("");
		$("#park").val("99");
		$("#parkDate").val("");
		$("#bank0").val("");
		$("#accountBank0").val("");
		$("#accountTitle0").val("");
		$("#bank1").val("");
		$("#accountBank1").val("");
		$("#accountTitle1").val("");
		$("#bank2").val("");
		$("#accountBank2").val("");
		$("#accountTitle2").val("");
		$("#accountTax").val("");
		$("#regAddress").val("");
		$("#street").val(0);
		$("#kind").val(0);
		$("#memo").val("");
		$("#regDate").val(currDate);
		$("#regOperator").val(currUser);
		$("#registorName").val(currUserName);
		$("#downloadFile_unitID").html("");
		setObjReadOnly(cItemsR,0,0);
		setObjMustFill(cItemsM,1);
	}
	
	function getUnitCode(){
		return $("#unitID").val();
	}
	
	function getUpdateCount(){
		return updateCount;
	}
	//style="background:#FFAAFF#00EE00"
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
				<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
					<table>
          <tr>
          	<td align="right">单位名称</td><input id="unitID" type="hidden" />
          	<td><input class="mustFill" type="text" id="unitName" name="unitName" size="24" /></td>
          	<td align="right">&nbsp;&nbsp;机构代码</td>
          	<td><input class="mustFill" type="text" id="unitCode" name="unitCode" size="20" /></td>
          	<td align="right">注册证书</td>
          	<td><input type="text" id="regNo" name="bank" size="20" /></td>
          </tr>
          <tr>
          	<td align="right">&nbsp;&nbsp;税号</td>
          	<td><input class="mustFill" type="text" id="accountTax" name="accountTax" size="20" /></td>
          	<td align="right">单位性质</td>
          	<td><select id="kind" name="kind" style="width:100px"></select></td>
          	<td align="right">&nbsp;&nbsp;法人代表</td><input id="bossID" type="hidden" />
          	<td><input class="readOnly" type="text" id="bossName" name="bossName" size="12" readOnly="true" />
          		<input type="button"  style="width:19px;background-image: url('images/find.png')" id="btnPickBoss" value="" /></td>
          </tr>
          <tr>
          	<td align="right">联系人</td><input id="email" type="hidden" />
          	<td><input type="text" id="linker" size="24" />
          	<td align="right">联系电话</td>
          	<td><input class="mustFill" type="text" id="phone" size="20" /></td>
          	<td align="right">注册资本</td>
          	<td><input type="text" id="regFund" size="8" />万元</td>
          </tr>
          <tr>
          	<td align="right">注册地址</td>
          	<td><input type="text" id="regAddress" size="24" /></td>
          	<td align="right">经营地址</td>
          	<td><input type="text" id="address" size="20" />
          	<td align="right" colspan="2">开业日期
          	<input type="text" id="openDate" size="7" />
          	注册日期<input type="text" id="regTime" size="7" /></td>
          </tr>
          <tr>
          	<td align="right">所属园区</td>
          	<td><select id="park" name="park" style="width:140px"></select></td>
          	<td align="right">所属街道</td>
          	<td><select id="street" name="street" style="width:140px"></select></td>
          	<td align="right">入园日期</td>
          	<td><input type="text" id="parkDate" size="20" /></td>
          </tr>
          <tr>
          	<td align="right">行业大类</td><input id="subKind" type="hidden" />
          	<td><select id="mainKind" name="mainKind" style="width:140px"></select></td>
          	<td align="right">是否帮创</td><input id="restruction" type="hidden" />
          	<td><select id="helpOpen" name="helpOpen" style="width:50px"></select></td>
          	<td align="right">企业类型</td>
          	<td><select id="type" name="type" style="width:100px"></select></td>
          </tr>
          <tr>
          	<td align="right">公司账号</td>
          	<td><input type="text" id="accountTitle0" name="accountTitle0" size="24" /></td>
          	<td align="right">开户银行</td>
          	<td><input type="text" id="bank0" name="bank0" size="20" /></td>
          	<td align="right">银行账号</td>
          	<td><input type="text" id="accountBank0" name="accountBank0" size="20" /><img id="img_pass0" src="images/green_check.png" border="0" width="16" /></td>
          </tr>
          <tr>
          	<td align="right">社保账号</td>
          	<td><input type="text" id="accountTitle2" name="accountTitle2" size="24" /></td>
          	<td align="right">开户银行</td>
          	<td><input type="text" id="bank2" name="bank2" size="20" /></td>
          	<td align="right">银行账号</td>
          	<td><input type="text" id="accountBank2" name="accountBank2" size="20" /><img id="img_pass2" src="images/green_check.png" border="0" width="16" /></td>
          </tr>
          <tr>
          	<td align="right">个人账号</td>
          	<td><input type="text" id="accountTitle1" name="accountTitle1" size="24" /></td>
          	<td align="right">开户银行</td>
          	<td><input type="text" id="bank1" name="bank1" size="20" /></td>
          	<td align="right">银行账号</td>
          	<td><input type="text" id="accountBank1" name="accountBank1" size="20" /><img id="img_pass1" src="images/green_check.png" border="0" width="16" /></td>
          </tr>
          <tr>
          </tr>
          </tr>
          	<td align="right">备注</td>
          	<td colspan="5"><textarea id="memo" name="memo" style="padding:2px;" rows="2" cols="82"/></textarea></td>
          <tr>
          <tr>
          	<td align="right">状态</td>
          	<td><select id="status" name="status" style="width:100px"></select></td>
          	<td align="right">录入日期</td>
          	<td><input class="readOnly" type="text" id="regDate" name="regDate" size="20" readOnly="true" /></td>
          	<td align="right">录入人</td><input type="hidden" id="regOperator" name="regOperator" />
          	<td><input class="readOnly" type="text" id="registorName" name="registorName" size="20" readOnly="true" /></td>
          </tr>
          <tr>
          	<td><input class="button" id="fnAttachFile" type="button" value="材料列表" /></td>
          	<td><input class="readOnly" readOnly="true" type="text" id="fxAttachFile" size="13" /></td>
          	<td><input class="button" id="fnEmployeeFunds" type="button" value="缴金情况" /></td>
          	<td><input class="readOnly" readOnly="true" type="text" id="fxEmployeeFunds" size="13" /></td>
          	<td>&nbsp;</td>
          	<td>&nbsp;</td>
          </tr>
        	</table>
				</form>
			</div>
		</div>
	</div>
	
	<div style="width:99%;float:left;margin:10;height:4px;"></div>
  <div align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" value="保存" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="addNew" value="新增" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="del" value="删除" />
  </div>
	<div style="width:99%;float:left;margin:10;height:4px;"></div>
  
	<div style="width:99%;float:left;margin:10;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
				<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#f5faa0;">
					<table>
          <tr>
          	<td align="right"><input class="button" type="button" id="fnModify" value="信息变更" /></td>
          	<td colspan="2" style="background:#EEEEEE;padding:0px 5px;width:42%;"><div id="c_modify"><font color="gray">暂无内容</></div></td>
          	<td align="right">&nbsp;&nbsp;<input class="button" type="button" id="fnWorklog" value="跟踪记录" /></td>
          	<td colspan="2" style="background:#EEEEEE;padding:0px 5px;width:42%;"><div id="c_worklog"><font color="gray">暂无内容</></div></td>
          </tr>
          <tr>
          	<td align="right"><input class="button" type="button" id="fnMemo" value="备忘录" /></td>
          	<td colspan="2" style="background:#EEEEEE;padding:0px 5px;width:42%;"><div id="c_memo"><font color="gray">暂无内容</></div></td>
          	<td align="right">开办费</td>
          	<td colspan="2" style="background:#EEEEEE;padding:0px 5px;width:42%;"><div id="c_order1"><font color="gray">暂无内容</></div></td>
          </tr>
          <tr>
          	<td align="right">启动金</td>
          	<td colspan="2" style="background:#EEEEEE;padding:0px 5px;width:42%;"><div id="c_order2"><font color="gray">暂无内容</></div></td>
          	<td align="right">社保补贴</td>
          	<td colspan="2" style="background:#EEEEEE;padding:0px 5px;width:42%;"><div id="c_order5"><font color="gray">暂无内容</></div></td>
          </tr>
          <tr>
          	<td align="right">市房补</td>
          	<td colspan="2" style="background:#EEEEEE;padding:0px 5px;width:42%;"><div id="c_order3"><font color="gray">暂无内容</></div></td>
          	<td align="right">区房补</td>
          	<td colspan="2" style="background:#EEEEEE;padding:0px 5px;width:42%;"><div id="c_order4"><font color="gray">暂无内容</></div></td>
          </tr>
        	</table>
				</form>
			</div>
		</div>
</div>
</body>
