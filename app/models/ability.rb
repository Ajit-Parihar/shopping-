
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
      can :manage, ActiveAdmin::Page, :name => "SellerDashboard"
      can :read, Business
      can :manage, Product
      can :read, Order
      can :manage, ActiveAdmin::Page, :name => "DisplayProduct"
      can :manage, UserAddress
      can :manage, ActiveAdmin::Page, :name => "OrderTracker"
      can :manage, ActiveAdmin::Page, :name => "Profile"
      # can :read, AdminUser
      can [:read, :update], AdminUser

      can :read, Transaction
      can :manage, ActiveAdmin::Page, :name => "AddToCard"
      can :manage, ActiveAdmin::Page, :name => "Buy"
      can :buy_product, Product
      can :manage, Rating
     else

      can :manage, ActiveAdmin::Page, :name => "AddToCard"
      can :manage, ActiveAdmin::Page, :name => "Buy"
      can :manage, UserAddress
      can :read, Business
      can :read, Product
      can :buy_product, Product
      can :read, Order
      can :manage, Rating
      # can :read, AdminUser
      can [:read, :update], AdminUser
      can :manage, ActiveAdmin::Page, :name => "OrderTracker"
      can :manage, ActiveAdmin::Page, :name => "Profile"
     end

     can :read, Business
  end
end
