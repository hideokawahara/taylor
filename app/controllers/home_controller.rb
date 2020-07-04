class HomeController < ApplicationController
  def index
    @record_tags = RecordTag.all
    render json: @record_tags
  end
end