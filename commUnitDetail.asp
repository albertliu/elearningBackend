					  	  <div style="width:58%;float:left;margin:0;">
			            <div id="unitCover">
									</div>
	              </div>
					  	  <div style="width:42%;float:right;margin:0;">
								 <div id="unitDetail" class="lineDiv">
	                <form class="comm" method="post" action="unitControl.asp?op=update" id="formUnit" name="formUnit" onSubmit="checkFormUnit()">
	                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="line-height:2px;">
		                <tr>
			                <td>单位编号</td>
			                <td><input class="readOnly" id="unitID" name="unitID" type="text" size="13" readOnly="true" /></td>
			                <td>曾用编号</td>
			                <td><input class="readOnly" id="unitOldID" name="unitOldID" type="text" size="11" readOnly="true" /></td>
		                </tr>
		                <tr>
			                <td>单位名称</td>
			                <td colspan="3"><input class="mustFill" id="unitName" name="unitName" type="text" size="40" />
			                	<input class="button" type="image" src="images\find2.png" id="btnUnitLog1" onClick="return false;" />
			                </td>
		                </tr>
		                <tr>
			                <td>单位地址</td>
			                <td colspan="3"><input class="mustFill" id="address" name="address" type="text" size="45" /></td>
		                </tr>
		                <tr>
			                <td>机构代码</td>
			                <td><input class="mustFill" id="unitCode" name="unitCode" type="text" size="13" /></td>
			                <td>状态</td><input id="status_old" name="status_old" type="hidden" />
			                <td><select id="status" name="status" style="width:55px"></select>
			                	<span id="contractFile" title="合同扫描">&nbsp;</span>
			                </td>
		                </tr>
		                <tr>
			                <td>联系电话</td>
			                <td><input class="mustFill" id="phone" name="phone" type="text" size="13" /></td>
			                <td>传真号码</td>
			                <td><input id="fax" name="fax" type="text" size="11" /></td>
		                </tr>
		                <tr>
			                <td>电子邮件</td>
			                <td><input id="email" name="email" type="text" size="13" /></td>
			                <td>联系人</td>
			                <td><input class="mustFill" id="linker" name="linker" type="text" size="11" /></td>
		                </tr>
		                <tr>
			                <td>邮政编码</td>
			                <td><input class="mustFill" id="zip" name="zip" type="text" size="13" /></td>
			                <td>信用等级</td>
			                <td><input id="credit" name="credit" type="text" size="5" />0～5</td>
		                </tr>
		                <tr>
			                <td>保管方式</td>
			                <td><input id="keepKind_old" name="keepKind_old" type="hidden" />
												<select id="keepKind" name="keepKind" style="width:90px"></select>
			                </td>
			                <td>单位类型</td>
			                <td><input id="type_old" name="type_old" type="hidden" />
												<select id="type" name="type" style="width:85px"></select>
			                </td>
		                </tr>
		                <tr id="self1">
			                <td>自管标识</td>
			                <td><input id="locMark" name="locMark" type="text" size="13" /></td>
			                <td>自管模式</td><input id="selfMode_old" name="selfMode_old" type="hidden" />
			                <td><select id="selfMode" name="selfMode" style="width:60px"></select>
			                	<input class="button" type="image" src="images\find.png" id="btnAgentList" onClick="return false;" />
			                </td>
		                </tr>
		                <tr id="agent1">
			                <td>收费标准</td>
			                <td><input id="price" name="price" type="text" size="13" /></td>
			                <td>缴费周期</td>
			                <td><input id="period" name="period" type="text" size="5" />(月)</td>
		                </tr>
		                <tr id="agent2">
			                <td>合同情况</td>
			                <td>
												<select id="contractMark" name="contractMark" style="width:90px"></select>
			                </td>
			                <td>当前合同</td>
			                <td><input class="readOnly" id="currContract" name="currContract" type="text" size="11" readOnly="true" /></td>
		                </tr>
		                <tr>
			                <td>备注</td>
			                <td colspan="3"><textarea id="memo" name="memo" cols="34" rows="2"></textarea></td>
		                </tr>
		                <tr>
			                <td>登记日期</td>
			                <td><input class="readOnly" id="regDate" name="regDate" type="text" size="13" readOnly="true" /></td>
			                <td>登记人</td>
			                <td><input id="regOperator" name="regOperator" type="hidden" />
			                	<input class="readOnly" id="regOperatorName" name="regOperatorName" type="text" size="11" readOnly="true" />
			                </td>
		                </tr>
		                <tr>
			                <td colspan="4" align="left">&nbsp;<input class="button" type="button" id="hasChangeName" value="更名" /></td>
		                </tr>
	                </table>
	                <hr color="#c0c0c0" noshadow>
			            <div align="center">
			            	<input class="button" type="submit" id="save" name="save" value="保存" />&nbsp;&nbsp;&nbsp;&nbsp;
			            	<input class="button" type="button" id="del" name="del" value="删除" />&nbsp;&nbsp;&nbsp;&nbsp;
			            	<input class="button" type="button" id="addNew" name="addNew" value="新增" />
				            <input class="button" type="button" id="receiveReNameDoc" name="receiveReNameDoc" value="更名函接收" />
				            <input class="button" type="button" id="reNameUnit" name="reNameUnit" value="修改单位名称" />
				            <input class="button" type="button" id="reCodeUnit" name="reCodeUnit" value="修改机构代码" />
			            </div>
	                </form>
	              </div>
	            </div>
