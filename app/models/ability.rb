
class Ability
  include CanCan::Ability

  def initialize(user)
     if user.user_type == "admin"
       can :manage, ActiveAdmin::Page, :name => "AllTransactions"
       can :read, Business
       can :manage, Product
       can :read, Order
       can :manage, AdminUser
       can :read, Transaction
       can :manage, ActiveAdmin::Page, :name => "Dashboard"
       can :manage, ActiveAdmin::Page, :name => "Profile"
     elsif user.user_type == "seller"
      can :manage, ActiveAdmin::Page, :name => "SellerDashboard"
      can :read, Business
      can :manage, Product
      can :delete, Product, id: SellerProduct.where(seller_id: user.id).pluck(:product_id)
      can :read, Order
      can :update, Product, id: SellerProduct.where(seller_id: user.id).pluck(:product_id)
      can :manage, ActiveAdmin::Page, :name => "DisplayProduct"
      can :manage, UserAddress
      can :manage, ActiveAdmin::Page, :name => "OrderTracker"
      can :manage, ActiveAdmin::Page, :name => "Profile"
      # can :read, AdminUser
      can [:read, :update], AdminUser
      can :read, Transaction
      can :read, AddToCard
      can :manage, ActiveAdmin::Page, :name => "Buy"
      can :buy_product, Product
      can :manage, Rating
     else
      can :read, AddToCard
      can :manage, ActiveAdmin::Page, :name => "Buy"
      can :manage, UserAddress
      can :read, Business
      can :read, Product
      can :buy_product, Product
      can :read, Order
      can :manage, Rating
      can [:read, :update], AdminUser
      can :manage, ActiveAdmin::Page, :name => "OrderTracker"
      can :manage, ActiveAdmin::Page, :name => "Profile"
     end

     can :read, Business
  end
end
