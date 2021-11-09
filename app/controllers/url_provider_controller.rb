require 'net/http'
require "uri"

class UrlProviderController < ApplicationController

    def index
        @url_providers = UrlProvider.all
    end

    def update
        # UNDER CONSTRUCTION
        @url_provider = UrlProvider.find(params[:id])
        if @url_provider.update(params)
            puts @url_provider
        else
            puts "DID NOT SAVED"
        end
    end

    def shorten
        if !params[:url].present?
            return render json: { error: "Url parameter is required" }, status: 400
        end

        provider = params[:provider].present? ? params[:provider] : 'bit.ly' 

        if provider == 'bit.ly'
            headers = {
                'Content-Type' => 'application/json',
                'Authorization' => "Bearer #{ENV['BITLY_TOKEN']}",
            }
            
            body = {
                'long_url' => params[:url],
                'group_guid' => ENV['BITLY_GROUP_GUID'],
                'domain' => ENV['BITLY_DOMAIN']
            }
            
            response = request_sender('https://api-ssl.bitly.com/v4/shorten', headers, body)
            
            if response.kind_of? Net::HTTPSuccess
                provider = UrlProvider.where(name: 'bit.ly')[0]
                provider.update(links_shortened_amount: provider.links_shortened_amount+1 )

                shortened_url = JSON.parse(response.body)["link"]
                return render json: { shortened_url: shortened_url }, status: 200
            else
                return render json: { error: "Problem with external service" }, status: 503
            end
        elsif provider == 'tinyurl.com'
            headers = {
                'Content-Type' => 'application/json',
                'Authorization' => "Bearer #{ENV['TINYURL_TOKEN']}",
            }
            
            body = {
                'url' => params[:url],
                'domain' => ENV['TINYURL_DOMAIN']
            }
            
            response = request_sender('https://api.tinyurl.com/create', headers, body)
            
            if response.kind_of? Net::HTTPSuccess
                provider = UrlProvider.where(name: 'tinyurl.com')[0]
                provider.update(links_shortened_amount: provider.links_shortened_amount+1 )
                
                shortened_url = JSON.parse(response.body)["data"]["tiny_url"]
                return render json: { shortened_url: shortened_url }, status: 200
            else
                return render json: { error: "Problem with external service" }, status: 503
            end
        end
    end

    def export_to_csv 
        @url_providers = UrlProvider.all
        respond_to do |format|
          format.html
          format.csv { send_data @url_providers.to_csv, filename: "providers.csv" }
        end
    end

    def request_sender(uri, headers, body)
        uri = URI(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.path, headers)
        request.body = body.to_json
        response = http.request(request)

        puts response.body

        return response
    end
end
