add_selected_element = function(object, method) {
	selected_option = $('#' + method + ' :selected');
	placeholder_element_id = method + "s"
	placeholder = $('#' + placeholder_element_id);
	
	hidden_field = "<input type='hidden' name='" + object + "["+ placeholder_element_id +"][]' value='" + selected_option.val() + "' />";
	text = selected_option.text();
	remove_link = "<a href='#' onclick= '$(this).parent(\"div\").remove(); return false;' class='form-button right'>Remove</a>";
	
	element_html = text + hidden_field + remove_link
	placeholder.append("<div>"+  element_html + "</div>");
}

register_event_clicktips = function() {
	$(".event-clicktip").each(function(){
	event_id_url= this.id
	 $(this).qtip({
		   content: {
		      url: event_id_url
			},
			style: {
				padding: 5,
				width: 500
			}
		});	
	})
	
	$(".unscheduled-event-clicktip").each(function(){
		$(this).qtip({
			content: "Recruitment step not scheduled",
			style: {width: 210}
		})
	})
};