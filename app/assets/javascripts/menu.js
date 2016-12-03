// var category_list = document.getElementById('category_list');
var active_li = null; 
var active_ul = null;

$('#category_list').click(function(event) {
	var li = event.target;

	if(li.id != 'float_category') return false;

	var ul = li.parentNode.nextElementSibling;

	if(ul.nodeName != 'UL') return false;

	/*****************************************/

	if(li == active_li) {
		ul.style.display = "";
		li.innerHTML = '[+]';

		active_li = null; 
		active_ul = null;
	}else {
		if(active_ul == null && active_li == null) {
			active_ul = ul;
			active_li = li;

			active_ul.style.display = "block";
			// active_ul.animate({'display': 'block'});

			active_li.innerHTML = '[-]';
		}else {
			active_ul.style.display = "";
			active_li.innerHTML = '[+]';

			active_ul = ul;
			active_li = li;

			active_ul.style.display = "block";
			active_li.innerHTML = '[-]';
		}
	}
});