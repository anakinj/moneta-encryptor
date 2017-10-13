require 'moneta/encryptor'

describe Moneta::Encryptor do
  it 'validates key length on initialization' do
    expect do
      described_class.new(nil, encryption_key: 'short_key')
    end.to raise_error(OpenSSL::Cipher::CipherError, 'key length too short')
  end

  let(:store) do
    Moneta.build do
      use :Encryptor, encryption_key: 'SECRET' * 6
      adapter :Memory
    end
  end

  it 'encrypts values before they are stored' do
    store['key'] = 'value'
    expect(store['key']).to eq 'value'
    expect(store.adapter.backend['key']).not_to eq 'value'
    expect(store.adapter.backend['key']).to match(/.*[.].*/)
  end

  it 'does not encrypt non string objects' do
    store['key'] = 1
    expect(store['key']).to eq 1
    expect(store.adapter.backend['key']).to eq 1
  end

  it 'returns the encrypted value if encryption key is nil' do
    store['key'] = 'value'
    value = store.load('key', encryption_key: nil)
    expect(value).not_to eq 'value'
    expect(value).to match(/.*[.].*/)
  end
end
