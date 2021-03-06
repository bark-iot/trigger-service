require 'sinatra'
require 'sinatra/namespace'
require 'sinatra/reloader' if development?
require './config/logging.rb'
require './config/authorize.rb'
require './config/database.rb'
require './config/concepts.rb'
require './config/redis.rb'


set :bind, '0.0.0.0'
set :port, 80
set :public_folder, 'public'

get '/triggers/docs' do
  redirect '/triggers/docs/index.html'
end

get '/triggers/system' do
  result = SystemTrigger::List.()
  if result.success?
    body Trigger::Representer.for_collection.new(result['models']).to_json
  else
    status 422
    body result['contract.default'].errors.messages.uniq.to_json
  end
end

get '/houses/:house_id/triggers/:id/validate' do
  result = Trigger::ValidateHouseId.(params.merge(authorization_header: request.env['HTTP_AUTHORIZATION'].to_s))
  if result.success?
    body Trigger::Representer.new(result['model']).to_json
  else
    if result['contract.default'] && result['contract.default'].errors.messages.size > 0
      status 422
      body result['contract.default'].errors.messages.uniq.to_json
    else
      status 404
    end
  end
end

namespace '/houses/:house_id/devices/:device_id' do
  get '/triggers' do
    result = Trigger::List.(device_id: params[:device_id])
    if result.success?
      body Trigger::Representer.for_collection.new(result['models']).to_json
    else
      status 422
      body result['contract.default'].errors.messages.uniq.to_json
    end
  end

  post '/triggers' do
    result = Trigger::Create.(params)
    if result.success?
      body Trigger::Representer.new(result['model']).to_json
    else
      if result['contract.default']
        status 422
        body result['contract.default'].errors.messages.uniq.to_json
      else
        status 404
      end
    end
  end

  get '/triggers/:id' do
    result = Trigger::Get.(params)
    if result.success?
      body Trigger::Representer.new(result['model']).to_json
    else
      if result['contract.default']
        status 422
        body result['contract.default'].errors.messages.uniq.to_json
      else
        status 404
      end
    end
  end

  put '/triggers/:id' do
    result = Trigger::Update.(params)
    if result.success?
      body Trigger::Representer.new(result['model']).to_json
    else
      if result['contract.default']
        status 422
        body result['contract.default'].errors.messages.uniq.to_json
      else
        status 404
      end
    end
  end

  delete '/triggers/:id' do
    result = Trigger::Delete.(params)
    if result.success?
      status 200
    else
      if result['contract.default'].errors.messages.size > 0
        status 422
        body result['contract.default'].errors.messages.uniq.to_json
      else
        status 404
      end
    end
  end
end