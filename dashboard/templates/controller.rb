class <%= "#{options[:namespace].camelize}::#{plural_table_name.camelize}" %>Controller < <%= options[:namespace].camelize %>Controller
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]
  before_action :set_search

  # GET <%= route_url %>
  def index
    authorize [:<%= options[:namespace] %>, :<%= singular_table_name %>], :index?
    @pagy, @<%= plural_table_name %> = pagy(@q.result(distinct: true).order(updated_at: :desc), items: 20)
    respond_to do |format|
      format.html
      format.csv { send_data @q.result(distinct: true).order(updated_at: :desc).to_csv, filename: "#{<%= class_name.constantize %>.model_name.human}-#{Date.today}.csv" }
    end
  end

  # GET <%= route_url %>/1
  def show
  end

  # GET <%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    authorize [:<%= options[:namespace] %>, @<%= singular_table_name %>]
  end

  # GET <%= route_url %>/1/edit
  def edit
  end

  # POST <%= route_url %>
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
    authorize [:<%= options[:namespace] %>, @<%= singular_table_name %>]

    if @<%= orm_instance.save %>
      flash[:notice] = "<span class='text-success me-1 fs-5 fw-bold lh-1'>&check;</span> #{I18n.t('flash.create_success')}"
      redirect_to edit_<%= options[:namespace] %>_<%= singular_table_name %>_path(@<%= singular_table_name %>)
    else
      flash.now[:danger] = "<span class='text-danger me-1 fs-5 fw-bold lh-1'>&cross;</span> #{I18n.t('flash.update_failed')}"
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      flash[:notice] = "<span class='text-success me-1 fs-5 fw-bold lh-1'>&check;</span> #{I18n.t('flash.create_success')}"
      redirect_to <%= options[:namespace] %>_<%= plural_table_name %>_path(anchor: "<%= singular_table_name %>-#{@<%= singular_table_name %>.id}")
    else
      flash.now[:danger] = "<span class='text-danger me-1 fs-5 fw-bold lh-1'>&cross;</span> #{I18n.t('flash.update_failed')}"
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>
    flash[:success] = I18n.t('flash.destroy_success')
    redirect_to admin_<%= index_helper %>_url
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    	authorize [:<%= options[:namespace] %>, @<%= singular_table_name %>]
    end

    def set_search
      @q = <%= singular_table_name.classify %>.ransack(params[:q])
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params.fetch(:<%= singular_table_name %>, {})
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end
end