//$(document).ready(function() { 
//	setTimeout(function () { $('#flash-message').fadeOut(); }, 2000); 
//});

$(document).ready(function(){
	$("input[type='text'],textarea,input[type='password']").focus(function() {
		$(this).addClass("inputFocus")
	});
	$("input[type='text'],textarea,input[type='password']").blur(function() {
		$(this).removeClass("inputFocus")
	});
	$("input[type='checkbox']").css({'border':'0 none'})   
});
