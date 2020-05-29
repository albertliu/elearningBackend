<!--#include file="js/doc.js" -->

<%
if(op == "getUnitList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(unitName like('%" + where + "%') or unitCode like('%" + where + "%') or regNo like('%" + where + "%'))";
	}
	//如果有分类，按照分类查询
	if(kindID > ""){ // 有分类
		s = "kind=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有类型
	if(keyID > ""){
		s = "type=" + keyID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有帮创
	if(String(Request.QueryString("helpOpen")) > ""){
		s = "helpOpen=" + String(Request.QueryString("helpOpen"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有改制
	if(String(Request.QueryString("restruction")) > ""){
		s = "restruction=" + String(Request.QueryString("restruction"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有街道
	if(String(Request.QueryString("street")) > ""){ 
		s = "street=" + String(Request.QueryString("street"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有园区
	if(String(Request.QueryString("park")) > ""){ 
		s = "park=" + String(Request.QueryString("park"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	
	//如果有状态，按照状态查询
	if(status < 99){ // 有分类
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}
	
	sql = " FROM v_unitInfo " + where;
	
	result = getBasketTip(sql,"");
	ssql = "SELECT unitName,unitCode,regNo,parkName,streetName,kindName,regTime,openDate,bossName,bossID,regAddress,address,mainKindName,accountTitle0,bank0,accountBank0,accountTitle1,bank1,accountBank1,accountTitle2,bank2,accountBank2,memo" + sql;
	sql = "SELECT top " + basket + " * " + sql;
	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("unitID").value + "|" + rs("unitName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("unitCode").value + "|" + rs("regNo").value + "|" + rs("kind").value + "|" + rs("kindName").value + "|" + rs("park").value + "|" + rs("parkName").value + "|" + rs("street").value + "|" + rs("streetName").value + "|" + rs("mainKind").value + "|" + rs("mainKindName").value + "|" + rs("subKind").value + "|" + rs("subKindName").value + "|" + rs("restruction").value + "|" + rs("restructionName").value + "|" + rs("helpOpen").value + "|" + rs("helpOpenName").value + "|" + rs("regFund").value + "|" + rs("regTime").value + "|" + rs("regAddress").value;
		//23
		result += "|" + rs("openDate").value + "|" + rs("bossID").value + "|" + rs("bossName").value + "|" + rs("address").value + "|" + rs("linker").value + "|" + rs("phone").value + "|" + rs("email").value + "|" + rs("bank0").value + "|" + rs("bank1").value + "|" + rs("bank2").value + "|" + rs("accountBank0").value + "|" + rs("accountBank1").value + "|" + rs("accountBank2").value + "|" + rs("accountTitle0").value + "|" + rs("accountTitle1").value + "|" + rs("accountTitle2").value + "|" + rs("accountTax").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("type").value + "|" + rs("typeName").value;
		result += "|" + rs("parkDate").value + "|" + rs("bossPhone").value + "|" + rs("sexName").value + "|" + rs("age").value;
		rs.MoveNext();
	}
	rs.Close();

	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}
	
if(op == "setUnitCombox"){
	sql = "SELECT unitID,unitName FROM v_unitInfo";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("unitID").value + "|" + rs("unitName").value;
		rs.MoveNext();
	}
	rs.Close();
	if(result > ""){
		result = result.substr(2);
	}
	Response.Write(escape(result));
}	
	
if(op == "getNodeInfo"){
	getUnitInfo();
	Response.Write(result);
}	

if(op == "update"){
	result = 0;
	if(nodeID==0){
		sql = "SELECT unitID FROM unitInfo where unitCode='" + unescape(String(Request.QueryString("unitCode"))) + "' or regNo='" + unescape(String(Request.QueryString("regNo"))) + "'";
		var rs1 = conn.Execute(sql);
		if (!rs1.EOF){
			//该单位已经存在
			nodeID = rs1("unitID").value;
			result = 6;
		}
		rs1.close();
	}
	if(result==0 && unescape(String(Request.QueryString("unitCode")))=="" && unescape(String(Request.QueryString("regNo")))==""){
		result = 1;  //组织机构代码和注册码必须填一个。
	}
	if(result==0 && unescape(String(Request.QueryString("unitName")))==""){
		result = 2;  //单位名称不能为空。
	}
	if(result==0 && unescape(String(Request.QueryString("phone")))==""){
		result = 5;  //电话不能为空。
	}
	if(result == 0){
		sql = "exec updateUnitInfo " + nodeID + ",'" + unescape(String(Request.QueryString("unitName"))) + "','" + String(Request.QueryString("unitCode")) + "','" + unescape(String(Request.QueryString("regNo"))) + "','" + status + "','" + kindID + "','" + keyID + "','" + String(Request.QueryString("park")) + "','" + String(Request.QueryString("parkDate")) + "','" + String(Request.QueryString("street")) + "','" + String(Request.QueryString("mainKind")) + "','" + String(Request.QueryString("subKind")) + "','" + String(Request.QueryString("restruction")) + "','" + String(Request.QueryString("helpOpen")) + "','" + String(Request.QueryString("regFund")) + "','" + String(Request.QueryString("regTime")) + "','" + String(Request.QueryString("regAddress")) + "','" + String(Request.QueryString("openDate")) + "','" + String(Request.QueryString("bossID")) + "','";
		sql += unescape(String(Request.QueryString("address"))) + "','" + unescape(String(Request.QueryString("linker"))) + "','" + unescape(String(Request.QueryString("phone"))) + "','" + unescape(String(Request.QueryString("email"))) + "','" + unescape(String(Request.QueryString("bank0"))) + "','" + unescape(String(Request.QueryString("bank1"))) + "','" + unescape(String(Request.QueryString("bank2"))) + "','" + unescape(String(Request.QueryString("accountBank0"))) + "','" + unescape(String(Request.QueryString("accountBank1"))) + "','" + unescape(String(Request.QueryString("accountBank2"))) + "','" + unescape(String(Request.QueryString("accountTitle0"))) + "','" + unescape(String(Request.QueryString("accountTitle1"))) + "','" + unescape(String(Request.QueryString("accountTitle2"))) + "','" + unescape(String(Request.QueryString("accountTax"))) + "','" + unescape(String(Request.QueryString("memo"))) + "','" + unescape(String(Request.QueryString("regOperator"))) + "'";
		
		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(unitID) as maxID FROM unitInfo where regOperator='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}
		
	result += "|" + nodeID;
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delUnitInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}
	
if(op == "getUnitInfoByCode"){
	sql = "SELECT unitID FROM unitInfo where unitCode='" + nodeID + "' or regNo='" + nodeID + "'";
	var rs1 = conn.Execute(sql);
	if (!rs1.EOF){
		nodeID = rs1("unitID").value;
		getUnitInfo();
	}
	rs1.Close();
	Response.Write(result);
}	

if(op == "checkID"){
	result = 0;
	if(nodeID.length != 9){
		result = 1;  //组织机构代码应为9位
	}
	if(result == 0){
		sql = "SELECT unitID FROM unitInfo where unitCode='" + nodeID + "'";
		rs = conn.Execute(sql);
		if (!rs.EOF){
			result = 2 + "|" + rs("unitID").value;  //该单位已经存在
		}
		rs.Close();
	}
	Response.Write(result);
}

if(op == "getUnitNameByCode"){  //根据单位代码或组织机构代码返回单位名称
	sql = "SELECT unitName FROM unitInfo where unitCode='" + nodeID + "' or unitID='" + nodeID + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("unitName").value;
	}
	rs.Close();

	Response.Write(escape(result));
}

if(op == "getUnitIDbyName"){  //根据单位名称返回ID
	result = "0";
	sql = "SELECT unitID FROM unitInfo where unitName='" + item + "' or unitCode='" + item + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("unitID").value;
	}
	rs.Close();

	Response.Write(escape(result));
}

if(op == "getStreetIDbyUnit"){
	sql = "SELECT street FROM unitInfo where unitCode='" + nodeID + "' or unitID='" + nodeID + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("street").value;
	}
	rs.Close();

	Response.Write(escape(result));
}

function getUnitInfo(){
	result = "";
	sql = "SELECT *,dbo.getAttachDocGlance(unitID,'unit') as fxAttachFile,dbo.getEmployeeFundsGlance(0,unitID,'','') as fxEmployeeFunds FROM v_unitInfo where unitID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("unitID").value + "|" + rs("unitName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("unitCode").value + "|" + rs("regNo").value + "|" + rs("kind").value + "|" + rs("kindName").value + "|" + rs("park").value + "|" + rs("parkName").value + "|" + rs("street").value + "|" + rs("streetName").value + "|" + rs("mainKind").value + "|" + rs("mainKindName").value + "|" + rs("subKind").value + "|" + rs("subKindName").value + "|" + rs("restruction").value + "|" + rs("restructionName").value + "|" + rs("helpOpen").value + "|" + rs("helpOpenName").value + "|" + rs("regFund").value + "|" + rs("regTime").value + "|" + rs("regAddress").value;
		//22
		result += "|" + rs("openDate").value + "|" + rs("bossID").value + "|" + rs("bossName").value + "|" + rs("address").value + "|" + rs("linker").value + "|" + rs("phone").value + "|" + rs("email").value + "|" + rs("bank0").value + "|" + rs("bank1").value + "|" + rs("bank2").value + "|" + rs("accountBank0").value + "|" + rs("accountBank1").value + "|" + rs("accountBank2").value + "|" + rs("accountTitle0").value + "|" + rs("accountTitle1").value + "|" + rs("accountTitle2").value + "|" + rs("accountTax").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("parkDate").value + "|" + rs("fxAttachFile").value + "|" + rs("fxEmployeeFunds").value;
		//45
		result += "|" + rs("bossPhone").value + "|" + rs("sexName").value + "|" + rs("age").value;
	}
	rs.Close();
}

if(op == "getUnitListJson"){

	sql = "SELECT unitID,unitName,unitCode,regNo FROM unitInfo";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("unitID").value + "|" + rs("unitName").value + "|" + rs("unitCode").value + " " + rs("regNo").value + "";
		rs.MoveNext();
	}
	rs.Close();
	if(result > ""){
		result = result.substr(2);
	}
	Response.Write((result));
}

if(op == "getUnitStat"){

	sql = "SELECT * FROM dbo.getUnitStat(" + nodeID + ")";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("title").value + "|" + rs("item").value;
		rs.MoveNext();
	}
	rs.Close();
	if(result > ""){
		result = result.substr(2);
	}
	Response.Write(escape(result));
}
%>
