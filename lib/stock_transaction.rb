require 'bigdecimal'

class StockTransaction
  attr_reader :date, :quantity, :amount

  def initialize(date, quantity, amount)
    raise "You must buy or sell something!" unless quantity > 0

    @date = date
    @quantity = quantity
    @amount = if amount.is_a? BigDecimal
      amount
    else
      BigDecimal.new(amount)
    end
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
      "<Purchase: #{quantity} @ #{price_per_item.to_s('F')}>"
    elsif sale?
      "<Sale: #{quantity} @ #{price_per_item.to_s('F')}>"
    end
  end

end
