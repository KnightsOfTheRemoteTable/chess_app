$ ->
  $('#myModal').on 'show.bs.modal', (e)->
    $('.modal-body').html('<h4>Loading...</h4>')
    userId = $(e.relatedTarget).data('playerid')
    url = '/users/' + userId
    $.get url, (response)->
      html = '<img src=' + response.gravatar_url + '></img><h4>' + response.name + ' has been registered since ' + response.playing_since + ' and has ' + response.total_wins + ' total wins.' + '</h4>'
      $('.modal-body').html(html)
  $('.chessboard__row__space a').draggable
    cursor: 'move',
    snap: '.chessboard__row__space',
    snapMode: 'inner',
    revert: 'invalid',
    zIndex: 5,
    start: (event, ui)->
      url = ui.helper.attr('href') + '/valid_moves'
      $.get url, (response)->
        response.forEach (position)->
          $("[data-x=#{position.x}][data-y=#{position.y}]").addClass('valid-move')
    stop: ->
      $('.valid-move').removeClass('valid-move')


  $('.chessboard__row__space').droppable drop: (event, ui)->
    $target = $(event.target)

    piece = ui.draggable
    piece_url = piece.attr('href')

    $.ajax
      url: piece_url,
      method: 'PUT',
      data:
        piece:
          position_x: $target.data('x'),
          position_y: $target.data('y')
      error: (response)->
        ui.draggable.animate(top: 0, left: 0)
