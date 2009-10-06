module Matcher
  # Checks that a Http response has a code of 422 UNPROCESSABLE ENTITY
  class BeUnprocessableEntity
    def initialize
      @expected_code = 422
    end

    def matches?(target)
      @target = target
      @target.code.to_i == @expected_code
    end

    def description
      "response code should be #{@expected_code}"
    end

    def failure_message
      "expected #{@target} to have a response code of #{@expected_code}, but got #{@target.code}"
    end

    def negative_failure_message
      "expected #{@target} to not have a response code of #{@expected_code}, but got #{@target.code}"
    end
  end

  def be_unprocessable_entity
    BeUnprocessableEntity.new
  end
end