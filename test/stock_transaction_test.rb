require 'test_helper'

describe StockTransaction do

  it "can be created with a date, quantity and amount" do
    StockTransaction.new(today, 10, 100).must_be_instance_of StockTransaction
  end

  describe "purchases" do
    subject { StockTransaction.new(today, 10, 100) }

    it "is a purchase" do
      subject.purchase?.must_equal true
    end

    it "is not a sale" do
      subject.sale?.must_equal false
    end

    it "is a purchase if it's free" do
      StockTransaction.new(today, 10, 0).purchase?.must_equal true
    end

    it "has a helpful to_s" do
      subject.to_s.must_equal "<Purchase: 10 @ 10.0>"
    end
  end

  describe "sales" do
    subject { StockTransaction.new(today, 10, -100) }

    it "is a sale" do
      subject.sale?.must_equal true
    end

    it "is not a purchase" do
      subject.purchase?.must_equal false
    end

    it "has a helpful to_s" do
      subject.to_s.must_equal "<Sale: 10 @ 10.0>"
    end
  end
end
