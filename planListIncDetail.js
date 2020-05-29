				  	<div style="width:100%;float:left;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索：</label>
				          <input type="text" id="txtSearchPlan" name="txtSearchPlan" size="20" title="名称" style="background:yellow;" />
				          <input class="button" type="button" name="btnSearchPlan" id="btnSearchPlan" value="查找">
						      &nbsp;|&nbsp;
						      <input class="button" type="button" id="btnAddPlan" value="新增" />
						      &nbsp;|&nbsp;
					        <span id="planListLongItem1">
					          <input style="border:0px;" type="radio" id="searchPlanStatus0" name="searchPlanStatus" value="0" />草稿&nbsp;
					          <input style="border:0px;" type="radio" id="searchPlanStatus1" name="searchPlanStatus" value="1" />活动&nbsp;
							      <input style="border:0px;" type="radio" id="searchPlanStatus2" name="searchPlanStatus" value="2" />完成&nbsp;
					          <input style="border:0px;" type="radio" id="searchPlanStatus99" name="searchPlanStatus" value="99" checked />全部
							      &nbsp;|&nbsp;;
						        <label>范围&nbsp;</label><select id="searchPlanPrivate" style="width:50px"></select>
				          </span>
						      &nbsp;&nbsp;
						      <span  style="float:right;">
								    <input class="button" type="button" name="btnDownLoad11" id="btnDownLoad11" onClick="outputFloat(11,'file')" value="下载">
								    <input class="button" type="button" name="btnPrint11" id="btnPrint11" onClick="outputFloat(11,'print')" value="打印">
							    </span>
							    <div style="margin: 2px 0px 0px 0px;">
					          <label>计划周&nbsp;</label>
					          <input type="text" id="txtSearchPlanWeek" name="txtSearchPlanWeek" size="6" title="周数" style="background:#AAFFAA;" />
					          &nbsp;|&nbsp;
					          <input style="border:0px;" type="radio" id="searchPlanKind0" name="searchPlanKind" value="0" />普通&nbsp;
					          <input style="border:0px;" type="radio" id="searchPlanKind1" name="searchPlanKind" value="1" />工程&nbsp;
							      <input style="border:0px;" type="radio" id="searchPlanKind2" name="searchPlanKind" value="2" />项目&nbsp;
					          <input style="border:0px;" type="radio" id="searchPlanKind99" name="searchPlanKind" value="99" checked />全部
							      &nbsp;|&nbsp;
					          工程&nbsp;<select id="searchPlanEngineering" style="width:100px"></select>&nbsp;&nbsp;
					          项目&nbsp;<select id="searchPlanProject" style="width:100px"></select>&nbsp;&nbsp;
					          人员&nbsp;<select id="searchPlanUser" style="width:80px"></select>
				          </div>
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="planCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
