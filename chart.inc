<link rel="stylesheet" type="text/css" href="css/jquery.jqplot.css" />
<script language="javascript" type="text/javascript" src="js/excanvas.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.jqplot.js"></script>
<script type="text/javascript" src="js/jqplot.categoryAxisRenderer.min.js"></script>
<script type="text/javascript" src="js/jqplot.barRenderer.min.js"></script>
<script type="text/javascript" src="js/jqplot.highlighter.min.js"></script>
<script type="text/javascript" src="js/jqplot.dateAxisRenderer.min.js"></script>
<script type="text/javascript" src="js/jqplot.canvasTextRenderer.min.js"></script>
<script type="text/javascript" src="js/jqplot.canvasAxisTickRenderer.min.js"></script>
<script type="text/javascript" src="js/jqplot.pieRenderer.min.js"></script>

<script language="javascript">
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

</script>