class HistorialesOdontologicosController < ApplicationController
  before_action :set_submenu, only: [:show, :index ]
  before_action :set_sidebar, only: [:show, :index]
  before_action :set_historial, only: [:show, :print]

  def set_submenu
    @submenu_layout = 'layouts/submenu_fichas_consultas'
  end

  def set_sidebar
    @sidebar_layout = 'layouts/sidebar_historiales'
  end

  def index
    get_pacientes
  end

  def show
  end

  # Obtiene los pacientes con ficha de odontología
  def get_pacientes
    @search = Paciente.ransack(params[:q])
    @pacientes = @search.result
                        .includes(:persona) # para que order por nombre de persona funcione
                        .joins(:ficha_odontologica)
                        .order('personas.nombre')
                        .page(params[:page]) # Usa paginates_per del modelo paciente
  end

  # Para el historial se requiere, los datos del paciente, su ficha y consultas
  # en el área de Odontología.
  # Si un paciente tiene consultas hechas pero no tiene ficha, no se mostrará su historial
  def set_historial
    @paciente  = Paciente.find(params[:id])
    @ficha = @paciente.ficha_odontologica
    @consultas = ConsultaOdontologica.where(ficha_odontologica_id: @ficha.blank? ? nil : @ficha.id).order(fecha: :desc)
  end

  def print
    respond_to do |format|
        format.pdf do
          render pdf:  'Historial de Paciente (Odontología)',
          template:    'historiales_odontologicos/print.pdf.erb',
          layout:      'pdf.html',
          title:       'Historial de Paciente (Odontología)',
          page_height: '13in', #33cm   Oficio
          page_width:  '8.5in',#21.6cm Oficio
          footer: {
            center: '[page] de [topage]',
            right: "#{Formatter.format_datetime(Time.now)}",
            left: "CI Nº: #{@paciente.persona_ci}"
          }
        end
      end
    end
end