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
							<span id="enterListLongItem7">
								状态&nbsp;<select id="searchEnterStatus" style="width:50px"></select>&nbsp;&nbsp;
							</span>
							<span id="enterListLongItem6">
								课程&nbsp;<select id="searchEnterCourseID" style="width:80px"></select>&nbsp;&nbsp;
							</span>
							<span id="enterListLongItem9">
								批次&nbsp;<select id="searchEnterProjectID" style="width:180px"></select>&nbsp;
							</span>
							<span>
								&nbsp;&nbsp;学习进度&nbsp;&gt;=<input type="text" id="searchEnter_completion1" size="2" />%
								&nbsp;&nbsp;模拟成绩&nbsp;&gt;=<input type="text" id="searchEnter_score1" size="2" />
								<input class="easyui-checkbox" id="searchEnterInvoice" name="searchEnterInvoice" value="1"/>&nbsp;开票&nbsp;
							</span>
						    <span style="float:right;">
								<input class="button" type="button" id="btnSearchEnterDownload" value="下载" />
							</span>
							<br/>
							<hr style="margin:3px 0;" />
							<span id="enterListLongItem4">
								状态&nbsp;<select id="searchEnterPhotoStatus" style="width:50px"></select>&nbsp;&nbsp;
								单位确认&nbsp;<select id="searchEnterChecked" style="width:50px"></select>&nbsp;&nbsp;
								材料确认&nbsp;<select id="searchEnterMaterialChecked" style="width:50px"></select>&nbsp;&nbsp;
							</span>
							<span id="enterListLongItem3">
								班主任&nbsp;<select id="searchEnterClassAdviser" style="width:90px"></select>&nbsp;&nbsp;
								班级&nbsp;<select id="searchEnterClassID" style="width:180px"></select>&nbsp;&nbsp;
								类别&nbsp;<select id="searchEnterReexamine" style="width:50px"></select>&nbsp;&nbsp;
								<input class="easyui-checkbox" id="searchEnterPre" name="searchEnterPre" value="1"/>&nbsp;预备班&nbsp;
							    &nbsp;<label id="searchEnterDateItem">报名日期</label>&nbsp;<input type="text" id="searchEnterStartDate" size="8" />-<input type="text" id="searchEnterEndDate" size="8" />
							</span>
							<input style="border:0px;" type="checkbox" id="searchEnterShowPhoto" value="" />&nbsp;显示照片&nbsp;
							<input class="button" type="button" id="btnEnterBadPhoto" value="照片通知" />&nbsp;&nbsp;
							<input class="button" type="button" id="btnEnterGoodPhoto" value="照片确认" />
							<input class="button" type="button" id="btnEnterSel" value="全选/取消" />&nbsp;&nbsp;
							<span id="enterListLongItem5">
								<input class="button" type="button" id="btnEnterCheck" value="材料确认" />&nbsp;
								准考证/申报&nbsp;<select id="searchEnterPasscard" style="width:50px"></select>&nbsp;
								<input class="button" type="button" id="btnEnterCall" value="催材料" />&nbsp;
							</span>
							<span style="float:right;margin-right:20px;">
								<input class="button" type="button" id="btnEnterCartAdd" value="加入购物车" />&nbsp;&nbsp;&nbsp;&nbsp;
								<label>已选记录:</label>&nbsp;<label style="color: red; padding-right:10px;" id="searchEnterPick"></label>
							</span>
							<span style="float:right;margin-right:10px;"><img id="cart_examer_img" src="images/cart.png" /></span>
							<span id="cart_examer" style="float:right;">0</span>
				        </form>
							</div>
							<hr style="margin:3px 0;" noshadow />
							<div id="enterCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
