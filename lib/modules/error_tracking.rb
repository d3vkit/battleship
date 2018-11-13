require_relative '../text_manager'

module ErrorTracking
  def errors
    @errors ||= []
  end

  def errors=(errors)
    @errors = errors
  end

  def valid?
    errors.empty?
  end

  def error_message
    TextManager.red(errors.join(', '))
  end

  def clear_errors
    @errors = []
  end
end