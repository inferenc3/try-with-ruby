# Check Ruby LSP is running.

class Main
  def hello
    H.say_hello
  end

  class Helpers
    class << self
      def say_hello
        "hello"
      end
    end
  end

  H = Helpers
end