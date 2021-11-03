class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user) + scope.joins(:pokemon).where(pokemons: { user: user })
    end
  end

  def show?
    user == record.user
  end

  def create?
    user.present?
  end

end
