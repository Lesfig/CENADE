class Paciente < ActiveRecord::Base
	paginates_per 20
	acts_as_paranoid

	# Despues de borrar el registro de paciente, se ejecutan estos métodos
	after_destroy :destroy_persona, :destroy_encargado	

	has_many :turnos
	belongs_to :persona
	belongs_to :encargado
	has_one :ficha_fisioterapia_nino

	has_one :ficha_fisioterapeutica_adulto
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

	ransack_alias :persona, :persona_nombre_or_persona_apellido_or_persona_ci
	#ransack_alias :paciente, :paciente_persona_ci_or_paciente_persona_nombre_or_paciente_persona_apellido_cont	

	# Retorna el nombre y apellido del paciente, usado en /pacientes/buscar
	def full_name
  		"#{persona.nombre} #{persona.apellido}"
	end

	# Retorna el ci del paciente, usado en /pacientes/buscar
	def ci
		"#{persona.ci}"
	end	
end
