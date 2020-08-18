class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'O e-mail já existe.',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida.',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Muitas tentativas, tente novamente mais tarde.',
    'EMAIL_NOT_FOUND': 'E-mail ou senha inválida.',
    'INVALID_PASSWORD': 'E-mail ou senha inválida.',
    'USER_DISABLED': 'Usuário desativado.',
  };

  final String key;

  const AuthException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    }
    return 'Ocorreu um erro na autenticação.';
  }
}
