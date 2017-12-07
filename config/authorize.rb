before '/houses/:house_id/devices/:device_id/*' do
  result = User::Get.(authorization_header: request.env['HTTP_AUTHORIZATION'].to_s)
  if result.success?
    USER = result['model']
    LOGGER.info "Authorized user #{USER.to_s}"
  else
    LOGGER.info "Unable to authorize user with header #{request.env['HTTP_AUTHORIZATION'].to_s}"
    halt 401
  end

  result = House::Get.(id: params[:house_id], authorization_header: request.env['HTTP_AUTHORIZATION'].to_s)
  if result.success? && result['model']['user_id'] == USER['id']
    HOUSE = result['model']
    LOGGER.info "Authorized house #{HOUSE.to_s}"
  else
    LOGGER.info "Unable to authorize house with id #{params[:house_id]}"
    halt 401
  end

  result = Device::Get.(id: params[:device_id], house_id: params[:house_id], authorization_header: request.env['HTTP_AUTHORIZATION'].to_s)
  if result.success? && result['model']['house_id'] == HOUSE['id']
    DEVICE = result['model']
    LOGGER.info "Authorized device #{DEVICE.to_s}"
  else
    LOGGER.info "Unable to authorize device with id #{params[:device_id]}"
    halt 401
  end
end