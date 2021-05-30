module Archivable
	extend ActiveSupport::Concern

	included do 
		scope :archived, -> { where.not(archived_at: nil) }
		scope :unarchived, -> { where(archived_at: nil) }

		def archive!
			update_column(:archived_at, Time.zone.now)
		end

		def unarchive!
			update_column(:archived_at, nil)
		end

		def archived?
			archived_at.present?
		end
	end
end