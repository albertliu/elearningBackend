<%
// 创建数据库对象
var conn = new ActiveXObject("ADODB.Connection");
var strdsn = "DSN=elearning;UID=sa;PWD=Admin12345";

// 打开数据源
	conn.Open(strdsn);

var sql = "";
var rs = "";
var rsCount = 0;
%>