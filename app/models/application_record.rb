class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.ransackable_attributes(auth_object = nil)
		column_names.map(&:to_sym).map(&:to_s)
	end


	def self.ransackable_associations(auth_object = nil)
		reflect_on_all_associations.map { |a| a.name.to_s }
	end
end
