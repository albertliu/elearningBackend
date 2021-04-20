				  	<div style="width:100%;float:right;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
						<form><label>搜索:</label>
				          <input type="text" id="txtSearchEnter" name="txtSearchEnter" size="10" title="姓名、身份证" style="background:yellow;" />
				          <input class="button" type="button" id="btnSearchEnter" value="查找" />&nbsp;
				          <input class="button" type="button" id="btnSearchEnterAdd" value="添加" />
						  	<span id="enterListLongItem1">&nbsp;
					          &nbsp;公司&nbsp;<select id="searchEnterHost" style="width:80px"></select>&nbsp;&nbsp;
				          	</span>
							<span id="enterListLongItem2">
					          &nbsp;部门&nbsp;<select id="searchEnterDept" style="width:80px"></select>&nbsp;&nbsp;
				          	</span>
							状态&nbsp;<select id="searchEnterStatus" style="width:50px"></select>&nbsp;&nbsp;
							<span id="enterListLongItem6">
								课程&nbsp;<select id="searchEnterCourseID" style="width:80px"></select>&nbsp;&nbsp;
							</span>
							批次&nbsp;<select id="searchEnterProjectID" style="width:75px"></select>&nbsp;&nbsp;
							班级&nbsp;<select id="searchEnterClassID" style="width:75px"></select>&nbsp;&nbsp;
							<input style="border:0px;" type="checkbox" id="searchEnterShowPhoto" value="" />&nbsp;图片&nbsp;&nbsp;
						    <span style="float:right;">
								<input class="button" type="button" name="btnDownLoad13" id="btnDownLoad13" onClick="outputFloat(101,'file')" value="下载" />
							</span>
							<br>
							<span id="enterListLongItem4">
								状态&nbsp;<select id="searchEnterPhotoStatus" style="width:50px"></select>&nbsp;&nbsp;
								单位确认&nbsp;<select id="searchEnterChecked" style="width:50px"></select>&nbsp;&nbsp;
								材料确认&nbsp;<select id="searchEnterMaterialChecked" style="width:50px"></select>&nbsp;&nbsp;
								<input class="button" type="button" id="btnEnterBadPhoto" value="修正通知" />&nbsp;&nbsp;
								<input class="button" type="button" id="btnEnterGoodPhoto" value="修正确认" />
							</span>
							<span id="enterListLongItem3">
							    &nbsp;报名日期&nbsp;<input type="text" id="searchEnterStartDate" size="8" />-<input type="text" id="searchEnterEndDate" size="8" />
							</span>
							<span id="enterListLongItem5">
								<input class="button" type="button" id="btnEnterSel" value="全选/取消" />&nbsp;&nbsp;
								<input class="button" type="button" id="btnEnterCheck" value="材料确认" />&nbsp;&nbsp;
								<input class="button" type="button" id="btnEnterPasscard" value="做准考证" />&nbsp;&nbsp;
								已做准考证&nbsp;<select id="searchEnterPasscard" style="width:50px"></select>&nbsp;&nbsp;
							</span>
				        </form>
							</div>
							<hr size="1" noshadow />
							<div id="enterCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
