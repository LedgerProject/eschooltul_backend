class ValidatorsController < ApplicationController
  def new; end

  def create
    pdf = params[:validator][:file].read
    hash = Report.calculate_hash(pdf)

    unless Report.exists?(content_hash: hash)
      redirect_to new_validator_url,
                  alert: "The report is not in the Eschooltul database."
      return
    end

    check_report_in_blockchain(hash)
  end

  private

  def check_report_in_blockchain(hash)
    report = Report.find_by(content_hash: hash)
    response = read_from_blockchain(report.transaction_id)
    content_hash = response["sawroom"]["dataToStore"]

    unless report.content_hash?(content_hash)
      redirect_to new_validator_url,
                  alert: "The report is not certified by Eschooltul."
      return
    end

    redirect_to new_validator_url, notice: "It's certified by Eschooltul."
  end

  def read_from_blockchain(transaction_id)
    body = { "data": { "transactionId": transaction_id }, "keys": {} }
    HTTParty.post(
      "https://apiroom.net/api/serveba/sawroom-read",
      body: body.to_json,
      headers: { "Content-Type" => "application/json" }
    )
  end
end
