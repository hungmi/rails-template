class <%= "#{options[:namespace].camelize}::#{plural_table_name.camelize}" %>Controller < <%= options[:namespace].camelize %>Controller
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]
  before_action :set_search

  # GET <%= route_url %>
  def index
    authorize [:<%= options[:namespace] %>, :<%= singular_table_name %>], :index?
    @pagy, @<%= plural_table_name %> = pagy(@q.result(distinct: true).order(updated_at: :desc), items: 20)
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
      flash[:success] = I18n.t('flash.create_success')
      redirect_to [:<%= options[:namespace] %>, @<%= singular_table_name %>]
    else
      render :new
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      flash[:success] = I18n.t('flash.update_success')
      redirect_to [:<%= options[:namespace] %>, @<%= singular_table_name %>]
    else
      render :edit
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
      @nav_search_symbol = :id_eq
      @nav_search_placeholder = nil
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