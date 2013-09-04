class CombineItemsInCart < ActiveRecord::Migration
  def up
    #for each cart
    Cart.all.each do |cart|
      #get the count of each product
      sums = cart.line_items.group(:product_id).sum(:quantity)

      #for each product/count pair
      sums.each do |product_id, quantity|
        if quantity > 1
          #get rid of existing lines
          cart.line_items.where(product_id: product_id).delete_all

          #create a new line with the correct quantity
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end

  #break existing line items with quantities > 1 into individual
  #line items.
  def down
    LineItem.where("quantity>1").each do |line_item|
      line_item.quantity.times do
        LineItem.create cart_id: line_item.cart_id,
          product_id: line_item.product_id, quantity: 1  
      end

      line_item.destroy  #get rid of the old line item    
    end
  end
end
