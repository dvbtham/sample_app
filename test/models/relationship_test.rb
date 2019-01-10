require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: users(:tham).id,
                                     followed_id: users(:archer).id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

  test "should follow and unfollow a user" do
    tham = users :tham
    archer = users :archer
    assert_not tham.following? archer
    tham.follow archer
    assert tham.following? archer
    assert archer.followers.include? tham
    tham.unfollow archer
    assert_not tham.following? archer
  end
end
