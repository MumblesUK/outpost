class ServicesController < ApplicationController
    before_action :no_admins
    before_action :set_service, only: [:edit, :show, :update, :destroy]

    def new
        @service = current_user.organisation.services.new
    end

    def create
        @service = current_user.organisation.services.build(service_params)
        @service.approved = false
        unless @service.save
            render "new"
        end
    end

    def edit
        @stage = params[:stage] || 'Basic Information'
    end

    def show

    end

    def update
        @service.approved = false
        if params[:service].nil? || @service.update(service_params)
            if params[:stage]
                redirect_to edit_service_path(@service, :stage => helpers.next_stage(params[:stage]))
            else
                redirect_to root_path
            end
        else
            render "show"
        end
    end

    def destroy
        @service.archive
        redirect_to organisations_path, notice: "That service has been removed and will no longer be visible."
    end

    private

    def set_service
        @service = current_user.organisation.services.find(params[:id])
    end

    def service_params
        params.require(:service).permit(
          :name,
          :description,
          :url,
          :email,
          :visible_from,
          :visible_to,
          :bccn_member,
          :current_vacancies,
          :pick_up_drop_off_service,
          taxonomy_ids: [],
          local_offer_attributes: [
              :id,
              :description,
              :link,
              :_destroy,
          ],
          cost_options_attributes: [
              :id,
              :option,
              :amount,
              :_destroy,
          ],
          regular_schedules_attributes: [
              :id,
              :opens_at,
              :closes_at,
              :weekday,
              :_destroy,
          ],
          contacts_attributes: [
              :id,
              :name,
              :title,
              :visible,
              :email,
              :_destroy,
              phones_attributes: [
                  :id,
                  :number
              ]
          ],
          locations_attributes: [
              :id,
              :name,
              :address_1,
              :city,
              :postal_code,
              :visible,
              :mask_exact_address,
              # :latitude,
              # :longitude,
              # :google_place_id,
              :_destroy,
              accessibility_ids: []
          ]
        )
      end

end