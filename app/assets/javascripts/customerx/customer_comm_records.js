// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//for autocomplete
$(function() {
   $("#customer_comm_record_comm_date").datepicker({dateFormat: 'yy-mm-dd'});
   $("#customer_comm_record_start_date_s").datepicker({dateFormat: 'yy-mm-dd'});
   $("#customer_comm_record_end_date_s").datepicker({dateFormat: 'yy-mm-dd'});
});

$(function() {
    return $('#customer_comm_record_customer_name_autocomplete').autocomplete({
        minLength: 1,
        source: $('#customer_comm_record_customer_name_autocomplete').data('autocomplete-source'),  //'#..' can NOT be replaced with this
        select: function(event, ui) {
            //alert('fired!');
            $('#customer_comm_record_customer_name_autocomplete').val(ui.item.value);
        },
    });
});