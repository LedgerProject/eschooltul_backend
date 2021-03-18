class ValidatorsController < ApplicationController

    def new
    end

    def create
        pdf = params[:validator][:file].read
        hash = Digest::SHA256.hexdigest(Base64.encode64(pdf)
        if Report.exists?(content_hash: hash))
            flash.notice = "It's in the Eschooltul database."
            transaction_id = Report.find_by(content_hash: hash).transaction_id
        else
            flash.alert = "The report is not certificate by Eschooltul."
        end
        redirect_to new_validator_url
    end

    def validates_report(transaction_id)
    
        response = HTTParty.post(
          "https://apiroom.net/api/serveba/sawroom-write",
          body: {
              transactionId: transaction_id
          }
        )
    end

end
