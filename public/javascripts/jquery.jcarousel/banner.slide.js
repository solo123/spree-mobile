// JScript File

// JScript File


var strSubpromoTrack1='';
var strSubpromoTrack2='';
var strSubpromoTrack3='';
var _intStaySecs = "5";
//var total_content=6;

$(document).ready(function(){ 
	//index
	//DisplayIndexBanner();

        

	var intTotalContent = 0;
	if(total_content > -1){
		intTotalContent = total_content;
	}

	if(intTotalContent > 0){
		//rebuil round button
		var strControl = '';
		for(i = 1;i<=intTotalContent;i++){
			strControl +='<div class="round" id="round_btn_' + i + '"></div>';
		}
		strControl = '<div id="jcarousel-control" align="center"><table id="TableForRound"><tr><td align="center">' + strControl + '</td></tr></table></div>';
		
		var siteName = location.href.toLowerCase();
		//var strWrap = 'circular';
		var strWrap = 'both';
		if(siteName.indexOf('/mea-sa/') > -1 || siteName.indexOf('/eg/') > -1){
			if($.browser.opera || $.browser.safari){
				strWrap = 'both';
			}
		}
		
		$('#random_index').width(randomwidth);
		$('#random_index').height(randomheight);
		$('#random_index').append($('#index_itemlist').html());
		$('#random_index').append(strControl);
		$('#random_index').jcarousel({
			vertical: false,
			wrap: strWrap,
			scroll: 1,
			auto:_intStaySecs,
			size:intTotalContent,
			itemFirstInCallback:  mycarousel_itemFirstInCallback,
			itemFirstOutCallback: mycarousel_itemFirstOutCallback,
			initCallback: mycarousel_initCallback,
			itemVisibleInCallback: {onBeforeAnimation: mycarousel_itemVisibleInCallback},
			itemVisibleOutCallback: {onAfterAnimation: mycarousel_itemVisibleOutCallback}
		});
		
		if(intTotalContent == 1){
			var objCSS = {
				'display' : 'none'
			}
			$('.jcarousel-next-horizontal').css(objCSS);
			$('.jcarousel-prev-horizontal').css(objCSS);
			$('#TableForRound').css(objCSS);
		}
	}
	
	//Subpromo
	if(typeof(total_content_1) != 'undefined'){DisplayContent(1);}
	if(typeof(total_content_2) != 'undefined'){DisplayContent(2);}
	if(typeof(total_content_3) != 'undefined'){DisplayContent(3);}
	
});

function mycarousel_initCallback(carousel) {
    jQuery('#TableForRound div').bind('click', function() {
		var strClickRoundId = this.id;
		var strIdx = strClickRoundId.replace('round_btn_','');
        carousel.scroll(jQuery.jcarousel.intval(strIdx));
        return false;
    }); 
};

function mycarousel_itemFirstInCallback(carousel, item, idx, state) {
	//alert('FirstIn:' + idx);
	var idxNow = carousel.index(idx, total_content + 1);
    $("#round_btn_" + idxNow).removeClass('round');
	$("#round_btn_" + idxNow).addClass('roundSelected');
	$("#round_btn_" + idxNow).unbind('click');
//	if(pageTracker){
//		var strGA = eval('googlepagename_' + (idxNow -1));
//		pageTracker._trackPageview(strGA);
//	}
};
function mycarousel_itemFirstOutCallback(carousel, item, idx, state) {
	//alert('FirstOut:' + idx);
	var idxNow = carousel.index(idx, total_content + 1);
    $("#round_btn_" + idxNow).removeClass('roundSelected');
	$("#round_btn_" + idxNow).addClass('round');
	$("#round_btn_" + idxNow).bind('click', function() {
        carousel.scroll(idx);
        return false;
    }); 
};

function mycarousel_itemVisibleInCallback(carousel, item, i, state, evt)
{
	/*var idx = carousel.index(i , total_content + 1);
	alert('VisibleIn:' + i + '/carousel.index:' + idx);
	var divName = "#liIndex_Flash_Start_" + (idx - 1);
	carousel.remove(i); 
	carousel.add(i, $(divName).html());*/
	//alert('VisibleIn:' + i);
	carousel.stopAuto();
};

function mycarousel_itemVisibleOutCallback(carousel, item, i, state, evt)
{
	//alert('VisibleOut:' + i);	 
	carousel.startAuto(_intStaySecs); 
};


function notChrome(){
	if($.browser.chrome == true){
		return false;
	}else{
		return true;
	}
}

function notSafari4(){
	if($.browser.safari == true){
		if($.browser.version.substring(0,1) >= 3){
			return false;
		}else{
			return true;
		}
	}else{
		return true;
	}
}


		 
function DisplayContent(iOrder){
	var page_Subpromo = '';
	var intCount = 0;
	var blnDisplayed = false;
	var intTotal;
	intTotal = eval('total_content_' + iOrder);
	iTotalProportion = eval('total_ratio_'+iOrder);
	var numRandom;
	numRandom = Math.random();
	numRandom = numRandom*iTotalProportion;
	
	for(z=0;z<=intTotal;z++){
		intCount += parseInt(eval('cratio_' +iOrder+'_'+ z));
		if(intCount > numRandom && blnDisplayed == false && ok_date('cstartdate_'+iOrder+'_'+z,'cenddate_'+iOrder+'_'+z) == true){
			$('#c3_' + iOrder).html($('#c3_' + iOrder + '_' + z).html());
			blnDisplayed = true;
			page_Subpromo = eval('googlepagename_' + iOrder + '_' + z);
		};
	};
		  
	if(blnDisplayed == false){
		DisplayContent(iOrder);
		return false;
	}
	
	if(iOrder == 1){strSubpromoTrack1=page_Subpromo}
	if(iOrder == 2){strSubpromoTrack2=page_Subpromo}
	if(iOrder == 3){strSubpromoTrack3=page_Subpromo}
}

