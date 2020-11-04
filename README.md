# MetaManager

Enable meta tags in your model

## Install

```
  gem "meta_manager"
```

ActiveRecord:

```
  require 'meta_manager/orm/active_record'

  rake meta_manager_engine:install:migrations
```

Mongoid:

```
  require 'meta_manager/orm/mongoid'
```

## Usage

```ruby
  class Category < ActiveRecord::Base
    include MetaManager::Taggable
  end

  @category = Category.new
  @category.tag_title = 'category test title'
  @category.tag_keywords = "Some keywords"
  @category.tag_description = "Some description"

  @category.meta_tags.build(:name => "og:title", :content => 'category og:title')

  # create dynamic meta tags, who will be overwrited the same category tag names
  # only with @meta_dynamic=true in controller
  @category.meta_tags.build(:name => "og:title", :content => 'dynamic og:title - %{post.title}', :is_dynamic => true)
  @category.meta_tags.build(:name => "title", :content => '%{post.title} - %{post.notes}', :is_dynamic => true)

  @category.save

  # create post for dynamic example
  @post = Post.create(:title => 'post test title', :notes => 'post test notes')
```

## Rendering example

At layouts/application.html.erb

```html
  <head>
  <%= raw(render_meta_tags(@category)) %>
  <title><%= render_page_title(@category) %></title>
```

At controllers/posts_controller.rb

```ruby
  before_action :find_category
  before_action :prepare_dynamic_page, :only => [:show]

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

  # set @meta_dynamic true to turn on dymanic meta tags.
  def prepare_dynamic_page
    @meta_dynamic = true
  end
```

It will be generate meta tags and title for @category.
In action show we wont to generate dynamic meta tags from instance @post.
It means that meta tag 'og:title' and tag 'title' will be overwrited with attributes from instance @post.

### Results

Action index:

```html
  <meta content='Some keywords' name='keywords' />
  <meta content='Some description' name='description' />
  <meta content='category og:title' property='og:title' />
  <title>category test title</title>
```

Action show:

```html
  <meta content='Some keywords' name='keywords' />
  <meta content='Some description' name='description' />
  <meta content='dynamic og:title - post test title' property='og:title' />
  <title>post test title - post test notes</title>
```

## Test

```
  rake test
```

Copyright (c) 2012 Fodojo, released under the MIT license
