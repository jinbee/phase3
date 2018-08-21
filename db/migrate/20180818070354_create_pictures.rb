class CreatePictures < ActiveRecord::Migration[5.1]
  def change
    create_table :pictures do |t|
      t.string :image
      t.string :title
      t.references :user, foreign_key: true
      t.text :comment
      t.timestamps
    end
  end
end
