				<div style="width:100%;float:right;margin:0;">
					<div class="comm" align='left' style="background:#fdfdfd;">
						<form><label>搜索:</label>
				          <input type="text" id="txtSearchStudentNeedDiploma" name="txtSearchStudentNeedDiploma" size="14" title="姓名、身份证、证书名称" style="background:yellow;" />
				          <input class="button" type="button" id="btnSearchStudentNeedDiploma" value="查找" />
					          &nbsp;&nbsp;公司&nbsp;<select id="searchStudentNeedDiplomaHost" style="width:150px"></select>&nbsp;&nbsp;
							  <span id="searchStudentNeedDiplomaItem2">
							  	&nbsp;&nbsp;单位&nbsp;<select id="searchStudentNeedDiplomaDept" style="width:150px"></select>&nbsp;&nbsp;
							  </span>
					          证书&nbsp;<select id="searchStudentNeedDiplomaCert" style="width:120px"></select>&nbsp;&nbsp;
		          			<input style="border:0px;" type="checkbox" id="searchStudentNeedDiplomaShowPhoto" value="" checked />&nbsp;显示照片&nbsp;&nbsp;
		          			<input style="border:0px;" type="checkbox" id="searchStudentNeedDiplomaRefuse" value="" />&nbsp;拒绝申请&nbsp;&nbsp;
							有照片&nbsp;<select id="searchStudentNeedDiplomaHavePhoto" style="width:50px"></select>&nbsp;
						    <span style="float:right;">
								<input class="button" type="button" id="btnStudentNeedDiplomaSel" value="全选/取消" />&nbsp;&nbsp;
								<input class="button" type="button" id="btnStudentNeedDiplomaIssue" value="制作证书" />&nbsp;&nbsp;
								<input class="button" type="button" id="btnStudentNeedDiplomaIssue1" value="制作证书" />&nbsp;&nbsp;
								<input class="button" type="button" id="btnStudentNeedDiplomaAttentionPhoto" value="照片通知" />
								<input class="button" type="button" id="btnStudentNeedDiplomaAttentionPhotoClose" value="照片确认" />
								<input class="button" type="button" id="btnDownLoad21" onClick="outputFloat(21,'file')" value="下载" />
							</span>
							<br/>
							<hr style="margin:3px 0;" />
							<span id="searchStudentNeedDiplomaItem1">
								班级&nbsp;<select id="searchStudentNeedDiplomaClassID" style="width:180px"></select>&nbsp;&nbsp;
								&nbsp;结课日期&nbsp;<input type="text" id="searchStudentNeedDiplomaCloseStartDate" size="8" />-<input type="text" id="searchStudentNeedDiplomaCloseEndDate" size="8" />
							    &nbsp;考试日期&nbsp;<input type="text" id="searchStudentNeedDiplomaStartDate" size="8" />-<input type="text" id="searchStudentNeedDiplomaEndDate" size="8" />
							</span>
						    <span style="float:right;">
							<label>已选记录:</label>&nbsp;<label style="color: red; padding-right:10px;" id="searchStudentNeedDiplomaPick"></label>
							</span>
				        </form>
					</div>
					<hr size="1" noshadow />
					<div id="studentNeedDiplomaCover" style="float:top;margin:0px;background:#f8fff8;">
					</div>
				</div>
