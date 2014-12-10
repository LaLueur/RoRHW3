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


function processVote(message, totalScore) {
    var totalScoreContainer = $('#post-total-score');
    var alertContainer = $('#post-alert');

    totalScoreContainer.text(totalScore);

    //ToDo: implement fancy alerts e.g. http://pjdietz.com/jquery-plugins/freeow/
    alertContainer.text(message);
}


$(function(){
    addDeleteEvent ($('.delete_comment_link'));
    addCommentEvent ($('.comment-post'));

});

function submitCommentEvent(element) {
    return element.on('ajax:complete', function(e, data, status, xhr) {
        if (status == 'success') {
            var comment = $(data.responseText);
            var parentElementId = element.find('#comment_parent_id').val();
            if (parentElementId){
                var parentCommentContainerId = '#comment-id-' + parentElementId;
                var parentComment = $(parentCommentContainerId);
                parentComment.after(comment);
            } else {
                var commentsContainerId = '#comments';
                var commentsContainer = $(commentsContainerId);
                commentsContainer.append(comment);
            }

            addDeleteEvent (comment.find('.delete_comment_link'));
            addCommentEvent (comment.find('.comment-post'));
        }
        $('#new-comment-form').html('');
    });
}

function addDeleteEvent (elements) {
   return elements.on('ajax:complete', function (e, data, status, xhr) {
       var response = jQuery.parseJSON(data.responseText);

       if (response.comment_deleted) {
           $(response.comment_container_id).parent('.nested').remove();
       }

       alert(response.message);
   });
};

function addCommentEvent (elements) {
    return elements.on('ajax:complete', function (e, data, status, xhr) {
        var container = $('#new-comment-form');
        var commentForm = $(data.responseText);

        container.append(commentForm);
        $('html, body').animate({
            scrollTop: (commentForm.offset().top)
        },500);
        submitCommentEvent($('#new_comment'));
    });
};