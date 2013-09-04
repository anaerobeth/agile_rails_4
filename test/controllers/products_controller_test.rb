require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
    @foo = products(:foo)
    @update = {
      title: 'Foo',
      description: 'More Foo For You',
      image_url: 'pity_da_foo.jpg',
      price: 999.99
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)

    assert_select "#main .list_line_odd", 2
    assert_select "#main .list_line_even", 1
    assert_select "#main .list_description", 3
    assert_select "#main .list_image", 3
    assert_select "#main a", "Show", 3
    assert_select "#main a", "Edit", 3
    assert_select "#main .list_description dl dt", "Programming Ruby 1.9"
    assert_select "#main .list_description dl dd", "MyText"
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: @update
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, id: @foo
    assert_response :success

    assert_select "#main p", /PTD Foo/   #title
    assert_select "#main p", /Mr T says PDT Foo/  #description
    assert_select "#main p", /foo\.png/  #image
    assert_select "#main p", /0?\.10?/   #price
  end

  test "should get edit" do
    get :edit, id: @product
    assert_response :success

    assert_select "#product_title[value=?]", @product.title
    assert_select "#product_description", /MyText/
    assert_select "#product_image_url[value=?]", @product.image_url
    assert_select "#product_price[value=?]", @product.price.to_s
  end

  test "should update product" do
    patch :update, id: @product, product: @update
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product
    end

    assert_redirected_to products_path
  end
end
