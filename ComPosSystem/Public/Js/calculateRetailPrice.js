$(document).ready(function() {
    //this calculates values automatically 
    calculateRetailPrice();
    $("#wholesalePrice, #markup").on("keydown keyup", function() {
        calculateRetailPrice();
      });
  });

function calculateRetailPrice() {
  var wholesalePrice = document.getElementById('wholesalePrice').value;
  var markup = document.getElementById('markup').value;
  var retailPrice = parseFloat(wholesalePrice) + ((parseFloat(markup) * parseFloat(wholesalePrice) / parseInt(100)));
  if (!isNaN(retailPrice)) {
    document.getElementById('retailPrice').value = retailPrice.toFixed(2);
  }
}