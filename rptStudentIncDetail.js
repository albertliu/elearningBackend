				<div style="width:100%;float:right;margin:0;">
					<div class="comm" align='left' style="background:#fdfdfd;">
						<form>
							<input class="button" type="button" id="btnRptStudent" value="查找">
							<span >
								&nbsp;&nbsp;公司&nbsp;<select id="rptStudentHost" style="width:100px"></select>&nbsp;&nbsp;
								类别&nbsp;<select id="rptStudentKind" style="width:60px"></select>&nbsp;&nbsp;
								&nbsp;注册日期&nbsp;<input type="text" id="rptStudentStartDate" size="8" />-<input type="text" id="rptStudentEndDate" size="8" />
								&nbsp;&nbsp;汇总项目&nbsp;&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptStudentGroupHost" value="">&nbsp;公司&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptStudentGroupDept" value="">&nbsp;部门&nbsp;&nbsp;
								<input style="border:0px;" type="checkbox" id="rptStudentGroupKind" value="">&nbsp;类别&nbsp;&nbsp;
								<input style="border:0px;" type="radio" id="rptStudentGroupDate1" name="rptStudentGroupDate" value="month" checked />月度
								<input style="border:0px;" type="radio" id="rptStudentGroupDate2" name="rptStudentGroupDate" value="quarter" />季度
								<input style="border:0px;" type="radio" id="rptStudentGroupDate3" name="rptStudentGroupDate" value="year" />年度
							</span>
							<span style="float:right;">
								<input class="button" type="button" id="btnDownLoad61" onClick="outputFloat(61,'file')" value="下载">
							</span>
				        </form>
					</div>
					<hr size="1" noshadow>
					<div id="rptStudentCover" style="float:top;margin:0px;background:#f8fff8;"></div>
				</div>
