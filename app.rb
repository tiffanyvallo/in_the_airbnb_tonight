
# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'sinatra/flash'
require_relative './lib/property'
require_relative './lib/user'
require './database_connection_setup'
require './lib/booking'


class Airbnb < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    register Sinatra::Flash
  end

  enable :sessions, :method_override
  

  get '/' do
    erb :index
  end

  get '/user/new' do
    erb :sign_up
  end

  post '/user/new' do
    if User.find(params[:email])
      flash[:error] = 'User already exists, please log in!'
    else
      user = User.create(params[:name], params[:email], params[:password])
      flash[:confirm] = "Welcome #{user.name}! Account has been created!"
    end
    redirect '/'
  end

  get '/homepage' do
    @properties = Property.all
    erb :homepage
  end

  post '/homepage' do
  end

  post '/session/new' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user] = user
      flash[:confirm] = "Welcome #{user.name}! Successfully logged in!"
      redirect '/homepage'
    else
      flash[:error] = 'Sorry email or password does not match!'
      redirect '/'
    end
  end

  post '/session/destroy' do
    session[:user] = nil
    flash[:confirm] = 'Successful log out'
    redirect '/'
  end

  get '/property/new' do
    erb(:"property/new")
  end

  post '/property/new' do
    property = Property.create(address: params[:address], postcode: params[:postcode], title: params[:title], description: params[:description], price_per_day: params[:price_per_day])
    if property
      flash[:success] = 'You have successfully created a listing'
    else
      flash[:danger] = 'Something went wrong'
    end
    redirect '/homepage' 
  end

  get '/property/:id' do
    @property = Property.find(params['id'])
    @bookings = Booking.find(params['id'])
    erb :'property/id'
  end

  post '/property/:id' do
    booking = Booking.create("#{params[:start_year]}-#{params[:start_month]}-#{params[:start_day]}",
       "#{params[:end_year]}-#{params[:end_month]}-#{params[:end_day]}", 
       params[:id],
       session[:user].id,
       "pending review")
    flash[:confirm] = 'Your rental request has been sent.'
    redirect "/property/#{params[:id]}"
  end

  get '/property/:id/request' do
  end
end
