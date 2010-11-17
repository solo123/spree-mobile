/*
 *   jquery.select.js
 *   Date : 08/11/30
 *   author : zhangjingwei
 *   http://www.zhangjingwei.com
 *	 Thanks for yoom
 *   Virsion : 1.2
 *	 模拟生成select表单。键盘可控。
*/

jQuery.fn.sSelect = function(){
	var selectId = $(this).attr('id');
	var selectIndex;
	$('#'+selectId).append('<div class="dropselectbox"><h4></h4><span class="FixSelectBrowserSpan"></span><ul style="display:none"></ul></div>');
	$.each($('#'+selectId+' > select > option'), function(i){
		if ($(this).attr("selected") == true){
			$('#'+selectId+' > div > h4').empty().append($(this).text());
			selectIndex = $('#'+selectId+' > select > option').index(this);
		};
	});
	$('.dropselectbox').show();
	$('#'+selectId+' > select').hide();
	$('#'+selectId).bind("click",function(e){
		selectId = $(this).attr('id');
		if($('#'+selectId+' > div > ul').css("display") == 'block'){
			$('.dropselectbox > h4').removeClass("over");
			$('.dropselectbox > span').removeClass("over");
			$('.dropselectbox > ul').empty().hide();
		}else{
			$('#'+selectId+' > div > h4').addClass("over");
			$('#'+selectId+' > div > span').addClass("over");
			$('#'+selectId+' > div > ul').empty().toggle();
			setSelectValue(selectId);
			selectIndex = $('#'+selectId+' > div > ul > li').index($('.selectedli')[0]);
			//相应选择事件
			$('#'+selectId+' > div > ul > li').click(function(e){
					selectIndex = $('#'+selectId+' > div > ul > li').index(this);
					//alert (selectIndex);
					$('#'+selectId+'> select')[0].selectedIndex = selectIndex;
					setSelectValue(selectId);
					cleadMenu();
					e.stopPropagation()
			})
			.hover(
				   function(){
						$('#'+selectId+' > div > ul > li').removeClass("over").removeClass("selectedli");
						$(this).addClass("over").addClass("selectedli");
						selectIndex = $('#'+selectId+' > div > ul > li').index(this);
						//$('#value2').append('滚动值：'+selectIndex+'&nbsp;&nbsp;<br>');
					},
					function(){
						$(this).removeClass("over");
					}
			)
		}
		e.stopPropagation();
	})
	.bind("blur",function(){
		$('#'+selectId+' > div > h4').removeClass("over");
		$('#'+selectId+' > div > span').removeClass("over");
		cleadMenu();						  
	})
	.bind("mousewheel",function(){
		//以后也许支持滚轮
		return false;				   
	})
	.bind("dblclick", function(){
		return false;
	})
	.bind("focus", function(){
		keyUpOrDown(selectId,selectIndex);			
	})
	.bind("keydown",function(e){
		// alert (e.keyCode);
		switch(e.keyCode){
			case 9:
				return true;
				break;
			case 13:
				//enter
				selectIndex = $('#'+selectId+' > div > ul > li').index($('.selectedli')[0]);
				$('#'+selectId+'> select')[0].selectedIndex = selectIndex;
				setSelectValue(selectId);
				cleadMenu();
				break;
			case 27:
				//esc
				cleadMenu();
				break;
			case 38:
				//up
				//$('#value2').append('原始值：'+selectIndex+'&nbsp;&nbsp;<br>');
				$('#'+selectId+' > div > ul > li').removeClass("over").removeClass("selectedli");
				selectIndex--;
				//$('#value2').append('计算值：'+selectIndex+'&nbsp;&nbsp;<br>');
				selectIndex < 0 ? selectIndex=$('#'+selectId+' > select > option').length - 1 : selectIndex;
				//$('#value2').append('判断值：'+selectIndex+'&nbsp;&nbsp;<br>--------------------------------------------------<br>');
				$('#'+selectId+' > div > ul > li:eq('+selectIndex+')').toggleClass("over").toggleClass("selectedli");
				break;
			case 40:
				//down
				//$('#value2').append('原始值：'+selectIndex+'&nbsp;&nbsp;<br>');
				$('#'+selectId+' > div > ul > li').removeClass("over").removeClass("selectedli");
				selectIndex ++;
				//$('#value2').append('计算值：'+selectIndex+'&nbsp;&nbsp;<br>');
				selectIndex > ($('#'+selectId+' > select > option').length - 1) ? selectIndex=0 : selectIndex;
				//$('#value2').append('判断值：'+selectIndex+'&nbsp;&nbsp;<br>--------------------------------------------------<br>');
				$('#'+selectId+' > div > ul > li:eq('+selectIndex+')').toggleClass("over").toggleClass("selectedli");
				break;
			default:
				return false;
		}
	}); 
	
	//禁止选择
	$('.dropselectbox').bind("selectstart",function(){
			return false;
	});
};



