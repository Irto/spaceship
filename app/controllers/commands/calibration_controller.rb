module Commands
  class CalibrationController < ::ActionController::API

    def index
      calibration_authorization = GameParameter[::GameParameter::CALIBRATION_AUTHORIZATION]
      reactor_rods_calibration = GameParameter[::GameParameter::REACTOR_RODS_CALIBRATION]

      if calibration_authorization.is?('complete')
        if reactor_rods_calibration&.is?('complete')

          result(
            status: 'finished',
            message: 'Processo finalizado! Sistema calibrado e operando em níveis de energia normais.'
          )

          GameParameter[::GameParameter::ENERGY_STABILIZATION].update(value: 'complete')
        elsif reactor_rods_calibration.present? && reactor_rods_calibration.value.to_i <= 0
          ::Terminal::Reset.instance.call

          result(
            status: 'continue',
            continue_url: commands_calibration_index_path,
            message: ' !!!! Sistema entrando em modo de recuperação agora !!!!'
          )
        elsif (rods_time = reactor_rods_calibration&.value.to_i) > 0
          result(
            status: 'continue',
            continue_url: commands_calibration_index_path,
            message: " ** ALERTA CRÍTICO: Reator operando em capacidade máxima. Calibragem das hastes é requerida imediatamente ou sistema entrará em recuperação automatica em #{rods_time} segundos..."
          )

          reactor_rods_calibration.update(value: rods_time - 1)
        else
          result(
            status: 'continue',
            continue_url: commands_calibration_index_path,
            message: ' Matriz Harmônica Gerada: MH-9B7C1D3A. Modulação de frequência harmônica para SCG_RESSONANCIA com base 7.384 em andamento...'
          )

          GameParameter.find_or_create_by(name: ::GameParameter::REACTOR_RODS_CALIBRATION).update!(value: '31')
        end
      else
        result(
          status: 'continue',
          continue_url: commands_calibration_index_path,
          message: "->> Aguardando autorização de comando #{calibration_authorization.value}."
        )
      end
    end

    private

    def result(**data)
      render(json: { **data, message: markdown.render(data[:message]) }.compact, status: :ok)
    end

    private

    def markdown
      @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    end
  end
end
