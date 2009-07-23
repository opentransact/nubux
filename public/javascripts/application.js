$(document).ready(function() {
  $('form#new_transact').submit(function(){
    return confirm("Are you sure you want to perform this payment? It can't be undone.");
  });
});