////////////////////////////////////////////////
// File upload management
////////////////////////////////////////////////

jQuery(function($){
	
	$('#select_file_icon')
	.css({position:'relative'})
	.prepend('<span id="select_file_swf" style="position:absolute; top:0; left:0; overflow:hidden;" />')
	.bind('fileUploadSelected', upload_select_file)
	.bind('fileUploadStarted',  upload_start)
	.bind('fileUploadProgress', upload_track_progress)
	.bind('fileUploadComplete', upload_complete)
	.bind('fileUploadError', 	upload_error);
	
	var swf_options = {
		src: 				"/javascripts/uploader.swf", 
		width:  			$('#select_file_icon').width(), 
		height: 			$('#select_file_icon').height(),
		wmode:  		    "transparent",
		allowscriptaccess:  'always'
	};
	
	var swf_data   = {}	
	var swf_object = $('#select_file_swf').flashembed(swf_options, swf_data);
	
	$('form[data-remote-uploadable]').live('submit', function(e){
		var options		= {};
		jQuery.each($(this).serializeArray(), function(i, field){
			if(field.name == 's3_policy_file' || field.name == 'upload_path') options[field.name] = field.value;
		});
		swf_object.startFileUpload(options);
        e.preventDefault();
    });	
	
});

function upload_complete(e, file_info){
	$('#upload_progress_tracker').overlay().close();
}

function upload_error(e, file_info){
	
}

function upload_select_file(e, file_info){
	$('input[data-uploadable-display]').val(file_info.name);
}

function upload_start(e, file_info){
	$('#upload_progress_tracker').overlay({ closeOnClick:false, closeOnEsc:false });
}

function upload_track_progress(e, file_info){
	
}