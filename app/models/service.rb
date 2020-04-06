class Service < ApplicationRecord
  belongs_to :organisation
  has_one :contact
  has_many :service_at_locations
  has_many :locations, through: :service_at_locations

  # watch functionality
  has_many :watches
  has_many :users, through: :watches

  paginates_per 20
  validates_presence_of :name

  include PgSearch::Model
  pg_search_scope :search, 
    against: [:name, :description], 
    using: {
      tsearch: { prefix: true }
    }

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end

end