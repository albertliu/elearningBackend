﻿				  	<div style="width:100%;float:right;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
							<form><label>搜索:</label>
							<input type="text" id="txtSearchGenerateDiploma" name="txtSearchGenerateDiploma" size="14" title="证书编号、证书名称" style="background:yellow;" />
							<input class="button" type="button" id="btnSearchGenerateDiploma" value="查找" />
								<span id="searchGenerateDiplomaItem1">&nbsp;&nbsp;公司&nbsp;<select id="searchGenerateDiplomaHost" style="width:100px"></select></span>
								&nbsp;&nbsp;证书&nbsp;<select id="searchGenerateDiplomaCert" style="width:80px"></select>&nbsp;&nbsp;
								&nbsp;&nbsp;样式&nbsp;<select id="searchGenerateDiplomaStyle" style="width:60px"></select>&nbsp;&nbsp;
								&nbsp;&nbsp;<label>制作日期</label>
								<input type="text" id="searchGenerateDiplomaStart" size="8" title="起始日期" style="background:#AAFFAA;" />
								-
								<input type="text" id="searchGenerateDiplomaEnd" size="8" title="截止日期" style="background:#AAFFAA;" />
								<span style="float:right;">
									<input class="button" type="button" id="btnDownLoad22" onClick="outputFloat(22,'file')" value="下载" />
								</span>
							</form>
							<div id="searchGenerateDiplomaItem">
								<input class="button" type="button" id="btnSearchGenerateDiploma1" value="重新生成" />&nbsp;&nbsp;
								<input type="text" id="txtSearchGenerateDiploma1" name="txtSearchGenerateDiploma1" size="100" title="身份证，用逗号分隔" style="background:yellow;" />
							</div>
						</div>
						<hr size="1" noshadow />
						<div id="generateDiplomaCover" style="float:top;margin:0px;background:#f8fff8;">
						</div>
					</div>
