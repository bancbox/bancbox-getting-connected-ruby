class App < Sinatra::Base

  configure do
    BancBox.configure do |config|
      config.username = ENV['BANCBOX_USERNAME']
      config.password = ENV['BANCBOX_PASSWORD']
      config.subscriber_id = ENV['BANCBOX_SUBSCRIBER_ID']
    end
    set :bancbox_api_client, BancBox::Client.new
  end

  get '/' do
    @clients = settings.bancbox_api_client.list_clients[:clients]
    erb :index
  end

  post '/create_client' do
    @result = settings.bancbox_api_client.create_client(params)
    @first_name, @last_name = params[:first_name], params[:last_name]
    @banc_box_id = @result[:client_id][:banc_box_id]
    erb :success
  end

  get '/client/:id' do
    @client = settings.bancbox_api_client.get_client(params[:id])[:client]
    erb :client_details
  end
end
