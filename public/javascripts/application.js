function start_uploading() {
  $('#upload form#new_image').fileUploadUI({
    uploadTable: $('.upload_files'),
    buildUploadRow: function (files, index) {
        var file = files[index];
        return $('<tr><td>' + file.name + '<\/td>' +
                '<td class="file_upload_progress"><div><\/div><\/td><\/tr>');
    },
    onComplete: function (event, files, index, xhr, handler) {
      start_cropping(handler.response.image, handler.response.uid);
    }
  });
}

function start_cropping(image, uid) {
  set_status('uploaded');
  $('#crop')
    .find('img')
      .attr('src', image.photo_url)
      .Jcrop({
        aspectRatio: image.ratio,
        setSelect: [ 10, 10, 493+10, 68+10 ],
        sideHandles: false,
        allowSelect: false,
        onChange: function(cropping) {
          $('#image_crop_x').val(cropping.x);
          $('#image_crop_y').val(cropping.y);
          $('#image_crop_width').val(cropping.w);
          $('#image_crop_height').val(cropping.h);
        }
      })
    .end()
    .find('form')
      .attr('action', '/images/' + image.id)
      .attr('method', 'put')
      .bind('ajax:beforeSend', function() {
        $("#crop").hide();
      })
      .bind('ajax:success', function(xhr, data, status) {
        start_processing(data.image);
      })
      .bind('ajax:failure', function(xhr, status, error) {
        error("No cropping possible");
      })
      .find("input#image_tag_uid")
        .val(uid);
}

function start_processing(image) {
  set_status('cropped');
  $("#process progress").attr('value', image.progress);
  setTimeout( function () {
    $.ajax({
       url: '/images/' + image.id,
       context: document.body,
       dataType: "json",
       success: function(data, status) {
         var image = data.image;
         if( image.status == 'processed' ) {
           finished(image);
         }
         else {
           start_processing(image);
         }
       }
    });
  }, 1000 );
}

function finished(image) {
  set_status('processed');
  $('#finish a').attr('href', image.profile_url);
}

//***************************************************
function error(reason) {
  alert( "failure! " + reason );
}

function set_status(status) {
  $('#status').html(status);
  $('#image').attr('class', status);
}

function set_login(status) {
  $('body').attr('class', status);
}

function logout() {
  set_login('loggedout');
}

function login() {
  set_login('loggedin');
}