require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  #by default all fixtures are loaded, so we don't need this
  #fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new
    product.title = "Foo"
    product.description = "More Foo For You"
    product.image_url = "foo.jpg"

    [-1, 0].each do |price|
      product.price = price
      assert product.invalid?
      assert_equal ["must be greater than or equal to 0.01"],
        product.errors[:price]
    end

    product.price = 1
    assert product.valid?
  end

  test "product image url must be a png, gif, or jpg" do
    product = Product.new( 
      title: "Foo", 
      description: "More Foo For You", 
      price: 9.99)

    ["foo.jpg", "foo.PNG", "foo.gIf", "http://yay.com/x/y/z.gif"].each do |img|
      product.image_url = img
      assert product.valid?, "#{img} should be a valid image url"
    end

    ["argle.bargle", "bad.gif/blah"].each do |img|
      product.image_url = img
      assert product.invalid?, "#{img} should not be a valid image url"
    end

  end

  test "product title must be unique" do
    product = Product.new(
      title: products(:foo).title,
      description: "test test test",
      price: 1,
      image_url: "foo.png")
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
    #it would be better to look up the error message rather than
    #hardcoding it.  That's not until chapter 15.
  end

  test "product description must be at least 10 chars" do
    product = Product.new(
      title: "A title",
      description: "short",
      price: 1,
      image_url: "foo.png")

    assert product.invalid?, "'#{product.description}'' should be too short for a description"

    product.description = "This is a valid description"

    assert product.valid?, "'#{product.description}' should be a valid product description"
  end

end
