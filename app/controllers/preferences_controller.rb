class PreferencesController < ApplicationController
  skip_authorization_check

  def create
    model_name = params[:preference][:model_name]
    model = model_name.constantize 
    filter_id = params[:preference][:filter_id].to_i
    preference = current_user.preferences.build(filter_name: model_name, filter_id: filter_id)
    respond_to do |format|
      if preference.save
        format.html { redirect_to :back }
        format.json { render action: 'show', status: :created, location: @preference }
      else
        format.html { redirect_to :back, error: 'Something went wrong.' }
        format.json { render json: @preference.errors, status: :unprocessable_entity }
      end
    end
  end

  def range_filters
    if params[:range_name] == "Year"
      range_from = params[:range_from]
      range_to = params[:range_to]
    elsif params[:range_name] == "Price"
      range_from = params[:range_from].to_i*1000000
      range_to = params[:range_to].to_i*1000000
    end
    preference_from = Preference.find_or_initialize_by(filter_name: "#{params[:range_name]}From", user_id: current_user.id)
    preference_to = Preference.find_or_initialize_by(filter_name: "#{params[:range_name]}To", user_id: current_user.id)
    
    preference_from.update(filter_id: range_from)
    preference_to.update(filter_id: range_to)
    redirect_to :back
  end

  def non_model_filters
    filter_id   = params[:preference][:filter_id].to_i
    filter_name = params[:preference][:filter_name]
    preference = current_user.preferences.build(filter_name: filter_name  , filter_id: filter_id )
    respond_to do |format|
      if preference.save
        format.html { redirect_to :back }
        format.json { render action: 'show', status: :created, location: @preference }
      else
        format.html { redirect_to :back, error: 'Something went wrong.' }
        format.json { render json: @preference.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    preference = current_user.preferences.where(filter_id: params[:id], filter_name: params[:model_name])
    if params[:model_name] == "Make"
      car_models_ids = CarModel.where(make_id: params[:id]).ids
      current_user.preferences.where(filter_name: "CarModel").where(filter_id: car_models_ids).destroy_all
    end
    preference.destroy_all
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private

end
