class CreateReportMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :report_mentions do |t|
      t.references :mentioning_report, null: false, foreign_key: { to_table: :reports }, index: false
      t.references :mentioned_report, null: false, foreign_key: { to_table: :reports }, index: false

      t.timestamps
    end
    add_index  :report_mentions, [:mentioning_report_id, :mentioned_report_id], unique: true, name: "index_report_mentions_on_reports"
  end
end
