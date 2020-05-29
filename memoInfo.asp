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
<link href="css/data_table.css" rel="stylesheet" type="text/css" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = "";
	var refID = 0;
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";	//unitID
		op = "<%=op%>";

		getDicList("memoKind","kindID",0);
		getDicList("private","",0);
		getDicList("holiday","",0);
		$("#keyDate").click(function(){WdatePicker();});
		$("#div2").hide();

		if(op==1){
			$("#private").val(0);
			$("#keyDate").val(currDate);
			setButton();
		}
		if(op!=1){
			getNodeInfo(nodeID);
		}
		
		$("#kindID").change(function(){
			$("#div1").show();
			$("#div2").hide();
			$("#private").attr("disabled",false);
			if($("#kindID").val()==1){
				$("#private").val(1);
			}
			if($("#kindID").val()==3){	//节假日
				if(checkPermission("HA",0)){
					$("#private").val(1);
					$("#private").attr("disabled",true);
					$("#div2").show();
					$("#div1").hide();
				}else{
					jAlert("没有法定节假日操作权限。");
					$("#kindID").val(0);
				}
			}
		});

		$("#save").click(function(){
			saveNode("");
		});

		$("#close").click(function(){
			saveNode(1);
		});

		$("#addNew").click(function(){
			op = 1;
			setButton();
		});

		$("#del").click(function(){
			jConfirm('你确定要删除这个条目吗?', '确认对话框', function(r) {
				if(r){
					$.get("memoControl.asp?op=delNode&nodeID=" + $("#memoID").val() + "&times=" + (new Date().getTime()),function(data){
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
		$.get("memoControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#memoID").val(ar[0]);
				$("#item").val(ar[1]);
				$("#status").val(ar[2]);
				$("#statusName").val(ar[3]);
				$("#keyDate").val(ar[4]);
				$("#alertDays").val(ar[5]);
				$("#kindID").val(ar[6]);
				$("#memo").val(ar[8]);
				$("#regDate").val(ar[9]);
				$("#regOperator").val(ar[10]);
				$("#registorName").val(ar[11]);
				$("#private").val(ar[13]);
				$("#holiday").val(ar[15]);
				if(ar[6]==3){
					$("#div2").show();
					$("#div1").hide();
				}else{
					$("#div1").show();
					$("#div2").hide();
				}
				getDownloadFile("memoID");
				setButton();
			}else{
				jAlert("该备忘录信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(status){
		if(status==""){
			status = $("#status").val();
		}
		//alert($("#memoID").val() + "&item=" + ($("#item").val()) + "&status=" + status + "&keyDate=" + $("#keyDate").val() + "&alertDays=" + $("#alertDays").val() + "&kindID=" + $("#kindID").val() + "&unitID=" + $("#unitID").val() + "&private=" + $("#private").val() + "&holiday=" + $("#holiday").val() + "&regDate=" + $("#regDate").val() + "&regOperator=" + ($("#regOperator").val()));
		$.get("memoControl.asp?op=update&nodeID=" + $("#memoID").val() + "&item=" + escape($("#item").val()) + "&status=" + status + "&keyDate=" + $("#keyDate").val() + "&alertDays=" + $("#alertDays").val() + "&kindID=" + $("#kindID").val() + "&private=" + $("#private").val() + "&holiday=" + $("#holiday").val() + "&memo=" + escape($("#memo").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + escape($("#regOperator").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("保存成功!","信息提示");
				if(op==1){	//新增
					op = 0;
				}
				updateCount += 1;
				getNodeInfo(ar[1]);
			}
			if(ar[0] == 2){
				jAlert("项目名称不能为空。","信息提示");
				$("#item").focus();
			}
		});
		return false;
	}
	
	function setButton(){
		//alert(op + ":" + $("#regOperator").val() + ":" + $("#memoID").val());
		$("#status").attr("disabled",true);
		$("#kindID").attr("disabled",true);
		$("#close").hide();
		if(op ==1){
			setEmpty();
			$("#save").show();
			$("#del").hide();
			$("#btnLoadFile").attr("disabled",true);
			$("#kindID").attr("disabled",false);
			$("#item").focus();
		}
		if(op ==0){
			if($("#regOperator").val() == currUser && $("#memoID").val()>0 && $("#status").val()==0){
				$("#save").show();
				$("#del").show();
				$("#close").show();
				$("#kindID").attr("disabled",false);
				$("#btnLoadFile").attr("disabled",false);
			}else{
				$("#save").hide();
				$("#del").hide();
				$("#btnLoadFile").attr("disabled",true);
			}
		}
	}
	
	function setEmpty(){
		$("#memoID").val(0);
		$("#status").val(0);
		$("#statusName").val("活动");
		$("#item").val("");
		//$("#kindID").val("");
		//$("#keyDate").val(currDate);
		$("#alertDays").val(1);
		$("#memo").val("");
		$("#regDate").val(currDate);
		$("#regOperator").val(currUser);
		$("#registorName").val(currUserName);
		$("#downloadFile_memoID").html("");
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
 <!--#include file='commLoadFileDetail.asp' -->
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
				<form id="detailCover" name="detailCover" style="width:100%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
					<table>
          <tr>
          	<td>类型</td>
          	<td><select id="kindID" style="width:100px"></select></td>
          	<td>标记日期</td>
          	<td><input type="text" id="keyDate" size="15" /></td>
          	<td colspan="2"><input id="alertDays" type="hidden" />
          		<div id="div1">&nbsp;</div>
          		<div id="div2">标记&nbsp;<select id="holiday" style="width:100px"></select></div>
          	</td>
          </tr>
          <tr>
          	<td>标题</td><input id="memoID" type="hidden" />
          	<td colspan="3"><input class="mustFill" type="text" id="item" size="55" /></td>
          	<td>&nbsp;状态</td><input id="status" type="hidden" />
          	<td><input class="readOnly" type="text" id="statusName" size="8" readOnly="true" /></td>
          </tr>
          <tr>
          	<td>范围</td>
          	<td><select id="private" style="width:100px"></select></td>
          </tr>
          <tr>
          	<td>内容</td>
          	<td colspan="5"><textarea id="memo" style="padding:2px;" rows="5" cols="80"/></textarea></td>
          </tr>
          <tr>
          	<td>登记日期</td>
          	<td><input class="readOnly" type="text" id="regDate" size="15" readOnly="true" /></td>
          	<td>登记人</td><input type="hidden" id="regOperator" />
          	<td><input class="readOnly" type="text" id="registorName" size="15" readOnly="true" /></td>
          	<td>&nbsp;</td>
          	<td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="6">
							<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#AAAAFF;line-height:18px;">
								<span style="padding-left:10px;"><input class="button" id="btnLoadFile" onClick="showLoadFile('memoID',0)" type="button" value="附件上传" /></span>
					      <span id="downloadFile_memoID">&nbsp;</span>
					    </div>
            </td>
          </tr>
        	</table>
				</form>
			</div>
		</div>
	</div>
	
	<div style="width:99%;float:left;margin:10;height:4px;"></div>
  <div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" name="save" value="保存" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="addNew" name="addNew" value="新增" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="close" name="close" value="关闭" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="del" name="del" value="删除" />
  </div>
	
</div>
</body>
