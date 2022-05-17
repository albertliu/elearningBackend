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
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var updateCount = 0;
	var userName = "";
	var realName = "";
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = <%=op%>;
		$.ajaxSetup({ 
			async: false 
		}); 
		
		getComList("deptID","deptInfo","deptID","deptName","pID=(select deptID from deptInfo where pID=0 and host='" + currHost + "') and kindID=0 and dept_status=0 order by deptID",1);
		getDicList("userStatus","status",0);
		getDicList("userKind","kindID",0);
		$("#limitedDate").click(function(){WdatePicker();});
		
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
		$("#save").click(function(){
			//alert($("#userID").val() + "&userName=" + ($("#userName").val()) + "&deptID=" + $("#deptID").val() + "&realName=" + ($("#realName").val()) + "&status=" + $("#status").val() + "&passwd=" + ($("#passwd").val()) + "&limitedDate=" + $("#limitedDate").val() + "&empID=" + $("#empID").val() + "&phone=" + ($("#phone").val()) + "&phoneWork=" + ($("#phoneWork").val()) + "&email=" + ($("#email").val()));
			$.get("userControl.asp?op=update&nodeID=" + $("#userID").val() + "&userNo=" + escape($("#userNo").val()) + "&deptID=" + $("#deptID").val() + "&realName=" + escape($("#realName").val()) + "&status=" + $("#status").val() + "&limitedDate=" + $("#limitedDate").val() + "&phone=" + escape($("#phone").val()) + "&memo=" + escape($("#memo").val()) + "&email=" + escape($("#email").val()) + "&p=0&times=" + (new Date().getTime()),function(re){
				//jAlert(unescape(re));
				var ar = new Array();
				ar = unescape(re).split("|");
				if(ar[0] == 0){
					jAlert("保存成功！","信息提示");
					updateCount += 1;
					nodeID = ar[1];
					getNodeInfo(ar[1]);
				}
				if(ar[0] == 1){
					jAlert("该用户名已经存在。","信息提示");
					$("#userNo").focus();
				}
				if(ar[0] == 2){
					jAlert("用户名不能为空。","信息提示");
					$("#userNo").focus();
				}
				if(ar[0] == 3){
					jAlert("姓名不能为空。","信息提示");
					$("#realName").focus();
				}
			});
			return false;
		});

		$("#del").click(function(){
			if($("#kindID").val()==1){
				jAlert("固定用户不可删除");
				return false;
			}
			jConfirm('你确定要删除这个用户吗?', '确认对话框', function(r) {
				if(r){
					$.get("userControl.asp?op=delNode&nodeID=" + $("#userID").val() + "&times=" + (new Date().getTime()),function(data){
						jAlert("删除成功！","信息提示");
						op = 1;
						setButton();
						updateCount += 1;
					});
				}
			});
		});
    
    $("#changeRole").click(function(){
    	showUserRoleList();
    });
    
    $("#changePermission").click(function(){
    	showUserPermissionList();
    });

  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		//alert(id);
		$.get("userControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#userID").val(ar[0]);
				$("#userNo").val(ar[1]);
				$("#userName").val(ar[2]);
				$("#realName").val(ar[3]);
				userName = ar[2];
				realName = ar[3];
				$("#status").val(ar[4]);
				$("#deptID").val(ar[6]);
				$("#kindID").val(ar[9]);
				$("#limitedDate").val(ar[10]);
				$("#phone").val(ar[11]);
				$("#email").val(ar[12]);
				$("#memo").val(ar[13]);
				$("#regDate").val(ar[14]);
				$("#registerID").val(ar[14]);
				$("#registerName").val(ar[16]);
				$("#kindName").val(ar[17]);
				//getDownloadFile("userID");
	    	getRoleListByUser();
	    	getPermissionListByUser();
	    	getAllPermissionListByUser();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
			op = 0;
			setButton();
		});
	}
	
	function setButton(){
		$("#addNew").hide();
		$("#save").hide();
		$("#del").hide();
		$("#userNo").attr("disabled",true);
		$("#changeRole").hide();
		$("#changePermission").hide();
		if(op == 0){
			if(($("#registerID").val() == currUser && $("#regDate").val() == currDate) || (checkPermission("userAdd") && currHost=="")){
				$("#save").show();
				$("#del").show();
			}
			if($("#userName").val() == currUser && !checkPermission("userAdd")){
				$("#save").show();
				setObjReadOnly("deptID|limitedDate|realName|status",1,0);
			}
			if(checkPermission("userAdd")){
				$("#addNew").show();
				$("#save").show();
				$("#changeRole").show();
				$("#changePermission").show();
			}
		}
		if(op == 1){
			setEmpty();
			$("#save").show();
			//$("#btnLoadFile").attr("disabled",true);
			$("#userNo").attr("disabled",false);
			$("#userNo").focus();
		}
	}
	
	function setEmpty(){
		$("#userID").val(0);
		$("#status").val(0);
		$("#userNo").val("");
		$("#realName").val("");
		$("#deptID").val("");
		$("#phone").val("");
		$("#email").val("");
		$("#limitedDate").val("2037-09-20");
		$("#regDate").val(currDate);
		$("#registerID").val(currUser);
		$("#registerName").val(currUserName);
		$("#roleList").empty();
		$("#permissionList").empty();
		$("#allPermissionList").empty();
		userName = "";
		realName = "";
		if(currDeptID > ""){
			$("#deptID").val(currDeptID);
		}

		//$("#downloadFile_userID").html("");
	}
	
	function getUpdateCount(){
		return updateCount;
	}

	function getRoleListByUser(){
		//根据用户名列出其拥有的角色
		$.get("userControl.asp?op=getRoleListByUser&userName=" + userName + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//$("#roleList").empty();
			document.getElementById("roleList").options.length = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#roleList");
				});
			}
		});
	}

	function getPermissionListByUser(){
		//根据用户名列出其拥有的直接分配权限
		$.get("userControl.asp?op=getPermissionListByUser&userName=" + userName + "&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//$("#permissionList").empty();
			document.getElementById("permissionList").options.length = 0;
			if(ar>""){
				var s = "";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					s = "";
					if(ar1[3]>""){s = "&nbsp;&nbsp;&nbsp;(" + ar1[3] + ")";}
					$("<option value='" + ar1[0] + "'>" + ar1[1] + s + "</option>").appendTo("#permissionList");
				});
			}
		});
	}

	function getAllPermissionListByUser(){
		//根据用户名列出其拥有的所有权限
		$.get("userControl.asp?op=getAllPermissionListByUser&userName=" + userName + "&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//$("#permissionList").empty();
			document.getElementById("allPermissionList").options.length = 0;
			if(ar>""){
				var s = "";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					s = "";
					if(ar1[3]>""){s = "&nbsp;&nbsp;&nbsp;(" + ar1[3] + ")";}
					$("<option value='" + ar1[0] + "'>" + ar1[1] + s + "</option>").appendTo("#allPermissionList");
				});
			}
		});
	}
	
	function showUserRoleList(){
		if($("#userID").val() > ""){
			//$.get("commonControl.asp?op=setSession&sName=pagePara" + "&anyStr=" + escape(userName + "|" + realName + "|" + 1) + "&times=" + (new Date().getTime()),function(re){
				asyncbox.open({
					url:'userRoleList.asp?refID=' + userName + '&item=' + escape(realName) + '&kindID=1&times=' + (new Date().getTime()),
					title: '角色分配',
					width : 730,
					height : 520,
					callback : function(action){
						if(action == 'close'){
							getRoleListByUser();
							getAllPermissionListByUser();
	　　　　　			}
		　　		}
				});
			//});
		}
	}
	
	function showUserPermissionList(){
		if($("#userID").val() > ""){
			//$.get("commonControl.asp?op=setSession&sName=pagePara" + "&anyStr=" + escape(userName + "|" + realName + "|" + 1) + "&times=" + (new Date().getTime()),function(re){
				asyncbox.open({
					url:'userPermissionList.asp?refID=' + userName + '&item=' + escape(realName) + '&kindID=1&times=' + (new Date().getTime()),
					title: '权限分配',
					width : 730,
					height : 520,
					callback : function(action){
				　　	if(action == 'close'){
							getPermissionListByUser();
							getAllPermissionListByUser();
		　　　　　		 }
		　　　  	 }
				});
			//});
		}
	}

