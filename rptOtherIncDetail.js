				<div style="width:100%;float:right;margin:0;">
					<div class="comm" align='left' style="background:#fdfdfd;">
						<form>
								<div>
									<span>日期&nbsp;&nbsp;<input type="text" id="rptOtherStartDate" size="9" />&nbsp;-&nbsp;<input type="text" id="rptOtherEndDate" size="9" /></span>
									<span style="padding-left:50px;">
										<a class="easyui-linkbutton" id="btnRptOther" href="javascript:void(0)"></a>&nbsp;&nbsp;
										<a class="easyui-linkbutton" id="btnRptOtherDownLoad" href="javascript:void(0)"></a>&nbsp;&nbsp;
										<a class="easyui-linkbutton" id="btnRptOtherPrint" href="javascript:void(0)"></a>
									</span>
									<span id="rptOtherItem1" style="padding-left: 50px;">
										<input class="easyui-radiobutton" name="rptOtherRadio" value="0" label="" checked />&nbsp;教师&nbsp;&nbsp;
										<input class="easyui-radiobutton" name="rptOtherRadio" value="1" label="" />&nbsp;班主任&nbsp;&nbsp;
									</span>
									<span id="rptOtherItem2">
										<input class="easyui-radiobutton" name="rptOtherRadio" value="2" label="" />&nbsp;学生来源&nbsp;&nbsp;
										<input class="easyui-radiobutton" name="rptOtherRadio" value="3" label="" />&nbsp;课程
									</span>
								</div>
				        </form>
					</div>
					<hr size="1" noshadow />
					<div style="display: flex; width:100%">
						<div id="rptOtherCoverItem" style="width:100px;">
							<input class="button" type="button" id="btnRptOther1" value="新开班统计" style="padding:0 10px 0 10px;height:28px;margin:5px;" />
							<br />
							<input class="button" type="button" id="btnRptOther2" value="工作量统计" style="padding:0 10px 0 10px;height:28px;margin:5px;" />
							<br />
							<input class="button" type="button" id="btnRptOther3" value="通过率统计" style="padding:0 10px 0 10px;height:28px;margin:5px;" />
							<br />
							<input class="button" type="button" id="btnRptOther4" value="课程招生量" style="padding:0 10px 0 10px;height:28px;margin:5px;" />
							<br />
							<input class="button" type="button" id="btnRptOther5" value="客户招生量" style="padding:0 10px 0 10px;height:28px;margin:5px;" />
						</div>
						<div id="rptOtherCover" style="flex-grow: 1;">
						</div>	
					</div>
				</div>
