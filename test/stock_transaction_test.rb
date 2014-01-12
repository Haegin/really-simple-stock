require 'test_helper'
require 'stock_transaction'

describe StockTransaction do
  it "can be created with a date, quantity and amount" do
    StockTransaction.new(yesterday, 1, 1).must_be_instance_of StockTransaction
  end

  it "knows if it's a purchase or sale" do
    purchase = StockTransaction.new(today, 10, 100)
    sale = StockTransaction.new(today, 10, -100)

    purchase.purchase?.must_equal true
    sale.purchase?.must_equal false

    purchase.sale?.must_equal false
    sale.sale?.must_equal true
  end

  it "is a purchase if it's free" do
    StockTransaction.new(today, 10, 0).purchase?.must_equal true
  end

  it "has a helpful to_s" do
    StockTransaction.new(today, 10, 100).to_s.must_equal "<Purchase: 10 @ 10>"
    StockTransaction.new(today, 10, -100).to_s.must_equal "<Sale: 10 @ 10>"
  end
end
