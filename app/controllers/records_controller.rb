class RecordsController < ApplicationController
  def index
    @records = Record.all.group_by{|record| record.created_at.strftime("%Y-%m-%d")}
    render :json => @records
  end

  def new
  end

  def show
    @record = Record.find(params[:id])
    render :json => @record
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
