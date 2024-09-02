class Expense < ApplicationRecord
  require 'httparty'

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :fuzzy_match_description, ->(search) { where("description ILIKE ?", "%#{search}%") }

  def self.sync_with_splitwise!
    api_key = ENV["SPLITWISE_API_KEY"]
    raise "SPLITWISE_API_KEY environment variable not set" unless api_key.present?

    query_params = { "limit" => "1000000" } # Gets all expenses from Splitwise API in one request. We should probably refactor to use pagination.
    headers = { "Authorization" => "Bearer #{api_key}" }
    response = HTTParty.get("https://secure.splitwise.com/api/v3.0/get_expenses", headers: headers, query: query_params)

    if response.success?
      json_response = response.parsed_response
      expense_hashes =  json_response["expenses"]
      expense_hashes.each do |expense_hash|
        expense = self.find_or_initialize_by(splitwise_id: expense_hash["id"])
        expense.update!(date: Date.parse(expense_hash["date"]), description: expense_hash["description"], amount: expense_hash["cost"].to_f, deleted_at: expense_hash["deleted_at"])
      end
    else
      raise "Failed to retrieve expenses from Splitwise API. Status: #{response.code}. \nBody: #{response.body}"
    end
  end
end
