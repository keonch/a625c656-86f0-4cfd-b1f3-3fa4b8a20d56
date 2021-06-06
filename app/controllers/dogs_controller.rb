class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy, :like]
  # before_action :authorize_dog_edit, only: [:edit, :update]
  # before_action :authenticate_user!, only: [:like]

  # GET /dogs
  # GET /dogs.json
  def index
    page = page_params[:page].to_i
    sort = page_params[:sort]
    dogs = Dog.with_attached_images.sorted(sort).paginated(page: page, n: 5)
    @dogs = helpers.delegate(dogs, sort, page)
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)
    @dog.owner = current_user

    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?
        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like
    respond_to do |format|
      if helpers.dog_has_owner? && helpers.user_is_dog_owner?
        format.html { redirect_to @dog, notice: 'You cannot like your own.' }
        format.json { render :show, status: :ok, location: @dog }
      elsif helpers.user_liked_dog?
        format.html { redirect_to @dog, notice: "You have already liked #{@dog.name}" }
        format.json { render :show, status: :ok, location: @dog }
      else
        @like = Like.new()
        @like.dog = @dog
        @like.user = current_user
        if @like.save
          format.html { redirect_to @dog, notice: "You have liked #{@dog.name}" }
          format.json { render :show, status: :ok, location: @dog }
        else
          format.html { redirect_to @dog }
          format.json { render json: @like.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description, images: [])
    end

    def page_params
      default={ sort: "new", page: "1"}
      params.permit(:page, :sort).reverse_merge(default)
    end

    # authorizes edit on dogs without owners (rspec tests dog edit without owner)
    def authorize_dog_edit
      if helpers.dog_has_owner? && !helpers.user_is_dog_owner?
        respond_to do |format|
          format.html { redirect_to @dog, notice: 'You are not the dog owner.' }
        end
      end
    end
end
