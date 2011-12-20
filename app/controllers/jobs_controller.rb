require 'user.rb'

class JobsController < ApplicationController
  def index
    @jobs = Job.limit(5).order('id DESC')
  end

  def show
    @job = Job.find(params[:id])
    
    @job.counter += 1;
    @job.update_attributes(params[:job])
    
    if @job.paid == false
      @paid = "Freiwillig"
    else
      @paid = "Bezahlte Arbeit"
    end
    
    if @job.paid == false
      @paid = "Freiwillig"
    else
      @paid = "Bezahlte Arbeit"
    end
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(params[:job])
    @job.counter = 0;   
    @job.user_id = 1;
    
    #Ask Raidel why it doesn't work automatically
    @job.employment_status = params[:employment_status]
    @job.offer_or_quest = params[:offer_or_quest]
    @job.paid = params[:paid]
    #############################################

    @job.save
    redirect_to jobs_path
  end
end
