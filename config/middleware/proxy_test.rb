class ProxyTest
  SUCCESS_CONFIRMATION_MESSAGE = 'test_passed'

  TEST_PAGE_PATH = '/proxy_test'
  WHAT_IS_MY_IP_PATH = '/what_is_my_ip'

  def initialize(app)
    @app = app
  end

  def call(env)
    # 🔴 IMPORTANT: disable proxy test middleware in development
    return @app.call(env) if Rails.env.development?

    if env['PATH_INFO'] == TEST_PAGE_PATH
      [200, { 'Content-Type' => 'text/plain' }, [
        "#{data(env)} #{SUCCESS_CONFIRMATION_MESSAGE}"
      ]]
    elsif env['PATH_INFO'] == WHAT_IS_MY_IP_PATH
      [200,
       { 'Content-Type' => 'text/plain' },
       [
         (
          env['HTTP_X_FORWARDED_FOR'].presence ||
            env['HTTP_X_REAL_IP'].presence ||
            env['REMOTE_ADDR'].presence
          )&.split(',')&.first
       ]]
    else
      @app.call(env)
    end
  end

  private

  def data(env)
    env
      .select { |k, _v| k =~ /^[A-Z_]+$/ && k != 'SERVER_ADDR' && k != 'HTTP_COOKIE' }
      .map { |_k, v| v }.join(' | ')
  end
end
