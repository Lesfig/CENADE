class FichaFisioterapiaNinosController < ApplicationController
	before_action :set_submenu, only: [:edit, :new, :show, :index]
	before_action :set_sidebar, only: [:edit, :new, :show, :index]
  	before_action :set_fisionino, only: [:show, :edit, :update, :destroy]

  def set_submenu
   @submenu_layout = 'layouts/submenu_fichas_consultas'
  end

  def set_sidebar
   @sidebar_layout = 'layouts/sidebar_fichas'
  end

  def index
  	@search = FichaFisioterapiaNino.ransack(params[:q])
    @fisio_ninos= @search.result.page(params[:page])
  end

  def new
  	@fisio_nino= FichaFisioterapiaNino.new
  end

   def create
  	@fisio_nino = FichaFisioterapiaNino.new(fisio_nino_params)

  	 respond_to do |format|
      if @fisio_nino.save
        flash.now[:notice] = 'Ficha registrada exitosamente'
		    format.html {render 'show'}
      else
        flash.now[:alert] = "No se ha podido guardar la Ficha"
        format.html { render "new"}
        format.js { render "new"}
      end
    end
  end

  def edit

  end

  def update
  	respond_to do |format|
      if @fisio_nino.update_attributes(fisio_nino_params)

        format.html { redirect_to ficha_fisioterapia_nino_path, notice: 'Ficha actualizado exitosamente'}
      else
        
        flash.now[:alert] = 'No se pudo crear la Ficha'
        format.html { render action: "edit"}
        format.js { render action: "edit"}
      end
      
    end
  end

  def show

  end
  
  #busca el paciente seleccionado en la base de datos
  def get_paciente
    @paciente= Paciente.find(params[:id])
      
  end

  #metodo creado para el filtro
  def buscar
    @search = FichaFisioterapiaNino.search(params[:q])
    @fisio_ninos = @search.result.page(params[:page])
    render 'index'
  end

  def set_fisionino
  	@fisio_nino= FichaFisioterapiaNino.find(params[:id])
  end 

  def fisio_nino_params
  	params.require(:ficha_fisioterapia_nino).permit(:area_id, :paciente_id, :doctor_id, :control_embarazo, :edad_gestacional,
     				:tipo_parto, :peso_nacer, :apgar, :antecedentes_familiares, :condicion_general,:fecha, :nro_ficha)
  end 
end