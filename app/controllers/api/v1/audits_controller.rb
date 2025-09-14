class Api::V1::AuditsController < Api::V1::ApiController

    def index
        audits = Audit.all
        render json: audits, status: :ok
    end

    def type
        if params[:type] == "Term"
            audits = Term.first
            render json: audits, status: :ok
        elsif (params[:type] == "Privacy")  
            audits = Privacy.first
            render json: audits, status: :ok
        elsif (params[:type] == "Faq")  
            audits = Faq.all
            render json: audits, status: :ok
        else
            render json: { data: null }, status: :ok
        end
    end

  
    def show
        audit = Audit.find(params[:id])
        render json: audit, status: :ok
        rescue ActiveRecord::RecordNotFound
        render json: { error: 'Audit not found' }, status: :not_found
    end
      
  end