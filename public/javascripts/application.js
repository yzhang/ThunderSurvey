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