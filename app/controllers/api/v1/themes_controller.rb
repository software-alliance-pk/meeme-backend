class Api::V1::ThemesController < Api::V1::ApiController
  include Rails.application.routes.url_helpers
  def index
    @themes = Theme.all
    render json: { message: 'No Themes Present' }, status: :not_found unless @themes.present?
  end

  def get_theme
    @theme = Theme.find_by(title: params[:title])
    render json: { message: 'Theme Not Found' }, status: :not_found unless @theme.present?
  end
end