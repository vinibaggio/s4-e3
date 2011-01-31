require 'test_helper'

module CounterExamples
  class BankExtract
    def initialize(transactions)
      @transactions = transactions
    end

    def balance
      @transactions.reduce(:+)
    end

    def print
      output  = "Bank extract\n"
      output += "#{'=' * 30}\n"
      @transactions.each do |transaction|
        spaces = " " * (25 - transaction.to_s.length)
        output += "#{spaces} $%.2f\n" % transaction
      end
      output += "#{'-' * 30}\n"
      output += "Total: $%.2f" % balance
      puts output
    end
  end
end

class SingleResponsibilityCounterExampleTest < MiniTest::Unit::TestCase
  include CounterExamples

  def test_print_extract
    extract = BankExtract.new([10, 20, 30])
    output, err = capture_io do
      extract.print
    end

    assert_equal <<-OUTPUT, output
Bank extract
==============================
                        $10.00
                        $20.00
                        $30.00
------------------------------
Total: $60.00
    OUTPUT
  end
end
