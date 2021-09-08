# frozen_string_literal: true

require 'json'

require 'phawn/params_parser'

module Phawn
  class API
    def call(env)
      req = Rack::Request.new(env)
      case [req.request_method, req.path_info]
      when ["POST", "/numbers"]
        data, errors = Phawn::ParamsParser.post_numbers(req.params)
        # TODO: fiddle with numbers
        if errors.nil?
          body = { "status": "success", "data": data }
          [200, {"Content-Type" => "text/json"}, [body.to_json]]
        else
          body = { "status": "fail", "data": errors }
          [400, {"Content-Type" => "text/json"}, [body.to_json]]
        end
      when ["POST", "/number"]
        data, errors = Phawn::ParamsParser.post_number(req.params)
        # TODO: fiddle with numbers
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