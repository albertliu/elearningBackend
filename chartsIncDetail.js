				  	<div style="width:100%;float:left;margin:0;">
							<div charts="comm" align='left' style="background:#fdfdfd;">
								<form>
				          <input class="button" type="button" id="btnSearchCharts" value="查询" />&nbsp;&nbsp;
					          &nbsp;课程&nbsp;<select id="searchChartsCert" style="width:120px"></select>&nbsp;
					          <label id="searchChartsDateItem">日期</label>&nbsp;<input type="text" id="searchChartsStartDate" size="8" />-<input type="text" id="searchChartsEndDate" size="8" />
							  &nbsp;&nbsp;&nbsp;&nbsp;汇总方式&nbsp;&nbsp;
								<input style="border:0px;" type="radio" id="rptChartsGroupDate1" name="rptChartsGroupDate" value="d" />日
								<input style="border:0px;" type="radio" id="rptChartsGroupDate2" name="rptChartsGroupDate" value="w" checked />周
								<input style="border:0px;" type="radio" id="rptChartsGroupDate3" name="rptChartsGroupDate" value="m" />月
								<input style="border:0px;" type="radio" id="rptChartsGroupDate4" name="rptChartsGroupDate" value="y" />年
							&nbsp;&nbsp;&nbsp;&nbsp;快速选择&nbsp;&nbsp;
								<input style="border:0px;" type="radio" id="rptChartsDate1" name="rptChartsDate" value="1" />最近一周
								<input style="border:0px;" type="radio" id="rptChartsDate2" name="rptChartsDate" value="2" checked />最近三个月
								<input style="border:0px;" type="radio" id="rptChartsDate3" name="rptChartsDate" value="3" />最近一年
				        </form>
							</div>
							<hr size="1" noshadow />
							<div id="chartsTotal" style="padding:3px; background:#f8f8f8;"></div>
							<div id="chartsCover" style="float:left;margin:0px;background:#f8fff8;width: 60%;height:605px;"></div>
							<div id="chartsPie1" style="float:right;margin:0px;background:#f8f8ff;width: 40%;height:300px;"></div>
							<div style="float:right;margin:0px;background:#dddddd;width: 40%;height:5px;"></div>
							<div id="chartsPie2" style="float:right;margin:0px;background:#f8f8ff;width: 40%;height:300px;"></div>
						</div>
