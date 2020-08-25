class Product < ApplicationRecord
  validates :title, :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true

  belongs_to :user

  scope :filter_by_title, lambda { |keyword| where('lower(title) LIKE ?', "%#{keyword.downcase}%")}
  scope :above_or_equal_to_price, lambda { |price| where('price >= ?', price) }
  scope :below_or_equal_to_price, lambda { |price| where('price <= ?', price) }
  scope :recent, lambda { order(updated_at: :DESC) }

  def self.search(params = {})
    product_ids = params[:product_ids]
    products = product_ids.present? ? Product.where(id: product_ids) : Product.all
    products = products.filter_by_title(params[:keyword]) if params[:keyword]
    products = products.below_or_equal_to_price(params[:max_price].to_f) if params[:max_price]
    products = products.recent if params[:recent]

    products
  end
end
