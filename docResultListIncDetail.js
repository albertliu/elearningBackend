				  	<div style="width:98%;float:left;margin:5px;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索：</label>
				          <input type="text" id="txtSearchDocResult" name="txtSearchDocResult" size="20" title="资料类型、标题、内容" style="background:yellow;" />
				          <input class="button" type="button" name="btnSearchDocResult" id="btnSearchDocResult" value="查找">
						      &nbsp;|&nbsp;
						      <input class="button" type="button" id="btnAddDocResult" value="新增" />
						      &nbsp;|&nbsp;
					        <span>
					          资料大类&nbsp;<select id="searchDocResultKind" style="width:100px"></select>
				          </span>
						      &nbsp;&nbsp;
						      <span  style="float:right;">
								    <input class="button" type="button" name="btnDownLoad11" id="btnDownLoad11" onClick="outputFloat(11,'file')" value="下载">
								    <input class="button" type="button" name="btnPrint11" id="btnPrint11" onClick="outputFloat(11,'print')" value="打印">
							    </span>
							    <div id="docResultListLongItem1" style="margin: 2px 0px 0px 0px;">
					          <input style="bdocResult:0px;" type="radio" id="searchDocResultStatus0" name="searchDocResultStatus" value="0" checked />有效&nbsp;
					          <input style="bdocResult:0px;" type="radio" id="searchDocResultStatus1" name="searchDocResultStatus" value="1" />关闭&nbsp;
					          <input style="bdocResult:0px;" type="radio" id="searchDocResultStatus99" name="searchDocResultStatus" value="99" />全部
					          &nbsp;&nbsp;
					          工程&nbsp;<select id="searchDocResultEngineering" style="width:100px"></select>&nbsp;&nbsp;
					          项目&nbsp;<select id="searchDocResultProject" style="width:100px"></select>
				          </div>
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="docResultCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
