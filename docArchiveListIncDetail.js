				  	<div style="width:98%;float:left;margin:5px;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索：</label>
				          <input type="text" id="txtSearchDocArchive" name="txtSearchDocArchive" size="20" title="资料类型、标题、内容" style="background:yellow;" />
				          <input class="button" type="button" name="btnSearchDocArchive" id="btnSearchDocArchive" value="查找">
						      &nbsp;|&nbsp;
						      <input class="button" type="button" id="btnAddDocArchive" value="新增" />
						      &nbsp;|&nbsp;
					        <span>
					          资料大类&nbsp;<select id="searchDocArchiveKind" style="width:100px"></select>
				          </span>
						      &nbsp;&nbsp;
						      <span  style="float:right;">
								    <input class="button" type="button" name="btnDownLoad11" id="btnDownLoad11" onClick="outputFloat(11,'file')" value="下载">
								    <input class="button" type="button" name="btnPrint11" id="btnPrint11" onClick="outputFloat(11,'print')" value="打印">
							    </span>
							    <div id="docArchiveListLongItem1" style="margin: 2px 0px 0px 0px;">
					          <input style="bdocArchive:0px;" type="radio" id="searchDocArchiveStatus0" name="searchDocArchiveStatus" value="0" checked />有效&nbsp;
					          <input style="bdocArchive:0px;" type="radio" id="searchDocArchiveStatus1" name="searchDocArchiveStatus" value="1" />关闭&nbsp;
					          <input style="bdocArchive:0px;" type="radio" id="searchDocArchiveStatus99" name="searchDocArchiveStatus" value="99" />全部
					          &nbsp;&nbsp;
					          工程&nbsp;<select id="searchDocArchiveEngineering" style="width:100px"></select>&nbsp;&nbsp;
					          项目&nbsp;<select id="searchDocArchiveProject" style="width:100px"></select>
				          </div>
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="docArchiveCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
