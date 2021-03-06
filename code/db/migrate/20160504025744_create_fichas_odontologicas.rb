class CreateFichasOdontologicas < ActiveRecord::Migration
  def change
    create_table :fichas_odontologicas do |t|
      t.integer :paciente_id                  , null: false
      t.integer :area_id                      , null: false
      t.integer :doctor_id                    , null: false
      t.integer :nro_ficha

      t.date :fecha                           , null: false
      t.string :nombre_tutor                  ,default: '' ,limit: Domain::NOMBRE,     null: true
      t.string :tel_tutor                     ,default: '' ,limit: Domain::TELEFONO,   null: true



      t.timestamps null: false
    end

    add_foreign_key(:fichas_odontologicas, :areas, column: 'area_id', on_delete: :restrict)
    add_foreign_key(:fichas_odontologicas, :pacientes, column: 'paciente_id', on_delete: :restrict)
    add_foreign_key(:fichas_odontologicas, :empleados, column: 'doctor_id', on_delete: :restrict)

    add_index :fichas_odontologicas, :paciente_id
    add_index :fichas_odontologicas, :area_id
    add_index :fichas_odontologicas, :doctor_id
  end
end
