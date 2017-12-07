require File.expand_path '../spec_helper.rb', __FILE__

describe 'Devices Service' do
  before(:each) do
    DB.execute('TRUNCATE TABLE triggers;')
    stub_request(:get, 'http://lb/users/by_token').
        with(headers: {'Authorization'=>"Bearer #{token}"}).
        to_return(status: 200, body: '{"id":1,"email":"test@test.com","token":"a722658b-0fea-415c-937f-1c1d3c8342fd","created_at":"2017-11-14 16:06:52 +0000","updated_at":"2017-11-14 16:06:52 +0000"}', headers: {})
    stub_request(:get, 'http://lb/users/by_token').
        with(headers: {'Authorization'=>'Bearer wrong_token'}).
        to_return(status: 422, body: '', headers: {})
    stub_request(:get, 'http://lb/houses/1').
        with(headers: {'Authorization'=>"Bearer #{token}"}).
        to_return(status: 200, body: '{"id":1,"user_id":1,"title":"Test","address":"Pr Pobedi 53b","key":"4d27328d-cbf6-493e-a5ec-7f6848ece614","created_at":"2017-11-24 20:32:29 +0000","updated_at":"2017-11-24 20:32:29 +0000"}', headers: {})
    stub_request(:get, 'http://lb/houses/3').
        with(headers: {'Authorization'=>'Bearer wrong_token'}).
        to_return(status: 404, body: '', headers: {})
    stub_request(:get, 'http://lb/houses/1/devices/1').
        with(headers: {'Authorization'=>"Bearer #{token}"}).
        to_return(status: 200, body: '{"id": 1,"house_id": 1,"title": "MyDevice","com_type": 0,"token": "2d931510-d99f-494a-8c67-87feb05e1594","online":false,"approved_at": "2017-11-11 11:04:44 UTC","created_at": "2017-11-11 11:04:44 UTC","updated_at": "2017-1-11 11:04:44 UTC"}', headers: {})
  end

  #TODO: add delete device test

  it 'should show trigger' do
    header 'Authorization', "Bearer #{token}"
    get "/houses/1/devices/1/triggers/#{trigger.id}"

    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)
    expect(body['title']).to eql('MyTrigger')
    expect(body['key']).to eql('my_trigger')
  end

  it 'should not show trigger for another device' do
    t = Trigger::Create.(title: 'MyTrigger', key: 'my_trigger', device_id: 2)['model']
    header 'Authorization', "Bearer #{token}"
    get "/houses/1/devices/1/triggers/#{t.id}"

    expect(last_response.status).to equal(404)
  end

  it 'should list all triggers for device' do
    trigger_title = trigger.title
    header 'Authorization', "Bearer #{token}"
    get 'houses/1/devices/1/triggers'

    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)
    expect(body[0]['title'] == trigger_title).to be_truthy
  end

  it 'should not list triggers for another device' do
    Trigger::Create.(title: 'MyTrigger', key: 'my_trigger', device_id: 2)['model']
    header 'Authorization', "Bearer #{token}"
    get '/houses/1/devices/1/triggers'

    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)
    expect(body.size == 0).to be_truthy
  end

  it 'should not list all triggers for user with wrong token' do
    header 'Authorization', 'Bearer wrong_token'
    get '/houses/1/devices/1/triggers'

    expect(last_response.status).to equal(401)
  end

  it 'should create trigger for device' do
    header 'Authorization', "Bearer #{token}"
    post '/houses/1/devices/1/triggers', {title: 'MyTrigger', key: 'my_trigger', output: '[{"key":"temp","type":"int"}]'}

    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)
    expect(body['title']).to eql('MyTrigger')
    expect(body['key']).to eql('my_trigger')
    output = JSON.parse(body['output'])
    expect(output[0]['key']).to eql('temp')
    expect(output[0]['type']).to eql('int')
  end

  it 'should not create trigger without title' do
    header 'Authorization', "Bearer #{token}"
    post '/houses/1/devices/1/triggers', {output: '[{"key":"temp","type":"int"}]'}

    expect(last_response.status).to equal(422)
    body = JSON.parse(last_response.body)
    expect(body[0] == ['title', ['must be filled']]).to be_truthy
    expect(body[1] == ['key', ['must be filled']]).to be_truthy
  end

  it 'should not create trigger with not unique key' do
    t = trigger
    header 'Authorization', "Bearer #{token}"
    post '/houses/1/devices/1/triggers', {title: 'Something', key: t.key, output: '[{"key":"temp","type":"int"}]'}

    expect(last_response.status).to equal(422)
    body = JSON.parse(last_response.body)
    expect(body[0] == ['key', ['already taken']]).to be_truthy
  end

  it 'should not create triggers for user with wrong token' do
    header 'Authorization', 'Bearer wrong_token'
    post '/houses/1/devices/1/triggers', {title: 'MyTrigger', key: 'my_trigger', output: '[{"key":"temp","type":"int"}]'}

    expect(last_response.status).to equal(401)
  end

  it 'should update trigger for device' do
    header 'Authorization', "Bearer #{token}"
    put "/houses/1/devices/1/triggers/#{trigger.id}", {title: 'My Trigger'}

    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)
    expect(body['title']).to eql('My Trigger')
  end

  it 'should not update trigger key for device' do
    header 'Authorization', "Bearer #{token}"
    put "/houses/1/devices/1/triggers/#{trigger.id}", {title: 'My Trigger', key: 'new_key'}

    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)
    expect(body['title']).to eql('My Trigger')
    expect(body['key']).to eql('my_trigger')
  end

  it 'should not update trigger of another device' do
    another_trigger = Trigger::Create.(title: 'MyTrigger', device_id: 2, key: 'my_key')['model']
    header 'Authorization', "Bearer #{token}"
    put "/houses/1/devices/1/triggers/#{another_trigger.id}", {title: 'My Trigger'}

    expect(last_response.status).to equal(404)
  end

  it 'should not update trigger for user with wrong token' do
    header 'Authorization', 'Bearer wrong_token'
    put "/houses/1/devices/1/triggers/#{trigger.id}", {title: 'MyTrigger'}

    expect(last_response.status).to equal(401)
  end

  it 'should delete trigger for device' do
    trigger_id = trigger.id
    header 'Authorization', "Bearer #{token}"
    delete "/houses/1/devices/1/triggers/#{trigger_id}"

    expect(last_response).to be_ok
    expect(Trigger.where(id: trigger_id).first == nil).to be_truthy
  end

  it 'should not delete trigger of another device' do
    t = Trigger::Create.(title: 'MyTrigger', key: 'my_trigger', device_id: 2)['model']
    header 'Authorization', "Bearer #{token}"
    delete "/houses/1/devices/1/triggers/#{t.id}"

    expect(last_response.status).to equal(404)
  end

  it 'should not delete device for user with wrong token' do
    header 'Authorization', 'Bearer wrong_token'
    delete "/houses/1/devices/1/triggers/#{trigger.id}"

    expect(last_response.status).to equal(401)
  end

  def token
    'a722658b-0fea-415c-937f-1c1d3c8342fd'
  end

  def trigger
    Trigger::Create.(title: 'MyTrigger', key: 'my_trigger', device_id: 1, output: '[{"key":"temp","type":"int"}]')['model']
  end
end