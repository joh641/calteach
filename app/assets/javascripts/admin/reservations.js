$(document).ready(function() {
    var date_out_key = '"reservation_out"';
    var id_key = '"id"';
    var value_delimiter = "=>"
    var end_pair_delimiter = "}"
    var last_clicked_field = null;
    var last_entered_date = null;

    $(".res_date").each(function(index, date){
        $(date).parent().append('<span class="btn-link", data-type="date-edit"><i class="fa fa-pencil pencil-icon"></i></span>');
    });

    $('.best_in_place').best_in_place()

    $(document).click(function (event) {
        if (last_clicked_field != null) {
            if (!last_clicked_field.is(event.target) && last_clicked_field.has(event.target).length == 0) {
                convertTextBoxToDiv(last_clicked_field.children().first());
                last_clicked_field = null;
                last_entered_date = null;
            } else {
                return;
            }
        }

        var cell = null;
        if ($(event.target).parent().attr('class') == "btn-link" && $(event.target).parent().parent().children().first().attr('class') == 'res_date') {
            cell = $(event.target).parent().parent();
        } else if ($(event.target).attr('class') == "res_date") {
            cell = $(event.target).parent()
        }

        if (cell != null) {
            var last_clicked_cell = cell;
            convertDivToTextBox(cell.children().first());
            last_clicked_field = last_clicked_cell;
            last_entered_date = last_clicked_field.val();
        }
    });

    var datepickerSettings = {
        clearBtn: true,
        todayHighlight: true,
        autoclose: true
    };
    $('#filter-section .input-daterange').datepicker(datepickerSettings);
    $('#filter-section_quantity').change(function() {
      $('#filter-section .input-daterange').datepicker('remove');
      $('#filter-section #date_in').val('');
      $('#filter-section #date_out').val('');
      $('#filter-section .input-daterange').datepicker(datepickerSettings);
    });

    function convertDivToTextBox(div) {
        var date = div.text();
        var parent = div.parent();
        parent.prepend('<input class="res_date">' + div.val() + "</input>");
        parent.children().first().val(date);
        parent.children().first().focus();
        div.remove();
    }

    function convertTextBoxToDiv(textBox) {
        var old_date = last_entered_date;
        var new_date = textBox.val();
        var id = textBox.parent().attr("data-id");
        var reservation_out;
        var reservation_in;
        var result_date = new_date;


        if (textBox.parent().attr('class') == 'reservation_out') {
            reservation_out = new_date;
            reservation_in = $('td.reservation_in[data-id=' + id + ']').children().first().text();
        } else {
            reservation_out = $('td.reservation_out[data-id=' + id + ']').children().first().text();
            reservation_in = new_date;
        }

        reservation_out = reservation_out.replace(/(\r\n|\n|\r)/gm,"");
        reservation_out = reservation_out.trim();

        $.ajax({
            type: "POST",
            url: "/reservations/" + id,
            data: {_method:'put', start_date:reservation_out, end_date:reservation_in, return_address:window.location.pathname },
            success: function(data) {
                result_date = new_date
                $('#reservation_error').css("visibility", "hidden");
                replaceWithDate(textBox, result_date)
            },
            error: function(data) {
                var response = ($('<p />').html(data['responseText'])).find('pre');
                var error = response.first().text();
                if (error == "Invalid Date") {
                    result_date = old_date;
                }
                replaceWithDate(textBox, result_date)
                $('#reservation_error').text(error).css("visibility", "visible");

            }
        });
    }

    function replaceWithDate(element, date) {
        element.parent().prepend('<span class="res_date">' + date + "</span>");
        element.remove();
    }

    function findValInHashText(response, key) {
        var valueStart = response.text().indexOf(value_delimiter, response.text().indexOf(key)) + value_delimiter.length;
        var valueEnd = response.text().indexOf(end_pair_delimiter, response.text().indexOf(key));
        return response.text().substring(valueStart, valueEnd).replace(/"/g, '');
    }
});