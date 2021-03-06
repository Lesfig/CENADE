class TurnosController < ApplicationController

  before_action :set_turno, only: [:show, :edit, :update, :destroy]
  respond_to :html, :js
  load_and_authorize_resource :turno


  def index
  	 get_turnos
  end

  def new
  	@turno= Turno.new
  end
  def create
  	@turno = Turno.new(turno_params)

  	 respond_to do |format|
      if @turno.save
        format.html { redirect_to turno_path(@turno.id), notice: t('messages.save_success', resource: 'el turno')}
      else
        flash.now[:alert] = t('messages.save_error', resource: 'el turno', errors: @turno.errors.full_messages.to_sentence)
        @turno_nuevo= true
        format.html { render "new"}
        format.js { render "edit"} # //- Creo que debería ser render 'new'
      end
    end
  end

  def edit
    @turno_nuevo= nil
  end

  def update
  	respond_to do |format|
      if @turno.update_attributes(turno_params)
        format.html { redirect_to turno_path, notice: t('messages.update_success', resource: 'el turno')}
      else
        flash.now[:alert] = t('messages.update_error', resource: 'el turno', errors: @turno.errors.full_messages.to_sentence)
        format.html { render "edit"}
        format.js { render "edit"}
      end

    end
  end

  #Busca los turnos segun los datos puestos para filtrar
  def buscar
    @search = Turno.search(params[:q])
    @turnos = @search.result.page(params[:page])
    render 'index'
  end

  def show
    @empleado= Empleado.find(@turno.doctor_id)
  end

  def destroy
    respond_to do |format|
      if @turno.destroy
        format.html { redirect_to turnos_url, notice: t('messages.delete_success', resource: 'el turno')  }
        format.json { head :no_content }
      else
        format.html { redirect_to turnos_url, alert: t('messages.delete_error', resource: 'el turno', errors: @turno.errors.full_messages.to_sentence)  }
        format.json { head :no_content }
      end
    end
  end

  def set_turno
     @turno = Turno.find(params[:id])
  end

  def print_turnos
      @search = Turno.ransack(params[:q])
      @search.sorts = ['fecha_consulta desc','turno asc'] if @search.sorts.empty?
      @turnos= @search.result

      respond_to do |format|
        format.pdf do
          render :pdf => "Lista de Turnos",
                 :template => "turnos/print_turnos.pdf.erb",
                 orientation:  'Landscape',
                 :layout => "pdf.html",
                 footer: {
                    center: '[page] de [topage]',
                    right: "#{Formatter.format_datetime(Time.now)}"
                  }
          end
        end
    end
  #Chequea si el paciente ya no tiene un turno en la fecha y área
   def check_paciente
     turno= Turno.find_by(paciente_id: self.paciente_id, fecha_consulta: self.fecha_consulta, area_id: self.area_id)

      render json: (turno.nil? || turno.id == params[:idd].to_i) ? true : "El paciente ya tiene un turno para el área y fecha".to_json
    end

  #obtiene el paciente
   def get_paciente
    @paciente= Paciente.find(params[:idd])

    authorize! :get_paciente, @paciente

  end

  #recarga la lista de profesionales segun el area
   def recarga_doctores
    @area= Area.find(params[:id_area])

  end

  def update_profesional
    @area= Area.find(params[:id])
    render update_profesional, format: :js
  end

  #Cambie el estado de pendiente a cancelado
  def cambiar_estado

    @turno= Turno.find(params[:id])
    if (@turno.estado== 'pendiente')

      @turno.update_attribute(:estado, params[:nuevo_estado])
      flash.now[:notice] = "Turno N° #{@turno.turno} "+ params[:nuevo_estado]

    else
      flash.now[:alert] = "Turno N° #{@turno.turno} no puede cambiar de estado"
    end
    index
    render 'index'

    end
    def get_turnos
      @search = Turno.ransack(params[:q])
      @search.sorts = ['fecha_consulta desc','turno asc'] if @search.sorts.empty?
      @turnos= @search.result.page(params[:page])
    end

  def turno_params
      params.require(:turno).permit(:paciente_id, :fecha_expedicion, :fecha_consulta,
      	:area_id, :doctor_id, :estado, :monto, :paga, :nro_factura)
  end
end
