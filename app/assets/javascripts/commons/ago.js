"use strict";

$(function() {
  $("time.ago").each(function(_, element) {
    $(element).text(moment.utc($(element).attr("datetime")).fromNow());
  });
});
