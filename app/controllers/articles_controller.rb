class ArticlesController < ApplicationController

  def index
    @article = current_user.articles.build
    @articles = Article.find :all, :order => 'id ASC'
    @feed_items =  Article.find :all, :order => 'id ASC'
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(params[:article])
    if @article.save
      flash[:success] = "Article created!"
      redirect_to root_url
    else
      render 'articles/index'
    end
  end

  def show
   @article = Article.find(params[:id])
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to root_url
  end

  private
   
    def correct_user
      @article = current_user.articles.find_by_id(params[:id])
      redirect_to root_url if @article.nil?
    end
end