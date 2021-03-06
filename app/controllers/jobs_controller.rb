# coding: UTF-8

#Fachhochschule Salzburg, MultiMediaTechnology, 2012
#Fachspezifisches Qualifikationsprojekt 2a
#Entwickler: Lukas Wanko, Sören Hentzschel

require 'user'

class JobsController < ApplicationController
  add_breadcrumb 'Jobbörse', '/jobs'
  
  def index    
    if params[:filter].present?
      if params[:filter] == "t"
        @filter = true
        add_breadcrumb 'Biete', jobs_path + '?filter=t'
      else
        @filter = false
        add_breadcrumb 'Suche', jobs_path + '?filter=f'
      end
    end
    
    if params[:service].present?
      add_breadcrumb params[:service], jobs_path + '?service=' + params[:service]
    end
  
    if params[:filter].present? && params[:service].present? && params[:service] == "Freiwillig"
      @jobs = Job.where(:is_offer => @filter, :paid => false).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
    elsif params[:filter].present? && params[:service].present?
      @jobs = Job.where(:is_offer => @filter, :employment_status => params[:service]).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')     
    elsif params[:service].present? && params[:service] == "Freiwillig"
      @jobs = Job.where(:paid => false).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
    elsif params[:service].present?
      @jobs = Job.where(:employment_status => params[:service]).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
    elsif params[:filter].present?
      @jobs = Job.where(:is_offer => @filter).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
    else
      @jobs = Job.paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
    end
  end

  def show
    @job = Job.find(params[:id])
    
    if @job.is_offer
      add_breadcrumb 'Biete', jobs_path + '?filter=t'
    else
      add_breadcrumb 'Suche', jobs_path + '?filter=f'
    end
    add_breadcrumb @job.title, job_path

    if cookies["job" + @job.id.to_s] != "disabled"
      cookies["job" + @job.id.to_s] = { :value => "disabled", :expires => 2.hour.from_now }
      @job.update_attribute(:counter, @job.counter + 1)
    end
  end

  def new
    @job = Job.new
    add_breadcrumb 'Anzeige hinzufügen', new_job_path
  end

  def create
    @job = Job.new(params[:job])
    @job.user_id = session[:user_id]
    @job.module = "job"

    if @job.save
      redirect_to @job, notice: 'Anzeige wurde erfolgreich hinzugefügt!'
    else
      render action: "new"
    end
  end
  
  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to jobs_path, :notice => 'Anzeige wurde erfolgreich gelöscht!'
  end
  
  def filter
  end
  
  def service
  end
  
  def remove_old_articles
    post_ids = Job.find(:all, :conditions => ["created_at < ?", 60.days.ago])
    puts "Aktualisiert am" + Time.now
    if post_ids.size > 0
      Item.destroy(post_ids)
    end
  end
end
