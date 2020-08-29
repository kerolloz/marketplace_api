require 'test_helper'

class PlacementTest < ActiveSupport::TestCase
  setup do
    @placement = placements(:one)
  end

  test 'should decrease the product quantity by the placemet quantity' do
    product = @placement.product

    assert_difference('product.quantity', -@placement.quantity) do
      @placement.decrement_product_quantity!
    end
  end
end
