# frozen_string_literal: true

require 'json'

require 'phawn/number_params_parser'
require 'phawn/numbers_params_parser'
require 'phawn/phone'
require 'phawn/jsend_formatter'

module Phawn
  class API
    def call(env)
      req = Rack::Request.new(env)
      case [req.request_method, req.path_info]
        when ["POST", "/numbers"]
          data, errors = Phawn::NumbersParamsParser.run(req.params)
          return JSendFormatter.fail(400, errors) if !errors.nil?
          data = data.map { |n| Phawn::Phone.new(n).to_h }
          JSendFormatter.success(200, data)
        when ["POST", "/number"]
          data, errors = Phawn::NumberParamsParser.run(req.params)
          return JSendFormatter.fail(400, errors) if !errors.nil?
          data = Phawn::Phone.new(data).to_h
          JSendFormatter.success(200, data)
        else
          JSendFormatter.fail(404, { "url": "not found" })
      end
    rescue StandardError => error
      JSendFormatter.error(500, error.message)
      # TODO: log the stack somewhere
    end
  end
end