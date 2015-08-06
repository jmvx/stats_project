class RecordsController < ApplicationController
  def index
    @records = Record.all.order(:created_at).group_by{|record| record.created_at.strftime("%Y-%m-%d")}.take(5)
    # Record.find_each(:batch_size => 5) do |r|
    render :json => @records
    # render :json => @sorted
  end

  def new
  end

  def show
    @record = Record.find(params[:id])
    @visits = @record.url_visits
    # @visits = num_visits(@record.url)
    # render :json => @record
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
  
    # def num_visits(url)
    #   Record.where(url: url).length
    # end

    def record_params
      params.require(:record).permit(:url, :referrer, :created_at)
    end

end
