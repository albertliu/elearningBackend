<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css?v=1.3"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
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
	var nodeID = 0;
	var op = 0;
	var updateCount = 0;
	var refID = "";		
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//ID
		refID = "<%=refID%>";	//teacherID
		op = <%=op%>;
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(currHost==""){
			getComList("host","hostInfo","hostNo","title","status=0 and kindID=1 order by ID",1);
		}else{
			getComList("host","hostInfo","hostNo","title","status=0 and kindID=1 and hostNo='" + currHost + "' order by ID",0);
		}
		getDicList("userStatus","status",0);
		
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
			if($("#teacherID").val()==""){
				alert("请填写教师编号。");
				return false;
			}
			if($("#teacherName").val()==""){
				alert("请填写教师姓名。");
				return false;
			}
			//alert($("#ID").val() + "&refID=" + ($("#teacherID").val()) + "&item=" + ($("#teacherName").val()) + "&status=" + $("#status").val() + "&host=" + $("#host").val() + "&memo=" + ($("#memo").val()));
			$.get("userControl.asp?op=updateTeacherInfo&nodeID=" + $("#ID").val() + "&refID=" + $("#teacherID").val() + "&item=" + escape($("#teacherName").val()) + "&status=" + $("#status").val() + "&host=" + $("#host").val() + "&memo=" + escape($("#memo").val()) + "&p=0&times=" + (new Date().getTime()),function(re){
				//alert(unescape(re));
				var ar = new Array();
				ar = unescape(re).split("|");
				if(re == 0){
					jAlert("教师编号重复，请修改以后再保存。","信息提示");
				}else{
					jAlert("保存成功！","信息提示");
					updateCount += 1;
					nodeID = re;
					getNodeInfo(re);
				}
			});
			return false;
		});

		$("#del").click(function(){
			jConfirm('你确定要删除这个教师吗?', '确认对话框', function(r) {
				if(r){
					$.get("userControl.asp?op=delNode&nodeID=" + $("#teacherID").val() + "&times=" + (new Date().getTime()),function(data){
						jAlert("删除成功！","信息提示");
						op = 1;
						setButton();
						updateCount += 1;
					});
				}
			});
		});

	});

	function getNodeInfo(id){
		//alert(id);
		$.get("userControl.asp?op=getTeacherInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#teacherID").val(ar[1]);
				$("#teacherName").val(ar[2]);
				$("#status").val(ar[3]);
				$("#host").val(ar[5]);
				$("#memo").val(ar[7]);
				$("#regDate").val(ar[8]);
				$("#registerID").val(ar[9]);
				$("#registerName").val(ar[10]);
				getTeacherCourseList();
				getCourseListByTeacher();
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
		if(op == 0){
			if(checkPermission("teacherAdd")){
				$("#save").show();
				//$("#del").show();
				$("#addNew").show();
				$("#teacherID").attr("disabled",true);
			}
		}
		if(op == 1){
			setEmpty();
			$("#save").show();
			$("#teacherID").attr("disabled",false);
		}
	}
	
	function setEmpty(){
		$("#teacherID").val("");
		$("#status").val(0);
		$("#host").val("");
		$("#regDate").val(currDate);
		$("#registerID").val(currUser);
		$("#registerName").val(currUserName);
		$("#userListCover").empty();
		$("#taskUserCover").empty();
	}
	
	function getUpdateCount(){
		return updateCount;
	}

	function getTeacherCourseList(){
		//alert($("#teacherID").val());
		$.get("userControl.asp?op=getTeacherCourseList&refID=" + $("#teacherID").val() + "&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//alert(ar);
			$("#userListCover").empty();
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='userListTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='10%'>No</th>");
			arr.push("<th width='40%'>课程</th>");
			arr.push("<th width='10%'>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td width='10%' class='left'>" + i + "</td>");
					arr.push("<td width='40%' class='left'>" + ar1[1] + "</td>");
					if(checkPermission("teacherAdd")){
						arr.push("<td width='10%' class='link1'><a href='javascript:doAddUser(\"" + ar1[0] + "\");'><img src='images/add.png' border='0' title='添加'></a></td>");
					}else{
						arr.push("<td width='10%' class='link1'>&nbsp;</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#userListCover").html(arr.join(""));
			arr = [];
			$('#userListTab').dataTable({
				"aaSorting": [],
				"bLengthChange": false,
				"aLengthMenu": [15, 25, 30, 50],
				"iDisplayLength": 50,
				"bFilter": false,
				"aoColumnDefs": []
			});
		});
	}
	
	function getCourseListByTeacher(){
		$.get("userControl.asp?op=getCourseListByTeacher&refID=" + $("#teacherID").val() + "&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//alert(ar);
			$("#taskUserCover").empty();
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='taskUserTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='10%'>No</th>");
			arr.push("<th width='40%'>课程</th>");
			arr.push("<th width='10%'>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td width='10%' class='left'>" + i + "</td>");
					arr.push("<td width='40%' class='left'>" + ar1[2] + "</td>");
					if(checkPermission("teacherAdd")){
						arr.push("<td width='10%' class='link1'><a href='javascript:doRemoveUser(\"" + ar1[0] + "\");'><img src='images/remove.png' border='0' title='撤销'></a></td>");
					}else{
						arr.push("<td width='10%' class='link1'>&nbsp;</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#taskUserCover").html(arr.join(""));
			arr = [];
			$('#taskUserTab').dataTable({
				"aaSorting": [],
				"bLengthChange": false,
				"aLengthMenu": [15, 25, 30, 50],
				"iDisplayLength": 50,
				"bFilter": false,
				"aoColumnDefs": []
			});
		});
	}

	function doAddUser(user){
		$.get("userControl.asp?op=addCourse2Teacher&refID=" + $("#teacherID").val() + "&nodeID=" + user + "&times=" + (new Date().getTime()),function(re){
			if(re==0){
				getTeacherCourseList();
				getCourseListByTeacher();
				jAlert("添加成功。","信息提示");
			}
		});
	}

	function doRemoveUser(nodeID){
		jConfirm("确实要退出该课程吗？","确认对话框",function(r){
			if(r){
				$.get("userControl.asp?op=removeCourse4Teacher&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
					if(re>""){
						getTeacherCourseList();
						getCourseListByTeacher();
						jAlert("删除成功。","信息提示");
					}
				});
			}
		});
	}

