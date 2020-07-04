require 'test_helper'

class RecordTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @record_tag = record_tags(:one)
  end

  test "should get index" do
    get record_tags_url, as: :json
    assert_response :success
  end

  test "should create record_tag" do
    assert_difference('RecordTag.count') do
      post record_tags_url, params: { record_tag: { name: @record_tag.name, user_id: @record_tag.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show record_tag" do
    get record_tag_url(@record_tag), as: :json
    assert_response :success
  end

  test "should update record_tag" do
    patch record_tag_url(@record_tag), params: { record_tag: { name: @record_tag.name, user_id: @record_tag.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy record_tag" do
    assert_difference('RecordTag.count', -1) do
      delete record_tag_url(@record_tag), as: :json
    end

    assert_response 204
  end
end
