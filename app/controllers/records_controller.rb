class RecordsController < ApplicationController
  
  def top_urls
    @records = Record.top_urls
    respond_to do |format|
      format.html
      format.json { render :json => @records }
    end
  end
  
  def top_referrers
    @records = Record.top_referrers
    respond_to do |format|
      format.html 
      format.json { render :json => @records }
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

    def record_params
      params.require(:record).permit(:url, :referrer, :created_at)
    end

end
