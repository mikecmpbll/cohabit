ActiveRecord::Schema.define(:version => 1) do
  create_table :yburs, :force => true do |t|
    t.column :joke, :string
    t.column :client_id, :integer
  end

  create_table :clients, :force => true do |t|
    t.column :name, :string
  end
end