class Api::V1::TutorialsController < Api::V1::ApiController
  include Rails.application.routes.url_helpers
  def tutorial
    @tutorials = Tutorial.all.order(:step)
  end
end