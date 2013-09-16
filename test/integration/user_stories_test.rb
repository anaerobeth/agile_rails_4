require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    book = products(:foo)

    get "/"
    assert_response :success
    assert_template "index"

    xml_http_request :post, '/line_items', product_id: book.id
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal book, cart.line_items[0].product

    get "/orders/new"
    assert_response :success
    assert_template "new"

    post_via_redirect "/orders",
      order: { name: "A Guy",
               address: "123 A Guy's Street",
               email: "guy@aguy.com",
               pay_type: "Check"}
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal "A Guy", order.name
    assert_equal "123 A Guy's Street", order.address
    assert_equal "guy@aguy.com", order.email
    assert_equal "Check", order.pay_type

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal book, line_item.product

    #Mail stuff omitted because I skipped it.
  end
end
