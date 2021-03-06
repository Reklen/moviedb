class CommentsController < ApplicationController
  before_action :set_variables

  def create
    authorize @comment, :create?

    if @comment.save
      flash.now[:notice] = 'Comment has been created.'

      respond_to do |format|
        format.js { render 'comments/comment.js.erb', locals: { comments: @movie.comments } }
      end
    else
      flash.now[:alert] = 'Comment has not been created.'
      render 'movies/show'
    end
  end

  private

  def set_variables
    @movie = Movie.find(params[:movie_id])
    @comment = @movie.comments.build(comment_params)
    @comment.author = current_user
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
