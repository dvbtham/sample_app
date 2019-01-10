module RelationshipsHelper
  def relationship user
    @relationship = current_user.active_relationships
                                .find_by followed_id: user.id
    @relationship ||= current_user.active_relationships.build
  end
end
