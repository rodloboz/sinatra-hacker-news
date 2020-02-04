# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end

require_relative 'config/application'

set :views, (proc { File.join(root, 'app/views') })
set :public_folder, proc { File.join(root, "app/public") }
set :bind, '0.0.0.0'

helpers do
  def link_to(link_text, link_url, options = {})
    attributes = options.reduce("") { |html, (key, value)| html += " #{key}='#{value}'" }
    "<a href='#{link_url}'#{attributes}>#{link_text}</a"
  end

  def pretty_date(date)
    date.strftime("%e %B %Y")
  end
end

get '/' do
  # TODO
  # 1. fetch posts from database.
  # 2. Store these posts in an instance variable
  # 3. Use it in the `app/views/posts.erb` view
  @posts = Post.all

  erb :posts # Do not remove this line
end

# TODO: add more routes to your app!

post '/posts/:id' do
  @post = Post.find(params[:id])

  erb :post
end

post '/posts/:id/upvote' do
  @post = Post.find(params[:id])
  @post.upvote!

  redirect '/'
end

post '/posts/:id/downvote' do
  @post = Post.find(params[:id])
  @post.downvote!

  redirect '/'
end