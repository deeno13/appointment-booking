class AppointmentsController < ApplicationController
  before_action :set_trainer
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]
  before_action :set_date_param, only: [:new, :create, :edit, :update]

  def index
    @appointments = @trainer.appointments
  end

  def show
  end

  def new
    @appointment = @trainer.appointments.new
  end

  def create
    @appointment = @trainer.appointments.new(appointment_params)

    if @appointment.save
      redirect_to trainer_appointment_path(@trainer, @appointment), notice: 'Appointment was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to trainer_appointments_path(@trainer), notice: 'Appointment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @appointment.destroy
    redirect_to trainer_appointments_path(@trainer), notice: 'Appointment was successfully destroyed.'
  end

  private

    # Set the date param to today if it is not set
    # Set the wday to the day of the week for the date param
    def set_date_param
      @date_param = params[:date] || Date.today.to_s
      @wday = Date.parse(@date_param).wday
    end

    def set_trainer
      @trainer = Trainer.find(params[:trainer_id])
    end

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    def appointment_params
      params.require(:appointment).permit(:start_time, :end_time)
    end
end
