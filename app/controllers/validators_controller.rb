class ValidatorsController < ApplicationController
  def new; end

  def show
    @report = report_or_document
    @data = data_from_address_state(@report.transaction_id)
    @batch_data = read_from_bloks(head_from_address_state(@report.transaction_id))
  end

  def create
    pdf = params[:validator][:file].read
    hash = Report.calculate_hash(pdf)

    unless Report.exists?(content_hash: hash) || DocumentReport.exists?(content_hash: hash)
      redirect_to new_validator_url,
                  alert: t("report.action.nodatabase")
      return
    end

    certified_by_eschooltul(hash)
  end

  private

  def certified_by_eschooltul(hash)
    if report_or_document_by_hash(hash).transaction_id.blank?
      redirect_to new_validator_url,
                  alert: t("report.action.nocertified")
      return
    end

    check_report_in_blockchain(hash)
  end

  def check_report_in_blockchain(hash)
    response = read_from_blockchain(report_or_document_by_hash(hash).transaction_id)
    if response["sawroom"].nil?
      redirect_to new_validator_url,
                  alert: t("report.action.error")
      return
    end

    certified_or_not(hash, response)
  end

  def certified_or_not(hash, response)
    content_hash = response["sawroom"]["dataToStore"]
    unless report_or_document_by_hash(hash).content_hash?(content_hash)
      redirect_to new_validator_url,
                  alert: t("report.action.nocertified")
      return
    end
    redirect_to validator_url(report_or_document_by_hash(hash).content_hash),
                notice: t("report.action.certified")
  end

  def read_from_blockchain(transaction_id)
    body = { data: { transactionId: transaction_id }, keys: {} }
    HTTParty.post(
      "#{ENV.fetch('ESTOOL_APIROOM_ENDPOINT') { 'https://apiroom.net' }}/api/serveba/sawroom-read",
      body: body.to_json,
      headers: { "Content-Type" => "application/json" }
    )
  end

  def head_from_address_state(transaction_id)
    endpoint_url = HTTParty.get(
      "http://195.201.41.35:8008/state?address=#{transaction_id}"
    )

    endpoint_url["head"]
  end

  def data_from_address_state(transaction_id)
    endpoint_url = HTTParty.get(
      "http://195.201.41.35:8008/state?address=#{transaction_id}"
    )

    Base64.decode64(endpoint_url.dig("data", 0, "data"))
  end

  def read_from_bloks(head)
    HTTParty.get(
      "http://195.201.41.35:8008/blocks/#{head}"
    )
  end

  def report_or_document
    if find_report.nil?
      find_document
    else
      find_report
    end
  end

  def report_or_document_by_hash(hash)
    if find_report_by_hash(hash).nil?
      find_document_by_hash(hash)
    else
      find_report_by_hash(hash)
    end
  end

  def find_report
    Report.find_by(content_hash: params[:content_hash])
  end

  def find_document
    DocumentReport.find_by(content_hash: params[:content_hash])
  end

  def find_report_by_hash(hash)
    Report.find_by(content_hash: hash)
  end

  def find_document_by_hash(hash)
    DocumentReport.find_by(content_hash: hash)
  end
end
