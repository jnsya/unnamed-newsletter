# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/base'
require 'sinatra/activerecord'
require 'pry'
require './services/get_new_articles'
require './services/scrape_longform'
require './services/send_newsletter'
require './models/article'
require './models/recipient'

class UnnamedNewsletter < Sinatra::Base
  enable :sessions

  get '/' do
    'Welcome to Unnamed Newsletter.'
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    recipient = Recipient.find_by(device_email: params[:email])

    if recipient&.authenticate(params[:password])
      session[:recipient_id] = recipient.id
    else
      flash[:error] = 'Login failed!'
    end

    redirect to '/'
  end

  get '/signup' do
    erb :signup
  end

  post '/signup' do
    @recipient = Recipient.new(device_email: params[:email])
    @recipient.password = params[:password]
    @recipient.save!
  end

  run! if app_file == $PROGRAM_NAME
end
