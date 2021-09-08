# frozen_string_literal: true

require 'csv'

module Phawn
  module ParamsParser
    def self.post_number(parameters)
      errors = Hash.new { |h, k| h[k] = [] }

      data = parameters.dig("data")
      errors["data"] << "parameter is mandatory" if data.nil?

      return nil, errors unless errors.each_value.all?(&:empty?)

      return data, nil
    end

    def self.post_numbers(parameters)
      errors = Hash.new { |h, k| h[k] = [] }

      headers = parameters.dig("headers")
      errors["headers"] << "parameter is mandatory" if headers.nil?

      column = parameters.dig("column")
      errors["column"] << "parameter is mandatory" if column.nil?

      data = parameters.dig("data")
      errors["data"] << "parameter is mandatory" if data.nil?

      return nil, errors unless errors.each_value.all?(&:empty?)

      headers = { "true" => true, "false" => false }[headers]
      if headers.nil?
        errors["headers"] << "allowed values: [true, false]"
        return nil, errors
      end

      begin
        # TODO: handle filesystem errors
        csv = CSV.parse(data[:tempfile], headers: headers)
      rescue CSV::MalformedCSVError
        errors["data"] << "the CSV file is malformed"
        return nil, errors
      end

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