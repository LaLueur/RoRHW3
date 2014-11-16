$( document ).ready(function() {
    var element = $( "#show-alert" );
    var show = element.text().trim();
    if (show == 'true') {
      bootbox.alert("Learn with Geekhub!");
    }

});






