				  	<div style="width:100%;float:left;margin:0;">
							<div class="comm" align='left' style="background:#fdfdfd;">
								<form><label>搜索:</label>
				          <input type="text" id="txtSearchUnit" name="txtSearchUnit" size="20" title="企业名称、机构代码、注册证书、法人姓名" style="background:yellow;" />
				          <input class="button" type="button" name="btnSearchUnit" id="btnSearchUnit" value="查找">
						      &nbsp;
						      <input class="button" type="button" id="btnAddUnit" name="btnAddUnit" value="新增" />
						      &nbsp;|&nbsp;
				          性质<select id="searchUnitKind" name="searchUnitKind" style="width:100px"></select>
				          园区<select id="searchUnitPark" name="searchUnitPark" style="width:180px"></select>
				          街道<select id="searchUnitStreet" name="searchUnitStreet" style="width:100px"></select>
					        <span id="unitListLongItem1">
					          <input style="border:0px;" type="radio" id="searchUnitStatus0" name="searchUnitStatus" value="0" checked />正常&nbsp;
							      <input style="border:0px;" type="radio" id="searchUnitStatus1" name="searchUnitStatus" value="1" />关闭&nbsp;
					          <input style="border:0px;" type="radio" id="searchUnitStatus9" name="searchUnitStatus" value="99" />全部
							    </span>
							    <div>
					          类型&nbsp;<select id="searchUnitType" name="searchUnitType" style="width:100px"></select>&nbsp;
					          是否帮创<select id="searchUnitHelpOpen" name="searchUnitHelpOpen" style="width:50px"></select>&nbsp;
					          是否转制<select id="searchUnitRestruction" name="searchUnitRestruction" style="width:50px"></select>
							      <span  style="float:right;">
									    <input class="button" type="button" name="btnDownLoad2" id="btnDownLoad2" onClick="outputFloat(2,'file')" value="下载">
									    <input class="button" type="button" name="btnPrint2" id="btnPrint2" onClick="outputFloat(2,'print')" value="打印">
									  </span>
								  </div>
				        </form>
							</div>
							<hr size="1" noshadow>
							<div id="unitCover" style="float:top;margin:0px;background:#f8fff8;">
							</div>
						</div>