//index---------------------------------------------------------------------------
/*var strIndexBannerTrack = '';
function DisplayIndexBanner(){
	var numRandom;
	numRandom = Math.random();
	numRandom = numRandom*total_ratio;
	var intCount = 0;
	var blnDisplayed = false;
	for(x=0;x<=total_content;x++){
		intCount += parseInt(eval('cratio_' + x));
		if(intCount > numRandom && blnDisplayed == false && ok_date('cstartdate_' + x,'cenddate_' + x) == true){
			$('#random_index').html($('#liIndex_Flash_Start_' + x).html());
			blnDisplayed = true;
			strIndexBannerTrack = eval('googlepagename_' + x);
		};
	};
};*/

function AsignImageIntoDiv(divName,imageFile){
	var imgNoFlash = new Image();
	imgNoFlash.src = imageFile;
	$('#' + divName).html(imgNoFlash);
}



//google analytics--------------
/*if(typeof(strIndexBannerTrack) != 'undefined'){
	if(strIndexBannerTrack != ''){
		if(pageTracker){
			pageTracker._trackPageview(strIndexBannerTrack);
		}
	}
}*/
if(typeof(strSubpromoTrack1) != 'undefined'){
	if(strSubpromoTrack1 != ''){
		if(pageTracker){
			pageTracker._trackPageview(strSubpromoTrack1);
		}
	}
}
if(typeof(strSubpromoTrack2) != 'undefined'){
	if(strSubpromoTrack2 != ''){
		if(pageTracker){
			pageTracker._trackPageview(strSubpromoTrack2);
		}
	}
}
if(typeof(strSubpromoTrack3) != 'undefined'){
	if(strSubpromoTrack3 != ''){
		if(pageTracker){
			pageTracker._trackPageview(strSubpromoTrack3);
		}
	}
}


/*

jQuery Browser Plugin
	* Version 2.3
	* 2008-09-17 19:27:05
	* URL: http://jquery.thewikies.com/browser
	* Description: jQuery Browser Plugin extends browser detection capabilities and can assign browser selectors to CSS classes.
	* Author: Nate Cavanaugh, Minhchau Dang, & Jonathan Neal
	* Copyright: Copyright (c) 2008 Jonathan Neal under dual MIT/GPL license.
	* JSLint: This javascript file passes JSLint verification.
*//*jslint
		bitwise: true,
		browser: true,
		eqeqeq: true,
		forin: true,
		nomen: true,
		plusplus: true,
		undef: true,
		white: true
*//*global
		jQuery
*/

(function ($) {
	$.browserTest = function (a, z) {
		var u = 'unknown', x = 'X', m = function (r, h) {
			for (var i = 0; i < h.length; i = i + 1) {
				r = r.replace(h[i][0], h[i][1]);
			}

			return r;
		}, c = function (i, a, b, c) {
			var r = {
				name: m((a.exec(i) || [u, u])[1], b)
			};

			r[r.name] = true;

			r.version = (c.exec(i) || [x, x, x, x])[3];

			if (r.name.match(/safari/) && r.version > 400) {
				r.version = '2.0';
			}

			if (r.name === 'presto') {
				r.version = ($.browser.version > 9.27) ? 'futhark' : 'linear_b';
			}
			r.versionNumber = parseFloat(r.version, 10) || 0;
			r.versionX = (r.version !== x) ? (r.version + '').substr(0, 1) : x;
			r.className = r.name + r.versionX;

			return r;
		};

		a = (a.match(/Opera|Navigator|Minefield|KHTML|Chrome/) ? m(a, [
			[/(Firefox|MSIE|KHTML,\slike\sGecko|Konqueror)/, ''],
			['Chrome Safari', 'Chrome'],
			['KHTML', 'Konqueror'],
			['Minefield', 'Firefox'],
			['Navigator', 'Netscape']
		]) : a).toLowerCase();

		$.browser = $.extend((!z) ? $.browser : {}, c(a, /(camino|chrome|firefox|netscape|konqueror|lynx|msie|opera|safari)/, [], /(camino|chrome|firefox|netscape|netscape6|opera|version|konqueror|lynx|msie|safari)(\/|\s)([a-z0-9\.\+]*?)(\;|dev|rel|\s|$)/));

		$.layout = c(a, /(gecko|konqueror|msie|opera|webkit)/, [
			['konqueror', 'khtml'],
			['msie', 'trident'],
			['opera', 'presto']
		], /(applewebkit|rv|konqueror|msie)(\:|\/|\s)([a-z0-9\.]*?)(\;|\)|\s)/);

		$.os = {
			name: (/(win|mac|linux|sunos|solaris|iphone)/.exec(navigator.platform.toLowerCase()) || [u])[0].replace('sunos', 'solaris')
		};

		if (!z) {
			$('html').addClass([$.os.name, $.browser.name, $.browser.className, $.layout.name, $.layout.className].join(' '));
		}
	};

	$.browserTest(navigator.userAgent);
})(jQuery);