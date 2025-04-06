# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

     if user.user_type == "admin"
     
       can :manage, :all
       
     elsif user.user_type == "seller"
      can :read, ActiveAdmin::Page, :name => "Home"
      can :manage, Business
      can :manage, Product
      can :manage, Order
    else
      can :read, ActiveAdmin::Page, :name => "Home"
    end
  end
end
