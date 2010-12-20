////////////////////////////////////////////////
// Form validation
////////////////////////////////////////////////

jQuery(function($){
	$('form[data-js-validatable]').validator({errorInputEvent:'blur', inputEvent:'blur', effect:'fluffery'});
});

$.tools.validator.addEffect("fluffery",
 
	// Called when errors are to be showed.
	function(errors, event) {
		$.each(errors, function(index, error) {
			var field_with_error = error.input;
			// array of error messages.
			var errors = error.messages;
			if(!$(field_with_error).parent('span.field_with_errors').get(0)){
				$(field_with_error).wrap("<span class='field_with_errors'></span>");
				$(field_with_error).after($("<span class='error_for_field' />").text(errors.join(", ")));
			}
		});

	}, 
	
	// Called when errors are to be hidden.
	function(inputs){
		$(inputs).each(function(ind, el){
			if($(this).parent('span.field_with_errors').get(0)) $(this).unwrap();			
			$(this).next('span.error_for_field').remove();			
		});
	}
);