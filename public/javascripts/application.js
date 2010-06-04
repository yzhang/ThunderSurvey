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

function fetch_row(form_id, row_id,key)
{
	$("#row").html($("#spinner").html());
	$(curr_row).css('background', '#FFF');
	curr_row = '#row' + row_id;
	$(curr_row).css('background', '#DDD');

  $.get('/forms/'+form_id+'/rows/'+row_id, {edit_key : key}, function(data){
    $("#row").html(data);
  });
}

function edit_row(form_id,row_id,key)
{
	$("#row").html($("#spinner").html());
	$(curr_row).css('background', '#FFF');
	curr_row = '#row' + row_id;	
	$(curr_row).css('background', '#DDD');
	
  $.get('/forms/'+form_id+'/rows/'+row_id+'/edit', {edit_key : key}, function(data){
    $("#row").html(data);
  });
}