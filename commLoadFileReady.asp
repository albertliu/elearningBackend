
		document.getElementById("lightLoadFile").style.display="none";
		document.getElementById("fadeLoadFile").style.display="none";
		/*
		$("input[name='uploadKind']").change(function(){
			alert($("input[name='uploadKind']:checked").val());
			$("#formUpload").attr("action", action + "?upID=" + $("input[name='uploadKind']:checked").val() + "&username=" + username);
		});
		*/
		$("#restore").click(function(){
            var form = new FormData(document.getElementById("formUpload"));
			var act = action + "?upID=" + $("input[name='uploadKind']:checked").val() + "&username=" + username + "&currUser=" + currUser + "&host=" + host;
            $.ajax({
                url: act,
                type:"post",
                data:form,
                processData:false,
                contentType:false,
                success:function(data){
					var msg = data.msg;
					if(msg == ""){
						msg = "共上传" + data.count + "个文件。";
					}
					jAlert(msg, "上传结果");
					if(mark != "mulitple"){
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

