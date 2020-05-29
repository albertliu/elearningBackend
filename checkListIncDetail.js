				  	<div style="width:100%;float:left;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索：</label>
				          <input type="text" id="txtSearchCheck" name="txtSearchCheck" size="20" title="名称、内容" style="background:yellow;" />
				          <input class="button" type="button" name="btnSearchCheck" id="btnSearchCheck" value="查找">
						      &nbsp;&nbsp;|&nbsp;&nbsp;
				          状态&nbsp;<select id="searchCheckStatus" style="width:80px"></select>&nbsp;&nbsp;
				          类型&nbsp;<select id="searchCheckKind" style="width:80px"></select>&nbsp;&nbsp;
					        <span id="checkListLongItem1">
							      &nbsp;&nbsp;|&nbsp;&nbsp;
					          <input style="border:0px;" type="radio" id="searchCheckMy0" name="searchCheckMy" value="0" checked />我申请的&nbsp;
					          <input style="border:0px;" type="radio" id="searchCheckMy1" name="searchCheckMy" value="1" />我审批的
				          </span>
							    <div style="margin: 2px 0px 0px 0px;">
							    	<label>日期：</label>
				          	<input type="text" id="searchCheckStart" size="8" title="起始提交日期" style="background:#AAFFAA;" />
				          	&nbsp;-&nbsp;
				          	<input type="text" id="searchCheckEnd" size="8" title="截止审批日期" style="background:#AAFFAA;" />
							      <span  style="float:right;">
									    <input class="button" type="button" name="btnDownLoad13" id="btnDownLoad13" onClick="outputFloat(13,'file')" value="下载">
									    <input class="button" type="button" name="btnPrint13" id="btnPrint13" onClick="outputFloat(13,'print')" value="打印">
								    </span>
							    </div>
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="checkCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
