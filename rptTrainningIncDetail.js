				<div style="width:100%;float:right;margin:0;">
					<div class="comm" align='left' style="background:#fdfdfd;">
						<form>
							<span>
								课程&nbsp;<select id="rptTrainningCourseID" style="width:200px"></select>&nbsp;&nbsp;
							</span>
							<span>
								销售&nbsp;<select id="rptTrainningSales" style="width:100px"></select>&nbsp;&nbsp;
							</span>
							<span>
								&nbsp;日期&nbsp;<input id="rptTrainningStartDate" class="easyui-datebox" data-options="height:22,width:100" />-<input id="rptTrainningEndDate" class="easyui-datebox" data-options="height:22,width:100" />
							</span>
							&nbsp;&nbsp;<input class="easyui-checkbox" id="rptTrainningMoth" name="rptTrainningMoth" value="1"/>&nbsp;月报&nbsp;
							<span style="padding-left:50px;">
								<a class="easyui-linkbutton" id="btnRptTrainning" href="javascript:void(0)"></a>
								<a class="easyui-linkbutton" id="btnRptTrainningDownLoad" href="javascript:void(0)"></a>
							</span>
				        </form>
					</div>
					<hr size="1" noshadow />
					<div style="width:100%;">
						<table style="width:100%;">
							<tr>
								<td style="width:48%;vertical-align:text-top;">
									<div id="rptTrainningCover" style="margin:0px;background:#f8fff8;"></div>
								</td>
								<td style="width:51%;vertical-align:text-top;">
									<div id="rptTrainningDetailCover" style="margin:0px;padding-left:10px;background:#f8fff8;">&nbsp;</div>
								</td>
							</tr>
						</table>
					</div>
				</div>
