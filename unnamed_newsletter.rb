# frozen_string_literal: true

require 'pry'
require 'sinatra/activerecord'
require './services/get_new_articles'
require './services/scrape_longform'
require './services/send_newsletter'
require './models/article'
require './models/recipient'
