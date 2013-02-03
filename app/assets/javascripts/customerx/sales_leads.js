// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
   $("#sales_lead_lead_date").datepicker({dateFormat: 'yy-mm-dd'});
});

$(function() {
    return $('#sales_lead_customer_name_autocomplete').autocomplete({
        minLength: 1,
        source: $('#sales_lead_customer_name_autocomplete').data('autocomplete-source'),  //'#..' can NOT be replaced with this
        select: function(event, ui) {
            //alert('fired!');
            $('#sales_lead_customer_name_autocomplete').val(ui.item.value);
        },
    });
});