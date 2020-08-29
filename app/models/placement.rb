class Placement < ApplicationRecord
  after_create :decrement_product_quantity!

  belongs_to :order, inverse_of: :placements
  belongs_to :product, inverse_of: :placements

  def decrement_product_quantity!
    product.decrement!(:quantity, quantity)
  end
end
