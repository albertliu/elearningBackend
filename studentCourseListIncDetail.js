				  	<div style="width:100%;float:right;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
						<form><label>搜索:</label>
				          <input type="text" id="txtSearchStudentCourse" name="txtSearchStudentCourse" size="10" title="姓名、身份证" style="background:yellow;" />
				          <input class="button" type="button" id="btnSearchStudentCourse" value="查找" />
						  	<span id="studentCourseListLongItem1">&nbsp;
					          &nbsp;公司&nbsp;<select id="searchStudentCourseHost" style="width:80px"></select>&nbsp;&nbsp;
				          	  </span>
							  <span id="studentCourseListLongItem2">
					          &nbsp;部门&nbsp;<select id="searchStudentCourseDept" style="width:90px"></select>&nbsp;&nbsp;
				          	  </span>
					          状态&nbsp;<select id="searchStudentCourseStatus" style="width:40px"></select>&nbsp;&nbsp;
					          课程&nbsp;<select id="searchStudentCourseID" style="width:80px"></select>&nbsp;&nbsp;
					          批次&nbsp;<select id="searchStudentCourseProjectID" style="width:75px"></select>&nbsp;&nbsp;
					          确认&nbsp;<select id="searchStudentCourseChecked" style="width:40px"></select>&nbsp;&nbsp;
							  <span id="studentCourseListLongItem3">
							    &nbsp;报名日期&nbsp;<input type="text" id="searchStudentCourseStartDate" size="8" />-<input type="text" id="searchStudentCourseEndDate" size="8" />
							  </span>
						    <span style="float:right;">
								<input class="button" type="button" id="btnStudentCourseSel" value="全选/取消" />&nbsp;&nbsp;
								<input class="button" type="button" id="btnStudentCourseCheck" value="确认" />&nbsp;&nbsp;
								<input class="button" type="button" id="btnStudentCourseRefuse" value="剔除" />&nbsp;&nbsp;
								<input class="button" type="button" name="btnDownLoad13" id="btnDownLoad13" onClick="outputFloat(13,'file')" value="下载" />
							</span>
				        </form>
							</div>
							<hr size="1" noshadow />
							<div id="studentCourseCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
