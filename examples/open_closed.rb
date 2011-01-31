require 'test_helper'

module Examples

  class BankReceipt
    attr_reader :transactions

    def initialize(transactions)
      @transactions = transactions
    end

    def balance
      @transactions.reduce(:+)
    end
  end

  # This example extracts information from a bank receipt in pure string.
  # Example:
  #
  # Bank receipt
  # ====================
  #             C  50.00
  #             D 100.00
  #             C  30.00
  #        -------------
  #  Total:     D  20.00
  #
  #
  #
  # I don't know how it works in the US, but accounting in Brazil uses C
  # for credits and D for debits.
  class BankReceiptParser
    def initialize(receipt)
      @receipt = receipt
    end

    def parse
      transactions = @receipt.split("\n").map do |line|
        parse_line(line)
      end.compact

      BankReceipt.new(transactions)
    end

    def debt_symbol;   'D'; end
    def credit_symbol; 'C'; end

    def parse_line(line)
      symbols = debt_symbol + credit_symbol
      matches = line.match(/^\s*([#{symbols}])\s*([0-9\.]+)$/)
      val     = nil

      if matches
        val = matches[2].to_f
        val *= -1 if matches[1] == debt_symbol
      end

      val
    end
  end

  # Example:
  #
  # Another bank receipt
  # ====================
  #             +  50.00
  #             - 100.00
  #             +  30.00
  #        -------------
  #  Total:     -  20.00
  class AnotherBankReceiptParser < BankReceiptParser
    def debt_symbol;   '-'; end
    def credit_symbol; '+'; end
  end
end

class OpenClosedTest < MiniTest::Unit::TestCase
  def test_parse_transactions_from_bank
    receipt = <<-RECEIPT
Bank receipt
====================
            C  50.00
            D 100.00
            C  30.00
       -------------
 Total:     D  20.00
    RECEIPT

    receipt = Examples::BankReceiptParser.new(receipt).parse
    assert_equal(3                   , receipt.transactions.count)
    assert_equal([50.0, -100.0, 30.0], receipt.transactions)
    assert_equal(-20.0               , receipt.balance)
  end

  def test_parse_transactions_from_another_bank
    receipt = <<-RECEIPT
Another bank receipt
====================
            -  90.00
            + 100.00
            +  30.00
       -------------
 Total:     +  40.00
    RECEIPT

    receipt = Examples::AnotherBankReceiptParser.new(receipt).parse
    assert_equal(3                   , receipt.transactions.count)
    assert_equal([-90.0, 100.0, 30.0], receipt.transactions)
    assert_equal(40.0                , receipt.balance)

  end
end

