class FeedbacksController < ApplicationController
  def new
    @page_title = "给我们提意见"
    @section = 'feedback' 
    @feedback = Feedback.new  
    
    respond_to do |wants|
      wants.html {}
    end
    
  end
  
  def create
    @feedback = Feedback.new(params[:feedback])
    
    respond_to do |wants|   
      if @feedback.save
        wants.html {redirect_to root_path,:notice => '多谢您的意见,我们会及时跟进!'}
        wants.js { 
          render :update do |page| 
            page.alert('') 
            page << "parent.$.fancybox.close();"
          end 
        } 
      else   
        wants.html {render :action => "new"}
        wants.js { 
          render :update do |page|
            page.alert('内容和联系email必填')
          end
        }
      end
    end
  end
end