require 'csv'

class UrlProvider < ApplicationRecord    
    validates :name, presence: true

    def self.to_csv
        attributes = %w{id name active links_shortened_amount}

        CSV.generate(headers: true) do |csv|
            csv << attributes

            all.each do |url_provider|
                csv << attributes.map{ |attr| url_provider.send(attr) }
            end
        end
    end
end
