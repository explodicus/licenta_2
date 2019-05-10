class VacationsController < ApplicationController
  before_action :set_vacation, except: %i[index new create]
  after_action :verify_authorized

  def index
    @vacations = Vacation.all
    authorize @vacations
  end

  def show
    authorize @vacation
  end

  def new
    @vacation = Vacation.new
    authorize @vacation
  end

  def create
    @vacation = Vacation.new(vacation_params)
    authorize @vacation
    if @vacation.save
      flash[:success] = 'Vacation was successfully created'
      redirect_to vacations_url
    else
      render 'new'
    end
  end

  def edit
    authorize @vacation
  end

  def update
    authorize @vacation
    if @vacation.update_attributes(vacation_params)
      flash[:success] = 'Vacation updated'
      redirect_to vacations_url
    else
      render 'edit'
    end
  end

  def destroy
    @vacation.destroy
    authorize @vacation
    flash[:success] = 'Vacation deleted'
    redirect_to vacations_url
  end

  private

  def set_vacation
    @vacation = Vacation.find(params[:id])
  end

  def vacation_params
    params.require(:vacation).permit(:name, :kind, :start_date, :end_date)
  end
end
