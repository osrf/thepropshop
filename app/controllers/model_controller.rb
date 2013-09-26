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
    modelParams=params["model"]
    modelParams[:rating] = 0.0
    modelParams[:creator] = current_user.username

    # Create a new model based on the passed in parameters.
    @model = Model.new(modelParams)

    # Save the model to the database.
    # TODO: Add check to make sure model was saved.
    @model.save

    # Create the new model path
    newModelPath = File.join(@@modelPath, @model.id.to_s)
    unless File.directory?(newModelPath)
      # Create materials/textures directory
      FileUtils.mkdir_p(File.join(newModelPath, "materials", "textures"))
      # Create materials/scripts directory
      FileUtils.mkdir_p(File.join(newModelPath, "materials", "scripts"))
      # Create meshes directory
      FileUtils.mkdir_p(File.join(newModelPath, "meshes"))
      # Meta data directory
      FileUtils.mkdir_p(File.join(newModelPath, "meta"))
    end

    # Process incoming files
    modelParams[:files].each do |file|
      filename = file.original_filename.downcase

      # Make sure "model.sdf" is the name of the SDF file
      if filename.include?(".sdf")
        filename = "model.sdf"
      elsif filename.include?(".jpg") || filename.include?(".png")
        filename = File.join("materials", "textures", filename)
      elsif filename.include?(".dae") || filename.include?(".stl")
        filename = File.join("meshes", filename)
      elsif filename.include?(".material")
        filename = File.join("materials", "textures", filename)
      else
        filename = ""
      end

      if filename != ""
        FileUtils.mv(file.path, File.join(newModelPath, filename))
      end
    end

    # Create the model.config file
    file = File.open(File.join(newModelPath, "model.config"), "w")
    file.printf("<?xml version='1.0'?>\n<model>\n")
    file.printf("  <name>%s</name>\n", @model.name)
    file.printf("  <sdf>model.sdf</sdf>\n")
    file.printf("  <category>%s</category>\n", @model.category)
    if User.exists?(id: @model.creator)
      creator = User.find(@model.creator)
      file.printf("  <author>\n")
      file.printf("    <name>#{creator.username}</name>\n")
      file.printf("    <email>#{creator.email}</name>\n")
      file.printf("  </author>")
    end
    file.printf("  <description>\n")
    file.printf("  %s\n", @model.description)
    file.printf(" </description>\n")
    file.printf("</model>\n")

    file = File.open("/tmp/touch/#{@model.id}", "w")
    file.close

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
  def sdf
    @model = Model.find(params[:id])

    response.headers['Cache-Control'] = "public, max-age=#{12.hours.to_i}"
    response.headers['Content-Type'] = 'text/xml'
    response.headers['Content-Disposition'] = 'inline'

    render :text => File.open(
      File.join(@@modelPath, "#{params[:id]}/model.sdf")).read
  end

  ###############################################
  # \brief Render on the model images
  def image
    response.headers['Cache-Control'] = "public, max-age=#{12.hours.to_i}"
    response.headers['Content-Type'] = 'image/jpeg'
    response.headers['Content-Disposition'] = 'inline'
    render :text => open(@@modelPath +
                         "#{params[:id]}/meta/#{params[:num]}.png", "rb").read
  end

  def download
    @model = Model.find(params[:id])
    send_file File.join(@@modelPath, "#{params[:id]}/#{params[:id]}.tar.gz"), :type => "application/x-gzip", :filename=>"#{params[:id]}.tar.gz"
  end

  private
  def model_params
    params.require(:name, :description).permit(:category_1, :category_2,
                                               :category_3, :tags)
  end
end
