class ValidatorsController < ApplicationController
  def new; end

  def create
    pdf = params[:validator][:file].read
    hash = Report.calculate_hash(pdf)

    unless Report.exists?(content_hash: hash)
      redirect_to new_validator_url,
                  alert: t("report.action.nodatabase")
      return
    end

    certified_by_eschooltul(hash)
  end

  private

  def certified_by_eschooltul(hash)
    if find_report(hash).transaction_id.blank?
      redirect_to new_validator_url,
                  alert: t("report.action.nocertified")
      return
    end

    check_report_in_blockchain(hash)
  end

  def find_report(hash)
    Report.find_by(content_hash: hash)
  end

  def check_report_in_blockchain(hash)
    response = read_from_blockchain(find_report(hash).transaction_id)
    if response["sawroom"].nil?
      redirect_to new_validator_url,
                  alert: t("report.action.error")
      return
    end

    certified_or_not(hash, response)
  end

  def certified_or_not(hash, response)
    content_hash = response["sawroom"]["dataToStore"]
    unless find_report(hash).content_hash?(content_hash)
      redirect_to new_validator_url,
                  alert: t("report.action.nocertified")
      return
    end
    redirect_to new_validator_url, notice: t("report.action.certified")
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
