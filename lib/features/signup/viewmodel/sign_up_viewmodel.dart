class SignUpViewModel {
  bool isLoading = false;
  String? error;
  bool isSuccess = false;

  Future<void> signUp(String name, String email, String password) async {
    isLoading = true;
    error = null;
    isSuccess = false;
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      isSuccess = true;
    } else {
      error = "Please fill in all fields to sign up.";
    }
    
    isLoading = false;
  }
}
