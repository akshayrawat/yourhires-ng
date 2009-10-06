module Matcher
  # Checks that a Http response has a code of 201 CREATED
  class BeCreated
    def initialize
      @expected = []
      @code = 201
    end

    def matches?(target)
      @target = target
      @target.code.to_i == @code
    end

    def description
      "response code should be #{@code}"
    end

    def failure_message
      "expected #{@target} to have a response code of #{@code}, got #{@target.code}"
    end

    def negative_failure_message
      "expected #{@target} to not have a response code of #{@code}, got #{@target.code}"
    end
  end

  def be_created
    BeCreated.new
  end
end