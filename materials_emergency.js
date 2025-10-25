	//path: 签名文件 p: 1 打印学历证明 0 不打印  k: 1 打印从事特种作业情况说明（在职证明） 0 不打印  s: 1 打印社保证明
	function getMaterials(username,path,p,k,s,courseID){
		$.getJSON(uploadURL + "/public/getStudentMaterials?username=" + username + "&IDcard=0",function(data){
			// jAlert(unescape(data));
			var c = 0;
			var i = 0;
			var idc = 0;
			$("#materialsCover").empty();
			var arr = new Array();
			if(data.length>0){
				arr.push('<div style="page-break-after:always">&nbsp;</div>');
				arr.push('<div style="float:left;width:100%;">');
				arr.push('<table style="margin-top:10mm;width:100%;">');
				$.each(data,function(iNum,val){
					if(val["kindID"]==1 || val["kindID"]==2){	//身份证正反面
						i += 1;
						idc += 1;
						arr.push('<tr>');
						arr.push('<td align="center" style="width:100%;">');
						arr.push('	<img src="users' + val["filename"] + '" style="max-width:300px;max-height:300px;padding-top:20px;">');
						arr.push('</td>');
						arr.push('</tr>');
					}
					if(p==1 && val["kindID"]==3){	//学历证明
						c = 1;
						i += 1;
						arr.push('<tr>');
						arr.push('<td align="center" style="width:100%;">');
						arr.push('	<img src="users' + val["filename"] + '" style="max-width:600px;max-height:400px;padding-top:20px;">');
						arr.push('</td>');
						arr.push('</tr>');
					}
					if(k==1 && val["kindID"]==5){	//在职证明
						i += 1;
						// arr.push('<div style="page-break-after:always"></div>');
						arr.push('<tr>');
						arr.push('<td align="center" style="width:100%;">');
						arr.push('	<img src="users' + val["filename"] + '" style="max-width:600px;max-height:600px;padding-top:20px;">');
						arr.push('</td>');
						arr.push('</tr>');
					}
					if(s==1 && val["kindID"]==8){	//社保证明
						i += 1;
						// arr.push('<div style="page-break-after:always"></div>');
						arr.push('<tr>');
						arr.push('<td align="center" style="width:100%;">');
						arr.push('	<img src="users' + val["filename"] + '" style="max-width:600px;max-height:900px;padding-top:20px;">');
						arr.push('</td>');
						arr.push('</tr>');
					}
				});
				arr.push('</table>');
				arr.push('</div>');
				arr.push('<div style="position: relative;width:100%;height:80%;">');
				let m_lk = (keyID==2?100:0);
				let m_left1 = 377 + m_lk;
				let m_left2 = 420 + m_lk;
				if(idc>0){
					//身份证签字
					// arr.push('<div style="position: absolute; z-index:10;">');
					// arr.push('<div style="float:left;">');
					// arr.push('	<span><img src="/users' + path + '?times=' + (new Date().getTime()) + '" style="width:170px;margin:0px 0px 8px 250px;padding-left:80px;padding-top:' + (p==1? 180 : 180) + 'px;"></span>');
					// arr.push('</div>');
					// arr.push('</div>');
					arr.push('<div style="position: absolute; z-index:20;width:100px;">');
					arr.push('<img src="/users' + path + '?times=' + (new Date().getTime()) + '" style="width:90px;margin:0px 0px 0px 557px;padding-left:0px;padding-top:200px;">');
					arr.push('</div>');
					arr.push('<div style="position: absolute; z-index:40; margin-left:100;">');
					arr.push('<img src="images/sign_stamp.png" style="width:150px;margin:0px 0px 0px ' + m_left1 + 'px;padding-left:0px;padding-top:173px;opacity:0.7;">');
					arr.push('</div>');
				}
				if(path>"" && c==1){
					//学历证明签字
					// arr.push('<div style="position: absolute; z-index:10;">');
					// arr.push('<div style="float:left;">');
					// arr.push('	<span><img src="/users' + path + '?times=' + (new Date().getTime()) + '" style="width:170px;margin:0px 0px 8px 250px;padding-left:80px;padding-top:670px;"></span>');
					// arr.push('</div>');
					// arr.push('</div>');
					arr.push('<div style="position: absolute; z-index:10;width:100;">');
					arr.push('<img src="/users' + path + '?times=' + (new Date().getTime()) + '" style="width:90px;margin:-200px 0px 0px 600px;padding-left:0px;padding-top:850px;">');
					arr.push('</div>');
					arr.push('<div style="position: absolute; z-index:40; margin-left:100;">');
					arr.push('<img src="images/sign_stamp.png" style="width:150px;margin:-200px 0px 0px ' + m_left2 + 'px;padding-left:0px;padding-top:820px;opacity:0.7;">');
					arr.push('</div>');
				}
				arr.push('</div>');
				// alert(arr.join(""))
				if(i>0){
					$("#materialsCover").html(arr.join(""));
				}
			}
		});
	}
