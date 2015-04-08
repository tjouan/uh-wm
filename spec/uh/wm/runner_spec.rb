module Uh
  module WM
    RSpec.describe Runner do
      let(:env)         { Env.new(StringIO.new) }
      subject(:runner)  { described_class.new env }

      describe '.run' do
        subject(:run) { described_class.run env }

        it 'builds a new Runner with given env' do
          expect(described_class).to receive(:new).with(env).and_call_original
          run
        end

        it 'connects the manager' do
          runner
          allow(described_class).to receive(:new) { runner }
          expect(runner).to receive(:connect_manager)
          run
        end
      end

      describe '#initialize' do
        it 'assigns the env' do
          expect(runner.env).to be env
        end

        it 'assigns a new Manager' do
          expect(runner.manager).to be_a Manager
        end
      end

      describe '#connect_manager' do
        it 'connects the manager' do
          expect(runner.manager).to receive :connect
          runner.connect_manager
        end

        it 'logs a message when connected' do
          expect(env).to receive(:log).with /connected/i
          runner.connect_manager
        end
      end
    end
  end
end
