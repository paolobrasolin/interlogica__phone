# frozen_string_literal: true

module Phawn
  module NumberParamsParser
    def self.run(parameters)
      errors = Hash.new { |h, k| h[k] = [] }

      # Validate parameters presence

      data = parameters.dig("data")
      errors["data"] << "parameter is mandatory" if data.nil?

      return nil, errors unless errors.each_value.all?(&:empty?)

      return data, nil
    end
  end
end