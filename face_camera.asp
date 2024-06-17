<!--#include file="js/doc.js" -->
<!doctype html>
<html>
<head>
  <title>教学考勤</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />  
	<meta name="format-detection" content="telephone=no" />  
	<meta name="apple-mobile-web-app-capable" content="yes" />  
	<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
	<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
	<link href="css/jquery-confirm.min.css" rel="stylesheet" type="text/css" media="screen" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.21">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.11">

  <script src="js/jquery-3.3.1.min.js"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.2"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
  <script src="js/tracking.js/tracking.js"></script>
  <script src="js/tracking.js/data/face.js"></script>
  <script src="js/tracking.js/data/eye.js"></script>
  <script src="js/tracking.js/data/mouth.js"></script>
	<script src="js/jquery-confirm.min.js" type="text/javascript"></script>

  <style>
    video {
      margin-left: 1px;
      margin-top: 1px;
      /* top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      margin: auto; */
      position: absolute;
      transform: rotateY(180deg);
      -webkit-transform: rotateY(180deg);
      -moz-transform: rotateY(180deg);
    }
    canvas {
      margin-left: 1px;
      margin-top: 1px;
      /* top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      margin: auto; */
      position: absolute;
    }
    .tip-box {
        font-size: 2em;
        color: blue;
        font-weight: bold;
        margin: 10px;
        text-align: center;
    }
    .tip-box1 {
        font-size: 1.5em;
        color: red;
        font-weight: bold;
        margin: 10px;
        text-align: center;
    }
    .tip {
        font-size: 1.5em;
    }
    .tip1 {
        font-size: 1.5em;
        color: blue;
        background-color: #eee;
        width: 100%;
    }
    .combobox-item{
      font-weight:bold;
      font-size: 1.5em;
    }
    .vbox{
      position: absolute;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      margin: auto;
    }
    .combobox-item-selected{
      font-weight:bold;
      color: blue;
      font-size: 1.5em;
    }
    .textbox .textbox-text{
      font-weight:bold;
      font-size: 1.5em;
    }
  </style>
  <script>
	  <!--#include file="js/commFunction.js"-->
    var tipFlag = false // 是否检测
    var faceflag = false // 是否进行拍照
    var quality = 0.2;  // 0.2-0.5之间，控制压缩率。越小压缩越大，0.2可以在保证质量的情况下达到最大压缩率。
    var scheduleID = 0;

    $(document).ready(function (){
      $('#dg1').datagrid({
          url:'',
          columns:[[
              {field:'username',title:'身份证号',width:'70%'},
              {field:'name',title:'姓名',width:'30%',align:'left'}
          ]]
      });
      $('#dg2').datagrid({
          url:'',
          columns:[[
              {field:'username',title:'身份证号',width:'50%'},
              {field:'name',title:'姓名',width:'20%',align:'left'},
	            {field:'photo_filename',title:'照片',width:'30%',align:'center',formatter: function(value,row,index){
									var s = "";
									if(row.photo_filename > ""){
										s = '<img style="width:40px;" src="users' + row.photo_filename + '?times=' + (new Date().getTime()) + '"></a>';
									}
									return s;
								}
        			}
          ]]
      });
      //更改的是datagrid中的数据
      $('.datagrid-cell').css('font-size','18px');
      //datagrid中的列名称
      $('.datagrid-header .datagrid-cell span ').css('font-size','18px');
      //标题
      $('.panel-title ').css('font-size','36px'); 
      //分页工具栏
      // $('.datagrid-pager').css('display','none');
      var video = document.getElementById('video');
      var canvas = document.getElementById('canvas');
      var context = canvas.getContext('2d');

      canvas.width = canvas.clientWidth;
      canvas.height = canvas.clientHeight;
      
      var videoWidth = videoHeight = 0
      video.addEventListener('canplay', function() {
          videoWidth = this.videoWidth;
          videoHeight = this.videoHeight;
      });

      var tracker = new tracking.ObjectTracker(['face', 'eye', 'mouth']);
      // 每次打开弹框先清除canvas没拍的照片
      context.clearRect(0, 0, canvas.width, canvas.height);
      tracker.setInitialScale(4);
      tracker.setStepSize(2);
      tracker.setEdgesDensity(0.1);

      var tra = tracking.track('#video', tracker, { camera: true });
      var timer = null;
      tracker.on('track', function(event) {
        if (scheduleID>0 && !tipFlag) {
          context.clearRect(0, 0, canvas.width, canvas.height);

          if (event.data.length === 0) {
            //未检测到人脸
            if (!faceflag && !timer) {
                timer = setTimeout(() => {
                  $("#tip").html('未检测到人脸');
                }, 500)
            }
          } else if (event.data.length === 1) { // 长度为多少代表检测到几张人脸
            window.clearTimeout(timer);
            timer = null;
            $("#tip").html('请将脸部置于屏幕中央');
            //检测到一张人脸
            if (!tipFlag) {
              event.data.forEach(function(rect) {
                context.strokeStyle = '#a64ceb';
                context.strokeRect(rect.x, rect.y, rect.width, rect.height);
                context.font = '11px Helvetica';
                context.fillStyle = "#fff";
                context.fillText('x: ' + rect.x + 'px', rect.x + rect.width + 5, rect.y + 11);
                context.fillText('y: ' + rect.y + 'px', rect.x + rect.width + 5, rect.y + 22);
              });
              let rect = event.data[0];
              //判断脸部是否在屏幕中间
              // alert(rect1?rect1.x:"");
              if (!faceflag && rect && rect.x > video.clientWidth * 0.2 && rect.x < video.clientWidth * 0.8) { // 检测到人脸进行拍照，延迟0.5秒
                  $("#tip").html('识别中，请勿晃动~');
                  faceflag = true;
                  tipFlag = true;
                  setTimeout(() => {
                      // 拍照
                      let base64Data = tackPhoto();
                      if(base64Data){
                        //upload photo for compare
                        // alert(uploadURLS + "/alis/searchFace")
                        $.post(uploadURLS + "/alis/searchFace", {base64Data: base64Data, refID: scheduleID} ,function(data){
                          // alert(data)
                          if(data.status < 9){
                            showResultMsg(data.status, data.msg);
                          }
                          $("#res").html(data.msg);
                          getScheduleCheckIn();
                          getCheckinList();
                        });
                      }
                      faceflag = false;
                      tipFlag = false;
                  }, 1000);
              }
            }
          } else {
            //检测到多张人脸
            if (!faceflag) {
              $("#tip").html('只可一人进行人脸识别！');
            }
          }
        }
      });
      

      $("#scheduleID").combobox({
        onChange: function(val){
          if(val>""){
            scheduleID = val;
            getCheckinList();
          }else{
            scheduleID = 0;
          }
        }
      });

      function tackPhoto() {
          // 第二种方式	
          context.drawImage(video, 0, 0, video.clientWidth, video.clientHeight);
          var snapData = canvas.toDataURL('image/jpeg', quality);
          // var imgSrc = "data:image/jepg;" + snapData;
          // $("#imgShot").src = snapData;
          return snapData

          // sessionStorage.setItem("faceImage", imgSrc);
          // history.go(-1);
          // history.back()
          // video.srcObject.getTracks().forEach(track => track.stop());
          // 取消监听
          // tra.stop();
      }

      getScheduleList();
    });

    function showResultMsg(kind, msg){
      let c = ["green", "red", "orange"];
      //根据不同标识，显示不同风格（字体颜色）。1秒后自动关闭
      let jc = $.dialog({
          title: false,
          content: '<strong style="font-size: 15em; color:' + c[kind] + ';">' + msg + '</strong>',
          autoClose: '|500',
          animation: 'scale',
          closeAnimation: 'zoom'
      });
      setTimeout(() => {
            jc.close();
      }, 500);    
    }

    function getScheduleList(){
      getComboList("scheduleID","dbo.getCurrScheduleList('" + currHost + "')","ID","title","typeID=0 order by ID",1);
    }

    function getScheduleCheckIn(){
      $.get("classControl.asp?op=getScheduleCheckIn&refID=" + scheduleID + "&times=" + (new Date().getTime()),function(re){
        var ar = new Array();
        ar = unescape(re).split("|");
        if(ar > ""){
          $("#qty0").html(ar[1]);
          $("#qty1").html(ar[2] + "/" + ar[0]);
          $("#qty2").html(ar[3]);
        }else{
          $("#qty0").html("");
          $("#qty1").html("");
          $("#qty2").html("");
        }
      });
    }

		function getCheckinList(){
      if(scheduleID > 0){
        $.getJSON(uploadURLS + "/public/getScheduleCheckInList?refID=" + scheduleID + "&times=" + (new Date().getTime()),function(re){
          $("#dg1").datagrid("loadData",re);
        });
        $.getJSON(uploadURLS + "/public/getScheduleNoCheckInList?refID=" + scheduleID + "&times=" + (new Date().getTime()),function(re){
          $("#dg2").datagrid("loadData",re);
        });
      }
		}

  </script>
