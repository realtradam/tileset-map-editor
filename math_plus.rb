module MathPlus
  def self.divisors_of(num)
    (1..num).select { |n| (num % n).zero? }
  end
end
