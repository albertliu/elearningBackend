<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<%Session.CodePage=65001%>
<%
var msg = "";
if (String(Request.QueryString("msg")) != "undefined" && 
    String(Request.QueryString("msg")) != "") { 
  msg = unescape(String(Request.QueryString("msg")));
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" href="css/styles_login.css" type="text/css">
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
	<link href="css/colortip-1.0-jquery.css" rel="stylesheet" type="text/css" />
	<script src="js/jquery-1.4.2.min.js" type="text/javascript"></script>
	<script src="js/jquery.lightbox_me.js" type="text/javascript"></script>
	<script src="js/colortip-1.0-jquery.js" type="text/javascript"></script>
	<script src="js/colortip-script.js" type="text/javascript"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
	<title>SLC NAC Sign Up.</title>
	<script type="text/javascript" charset="utf-8">
        $(document).ready(function () {
            if("<%=msg%>" > ""){
            	alert("<%=msg%>");
            }
            
            function launch() {
            	$('#sign_up').lightbox_me({centered: true, onLoad: function() { $('#sign_up').find('input:first').focus()}});
            	$("#log_in").click(function(){
            		//alert($("#username").val() + "   " + $("#passwd").val());
					$.get("login.asp?username=" + $("#username").val() + "&passwd=" + $("#passwd").val() + "&times=" + (new Date().getTime()),function(re){
						//alert(unescape(re));
						if(re==0){  //passed
							self.location = "index.asp";
						}
						if(re==1){  //name is wrong
							$("#imgAllow1").html("<img src='images/cancel.png' width='13' height='13'>");
							window.setTimeout(function(){
								$("#imgAllow1").empty();
							},3000);
						}
						if(re==2){  //password is wrong
							$("#imgAllow2").html("<img src='images/cancel.png' width='13' height='13'>");
							window.setTimeout(function(){
								$("#imgAllow2").empty();
							},3000);
						}
						if(re==3){  //access deny
							jAlert("该账户已经被禁用！","提示");
						}
						if(re==4){  //密码过期
							jConfirm("该账户密码已过期，请重新设置！","确认对话框",function(r){
								if(r){
									self.location = "userEdit.asp";
								}
							});
						}
					});
				});
            }
            
            $("#loader").lightbox_me({centered: true});
            setTimeout(launch, 100);
            return false;
            
        	$('table tr:nth-child(even)').addClass('stripe');
        	
        });
    </script>
    
</head>

<body style="background-image:url(images/bg.gif)">
    <div id="container">
        
        <div id="wrapper">
            <div id="sign_up">
                <img src='images/nac_banner.jpg'>
                <div style="background:#f0f0f9;">如果密码过期，请用原密码登录后重新设置。</div>
		        <form name="form1" id="form1" action="login.asp">
	                <div id="sign_up_form">
	                    <label><strong>Username:</strong> <input class="sprited" id="username" />&nbsp;<span id="imgAllow1"></span></label>
	                    <label><strong>Password:</strong> <input class="sprited" type="password" id="passwd" />&nbsp;<span id="imgAllow2"></span></label>
	                    <div id="actions">
	                        <a class="close form_button sprited" id="cancel" href="#">Cancel</a>
	                        <a class="form_button sprited" id="log_in" href="#">Sign in</a>
	                    </div>
	                </div>
		        </form>
                <a href="forgetPwd.asp"><h3 id="left_out"><font color="#779977">忘记了密码？</font></h3></a>
                <br>
                <span>如果您还没有注册，请使用<a href="#" title="021-12345678-1234">电话</a>或<a href="#" title="support@sadfds.com.cn">邮件</a>与管理员联系！</span>
                <a id="close_x" class="close sprited" href="#">close</a>
            </div>
        </div>
        
    </div>
</body>
</html>
 