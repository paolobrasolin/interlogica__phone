# frozen_string_literal: true

require 'json'

require 'phawn/number_params_parser'
require 'phawn/numbers_params_parser'
require 'phawn/phone_validator'

module Phawn
  class API
    def call(env)
      req = Rack::Request.new(env)
      case [req.request_method, req.path_info]
      when ["POST", "/numbers"]
        data, errors = Phawn::NumbersParamsParser.run(req.params)
        data = data.map(&Phawn::PhoneValidator.method(:run))
        if errors.nil?
          body = { "status": "success", "data": data }
          [200, {"Content-Type" => "text/json"}, [body.to_json]]
        else
          body = { "status": "fail", "data": errors }
          [400, {"Content-Type" => "text/json"}, [body.to_json]]
        end
      when ["POST", "/number"]
        data, errors = Phawn::NumberParamsParser.run(req.params)
        data = Phawn::PhoneValidator.run(data)
        if errors.nil?
          body = { "status": "success", "data": data }
          [200, {"Content-Type" => "text/json"}, [body.to_json]]
        else
          body = { "status": "fail", "data": errors }
          [400, {"Content-Type" => "text/json"}, [body.to_json]]
        end
      else
        [404, {}, []]
      end
    end
  end
end