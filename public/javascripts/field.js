/* 用户完成字段编辑后调用此函数 */
function field_done_editing(e)
{
  var field_div = $(e).closest('.field');
  
	$("#saving").show();
  field_div.find('.question').show();
  field_div.find('.form').hide();
  
  // 更新问题名称
  var field_name = $(field_div).find("#field_name").val();
  field_div.find('.question label').html(field_name)

	if(field_div.find('.form #field_required').attr('checked') == true) {
  	field_div.find('.question .required').html('*');
	} else {
		field_div.find('.question .required').html('');
	}
  
  var field_input = $(field_div).find("#field_input").val();
  var field_uuid  = $(field_div).find("#field_uuid").val();
  var field_prompt  = $(field_div).find("#field_prompt").val();
  var input = '';
  
  if(field_input == 'text') {
    input += "<textarea rows='8' cols='60'></textarea>";
  } else if(field_input == 'radio') {
    field_div.find('.form .options input[type=text]').each(function(){
      input += "<p><input type='radio' style='margin-right:5px;'/>";
      input += "<label>" + $(this).val(); + "</label></p>";
    });
		if(field_div.find('.form #field_include_other').attr('checked')) {
			input += "<p><input type='radio' style='margin-right:5px;'/>";
			input += other_text + " <input type='text' size='30' /></p>";
		}
  } else if(field_input == 'string') {
    input += '<input type="text" size=35 />';
  } else if(field_input == 'check') {
    field_div.find('.form .options input[type=text]').each(function(){
      input += '<p><input type="checkbox" style="margin-right:5px;"/>';
      input += '<label>' + $(this).val(); + '</label></p>';
    });
		if(field_div.find('.form #field_include_other').attr('checked')) {
			input += "<p><input type='checkbox' style='margin-right:5px;'/>";
			input += other_text + " <input type='text' size='30' /></p>";
		}
  } else if(field_input == 'drop') {
    input += "<select>";
    field_div.find('.form .options input[type=text]').each(function(){
      option = '<option value="' + $(this).val() + '">' + $(this).val() + '</option>';
      input += option;
    });
    input += "</select>";
  } else if(field_input == 'date') {
    input += '<input type="text" id="' + field_uuid + '"/>';
  }
  input += '<br /><span class="prompt">' + field_prompt + '</span>'

  field_div.find('.question .input').html(input);
  field_div.css('background-color','') 
  if(field_input == 'date') {
    $("#" + field_uuid).datepicker({changeMonth:true, changeYear:true});
  }                                                      
  // 设定表单高度
  $('#form_height').val($('#fields').innerHeight());
	// 保存字段设置
	field_div.find('.form #field_submit').submit();     
}

function field_cancel_editing(e)
{
  var field = $(e).closest('.field');
  field.find('.question').show();
  field.find('.form').hide();
  field.css('background-color','') 
}

function field_start_editing(e)
{
  if(typeof(field_start_editing.current_editing_field) == 'undefined') {
    field_start_editing.current_editing_field = e;
  } else {
    field_cancel_editing(field_start_editing.current_editing_field)
    field_start_editing.current_editing_field = e;
  }
  var field = $(e).closest('.field'); 
  field.css('background-color','#FDF2C6');
  //field.removeClass('edit');
  field.find(".question").hide();
  field.find(".form").show();
  clear_initial.question_title = field.find('.form #field_name').val();
  field.find('.form #field_name').focus();
}

function field_input_changed(e)
{                             
  var field = $(e).closest('.field')
  var form = $(e).closest('form');
  var input = $(e).val();
  var input_options = $('#' + input + '_input').html();
  form.find('.input_options').html(input_options);
}

function field_add_option(e, type)
{
  var options = $(e).closest('.input_options').find('.options');
  var count   = options.find('input[type=text]').size() + 1;
  var option = '<p>';

  if(type == 'radio') {
    option += '<input type="radio" />';
  } else if (type == 'check') {
    option += '<input type="checkbox" />';
  }
  
  option += '<input type="text" name="options[]" value="' + new_option_name + count + '" style="color:#666;margin-left:5px;" onfocus="clear_option_initial(this);" onblur="set_option_initial(this)" />';
  option += '<a href="#" onclick="field_remove_option(this);">' + delele_link_text + '</a>';
  option += '</p>';
  
  options.append(option);
  options.find('input[type=text]').last().focus();
}

function field_remove_option(e)
{
  $(e).parent().remove();
  // 设定表单高度
  $('#form_height').val($('#fields').innerHeight());
}   

function toggle_opration(e, show){
	if(show == true) {
		$(e).find('.opration').show(); 
	   	$(e).addClass('highlight_hover')
	} else {
		$(e).find('.opration').hide(); 
	 	$(e).removeClass('highlight_hover')
	}
}    

function toggle_other(e) {
	$(e).closest('.field').find('.form_other').toggle();	
}