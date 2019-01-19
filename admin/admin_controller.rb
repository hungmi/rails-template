class AdminController < ApplicationController
	layout "admin"
	rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
	include Pagy::Backend

	private
		def handle_record_not_found
      respond_to do |format|
        format.js { render "admin/common/record_not_found", status: 404 }
      end
    end
end