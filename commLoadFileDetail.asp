<script language="javascript">
	var username = "";
	var action = uploadURL + "/outfiles/uploadSingle";
	//alert(action);
	function showLoadFile(loadOp,loadID){
		//var st = $("input[name='searchMemoStatus']:checked").val();
		$("input[value='" + loadOp + "']").attr("checked",true);
		//$("#loadFileRefKind").val(refKind);
		//$("#loadFileKind").val(kind);
		username = loadID;
		$("#formUpload").attr("action", action + "?upID=" + loadOp + "&username=" + loadID);
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
				  			<div id="upload" align="left" style="border:solid 1px #e0e060;background:#ffffff;width:400;height:300;">
									<div align="center" style="background:#f0f0f0;vertical-align:middle;height:9;">文件上传</div>
									<div style="margin: 10px;">
										<input style="border:0px;" type="radio" id="uploadKind0" name="uploadKind" value="student_photo" />照片&nbsp;
										<input style="border:0px;" type="radio" id="uploadKind1" name="uploadKind" value="student_IDcardA" />身份证正面&nbsp;
										<input style="border:0px;" type="radio" id="uploadKind2" name="uploadKind" value="student_IDcardB" />身份证背面&nbsp;
										<input style="border:0px;" type="radio" id="uploadKind2" name="uploadKind" value="student_education" />学历证书&nbsp;
										<input style="border:0px;" type="radio" id="uploadKind3" name="uploadKind" value="student_diploma" />证书&nbsp;
										<input style="border:0px;" type="radio" id="uploadKind4" name="uploadKind" value="course_video" />视频&nbsp;
										<input style="border:0px;" type="radio" id="uploadKind5" name="uploadKind" value="course_courseware" />课件
									</div>
									<form class="comm" action="" id="formUpload" name="formUpload" encType="multipart/form-data"  method="post" target="hidden_frame" >
										<div style="margin: 10px;"><input type="file" id="avatar" name="avatar" style="width:200px;">
						  				&nbsp;&nbsp;<input name="restore" type="button"  id="restore" value="上传" style="cursor:hand;margin:10px;"></div>
									</form>
				  			</div>
	</div> 
	<div id="fadeLoadFile" class="black_overlay"></div> 
</div>
