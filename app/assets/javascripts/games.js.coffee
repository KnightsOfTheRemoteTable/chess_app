$ ->
  $('.chessboard__row__space a').draggable
    cursor: 'move',
    snap: '.chessboard__row__space',
    snapMode: 'inner',
    revert: 'invalid',
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
      success: ->
        piece.css(top: 0, left: 0)
        $target.empty().append(piece.detach())
      error: (response)->
        ui.draggable.animate(top: 0, left: 0)

