$(document).ready(function(){
  $('#toolbar a:first').tab('show');
  $('#toolbar a:first').addClass('active');

  $(document).on('click', '#toolbar a:not(.active)', function() {
    $('#toolbar a').toggleClass('active');
  });

  $("#item_tag_list").select2({tags:$('#item_tag_list').data('all')});

  var availability = $.parseJSON($('#reservation form').attr('avail_hash'));
  var datepickerSettings = {
      startDate: new Date(),
      endDate: moment(new Date()).add('days', 59).toDate(),
      autoclose: true,
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
  });

  $.datepicker.setDefaults({
    dateFormat: 'yyyy/mm/dd'
  });
})


