"use strict";

$(document).on("turbolinks:load", function() {
  $("time.ago").each(function(_, element) {
    $(element).text(moment.utc($(element).attr("datetime")).fromNow());
  });
});
