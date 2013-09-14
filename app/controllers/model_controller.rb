class ModelController < ApplicationController
  @@modelPath ="#{Rails.root}/app/assets/models/"

  def index
    @post = params
  end

  def new
    @post = params
    @categories = Category.all
  end

  # Create a new model in the database.
  def create
    puts params
    modelParams={name: params["name"], description: params["description"],
      tags: params["tags"], category_1: 0, category_1: 1, category_2:2 }

    # Create a new model based on the passed in parameters.
    @model = Model.new(modelParams)

    # Save the model to the database.
    # TODO: Add check to make sure model was saved.
    @model.save

    # Redirect to the show action
    redirect_to @model
  end

  def show
    @otherModels = []

    @post = params

    @model = Model.find(params[:id]) rescue render_404

    # \todo: Replace "1" with session user_id.
    @rating = Rating.where("model_id = ? AND user_id = ?",
                           params[:id], 1).first

    begin
      @creator = User.find(@model.creator)

      # Get at most three other models made by the shown model's creator.
      models = Model.where("creator = ? AND id != ?",
                         @model.creator, @model.id).shuffle.first(3).each do |m|
        @otherModels.push(m)
      end
    rescue Exception=>e
    end
  end

  ###############################################
  # \brief Rate a model.
  def rate
    row = Rating.where("model_id = ? AND user_id = ?",
                       params[:id], params[:user_id]).first

    # If the row exists in the database, then update the score.
    # Otherwise, create a new row.
    if row
      row.score = params[:score]
    else
      ratingParams = {model_id:params[:id], user_id:params[:user_id],
        score: params[:score]}
      row = Rating.new(ratingParams)
    end
    row.save

    render :text=>"success"
  end

  ###############################################
  # \brief Output the URDF file for the model
  def urdf
    @model = Model.find(params[:id])

    response.headers['Cache-Control'] = "public, max-age=#{12.hours.to_i}"
    response.headers['Content-Type'] = 'text/xml'
    response.headers['Content-Disposition'] = 'inline'
    render :text => open(@@modelPath + "#{@model.id}/model.sdf", "rb").read
  end

  ###############################################
  # \brief Render on the model images
  def image
    @model = Model.find(params[:id])

    if params[:num].to_i == 1
      @img = @model.image_1
    elsif params[:num].to_i == 2
      @img = @model.image_2
    elsif params[:num].to_i == 3
      @img = @model.image_3
    else
      @img = @model.image_4
    end

    response.headers['Cache-Control'] = "public, max-age=#{12.hours.to_i}"
    response.headers['Content-Type'] = 'image/jpeg'
    response.headers['Content-Disposition'] = 'inline'
    render :text => open(@@modelPath + "#{@model.id}/meta/#{@img}", "rb").read
  end

  private
  def model_params
    params.require(:name, :description).permit(:category_1, :category_2,
                                               :category_3, :tags)
  end
end
