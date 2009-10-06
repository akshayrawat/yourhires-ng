module Matcher
  # Checks that a Http response has a code of 302 REDIRECTED and a target of {:controller => :login, :action => :permission_denied}
  class RedirectToPermissionDenied

    def initialize
      @expected_code = 302
      @expected_target = {:controller => :login, :action => :permission_denied}
    end

    def matches?(target)
      @target = target
      target.code.to_i == @expected_code && target.redirected_to == @expected_target
    end

    def description
      "response should redirect to #{@expected_target.inspect}"
    end

    def failure_message
      "expected a redirect to #{@expected_target.inspect}, but got a response with code #{@target.code} and target #{@target.redirected_to.inspect}"
    end

    def negative_failure_message
      "expected not to get a redirect to {:controller => :login, :action => :permission_denied}, but got a response with code #{@target.code} and target #{@target.redirected_to.inspect}"
    end
  end

  def redirect_to_permission_denied
    RedirectToPermissionDenied.new
  end
end
