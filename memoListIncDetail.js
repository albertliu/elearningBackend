				  	<div style="width:100%;float:left;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索：</label>
				          <input type="text" id="txtSearchMemo" name="txtSearchMemo" size="20" title="名称" style="background:yellow;" />
				          <input class="button" type="button" name="btnSearchMemo" id="btnSearchMemo" value="查找">
						      <input class="button" type="button" id="btnAddMemo" value="新增" />
						      &nbsp;|&nbsp;<input id="searchMemoUnit" type="hidden" /><input id="searchMemoUser" type="hidden" />
				          <input style="border:0px;" type="radio" id="searchMemoStatus0" name="searchMemoStatus" value="0" checked />活动&nbsp;
				          <input style="border:0px;" type="radio" id="searchMemoStatus1" name="searchMemoStatus" value="1" />关闭&nbsp;
				          <input style="border:0px;" type="radio" id="searchMemoStatus99" name="searchMemoStatus" value="99" />全部
					        <span id="memoListLongItem1">
							      &nbsp;|&nbsp;
						        <label>范围&nbsp;</label><select id="searchMemoPrivate" style="width:50px"></select>
							      &nbsp;|&nbsp;
							    	<label>日期：</label>
				          	<input type="text" id="searchMemoStart" size="8" title="起始日期" style="background:#AAFFAA;" />
				          	-
				          	<input type="text" id="searchMemoEnd" size="8" title="截止日期" style="background:#AAFFAA;" />
				          </span>
							    <div style="margin: 2px 0px 0px 0px;">
					          <input style="border:0px;" type="radio" id="searchMemoKind0" name="searchMemoKind" value="0" checked />普通&nbsp;
					          <input style="border:0px;" type="radio" id="searchMemoKind1" name="searchMemoKind" value="1" />单位&nbsp;
							      <input style="border:0px;" type="radio" id="searchMemoKind3" name="searchMemoKind" value="3" />节假日&nbsp;
					          <input style="border:0px;" type="radio" id="searchMemoKind99" name="searchMemoKind" value="99" />全部
							      <span  style="float:right;">
									    <input class="button" type="button" name="btnDownLoad10" id="btnDownLoad10" onClick="outputFloat(10,'file')" value="下载">
									    <input class="button" type="button" name="btnPrint10" id="btnPrint10" onClick="outputFloat(10,'print')" value="打印">
								    </span>
				          </div>
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="memoCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
