var fonoaudiologicasUI = (function(){
	return {		
		checkPACIENTE: function(checkFonoaudiologicaPacienteUrl){
      $.validator.addClassRules({
          uniquePACIENTE: {
              remote: {
                  url: checkFonoaudiologicaPacienteUrl,
                  type: "get",
                  data: {
                      paciente_id: function() {
                          return $( "#paciente_id" ).val();
                      },
                      id: function() {
                          return $('#fonoaudiologica_id').val();
                      }
                  }
              }
          }
      });
    },

        advancedSearchControl: function(){
          $(".to-hide").hide();

             $(document).ready(function(){
              var show=true;
              $("#show").click(function(){
               if(show){
                  $("#advanced-search").show();
                  show=false;
               }else{
                  $("#advanced-search").hide();
                  show=true;
               }

            });
          });
        },

		initScript: function(checkFichaFonoaudiologicaPacienteUrl){
			fonoaudiologicasUI.checkPACIENTE(checkFichaFonoaudiologicaPacienteUrl);
      fonoaudiologicasUI.advancedSearchControl();
            
            $(".paciente_select").select2({
                placeholder: "Seleccione un paciente",
                language: "es",
                theme: "bootstrap"

                }).on("select2:select",function(){
                $(this).valid();
                id = $(this).val();

                $.ajax({
                 
                  url: "/fichas_fonoaudiologicas/get_paciente",
                  type: 'get',
                  data: {
                   paciente_id : $(this).val()
                  },
                  success: function(resp){
                      //alert("Data");
                   }
                  
                 });
              });
              $(".profesional_select").select2({
                placeholder: "Seleccione un Profesional",
                language: "es",
                theme: "bootstrap"

                }).on('change', function () {
                    $(this).valid();
                });
            $(".area_select").select2({
                placeholder: "Seleccione un Área",
                theme: "bootstrap",
                language: "es"

                }).on('change', function () {
                    $(this).valid();
                });

            $('.datepicker').datepicker({
                format: "dd/mm/yyyy",
                language: "es",
                autoclose: true,
                orientation: "bottom"
                }).on('change', function() {
                    $(this).valid();
                });
		   	//Valida el formulario antes de enviarlo
		  	$('.nueva-ficha').validate();
		}
	};
}()); 