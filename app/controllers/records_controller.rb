class RecordsController < ApplicationController
  
  def top_urls
    @records = five_day_records.group_by{|record| record.created_at.to_date }
    respond_to do |format|
      format.html
      format.json { render :json => @records }
    end
  end
  
  def top_referrers
    @records = five_day_records.group_by{|record| record.created_at.to_date }
    respond_to do |format|
      format.html 
      format.json { render :json => @records.to_json(:methods => [:top_referrers])}
    end
  end
  
  def index
  end

  def new
  end

  def show
    @record = Record.find(params[:id])
  end

  # post /records.json
  def create
    @record = Record.new(record_params)
    respond_to do |format|
      if @record.save
        format.html { redirect_to root }
        format.json { render json: @record }
      else
        format.html { redirect_to root }
        format.json { render json: @record.errors, status: :unprocessable_entity}
      end
    end
  end

  private
  
    def last_five_days
      Record.uniq.order('created_at desc').limit(5).pluck("DATE_FORMAT(created_at, '%Y-%m-%d')")
    end
    
    def five_day_records
      end_day = last_five_days.first.to_datetime.end_of_day
      start_day = last_five_days.last.to_datetime.beginning_of_day
      return Record.where(:created_at => start_day..end_day).order('created_at desc').group("date(created_at)")
    end

    def record_params
      params.require(:record).permit(:url, :referrer, :created_at)
    end

end
