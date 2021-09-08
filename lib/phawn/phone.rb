module Phawn
  class Phone
    attr_reader :origin
    attr_reader :output
    attr_reader :status
    attr_reader :change

    def initialize(number)
      @origin = number.dup
      @output = number.dup
      @change = []

      check_whitespace
      check_format
    end

    def to_h
      {
        origin: origin,
        output: output,
        status: status,
        change: change,
      }
    end

  private

    def check_whitespace
      if @output.match?(/[[:space:]]/)
        @output.gsub!(/[[:space:]]/, '')
        @change << :WHITESPACE
      end
    end

    def check_format
      case @output
        when /^27\d{9}$/
          @status = @change.any? ? :FIXED : :VALID
        when /^\d{9}$/
          @output = "27#{@output}"
          @change << :PREFIX
          @status = :FIXED
        when /^\+27\d{9}$/
          @output = @output[1..]
          @change << :PREFIX
          @status = :FIXED
        else
          @output = nil
          @change = nil
          @status = :BOGUS
      end
    end
  end
end