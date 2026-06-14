class SignInViewModel {
  bool isLoading = false;
  String? error;
  bool isSuccess = false;

  Future<void> signIn(String email, String password) async {
    isLoading = true;
    error = null;
    isSuccess = false;
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (email.isNotEmpty && password.isNotEmpty) {
      isSuccess = true;
    } else {
      error = "Please enter a valid email and password.";
    }
    
    isLoading = false;
  }
}
