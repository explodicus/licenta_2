class GroupPolicy < ApplicationPolicy
  def index?
    @user&.admin?
  end

  def show?
    @user && (@user.admin? || (@user.teacher? && @user.in?(group.users)))
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

  def search_attendance?
    @user&.admin?
  end

  def found_attendance?
    @user && (@user.admin? || (@user.teacher? && @user.in?(group.users) &&
        lesson_now?))
  end

  def create_attendances?
    @user && (@user.admin? || (@user.in?(group.users) && @user.teacher? &&
        lesson_now?))
  end

  def lesson_now?
    if group.active
      group.find_lesson(Time.now)
      return true
    end
    false
  end

  private

  def group
    @record
  end
end
