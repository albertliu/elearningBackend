<!--#include file="js/doc.js" -->

<%
var fCount = 0;
var fName = "";
var sDate = "";

if (String(Request.QueryString("fName")) != "undefined" && 
    String(Request.QueryString("fName")) != "") { 
  fName = unescape(String(Request.QueryString("fName")));
}

if (String(Request.QueryString("sDate")) != "undefined" && 
    String(Request.QueryString("sDate")) != "") { 
  sDate = unescape(String(Request.QueryString("sDate")));
}

var fileName = Server.MapPath(".") + "\\" + fName;

var conn1 = new ActiveXObject("ADODB.Connection");
//conn1.Provider = "Microsoft.Jet.OLEDB.4.0";
conn1.Provider = "Microsoft.ACE.OLEDB.12.0";
conn1.ConnectionString = "Data Source=" + fileName + ";Extended Properties=Excel 12.0 Xml;";
conn1.CursorLocation = 1;
conn1.Open;

if (kindID=="getStudentList"){	//导入学员名单
	fCount = 19;
	sql = "select * from [ListView$]";
	rs.ActiveConnection = conn1;
	rs.Open(sql);

	result = "";
	var b = 0;		//重复的数据
	var c = 0;		//实际导入的数据
	var d = 0;		//无匹配单位的数据
	var rs1;
	if(!rs.EOF){
		try{
			if(rs.Fields.Count != fCount || rs(1).value=="null" || rs(1).value==null){
				b = -1;		//格式错误
			}
			while(!rs.EOF && rs(3).value != null && b > -1){
				sql = "select ID from archivesMerge where archiveID='" + rs(3).value + "' and dismissDate='" + rs(6).value + "'";
				rs1 = conn.Execute(sql);
				if(!rs1.EOF){
					//the record has existed in current table, don't recover it, but tell an alert message to program.
					result += ",&nbsp;" + rs(3).value + "&nbsp;" + rs(2).value;
					//result += ",&nbsp;" + rs("证件号码").value + "&nbsp;" + rs("姓名").value;
					b += 1;
				}else{
					if(rs(3).value > "" && rs(3).value != "证件号码"){
						//sql = "insert into archivesMerge(kind,archiveID,name,unitName,dismissDate,regLinker,memo,item,regOperator) values(1,'" + rs("证件号码").value + "','" + rs("姓名").value + "','" + rs("单位名称").value + "','" + rs("退工登记日期").value + "','" + rs("工作结束日期").value + "','" + rs("档案所在地备注").value + "','退工单','" + currUser + "')";
						sql = "insert into archivesMerge(kind,archiveID,name,unitName,dismissDate,regLinker,memo,subKind,note,item,regOperator) values(1,'" + rs(3).value + "','" + rs(2).value + "','" + rs(5).value + "','" + rs(6).value + "','" + rs(17).value + " " + rs(18).value + "','" + rs(16).value + "','退工单',1,'" + rs(5).value + "(退工单)','" + currUser + "')";
						execSQL(sql);
						c += 1;
					}
				}
				rs1.close();
				rs.MoveNext();
			}
		}catch(e){
			b = -1;
			c = 0;
			d = 0;
		}
	}
	
	if(c > 0){		//如果有数据导入，需要进一步处理
		sql = "exec dealDismissOrder '" + currUser + "'";
		execSQL(sql);
		sql = "select count(*) as count from archivesMerge where mark=0 and unitID=0 and status=0 and regOperator= '" + currUser + "'";
		var rs2 = conn.Execute(sql);
		if(!rs2.EOF){
			d = rs2("count").value;
		}
		rs2.close();
	}
	
	if(result > ""){
		result = result.substr(1);
	}
	rs.close();
	conn1.close();
	
	result = b + "|" + c + "|" + d + "|" + result;
	Session(kindID) = "select archiveID,name,unitName,dismissDate,memo from archivesMerge where mark=0 and unitID=0 and status=0 and regOperator= '" + currUser + "'";
	Response.Write(escape(result));
}

