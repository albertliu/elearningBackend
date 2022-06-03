				  	<div style="width:100%;float:right;margin:0;">
						<div class="comm" align='left' style="background:#fdfdfd;">
							<form><label>搜索:</label>
								<input type="text" id="txtSearchDiploma" name="txtSearchDiploma" size="14" title="姓名、身份证、单位名称、证书编号" style="background:yellow;" />
								<input class="button" type="button" id="btnSearchDiploma" value="查找" />
								<span id="diplomaListLongItem1">&nbsp;&nbsp;
									&nbsp;&nbsp;公司&nbsp;<select id="searchDiplomaHost" style="width:100px"></select>&nbsp;&nbsp;
								</span>
								<span id="diplomaListLongItem2">&nbsp;&nbsp;
									&nbsp;&nbsp;部门&nbsp;<select id="searchDiplomaDept" style="width:100px"></select>&nbsp;&nbsp;
								</span>
								证书&nbsp;<select id="searchDiplomaKind" style="width:100px"></select>&nbsp;&nbsp;
								状态&nbsp;<select id="searchDiplomaStatus" style="width:60px"></select>&nbsp;&nbsp;
								&nbsp;发证日期&nbsp;<input type="text" id="searchDiplomaStartDate" size="8" />-<input type="text" id="searchDiplomaEndDate" size="8" />
								<span style="float:right;">
									<input class="button" type="button" id="btnDownLoad20" onClick="outputFloat(20,'file')" value="下载" />
								</span>
							</form>
						</div>
						<hr size="1" noshadow />
						<div id="diplomaCover" style="float:top;margin:0px;background:#f8fff8;">
						</div>
					</div>
