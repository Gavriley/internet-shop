class Ability
  include CanCan::Ability

  def initialize(user)
    
    @ability_user = user || User.new 
    
    case @ability_user.role.name
      when 'guest'
        guest_can 
      when 'client'
        client_can 
      when 'manage'
        manager_can     
      when 'admin'
        admin_can  
    end      
  end

  private
    def admin_can
      manager_can

      can :manage, Comment
      can :manage, Product
    end  

    def manager_can
      client_can

      can :manage, Comment, product: { user: @ability_user }

      can :create, Product
      can :valid_avatar, Product
      can :update, Product, user: @ability_user
    end  

    def client_can
      guest_can

      can :create, Comment
      can :update, Comment, user: @ability_user
      can :destroy, Comment, user: @ability_user
    end  

    def guest_can
      can :read, Product
      can :search, Product

      can :read, Category

      can :read, Cart
      can :create, Cart

      can :read, LineItem
      can :create, LineItem
      can :count_up, LineItem
      can :count_down, LineItem

      can :read, Order
      can :create, Order
      can :liqpay_response, Order
      can :paypal_response, Order
      can :create_stripe, Order

      can :read, Comment
    end  
end
