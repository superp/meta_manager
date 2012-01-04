class PostsController < ApplicationController
  before_filter :find_category
  before_filter :prepare_dynamic_page, :only => [:show]
  
  def index
    @posts = Post.order('id')
    respond_with(@posts)
  end
  
  def show
    @post = Post.find(params[:id])
    respond_with(@post)
  end
  
  protected
    
    def find_category
      @category = Category.first
    end
    
    def prepare_dynamic_page
      @meta_dynamic = true
    end
    
end
