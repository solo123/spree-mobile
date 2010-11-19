$(function(){
    $("#QPlist table tr")
    .hover(
        function(){
            $(this).addClass("hover");
        },
        function(){
            $(this).removeClass("hover");
        }
        )
    .click(function(){
        $(this).toggleClass("seleted");
    });
});