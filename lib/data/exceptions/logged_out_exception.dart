class UnauthenticatedException implements Exception {
  final String message;

  UnauthenticatedException({
    this.message = "This action is unavailable while not logged in",
  });
}