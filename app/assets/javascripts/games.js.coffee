$ ->
  $('.chessboard__row__space img').draggable(cursor: 'move', snap: '.chessboard__row__space')
  $('.chessboard__row__space').droppable drop: (event, ui)->
    $target = $(event.target)

    piece_url = ui.draggable.parent().attr('href')

    $.ajax
      url: piece_url,
      method: 'PUT',
      data:
        piece:
          position_x: $target.data('x'),
          position_y: $target.data('y')
      complete: ->
        location.reload()
      error: ->
        alert('Invalid move')

