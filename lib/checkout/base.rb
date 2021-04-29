# frozen_string_literal: true

module Checkout
  class Base
    attr_accessor :promotional_rules, :basket

    def initialize(promotional_rules = nil)
      @promotional_rules = promotional_rules
      @basket = Basket.new
    end

    def scan(code)
      basket.add(Product.find_by_code(code))
    end

    def total
      count_discounts
      basket.price_with_currency
    end

    private

    def count_discounts
      if promotional_rules
        count_products_promotions
        count_basket_promotions
      else
        basket.sum_final_prices
      end
    end

    def count_products_promotions
      promotional_rules[:products].each do |promo|
        products = basket.find_products(promo[:product_code])

        products.map { |item| item.promotional_price = promo[:price] } if products.count >= promo[:activation_amount]
      end
      basket.sum_final_prices
    end

    def count_basket_promotions
      promotional_rules[:basket].each do |promo|
        percentage_discount(promo[:percentage]) if basket.final_price > promo[:activation_price]
      end
    end

    def percentage_discount(percentage)
      basket.final_price = basket.final_price * (100 - percentage) / 100.0
    end
  end
end
