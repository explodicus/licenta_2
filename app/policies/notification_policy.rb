class NotificationPolicy < ApplicationPolicy
  def show?
    @user && @user == notification.user
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

    def notification
      @record
    end
end
