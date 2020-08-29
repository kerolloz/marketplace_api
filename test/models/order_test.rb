require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = orders(:one)
    @product1 = products(:one)
    @product2 = products(:two)
  end

  test 'should calculate total according to provided products and their quantity' do
    order = Order.new user_id: @order.user_id
    order.products << products(:one)
    order.products << products(:two)
    order.save

    expected_price = @product1.price * @product1.quantity + @product2.price * @product2.quantity
    assert_equal expected_price, order.total
  end

  test 'builds 2 placements for the order' do
    @order.build_placements_with_product_ids_and_quantities [
      { product_id: @product1.id, quantity: 2 },
      { product_id: @product2.id, quantity: 3 }
    ]

    assert_difference('Placement.count', 2) do
      @order.save
    end
  end

  test 'should not allow to place an order with product quantity more than available' do
    @order.placements << Placement.new(product_id: @product1.id, quantity: (@product1.quantity + 1))

    assert_not @order.valid?
  end
end
