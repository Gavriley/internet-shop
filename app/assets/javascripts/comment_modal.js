$('#comments_list').click(function(event){
	action = $(event.target);

	if(action.attr('id') == 'edit_comment') {
		// console.log($('#comment_content_' + action.attr('value')).html());
		$("#info_modal_block").html('');
		$('#update_comment_form').attr('action', action.attr('href'));
		$('#comment_modal_content').val($('#comment_content_' + action.attr('value')).html());
		$('#comment_modal_block').css("display","block");
		event.preventDefault();
	}
});

$('#close').on('click', function(event) {
	$('#comment_modal_block').css("display","none");
	event.preventDefault();
});

$(window).click(function(event) {
	if(event.target.id == 'comment_modal_block') {
		$('#comment_modal_block').css("display","none");
	}
});