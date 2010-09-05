class Admin::FormsController < Admin::BaseController
  before_filter :login_required
  access_control :DEFAULT => '(superuser)'
  layout 'admin'
  before_filter Proc.new{ @section = 'forms' }
  
  def index
    order = params[:order] || 'updated_at DESC'
    @forms = Form.paginate(:per_page => 25, :page => params[:page], :order => order)
  end   
  
  def recommand
     @form = Form.find(params[:id])
     @form.recommanded = params[:mark] 
     
     respond_to do |wants|
       if @form.save
         flash[:notice] = '操作成功'
       else
         flash[:alert] = 'Something Wrong'  
       end                                                                    
       wants.html { redirect_to admin_forms_url }     
     end
  end
  
  def stats
    @tab = 'stats'
    @form = Form.find(params[:id])
    @visits_count = Visit.group_by_created_at(:form_id => @form.id)
    @referrers    = Visit.group_by_host(:form_id => @form.id)[0..4]
    @cities =       Visit.group_by_city(:form_id => @form.id)[0..4]

    @data = @visits_count.map {|i| i['count'].to_i}
    @max = @data.max || 0
    #@labels[0] = ''
    # @labels = ['']
    # [3, 2, 1, 0].each do |i|
    #   d = Date.today - i.week
    #   @labels << d.strftime("%m-%d")
    # end
    @axis_labels = [[], [0, @max/2, @max]]
    
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @form = Form.find(params[:id])  
    klass = @form.klass
    @rows = klass
    
    respond_to do |wants| 
      unless klass.count == 0
      wants.html { 
        @rows = klass.paginate(:page => params[:page], :per_page => (params[:per_page]||20), :order => 'created_at')
      }                   
      else
      wants.html {
        redirect_to admin_forms_path,:alert => '此问卷暂无回应'
      }
      end
    end
  end
  
  def destroy
    @form = Form.find(params[:id])
    Form.delete(@form._id) if @form
    
    respond_to do |format|
      format.html { redirect_to(admin_forms_url,:notice => '已删除') }
    end
  end
end