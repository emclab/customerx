class AddBriefNoteToCustomerxLeadSources < ActiveRecord::Migration
  def change
    add_column :customerx_lead_sources, :brief_note, :string
  end
end
