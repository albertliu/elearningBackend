<!--#include file="js/doc.js" -->

<%

if(op == "getDiplomaList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "' or diplomaID='" + where + "' or certName like('%" + where + "%'))";
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
	//如果有状态
	if(status > ""){ // 
		s = "status=" + status;
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
		s = "startDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "startDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	//sql = " FROM v_studentDiplomaList " + where;
	sql = " FROM v_diplomaInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT diplomaID,certName,statusName,term,startDate,endDate,agencyName,username,name,sexName,age,hostName,dept1Name,dept2Name,job,mobile,email,memo,regDate,registerName" + sql + " order by diplomaID";
	sql = "SELECT top " + basket + " *" + sql + " order by diplomaID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("diplomaID").value;
		//8
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("mobile").value + "|" + rs("email").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value;
		//16
		result += "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("term").value + "|" + rs("memo").value + "|" + rs("agencyName").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("filename").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getDiplomaLastList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "' or diplomaID='" + where + "' or certName like('%" + where + "%'))";
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
	//如果有状态
	if(status > ""){ // 
		s = "status=" + status;
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
		s = "endDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "endDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_diplomaLastInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT diplomaID,certName,statusName,term,startDate,endDate,agencyName,username,name,sexName,age,hostName,dept1Name,dept2Name,job,mobile,email,memo,regDate,registerName" + sql + " order by diplomaID";
	sql = "SELECT top " + basket + " *" + sql + " order by diplomaID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("diplomaID").value;
		//8
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("mobile").value + "|" + rs("email").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value;
		//16
		result += "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("term").value + "|" + rs("memo").value + "|" + rs("agencyName").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("filename").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_diplomaInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("diplomaID").value;
		//8
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("mobile").value + "|" + rs("email").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value;
		//16
		result += "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("term").value + "|" + rs("memo").value + "|" + rs("agencyName").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("filename").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfoShort"){
	result = "";
	sql = "SELECT * FROM v_diplomaInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("name").value + "|" + rs("certName").value + "|" + rs("diplomaID").value + "|" + rs("dept1Name").value + "|" + rs("job").value;
		//5
		result += "|" + rs("startDate").value + "|" + rs("term").value + "|" + rs("title").value + "|" + rs("photo_filename").value + "|" + rs("logo").value + "|" + rs("certID").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getStudentNeedDiplomaList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "' or certName like('%" + where + "%'))";
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
	//如果缺照片
	if(keyID == 1){ // 
		s = "photo_filename=''";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " and " + where;
	}
	sql = " FROM v_studentCertList where type=1 and result=1 and diplomaID=''" + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT username,name,sexName,age,certName,agencyName,hostName,dept1Name,dept2Name,job,mobile,closeDate,examScore,memo" + sql + " order by name";
	sql = "SELECT top " + basket + " *" + sql + " order by ID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("certID").value + "|" + rs("certName").value;
		//5
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value;
		//10
		result += "|" + rs("job").value + "|" + rs("closeDate").value + "|" + rs("agencyName").value + "|" + rs("photo_filename").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
}	

if(op == "getNeedDiplomaNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_studentCertList where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("certID").value + "|" + rs("certName").value;
		//5
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value;
		//10
		result += "|" + rs("job").value + "|" + rs("closeDate").value + "|" + rs("agencyName").value + "|" + rs("photo_filename").value + "|" + rs("mobile").value + "|" + rs("student_kindName").value + "|" + rs("memo").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getGenerateDiplomaList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(diplomaID like('%" + where + "%') or certName like('%" + where + "%'))";
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
	sql = " FROM v_generateDiplomaInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT certName,qty,firstID,lastID,hostName,memo,regDate,registerName" + sql + " order by ID";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("qty").value;
		//4
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("filename").value;
		//8
		result += "|" + rs("firstID").value + "|" + rs("lastID").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
}	

if(op == "getGenerateDiplomaNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_generateDiplomaInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("qty").value;
		//4
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("filename").value;
		//8
		result += "|" + rs("firstID").value + "|" + rs("lastID").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getGenerateMaterialList"){
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
	//如果有分类
	if(kindID > ""){ // 
		s = "kindID='" + kindID + "'";
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
	sql = " FROM v_generateMaterialInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT kindName,qty,hostName,memo,regDate,registerName" + sql + " order by ID";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("qty").value;
		//4
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
}	

if(op == "getGenerateMaterialNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_generateMaterialInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("qty").value;
		//4
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "setMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setDiplomaMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}
if(op == "setNeedDiplomaMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setNeedDiplomaMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}
if(op == "setNeedDiplomaCancel"){
	result = 0;
	if(result == 0){
		sql = "exec setNeedDiplomaCancel " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}
if(op == "setGenerateDiplomaMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setGenerateDiplomaMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}
if(op == "setGenerateMaterialMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setGenerateMaterialMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}

if(op == "delNode"){
	sql = "exec delDiplomaList '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

%>
