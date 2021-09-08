# frozen_string_literal: true

require 'csv'

module Phawn
  module NumbersParamsParser
    def self.run(parameters)
      errors = Hash.new { |h, k| h[k] = [] }

      # Validate parameters presence

      headers = parameters.dig("headers")
      errors["headers"] << "parameter is mandatory" if headers.nil?

      column = parameters.dig("column")
      errors["column"] << "parameter is mandatory" if column.nil?

      data = parameters.dig("data")
      errors["data"] << "parameter is mandatory" if data.nil?

      return nil, errors unless errors.each_value.all?(&:empty?)

      # Validate `headers` value

      headers = { "true" => true, "false" => false }[headers]
      if headers.nil?
        errors["headers"] << "allowed values: [true, false]"
        return nil, errors
      end

      # Validate `data` value

      begin
        # TODO: handle filesystem errors
        csv = CSV.parse(data[:tempfile], headers: headers)
      rescue CSV::MalformedCSVError
        errors["data"] << "the CSV file is malformed"
        return nil, errors
      end

      # Validate `columns` value

      if headers
        columns = csv.headers
      else
        csv = csv.transpose
        columns = (0...csv.length)
        column = column.to_i if column.match?(/\d+/)
      end

      if !columns.include?(column)
        errors["column"] << "allowed values: #{columns.to_a}"
        return nil, errors
      end

      return csv[column], nil
    end
  end
end