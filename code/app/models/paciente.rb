class Paciente < ActiveRecord::Base
	paginates_per 20
	acts_as_paranoid

	# Despues de borrar el registro de paciente, se ejecutan estos métodos
	after_destroy :destroy_persona, :destroy_encargado

	has_many :turnos
	belongs_to :persona
	belongs_to :encargado

	has_one :ficha_fisioterapia_nino
	has_one :ficha_fonoaudiologica
	has_one :ficha_psicopedagogica
	has_one :ficha_fisioterapeutica_adulto
	has_one :ficha_nuticional_pediatrica
	has_one :ficha_nuticional_adulto

	has_many :consultas

	# Permiten guardar persona y encargado en el formulario de paciente
	accepts_nested_attributes_for :persona
	accepts_nested_attributes_for :encargado


	# Se elimina el registro de persona al eliminar el paciente
	def destroy_persona
      persona.destroy
    end

    # Se elimina el registro de encargado al eliminar el paciente
	def destroy_encargado
      if !encargado.blank?
      	# Se setea el campo paciente_id de encargado, para que se sepa a que paciente perteneció
      	encargado.update(paciente_id: id)
      	encargado.destroy
      end
    end

	# Law of Demeter
	delegate :full_name, :nombre, :apellido, :ruc, :edad, :sexo, :ci, :nacionalidad,
			 :fecha_nacimiento, :profesion, :telefono, :direccion, :fecha_ingreso,
			 :estado_civil_descripcion, :lugar_nacimiento,:email,:estado_civil_id,
			 to: :persona, prefix: true, allow_nil: true

	delegate :padre_nombre, :padre_edad, :padre_prof_act_ant, :madre_nombre, :madre_edad,
			 :madre_num_hijos, :madre_prof_act_ant, :encargado_nombre, :encargado_edad,
			 :encargado_prof_act_ant, to: :encargado, prefix: true, allow_nil: true
end
