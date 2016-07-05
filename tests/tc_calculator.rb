require "test/unit"
require_relative "../calculator"

class TestLexer < Test::Unit::TestCase
  def test_addition
    calculator = Calculator.new
    assert_equal(6, calculator.run("1 + 5"))
  end

  def test_substraction
    calculator = Calculator.new
    assert_equal(201, calculator.run("206 - 5"))
  end

  def test_multiplication
    calculator = Calculator.new
    assert_equal(24, calculator.run("4 * 6"))
  end

  def test_division
    calculator = Calculator.new
    assert_equal(4, calculator.run("20 / 5"))
  end

  def test_pharentesis
    calculator = Calculator.new
    assert_equal(30, calculator.run("(1 + 9) * 3"))
  end

  def test_pharentesis_mismatch
    calculator = Calculator.new
    assert_raise(RuntimeError) do
      calculator.run("(4 + 3)) * 2")
    end 
  end

  def test_divide_by_zero
    calculator = Calculator.new
    assert_raise(RuntimeError) do
      calculator.run("1 / 0")
    end 
  end

  def test_invalid_token
    calculator = Calculator.new
    assert_raise(RuntimeError) do
      calculator.run("a + 1")
    end 
  end 
end 
