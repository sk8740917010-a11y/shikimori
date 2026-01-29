# frozen_string_literal: true

# views for topics to be shown in sticky topics forum section:
# all of them belong to offtopic forum
class StickyClubView
  include ShallowAttributes
  extend Translation

  attribute :object, Object
  attribute :title, String
  attribute :description, String

  CLUB_IDS = {
    faq: 1_093,
    content_moderation: 2_052,
    forum_moderation: 917
  }.freeze

  CLUB_IDS.each_key do |club_name|
    define_singleton_method club_name do
      club_id = CLUB_IDS[club_name]
      next unless club_id.present?

      instance_variable_get(:"@#{club_name}") ||
        instance_variable_set(
          :"@#{club_name}",
          new(
            object: clubs[club_id],
            title: club_name(club_id),
            description: description(club_name)
          )
        )
    end
  end

  def self.club_name(club_id)
    clubs[club_id]&.name
  end

  def self.description(club_name)
    i18n_t("#{club_name}.description")
  end

  def self.clubs
    @clubs ||= Hash.new do |cache, club_id|
      # Use find_by to return nil if record is missing, avoiding the 500 error
      club = Club.find_by(id: club_id)
      cache[club_id] = club&.decorate
    end
  end
end