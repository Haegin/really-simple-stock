class StockTransaction
  attr_reader :date, :quantity, :amount

  def initialize(date, quantity, amount)
    raise "You must buy or sell something!" unless quantity > 0

    @date = date
    @quantity = quantity
    @amount = amount
  end

  def purchase?
    amount >= 0
  end

  def sale?
    !purchase?
  end

  def price_per_item
    amount.abs / quantity
  end

  def to_s
    if purchase?
      "<Purchase: #{quantity} @ #{price_per_item}>"
    elsif sale?
      "<Sale: #{quantity} @ #{price_per_item}>"
    end
  end

end
