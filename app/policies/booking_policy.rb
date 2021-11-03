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

  def update?
    user == record.pokemon.user
  end

  def destroy?
    (record.start_date - Date.today) > 1
  end
end
