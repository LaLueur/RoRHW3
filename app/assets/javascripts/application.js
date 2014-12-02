// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require jquery.turbolinks
//= require bootstrap-tagsinput
//= require_tree ../../../vendor/assets/javascripts/.

$(function() {
    return $('.vote-link-up, .vote-link-down').on('ajax:complete', function(e, data, status, xhr) {
        var response = jQuery.parseJSON(data.responseText);
        processVote(response.message, response.total_score);
    });
});


function processVote(message, totalScore){
    var totalScoreContainer = $('#post-total-score');
    var alertContainer = $('#post-alert');

    totalScoreContainer.text(totalScore);

    //ToDo: implement fancy alerts e.g. http://pjdietz.com/jquery-plugins/freeow/
    alertContainer.text(message);
}


$(function() {
    return $('#new_comment').on('ajax:complete', function(e, data, status, xhr) {
        if (status == 'success') {
            var comment = data.responseText;
            var commentsContainer = $('#comments');
            commentsContainer.append(comment);
        }
        $('#comment_content').val('');
    });
});

//$(function() {
//   return $('#delete_comment_link').on('ajax:complete', function (e, data, status, xhr) {
//        var message = data.responseText;
//        alert(message);
//   });
//});