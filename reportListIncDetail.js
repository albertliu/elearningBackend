
						<div class="urbangreymenu" style="width:24%;float:left;">
							<h3 class="headerbar">统计查询项目</h3>
							<ul class="submenu">
							<li id="c_report1"><a href="javascript:void();">超期保存档案</a></li>
							<li id="c_report2"><a href="javascript:void();">分类汇总统计</a></li>
							<li id="c_report3"><a href="javascript:void();">工作量统计</a></li>
							<li id="c_report4"></li>
							<li id="c_report5"></li>
							<li>&nbsp;</li>
							<li>&nbsp;</li>
							<li>&nbsp;</li>
							</ul>
						</div>

				  	<div style="width:75%;float:right;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<div id='map' align='left' style='background:#f9f9f9; padding-left:10px; height:18px;'>&nbsp;</div>
								<form><label>搜索:</label>
					        <span id="reportListItem1">
				          <input type="text" id="txtSearchReport" name="txtSearchReport" size="12" title="类型、标题、编号" style="background:yellow;" />
				          </span>
				          <input class="button" type="button" id="btnSearchReport" value="查找">
					        <span id="reportListItem4">
					          状态<select id="searchReportStatus" style="width:60px"></select>
				          </span>
					        <span id="reportListItem2">
					          类型<select id="searchReportKind" style="width:90px"></select>
					          科目<select id="searchReportType" style="width:150px"></select>
				          </span>
	          			<input style="border:0px;" type="checkbox" id="searchReportBox1" value=""><span id="searchReportBoxTitle1">未成卷</span>
						      <span style="float:right;">
								    <input class="button" type="button" id="btnDownLoadReport" value="下载">
							    </span>
							    <div style="margin:2px;">
							    日期&nbsp;<input type="text" id="searchReportStartDate" size="8" />-<input type="text" id="searchReportEndDate" size="8" />
					        <span id="reportListItem3">
					        	&nbsp;&nbsp;汇总项目
										<input style="border:0px;" type="checkbox" id="searchReportGroup1" value="" checked>分类科目&nbsp;
										<input style="border:0px;" type="checkbox" id="searchReportGroup2" value="" checked>所属年度
									</span>
							    </div>
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="reportCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
