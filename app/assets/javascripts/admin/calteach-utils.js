var calteach = {};

(function ($) {

calteach.categories = [
	"Geography", "Math", "Science", "Social Studies"
];

calteach.color_key = {
	"red": "#dd4b39",
	"blue": "#32ccfe",
	"yellow": "#f5cd38",
	"green": "#5bab48"
};

calteach.colors = ["red", "blue", "yellow", "green"]

calteach.icons = {
	"Geography": "fa fa-globe",
	"Math": "fa fa-calendar",
	"Science": "fa fa-flask",
	"Social Studies": "fa fa-book"
};

calteach.initInventory = function() {
	calteach.adjustInventoryColumnHeight();
	calteach.initCategories();
};

calteach.adjustInventoryColumnHeight = function() {
	var mainMenuHeight = $("#main-menu").height();
	var totalDocumentHeight = $(window).height();
	$(".left-column-container").height(totalDocumentHeight - mainMenuHeight);
};

calteach.initCategories = function() {
	$(calteach.categories).each(function(index, category) {
		var $category = $(".category[data-category='" + category + "']");
		console.log($category);
		$category.find("i").addClass(calteach.icons[category]);
		var color = calteach.colors[index % calteach.colors.length]
		$category.css({
			"background-color": calteach.color_key[color],
		});
	});
};
	// background-color: $calteach-yellow;
	// &:hover, &.active {
	// 	background-color: lighten($calteach-yellow, 10%);
	// }
})(jQuery);
