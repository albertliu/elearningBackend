				  	<div style="width:100%;float:left;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索:</label>
				          <input type="text" id="txtSearchArchiveBorrow" name="txtSearchArchiveBorrow" size="15" title="类型、标题、编号" style="background:yellow;" />
				          <input class="button" type="button" id="btnSearchArchiveBorrow" value="查找">
						      <input class="button" type="button" id="btnAddArchiveBorrow" value="新增" />
					        <span id="archiveBorrowListLongItem1">
					          &nbsp;状态<select id="searchArchiveBorrowStatus" style="width:50px"></select>&nbsp;
					          &nbsp;类型<select id="searchArchiveBorrowKind" style="width:80px"></select>
				          </span>
							    &nbsp;日期<input type="text" id="searchArchiveBorrowStartDate" size="8" />-<input type="text" id="searchArchiveBorrowEndDate" size="8" />
						      <span  style="float:right;">
								    <input class="button" type="button" onClick="outputFloat(31,'file')" value="下载">
							    </span>
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="archiveBorrowCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
