# This migration comes from authentify (originally 20130630134336)
class CreateAuthentifySearchStatConfigs < ActiveRecord::Migration
  def change
    create_table :authentify_search_stat_configs do |t|
      t.string :resource_name
      t.text :stat_function
      t.text :labels_and_fields
      t.string :search_results_url
      t.text :search_where
      t.boolean :include_stats
      t.text :search_results_period_limit
      t.integer :last_updated_by_id

      t.timestamps
    end
    
    add_index :authentify_search_stat_configs, :resource_name
    add_index :authentify_search_stat_configs, :search_results_url
  end
end
