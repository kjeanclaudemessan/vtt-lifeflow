/// Configuration for Supabase integration tests.
///
/// Uses the local Supabase instance for testing.
library;

/// Local Supabase URL.
const String testSupabaseUrl = 'http://127.0.0.1:54321';

/// Local Supabase anon key.
const String testSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0';

/// Local Supabase service role key (for admin operations in tests).
const String testSupabaseServiceKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU';

/// Test user credentials.
class TestUser {
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;

  const TestUser({
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
  });
}

/// Default test user for authentication tests.
const testUser1 = TestUser(
  email: 'test1@example.com',
  password: 'Test123456!',
  firstName: 'Test',
  lastName: 'User',
);

/// Second test user for multi-user scenarios.
const testUser2 = TestUser(
  email: 'test2@example.com',
  password: 'Test123456!',
  firstName: 'Second',
  lastName: 'User',
);

/// Generate a unique test email to avoid conflicts.
String generateTestEmail() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  return 'test_$timestamp@example.com';
}
