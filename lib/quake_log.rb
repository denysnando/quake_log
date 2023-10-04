# frozen_string_literal: true

require 'pry'

Dir[File.join('./lib/**/*.rb')].each { |f| require f }

module QuakeLog
end
