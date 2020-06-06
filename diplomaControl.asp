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
	sql = " FROM v_studentDiplomaList " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT diplomaID,certName,statusName,term,startDate,endDate,agencyName,username,name,sexName,age,hostName,dept1Name,dept2Name,mobile,email,memo,regDate,registerName" + sql + " order by diplomaID";
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
/*	*/
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

if(op == "setMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setDiplomaMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}

if(op == "delNode"){
	sql = "exec delDiplomaList '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "generateDiploma"){
	result = "";
	sql = "SELECT * FROM dbo.getDiplomaData('" + refID + "','" + host + "')";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("diplomaID").value + "|" + rs("username").value + "|" + rs("certName").value + "|" + rs("term").value + "|" + rs("startDate").value + "|" + rs("endDate").value;
		//6
		result += "|" + rs("hostName").value + "|" + rs("dept1Name").value "|" + rs("job").value + "|" + rs("logo").value + "|" + rs("photo").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	


%>
