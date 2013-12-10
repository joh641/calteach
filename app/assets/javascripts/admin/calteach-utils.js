var calteach = {};

(function ($) {

calteach.adjustInventoryColumnHeight = function() {
	var mainMenuHeight = $("#main-menu").height();
	var totalDocumentHeight = $(window).height();
	$(".left-column-container").height(totalDocumentHeight - mainMenuHeight);
};

calteach.initItemReservationDatePicker = function() {
  var availability = $.parseJSON($('#reservation form').attr('avail_hash'));
  var yesterday = new Date(new Date().setDate(new Date().getDate()-1));


  var datepickerSettings = {
      startDate: new Date(),
      endDate: moment(new Date()).add('days', 59).toDate(),
      autoclose: true,
      beforeShowDay: function (date) {
        var thisDate = moment(date).format("MM/DD/YYYY");
        if (availability[thisDate] < $('#reservation_quantity').find(":selected").text()) {
          return 'crossed';
        } else {
          if (moment(date) > moment(yesterday))
          return 'bold';
        }
      }
  };

  $('#reservation .input-daterange').datepicker(datepickerSettings);
  $('#reservation_quantity').change(function() {
    $('#reservation .input-daterange').datepicker('remove');
    $('#reservation_start_date').val('');
    $('#reservation_end_date').val('');
    $('#reservation .input-daterange').datepicker(datepickerSettings);
  });
};

})(jQuery);
