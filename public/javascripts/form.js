$(document).ready(function($) { 
  if ($('#form_title').val() == dft_form_title) {
	   $('#form_title').css('color','#666')
	}      
	
	if ($('#form_description').val() == dft_form_desc) {
	   $('#form_description').css('color','#666')
	}

  $('#form_title').  
      focus(function() {   
      if (this.value == dft_form_title) {
          this.value = "";
    	  this.style.color = "#333";
      }
  }).blur(function() {
      if (this.value == "") { 
    	  this.style.color = "#666";
          this.value = dft_form_title;
      }
  }); 
  
  $('#form_description').  
      focus(function() {   
      if (this.value == dft_form_desc) {
          this.value = "";
    		  this.style.color = "#333"
      }
  }).blur(function() {
      if (this.value == "") { 
    	  this.style.color = "#666";
          this.value = dft_form_desc;
      }
  });      

  
  $("#fields").sortable({axis:'y', cursor: 'move', forcePlaceholderSize: true, items: '.field',placeholder: 'placeholder' });
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
		$("#saving").show();
    $("#edit_form #form_submit").submit();
  });

	//根据窗口大小自动调整表单模块的高度
	$("#form").height(document.documentElement.clientHeight - $("#form").position().top -70);
	$(window).resize(function(){
		$("#form").height(document.documentElement.clientHeight - $("#form").position().top - 70);
	});
});     


function clear_initial(obj){
   if(new_question_regex.test(obj.value)){
			clear_initial.question_title = obj.value;
	    obj.value = ''; 
		obj.style.color = "#000";
	}
}

function set_initial(obj){
   if(obj.value == ''){
	    obj.value = clear_initial.question_title;
		obj.style.color = "#666"
	}
}

function clear_option_initial(obj){
   if(new_option_regex.test(obj.value)){
			clear_option_initial.option_title = obj.value;
	    obj.value = ''; 
		obj.style.color = "#000";
	}
}

function set_option_initial(obj){
   if(obj.value == ''){
	    obj.value = clear_option_initial.option_title;
		obj.style.color = "#666"
	}
}

function form_add_field(e)
{
  $("#fields").append($("#field_template").html());
  var new_field = $("#fields").find('.field').last();
	$(new_field[0]).attr('id', 'last_field');
  new_field.find('.question').hide();
  new_field.find('.form').show();
  new_field.find('.form #field_name').val(new_question_title + (field_count - 100)).css('color','#666');
  new_field.css('background-color','#FDF2C6');
  new_field.find('.question label').html(new_question_title + (field_count - 100));  
  // initial position
  field_count += 1;
  new_field.find('.field_position').val(field_count);

  // focus guide
  now = new Date();
  new_field.find('.form #field_uuid').val(now.getTime());
  $("#saving").show();
  new_field.find('#field_submit').submit();
  $('#form').scrollTo('max');
}

function form_dup_field(e)
{
  $("#fields").append($("#field_template").html());	

  var new_field = $("#fields").find('.field').last();
	var parent = $(e).closest('.field')
	$(new_field[0]).html(parent.html());
	$(new_field[0]).attr('id', 'last_field');
	new_field.find('.field_form').attr('action', $("#field_template .field_form").attr('action'));
	$(new_field.find('.field_form').children()[0]).html($($("#field_template .field_form").children()[0]).html());
	
	parent.find('.question').show();
	parent.find('.operation').hide();
	parent.find('.form').hide();
	
	new_field.find('.question').hide();
	new_field.find('.opration').hide();
  new_field.find('.form').show();
	new_field.find('.form #field_name').focus();
  new_field.css('background-color','#FDF2C6');
	
	field_start_editing.current_editing_field = new_field.find('.question');
	
	// initial position
	field_count += 1;
	new_field.find('.field_position').val(field_count);

	// focus guide
	now = new Date();
	new_field.find('.form #field_uuid').val(now.getTime());
	$("#saving").show();
  new_field.find('#field_submit').submit();
  $('#form').scrollTo('max');
}