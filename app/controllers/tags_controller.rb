class TagsController < ApplicationController
  def index
    @tags = Tag.all.most_popular
    authorize @tags
  end

  def create
    @tag = Tag.new(tag_params)
    authorize @tag

    if @tag.save
      render json: @tag, status: :created
    else
      render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    authorize @tag

    @tag.destroy
    redirect_to tags_path, notice: 'Tag was successfully destroyed.'
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
