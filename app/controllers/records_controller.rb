class RecordsController < ApplicationController
  def index
    @records = Record.all.order(created_at: :desc).group_by{|record| record.created_at.strftime("%Y-%m-%d")}
    respond_to do |format|
      format.html
      format.json { render json: @records }
    end
  end

  def new
  end

  def show
    @record = Record.find(params[:id])
    @visits = @record.visits
    @referrers = @record.referrers
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
