require 'roar/decorator'
require 'roar/json'

class Trigger < Sequel::Model(DB)
  class Representer < Roar::Decorator
      include Roar::JSON
      defaults render_nil: true

      property :id
      property :device_id
      property :title
      property :key
      property :output
      property :created_at
      property :updated_at
  end
end