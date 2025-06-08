require 'rails_helper'

RSpec.describe 'Executing commands', type: :request do
  before do
    Terminal::Reset.instance.call
  end

  describe 'when with a valid command' do
    context 'when game is on GENERAL_AUTHORIZATION incomplete' do
      it 'returns a success message' do
        get terminal_status_index_path, params: { name: 'energy' }

        expect(json['terminal']['name']).to eq('energy')

        room_id = json['terminal']['id']

        post commands_execution_path, params: { execution: { name: 'dist_energia', operation: 'estado', terminal_id: room_id } }

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

        get terminal_status_index_path, params: { name: 'escape' }

        expect(json['terminal']['name']).to eq('escape')
        escape_room_id = json['terminal']['id']

        post commands_execution_path, params: { execution: { name: 'csl', operation: 'iniciar_lancamento', terminal_id: escape_room_id } }

        expect(json['status']).to eq('error')
        expect(json['message']).to eq("<p>Impossível executar comando, sistema funcionando em nível crítico. (FALHA CRÍTICA: Flutuação de energia induzida por ressonância gravitacional externa (Ref: Alerta Engenharia ARG-05-01). Compensação da Engenharia (05) ineficaz. Reator Principal operando em código 0x01020).</p>\n")

        get terminal_status_index_path, params: { name: 'energy' }

        expect(json['terminal']['name']).to eq('energy')
        energy_room_id = json['terminal']['id']

        post commands_execution_path, params: { execution: { name: 'reator_principal', operation: 'estado', terminal_id: energy_room_id } }

        expect(json['message']).to eq("<p>Reator Principal operando em código <code>0x01020</code>. FALHA CRÍTICA: Flutuação de energia induzida por ressonância gravitacional externa. Análise do fluxo taquionico para recalibragem manual da frequencia harmonica SCG_RESSONANCIA é necessária.</p>\n")
        expect(json['status']).to eq('finished')

        post commands_execution_path, params: { execution: { name: 'reator_principal', operation: 'ler_fluxo_taquionico_ambiente', terminal_id: energy_room_id } }

        expect(json['message']).to eq("<p>Leitura do fluxo taquiônico ambiente: <code>7.384</code> unidades.</p>\n")
        expect(json['status']).to eq('finished')

        get terminal_status_index_path, params: { name: 'tec' }

        expect(json['terminal']['name']).to eq('tec')
        tec_room_id = json['terminal']['id']

        post commands_execution_path, params: { execution: { name: 'calibrar_sensores', operation: 'modular_frequencia_harmonica SCG_RESSONANCIA 7.384', terminal_id: tec_room_id } }

        expect(json['message']).to eq("<p>Calibragem dos sensores iniciada...</p>\n")
        expect(json['status']).to eq('continue')

        continue_url = json['continue_url']

        get continue_url, params: { execution: { name: 'calibrar_sensores', operation: 'modular_frequencia_harmonica SCG_RESSONANCIA 7.384', terminal_id: tec_room_id } }

        expect(json['message']).to eq("<p>-&gt;&gt; Aguardando autorização de comando MB-H897.</p>\n")
        expect(json['status']).to eq('continue')

        get terminal_status_index_path, params: { name: 'bridge' }

        expect(json['terminal']['name']).to eq('bridge')
        bridge_room_id = json['terminal']['id']

        post commands_execution_path, params: { execution: { name: 'ponte', operation: 'autorizar 15 MB-H897', terminal_id: bridge_room_id } }

        expect(json['message']).to eq("<p>Operação MB-H897 da sala tec (15) foi autorizado com sucesso!</p>\n")
        expect(json['status']).to eq('finished')

        get continue_url, params: { execution: { name: 'calibrar_sensores', operation: 'modular_frequencia_harmonica SCG_RESSONANCIA 7.384', terminal_id: tec_room_id } }

        expect(json['message']).to eq("<p>Matriz Harmônica Gerada: MH-9B7C1D3A. Modulação de frequência harmônica para SCG_RESSONANCIA com base 7.384 em andamento...</p>\n")
        expect(json['status']).to eq('continue')

        get continue_url, params: { execution: { name: 'calibrar_sensores', operation: 'modular_frequencia_harmonica SCG_RESSONANCIA 7.384', terminal_id: tec_room_id } }

        expect(json['message']).to eq("<p>** ALERTA CRÍTICO: Reator operando em capacidade máxima. Calibragem das hastes é requerida imediatamente ou sistema entrará em recuperação automatica em 31 segundos...</p>\n")
        expect(json['status']).to eq('continue')

        get continue_url, params: { execution: { name: 'calibrar_sensores', operation: 'modular_frequencia_harmonica SCG_RESSONANCIA 7.384', terminal_id: tec_room_id } }

        expect(json['message']).to eq("<p>** ALERTA CRÍTICO: Reator operando em capacidade máxima. Calibragem das hastes é requerida imediatamente ou sistema entrará em recuperação automatica em 30 segundos...</p>\n")
        expect(json['status']).to eq('continue')

        get terminal_status_index_path, params: { name: 'eng' }

        expect(json['terminal']['name']).to eq('eng')
        eng_room_id = json['terminal']['id']

        post commands_execution_path, params: { execution: { name: 'nuclear', operation: 'calibrar_hastes', terminal_id: eng_room_id } }

        expect(json['message']).to eq("<p>Calibração das hastes de controle concluída. Precisão dentro de 0.01mm.</p>\n")
        expect(json['status']).to eq('finished')

        get continue_url, params: { execution: { name: 'calibrar_sensores', operation: 'modular_frequencia_harmonica SCG_RESSONANCIA 7.384', terminal_id: tec_room_id } }

        expect(json['message']).to eq("<p>Processo finalizado! Sistema calibrado e operando em níveis de energia normais.</p>\n")
        expect(json['status']).to eq('finished')
      end
    end

    context 'when room doesnt have the command but is a valid command' do
      it 'returns a success message' do
        get terminal_status_index_path, params: { name: 'energy' }

        expect(json['terminal']['name']).to eq('energy')

        room_id = json['terminal']['id']

        post commands_execution_path, params: { execution: { name: 'pap', operation: 'autenticar CV-917-ORION-7', terminal_id: room_id } }

        expect(json['status']).to eq('error')
        expect(json['message']).to eq("<p><strong>Comando não autorizado!</strong> Esse terminal (energy) não possui os níveis de permissão necessários para execução de comandos &quot;<code>pap</code>&quot;.</p>\n")
      end
    end
  end

  describe 'when with an unknown command' do
    it 'returns a success message' do
      get terminal_status_index_path, params: { name: 'energy' }

      expect(json['terminal']['name']).to eq('energy')

      room_id = json['terminal']['id']

      post commands_execution_path, params: { execution: { name: 'unknown', operation: 'estado', terminal_id: room_id } }

      expect(json['status']).to eq('error')
      expect(json['message']).to eq(<<~MESSAGE)
        <p>Comando inexistente, não foi possível encontrar &quot;<code>unknown</code>&quot; no sistema.</p>

        <p><strong>Commandos disponíveis:</strong> <code>dist_energia, gerador_aux, reator_principal</code></p>
      MESSAGE
    end
  end

  describe 'when with an unknown operation on a valid command' do
    it 'returns a success message' do
      get terminal_status_index_path, params: { name: 'energy' }

      expect(json['terminal']['name']).to eq('energy')

      room_id = json['terminal']['id']

      post commands_execution_path, params: { execution: { name: 'dist_energia', operation: 'unknown', terminal_id: room_id } }

      expect(json['status']).to eq('error')
      expect(json['message']).to eq("<p>Operação inexistente, não foi possível encontrar operação &quot;<code>unknown</code>&quot; no comando &quot;<code>dist_energia</code>&quot;.</p>\n")
    end

    describe 'when operation is blank' do
      it 'returns a success message' do
        get terminal_status_index_path, params: { name: 'energy' }

        expect(json['terminal']['name']).to eq('energy')

        room_id = json['terminal']['id']

        post commands_execution_path, params: { execution: { name: 'dist_energia', operation: '', terminal_id: room_id } }

        expect(json['status']).to eq('error')
        expect(json['message']).to eq("<p>Operação inexistente, não foi possível encontrar operação &quot;`<code>&quot; no comando &quot;</code>dist_energia`&quot;.</p>\n")
      end
    end

  end
end
