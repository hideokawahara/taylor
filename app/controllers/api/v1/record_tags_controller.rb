module Api
  module V1
    class RecordTagsController < ApplicationController
      before_action :authorize_access_request!, except: [:show, :index]
      before_action :set_record_tag, only: [:show, :update, :destroy]

      # GET /record_tags
      def index
        @record_tags = RecordTag.all

        render json: @record_tags
      end

      # GET /record_tags/1
      def show
        render json: @record_tag
      end

      # POST /record_tags
      def create
        @record_tag = RecordTag.new(record_tag_params)

        if @record_tag.save
          render json: @record_tag, status: :created
        else
          render json: @record_tag.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /record_tags/1
      def update
        if @record_tag.update(record_tag_params)
          render json: @record_tag
        else
          render json: @record_tag.errors, status: :unprocessable_entity
        end
      end

      # DELETE /record_tags/1
      def destroy
        @record_tag.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_record_tag
          @record_tag = RecordTag.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def record_tag_params
          params.require(:record_tag).permit(:name)
        end
    end
  end
end

