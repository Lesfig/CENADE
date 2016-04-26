class FichaFisioterapiaNino < ActiveRecord::Base
	paginates_per 20
	validates :condicion_general , length: { maximum: 700, message: ' soporta un máximo 700 caracteres' }
	belongs_to :paciente
	belongs_to :doctor, :foreign_key => :doctor_id
	before_create :cargar_area_id

	before_create :actualizar_nro

	def actualizar_nro
      ficha = FichaFisioterapiaNino.last
      if ficha.nil? 
        self.nro_ficha = 1
      end
      if ficha.nro_ficha.nil?
      	self.nro_ficha = 1
      else
        ficha_nro = ficha.nro_ficha
        self.nro_ficha = ficha_nro+1
      end
    end

	def cargar_area_id
		area= Area.where(nombre: 'Fisioterapia').first.id
		self.area_id= area
	end

	def validate_paciente 
		paciente= FichaFisioterapiaNino.where("paciente_id = ?", self.paciente_id)
		if !paciente.empty?
			errors.add(:base, "El paciente ya posee una Ficha en el Fisioterapia Niño")
		end
	end

end