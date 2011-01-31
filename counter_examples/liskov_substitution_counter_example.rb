require 'test_helper'

module CounterExamples
  class BasicAccount
    def initialize(financial_data)
      @financial_data = financial_data.dup
    end

    def balance
      @financial_data.reduce { |sum,data| sum + data }
    end

    def summary
      "Balance: $%.2f" % balance
    end
  end

  class ComplexAccount < BasicAccount
    def highest_debt
      @financial_data.reduce(9999) { |min,data| data < min ? data : min }
    end

    def highest_credit
      @financial_data.reduce(-9999) { |max,data| data > max ? data : max }
    end

    def summary
      report = "#{super}\n"
      report += "Highest debt: $%.2f\n" % highest_debt
      report += "Highest credit: $%.2f\n" % highest_credit
    end
  end
end

module BasicAccountSharedTests
  def test_calculate_the_balance
    instance = @subject_class.new([-50.0, 40.0, 20.0])
    assert_equal(10, instance.balance)
  end

  # This test will fail for ComplexAccount! LSP Violation.
  def test_build_summary
    instance = @subject_class.new([-50.0, 40.0, 20.0])
    assert_equal("Balance: $10.00", instance.summary)
  end
end

class BasicAccountCounterExampleTest < MiniTest::Unit::TestCase
  def setup
    @subject_class = CounterExamples::BasicAccount
  end

  include BasicAccountSharedTests
end

class ComplexAccountCounterExampleTest < MiniTest::Unit::TestCase
  def setup
    @subject_class = CounterExamples::ComplexAccount
    @instance = @subject_class.new([-50.0, 40.0, 20.0])
  end

  def test_calculate_the_highest_debt
    assert_equal(-50.0, @instance.highest_debt)
  end

  def test_calculate_the_highest_credit
    assert_equal(40.0, @instance.highest_credit)
  end

  include BasicAccountSharedTests
end
