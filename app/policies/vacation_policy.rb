class VacationPolicy < ApplicationPolicy
  def index?
    @user&.admin?
  end

  def show?
    @user&.admin?
  end

  def create?
    @user&.admin?
  end

  def update?
    @user&.admin?
  end

  def destroy?
    @user&.admin?
  end

  private

  def vacation
    @record
  end
end
