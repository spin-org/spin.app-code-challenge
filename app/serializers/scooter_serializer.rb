class ScooterSerializer < ActiveModel::Serializer
  attributes :id, :uid, :city_id, :lon, :lat

  def lon
    object.lonlat.longitude
  end

  def lat
    object.lonlat.latitude
  end
end
