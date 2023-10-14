class AvailabilitiesController < ApplicationController
  before_action :set_trainer
  before_action :set_availability, only: [:show, :edit, :update, :destroy]

  def index
    @availabilities = @trainer.availabilities
  end

  def show
  end

  def new
    @availability = @trainer.availabilities.new
  end

  def create
    @availability = @trainer.availabilities.new(availability_params)
    if @availability.save
      redirect_to trainer_availabilities_path(@trainer), notice: 'Availability was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @availability.update(availability_params)
      redirect_to trainer_availabilities_path(@trainer), notice: 'Availability was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @availability.destroy
    redirect_to trainer_availabilities_path(@trainer), notice: 'Availability was successfully destroyed.'
  end

  private

  def set_trainer
    @trainer = Trainer.find(params[:trainer_id])
  end

  def set_availability
    @availability = @trainer.availabilities.find(params[:id])
  end

  def availability_params
    params.require(:availabilities).permit(:day_of_week, :start_time, :end_time)
  end
end
