# frozen_string_literal: true

# name: discourse-pronoun-badge
# about: Exibe pronomes ao lado do nome do usuário com suporte a emoji e borda estilizada
# version: 1.0.0
# authors: xx
# url: https://github.com/xhyeops/discourse-pronoun-badge
# required_version: 2.7.0

enabled_site_setting :pronoun_badge_enabled

register_asset "stylesheets/pronoun-badge.scss"

after_initialize do
  # Serializer para incluir o campo de pronome nos dados do usuário
  add_to_serializer(:user, :pronoun_field) do
    return nil unless SiteSetting.pronoun_badge_enabled
    return nil unless SiteSetting.pronoun_badge_user_field_id.present?

    field_id = SiteSetting.pronoun_badge_user_field_id.to_i
    return nil if field_id == 0

    user_field = object.user_fields&.dig(field_id.to_s)
    user_field.presence
  end

  add_to_serializer(:post, :user_pronoun_field) do
    return nil unless SiteSetting.pronoun_badge_enabled
    return nil unless SiteSetting.pronoun_badge_user_field_id.present?

    field_id = SiteSetting.pronoun_badge_user_field_id.to_i
    return nil if field_id == 0

    user_field = object.user&.user_fields&.dig(field_id.to_s)
    user_field.presence
  end

  add_to_serializer(:topic_view, :pronoun_fields) do
    return {} unless SiteSetting.pronoun_badge_enabled
    return {} unless SiteSetting.pronoun_badge_user_field_id.present?

    field_id = SiteSetting.pronoun_badge_user_field_id.to_i
    return {} if field_id == 0

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
