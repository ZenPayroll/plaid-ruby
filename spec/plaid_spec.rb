require 'spec_helper.rb'

describe Plaid, 'Call' do
  before(:all) do |_|
    keys = YAML::load(IO.read('./keys.yml'))
    Plaid.config do |p|
      p.client_id = keys['CLIENT_ID']
      p.secret = keys['SECRET']
    end
  end

  it 'calls get_place and returns a response code of 200' do
    place = Plaid.call.get_place('526842af335228673f0000b7')
    expect(place[:code]).to eq(200)
  end

  it 'calls get_institutions and returns a response code of 200' do
    institutions = Plaid.call.get_institutions
    expect(institutions.any?).to eq(true)
  end

end

describe Plaid::Auth do
  before(:all) do |_|
    keys = YAML::load(IO.read('./keys.yml'))
    Plaid.config do |p|
      p.client_id = keys['CLIENT_ID']
      p.secret = keys['SECRET']
    end
  end

  describe '.add' do
    context 'when the bank does not require MFA' do
      it 'responds with a status code of 200' do
        response = Plaid::Auth.add('wells', username: 'plaid_test', password: 'plaid_good')
        expect(response[:code]).to eq(200)
      end
    end

    context 'when the bank requires MFA' do
      it 'responds with a status code of 201' do
        response = Plaid::Auth.add('chase', username: 'plaid_test', password: 'plaid_good')
        expect(response[:code]).to eq(201)
      end
    end
  end

  describe '.get' do
    it 'responds with a status code of 200' do
      response = Plaid::Auth.get('test')
      expect(response[:code]).to equal(200)
    end
  end

  describe '.step' do
    context 'when the first answer is given' do
      it 'responds with a status code of 201' do
        response = Plaid::Auth.step('test', 'again', nil, 'bofa')
        expect(response[:code]).to eq(201)
      end
    end

    context 'when the final answer is given' do
      it 'responds with a status code of 200' do
        response = Plaid::Auth.step('test', 'tomato', nil, 'bofa')
        expect(response[:code]).to eq(200)
      end
    end
  end

end

describe Plaid, 'Customer' do
  before :all do |_|
    keys = YAML::load(IO.read('./keys.yml'))
    Plaid.config do |p|
      p.client_id = keys['CLIENT_ID']
      p.secret = keys['SECRET']
    end
  end

  it 'calls get_transactions and returns a response code of 200' do
    transactions = Plaid.customer.get_transactions('test')
    expect(transactions[:code]).to eq(200)
  end

  it 'calls delete_account and returns a response code of 200' do
    message = Plaid.customer.delete_account('test')
    expect(message[:code]).to eq(200)
  end
end