</script>

</head>

<body style="background:#f0f0f0;">
 <!--#include file='commLoadFileDetail.asp' -->

<div id='layout' align='left' style="background:#f0f0f0;">	
	<table border='0' cellpadding='0' cellspacing='0' valign='top' width = '99%'>
		<tr>
	   <td colspan="3" valign='top'>
			<div style="width:98%;float:left;margin:0;">
				<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
					<div class="comm" style="background:#f5faf8;">
						<form action="docControl.asp?op=update" id="fm1" name="fm1"  method="post" encType="multipart/form-data" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
							<table border="0" cellpadding="0" cellspacing="0" width="98%" style="line-height:10px;">
		            <tr>
		              <td>用户名</td><input id="userID" type="hidden" />
		              <td><input class="mustFill" id="userNo" name="userNo" type="text" size="15" /></td>
		              <td>姓名</td><input id="userName" type="hidden" /><input id="kindID" type="hidden" />
		              <td><input class="mustFill" id="realName" name="realName" type="text" size="25" /></td>
		            </tr>
		            <tr>
		              <td>类别</td>
		              <td><input class="readOnly" type="text" id="kindName" size="15" readOnly="true" /></td>
		              <td>部门</td>
		              <td><select id="deptID" style="width:180px;" ></select></td>
		            </tr>
		            <tr>
		              <td>电话</td>
		              <td><input id="phone" type="text" size="15" /></td>
		              <td>Email</td>
		              <td><input id="email" name="email" type="text" size="25" /></td>
		            </tr>
		            <tr>
		              <td>有效期</td>
		              <td><input id="limitedDate" name="limitedDate" type="text" size="15" /></td>
		              <td>状态</td>
		              <td><select id="status" style="width:100px;" ></select></td>
		            </tr>
					<tr>
						<td align="right">备注</td>
						<td colspan="5"><textarea id="memo" style="padding:2px;" rows="5" cols="75"></textarea></td>
					</tr>
		            <tr>
						<td align="right">登记日期</td>
						<td><input class="readOnly" type="text" id="regDate" size="15" readOnly="true" /></td>
						<td align="right">登记人</td><input type="hidden" id="registerID" />
						<td><input class="readOnly" type="text" id="registerName" size="25" readOnly="true" /></td>
			        </tr>
		          </table>
							<div style="width:100%;float:left;margin:10;height:4px;"></div>
						  <div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
						  	<input class="button" type="button" id="save" name="save" value="保存" />&nbsp;&nbsp;&nbsp;
						  	<input class="button" type="button" id="addNew" name="addNew" value="新增" />&nbsp;&nbsp;&nbsp;
						  	<input class="button" type="button" id="del" name="del" value="删除" />
						  </div>
		        </form>
					</div>
				</div>
			</div>
	   </td>
		</tr>
		<tr>
	   <td valign='top' width = '30%'>
			<div style="float:left;border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:18px;">
	    	<div align="center">
	    		<div class="comm"><h2>拥有角色</h2></div>
					<select name="roleList" size="15" id="roleList" multiple style="background-color:#FFFFFE; border: '#EEEEFF'; width:90% ">
					</select>
	    	</div>
        <hr size="1" color="#c0c0c0" noshadow>
        <div class="comm" align="center">
        	<input class="button" type="button" id="changeRole" name="changeRole" value="变更角色" />
        </div>
			</div>
	   </td>
	   <td valign='top' width = '30%'>
			<div style="float:left;border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:18px;">
	    	<div align="center">
	    		<div class="comm"><h2>直接权限</h2></div>
					<select name="permissionList" size="15" id="permissionList" multiple style="background-color:#FFFFFE; border: '#EEEEFF'; width:90% ">
					</select>
	    	</div>
        <hr size="1" color="#c0c0c0" noshadow>
        <div class="comm" align="center">
        	<input class="button" type="button" id="changePermission" name="changePermission" value="变更权限" />
        </div>
			</div>
	   </td>
	   <td valign='top' width = '30%'>
			<div style="float:left;border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:18px;">
	    	<div align="center">
	    		<div class="comm"><h2>实际权限</h2></div>
					<select name="allPermissionList" size="15" id="allPermissionList" multiple style="background-color:#FCFCFC; border: '#EEEEFF'; width:90% ">
					</select>
	    	</div>
	    	<div style="color:gray;">* 包括直接分配的权限、从角色获得的权限以及他人的授权。</div>
			</div>
	   </td>
		</tr>
	</table>
	
	
</div>
</body>
