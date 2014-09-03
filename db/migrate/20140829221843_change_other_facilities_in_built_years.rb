class ChangeOtherFacilitiesInBuiltYears < ActiveRecord::Migration
  def up
    change_column :built_years, :other_facilities, :text
  end

  # def down
  #   change_column :built_years, :other_facilities, :string
  # end
end
