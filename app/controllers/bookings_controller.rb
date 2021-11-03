class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :update, :destroy]

  def show
    authorize @booking
  end

  def new
    @pokemon = Pokemon.find(params[:pokemon_id])
    @booking = Booking.new
    authorize @booking
  end

  def create
    @pokemon = Pokemon.find(params[:pokemon_id])
    @booking = Booking.new(booking_params)
    @booking.pokemon = @pokemon
    @booking.user = current_user
    authorize @booking

    if @booking.save
      redirect_to booking_path(@booking)
    else
      render :new
    end
  end

  def update
    authorize @booking
    @booking.send("#{params[:status]}!")
    redirect_to dashboard_path
  end

  def destroy
    authorize @booking
    @booking.destroy
    redirect_to dashboard_path
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end

  def set_booking
		@booking = Booking.find(params[:id])
  end
end
