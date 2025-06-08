require 'rails_helper'

RSpec.describe 'Executing commands', type: :request do
  before do
    Terminal::Reset.instance.call
  end

  describe 'when with a valid command' do
    context 'when game is on GENERAL_AUTHORIZATION incomplete' do
      it 'returns a success message' do
        get terminal_status_index_path, params: { name: 'tec' }

        expect(json['terminal']['name']).to eq('tec')

        room_id = json['terminal']['id']

        post commands_execution_path, params: { execution: { name: 'backup_restore', operation: 'estado_backup', terminal_id: room_id } }

        expect(json['status']).to eq('error')
        expect(json['message']).to eq("<p>SISTEMA BLOQUEADO, OPERADOR NECESSÁRIO</p>\n")
      end
    end

    context 'when game is on GENERAL_AUTHORIZATION complete' do
      it 'returns a success message' do
        get terminal_status_index_path, params: { name: 'bridge' }

        expect(json['terminal']['name']).to eq('bridge')

        room_id = json['terminal']['id']

        post commands_execution_path, params: { execution: { name: 'pap', operation: 'autenticar CV-917-ORION-7', terminal_id: room_id } }

        expect(json['message']).to eq("<p>Código <strong>CV-917-ORION-7</strong> aceito. Bem-vindo, <code>Copiloto Júnior</code>. Acesso Nível 2 concedido. Paineis operacionais liberados. Código <code>0x01300</code>`.</p>\n")
        expect(json['status']).to eq('finished')

        get terminal_status_index_path, params: { name: 'tec' }

        expect(json['terminal']['name']).to eq('tec')

        room_id = json['terminal']['id']

        post commands_execution_path, params: { execution: { name: 'backup_restore', operation: 'estado_backup', terminal_id: room_id } }

        expect(json['message']).to eq("<p>O comando &#39;estado<em>backup&#39; do módulo &#39;backup</em>restore&#39; foi executado com sucesso.</p>\n")
        expect(json['status']).to eq('finished')
      end
    end

    context 'when room doesnt have the command but is a valid command' do
      it 'returns a success message' do
        get terminal_status_index_path, params: { name: 'tec' }

        expect(json['terminal']['name']).to eq('tec')

        room_id = json['terminal']['id']

        post commands_execution_path, params: { execution: { name: 'pap', operation: 'autenticar CV-917-ORION-7', terminal_id: room_id } }

        expect(json['status']).to eq('error')
        expect(json['message']).to eq("<p><strong>Comando não autorizado!</strong> Esse terminal (tec) não possui os níveis de permissão necessários para execução de comandos &quot;<code>pap</code>&quot;.</p>\n")
      end
    end
  end

  describe 'when with an unknown command' do
    it 'returns a success message' do
      get terminal_status_index_path, params: { name: 'tec' }

      expect(json['terminal']['name']).to eq('tec')

      room_id = json['terminal']['id']

      post commands_execution_path, params: { execution: { name: 'unknown', operation: 'estado_backup', terminal_id: room_id } }

      expect(json['status']).to eq('error')
      expect(json['message']).to eq(<<~MESSAGE)
        <p>Comando inexistente, não foi possível encontrar &quot;<code>unknown</code>&quot; no sistema.</p>

        <p><strong>Commandos disponíveis:</strong> <code>backup_restore, calibrar_sensores, diagnostico_remoto, estrutura_nave, exp_quanticos, manip_materia</code></p>
      MESSAGE
    end
  end

  describe 'when with an unknown operation on a valid command' do
    it 'returns a success message' do
      get terminal_status_index_path, params: { name: 'tec' }

      expect(json['terminal']['name']).to eq('tec')

      room_id = json['terminal']['id']

      post commands_execution_path, params: { execution: { name: 'backup_restore', operation: 'unknown', terminal_id: room_id } }

      expect(json['status']).to eq('error')
      expect(json['message']).to eq("<p>Operação inexistente, não foi possível encontrar operação &quot;<code>unknown</code>&quot; no comando &quot;<code>backup_restore</code>&quot;.</p>\n")
    end

    describe 'when operation is blank' do
      it 'returns a success message' do
        get terminal_status_index_path, params: { name: 'tec' }

        expect(json['terminal']['name']).to eq('tec')

        room_id = json['terminal']['id']

        post commands_execution_path, params: { execution: { name: 'backup_restore', operation: '', terminal_id: room_id } }

        expect(json['status']).to eq('error')
        expect(json['message']).to eq("<p>Operação inexistente, não foi possível encontrar operação &quot;`<code>&quot; no comando &quot;</code>backup_restore`&quot;.</p>\n")
      end
    end

  end
end
