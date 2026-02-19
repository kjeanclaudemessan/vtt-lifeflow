import 'package:supabase/supabase.dart';

void main() async {
  final c = SupabaseClient(
    'http://127.0.0.1:54321',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU',
  );
  final users = await c.auth.admin.listUsers();
  int count = 0;
  for (final u in users) {
    if (u.email?.startsWith('vm_test_') == true) {
      await c.auth.admin.deleteUser(u.id);
      count++;
    }
  }
  print('Deleted $count vm_test_ users');
}
