class DashboardsController < ApplicationController
  skip_after_action :verify_authorized, only: :show
  after_action :verify_policy_scoped, only: :show

  def show
    @my_bookings = policy_scope(Booking).select { |booking| booking.user == current_user }
    @my_pokemons_bookings = policy_scope(Booking) - @my_bookings
  end
end
