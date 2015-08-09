class RecordsController < ApplicationController
  
  def top_urls
    @records = by_day
    respond_to do |format|
      format.html
      format.json { render :json => @records }
    end
  end
  
  def top_referrers
    @records = by_day
    respond_to do |format|
      format.html 
      format.json { render :json => @records.as_json(:methods => [:visits, :referrers])}
    end
  end
  
  def index
  end

  def new
  end

  def show
    @record = Record.find(params[:id])
    @visits = @record.visits
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
    
    def by_day
      Record.all.where("created_at < ?", 6.days.ago).order(created_at: :desc ).group_by{ |record| record.created_at.to_date }
    end

    def record_params
      params.require(:record).permit(:url, :referrer, :created_at)
    end

end
