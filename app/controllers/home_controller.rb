class HomeController < ApplicationController
  def index
    # render "home/index"
    @article = Article.first
  end

  def about

  end

end