/*

This validation add-on integrates Fluffery with jQuery Tools and allows for the wrapping of fields
in the same manner as the gem does.

*/
$.tools.validator.addEffect("fluffery",
 
	// Called when errors are to be showed.
	function(errors, event) {
		$.each(errors, function(index, error) {
			var field_with_error = error.input;
			// array of error messages.
			var errors = error.messages;
		});

	}, 
	
	// Called when errors are to be hidden.
	function(inputs){
	
	}
);