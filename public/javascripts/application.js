$(document).ready(function() { 
	setTimeout(function () { $('#flash-message').fadeOut(); }, 6000); 
});

$(document).ready(function(){
	$("input[type='text'],textarea,input[type='password']").focus(function() {
		$(this).addClass("inputFocus")
	});
	$("input[type='text'],textarea,input[type='password']").blur(function() {
		$(this).removeClass("inputFocus")
	});
	$("input[type='checkbox']").css({'border':'0 none'})   
});

function fetch_row(form_id,row_id,key,obj){
   $('#results td').css({'background':'#FDFDFD','color':'#333'}) 
   $(obj).find("td").css({'background':'#0099FF','color':'#fff'})
   $("#row").html($("#spinner").html());
   $.get('/forms/'+form_id+'/rows/'+row_id, {edit_key : key}, function(data){
   	$("#row").html(data);
   });
}

function edit_row(form_id,row_id,key)
{
  $("#row").html($("#spinner").html());    
  $.get('/forms/'+form_id+'/rows/'+row_id+'/edit', {edit_key : key}, function(data){
    $("#row").html(data);
  });
}

function remote_action(e){
  $('#spinner').show();
}

$(document).ready(function(){    
  $(".signin").click(function(e) {
    e.preventDefault();
    $("#signin_menu").toggle();
    $("#email").focus();
    $(".signin").toggleClass("menu-open");
  });

  $("#signin_menu").mouseup(function() {
    return false;
  });     

  $(document).mouseup(function(e) {
    if($(e.target).parent("a.signin").length==0) {
      $(".signin").removeClass("menu-open");
      $("#signin_menu").hide();
    }
  });
})     

$(document).ready(function(){   
	$('#rows td').hover(
		function(){$(this).closest('tr').addClass('highlighted')},
		function(){$(this).closest('tr').removeClass('highlighted')}
		) 
		
   $('#rows td').dblclick(function(){ 
	  row_id = $(this).closest('tr').attr('id')
	  $.fancybox(
		$("#row_" + row_id).html(),
		{
        	'autoDimensions'	: false,
			'width'         	: 450,
			'height'        	: 'auto',
			'transitionIn'		: 'none',
			'transitionOut'		: 'none'
		})	
 	});
})

jQuery(function() {
   jQuery.support.borderRadius = false;
   jQuery.each(['BorderRadius','MozBorderRadius','WebkitBorderRadius','OBorderRadius','KhtmlBorderRadius'], function() {
      if(document.body.style[this] !== undefined) jQuery.support.borderRadius = true;
      return (!jQuery.support.borderRadius);
   });
});
$(function() {
   if(!$.support.borderRadius) {
      $('.btn').each(function() {
         $(this).wrap('<div class="buttonwrap"></div>')
         .before('<div class="corner tl"></div><div class="corner tr"></div>')
         .after('<div class="corner bl"></div><div class="corner br"></div>');
      });
   }
});
