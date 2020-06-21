				<div style="width:100%;float:right;margin:0;">
					<div class="comm" align='left' style="background:#fdfdfd;">
						<form>
						<table style="width:100%;"><tr>
							<td style="float:left;">
								&nbsp;&nbsp;公司&nbsp;<select id="rptTrainningHost" style="width:100px"></select>&nbsp;&nbsp;
								类别&nbsp;<select id="rptTrainningKind" style="width:60px"></select>&nbsp;&nbsp;
								课程&nbsp;<select id="rptTrainningCourse" style="width:100px"></select>&nbsp;&nbsp;
								状态&nbsp;<select id="rptTrainningStatus" style="width:50px"></select>&nbsp;&nbsp;
								&nbsp;选课日期&nbsp;<input type="text" id="rptTrainningStartDate" size="8" />-<input type="text" id="rptTrainningEndDate" size="8" />
								</td>
							<td rowspan="2">
								<div style="float:right;padding-left:15px;">
								<input class="button" type="button" id="btnRptTrainning" value="报表预览" style="padding:2px;height:28px;">&nbsp;&nbsp;
								<input class="button" type="button" id="btnRptTrainningDownLoad" value="报表下载" style="padding:2px;height:28px;">
								</div>
							</td></tr>
							<tr>
							<td style="float:left;">
								汇总项目&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptTrainningGroupHost" value="">&nbsp;公司&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptTrainningGroupDept" value="">&nbsp;部门&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptTrainningGroupKind" value="">&nbsp;类别&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptTrainningGroupCourse" value="">&nbsp;课程&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptTrainningGroupStatus" value="">&nbsp;状态&nbsp;&nbsp;
								<input style="border:0px;" type="radio" id="rptTrainningGroupDate1" name="rptTrainningGroupDate" value="month" checked />月度
								<input style="border:0px;" type="radio" id="rptTrainningGroupDate2" name="rptTrainningGroupDate" value="quarter" />季度
								<input style="border:0px;" type="radio" id="rptTrainningGroupDate3" name="rptTrainningGroupDate" value="year" />年度
							</td>
							</tr></table>
				        </form>
					</div>
					<hr size="1" noshadow>
					<div id="rptTrainningCover" style="float:top;margin:0px;background:#f8fff8;"></div>
				</div>
