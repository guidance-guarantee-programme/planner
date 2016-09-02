(function($) {
  var $collapseItems = $('main [data-toggle="collapse"]');
  $collapseItems.removeClass('hidden');

  $collapseItems.each(function() {
    $item = $(this);
    var targetId = $item.attr('data-target') || $item.attr('href');

    $(targetId).addClass('collapse');
  });
})(jQuery);