if (kindID=="getK3unitList"){	//导入房补批复企业名册
	fCount = 10;
	sql = "select * from [ListView$]";
	rs.ActiveConnection = conn1;
	rs.Open(sql);
	
	result = "";
	var err = "";
	var b = 0;		//重复的数据
	var c = 0;		//实际导入的数据
	var d = 0;		//不匹配的数据
	var e = 0;		//当前导入数据的批次号
	var ID = "";
	var rs1;
	
	if(!rs.EOF){
		if(rs.Fields.Count != fCount){
			b = -1;		//格式错误
			//err = "Error:" + rs.Fields.Count + ":" + rs(1).value;
		}
		try{
			rs.MoveNext();
			rs.MoveNext();
			rs.MoveNext();
			rs.MoveNext();
			rs.MoveNext();
			rs.MoveNext();
			rs.MoveNext();	//从第八行开始为数据字段名
			while(!rs.EOF && rs(2).value != null && b > -1){
				ID = rs(2).value;
				sql = "select 1 from inputData_k3_unit where unitName='" + ID + "' and dateStart='" + rs(5).value + "' and dateEnd='" + rs(6).value + "'";
				
				rs1 = conn.Execute(sql);
				if(!rs1.EOF){
					//the record has existed in current table, don't recover it, but tell an alert message to program.
					result += ID + "&nbsp;&nbsp;&nbsp;" + rs(3).value + "\n";
					b += 1;
				}else{
					if(ID > "" && ID != "单位名称"){
						sql = "insert into inputData_k3_unit(unitName,parkName,parkID,dateStart,dateEnd,months,amount,checkStatus,regOperator) values('" + ID + "','" + rs(3).value + "','" + rs(4).value + "','" + rs(5).value + "','" + rs(6).value + "','" + rs(7).value + "','" + rs(8).value + "','" + rs(9).value + "','" + currUser + "')";
						execSQL(sql);
						c += 1;
					}
				}
				rs1.close();
				
				rs.MoveNext();
			}
		}catch(e){
			b = -1;
			c = 0;
			d = 0;
		}
	}
	if(c > 0){		//如果有数据导入，需要进一步处理
		sql = "exec dealK3unit '" + currUser + "'";
		execSQL(sql);
		sql = "select max(groupID) as groupID from inputData_k3_unit where regOperator= '" + currUser + "'";
		var rs2 = conn.Execute(sql);
		if(!rs2.EOF){
			e = rs2("groupID").value;
		}
		rs2.close();
		sql = "select unitName,(case when mark=1 then '单位名称不匹配' when mark=2 then '申请单不匹配,请核对起止日期及审批流程' else '其他错误' end) as err from inputData_k3_unit where mark>0 and groupID=" + e;
		var rs3 = conn.Execute(sql);
		if(!rs3.EOF){
			while (!rs3.EOF){
				d += 1;
				err += "&nbsp;" + rs3("unitName").value + "&nbsp;<font color='red'>" + rs3("err").value + "</font>\n";
				rs3.MoveNext();
			}
		}
		rs3.close();
		
		if(d>0){
			sql = "delete from inputData_k3_unit where mark>0 and groupID=" + e;
			execSQL(sql);
		}
	}

	result = b + "|" + c + "|" + d + "|" + e + "|" + result + "|" + err;

	rs.close();
	conn1.close();
	conn1 = null;
	Response.Write(escape(result));
}

