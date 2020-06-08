				  	<div style="width:100%;float:right;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
						<form><label>搜索:</label>
				          <input type="text" id="txtSearchStudentCourse" name="txtSearchStudentCourse" size="14" title="姓名、身份证" style="background:yellow;" />
				          <input class="button" type="button" id="btnSearchStudentCourse" value="查找">
					          &nbsp;&nbsp;公司&nbsp;<select id="searchStudentCourseHost" style="width:100px"></select>&nbsp;&nbsp;
					          类别&nbsp;<select id="searchStudentCourseKind" style="width:60px"></select>&nbsp;&nbsp;
					          状态&nbsp;<select id="searchStudentCourseStatus" style="width:40px"></select>&nbsp;&nbsp;
					          课程&nbsp;<select id="searchStudentCourseID" style="width:80px"></select>&nbsp;&nbsp;
		          			<input style="border:0px;" type="checkbox" id="searchStudentCourseOld" value="">&nbsp;55岁以上&nbsp;&nbsp;
					        <span id="studentCourseListLongItem1">
							    &nbsp;选课日期&nbsp;<input type="text" id="searchStudentCourseStartDate" size="8" />-<input type="text" id="searchStudentCourseEndDate" size="8" />
				          	</span>
						    <span style="float:right;">
								<input class="button" type="button" name="btnDownLoad13" id="btnDownLoad13" onClick="outputFloat(13,'file')" value="下载">
							</span>
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="studentCourseCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
