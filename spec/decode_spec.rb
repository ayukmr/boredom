# decoding tests
describe Boredom::Decoder, '#decode' do
  # basic objects decoding
  context 'basic objects' do
    # test decoding hashes
    it 'decodes hashes' do
      decoded = Boredom::Decoder.decode("\x0\x1\x1x\xc\x1y")
      expect(decoded).to eq({ 'x' => 'y' })
    end

    # test decoding arrays
    it 'decodes arrays' do
      decoded = Boredom::Decoder.decode("\x1\x3\xc\x1x\xc\x1y\xc\x1z")
      expect(decoded).to eq(%w[x y z])
    end

    # test decoding booleans
    it 'decodes booleans' do
      decoded = Boredom::Decoder.decode("\x2")
      expect(decoded).to eq(true)

      decoded = Boredom::Decoder.decode("\x3")
      expect(decoded).to eq(false)
    end

    # test decoding integers
    it 'decodes integers' do
      decoded = Boredom::Decoder.decode("\x4\x1")
      expect(decoded).to eq(1)
    end

    # test decoding floats
    it 'decodes floats' do
      decoded = Boredom::Decoder.decode("\x8\x1\x2")
      expect(decoded.to_d).to eq(BigDecimal('1.5'))
    end

    # test decoding strings
    it 'decodes strings' do
      decoded = Boredom::Decoder.decode("\xc\x6string")
      expect(decoded).to eq('string')
    end
  end

  # nested objects decoding
  context 'nested objects' do
    # test decoding hashes in arrays
    it 'decodes hashes in arrays' do
      decoded = Boredom::Decoder.decode("\x1\x2\x0\x1\x1x\xc\x1y\x0\x1\x1y\xc\x1z")
      expect(decoded).to eq([{ 'x' => 'y' }, { 'y' => 'z' }])
    end

    # test decoding hashes in hashes
    it 'decodes hashes in hashes' do
      decoded = Boredom::Decoder.decode("\x0\x2\x1x\x0\x1\x1y\xc\x1z\x1y\x0\x1\x1z\xc\x1x")
      expect(decoded).to eq(
        {
          'x' => { 'y' => 'z' },
          'y' => { 'z' => 'x' }
        }
      )
    end
  end
end
