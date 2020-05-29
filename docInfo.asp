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
<link rel="stylesheet" href="css/token-input-facebook.css?v=20150409" type="text/css" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type="text/javascript" src="js/jquery.tokeninput.js"></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = 0;
	var kindID = 0;
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		kindID = "<%=kindID%>";
		op = <%=op%>;
    $.ajaxSetup({ 
  		async: false 
  	}); 
		getDicList("status","",0);
		getDicList("docKind","kindID",0);
		$("#kindID").val(kindID);
		
		if(op==1){
			setButton();
		}
		if(op==0){
			getNodeInfo(nodeID);
		}

		$("#addNew").click(function(){
			op = 1;
			nodeID = "";
			setButton();
		});

		$("#kindID").change(function(){
			if($("#kindID").val()==1){
				$("#findUsers").show();
			}else{
				$("#findUsers").hide();
			}
		});

/*
		$("#fm1").ajaxForm(function(re){
			alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("保存成功！","信息提示");
				updateCount += 1;
				nodeID = ar[1];
				getNodeInfo(ar[1]);
			}
			if(ar[0] == 1){
				jAlert("标题不能为空。","信息提示");
				$("#item").focus();
			}
		});
*/		
		$("#save").click(function(){
			//alert("nodeID=" + $("#docID").val() + "&item=" + ($("#item").val()) + "&kindID=" + $("#kindID").val() + "&description=" + ($("#description").val()) + "&status=" + $("#status").val() + "&docContent=" + ($("#docContent").val()));
			$.get("docControl.asp?op=update&nodeID=" + $("#docID").val() + "&item=" + escape($("#item").val()) + "&kindID=" + $("#kindID").val() + "&description=" + escape($("#description").val()) + "&status=" + $("#status").val() + "&docContent=" + escape($("#docContent").val()) + "&userID=" + escape(token_user.join("|")) + "&p=1&times=" + (new Date().getTime()),function(re){
				jAlert(unescape(re));
				var ar = new Array();
				ar = unescape(re).split("|");
				if(ar[0] == 0){
					jAlert("保存成功！","信息提示");
					updateCount += 1;
					nodeID = ar[1];
					getNodeInfo(ar[1]);
				}
				if(ar[0] == 1){
					jAlert("标题不能为空。","信息提示");
					$("#item").focus();
				}
			});
			return false;
		});

		$("#del").click(function(){
			jConfirm('你确定要删除这个通知吗?', '确认对话框', function(r) {
				if(r){
					$.get("docControl.asp?op=delNode&nodeID=" + $("#docID").val() + "&times=" + (new Date().getTime()),function(data){
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
		$.get("docControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#docID").val(ar[0]);
				nodeID = ar[0];
				$("#item").val(ar[1]);
				$("#status").val(ar[2]);
				$("#kindID").val(ar[4]);
				$("#description").val(ar[5]);
				$("#docContent").val(ar[6]);
				$("#regDate").val(ar[7]);
				$("#regOperator").val(ar[8]);
				$("#registorName").val(ar[9]);
				$("#div_token_user").html('<input class="mustFill" type="text" id="userName" size="60" />');
				setTokenUser(0);
				getReceiverListJson("doc",ar[0]);
				//$("#usersName").val(ar[11]);
				getDownloadFile("docID");
				setSession("loadFileSpecialName","");
				//$("#findUserList").show();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
			op = 0;
			setButton();
		});
	}
	
	function setButton(){
		$("#findUsers").hide();
		$("#btnLoadFile").attr("disabled",true);
		if($("#kindID").val()==1){
			$("#findUsers").show();
		}
		if(op == 0){
			if(($("#regOperator").val() == currUser && $("#regDate").val() == currDate) || checkPermission("admin")){
				$("#save").show();
				$("#del").show();
			}else{
				$("#save").hide();
				$("#del").hide();
			}
			if($("#regOperator").val() == currUser){
				$("#btnLoadFile").attr("disabled",false);
			}
		}
		if(op == 1){
			setEmpty();
			$("#save").show();
			$("#del").hide();
			$("#btnLoadFile").attr("disabled",true);
			$("#item").focus();
		}
	}
	
	function setEmpty(){
		$("#status").val(0);
		$("#docID").val(0);
		nodeID = 0;
		$("#item").val("");
		$("#kindID").val(kindID);
		$("#description").val("");
		$("#docContent").val("");
		$("#regDate").val(currDate);
		$("#regOperator").val(currUser);
		$("#registorName").val(currUserName);
		$("#usersName").val("");
		$("#cTotal").html("&nbsp;");
		$("#cReturn").html("&nbsp;");
		//$("#findUserList").hide();
		setTokenUser(0);

		$("#downloadFile_docID").html("");
	}
	
	function getUpdateCount(){
		return updateCount;
	}
	
	function showUserList(){
		if(nodeID>0){
			//alert('kindID=doc&nodeID=' + nodeID + '&item=' + ($("#item").val()) + '&refID=' + $("#regOperator").val());
			parent.asyncbox.open({
				url:'docUserList.asp?kindID=doc&nodeID=' + nodeID + '&item=' + escape($("#item").val()) + '&refID=' + $("#regOperator").val() + '&p=1&times=' + (new Date().getTime()),
				title: '接收人情况',
	　　　width : 980,
	　　　height : 620,
	　　　callback : function(action){
　　　　　if(action == 'close'){
						getNodeInfo(nodeID);
　　　　　}
	　　　}
			});
		}
	}
</script>

</head>

<body style="background:#f0f0f0;">
 <!--#include file='commLoadFileDetail.asp' -->

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="bdocArchive:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
				<form action="docControl.asp?op=update" id="fm1" name="fm1"  method="post" encType="multipart/form-data" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
					<table border="0" cellpadding="0" cellspacing="0" width="98%" style="line-height:10px;">
            <tr>
              <td>标题</td><input id="docID" name="docID" type="hidden" />
              <td colspan="3"><input class="mustFill" id="item" name="item" type="text" size="62" /></td>
            </tr>
            <tr>
              <td>类型</td>
              <td><select id="kindID" name="kindID" style="width:100px;" ></select></td>
              <td>状态</td>
              <td><select id="status" name="status" style="width:100px;" ></select></td>
            </tr>
            <tr>
              <td>备注</td>
              <td colspan="3"><input id="description" name="description" type="text" size="62" /></td>
            </tr>
            <tr>
              <td>内容</td>
              <td colspan="3"><textarea id="docContent" name="docContent" cols="70" rows="10"></textarea></td>
            </tr>
            <tr id="findUsers">
	          	<td>接收人</td><input id="userID" type="hidden" />
	          	<td colspan="3"><div id="div_token_user"><input class="mustFill" type="text" id="userName" size="62" /></div></td>
            </tr>
            <tr>
              <td colspan="4">
              	<div id="userPan" style="padding:5px;">
              		访问回执：</span><span id="cReturn">&nbsp;</span>
	              	&nbsp;&nbsp;
	              	创建日期&nbsp;&nbsp;<input class="readOnly" id="regDate" name="regDate" type="text" size="10" readOnly="true" />
	              	&nbsp;&nbsp;<input id="regOperator" type="hidden" />
	              	创建人&nbsp;&nbsp;<input class="readOnly" id="registorName" name="registorName" type="text" size="10" readOnly="true" />
              	</div>
              </td>
            </tr>
            <tr>
              <td colspan="4">
							<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#AAAAFF;line-height:18px;">
								<span style="padding-left:10px;"><input class="button" id="btnLoadFile" onClick="showLoadFile('docID',0)" type="button" value="附件上传" /></span>
					      <span id="downloadFile_docID">&nbsp;</span>
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
  	<input class="button" type="button" id="del" name="del" value="删除" />
  </div>
	
</div>
</body>
