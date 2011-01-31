require 'test_helper'

module Examples
  class BankAccount
    def initialize(transactions)
      @transactions = transactions
    end

    def each(&block)
      @transactions.each(&block)
    end

    def balance
      @transactions.reduce(:+)
    end
  end

  class BankExtractPrinter
    def initialize(account)
      @account = account
    end

    def print
      output  = "Bank extract\n"
      output += "#{'=' * 30}\n"
      @account.each do |transaction|
        spaces = " " * (25 - transaction.to_s.length)
        output += "#{spaces} $%.2f\n" % transaction
      end
      output += "#{'-' * 30}\n"
      output += "Total: $%.2f" % @account.balance
      puts output
    end
  end
end

class SingleResponsibilityCounterExampleTest < MiniTest::Unit::TestCase
  include Examples

  def test_print_extract
    bank_account = BankAccount.new([10, 20, 30])
    extract      = BankExtractPrinter.new(bank_account)

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

