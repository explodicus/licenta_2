# Policy for post
class PostPolicy < ApplicationPolicy
  def index?
    @user
  end

  def show?
    @user
  end

  def create?
    @user && (@user.admin? || @user.editor?)
  end

  def update?
    @user && (@user.admin? || (@user == @post.user))
  end

  def destroy?
    @user && (@user.admin? || (@user == @post.user))
  end

  private

  def post
    @record
  end
end
