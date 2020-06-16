				  	<div style="width:100%;float:right;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索:</label>
				          <input type="text" id="txtSearchStudent" name="txtSearchStudent" size="14" title="姓名、身份证" style="background:yellow;" />
				          <input class="button" type="button" id="btnSearchStudent" value="查找">
					        <span id="studentListLongItem1">
					          &nbsp;&nbsp;公司&nbsp;<select id="searchStudentHost" style="width:100px"></select>&nbsp;&nbsp;
					          类别&nbsp;<select id="searchStudentKind" style="width:60px"></select>&nbsp;&nbsp;
		          			<input style="border:0px;" type="checkbox" name="searchStudentOld" id="searchStudentOld" value="">&nbsp;55岁以上&nbsp;&nbsp;
		          			<input style="border:0px;" type="checkbox" name="searchStudentPhoto" id="searchStudentPhoto" value="">&nbsp;缺照片&nbsp;&nbsp;
		          			<input style="border:0px;" type="checkbox" name="searchStudentIDcard" id="searchStudentIDcard" value="">&nbsp;缺身份证&nbsp;
				          </span>
							    &nbsp;注册日期&nbsp;<input type="text" id="searchStudentStartDate" size="8" />-<input type="text" id="searchStudentEndDate" size="8" />
						      <span style="float:right;">
								    <input class="button" type="button" id="btnDownLoad11" onClick="outputFloat(11,'file')" value="下载">
							    </span>
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="studentCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
