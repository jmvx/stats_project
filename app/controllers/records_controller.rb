class RecordsController < ApplicationController
  def index
    @records = Record.all.order(created_at: :desc )
    @records_by_day = @records.group_by{ |record| record.created_at.to_date }
    render json: @records_by_day
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
  
    def sort_items
      # Record.all.order(created_at: :desc).group_by{ |record| record.created_at.to_date }
        Record.find(:all, :order => 'created_at, url')
    end

    def record_params
      params.require(:record).permit(:url, :referrer, :created_at)
    end

end
