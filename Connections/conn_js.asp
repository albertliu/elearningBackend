<%
// 创建数据库对象
var conn = new ActiveXObject("ADODB.Connection");
var strdsn = "DSN=elearning;UID=sqlrw;PWD=De0penl99O53!4N#~9.";

// 打开数据源
	conn.Open(strdsn);

var sql = "";
var rs = "";
var rsCount = 0;
%>