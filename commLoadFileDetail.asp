<script language="javascript">
	var username = "";
	var action = uploadURL + "/outfiles/uploadSingle";
	var host = "";
	arr = [];
	//alert(action);
	//mark:student,host,course
	function showLoadFile(loadOp,loadID,mark,p_host){
		username = loadID;
		host = p_host;
		//alert(action + ":" + loadID + ":" + loadOp);
		//$("#formUpload").attr("action", action + "?upID=" + loadOp + "&username=" + loadID + "&currUser=" + currUser);
		
		if(mark=='student'){
			//student material
			arr.push('<input style="border:0px;" type="radio" id="uploadKind0" name="uploadKind" value="student_photo" />照片&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind1" name="uploadKind" value="student_IDcardA" />身份证正面&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind2" name="uploadKind" value="student_IDcardB" />身份证背面&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind3" name="uploadKind" value="student_education" />学历证书&nbsp;');
		}
		if(mark=='host'){
			//host material
			arr.push('<input style="border:0px;" type="radio" id="uploadKind0" name="uploadKind" value="host_logo" />LOGO&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind1" name="uploadKind" value="host_QR" />登录二维码&nbsp;');
		}
		if(mark=='course'){
			//course material
			arr.push('<input style="border:0px;" type="radio" id="uploadKind0" name="uploadKind" value="course_video" />视频&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind1" name="uploadKind" value="course_courseware" />课件');
		}
		if(mark=='diploma'){
			//diploma material
			arr.push('<input style="border:0px;" type="radio" id="uploadKind0" name="uploadKind" value="student_diploma" />证书&nbsp;');
		}
		if(mark=='studentList'){
			//student material
			arr.push('<input style="border:0px;" type="radio" id="uploadKind0" name="uploadKind" value="student_list" />学员报名表&nbsp;');
			arr.push('<input style="border:0px;" type="radio" id="uploadKind1" name="uploadKind" value="score_list" />考试成绩单&nbsp;');
		}
		$("#radioCover").html(arr.join(""));
		$("input[value='" + loadOp + "']").attr("checked",true);
		
		document.getElementById("lightLoadFile").style.display="block";
		document.getElementById("fadeLoadFile").style.display="block";
	}

</script>
<div valign="baseline">
	<div id="lightLoadFile" class="white_content" STYLE="font-family: Arial; font-size: 12px; color: black"> 
		<div style="align:right;">
		  <span style="align:right;" onclick="document.getElementById('lightLoadFile').style.display='none';document.getElementById('fadeLoadFile').style.display='none'"><img src="../Images/close3.gif" />
		  </span>
		</div>    
		<br>
		<div id="upload" align="left" style="border:solid 1px #e0e060;background:#ffffff;width:500;height:300;">
			<div align="center" style="background:#f0f0f0;vertical-align:middle;height:9;">文件上传</div>
			<div id="radioCover" style="margin: 10px;"></div>
			<form class="comm" action="" id="formUpload" name="formUpload" encType="multipart/form-data"  method="post" target="hidden_frame" >
				<div style="margin: 10px;"><input type="file" id="avatar" name="avatar" style="width:200px;">
				&nbsp;&nbsp;<input name="restore" type="button"  id="restore" value="上传" style="cursor:hand;margin:10px;"></div>
			</form>
		</div>
	</div> 
	<div id="fadeLoadFile" class="black_overlay"></div> 
</div>
