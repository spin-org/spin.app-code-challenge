# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    put '/scooter/:uid/:lon/:lat/:charge_percent',
        to: 'scooter#update',
        format: false,
        defaults: { format: 'JSON' },
        constraints: { lon: %r{[^\/]+},
                       lat: %r{[^\/]+},
                       charge_percent: %r{[^\/]+} }

    get '/active_scooters_near_by/:lon/:lat/:radius_in_mi/:utc_offset',
        to: 'scooter#active',
        format: false,
        defaults: { format: 'JSON' },
        constraints: { lon: %r{[^\/]+},
                       lat: %r{[^\/]+} }

    get '/historical_data/city_id', to: 'scooter#historical_data'

    put '/scooter/:id/take_scooter_offline_for_maintenance',
        to: 'scooter#take_scooter_offline_for_maintenance'
  end
end
