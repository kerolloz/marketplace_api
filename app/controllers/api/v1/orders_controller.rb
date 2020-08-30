class Api::V1::OrdersController < ApplicationController
  include Paginable

  before_action :check_login

  def index
    @orders = current_user.orders.page(current_page).per(per_page)
    options = get_pagination_links_serializer_options('api_v1_orders_url', @orders)
    render json: OrderSerializer.new(@orders, options).serializable_hash
  end

  def show
    order = current_user.orders.find(params[:id])
    if order
      options = { include: [:products] }
      render json: OrderSerializer.new(order, options).serializable_hash
    else
      head 404
    end
  end

  def create
    order = current_user.orders.new
    order.build_placements_with_product_ids_and_quantities(order_params[:product_ids_and_quantities])

    if order.save
      OrderMailer.send_confirmation(order).deliver
      render json: order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(product_ids_and_quantities: [:product_id, :quantity])
  end
end
