result = {}
    object.posts.each do |post|
      next unless post.user
      pronoun = post.user.user_fields&.dig(field_id.to_s)
      result[post.user_id] = pronoun if pronoun.present?
    end
    result
  end

  add_to_serializer(:basic_user, :pronoun_field) do
    return nil unless SiteSetting.pronoun_badge_enabled
    return nil unless SiteSetting.pronoun_badge_user_field_id.present?

    field_id = SiteSetting.pronoun_badge_user_field_id.to_i
    return nil if field_id == 0

    user_field = object.user_fields&.dig(field_id.to_s)
    user_field.presence
  end

  add_to_serializer(:user_card, :pronoun_field) do
    return nil unless SiteSetting.pronoun_badge_enabled
    return nil unless SiteSetting.pronoun_badge_user_field_id.present?

    field_id = SiteSetting.pronoun_badge_user_field_id.to_i
    return nil if field_id == 0

    user_field = object.user_fields&.dig(field_id.to_s)
    user_field.presence
  end
end
