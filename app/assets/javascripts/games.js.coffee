$ ->
  gameId = $('.chessboard').data('channelid')

  if (gameId != undefined)
    pusher = new Pusher '9d04d520abd8261569ea', { encrypted: true }
    channel = pusher.subscribe gameId
    channel.bind 'move', (data)->
      piece = $("[data-id=#{data.piece_id}]")

      if piece.css('top') == '0px' && piece.css('left') == '0px'
        animateMove(piece, data.destination)
      else
        movePieceElement(piece, data.destination)

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

movePieceElement = (piece, destination)->
  piece.css(top: 0, left: 0)
  destinationSquare = $("[data-x=#{destination.x}][data-y=#{destination.y}]")
  destinationSquare.empty().append(piece.detach())

animateMove = (piece, destination)->
  topOffset = (destination.y - piece.parent().data('y')) * 72
  leftOffset = (destination.x - piece.parent().data('x')) * 72
  piece.animate top: topOffset, left: leftOffset, ->
    movePieceElement(piece, destination)
