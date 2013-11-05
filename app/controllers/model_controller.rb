require 'tmpdir'
class ModelController < ApplicationController

  @@modelPath = "/data/models"

  ###############################################
  def index
    @post = params
  end

  ###############################################
  def new
    @post = params
    @categories = Category.all
    addBreadcrumb "Upload", request.original_url
  end

  ###############################################
  # \brief Create a new model in the database.
  def destroy
    model = Model.find(params[:id])
    if model
      model.delete_request = true;
      model.save
    end

    status = "success"
    msg = "Deleted model"
    render :json=>{:status=> status, :message => msg}
  end

  ###############################################
  # \brief Modify a  model in the database.
  def modify
    modelParams=params["model"]
    modelParams[:creator] = current_user.id

    if params["hidden-model"]
      modelParams["tags"] = params["hidden-model"]["tags"]
    end

    @model = Model.find(params[:id])
    if !@model.nil?
      modelParams[:version] = @model.version + 1

      # Update the category count if the category was changed
      if modelParams[:category] != @model.category
        # Decrement the count for the old category
        cat = Category.where(:name=>@model.category).first
        cat.model_count = [cat.model_count-1, 0].max
        cat.save

        # Increment the count for the new category
        cat = Category.where(:name=>modelParams[:category]).first
        if !cat.model_count
          cat.model_count = 1
        else
          cat.model_count += 1
        end
        cat.save
      end

      # Update the model attributes, and save
      @model.update_attributes(modelParams)
      @model.save

      modelPath = File.join(@@modelPath, @model.id.to_s)


      if !modelParams[:files].nil? and File.exists?(modelParams[:files].path)
        # Clear the old model contents
        FileUtils.rm_rf(modelPath, :secure=>true, :noop=>false)

        Dir.mktmpdir { |dir|
          `tar xvf #{modelParams[:files].path} -C #{dir}`

          # \todo Validate the uploaded data here.

          `mv #{dir}/* #{modelPath}`
          FileUtils.mv(modelParams[:files].path,
                       File.join(modelPath, @model.id.to_s + ".tar.gz"))
        }
      end

      # Regenerate the model.config file.
      create_model_config(modelPath, @model)
    end

    # Redirect to the show action
    redirect_to @model
  end

  ###############################################
  # \brief Create a new model in the database.
  def create
    modelParams=params["model"]
    modelParams[:rating] = 0.0
    modelParams[:creator] = current_user.id
    modelParams[:version] = 0

    if params["hidden-model"]
      modelParams["tags"] = params["hidden-model"]["tags"]
    end

    # Create a new model based on the passed in parameters.
    @model = Model.new(modelParams)

    # Save the model to the database.
    # TODO: Add check to make sure model was saved.
    @model.save

    # Create the new model path
    newModelPath = File.join(@@modelPath, @model.id.to_s)

    Dir.mktmpdir { |dir|
      `tar xvf #{modelParams[:files].path} -C #{dir}`

      # \todo Validate the uploaded data here.

      `mv #{dir}/* #{newModelPath}`
      FileUtils.mv(modelParams[:files].path,
                   File.join(newModelPath, @model.id.to_s + ".tar.gz"))
    }

    # Create the model.config file
    create_model_config(newModelPath, @model)

    cat = Category.where(:name=>@model.category).first
    if !cat.model_count
      cat.model_count = 1
    else
      cat.model_count += 1
    end
    cat.save

    # Redirect to the show action
    redirect_to @model
  end

  ###############################################
  def exists
    model = Model.where(:name => params[:name]).first
    render :json=>{:status=>"success", :exists => !model.nil?,
                   :model_id => model.id}
  end

  ###############################################
  def show
    @otherModels = []

    @post = params

    @model = Model.find(params[:id]) rescue render_404
    @modelPath = @@modelPath
    filename = File.join(@modelPath, @model.id.to_s, @model.id.to_s + ".tar.gz")
    if File.exists?(filename)
      size = File.size(filename).to_f
      if size < 2**20 
        @filesize = "(%.2f KB)" % (size / 2**10)
      else
        @filesize = "(%.2f MB)" % ( size / 2**20)
      end
    end

    addBreadcrumb @model.name, request.original_url

    if signed_in?
      @rating = Rating.where("model_id = ? AND user_id = ?",
                             params[:id], current_user.id).first
    end

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
  # \brief Like/dislike a model
  def like
    result = "success"
    if Likes.where(user_id: params[:user], model_id: params[:id]).first.blank?
      like = Likes.new(user_id: params[:user],
                       model_id: params[:id], value: true)
      like.save
      result = "1"
    else
      like = Likes.where(user_id: params[:user], model_id: params[:id]).first
      like.value = !like.value
      if like.value?
        result = "1"
      else
        result = "0"
      end

      like.save
    end

    render :text=>result
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

    total = 0
    # Update model rating
    rows = Rating.where(:model_id=>params[:id])
    rows.each do |r|
      total += r.score
    end
    model = Model.find(params[:id])
    model.rating = (total / rows.size).round(1)
    model.save

    render :text=>model.rating
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
    metaPath = File.join(@@modelPath, "#{params[:id]}/meta")
    if File.exists?(File.join(metaPath, "#{params[:num]}.png"))
      render :text => open(
        File.join(metaPath, "#{params[:num]}.png"), "rb").read
    else
      render :text => open(
        "#{Rails.root}/app/assets/images/generating_images.png", "rb").read
    end
  end

  ###############################################
  def edit
    model = Model.find(params[:id])
    @categories = Category.all
    @modelName = model.name
    @modelDesc = model.description
    @modelCat = model.category
    @modelTags = model.tags
    @modelFilename = model.name + ".tar.gz"
    @modelFilesize = "0 KB"

    @modelPath = @@modelPath
    filename = File.join(@modelPath, model.id.to_s, model.id.to_s + ".tar.gz")
    if File.exists?(filename)
      size = File.size(filename).to_f
      if size < 2**20 
        @modelFilesize = "%.2f KB" % (size / 2**10)
      else
        @modelFilesize = "%.2f MB" % ( size / 2**20)
      end
    end
    @post = params;

    render new_model_path
  end

  ###############################################
  def download
    @model = Model.find(params[:id])

    # If the user is signed in, then update their download history
    if signed_in?
      user = current_user
      if Downloads.where(:model_id => @model.id,
                         :user_id => user.id).first.blank?
        # Create a new entry in the dl database
        dl = Downloads.new(:model_id => @model.id, :user_id => user.id)
        dl.save
      else
        # Update the updated_at column
        Downloads.where(:model_id => @model.id, :user_id => user.id).first.touch
      end
    end

    send_file File.join(@@modelPath, "#{params[:id]}/#{@model.id}.tar.gz"), :type => "application/x-gzip", :filename=>"#{@model.name}.tar.gz"
  end

  private
  def model_params
    params.require(:name, :description).permit(:category_1, :category_2,
                                               :category_3, :tags)
  end

  ###############################################
  # \brief Create a model.config file
  def create_model_config(newModelPath, model)
    file = File.open(File.join(newModelPath, "model.config"), "w")
    file.printf("<?xml version='1.0'?>\n<model>\n")
    file.printf("  <name>%s</name>\n", model.name)
    file.printf("  <sdf>model.sdf</sdf>\n")
    file.printf("  <category>%s</category>\n", model.category)
    if User.exists?(id: model.creator)
      creator = User.find(model.creator)
      file.printf("  <author>\n")
      file.printf("    <name>#{creator.username}</name>\n")
      file.printf("    <email>#{creator.email}</name>\n")
      file.printf("  </author>\n")
    end
    file.printf("  <description>\n")
    file.printf("  %s\n", model.description)
    file.printf(" </description>\n")
    file.printf("</model>\n")
  end
end
