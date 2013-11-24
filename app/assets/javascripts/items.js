$(document).ready(function(){
  $('#toolbar a:last').tab('show');
  $('#toolbar a:last').addClass('active');

  $('#toolbar a').click(function() {
    $('#toolbar a').toggleClass('active');
  });

  var availability = $.parseJSON($('#reservation form').attr('avail_hash'));
  var datepickerSettings = {
      startDate: new Date(),
      endDate: moment(new Date()).add('days', 59).toDate(),
      beforeShowDay: function (date) {
        var thisDate = moment(date).format("MM/DD/YYYY");
        if (availability[thisDate] < $('#reservation_quantity').find(":selected").text()) {
          return 'crossed';
        } else {
          if (moment(date) > moment(new Date()))
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
  })
})


