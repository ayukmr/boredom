# encoding tests
describe Boredom::Encoder, '#encode' do
  # basic objects encoding
  context 'basic objects' do
    # test encoding hashes
    it 'encodes hashes' do
      encoded = Boredom::Encoder.encode({ 'x' => 'y' })
      expect(encoded).to eq("\x0\x1\x1x\xc\x1y")
    end

    # test encoding arrays
    it 'encodes arrays' do
      encoded = Boredom::Encoder.encode(%w[x y z])
      expect(encoded).to eq("\x1\x3\xc\x1x\xc\x1y\xc\x1z")
    end

    # test encoding booleans
    it 'encodes booleans' do
      encoded = Boredom::Encoder.encode(true)
      expect(encoded).to eq("\x2")

      encoded = Boredom::Encoder.encode(false)
      expect(encoded).to eq("\x3")
    end

    # test encoding integers
    it 'encodes integers' do
      encoded = Boredom::Encoder.encode(1)
      expect(encoded).to eq("\x4\x1")
    end

    # test encoding floats
    it 'encodes floats' do
      encoded = Boredom::Encoder.encode(1.5)
      expect(encoded).to eq("\x8\x1\x2")
    end

    # test encoding strings
    it 'encodes strings' do
      encoded = Boredom::Encoder.encode('string')
      expect(encoded).to eq("\xc\x6string")
    end
  end

  # nested objects encoding
  context 'nested objects' do
    # test encoding hashes in arrays
    it 'encodes hashes in arrays' do
      encoded = Boredom::Encoder.encode([{ 'x' => 'y' }, { 'y' => 'z' }])
      expect(encoded).to eq("\x1\x2\x0\x1\x1x\xc\x1y\x0\x1\x1y\xc\x1z")
    end

    # test encoding hashes in hashes
    it 'encodes hashes in hashes' do
      encoded = Boredom::Encoder.encode(
        {
          'x' => { 'y' => 'z' },
          'y' => { 'z' => 'x' }
        }
      )
      expect(encoded).to eq("\x0\x2\x1x\x0\x1\x1y\xc\x1z\x1y\x0\x1\x1z\xc\x1x")
    end
  end
end
