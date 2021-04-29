# frozen_string_literal: true

module Checkout
  class Basket
    attr_accessor :items, :regular_price, :final_price

    PRICE_FORMAT = '%.2f'

    def initialize
      @items = []
    end

    def add(item)
      items << item
    end

    def find_products(product_code)
      items.select { |item| item.code == product_code }
    end

    def sum_final_prices
      @regular_price = items.map(&:final_price).inject(:+)
      @final_price = @regular_price
    end

    def price_with_currency
      "£#{self}"
    end

    private

    def to_s
      format(PRICE_FORMAT, final_price)
    end
  end
end
