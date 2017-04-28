class Griddler::EmailsController < ActionController::Base
  def create
    normalized_params.each do |p|
      Rails.logger.info "params permitted? #{p.permitted?}"
      process_email email_class.new(p.to_h)
    end

    head :ok
  end

  private

  delegate :processor_class, :email_class, :processor_method, :email_service, to: :griddler_configuration

  private :processor_class, :email_class, :processor_method, :email_service

  def normalized_params
    Array.wrap(email_service.normalize_params(params))
  end

  def process_email(email)
    processor_class.new(email).public_send(processor_method)
  end

  def griddler_configuration
    Griddler.configuration
  end
end
