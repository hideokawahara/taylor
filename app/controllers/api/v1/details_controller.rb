module Api
  module V1
    class DetailsController < ApplicationController
      before_action :authorize_access_request!
      before_action :set_detail, only: [:show, :update, :destroy]

      # GET /details
      def index
        @details = current_user.details.all

        render json: @details
      end

      # GET /details/1
      def show
        render json: @detail
      end

      # POST /details
      def create
        @detail = current_user.details.build(detail_params)

        if @detail.save
          render json: @detail, status: :created
        else
          render json: @detail.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /details/1
      def update
        if @detail.update(detail_params)
          render json: @detail
        else
          render json: @detail.errors, status: :unprocessable_entity
        end
      end

      # DELETE /details/1
      def destroy
        @detail.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_detail
          @detail = current_user.details.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def detail_params
          params.require(:detail).permit(:title, :year, :record_tag_id)
        end
    end
  end
end