</head>
<body>
  <div>
    <table style="width:100%;">
    <tr>
        <td colspan="3">
          <div class="tip">
            <span style="font-size:1.1em;">课程表&nbsp;<select id="scheduleID" name="scheduleID" class="easyui-combobox" data-options="height:22,editable:false,panelHeight:'auto',width:300"></select></span>
            <span id="res" class="tip-box1" style="padding-top: 20px; padding-left: 20px;"></span>
          </div>
        </td>
    </tr>
    <tr>
      <td colspan="3" style="width:30%;">
        <span class="tip">签到人数：</span><span id="qty0" class="tip1"></span>
        &nbsp;&nbsp;&nbsp;&nbsp;<span class="tip">本班：</span><span id="qty1" class="tip1"></span>
        &nbsp;&nbsp;&nbsp;&nbsp;<span class="tip">其他：</span><span id="qty2" class="tip1"></span>
      </td>
    </tr>
    <tr>
        <td style="width:25%;" valign="top">
          <div class="tip">已签到人员：</div>
          <div><table id="dg1" style="font-size:1.3em;"></table></div>
        </td>
        <td style="width:40%;" valign="top">
          <div>
            <div id="tip" class="tip-box"></div>
            <video id="video" width="480" height="360" preload autoplay loop muted></video>
            <canvas id="canvas" width="480" height="360"></canvas>
          </div>
        </td>
        <td style="width:30%;" valign="top">
          <div class="tip">本班未签到人员：</div>
          <div><table id="dg2" style="font-size:1.3em;"></table></div>
        </td>
    </tr>
    </table>
  </div>

</body>
</html>
