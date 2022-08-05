
		document.getElementById("lightLoadFile").style.display="none";
		document.getElementById("fadeLoadFile").style.display="none";

		var commw1 = "status=0 and hostNo='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("commLoadFileHost","hostInfo","hostNo","title","status=0 order by hostName",1);
			$("#commLoadFileHost").val("znxf");
		}else{
			getComList("commLoadFileHost","hostInfo","hostNo","title",commw1,0);
		}

		$("#restore").click(function(){
			if($("#commLoadFileHost").val()==""){
				alert("请选择一个公司。");
				return false;
			}
            var form = new FormData(document.getElementById("formUpload"));
			var act = action + "?upID=" + $("input[name='uploadKind']:checked").val() + "&username=" + username + "&currUser=" + currUser + "&host=" + $("#commLoadFileHost").val() + "&commMark=" + commMark + "&para=" + para;
            $.ajax({
                url: act,
                type:"post",
                data:form,
                processData:false,
                contentType:false,
                success:function(data){
					var msg = data.msg;
					if(msg == ""){
						if(data.count>0){
							msg = "成功上传" + data.count + "个文件。";
						}else{
							msg = "没有上传有效文件。\n";
						}
						if(data.err_msg > ""){
							msg += data.err_msg;
						}
						if(data.exist_msg > ""){
							msg += data.exist_msg;
						}
						alert(msg, "上传结果");
					}else{
						alert(msg, "上传结果");
					}
					if(commMark != "mulitple"){
						document.getElementById("lightLoadFile").style.display="none";
						document.getElementById("fadeLoadFile").style.display="none";
						getNodeInfo(nodeID);
					}
	                updateCount += 1;
                },
                error:function(e){
					document.getElementById("lightLoadFile").style.display="none";
					document.getElementById("fadeLoadFile").style.display="none";
					getNodeInfo(nodeID);
					//alert(e);
                }
            });        
		});

