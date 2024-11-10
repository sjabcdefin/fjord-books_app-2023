class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :comment, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.references :commentable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
