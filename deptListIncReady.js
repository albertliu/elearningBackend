	var deptListLong = 0;		//0: 标准栏目  1：短栏目
	var deptListChk = 0;

	$(document).ready(function (){
		var w = "status=0 and hostNo='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchDeptHost","hostInfo","hostNo","title","status=0 order by hostName",1);
		}else{
			getComList("searchDeptHost","hostInfo","hostNo","title",w,0);
			getDeptList(currHost);
		}
		$("#searchDeptHost").change(function(){
			getDeptList($("#searchDeptHost").val());
		});
	});

	function getDeptList(host){
		$.get("deptControl.asp?op=getRootDeptByHost&refID=" + host + "&times=" + (new Date().getTime()),function(re){
			if(re>0){
				getDeptList(re);
				var dtree = getDeptTree(re);
				//jAlert(dtree);
				$("#tree1").treeview({
					data: dtree,
					onNodeSelected: function(event, data) {
						//alert(data.id);
						showDeptInfo(data.id,data.pID,0,1);
					}
				});
			}
		});
	}
	