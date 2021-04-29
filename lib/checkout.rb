# frozen_string_literal: true

require_relative "checkout/base"
require_relative "checkout/basket"
require_relative "checkout/product"
require_relative "checkout/version"

module Checkout
  class Error < StandardError; end

  def self.new(promotional_rules = nil)
    @base = Base.new(promotional_rules)
  end
end
