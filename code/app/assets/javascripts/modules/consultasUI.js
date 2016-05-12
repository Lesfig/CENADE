var consultasUI = (function(){
	return {

		init: function(){
			$('body').on('click', '.show-consulta', function(e){
				$.get($(this).parents('tr').data('url'), {}, function(){}, 'script');
			});
		},

    initConsultasTab: function(){
      var tabs;
      jQuery(function($) {
        tabs = $('.tabscontent').tabbedContent({loop: true}).data('api');


                // Next and prev actions
                $('.controls a').on('click', function(e) {
                  var action = $(this).attr('href').replace('#', '');
                  tabs[action]();
                  e.preventDefault();
                });
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

    selectControl: function(){
      $(".paciente_select").select2({
        placeholder: "Seleccione un paciente",
        language: "es",
        theme: "bootstrap"

      }).on("select2:select",function(){
        $(this).valid();
        id = $(this).val();

        $.ajax({

          url: "/consultas/get_paciente",
          type: 'get',
          data: {
           id : $(this).val()
         },
         success: function(resp){
                      //alert("Data");
                    }

                  });
      });
      $(".profesional_select2").select2({
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
        id = $(this).val();

        $.ajax({

          url: "/consultas/recarga_profesional",
          type: 'get',
          data: {
           id : $(this).val()
         },
         success: function(resp){
                          //alert("Data");
                        }

                      });
      });

    },

		// Inicia el script en el formulario
		initScript: function(){
			consultasUI.selectControl();
      consultasUI.advancedSearchControl();

      $('.datepicker').datepicker({
        format: "dd/mm/yyyy",
        language: "es",
        autoclose: true,
        orientation: "bottom",
        theme: "bootstrap"
      }).on('change', function() {
       $(this).valid();
     });

		   	//Valida el formulario antes de enviarlo
       $('.nueva-consulta').last().validate();
     }
   };
 }());

$(function(){
	consultasUI.init();
});