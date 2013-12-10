$(document).ready(function() {
	// calteach.initInventory();
	calteach.adjustInventoryColumnHeight();
    $(window).resize(function() {
        calteach.adjustInventoryColumnHeight();
    });
});
