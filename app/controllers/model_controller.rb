class ModelController < ApplicationController
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
    @post = params
    puts "ModelController::show"
    @model = Model.find(params[:id])
  end

  private
  def model_params
    params.require(:name, :description).permit(:category_1, :category_2,
                                               :category_3, :tags)
  end
end
