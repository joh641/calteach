var calteach = {};

(function ($) {

calteach.adjustInventoryColumnHeight = function() {
	var mainMenuHeight = $("#main-menu").height();
	var totalDocumentHeight = $(window).height();
	$(".left-column-container").height(totalDocumentHeight - mainMenuHeight);
};

})(jQuery);
