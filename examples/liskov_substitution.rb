require 'test_helper'

module Examples
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

    def complete_summary
      report = "#{summary}\n"
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

  def test_build_summary
    instance = @subject_class.new([-50.0, 40.0, 20.0])
    assert_equal("Balance: $10.00", instance.summary)
  end
end

class BasicAccountTest < MiniTest::Unit::TestCase
  def setup
    @subject_class = Examples::BasicAccount
  end

  include BasicAccountSharedTests
end

class ComplexAccountTest < MiniTest::Unit::TestCase
  def setup
    @subject_class = Examples::ComplexAccount
    @instance = @subject_class.new([-50.0, 40.0, 20.0])
  end

  def test_calculate_the_highest_debt
    assert_equal(-50.0, @instance.highest_debt)
  end

  def test_calculate_the_highest_credit
    assert_equal(40.0, @instance.highest_credit)
  end

  def test_build_complete_summary
    assert_equal(<<-SUMMARY, @instance.complete_summary)
Balance: $10.00
Highest debt: $-50.00
Highest credit: $40.00
    SUMMARY
  end

  include BasicAccountSharedTests
end
