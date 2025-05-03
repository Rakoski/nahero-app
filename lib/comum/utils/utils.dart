class Utils {
  static String getNivelDificuldade(int? nivel) {
    switch (nivel) {
      case 1:
        return 'Fundação';
      case 2:
        return 'Associado';
      case 3:
        return 'Profissional';
      case 4:
        return 'Especialidade';
      default:
        return 'Associado';
    }
  }
}
