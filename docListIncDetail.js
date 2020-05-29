				  	<div style="width:100%;float:left;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索：</label>
				          <input type="text" id="txtSearchDoc" name="txtSearchDoc" size="15" title="标题、内容" style="background:yellow;" />
				          <input class="button" type="button" name="btnSearchDoc" id="btnSearchDoc" value="查找">
						      <input class="button" type="button" id="btnAddDoc" name="btnAddDoc" value="新增" />
						      &nbsp;|&nbsp;
				          <input style="border:0px;" type="radio" id="searchDocKind0" name="searchDocKind" value="0" checked />公告&nbsp;
				          <input style="border:0px;" type="radio" id="searchDocKind1" name="searchDocKind" value="1" />通知&nbsp;
						      <input style="border:0px;" type="radio" id="searchDocKind2" name="searchDocKind" value="2" />业务资料
					        <span id="docListLongItem1">
							      &nbsp;|&nbsp;
					          <input style="border:0px;" type="radio" id="searchDocStatus0" name="searchDocStatus" value="0" checked />正常&nbsp;
							      <input style="border:0px;" type="radio" id="searchDocStatus1" name="searchDocStatus" value="1" />关闭&nbsp;
					          <input style="border:0px;" type="radio" id="searchDocStatus9" name="searchDocStatus" value="99" />全部
							      &nbsp;|&nbsp;
							      发布日期&nbsp;<input type="text" id="searchDocStartDate" size="8" />-<input type="text" id="searchDocEndDate" size="8" />
							    </span>
						      <span  style="float:right;">
								    <input class="button" type="button" name="btnDownLoad12" id="btnDownLoad12" onClick="outputFloat(12,'file')" value="下载">
								    <input class="button" type="button" name="btnPrint12" id="btnPrint12" onClick="outputFloat(12,'print')" value="打印">
								  </span>
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="docCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
