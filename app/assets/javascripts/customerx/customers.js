// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
   $("#customer_since_date").datepicker({dateFormat: 'yy-mm-dd'});
});

//for search.html.erb
$(function() {
   $("#customer_start_date_s").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#customer_end_date_s").datepicker({dateFormat: 'yy-mm-dd'});
});