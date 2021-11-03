class DashboardsController < ApplicationController
  skip_after_action :verify_authorized, only: :show
  after_action :verify_policy_scoped, only: :show

  def show
    @applied_bookings = policy_scope(current_user.bookings).sort_by(&:start_date).reverse
    @received_bookings = policy_scope(current_user.received_bookings).sort_by(&:start_date).reverse
  end
end
