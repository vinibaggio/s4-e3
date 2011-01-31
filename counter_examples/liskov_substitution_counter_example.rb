require 'test_helper'

module CounterExamples
  class BasicAccount
    def initialize(financial_data)
      @financial_data = financial_data
    end

    def balance
      @financial_data.reduce(:+)
    end

    def summary
      "Balance: $%.2f" % balance
    end
  end

  class ComplexAccount < BasicAccount
    def highest_debt
      @financial_data.min
    end

    def highest_credit
      @financial_data.max
    end

    def summary
      report = "#{super}\n"
      report += "Highest debt: $%.2f\n" % highest_debt
      report += "Highest credit: $%.2f\n" % highest_credit
    end
  end
end

module BasicAccountSharedTests
  TEST_DATA = [-50.0, 40.0, 20.0]

  def setup
    @instance = subject_class.new(TEST_DATA)
  end

  def test_calculate_the_balance
    assert_equal(10, @instance.balance)
  end

  def test_build_summary
    assert_equal("Balance: $10.00", @instance.summary)
  end
end

class BasicAccountCounterExampleTest < MiniTest::Unit::TestCase
  include CounterExamples
  include BasicAccountSharedTests

  def subject_class
    BasicAccount
  end
end

class ComplexAccountCounterExampleTest < MiniTest::Unit::TestCase
  include CounterExamples
  include BasicAccountSharedTests

  def subject_class
    ComplexAccount
  end

  def test_calculate_the_highest_debt
    assert_equal(-50.0, @instance.highest_debt)
  end

  def test_calculate_the_highest_credit
    assert_equal(40.0, @instance.highest_credit)
  end
end
