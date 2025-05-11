class AddToCardsController < ApplicationController
  def update_quantity
   puts "working fine update quantity work"
   puts current_admin_user.inspect
   puts params[:product_id]
    @add_to_card = AddToCard.find_by(id: params[:product_id], admin_user_id: current_admin_user.id)
     puts @add_to_card.inspect
    if @add_to_card
      if @add_to_card.update(quantity: params[:quantity])
        render json: { success: true, message: 'Quantity updated successfully!' }
      else
        render json: { success: false, message: 'Failed to update quantity.' }
      end
    else
      render json: { success: false, message: 'Cart item not found.' }
    end
  end
end
