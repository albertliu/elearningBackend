<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>PerkinElmer Demo</title>
<link rel="stylesheet" type="text/css" href="css/jquery.jqplot.css" />
<script language="javascript" type="text/javascript" src="js/excanvas.js"></script>
<script language="javascript" src="js/jquery-1.4.2.min.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.jqplot.js"></script>
<script type="text/javascript" src="js/jqplot.categoryAxisRenderer.min.js"></script>
<script type="text/javascript" src="js/jqplot.barRenderer.min.js"></script>
<script type="text/javascript" src="js/jqplot.highlighter.min.js"></script>
<script type="text/javascript" src="js/jqplot.dateAxisRenderer.min.js"></script>
<script type="text/javascript" src="js/jqplot.canvasTextRenderer.min.js"></script>
<script type="text/javascript" src="js/jqplot.canvasAxisTickRenderer.min.js"></script>
<script type="text/javascript" src="js/jqplot.pieRenderer.min.js"></script>

<script language="javascript">
$(document).ready(function () {
    $.ajaxSetup({ 
  		async: false 
  	}); 
  	/*
  	showChartBar(1,24,1,1,1,1);
  	showChartBar(2,23,1,2,1,0);
  	showChartBar(1,0,2,3,0,1);
  	showChartBar(2,0,2,4,0,0);
  	showChartBar(0,0,3,5,1,0);
 	showChartPoint(0,0,4,6,1);
  	showChartPoint(0,0,6,8,0);
  	showChartPie('pKind',7,9,0);
  	showChartPie('pJob',7,10,0);
  	showChartPie('pEducation',7,11,0);
  	showChartPie('pArea',7,12,0);
  	showChartPie('pIndustry',7,13,0);
  	showChartPoint('2009',0,5,7,1);
   	showChartBar('2010',0,9,16,1,0,-30);
   	showChartBar('2010',0,10,17,1,0,0);
  	showChartPie('2010','Shanghai',7,14,0);
  	showChartPie('201003','Shanghai',6,13,0);
  	*/
   	showChartBar(1,1,1,0,30);
  	
  	function showChartBar(modeID,chart,hasSum,overlay,angle){
  		
  		//chart    -- chart的标号（div中的ID）
  		//hasSum   -- 附带汇总信息        	0 否  1 是
  		//overlay  -- 不同的line是否叠加  	0 否  1 是
  		//angle    -- X轴项目倾斜角度
  		
		var num = "1";             //柱子数量，最多4个
		var chartTitle = "";
		var unit = new Object();
		var line1 = new Object();
		var line2 = new Object();
		var line3 = new Object();
		var line4 = new Object();
		var kind = new Array();
		var chartSum = new Array();
		var chartSumTitle = new Array();
		var ar = new Array();
		var barPadding = 4;
		var barMargin = 8;
		$.get("chart_control.asp?type=getTitle&modeID=" + modeID + "&times=" + (new Date().getTime()),function(re){
			ar = unescape(re).split("|");
			//alert(ar);
			num = ar[0];
			chartTitle = ar[1];
			kind = ar[2].split(",");
		});
		
		$.get("chart_control.asp?type=getData&modeID=" + modeID + "&times=" + (new Date().getTime()),function(data){
			ar = unescape(data).split("|");
			//alert(ar);
			if(num > 0){
				line1 = ar[1].split(",");
				line1 = $.map(line1,function(value){
					return parseFloat(value);
				});
			}
			if(num > 1){
				line2 = ar[2].split(",");
				line2 = $.map(line2,function(value){
					return parseFloat(value);
				});
			}
			if(num > 2){
				line3 = ar[3].split(",");
				line3 = $.map(line3,function(value){
					return parseFloat(value);
				});
			}
			if(num > 3){
				line4 = ar[4].split(",");
				line4 = $.map(line4,function(value){
					return parseFloat(value);
				});
			}
			
			unit = ar[0].split(",");
		});
		
		if(unit.length > 0){
			barPadding = 36/unit.length;
			barMargin = 72/unit.length;
			if(barMargin > 50){
				barMargin = 50;
			}
			if(barPadding > 10){
				barPadding = 10;
			}
		}
		if(hasSum == 1){
			//alert(parseInt(num)+1);
			chartSumTitle = ar[parseInt(num) + 1].split(",");
			chartSum = ar[parseInt(num) + 2].split(",");
			//alert(chartSumTitle);
			var s = "";
			var p = " <font color='#CCCCCC'>|</font> ";
			for(i=0; i<chartSumTitle.length; i++){
				s += " <font color='#999999'> " + chartSumTitle[i] + ":</font> <font color='red'>" + chartSum[i] + "</font>" + p;
			}
			$("#chartSum" + chart).html("总计 " + p + s);
			$("#chartSum" + chart).css("font-size",13);
		}
	
		if(num == 1){
			plot1 = $.jqplot('chart' + chart, [line1], {
			    legend:{show:true, location:'ne'},
			    title:chartTitle,
			    seriesDefaults:{
			        renderer:$.jqplot.BarRenderer, 
			        rendererOptions:{barPadding: barPadding, barMargin: barMargin}
			    },
			    series:[
			        {label:kind[0]}
			    ],
			    axes:{
			        xaxis:{
			            renderer:$.jqplot.CategoryAxisRenderer, 
			            tickRenderer: $.jqplot.CanvasAxisTickRenderer ,
			            ticks:unit,
					    tickOptions: {
					      angle: angle
					    }
			        }, 
			        yaxis:{min:0}
			    }
			});
		}
	
		if(num == 2){
			if(overlay == 0){
				plot1 = $.jqplot('chart' + chart, [line1, line2], {
				    legend:{show:true, location:'ne'},
				    title:chartTitle,
				    seriesDefaults:{
						renderer:$.jqplot.BarRenderer, 
				        rendererOptions:{barPadding: barPadding, barMargin: barMargin}
				    },
				    series:[
				        {label:kind[0]}, 
				        {label:kind[1]}
				    ],
		      		cursor:{show:true, zoom:true},
				    axes:{
				        xaxis:{
				            renderer:$.jqplot.CategoryAxisRenderer, 
				            ticks:unit
				        }, 
				        yaxis:{min:0}
				    }
				});
			}
			if(overlay == 1){
				plot1 = $.jqplot('chart' + chart, [line1, line2], {
					stackSeries: true,
				    legend:{show:true, location:'ne'},
				    title:chartTitle,
				    seriesDefaults:{
				        renderer:$.jqplot.BarRenderer, 
				        rendererOptions:{barPadding: barPadding, barMargin: barMargin, barWidth: barMargin}
				    },
				    series:[
				        {label:kind[0]}, 
				        {label:kind[1]}
				    ],
				    axes:{
				        xaxis:{
				            renderer:$.jqplot.CategoryAxisRenderer, 
				            ticks:unit
				        }, 
				        yaxis:{min:0}
				    }
				});
			}
		}
	
		if(num == 3){
			plot1 = $.jqplot('chart' + chart, [line1, line2, line3], {
			    legend:{show:true, location:'ne'},
			    title:chartTitle,
			    seriesDefaults:{
					renderer:$.jqplot.BarRenderer, 
			        rendererOptions:{barPadding: barPadding, barMargin: barMargin, barWidth: barMargin}
			    },
			    series:[
			        {label:kind[0]}, 
			        {label:kind[1]}, 
			        {label:kind[2]}
			    ],
	      		cursor:{show:true, zoom:true},
			    axes:{
			        xaxis:{
			            renderer:$.jqplot.CategoryAxisRenderer, 
			            ticks:unit
			        }, 
			        yaxis:{min:0}
			    }
			});
		}
	
		if(num == 4){
			plot1 = $.jqplot('chart' + chart, [line1, line2, line3, line4], {
			    legend:{show:true, location:'ne'},
			    title:chartTitle,
			    seriesDefaults:{
			        renderer:$.jqplot.BarRenderer, 
			        rendererOptions:{barPadding: barPadding, barMargin: barMargin}
			    },
			    series:[
			        {label:kind[0]}, 
			        {label:kind[1]}, 
			        {label:kind[2]}, 
			        {label:kind[3]}
			    ],
			    axes:{
			        xaxis:{
			            renderer:$.jqplot.CategoryAxisRenderer, 
			            ticks:unit
			        }, 
			        yaxis:{min:0}
			    }
			});
		}
	}
	
	/*
	function showChartPie(kindID,groupID,modeID,chart,hasSum){
		var chartTitle = "";
		var line1 = new Array();
		var ar = new Array();
		$.get("chart_control.asp?type=getData&kindID=" + kindID + "&groupID=" + groupID + "&modeID=" + modeID + "&times=" + (new Date().getTime()),function(data){
			ar = unescape(data).split("|");
		 	//alert(unescape(data));
			for(i=0; i<ar.length; i++){
				line1[i] = [(ar[i].split(","))[0],parseInt((ar[i].split(","))[1])];
			}
		});
		$.get("chart_control.asp?type=getTitle&kindID=" + kindID + "&groupID=" + groupID + "&modeID=" + modeID + "&times=" + (new Date().getTime()),function(data){
			chartTitle = unescape(data);
		});

		if(hasSum == 1){
			$.get("chart_control.asp?type=getSum&kindID=" + kindID + "&groupID=" + groupID + "&modeID=" + modeID + "&times=" + (new Date().getTime()),function(data){
				var chartSum = (data).split("|");
				var s = "";
				var p = " <font color='#CCCCCC'>|</font> ";
				s = " <font color='#999999'> 合计:</font> <font color='red'>" + chartSum[0] + "</font>" + p;
				$("#chartSum" + chart).html(p + s);
				$("#chartSum" + chart).css("font-size",13);
			});
		}

		plot3 = $.jqplot('chart' + chart, [line1], {
			title: chartTitle, 
			seriesDefaults:{renderer:$.jqplot.PieRenderer, rendererOptions:{sliceMargin:8}},
    		legend:{show:true}
		});
	}
	*/
});
</script>
</head>
	<body>
		<p class="description" align="center"><font color="red" size="18">NAC Demo</font></p>
		<br>
		<div class="jqPlot" id="chart1" style="height:220px; width:500px;"></div>
		<div id="chartSum1" align="center"></div>
		<br>
		<br>
	</body>
</html>
