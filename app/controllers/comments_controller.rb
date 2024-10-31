# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))

    respond_to do |format|
      if @comment.persisted?
        format.html { redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human) }
      else
        set_commentable_and_comments

        action = @commentable.is_a?(Book) ? 'books/show' : 'reports/show'
        format.html { render action, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human) }
    end
  end

  private

  def set_commentable
    if params[:book_id]
      @commentable = Book.find(params[:book_id])
    elsif params[:report_id]
      @commentable = Report.find(params[:report_id])
    end
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def authorize_user!
    return if @comment.user == current_user

    redirect_to @commentable
  end

  def set_commentable_and_comments
    case @commentable
    when Book
      @book = @commentable
    when Report
      @report = @commentable
    end
    @comments = @commentable.comments.includes(:user).order(:id).page(params[:page])
  end
end
