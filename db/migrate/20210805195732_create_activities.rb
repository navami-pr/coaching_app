class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      t.string :name, :null => false
      t.references :course, null: false, index: true

      t.timestamps
    end
  end
end
