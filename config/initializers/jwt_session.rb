# frozen_string_literal: true

DEFAULT_ACCESS_EXPIRATION = 3_600 # 1 hour in seconds

JWTSessions.algorithm = 'HS256'
JWTSessions.encryption_key = Rails.application.credentials.dig(:jwt_sessions, :encryption_key)
JWTSessions.access_exp_time = DEFAULT_ACCESS_EXPIRATION
