class WidgetsController < ApplicationController
  before_action :check_logged_in, except: [:index]
  before_action :set_widget, only: [:show, :edit, :update, :destroy]

  # GET /widgets
  # GET /widgets.json
  def index
    @widgets = Widget.search(current_access_token, params[:q])
  end

  def mine
    @widgets = current_user.widgets(current_access, params[:q])
  end

  # GET /widgets/new
  def new
    @widget = Widget.new
  end

  # GET /widgets/1/edit
  def edit
  end

  # POST /widgets
  # POST /widgets.json
  def create
    @widget = Widget.new(widget_params)

    if @widget.save(current_access)
      redirect_to mine_widgets_path, notice: 'Widget was successfully created.'
    else
      flash[:alert] = @widget.error_message
      render :new
    end
  end

  # PATCH/PUT /widgets/1
  # PATCH/PUT /widgets/1.json
  def update
    if @widget.update(current_access, widget_params)
      redirect_to mine_widgets_path, notice: 'Widget was successfully updated.'
    else
      flash[:alert] = @widget.error_message
      render :edit
    end
  end

  # DELETE /widgets/1
  # DELETE /widgets/1.json
  def destroy
    notification = if @widget.destroy(current_access)
      { notice: 'Widget was successfully destroyed.' }
    else
      { alert: @widget.error_message }
    end
    redirect_to mine_widgets_path, notification
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_widget
      @widget = Widget.find(current_user, current_access, params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def widget_params
      params.require(:widget).permit(:name, :description, :kind)
    end
end
