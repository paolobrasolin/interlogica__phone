# frozen_string_literal: true

module Phawn
  module JSendFormatter
    HEADERS = { "Content-Type" => "text/json" }

    def self.success(code, data)
      body = { "status": "success", "data": data }
      [code, HEADERS, [body.to_json]]
    end

    def self.fail(code, data)
      body = { "status": "fail", "data": data }
      [code, HEADERS, [body.to_json]]
    end

    def self.error(code, message)
      body = { "status": "error", "message": message }
      [code, HEADERS, [body.to_json]]
    end
  end
end
