# coding: UTF-8

#Fachhochschule Salzburg, MultiMediaTechnology, 2012
#Fachspezifisches Qualifikationsprojekt 2a
#Entwickler: Lukas Wanko, Sören Hentzschel

require 'user.rb'

class HomeController < ApplicationController
  def index
    @my_jobs = Job.order("created_at DESC").where("user_id = '#{session[:user_id]}'")
    @my_drives = Drive.order("created_at DESC").where("user_id = '#{session[:user_id]}'")
    @my_products = Product.order("created_at DESC").where("user_id = '#{session[:user_id]}'")
    @my_apartments = Apartment.order("created_at DESC").where("user_id = '#{session[:user_id]}'")
    @my_items = Item.order("created_at DESC").where("user_id = '#{session[:user_id]}'")
    
    @my_articles = (@my_jobs + @my_drives + @my_products + @my_apartments + @my_items).sort_by(&:created_at).reverse!
  end
end
