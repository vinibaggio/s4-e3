require 'test_helper'

module Examples
  class Account
    include Enumerable

    def initialize(category, transactions)
      @category     = category
      @transactions = transactions
    end

    def each(&block)
      @transactions.each(&block)
    end
  end

  class Report
    def initialize(financial_data)
      @financial_data = financial_data.dup
    end

    def balance
      # calls #each in the back
      @financial_data.reduce(:+)
    end

    def print
      puts "Balance: $%.2f" % balance
    end
  end
end

class InterfaceSegregationTest < MiniTest::Unit::TestCase
  include Examples

  def test_report_should_work_with_account
    account = Account.new(:investment, [1_000, 3_300, -500])
    out, err = capture_io do
      report = Report.new(account)
      report.print
    end

    assert_equal "Balance: $3800.00\n", out
  end

  def test_report_should_work_with_arrays
    out, err = capture_io do
      report = Report.new([2_000, -3_000])
      report.print
    end

    assert_equal "Balance: $-1000.00\n", out
  end
end
