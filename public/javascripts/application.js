$(document).ready(function() { 
	setTimeout(function () { $('#flash-message').fadeOut(); }, 2000); 
});

$(document).ready(function(){
	$("input[type='text'],textarea").focus(function() {
		$(this).addClass("inputFocus")
	});
	$("input[type='text'],textarea").blur(function() {
		$(this).removeClass("inputFocus")
	});
	$("input[type='checkbox']").css({'border':'0 none'})   
});
