# frozen_string_literal: true

require 'yaml'

module Checkout
  class NoProductFound < StandardError; end

  class Product
    LIST = YAML.load_file('lib/checkout/product/products.yaml').freeze

    attr_accessor :product, :promotional_price

    def initialize(product)
      @product = product
    end

    def self.find_by_code(code)
      products = LIST.select { |product| product["code"] == code }
      return new(products.last) if products.any?

      raise NoProductFound, "No product found, code: #{code}"
    end

    def final_price
      promotional_price.nil? ? price : promotional_price
    end

    def code
      product["code"]
    end

    def name
      product["name"]
    end

    def price
      product["price"]
    end
  end
end
