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
    user.present? && record.pokemon.user != user
  end

  def update?
    user == record.pokemon.user && record.is_updatable?
  end

  def destroy?
    record.is_updatable?
  end
end
