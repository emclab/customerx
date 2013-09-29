// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
   $("#sales_lead_lead_date").datepicker({dateFormat: 'yy-mm-dd'});
   $("#sales_lead_start_date_s").datepicker({dateFormat: 'yy-mm-dd'});
   $("#sales_lead_end_date_s").datepicker({dateFormat: 'yy-mm-dd'});
});

//hide sales_lead_initial_order_total if sale success is false
$(function(){
	var rpt = $('#sales_lead_sale_success').val();
    if (rpt == 'true') {
      $("#sales_lead_order_total").show(); 
    } else {
      $("#sales_lead_order_total").hide(); 
   }
});

$(function(){
   $("#sales_lead_sale_success").change(function() {
   	 var rpt = $('#sales_lead_sale_success').val();
   	 if ( rpt == 'true') {
   	    $("#sales_lead_order_total").show(); 
   	 } else {
   	 	$("#sales_lead_order_total").hide(); 
   	 }
   }); 
});

//autocomplete for customers
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


//autocomplete for users
$(function() {
    return $('#sales_lead_provider_name_autocomplete').autocomplete({
        minLength: 1,
        source: $('#sales_lead_provider_name_autocomplete').data('autocomplete-source'),  //'#..' can NOT be replaced with this
        select: function(event, ui) {
            //alert('fired!');
            $('#sales_lead_provider_name_autocomplete').val(ui.item.value);
        },
    });
});