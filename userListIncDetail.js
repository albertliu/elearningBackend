				  	<div style="width:100%;float:left;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索：</label>
				          <input type="text" id="txtSearchUser" name="txtSearchUser" size="20" title="姓名、用户名" style="background:yellow;" />
				          <input class="button" type="button" name="btnSearchUser" id="btnSearchUser" value="查找">
						      &nbsp;&nbsp;|&nbsp;&nbsp;
						      <input class="button" type="button" id="btnAddUser" name="btnAddUser" value="新增" />
						      &nbsp;&nbsp;|&nbsp;&nbsp;
				          所属部门<select id="searchUserDeptID" style="width:100px"></select>
						      &nbsp;&nbsp;
					        <span id="userListLongItem1">
							      &nbsp;&nbsp;|&nbsp;&nbsp;
							  状态&nbsp;<select id="searchUserStatus" style="width:50px"></select>
							      &nbsp;&nbsp;|&nbsp;&nbsp;
								    <input class="button" type="button" name="btnDownLoadUser" id="btnDownLoadUser" onClick="outputFloat(20,'file')" value="下载">
								  </span>
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="userCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
