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

    channel.bind 'status', (data)->
      $('.status').text(data.message)

movePieceElement = (piece, destination)->
  piece.css(top: 0, left: 0)
  destinationSquare = $("[data-x=#{destination.x}][data-y=#{destination.y}]")
  destinationSquare.empty().append(piece.detach())

animateMove = (piece, destination)->
  topOffset = (destination.y - piece.parent().data('y')) * 72
  leftOffset = (destination.x - piece.parent().data('x')) * 72
  piece.animate top: topOffset, left: leftOffset, ->
    movePieceElement(piece, destination)

