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

  it "can calculate relevant transactions case 1" do
    expected_prices = [[10, 10], [10, 5]]
    @sale_of_stock.relevant_transactions.must_equal expected_prices
  end

  it "knows how much each item sold for" do
    @sale_of_stock.sale_price.must_equal 12
  end

  it "knows how many were sold" do
    @sale_of_stock.number_sold.must_equal 10
  end

  it "knows the items that were sold" do
    sold_items = [[10, 10]]
    @sale_of_stock.items_sold.must_equal sold_items
  end

  it "sells the oldest stock first when there is no prior sale" do
    @sale_of_stock.total_profit.must_equal 20
    @sale_of_stock.profit_per_item.must_equal 2
  end

  it "can calculate relevant transactions case 2" do
    transactions = [
      StockTransaction.new(today.prev_day(4), 10, 100),
      StockTransaction.new(today.prev_day(3), 5, -75),
      StockTransaction.new(today.prev_day(2), 5, 55),
      StockTransaction.new(today.prev_day(1), 2, -30),
      StockTransaction.new(today, 2, -30)
    ]
    new_sale = SaleOfStock.new(StockItem.new('Pencils', transactions))
    expected_transactions = [[10, 10], [5, -15], [5, 11], [2, -15]]
    expected_prices = [[3, 10], [5, 11]]
    new_sale.relevant_transactions.must_equal expected_transactions
    new_sale.purchase_prices.must_equal expected_prices
  end

  it "can calculate purchase prices" do
    transactions = [
      StockTransaction.new(yesterday.prev_day, 10, 100), # 10 @ 10
      StockTransaction.new(yesterday, 10, 50),           # 10 @ 5
      StockTransaction.new(today, 5, -60),               # 10 @ 12
      StockTransaction.new(today, 10, -120)              # 10 @ 12
    ]
    stock_item = StockItem.new('Pen', transactions)
    @sale_of_stock = SaleOfStock.new(stock_item)

    expected = [[5, 10], [10, 5]]

    @sale_of_stock.purchase_prices.must_equal expected
  end
end
