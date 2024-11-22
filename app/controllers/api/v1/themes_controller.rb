class Api::V1::ThemesController < Api::V1::ApiController
  def index
    @themes = Theme.all
    render json: { message: 'No Themes Present' }, status: :not_found unless @themes.present?
  end

  def set_theme
    @theme = Theme.find_by(ref: params[:ref])
    render json: { message: 'Theme Not Found' }, status: :not_found unless @theme.present?
  end
end