# frozen_string_literal: true

module Api
  class ScooterController < ApplicationController
    before_action :set_scooter, only: [:update]
    def update
      unless @scooter
        render json: { error: 'scooter_not_found' }
        return
      end
      @scooter.update(
        lonlat: "POINT(#{params[:lon]} #{params[:lat]})",
        charge_percent: params[:charge_percent]
      )
      render json: ScooterSerializer.new(@scooter).to_json
    end

    def active
      client_time = Time.now.getlocal(active_scooters_params[:utc_offset])
      unless (9..17).cover?(client_time.hour)
        render json: [].to_json
        return
      end
      scooters = Scooter.within(active_scooters_params[:lon],
                                active_scooters_params[:lat],
                                active_scooters_params[:radius_in_mi])
                        .active()
      render json: scooters, each_serializer: ScooterSerializer
    end

    def historical_data
      ids = Scooter.where(city_id:params[:city_id]).pluck(:id)
      render json: ScooterStateChange.where(scooter_id: ids)
    end

    def take_scooter_offline_for_maintenance
      render json: Scooter.find(params[:id]).update(under_maintenance: true)
    end

    private

    def set_scooter
      @scooter = Scooter.where(uid: params[:uid]).last
    end

    def active_scooters_params
      params.permit(:lon, :lat, :radius_in_mi, :utc_offset)
    end
  end
end
