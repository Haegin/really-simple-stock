require 'test_helper'
require 'sale_of_stock'

describe SaleOfStock do
  before do
    purchases = [
      StockTransaction.new(yesterday.prev_day, 10, 100), # 10 @ 10
      StockTransaction.new(yesterday, 10, 50),           # 10 @ 5
    ]
    sale = StockTransaction.new(today, 10, -120)          # 10 @ 12
    stock_item = StockItem.new('Pen', purchases + [sale])
    @sale_of_stock = SaleOfStock.new(stock_item)
  end

  it "has a stock item" do
    @sale_of_stock.stock_item.must_be_instance_of StockItem
  end

  it "can calculate relevant transactions" do
    expected_prices = [[10, 10], [10, 5]]
    @sale_of_stock.relevant_transactions.must_equal expected_prices
  end

  it "sells the oldest stock first when there is no prior sale" do
    @sale_of_stock.total_profit.must_equal 10
    @sale_of_stock.profit_per_item.must_equal 2
  end

  it "can calculate unsold_stock_with_prices" do
    transactions = [
      StockTransaction.new(yesterday.prev_day, 10, 100), # 10 @ 10
      StockTransaction.new(yesterday, 10, 50),           # 10 @ 5
      StockTransaction.new(today, 5, -60),               # 10 @ 12
      StockTransaction.new(today, 10, -120)              # 10 @ 12
    ]
    stock_item = StockItem.new('Pen', transactions)
    @sale_of_stock = SaleOfStock.new(stock_item)

    expected = [[5, 10], [10, 5]]

    @sale_of_stock.unsold_stock_with_prices.must_equal expected
  end
end
