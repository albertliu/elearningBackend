<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css?v=1.8.6">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery-confirm.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.12.4.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js?v=1.8.6"></script>
<script src="js/jquery-confirm.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var refID = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";
		op = "<%=op%>";
		
		getComList("certID","certificateInfo","certID","shortName","status=0 and type=0 order by certID",1);
		getComList("projectID","projectInfo","projectID","projectName","status=1 order by projectID desc",1);
		getComList("adviserID","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='adviser') order by realName",1);
		getDicList("planStatus","status",0);
		$("#dateStart").click(function(){WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'});});
		$("#dateEnd").click(function(){WdatePicker();});
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo(nodeID);
		}
		setButton();
		
		$("#save").click(function(){
			saveNode();
		});
		$("#close").click(function(){
			if(confirm('确定要结束课程吗?')){
				$.get("classControl.asp?op=closeClass&nodeID=" + $("#ID").val() + "&refID=2&times=" + (new Date().getTime()),function(data){
					alert("已结课","信息提示");
					getNodeInfo(nodeID);
					updateCount += 1;
				});
			}
		});
		$("#open").click(function(){
			if(confirm('确定重新开启班级吗?')){
				$.get("classControl.asp?op=closeClass&nodeID=" + $("#ID").val() + "&refID=0&times=" + (new Date().getTime()),function(data){
					alert("已重新开启，请及时关闭。","信息提示");
					getNodeInfo(nodeID);
					updateCount += 1;
				});
			}
		});
		$("#del").click(function(){
			if($("#qty").val() > 0){
				alert("该班级还有学员，不能删除。");
				return false;
			}
			if(confirm('确定删除班级吗?')){
				var x = prompt("请输入删除原因：","");
				if(x && x>""){
					$.get("classControl.asp?op=delNode&nodeID=" + $("#classID").val() + "&where=" + escape(x) + "&times=" + (new Date().getTime()),function(data){
						//alert(unescape(data));
						alert("已成功删除。","信息提示");
						updateCount += 1;
						op = 1;
						setButton();
					});
				}
			}
		});
		$("#btnSummary").click(function(){
			$.get("classControl.asp?op=getRandSummary&refID=" + $("#ID").val() + "&times=" + (new Date().getTime()),function(data){
				if(data==""){
					alert("没有找到相关记录。","信息提示");
				}else{
					$("#summary").val(unescape(data));
				}
			});
		});

		$("#certID").change(function(){
			if($("#certID").val()>""){
				var id=$("#certID").val();
				setProjectList(id,[]);
				$("#className").val($("#certID").find("option:selected").text() + $("#dateStart").val().substr(2,8).replace(/-/g,""));
			}
		});

		$("#doImportRef").click(function(){
			if($("#projectID").val()==""){
				alert("请选择招生批次。");
				return false;
			}
			showLoadFile("ref_student_list",$("#ID").val(),"studentList",'');
			updateCount += 1;
		});

		$("#doImport").click(function(){
			if($("#projectID").val()==""){
				alert("请选择招生批次。");
				return false;
			}
			showLoadFile("student_list",$("#ID").val(),"studentList",'');
			updateCount += 1;
		});

		$("#refundList").click(function(){
			$.getJSON(uploadURL + "/outfiles/generate_refund_list?classID=" + $("#classID").val() + "&className=" + $("#className").val() + "&price=10" ,function(data){
				if(data>""){
					asyncbox.alert("已生成 <a href='" + data + "' target='_blank'>下载文件</a>",'操作成功',function(action){
					　　//alert 返回action 值，分别是 'ok'、'close'。
					　　if(action == 'ok'){
					　　}
					　　if(action == 'close'){
					　　　　//alert('close');
					　　}
					});
					//getNodeInfo(nodeID);
				}else{
					alert("没有可供处理的数据。");
				}
			});
		});

		$("#archive").click(function(){
			if($("#summary").val()==""){
				alert("请填写工作小结。");
				return false;
			}
			if($("#dateEnd").val()==""){
				alert("请填写班级结束日期。");
				return false;
			}
			//showLoadFile("ref_student_list",$("#ID").val(),"studentList",'');
			window.open("class_archives.asp?nodeID=" + nodeID + "&keyID=1", "_self");
		});

		$("#btnSel").click(function(){
			setSel("");
		});
		
		$("#btnClassCall").click(function(){
			getSelCart("visitstockchk");
			if(selCount==0){
				alert("请选择要通知的名单。");
				return false;
			}
			if(confirm("确定要通知这" + selCount + "个学员参加培训吗？")){
				$.post(uploadURL + "/public/send_message_class", {batchID: $("#classID").val(), selList: selList, SMS:1, registerID: currUser} ,function(data){
					getNodeInfo(nodeID);
					alert("发送成功。");
				});
			}
		});

		$("#btnMockView").click(function(){
			showClassExamStat($("#classID").val(),$("#className").val(),0,0);
		});

	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("classControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#classID").val(ar[1]);
				//$("#projectID").val(ar[2]);
				$("#certID").val(ar[3]);
				setProjectList(ar[3],ar[2]);
				$("#kindID").val(ar[5]);
				$("#status").val(ar[6]);
				$("#adviserID").val(ar[8]);
				$("#dateStart").val(ar[10]);
				$("#dateEnd").val(ar[11]);
				$("#classroom").val(ar[12]);
				$("#memo").val(ar[13]);
				$("#regDate").val(ar[14]);
				$("#registerName").val(ar[16]);
				$("#className").val(ar[17]);
				$("#timetable").val(ar[18]);
				$("#qty").val(ar[20]);
				$("#qtyApply").val(ar[26]);
				$("#qtyExam").val(ar[27]);
				$("#qtyPass").val(ar[28]);
				$("#qtyReturn").val(ar[33]);
				$("#summary").val(ar[25]);
				$("#archiveDate").val(ar[24]);
				$("#archiverName").val(ar[29]);
				$("#send").val(ar[30]);
				$("#sendDate").val(ar[31]);
				$("#senderName").val(ar[32]);
				if(ar[24]>""){
					$("#archived").prop("checked",true);
				}else{
					$("#archived").prop("checked",false);
				}
				var c = "";
				if(ar[21] > ""){
					c += "<a href='/users" + ar[21] + "' target='_blank'>报名清单</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;";}
				$("#photo").html(c);
				$("#refundList").html("<a>退费清单</a>");
				$("#archive").html("<a>班级档案</a>");
				getStudentList();
				//getDownloadFile("classID");
				setButton();
			}else{
				alert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}

	function getStudentList(){
		//alert($("#classID").val());
        var mark = 1;
        if(checkRole("saler")){
            mark = 3;
        }
		$.get("studentCourseControl.asp?op=getStudentCourseList&classID=" + $("#classID").val() + "&mark=" + mark + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			arr = [];		
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='4%'>No</th>");
			arr.push("<th width='7%'>学号</th>");
			arr.push("<th width='9%'>身份证</th>");
			arr.push("<th width='6%'>姓名</th>");
			arr.push("<th width='13%'>单位</th>");
			arr.push("<th width='6%'>电话</th>");
			arr.push("<th width='5%'>进度%</th>");
			arr.push("<th width='7%'>模拟</th>");
			arr.push("<th width='5%'>准申</th>");
			arr.push("<th width='5%'>成绩</th>");
			arr.push("<th width='5%'>补考</th>");
			arr.push("<th width='5%'>状态</th>");
			arr.push("<th width='4%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var k = 0;
				var s = $("#status").val();
				var imgChk = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + ar1[43] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(" + ar1[0] + ",\"" + ar1[1] + "\",0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					if(ar1[56]=="znxf"){	//非集团客户，显示自己的单位和部门
						arr.push("<td class='left'>" + ar1[54].substr(0,12) + "</td>");
					}else{
						arr.push("<td class='left'>" + ar1[12].substr(0,12) + "</td>");
					}
					arr.push("<td class='left'>" + ar1[69] + "</td>");
					c = ar1[10];
					if(c>0){
						c = c;
					}else{
						c = "";
					}
					arr.push("<td class='center'>" + c + "</td>");	//学习进度
					arr.push("<td title='最好成绩*次数' class='link1'><a href='javascript:showStudentExamStat(" + ar1[0] + ",\"" + ar1[2] + "\",0,0);'>" + nullNoDisp(ar1[15]) + "*" + nullNoDisp(ar1[59]) + "</td>");
					//申报
					if(ar1[65]>0 || ar1[53]>0){
						arr.push("<td class='center'>" + imgChk + "</td>");	//申报/准考证
					}else{
						arr.push("<td class='center'>&nbsp;</td>");
					}
                    h = ar1[66];
                    if($("#certID").val()=="C12"){
                        h = ar1[70].replace(".00","") + "/" + ar1[71].replace(".00","");
                    }
					arr.push("<td class='left'>" + nullNoDisp(h) + "</td>");
					arr.push("<td class='center'>" + nullNoDisp(ar1[68]) + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					arr.push("<td class='left'><input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[1] + "' name='visitstockchk'></td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#cover").html(arr.join(""));
			arr = [];
			$('#cardTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 500,
				"bInfo": true,
				"aoColumnDefs": []
			});
		});
	}
	
	function saveNode(){
		if(op==0 && $("#adviserID").val()!=currUser){
			//alert("只有该班的班主任才能操作。");
			//return false;
		}
		if($("#className").val()==0){
			alert("请填写班级名称。");
			return false;
		}
		var photo = 0;
		if($("#archived").prop("checked")){photo = 1;}
		$.post("classControl.asp?op=update&nodeID=" + $("#ID").val() + "&projectID=" + $("#projectID").combobox("getValues") + "&className=" + escape($("#className").val()) + "&classroom=" + escape($("#classroom").val()) + "&timetable=" + escape($("#timetable").val()) + "&certID=" + $("#certID").val() + "&adviserID=" + $("#adviserID").val() + "&kindID=" + $("#kindID").val() + "&status=" + $("#status").val() + "&dateStart=" + $("#dateStart").val() + "&dateEnd=" + $("#dateEnd").val() + "&archived=" + photo, {"memo":$("#memo").val(), "summary":$("#summary").val()},function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				if(op == 1){
					op = 0;
					nodeID = ar[1];
				}
				alert("保存成功！","信息提示");
				getNodeInfo(ar[1]);
				updateCount += 1;
			}else{
				alert("未能成功提交，请退出后重试。","信息提示");
			}
		});
		//return false;
	}
	
	function setProjectList(id,s){
		$("#projectID").empty();
		//getComList("projectID","projectInfo","projectID","projectName"," status>0 and certID='" + id + "' order by projectID desc",1);
		$.getJSON(uploadURL + "/public/getProjectListBycertID?certID=" + id + "&op=" + op ,function(data){
			if(data>""){
				//alert(data[0]["deptName"]);
				//data = [{"id":1,"text":"text1"},{"id":2,"text":"text2"},{"id":3,"text":"text3"},{"id":4,"text":"text4"},{"id":5,"text":"text5"}];
				$('#projectID').combobox({
					data: data,
					valueField:'projectID',
					textField:'projectName',
					//panelHeight: 200,
					multiple: true,
					editable: false,
					onLoadSuccess: function () { // 下拉框数据加载成功调用
						// 正常情况下是默认选中“所有”，但我想实现点击所有全选功能，这这样会冲突，暂时默认都不选
						//$("#dept").combobox('clear'); //清空
						$('#projectID').combobox("setValues",s);

						// var opts = $(this).combobox('options');
						// var values = $('#'+_id).combobox('getValues');
						// $.map(opts.data, function (opt) {
						//     if (opt.id === '') { // 将"所有"的复选框勾选
						//         $('#'+opt.domId + ' input[type="checkbox"]').prop("checked", true);
						//     }
						// });
					}
				});
			}
		});
	}
	
	function setButton(){
		var s = $("#status").val();
		$("#save").hide();
		$("#close").hide();
		$("#open").hide();
		$("#del").hide();
		$("#doImportRef").hide();
		$("#doImport").hide();
		$("#btnClassCall").hide();
		$("#btnMockView").hide();
		if(op ==1){
			setEmpty();
		}else{
			if(checkPermission("classAdd") && s < 2){
				$("#close").show();
			}
			if(checkPermission("classOpen") && s > 0){
				$("#open").show();
			}
			if(checkPermission("classAdd")){
				$("#del").show();
			}
			$("#btnMockView").show();
		}
		if(checkPermission("classAdd") && s < 2){
			$("#save").show();
			$("#doImport").show();
			$("#btnClassCall").show();
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#classID").val("");
		$("#projectID").val("");
		$("#adviserID").val("");
		$("#memo").val("");
		$("#className").val("");
		$("#status").val(0);
		$("#kindID").val(0);
		$("#classroom").val("黄兴路158号D103");
		$("#dateStart").val(addDays(currDate,3) + " 8:30");
		$("#dateEnd").val("");
		$("#regDate").val(currDate);
		$("#registerID").val(currUser);
		$("#registerName").val(currUserName);
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
			<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
			<tr>
				<td align="right">开课日期</td>
				<td><input type="text" id="dateStart" size="15" /></td>
				<td align="right">结课日期</td>
				<td><input type="text" id="dateEnd" size="15" />&nbsp;预计</td>
			</tr>
			<tr>
				<td align="right">班级编号</td><input id="ID" type="hidden" /><input id="kindID" type="hidden" /><input id="status" type="hidden" />
				<td><input type="text" id="classID" size="25" class="readOnly" readOnly="true" /></td>
				<td align="right">课程名称</td>
				<td><select id="certID" style="width:180px;"></select></td>
			</tr>
			<tr>
				<td align="right">班级名称</td>
				<td><input type="text" class="mustFill" id="className" size="25" /></td>
				<td align="right">招生批次</td>
				<td><input type="text" id="projectID" name="projectID" size="25" /></td>
			</tr>
			<tr>
				<td align="right">学员人数</td>
				<td colspan="3">
					<input type="text" class="readOnly" readOnly="true" id="qty" size="3" />
					申报<input type="text" class="readOnly" readOnly="true" id="qtyApply"  size="3" />
					考试<input type="text" class="readOnly" readOnly="true" id="qtyExam"  size="3" />
					合格<input type="text" class="readOnly" readOnly="true" id="qtyPass"  size="3" />
					退课<input type="text" class="readOnly" readOnly="true" id="qtyReturn"  size="3" />
				</td>
			</tr>
			<tr>
				<td align="right">班主任</td>
				<td><select id="adviserID" style="width:180px;"></select></td>
				<td align="right">上课地点</td>
				<td><input type="text" id="classroom" size="25" /></td>
			</tr>
			<tr>
				<td colspan="2">
					资料归档<input style="border:0px;" type="checkbox" id="archived" value="" />&nbsp;&nbsp;<input class="readOnly" type="text" id="archiverName" size="8" readOnly="true" />&nbsp;&nbsp;<input class="readOnly" type="text" id="archiveDate" size="8" readOnly="true" />
				</td>
				<td colspan="2">
					<span id="photo" style="margin-left:10px;"></span>&nbsp;&nbsp;
					<span id="refundList" style="margin-left:10px;"></span>&nbsp;&nbsp;
					<span id="archive" style="margin-left:10px;"></span>
				</td>
			</tr>
			<tr>
				<td align="right">课程安排</td>
				<td colspan="5"><textarea id="timetable" style="padding:2px;" rows="4" cols="75"></textarea></td>
			</tr>
			<tr>
				<td align="right">
					工作小结<br />
					<div class="comm" align="center"><input class="button" type="button" id="btnSummary" value="..." /></div>
				</td><input id="memo" type="hidden" />
				<td colspan="5"><textarea id="summary" style="padding:2px;" rows="5" cols="75"></textarea></td>
			</tr>
			<tr>
				<td align="right">开课通知</td>
				<td colspan="5">
					次数&nbsp;<input class="readOnly" type="text" id="send" size="2" readOnly="true" />&nbsp;&nbsp;
					日期&nbsp;<input class="readOnly" type="text" id="sendDate" size="6" readOnly="true" />&nbsp;&nbsp;
					发送人&nbsp;<input class="readOnly" type="text" id="senderName" size="5" readOnly="true" />&nbsp;&nbsp;
				</td>
			</tr>
			<tr>
				<td align="right">登记人</td>
				<td><input class="readOnly" readOnly="true" type="text" id="registerName" size="25" /></td>
				<td align="right">登记日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" value="保存" />&nbsp;&nbsp;
  	<input class="button" type="button" id="close" value="结束" />&nbsp;&nbsp;
  	<input class="button" type="button" id="open" value="开启" />&nbsp;&nbsp;
  	<input class="button" type="button" id="del" value="删除" />&nbsp;&nbsp;
	<input class="button" type="button" id="doImportRef" value="石化预报名表" />
	<input class="button" type="button" id="doImport" value="报名表导入" />

	<div style="width:100%;float:left;margin:10;height:4px;"></div>
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:5px;background:#ffffff;line-height:18px;padding-left:20px;">
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnSel" value="全选/取消" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnClassCall" value="开课通知" /></span>
			<span id="btnMockView">&nbsp;&nbsp;查看模拟考试情况</span>
		</div>
	</div>
	<hr size="1" noshadow />
	<div id="cover" style="float:top;margin:3px;background:#f8fff8;">
	</div>
  </div>
</div>
</body>
