					  	  <div style="width:59%;float:left;margin:0;">
								 <div id="new_accountInfo" style="background:#ffffdd;">
					  	  	<div class='comm'><span style="padding-left:30px;font-size:13px;font-weight:bold;color: #3F410F;">未出账单</span>&nbsp;&nbsp;
					  	  		<input class="button" type="button" id="newAccount" name="newAccount" value="现在结算" />&nbsp;&nbsp;
					  	  		<input class="button" type="button" id="editNewAccount" name="editNewAccount" value="修改帐期" />&nbsp;&nbsp;
					  	  		<input class="button" type="button" id="preNewAccount" name="preNewAccount" value="费用估算" />&nbsp;&nbsp;
					  	  		<input class="button" type="button" id="showNewAccount" name="showNewAccount" value="查看账单" />
					  	  	</div>
	                <hr size="1" color="#c0c0c0" noshadow>
	                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="line-height:18px;">
		                <tr>
			                <td>&nbsp;起始日期</td><input id="new_accountCode" name="new_accountCode" type="hidden" />
			                <td align="left"><div id="new_accountStartDate">&nbsp;</div></td>
			                <td>截止日期</td>
			                <td align="left"><div id="new_accountEndDate">&nbsp;</div></td>
			                <td>单价</td>
			                <td align="left"><div id="new_accountPrice">&nbsp;</div></td>
		                </tr>
		              </table>
								 </div>
								 <br>
			            <div id="accountCover">
									</div>
	              </div>
					  	  <div style="width:41%;float:right;margin:0;">
								 <div id="accountDetail"  class="lineDiv">
	                <form class="comm" method="post" action="accountControl.asp?op=update" id="formAccount" name="formAccount" onSubmit="return checkFormAccount()">
	                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="line-height:2px;">
		                <tr>
			                <td>账单编号</td><input id="accountID" name="accountID" type="hidden" /><input id="willPay" name="willPay" type="hidden" />
			                <td><input class="readOnly" id="accountCode" name="accountCode" type="text" size="10" readOnly="true" /></td>
			                <td>状态</td><input id="accountStatus_old" name="accountStatus_old" type="hidden" />
			                <td><select id="accountStatus" name="accountStatus" style="width:80px"></select></td>
		                </tr>
		                <tr>
			                <td>起始日期</td>
			                <td><input class="readOnly" id="accountStartDate" name="accountStartDate" type="text" size="10" readOnly="true" /></td>
			                <td>截止日期</td>
			                <td><input class="readOnly" id="accountEndDate" name="accountEndDate" type="text" size="10" readOnly="true" /></td>
		                </tr>
		                <tr>
			                <td>本期数量</td>
			                <td><input class="readOnly" id="calBase" name="calBase" type="text" size="8" readOnly="true" />&nbsp;天</td>
			                <td>单价</td>
			                <td><input class="readOnly" id="accountPrice" name="accountPrice" type="text" size="10" readOnly="true" /></td>
		                </tr>
		                <tr>
			                <td>本期费用</td>
			                <td><input class="readOnly" id="account" name="account" type="text" size="10" readOnly="true" /></td>
			                <td>前期结转</td>
			                <td><input class="readOnly" id="debt" name="debt" type="text" size="10" readOnly="true" /></td>
		                </tr>
		                <tr>
			                <td>减免金额</td>
			                <td><input class="readOnly" id="remit" name="remit" type="text" size="6" readOnly="true" />
			                	<input class="button" type="button" id="showRemit" name="showRemit" value="..." title="申请记录" />
			                	</td>
			                <td>打印日期</td>
			                <td><input class="readOnly" id="noteDate" name="noteDate" type="text" size="10" readOnly="true" /></td>
		                </tr>
		                <tr>
			                <td>备注</td><input id="accountCountUnit" name="accountCountUnit" type="hidden" />
			                <td colspan="2"><textarea id="accountMemo" name="accountMemo" cols="24" rows="4"></textarea>
			                </td>
			                <td><input style="border:0px;" type="checkbox" id="mailReturn" name="mailReturn" />&nbsp;邮寄退回</td>
		                </tr> 
		                <tr>
			                <td>应缴费用</td><input id="shouldPay" name="shouldPay" type="hidden" />
			                <td><input class="readOnly" id="targetPay" name="targetPay" type="text" size="10" readOnly="true" /></td>
			                <td>已缴费用</td>
			                <td><input class="readOnly" id="completedPay" name="completedPay" type="text" size="10" readOnly="true" /></td>
		                </tr>
		                <tr>
			                <td>计费数量</td>
			                <td><input class="readOnly" id="billQty" type="text" size="10" readOnly="true" /></td>
			                <td>欠费金额</td>
			                <td><input class="readOnly" id="needPay" name="needPay" type="text" size="10" readOnly="true" style="font-faimly:arial;color:red;" /></td>
		                </tr>
	                </table>
	                <hr size="1" color="#c0c0c0" noshadow>
			            <div align="center">
			            	<input class="button" type="submit" id="saveAccount" name="saveAccount" value="保存" />
			            	<input class="button" type="button" id="doRemit" name="doRemit" value="申请减免" />
			            	<input class="button" type="button" id="printAccount" name="printAccount" value="打印账单" />
			            	<input class="button" type="button" id="showAccountDetail" name="showAccountDetail" value="明细" />
			            	<input class="button" type="button" id="doPayment" name="doPayment" value="缴费" />
			            	<input class="button" type="button" id="reGenAccount" name="reGenAccount" value="调整帐期" />
			            	<input class="button" type="button" id="reBuildAccount" name="reBuildAccount" value="重新计算" />
			            	<input class="button" type="button" id="refund" name="refund" value="退款" />
			            </div>
	                </form>
	              </div>
								 <div style="border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:8px;">
	                <table class="dir" id="payList">
		              </table>
								 </div>
	            </div>

		<div valign="baseline">
			<div id="payDetail" class="white_content" STYLE="font-family: Arial; font-size: 12px; color: black"> 
				<div align="right">
			  	<span style="text-align:right;" onclick="document.getElementById('payDetail').style.display='none';document.getElementById('fadePayDetail').style.display='none'"><img src="../Images/close3.gif" />
				  </span>
			  </div>    
				<br>
				<form class="comm" method="post" action="accountControl.asp?op=updatePay" name="formPay" id="formPay">
					<h2>支付档案保管费用</h2>
				  <table align="center" width="80%">
				    <tr valign="baseline">
				      <td nowrap align="left"><div id="paySelect">欠费金额</div></td>
				      <td align="left"><input type="hidden" id="accountPayID" name="accountPayID" value="">
				      	<input class="readOnly" type="text" id="wouldPay" name="wouldPay" value="" size="20" readOnly="true">
				      	<input class="readOnly" type="text" id="account_refID" name="account_refID" value="" size="20" readOnly="true">
				      	</td>
				      <td nowrap align="left">实际支付</td>
				      <td align="left"><input class="mustFill" type="text" id="realPay" name="realPay" value="" size="20"></td>
				      <td nowrap align="left">支付日期</td>
				      <td align="left"><input type="text" id="payDate" name="payDate" value="" size="20"></td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap align="left">支付类型</td>
				      <td align="left"><select id="payType" name="payType" style="width:80px"></select>
				      	</td>
				      <td nowrap>凭证号码</td>
				      <td><input type="text" id="checkNo" name="checkNo" value="" size="20"></td>
				      <td nowrap>发票号码</td>
				      <td><input class="mustFill" type="text" id="billNo" name="billNo" value="" size="20"></td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap>备注</td>
				      <td><input type="text" id="payMemo" name="payMemo" value="" size="20"></td>
				      <td nowrap>操作人</td><input type="hidden" id="payOperator" name="payOperator" value="">
				      <td><input class="readOnly" type="text" id="payOperatorName" name="payOperatorName" value="" size="20" readOnly="true"></td>
				      <td nowrap>发票签收</td><input type="hidden" id="billMan" name="billMan" value="">
				      <td><input class="mustFill" type="text" id="billDate" name="billDate" value="" size="20"></td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap align="center" colspan="8" scope="col">
				      	<input class="button" id="savePay" type="submit" value=" 保存 ">&nbsp;&nbsp;&nbsp;
				      	<input class="button" id="delPay" type="button" value=" 删除 ">&nbsp;&nbsp;&nbsp;
				      	<input class="button" id="close" type="button" value=" 关闭 " onclick="document.getElementById('payDetail').style.display='none';document.getElementById('fadePayDetail').style.display='none'">
				      </td>
				    </tr>
				  </table>
				</form>
			</div> 
			<div id="fadePayDetail" class="black_overlay"></div> 
		</div>
