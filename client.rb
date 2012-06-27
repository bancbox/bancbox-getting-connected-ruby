# This file includes a sample client implementation
# which encapsulates SOAP calls to BancBox.
# Currently 3 method calls are provided: Creating a client, getting a client's details
# and searching for client information

require 'savon'

module BancBox

  # Configuration options for the client
  # Set wsdl_endpoint to production url when rady to move from testing
  class << self
    attr_accessor :username, :password, :subscriber_id
    attr_writer :wsdl_endpoint

    def wsdl_endpoint
      @wsdl_endopint ||= "https://sandbox-api.bancbox.com/BBXPort?wsdl"
    end

    def configure
      yield(self)
    end

  end

  # Main client providing the sample functionalities.
  class Client

    # Setup the SAOP client with credentials
    def initialize
      @soap_client = Savon::Client.new do
        wsdl.document = BancBox.wsdl_endpoint
        wsse.credentials(BancBox.username, BancBox.password)
      end
    end

    # Create a client on BancBox
    # See http://www.bancbox.com/api/view/2 for details
    def create_client(params = {})
      resp = setup_client(:create_client) do |soap|
        soap.body do |xml|
          xml.createClientRequest do |xml|
            xml.subscriberId BancBox.subscriber_id
            xml.firstName params[:first_name]
            xml.lastName params[:last_name]
            xml.ssn params[:ssn]
            xml.dob params[:dob]
            xml.address do |xml|
              xml.line1 params[:address_line_1]
              xml.line2 params[:address_line_2]
              xml.city params[:city]
              xml.state params[:state]
              xml.zipcode params[:zipcode]
            end
            xml.homePhone params[:home_phone]
            xml.email params[:email]
          end
        end
      end.to_hash
      return resp[:create_client_response][:return]
    end

    # Search all previously created clients
    # See http://www.bancbox.com/api/view/8 for details
    def list_clients
      resp = setup_client(:search_clients) do |soap|
        soap.body do |xml|
          xml.searchClientRequest do |xml|
            xml.subscriberId BancBox.subscriber_id
          end
        end
      end.to_hash
      return resp[:search_clients_response][:return]
    end

    # Get a created client's details
    # See http://www.bancbox.com/api/view/8 for details
    def get_client(bancbox_id = nil, ref_id = nil)
      resp = setup_client(:get_client) do |soap|
        soap.body do |xml|
          xml.getClientRequest do |xml|
            xml.subscriberId BancBox.subscriber_id
            xml.clientId do |xml|
              xml.bancBoxId bancbox_id
              xml.subscriberReferenceId ref_id
            end
          end
        end
      end.to_hash
      return resp[:get_client_response][:return]
    end

    private

    # Setup the SOAP client for common options
    # to be passed with every request
    def setup_client(method_name)
      @soap_client.request :sch, method_name do
        soap.env_namespace = :soapenv
        soap.namespaces["xmlns:soapenv"] = "http://schemas.xmlsoap.org/soap/envelope/"
        yield(soap)
      end
    end

  end

end
