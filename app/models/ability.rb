
class Ability
  include CanCan::Ability

  def initialize(user)
     if user.user_type == "admin"
       can :read, Business
       can :read, Product
       can :read, Order
       can :manage, AdminUser
       can :manage, ActiveAdmin::Page, :name => "Dashboard"

     elsif user.user_type == "seller"
      
      can :read, Business
      can :manage, Product
      can :manage, Order
      can :manage, ActiveAdmin::Page, :name => "DisplayProduct"
      can :read, UserAddress

     else 
      can :manage, ActiveAdmin::Page, :name => "AddToCard"
      can :manage, ActiveAdmin::Page, :name => "Buy"
      can :manage, UserAddress
      can :read, Business
      can :read, Product
      can :buy_product, Product        
      # can :read, Order, user_id: user.id
      can :manage, Order
      can :manage, Rating
      can :manage, ActiveAdmin::Page, :name => "OrderTracker"
     end
  end
end
