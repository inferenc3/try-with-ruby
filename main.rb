class Main
  def hello
    Helpers.say_hello
  end

  class Helpers
    class << self
      def say_hello
        "hello"
      end
    end
  end
end