</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	<table border='0' cellpadding='0' cellspacing='0' valign='top' width = '99%'>
		<tr>
	   	<td valign='top'>
			<div style="width:98%;float:left;margin:0;">
				<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
					<div class="comm" style="background:#f5faf8;">
						<form action="docControl.asp?op=update" id="fm1" name="fm1"  method="post" encType="multipart/form-data" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
							<table border="0" cellpadding="0" cellspacing="0" width="98%" style="line-height:10px;">
		            <tr>
		              <td>编号</td><input id="ID" type="hidden" />
		              <td><input class="mustFill" id="teacherID" type="text" size="15" /></td>
		              <td>姓名</td>
		              <td><input class="mustFill" id="teacherName" name="realName" type="text" size="25" /></td>
		            </tr>
		            <tr>
		              <td>所属</td>
		              <td><select id="host" style="width:120px;" ></select></td>
		              <td>状态</td>
		              <td><select id="status" style="width:100px;" ></select></td>
		            </tr>
					<tr>
						<td align="right">备注</td>
						<td colspan="5"><textarea id="memo" style="padding:2px;" rows="1" cols="75"></textarea></td>
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
						  	<input class="button" type="button" id="save" value="保存" />&nbsp;&nbsp;&nbsp;
						  	<input class="button" type="button" id="addNew" value="新增" />&nbsp;&nbsp;&nbsp;
						  	<input class="button" type="button" id="del" value="删除" />
						  </div>
		        </form>
					</div>
				</div>
			</div>
	   	</td>
		</tr>
		<tr>
	   	<td width = '100%'>
			<div class="comm"><h2>教授课程</h2></div>
				<div style="width:48%;float:left;margin:2;">
					<div style="color:orange;margin:0;padding:5px;text-align:center;">未分配课程</div>
					<div style="border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:18px;">
						<div id="userListCover" style="float:top;margin:3px;background:#f8fff8;">
						</div>
					</div>
				</div>
				<div style="width:48%;float:right;margin:2;">
					<div style="color:orange;margin:0;padding:5px;text-align:center;">已分配课程</div>
					<div style="border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:18px;">
						<div id="taskUserCover" style="float:top;margin:3px;background:#f8fff8;">
						</div>
					</div>
				</div>
			</div>
	   	</td>
		</tr>
	</table>
	
	
</div>
</body>