if (kindID=="getK3employeeList"){	//导入房补批复人员名册
	fCount = 0;	//不确定
	sql = "select * from [ListView$]";
	rs.ActiveConnection = conn1;
	rs.Open(sql);
	
	result = "";
	var err = "";
	var b = 0;		//重复的数据
	var c = 0;		//实际导入的数据
	var d = 0;		//不匹配的数据
	var e = 0;		//当前导入数据的批次号
	var ID = "";
	var rs1;
	var m = 0;
	var unitName = "";
	var ar = new Array();
	
	if(!rs.EOF){
		m = rs.Fields.Count;	//列数，从第5列开始为缴纳社保的日期部分
		try{
			//err = rs(9).value;	//第一行第二单元格记录了单位名称（去除最后11位字符）
			//err = unitName.substring(0,unitName.length()-11);
			rs.MoveNext();
			rs.MoveNext();
			rs.MoveNext();
			rs.MoveNext();
			rs.MoveNext();
			rs.MoveNext();
			//rs.MoveNext();	
			for(var i=4;i<m;i++){
				//从第八行开始为数据字段名,将月份名保存起来
				ar[i] = rs(i).value;
			}
			while(!rs.EOF && rs(3).value != null && b > -1){
				ID = rs(3).value;
				if(ID > "" && ID != "身份证号"){
					for(var i=4;i<m;i++){
						if(rs(i).value=="√"){
							sql = "insert into inputData_k3_employee(name,SID,ym,refID,regOperator) values('" + rs(2).value + "','" + ID + "','" + ar[i] + "','" + refID + "','" + currUser + "')";
							execSQL(sql);
						}
					}
					c += 1;
				}
				
				rs.MoveNext();
			}
		}catch(e){
			b = -1;
			c = 0;
			d = 0;
		}
	}
	if(c > 0){		//如果有数据导入，需要进一步处理
		sql = "exec dealK3employee '" + currUser + "'";
		execSQL(sql);
	}

	result = b + "|" + c + "|" + d + "|" + e + "|" + result + "|" + err;

	rs.close();
	conn1.close();
	conn1 = null;
	Response.Write(escape(result));
}

if (kindID=="getK3payList"){	//导入房补支付企业名册
	fCount = 11;
	sql = "select * from [ListView$]";
	rs.ActiveConnection = conn1;
	rs.Open(sql);
	
	result = "";
	var err = "";
	var b = 0;		//重复的数据
	var c = 0;		//实际导入的数据
	var d = 0;		//不匹配的数据
	var e = 0;		//当前导入数据的批次号
	var ID = "";
	var rs1;
	
	if(!rs.EOF){
		if(rs.Fields.Count != fCount){
			b = -1;		//格式错误
			//err = "Error:" + rs.Fields.Count + ":" + rs(1).value;
		}
		try{
			while(!rs.EOF && rs(3).value != null && b > -1){
				ID = rs(3).value;
				if(ID > "" && ID != "单位名称"){
					sql = "insert into inputData_k3_pay(unitCode,unitName,parkName,amount,type,accountTitle,bank,account,accountKind,regOperator) values('" + rs(2).value + "','" + ID + "','" + rs(4).value + "','" + rs(5).value + "','" + rs(6).value + "','" + rs(7).value + "','" + rs(8).value + "','" + rs(9).value + "','" + rs(10).value + "','" + currUser + "')";
					execSQL(sql);
					c += 1;
				}
				rs.MoveNext();
			}
		}catch(e){
			b = -1;
			c = 0;
			d = 0;
		}
	}
	if(c > 0){		//如果有数据导入，需要进一步处理
		sql = "exec dealK3pay '" + currUser + "'";
		execSQL(sql);
		sql = "select max(groupID) as groupID from inputData_k3_pay where regOperator= '" + currUser + "'";
		var rs2 = conn.Execute(sql);
		if(!rs2.EOF){
			e = rs2("groupID").value;
		}
		rs2.close();
		sql = "select unitName,(case when mark=1 then '单位名称不匹配' when mark=2 then '申请单不匹配,请核对审批流程' else '其他错误' end) as err from inputData_k3_pay where mark>0 and groupID=" + e;
		var rs3 = conn.Execute(sql);
		if(!rs3.EOF){
			while (!rs3.EOF){
				d += 1;
				err += "&nbsp;" + rs3("unitName").value + "&nbsp;<font color='red'>" + rs3("err").value + "</font>\n";
				rs3.MoveNext();
			}
		}
		rs3.close();
		
		if(d>0){
			sql = "delete from inputData_k3_pay where mark>0 and groupID=" + e;
			execSQL(sql);
		}
	}

	result = b + "|" + c + "|" + d + "|" + e + "|" + result + "|" + err;

	rs.close();
	conn1.close();
	conn1 = null;
	Response.Write(escape(result));
}

%>
