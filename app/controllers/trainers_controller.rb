class TrainersController < ApplicationController
  before_action :set_trainer, only: [:show, :edit, :update, :destroy]

  def index
    @trainers = Trainer.all
  end

  def show
  end

  def new
    @trainer = Trainer.new
  end

  def create
    @trainer = Trainer.new(trainer_params)
    if @trainer.save
      redirect_to @trainer, notice: 'Trainer was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @trainer.update(trainer_params)
      redirect_to @trainer, notice: 'Trainer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @trainer.destroy
    redirect_to trainers_url, notice: 'Trainer was successfully destroyed.'
  end

  private

  def set_trainer
    @trainer = Trainer.find(params[:id])
  end

  def trainer_params
    params.require(:trainer).permit(:name)
  end
end
