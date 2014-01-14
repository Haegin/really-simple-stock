require 'test_helper'

describe StockItem do
  before do
    @opening_purchase = StockTransaction.new(yesterday, 20, 10)
    @stock_item = StockItem.new('Pen', [@opening_purchase])
  end

  it "can be created with the name of the item" do
    StockItem.new('Pen').must_be_instance_of StockItem
  end

  it "knows it's own name" do
    @stock_item.name.must_equal 'Pen'
  end

  it "has a list of stock transactions" do
    @stock_item.transactions.must_equal [@opening_purchase]
  end

  it "can buy stock" do
    after_purchase = @stock_item.buy(today, 10, 10)

    after_purchase.must_be_instance_of StockItem
    after_purchase.name.must_equal @stock_item.name
    after_purchase.quantity.must_equal @stock_item.quantity + 10
  end

  it "can sell stock" do
    after_sale = @stock_item.sell(today, 10, 10)

    after_sale.must_be_instance_of SaleOfStock
    after_sale.stock_item.name.must_equal @stock_item.name
    after_sale.stock_item.quantity.must_equal @stock_item.quantity - 10
  end

  it "cannot sell stock it doesn't have" do
    proc { @stock_item.sell(today, 1000, 10) }.must_raise RuntimeError
  end
end
