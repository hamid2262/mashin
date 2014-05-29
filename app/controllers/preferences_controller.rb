class PreferencesController < ApplicationController
  skip_authorization_check

  # POST /internal_colors
  # POST /internal_colors.json
  def create
    model_name = params[:preference][:model_name]
    filter_name = params[:preference][:filter_name]
    model = model_name.constantize 
    obj = model.where(name: filter_name).first

    @preference = current_user.preferences.build(filter_name: model_name, filter_id: obj.id)
    respond_to do |format|
      if @preference.save
        format.html { redirect_to :back, notice: 'Internal color was successfully created.' }
        format.json { render action: 'show', status: :created, location: @preference }
      else
        format.html { redirect_to :back, error: 'Something went wrong.' }
        format.json { render json: @preference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /internal_colors/1
  # DELETE /internal_colors/1.json
  def destroy
    @preference.destroy
    respond_to do |format|
      format.html { redirect_to internal_colors_url }
      format.json { head :no_content }
    end
  end

  private

    def internal_color_params
      params.require(:preference).permit(:filter_name, :filter_id)
    end

end
