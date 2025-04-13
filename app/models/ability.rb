
class Ability
  include CanCan::Ability

  def initialize(user)
     if user.user_type == "admin"
       can :manage, :all

     elsif user.user_type == "seller"
      can :read, Business
      can :manage, Product
      can :manage, Order
      can :manage, ActiveAdmin::Page, :name => "DisplayProduct"

     else 
      can :manage, ActiveAdmin::Page, :name => "AddToCard"
      can :manage, ActiveAdmin::Page, :name => "Buy"
      can :manage, ActiveAdmin::Page, :name => "DisplayProduct"
      can :read, Business
      can :manage, UserAddress
      can :read, Product
      can :read, Order, user_id: user.id
      can :manage, Rating
      can :manage, ActiveAdmin::Page, :name => "OrderTracker"
     end
  end
end
