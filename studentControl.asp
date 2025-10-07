<!--#include file="js/doc.js" -->

<%

if(op == "getStudentList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "')";
	}
	/*
	//如果有公司
	if(host > ""){ // 
		s = "host='" + host + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
		//如果有部门
		if(currDeptID > 0){ // 
			s = "dept1=" + currDeptID;
			where = where + " and " + s;
		}
	}
	//mark=3: 当前用户为销售
	if(String(Request.QueryString("mark")) == 3){
		s = "fromID='" + currUser + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	*/
	if(fStart > ""){
		s = "regDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "regDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有公司
	var unit = decodeURI(String(Request.QueryString("unit")));
	if(unit>"" && unit != "null"){
		s = "unit='" + unit + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(kindID > ""){
		s = "fromKind=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}
	sql = " FROM v_studentInfo " + where;
	var saler = String(Request.QueryString("sales"));
	//如果有saler
	if(saler > "" && saler != "null"){ // 
		sql = " FROM [dbo].[getStudentListBySaler]('" + saler + "') " + where;
	}
	
	result = getBasketTip(sql,"");
	ssql = "SELECT username,name,sexName,age,birthday,(case when host='znxf' then '' else kindName end),statusName,(case when host='znxf' then unit else hostName end),(case when host='znxf' then dept else dept1Name end),(case when host='znxf' then '' else dept2Name end),mobile,phone,email,memo,regDate,(case when photo_filename>'' then '+' else '' end) as photo,(case when IDa_filename>'' then '+' else '' end) as ida,(case when IDb_filename>'' then '+' else '' end) as idb" + sql + " order by userID desc";
	sql = "SELECT top " + basket + " *," + (saler>"" && saler != "null"?"[dbo].[getStudentSalerCourseCount](username,'" + saler + "') as salerCourseCount":"'' as salerCourseCount") + sql + " order by userID desc";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("userID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("user_status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value;
		//7
		result += "|" + rs("mobile").value + "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value + "|" + rs("photo").value + "|" + rs("job_status").value;
		//17
		result += "|" + rs("unit").value + "|" + rs("dept").value + "|" + rs("host").value + "|" + rs("courseCount").value + "|" + rs("educationName").value;
		//22
		result += "|" + rs("fromID").value + "|" + rs("fromKind").value + "|" + rs("salerName").value + "|" + rs("fromKindName").value + "|" + rs("salerCourseCount").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	result = "";
	if(nodeID>0){
		sql = "SELECT * FROM v_studentInfo where userID=" + nodeID;
	}else{
		if(refID>""){
			sql = "SELECT * FROM v_studentInfo where username='" + refID + "'";
		}
	}
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("userID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("user_status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value;
		//7
		result += "|" + rs("mobile").value + "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value + "|" + rs("photo").value;
		//16
		result += "|" + rs("email").value + "|" + rs("phone").value + "|" + rs("job").value + "|" + rs("dept3Name").value + "|" + rs("limitDate").value;
		//21
		result += "|" + rs("photo_filename").value + "|" + rs("IDa_filename").value + "|" + rs("IDb_filename").value + "|" + rs("edu_filename").value;
		//25
		result += "|" + rs("companyID").value + "|" + rs("dept1").value + "|" + rs("dept2").value + "|" + rs("dept3").value + "|" + rs("host").value;
		//30
		result += "|" + rs("education").value + "|" + rs("educationName").value + "|" + rs("job_status").value + "|" + rs("birthday").value + "|" + rs("address").value;
		//35
		result += "|" + rs("unit").value + "|" + rs("dept").value + "|" + rs("ethnicity").value + "|" + rs("IDaddress").value + "|" + rs("bureau").value + "|" + rs("IDdateStart").value + "|" + rs("IDdateEnd").value + "|" + rs("experience").value;
		//43
		result += "|" + rs("CHESICC_filename").value + "|" + rs("employe_filename").value + "|" + rs("job_filename").value + "|" + rs("linker").value + "|" + rs("fromID").value + "|" + rs("sex").value + "|" + rs("IDab_filename").value + "|" + rs("promise_filename").value;
		//51
		result += "|" + rs("social_filename").value + "|" + rs("scanID").value + "|" + rs("scanPhoto").value + "|" + rs("fromKind").value + "|" + rs("tax").value + "|" + rs("checker").value;
	}
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "getGenerateStudentList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(item like('%" + where + "%'))";
	}
	//如果有公司
	if(host > ""){ // 
		s = "host='" + host + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > ""){
		s = "regDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "regDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_generateStudentInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT item,qty,hostName,memo,regDate,registerName" + sql + " order by ID";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("item").value + "|" + rs("qty").value;
		//3
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("filename").value;
		//7
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	Response.Write(escape(result));
}	

if(op == "update"){
	result = 0;
	if(result == 0){
		//@mark int,@username varchar(50),@name nvarchar(50),@password varchar(50),@kindID int,@companyID varchar(50),@dept1 varchar(50),@dept1Name nvarchar(100),@dept2 varchar(50),@dept3 varchar(50),@job varchar(50),@mobile nvarchar(50),@phone nvarchar(50),@email nvarchar(50),@limitDate varchar(50),@memo nvarchar(500),@host varchar(50),@registerID varchar(50)
		sql = "exec updateStudentInfo " + keyID + ",'" + nodeID + "',N'" + String(Request.Form("name")) + "',''," + kindID + ",'" + String(Request.Form("companyID")) + "','" + String(Request.Form("dept1")) + "','','" + String(Request.Form("dept2")) + "','','" + unescape(String(Request.Form("job"))) + "','" + String(Request.Form("linker")) + "'," + String(Request.Form("job_status")) + ",'" + String(Request.Form("mobile")) + "','" + String(Request.Form("phone")) + "','" + (String(Request.Form("email"))) + "','" + (String(Request.Form("address"))) + "','" + String(Request.Form("limitDate")) + "','" + String(Request.Form("education")) + "','" + (String(Request.Form("unit"))) + "','" + (String(Request.Form("tax"))) + "','" + (String(Request.Form("dept"))) + "','" + (String(Request.Form("ethnicity"))) + "','" + (String(Request.Form("IDaddress"))) + "','" + (String(Request.Form("bureau"))) + "','" + String(Request.Form("IDdateStart")) + "','" + String(Request.Form("IDdateEnd")) + "','" + (String(Request.Form("experience"))) + "','" + String(Request.Form("fromID")) + "','" + String(Request.Form("fromKind")) + "','" + memo + "','" + host + "','" + currUser + "'";
		execSQL(sql);
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "updateTai"){
	result = 0;
	if(result == 0){
		//@mark int,@username varchar(50),@name nvarchar(50),@sex int,@birthday varchar(50),@kindID int,@companyID varchar(50),@dept1 varchar(50),@dept1Name nvarchar(100),@dept2 varchar(50),@dept3 varchar(50),@job varchar(50),@mobile nvarchar(50),@phone nvarchar(50),@email nvarchar(50),@limitDate varchar(50),@memo nvarchar(500),@host varchar(50),@registerID varchar(50)
		sql = "exec updateStudentInfoTai '" + nodeID + "','" + (String(Request.Form("name"))) + "'," + String(Request.QueryString("sex")) + ",'" + String(Request.QueryString("birthday")) + "'," + kindID + ",'" + String(Request.QueryString("companyID")) + "','" + String(Request.QueryString("dept1")) + "','','" + String(Request.QueryString("dept2")) + "','','" + unescape(String(Request.QueryString("job"))) + "','" + unescape(String(Request.QueryString("linker"))) + "'," + String(Request.QueryString("job_status")) + ",'" + unescape(String(Request.QueryString("mobile"))) + "','" + unescape(String(Request.QueryString("phone"))) + "','" + unescape(String(Request.QueryString("email"))) + "','" + unescape(String(Request.QueryString("address"))) + "','" + String(Request.QueryString("limitDate")) + "','" + String(Request.QueryString("education")) + "','" + unescape(String(Request.QueryString("unit"))) + "','" + String(Request.QueryString("tax")) + "','" + unescape(String(Request.QueryString("dept"))) + "','" + unescape(String(Request.QueryString("ethnicity"))) + "','" + unescape(String(Request.QueryString("IDaddress"))) + "','" + unescape(String(Request.QueryString("bureau"))) + "','" + String(Request.QueryString("IDdateStart")) + "','" + String(Request.QueryString("IDdateEnd")) + "','" + unescape(String(Request.QueryString("experience"))) + "','" + String(Request.QueryString("fromID")) + "','" + String(Request.QueryString("fromKind")) + "','" + memo + "','" + host + "','" + currUser + "'";
		execSQL(sql);
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getGenerateStudentNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_generateStudentInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("item").value + "|" + rs("qty").value;
		//3
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("filename").value;
		//7
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "updateGenerateStudent"){
	result = 0;
	if(result == 0){
		sql = "exec updateGenerateStudentInfo " + nodeID + ",'" + item + "'," + String(Request.QueryString("qty")) + ",'" + host + "','" + memo + "','" + currUser + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT ID as maxID FROM generateStudentInfo where registerID='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delGenerateStudentNode"){
	sql = "exec delGenerateStudentInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getGenerateScoreList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(item like('%" + where + "%'))";
	}
	//如果有公司
	if(host > ""){ // 
		s = "host='" + host + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有分类(证书类型)
	if(kindID > ""){ // 
		s = "certID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > ""){
		s = "regDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "regDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_generateScoreInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT item,certID,certName,qty,hostName,memo,regDate,registerName" + sql + " order by ID";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("item").value + "|" + rs("qty").value;
		//3
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("filename").value;
		//7
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value + "|" + rs("certID").value + "|" + rs("certName").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	Response.Write(escape(result));
}	

if(op == "getGenerateScoreNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_generateScoreInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("item").value + "|" + rs("qty").value;
		//3
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("filename").value;
		//7
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value + "|" + rs("certID").value + "|" + rs("certName").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "updateGenerateScore"){
	result = 0;
	if(result == 0){
		sql = "exec updateGenerateScoreInfo " + nodeID + ",'" + item + "','" + String(Request.QueryString("certID")) + "','" + memo + "','" + currUser + "'";
		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM generateScoreInfo where registerID='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}
	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delGenerateScoreNode"){
	sql = "exec delGenerateScoreInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "setGenerateStudentMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setGenerateStudentMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}

if(op == "setMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setStudentMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}

if(op == "setStatus"){
	result = 0;
	if(result == 0){
		sql = "exec setStudentStatus '" + nodeID + "'," + status + ",'" + currUser + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}

if(op == "delNode"){
	sql = "exec delStudentInfo '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "reset"){
	result = 0;
	sql = "exec resetStudentPwd '" + nodeID + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("re").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "studentExist"){
	result = 0;
	sql = "SELECT userID FROM studentInfo where username='" + nodeID + "'";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("userID").value;
	}
	rs.Close();
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "getDeptRefrence"){
	result = "";
	sql = "SELECT * FROM dbo.getDeptRefrence('" + nodeID + "')";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("companyID").value + "|" + rs("dept1").value + "|" + rs("dept2").value + "|" + rs("mobile").value + "|" + rs("education").value + "|" + rs("job").value + "|" + rs("memo").value;
	}
	rs.Close();
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "getClassRefrence"){
	result = "";
	sql = "SELECT dbo.getClassRefrence('" + nodeID + "','" + refID + "') as item";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("item").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getDeptRefrenceNo"){
	result = 0;
	sql = "SELECT * FROM dbo.getDeptRefrenceNo('" + nodeID + "','" + refID + "')";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value;
	}
	rs.Close();
	Response.Write(result);
}

if(op == "exchangeMaterial"){
	result = 0;
	sql = "exec exchangeMaterial '" + nodeID + "','" + kindID + "','" + refID + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("re").value;
	}
	rs.Close();
	Response.Write(result);
}

if(op == "getDeptPayTitle"){
	result = 0;
	sql = "SELECT * FROM dbo.getDeptPayTitle(" + refID + ")";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("payNow").value + "|" + rs("title").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "getStudentServiceList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(item like('%" + where + "%'))";
	}
	//如果有username
	if(nodeID > ""){ // 
		s = "username='" + nodeID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有enterID
	if(refID > ""){ // 
		s = "refID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果不是销售或领导，只能看公开记录
	if(keyID == 0){ // 
		s = "private=0";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_studentServiceInfo " + where;
	ssql = "SELECT username,name,item,typeName,serviceDate,memo,regDate,registerName" + sql + " order by ID desc";
	sql = "SELECT *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("item").value + "|" + rs("username").value + "|" + rs("refID").value;
		//4
		result += "|" + rs("type").value + "|" + rs("typeName").value + "|" + rs("serviceDate").value + "|" + rs("memo").value;
		//8
		result += "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("name").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	/**/
	Session(op) = ssql;
	Response.Write(escape(result));
}

if(op == "getStudentServiceNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_StudentServiceInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("item").value + "|" + rs("username").value + "|" + rs("refID").value;
		//4
		result += "|" + rs("type").value + "|" + rs("typeName").value + "|" + rs("serviceDate").value + "|" + rs("memo").value;
		//8
		result += "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("name").value + "|" + rs("private").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "updateStudentServiceInfo"){
	result = "";
	sql = "exec updateStudentServiceInfo " + nodeID + ",'" + keyID + "','" + item + "','" + refID + "','" + kindID + "','" + String(Request.QueryString("serviceDate")) + "','" + String(Request.QueryString("private")) + "','" + memo + "','" + currUser + "'";
	
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("re").value;
	}
	rs.Close();
	/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getSalerUnitList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(unitName like('%" + where + "%'))";
	}
	//如果有kind
	if(kindID > ""){ // 
		s = "kindID=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有saler
	if(refID > ""){ // 
		s = "saler='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_unitInfo " + where;
	ssql = "SELECT unitName,taxNo,salerName,kindName,linker,phone,address,email,memo,regDate,registerName" + sql + " order by ID";
	sql = "SELECT *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("unitName").value + "|" + rs("taxNo").value + "|" + rs("saler").value + "|" + rs("salerName").value + "|" + rs("status").value;
		//6
		result += "|" + rs("kindID").value + "|" + rs("fromKindName").value + "|" + rs("linker").value + "|" + rs("phone").value + "|" + rs("address").value + "|" + rs("email").value;
		//12
		result += "|" + rs("association").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("checker").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Session(op) = ssql;
	Response.Write(escape(result));
}

if(op == "getSalerUnitNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_unitInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("unitName").value + "|" + rs("taxNo").value + "|" + rs("saler").value + "|" + rs("salerName").value + "|" + rs("status").value;
		//6
		result += "|" + rs("kindID").value + "|" + rs("fromKindName").value + "|" + rs("linker").value + "|" + rs("phone").value + "|" + rs("address").value + "|" + rs("email").value;
		//12
		result += "|" + rs("association").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("checker").value + "|" + rs("checkerName").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "updateSalerUnitInfo"){
	result = 0;
	sql = "exec updateSalerUnitInfo " + nodeID + ",'" + item + "','" + String(Request.QueryString("taxNo")) + "','" + refID + "','" + kindID + "','" + decodeURI(String(Request.QueryString("linker"))) + "','" + decodeURI(String(Request.QueryString("phone"))) + "','" + decodeURI(String(Request.QueryString("address"))) + "','" + decodeURI(String(Request.QueryString("email"))) + "','" + decodeURI(String(Request.QueryString("association"))) + "','" + memo + "','" + currUser + "'";
	
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("re").value;
	}
	rs.Close();
	/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

%>
