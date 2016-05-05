class FichasNutricionalesPediatricasController < ApplicationController

  before_action :set_submenu, only: [:edit, :new, :show, :index, :create, :update]
  before_action :set_sidebar, only: [:edit, :new, :show, :index, :create, :update]
  before_action :set_ficha_nutri_pediatrica, only: [:show, :edit, :update, :destroy]
  before_action :set_Titulo, only: [:show, :create, :update, :edit, :new]

  def set_submenu
  	@submenu_layout = 'layouts/submenu_fichas_consultas'
  end

  def set_Titulo
    @titulos_largos= TituloLargo.all
  end

  def set_sidebar
   	@sidebar_layout = 'layouts/sidebar_fichas'
  end

  def index
  	@search = FichaNutricionalPediatrica.ransack(params[:q])
    @nutri_pediatricas= @search.result.page(params[:page])
  end

  def new
  	@nutri_pediatrica= FichaNutricionalPediatrica.new
    # Para renderizar un formulario vacio de datos del paciente
    @paciente = Paciente.new
  	get_doctores_nutricion

  end

  def create
  	@nutri_pediatrica = FichaNutricionalPediatrica.new(nutri_pediatrica_params)
    @paciente= Paciente.find(@nutri_pediatrica.paciente_id) 
  	 respond_to do |format|
      if @nutri_pediatrica.save
        flash.now[:notice] = 'Ficha registrada exitosamente'
		    format.html {render 'show'}
        format.js { render "show"}
      else
        if @nutri_pediatrica.errors.full_messages.any?
          flash.now[:alert] = @nutri_pediatrica.errors.full_messages.first
        else
          flash.now[:alert] = "No se ha podido guardar la Ficha"
        end
        
        format.html { render "edit"}
        format.js { render "edit"}

      end
    end
  end

  def edit
  end

  def update
    
  	respond_to do |format|
      if @nutri_pediatrica.update_attributes(nutri_pediatrica_params)
	    flash.now[:notice] = 'Ficha actualizada exitosamente'
    		format.html {render 'show'}
    	    format.js { render "show"}
      else
        
        if @nutri_pediatrica.errors.full_messages.any?
          flash.now[:alert] = @nutri_pediatrica.errors.full_messages.first
        else
          flash.now[:alert] = "No se ha podido guardar la Ficha"
        end
        format.html { render action: "edit"}
        format.js { render action: "edit"}
      end
    end
  end

  def show
    
  end

  def get_doctores_nutricion
	@area = Area.find_by_nombre('Nutrición')
	@doctores = Doctor.where(area_id: @area.id)
  end

  #busca el paciente seleccionado en la base de datos
  def get_paciente
    @paciente= Paciente.find(params[:id])    
  end
 
  #metodo creado para el filtro
  def buscar
    @search = FichaNutricionalPediatrica.search(params[:q])
    @nutri_pediatricas = @search.result.page(params[:page])
    render 'index'
  end

  def set_ficha_nutri_pediatrica
  	@nutri_pediatrica= FichaNutricionalPediatrica.find(params[:id])
    @paciente= Paciente.find(@nutri_pediatrica.paciente_id) 
  end

  def nutri_pediatrica_params
  	params.require(:ficha_nutricional_pediatrica).permit(:area_id, :paciente_id, :profesional_salud_id, :fecha, :nro_ficha, 
  		 :problema_embarazo,:control_prenatal,:alimentacion_embarazo,:otros_datos,:parto_vaginal_cesarea, :termino_pretermino, 
  		 :lugar_parto,:como_fue_parto, :peso_nacimiento, :asfixia_lloro, :tomo_pecho, :alimentacion_complementaria)
  end
end
