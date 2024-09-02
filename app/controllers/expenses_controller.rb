class ExpensesController < ApplicationController
  before_action :allow_embedding, only: :index

  def index
    @current_page = params.fetch(:page, '1').to_i
    @expenses = Expense.active.order(date: :desc)

    if params[:search].present?
      @expenses = @expenses.fuzzy_match_description(params[:search])
    end

    @pagy, @expenses = pagy(@expenses)
  end

  private

  def allow_embedding
    response.headers.except! 'X-Frame-Options'
  end
end
