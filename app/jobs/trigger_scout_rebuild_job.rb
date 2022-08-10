class TriggerScoutRebuildJob < ApplicationJob
    queue_as :default
  
    def perform()
        if ENV["SCOUT_BUILD_HOOK"].present?
            HTTParty.post(ENV["SCOUT_BUILD_HOOK"])
        end
    end
end