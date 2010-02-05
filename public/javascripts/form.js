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
    		  this.style.color = "#000"
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
});

function form_add_field(e)
{
  $("#fields").append($("#new_field").html());
  var new_field = $("#fields").find('.field').last();
  new_field.find('.question').hide();
  new_field.find('.form').show();
  new_field.find('.form #field_name').val('新问题' + field_count);
  new_field.find('.question label').html('新问题' + field_count);
  field_count += 1;
  now = new Date();
  new_field.find('.form #field_uuid').val(now.getTime());
}