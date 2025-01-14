# frozen_string_literal: true

module Spree
  class Taxonomy < ApplicationRecord
    validates :name, presence: true

    has_many :taxons
    has_one :root, -> { where parent_id: nil }, class_name: "Spree::Taxon", dependent: :destroy

    after_save :set_name

    default_scope -> { order("#{table_name}.position") }

    private

    def set_name
      if root
        root.update_columns(
          name:,
          updated_at: Time.zone.now
        )
      else
        self.root = Taxon.create!(taxonomy_id: id, name:)
      end
    end
  end
end
