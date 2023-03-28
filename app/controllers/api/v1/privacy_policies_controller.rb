class Api::V1::PrivacyPoliciesController < Api::V1::ApiController
  def privacy
    return render json: { message: 'No Policy is present' }, status: :unprocessable_entity unless Privacy.first.present?

    render json: { privacy: Privacy.first }, status: :ok
  end
end