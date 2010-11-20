// Coolpur.com Global script
$(function(){
    $("input:text, input:password, textarea","#content")
    .addClass("ipt")
    .hover(
        function(){$(this).addClass("hover");},
        function(){$(this).removeClass("hover");}
    )
    .focus(function(){$(this).addClass("focus");})
    .blur(function(){$(this).removeClass("focus");});

    $("input:submit, input:reset, button,","#content")
    .hover(
        function(){$(this).addClass("hover");},
        function(){$(this).removeClass("hover");})
    .focus(function(){$(this).addClass("focus");})
    .blur(function(){$(this).removeClass("focus");});

    $(".radiogroup").buttonset();
    $("#cart-form").addClass("cart-form-hover")

    setTimeout("$('#effectnotice, #effecterrors').toggle('blind', null, 500);", 8000);

    $('.product-listing li').hover(
        function(){$(this).addClass("hover");},
        function(){$(this).removeClass("hover");});

    // set current menu
    var l = location.pathname;
    if (l == '/' || l.substr(0,5)== '/home')
        $('.nav-list li:nth-child(1) a').addClass('current');
    else if ( l=='/pages/direct-supply-process')
        $('.nav-list li:nth-child(2) a').addClass('current');
    else if ( l.substr(0,9) == '/products' || l.substr(0,3)=='/t/')
        $('.nav-list li:nth-child(3) a').addClass('current');
    else if (l.substr(0,11)=='/quotations')
        $('.nav-list li:nth-child(4) a').addClass('current');
    else if (l.substr(0,6)=='/pages')
        $('.nav-list li:nth-child(5) a').addClass('current');
});

