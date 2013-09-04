require 'test_helper'

class CartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "adding duplicate items must not create two line items" do
    cart = Cart.create
    foo = products(:foo)
    cart.add_product(foo.id).save!
    cart.add_product(foo.id).save!

    assert_equal 1, cart.line_items.size, "Cart must have one line item"
    assert_equal 2, cart.line_items[0].quantity, "The quantity must be 2"
  end

  test "adding unique items must create two line items" do
    cart = Cart.create
    one = products(:one)
    two = products(:two)
    cart.add_product(one.id).save!
    cart.add_product(two.id).save!

    assert_equal 2, cart.line_items.size, "Cart should have 2 line items"
    cart.line_items.each do |item|
      assert_equal 1, item.quantity, "Item #{item.product.title} should have a quantity of 1"
    end
  end
end
