add_selected_element = function(object, method) {
	selected_option = $('#' + method + ' :selected');
	placeholder_element_id = method + "s"
	placeholder = $('#' + placeholder_element_id);
	hidden_field = "<input type='hidden' name='" + object + "["+ placeholder_element_id +"][]' value='" + selected_option.val() + "' />";
	text = selected_option.text();
	remove_link = "<a href='#' onclick= '$(this).parent(\"div\").remove(); return false;' class='form-button right'>Remove</a>";
	placeholder.append("<div>"+  text + hidden_field + remove_link + "</div>");
}