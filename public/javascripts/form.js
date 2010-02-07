$(document).ready(function($) { 
  if ($('#form_title').val() == "未命名表单") {
	   $('#form_title').css('color','#666')
	}      
	
	if ($('#form_description').val() == "描述一下你的表单吧") {
	   $('#form_description').css('color','#666')
	}

  $('#form_title').  
      focus(function() {   
      if (this.value == "未命名表单") {
          this.value = "";
    	  this.style.color = "#000";
      }
  }).
      blur(function() {
      if (this.value == "") { 
    		  this.style.color = "#666";
          this.value = "未命名表单";
      }
  }); 
  
  $('#form_description').  
      focus(function() {   
      if (this.value == "描述一下你的表单吧") {
          this.value = "";
    		  this.style.color = "#000"
      }
  }).
      blur(function() {
      if (this.value == "") { 
    	  this.style.color = "#666";
          this.value = "描述一下你的表单吧";
      }
  });      

  
  $("#fields").sortable({axis:'y', cursor: 'move', forcePlaceholderSize: true, items: '.field'});
  $("#fields").disableSelection();
  
  // 更新排序结果
  $('#fields').bind('sortupdate', function(event, ui) {
    var i = 1;
    data = []
    $("#fields").find(".field").each(function(){
      uuid = $(this).find('#field_uuid').val();
      data.push('<input type="hidden" name="uuids[' + uuid + ']" value="' + i + '" />')
      i += 1;
    });
    $("#field_positions").html(data.join(''));
    $(".edit_form #form_submit").submit();
  });
});     


function clear_initial(obj){
   if(/新问题\d/.test(obj.value)){
	    obj.value = ''; 
		obj.style.color = "#000";
	}
}

function set_initial(obj){
   if(obj.value == ''){
	    obj.value = '新问题'+ (field_count -1);
		obj.style.color = "#666"
	}
}

function form_add_field(e)
{
  $("#fields").append($("#new_field").html());
  var new_field = $("#fields").find('.field').last();
  new_field.find('.question').hide();
  new_field.find('.form').show();
  new_field.find('.form #field_name').val('新问题' + field_count).css('color','#666');
  new_field.find('.question label').html('新问题' + field_count);  
  new_field.find('.field_position').val(field_count)
  field_count += 1;
  now = new Date();
  new_field.find('.form #field_uuid').val(now.getTime());
  new_field.find('#field_submit').submit();  
}