function cleadMenu(){
	$('.dropselectbox > ul').empty().hide();
	$('.dropselectbox > h4').removeClass("over");
	$('.dropselectbox > span').removeClass("over");
	$(document).unbind("click",cleadMenu);
}

function keyUpOrDown(selectId,selectIndex){
	$('#'+selectId+' > div > h4').toggleClass("over");
	$("#"+selectId).bind("keydown",function(e){
		//alert (e.keyCode);
		switch(e.keyCode){
			case 9:
				return true;
				break;
			case 38:
				//up
				//$('#value2').append('原始值：'+selectIndex+'&nbsp;&nbsp;<br>');
				$('#'+selectId+' > div > ul > li').removeClass("over").removeClass("selectedli");
				selectIndex--;
				//$('#value2').append('计算值：'+selectIndex+'&nbsp;&nbsp;<br>');
				selectIndex < 0 ? selectIndex=$('#'+selectId+' > select > option').length - 1 : selectIndex;
				//$('#value2').append('判断值：'+selectIndex+'&nbsp;&nbsp;<br>--------------------------------------------------<br>');
				$('#'+selectId+' > div > ul > li:eq('+selectIndex+')').toggleClass("over").toggleClass("selectedli");
				$('#'+selectId+'> select')[0].selectedIndex = selectIndex;
				$.each($('#'+selectId+' > select > option'), function(i){
					if ($(this).attr("selected") == true){
						$('#'+selectId+' > div > h4').empty().append($(this).text());
						$('#'+selectId+' > div > ul > li').eq(i).addClass("over").addClass("selectedli");
					};
				});
				break;
			case 40:
				//down
				//$('#value2').append('原始值：'+selectIndex+'&nbsp;&nbsp;<br>');
				$('#'+selectId+' > div > ul > li').removeClass("over").removeClass("selectedli");
				selectIndex ++;
				//$('#value2').append('计算值：'+selectIndex+'&nbsp;&nbsp;<br>');
				selectIndex > ($('#'+selectId+' > select > option').length - 1) ? selectIndex=0 : selectIndex;
				//$('#value2').append('判断值：'+selectIndex+'&nbsp;&nbsp;<br>--------------------------------------------------<br>');
				$('#'+selectId+' > div > ul > li:eq('+selectIndex+')').toggleClass("over").toggleClass("selectedli");
				$('#'+selectId+'> select')[0].selectedIndex = selectIndex;
				$.each($('#'+selectId+' > select > option'), function(i){
					if ($(this).attr("selected") == true){
						$('#'+selectId+' > div > h4').empty().append($(this).text());
						$('#'+selectId+' > div > ul > li').eq(i).addClass("over").addClass("selectedli");
					};
				});
				break;
			default:
				return false;
		};
	}); 
}

function setSelectValue(sID){
	$.each($('#'+sID+' > select > option'), function(i){
		$('#'+sID+' > div > ul').append("<li class='FixSelectBrowser'>"+$(this).text()+"</li>");
		if ($(this).attr("selected") == true){
			$('#'+sID+' > div > h4').empty().append($(this).text());
			$('#'+sID+' > div > ul > li').eq(i).addClass("over").addClass("selectedli");
		};
	});
}