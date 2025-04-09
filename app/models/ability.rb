
class Ability
  include CanCan::Ability

  def initialize(user)
     if user.user_type == "admin"
       can :manage, :all

     elsif user.user_type == "seller"
      can :manage, Business
      can :manage, Product
      can :manage, Order

     else 
      can :manage, ActiveAdmin::Page, :name => "AddToCard"
      can :read, Business
      cannot :read, Order
     end
  end
end
