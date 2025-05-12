
class Ability
  include CanCan::Ability

  def initialize(user)
     if user.user_type == "admin"
       can :read, Business
       can :manage, Product
       can :read, Order
       can :manage, AdminUser
       can :manage, ActiveAdmin::Page, :name => "Dashboard"
       can :manage, ActiveAdmin::Page, :name => "Profile"
     elsif user.user_type == "seller"
      
      can :read, Business
      can :manage, Product
      can :manage, Order
      can :manage, ActiveAdmin::Page, :name => "DisplayProduct"
      can :read, UserAddress
      can :manage, ActiveAdmin::Page, :name => "OrderTracker"
      can :manage, ActiveAdmin::Page, :name => "Profile"
      can [:edit, :update], AdminUser
      can :read, Transaction
     else

      can :manage, ActiveAdmin::Page, :name => "AddToCard"
      can :manage, ActiveAdmin::Page, :name => "Buy"
      can :manage, UserAddress
      can :read, Business
      can :read, Product
      can :buy_product, Product
      can :read, Order
      can :manage, Rating
      can [:edit, :update], AdminUser
      can :manage, ActiveAdmin::Page, :name => "OrderTracker"
      can :manage, ActiveAdmin::Page, :name => "Profile"
     end

     can :read, Business
  end
end
