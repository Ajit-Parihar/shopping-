# frozen_string_literal: true

class Ability
  include CanCan::Ability
  def initialize(user)
     if user.user_type == "admin"
       can :manage, :all
     elsif user.user_type == "seller"
      can :read, ActiveAdmin::Page, :name => "Home"
      can :read, ActiveAdmin::Page, :name => "Buy"
      can :read, ActiveAdmin::Page, :name => "AddToCart"
      can :manage, Business
      can :manage, Product
      can :manage, Order
     elsif user.user_type == "user"
      can :read, ActiveAdmin::Page, :name => "Home"
      can :read, ActiveAdmin::Page, :name => "Buy"
      can :read, ActiveAdmin::Page, :name => "AddToCart"
      can :read, Business 
      can :read, Order  
     else
      can :read, ActiveAdmin::Page, :name => "Home" 
     end
  end
end
