require 'test_helper'

module Examples
  class ATM
    def initialize(params)
      @printer      = params[:printer] || ScreenExtractPrinter.new
      @transactions = params[:transactions]
    end

    def each(&block)
      @transactions.each(&block)
    end

    def balance
      @transactions.reduce(:+)
    end

    def print_extract
      @printer.print(@transactions, balance)
    end
  end

  class ScreenExtractPrinter
    def print(transactions, balance)
      output  = "Bank extract\n"
      output += "#{'=' * 30}\n"
      transactions.each do |transaction|
        spaces = " " * (25 - transaction.to_s.length)
        output += "#{spaces} $%.2f\n" % transaction
      end
      output += "#{'-' * 30}\n"
      output += "Total: $%.2f" % balance
      puts output
    end
  end

  class FileExtractPrinter
    def print(transactions, balance)
      output  = "Bank extract\n"
      output += "#{'=' * 30}\n"
      transactions.each do |transaction|
        spaces = " " * (25 - transaction.to_s.length)
        output += "#{spaces} $%.2f\n" % transaction
      end
      output += "#{'-' * 30}\n"
      output += "Total: $%.2f" % balance

      File.open('tmp/output.txt', 'w') do |file|
        file.puts output
      end
    end
  end
end

class DependencyInjectionTest < MiniTest::Unit::TestCase
  include Examples

  def teardown
    File.delete('tmp/output.txt')
  rescue
  end

  def test_print_extract_to_screen
    bank_account = ATM.new(:transactions => [10, 20, 30])

    output, err = capture_io do
      bank_account.print_extract
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

  def test_print_extract_to_file
    bank_account = ATM.new(:transactions => [10, 20, 30],
                                   :printer      => FileExtractPrinter.new)

    bank_account.print_extract
    extract = File.read('tmp/output.txt')

    assert_equal <<-OUTPUT, extract
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

