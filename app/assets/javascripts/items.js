$(document).ready(function(){
  $('[data-behaviour~=datepicker]').datepicker({});
  $('#toolbar a:last').tab('show');
  $('#toolbar a:last').addClass('active');

  $('#toolbar a').click(function() {
    $('#toolbar a').toggleClass('active');
  });
})


