# frozen_string_literal: true

RSpec.describe Checkout do
  subject(:order) { described_class.new(promotional_rules) }

  let(:promotional_rules) do
    {
      products: [{ product_code: "001", price: 8.5, activation_amount: 2 }],
      basket: [{ percentage: 10, activation_price: 60.0 }]
    }
  end

  it "has a version number" do
    expect(Checkout::VERSION).not_to be nil
  end

  describe ".new" do
    it "creates new basket" do
      expect(order).to be_a(Checkout::Base)
    end
  end

  describe ".scan" do
    subject(:scan) { order.scan(product_code) }

    context "when product code exist" do
      let(:product_code) { "001" }

      it "adds product to basket" do
        expect(scan.size).to eq(1)
        expect(scan.last).to be_a(Checkout::Product)
        expect(scan.last.product).to eq({ "code" => "001", "name" => "Red Scarf", "price" => 9.25 })
      end
    end

    context "when product code not exist" do
      let(:product_code) { "i'm not real code" }

      it "raises error" do
        expect { scan }.to raise_error(Checkout::NoProductFound, "No product found, code: #{product_code}")
      end
    end
  end

  describe ".total" do
    subject(:total) { order.total }

    context "with promotional rules" do
      context "whent test case 1" do
        before(:each) do
          order.scan("001")
          order.scan("002")
          order.scan("003")
        end
  
        it { expect(total).to eq("£66.78") }
      end
  
      context "whent test case 2" do
        before do
          order.scan("001")
          order.scan("003")
          order.scan("001")
        end
  
        it { expect(total).to eq("£36.95") }
      end
  
      context "whent test case 3" do
        before do
          order.scan("001")
          order.scan("002")
          order.scan("001")
          order.scan("003")
        end
  
        it { expect(total).to eq("£73.76") }
      end
    end

    context "withoutpromotional rules" do
      subject(:order) { described_class.new }

      context "whent test case 1" do
        before(:each) do
          order.scan("001")
          order.scan("002")
          order.scan("003")
        end
  
        it { expect(total).to eq("£74.20") }
      end
  
      context "whent test case 2" do
        before do
          order.scan("001")
          order.scan("003")
          order.scan("001")
        end
  
        it { expect(total).to eq("£38.45") }
      end
  
      context "whent test case 3" do
        before do
          order.scan("001")
          order.scan("002")
          order.scan("001")
          order.scan("003")
        end
  
        it { expect(total).to eq("£83.45") }
      end
    end
    
  end
end
