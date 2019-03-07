# frozen_string_literal: true

class Scooter < ApplicationRecord
  belongs_to :city
  has_many :scooter_state_changes
  after_commit :record_state_change, on: :update

  scope :within, lambda { |lon, lat, distance_in_miles|
    unless distance_in_miles.class == Integer
      distance_in_miles = distance_in_miles.to_i
    end
    point = "POINT(#{lon} #{lat})"
    where('ST_Distance(lonlat, ?) < ?',
          point,
          (distance_in_miles * 1609.34))
  }

  scope :active, lambda {
    where('charge_percent >= ? AND under_maintenance = ?', 0.3, false)
  }

  private

  def record_state_change
    if saved_changes?
      saved_changes.transform_values(&:first).each do |k, _v|
        next unless %w[under_maintenance lonlat charge_percent city_id]
                    .include? k

        ScooterStateChange.create(
          scooter_id: id,
          attr_changed: k,
          original_value: send("#{k}_before_last_save"),
          new_value: send(k)
        )
      end
    end
  end
end
