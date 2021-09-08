# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib/')

require 'phawn'

run Phawn::API.new
