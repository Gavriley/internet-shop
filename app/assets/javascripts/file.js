function readURL(input) {

  if (input.files && input.files[0]) {
    var reader =  new FileReader();

    reader.onload = function (e) {
    	$('#file_container').attr('src', e.target.result);
    	$('#file_container').css("display","block");
    }

    reader.readAsDataURL(input.files[0]);
  }
}

$(document).ready(function() {  
	$("#file").change(function() {
	  $("#clear").css("display","block");
	  $("#raper_file").css("display","none");
	  if($("#drop_file")) $("#drop_file").remove();
	  readURL(this);
	});

	$("#clear").click(function (e) {
    $("#file_container").css("display","none");
    $("#file").val("");
    $("#raper_file").css("display","block");
    $("#clear").css("display","none");
    $("#file_block").append("<input type='hidden' name='drop_file' id='drop_file'>");
    e.preventDefault();
  });
});