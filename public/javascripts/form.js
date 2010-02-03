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