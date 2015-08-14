class RecordsController < ApplicationController
  
  # /top_urls
  def top_urls
  end

  # /top_referrers
  def top_referrers
  end

  # /get_top_urls.json
  def get_top_urls
    @records = Record.top_urls
    render json: @records
  end
  
  # /get_top_referrers.json
  def get_top_referrers
    @records = Record.top_referrers
    render json: @records
  end

  def index
  end

  # GETS /records/[id]
  def show
    @record = Record.find(params[:id])
  end

  def new
  end

  def create
    @record = Record.new(record_params)
    respond_to do |format|
      if @record.save
        format.html { redirect_to @record }
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
