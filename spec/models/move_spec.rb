describe Move do
  let(:piece) do
    piece = instance_double(ChessPiece)
    allow(piece).to receive(:coordinates).and_return(Coordinates.new(1, 1))
    piece
  end

  describe '.new' do
    it 'initializes source and destination coordinates' do
      move = Move.new(piece: piece, destination: Coordinates.new(1, 3))

      expect(move.source).to eq Coordinates.new(1, 1)
      expect(move.destination).to eq Coordinates.new(1, 3)
    end
  end

  describe '#path' do
    context 'vertical moves' do
      it 'returns all the squares between the source and destination' do
        move = Move.new(piece: piece, destination: Coordinates.new(1, 3))

        expect(move.path).to eq [Coordinates.new(1, 2)]
      end
    end

    context 'horizontal moves' do
      it 'returns all the squares between the source and destination' do
        move = Move.new(piece: piece, destination: Coordinates.new(3, 1))

        expect(move.path).to eq [Coordinates.new(2, 1)]
      end
    end

    context 'diagonal moves' do
      it 'returns all the squares between the source and destination' do
        move = Move.new(piece: piece, destination: Coordinates.new(3, 3))

        expect(move.path).to eq [Coordinates.new(2, 2)]
      end
    end
  end
end
