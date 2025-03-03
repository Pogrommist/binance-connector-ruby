# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Binance::Spot::Blvt, '#redeem' do
  let(:tokenName) { 'BTCDOWN' }
  let(:amount) { 100.11 }
  let(:path) { '/sapi/v1/blvt/redeem' }
  let(:body) { fixture('response.json') }
  let(:status) { 200 }
  let(:params) do
    {
      "tokenName": tokenName,
      "amount": amount
    }
  end

  before do
    mocking_signature_and_ts(**params)
    stub_binance_sign_request(:post, path, status, body, params)
  end

  context 'validation tokenName' do
    let(:params) { { "tokenName": '', "amount": amount } }
    it 'should raise validation error without tokenName' do
      expect { spot_client_signed.redeem(**params) }.to raise_error(Binance::RequiredParameterError)
    end
  end

  context 'validation amount' do
    let(:params) { { "tokenName": tokenName, "amount": '' } }
    it 'should raise validation error without amount' do
      expect { spot_client_signed.redeem(**params) }.to raise_error(Binance::RequiredParameterError)
    end
  end

  context 'with parameters' do
    it 'should redeem blvt' do
      spot_client_signed.redeem(**params)
      expect(send_a_request_with_signature(:post, path, params)).to have_been_made
    end
  end
end
