<!--#include file="js/doc1.js" -->

<!DOCTYPE html>
<html lang="zh-CN" meta viewport="width=device-width, initial-scale=1.0">
<link href="css/style_inner1.css?ver=1.0"  rel="stylesheet" type="text/css" id="css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script language="javascript">
	var updateCount = 0;
	var uploadURL = "<%=uploadURL%>";
    let refID = 0;
	$(document).ready(function (){
		$.ajaxSetup({ 
			async: false 
		});
		$("#date-input").click(function(){WdatePicker({lang:'zh-cn'});});
        $("#btnSave").prop("disabled",true);
		
		$("#id-input").change(function(){
            let t = $("#id-input").val();
			if($("#id-input").val()==""){
                jAlert("请填写身份证号码。");
                return false;
			}
            $("#id-input").val($("#id-input").val().toUpperCase());
            $.post(uploadURL + "/public/postCommInfo", {"proc":"getFiremanInfo", "params":{"username":t}},function(data){
                if(data>""){
                    let status = data[0]["status"];
                    $("#name-input").val(data[0]["name"]);
                    $("#date-input").val(data[0]["examDate"]);
                    if(status==0){
                        refID = data[0]["refID"];
                        if(refID>0){
                            $("#btnSave").prop("disabled",false);
                        }else{
                            $("#btnSave").prop("disabled",true);
                        }
                    }else{
                        jAlert(data[0]["msg"]);
                        if(status==1){
                            $("#id-input").val("");
                        }
                    }
                }
            });
		});

        $("#btnSave").click(function(){
            let t = $("#date-input").val();
            if(t==""){
                jAlert("请填写考试日期。");
                return false;
            }
            $.post(uploadURL + "/public/postCommInfo", {"proc":"setFiremanExamDate", "params":{refID:refID, examDate:t}},function(data){
                if(data>""){
                    let status = data[0]["status"];
                    if(data[0]["status"]==0){
                        jAlert("保存成功");
                        window.location.href = "about:blank";
                        window.close();
                    }else{
                        jAlert(data[0]["msg"]);
                    }
                }
            });
		});

        $("#btnClose").click(function(){
            window.location.href = "about:blank";
            window.close();
		});
	});
</script>

<head>
    <meta charset="UTF-8">
    <title>考试日期登记</title>
    <style>
        /* 设置字符集和字体 */
        @charset "UTF-8";
        
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 16px;
            background-color: #f0f0f0;
        }

        .content-box {
            max-width: 600px;
            margin: 20px auto;
            text-align: center;
        }

        h1 {
            color: orange;
            font-size: 3em;
            margin-bottom: 20px;
        }

        .input-group {
            margin-bottom: 15px;
        }

        input[type="text"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 2em;
        }

        .button {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 12px;
            border: none;
            border-radius: 4px;
            background-color: #007bff;
            color: white;
            font-size: 2em;
        }
    </style>
</head>
<body>
    <div class="content-box">
        <h1>考试日期登记</h1>
        
        <div class="input-group">
            <input class="mustFill" type="text" placeholder="身份证号码" id="id-input">
        </div>

        <div class="input-group">
            <input type="text" placeholder="姓名" id="name-input">
        </div>

        <div class="date-input">
            <input class="mustFill" type="text" placeholder="考试日期" id="date-input">
        </div>

        <div style="display: flex; justify-content: center; padding:20px;">
            <input class="button" type="button" id="btnSave" value="保存" />&nbsp;&nbsp;&nbsp;&nbsp;
            <input class="button" type="button" id="btnClose" value="关闭" />
        </div>
    </div>
</body>
</html>