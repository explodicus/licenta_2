class UserPolicy < ApplicationPolicy

  def show?
    @user && (@user.admin? || @record == @user || (@user.parent? && @user.children.include?(@record) && @record.admin_confirmed))
  end

  def create?
    @user
  end

  def students?
    @user&.admin?
  end

  def teachers?
    @user&.admin?
  end

  def pending_approval?
    @user&.admin?
  end

  def make_admin?
    @user&.admin?
  end

  def make_teacher?
    @user&.admin?
  end

  def make_editor?
    @user&.admin?
  end

  def remove_admin?
    @user&.admin?
  end

  def remove_teacher?
    @user&.admin?
  end

  def remove_editor?
    @user&.admin?
  end

  def approve?
    @user&.admin?
  end

  def new_full?
    @user && (@user.admin? || (@user.parent? && @user.children.include?(@record) && @record.admin_confirmed))
  end

  def edit?
    @user && (@user.admin? || (@user.parent? && @user.children.include?(@record) && @record.admin_confirmed))
  end

  def create_full?
    @user && (@user.admin? || (@user.parent? && @user.children.include?(@record) && @record.admin_confirmed))
  end

  def update?
    @user && (@user.admin? || (@user.parent? && @user.children.include?(@record) && @record.admin_confirmed))
  end

  def set_discount?
    @user&.admin?
  end

  def update_discount?
    @user&.admin?
  end
end
