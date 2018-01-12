require 'roar/decorator'
require 'roar/json'

class Trigger < Sequel::Model(DB)
  Types = {'system' => 0, 'device' => 1}

  class Representer < Roar::Decorator
    include Roar::JSON
    defaults render_nil: true

    property :id
    property :device_id
    property :title
    property :key
    property :output
    property :type
    property :created_at
    property :updated_at
  end
end