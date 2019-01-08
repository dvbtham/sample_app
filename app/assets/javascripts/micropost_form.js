$(document).on('turbolinks:load', function() {
  $('#micropost_picture').on('change', function() {
    const MAX_SIZE = 5;
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > MAX_SIZE)
      alert(I18n.t('picture.max_size', {max_size: MAX_SIZE}));
  });
})
