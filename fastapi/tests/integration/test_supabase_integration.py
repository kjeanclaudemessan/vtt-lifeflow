"""Integration tests with real Supabase connection."""

import pytest
from dotenv import load_dotenv
import os

# Load real .env file
load_dotenv(override=True)


def test_supabase_connection():
    """Test real connection to Supabase."""
    from app.core.config import Settings
    from supabase import create_client
    
    # Create settings from real env
    settings = Settings()
    
    # Connect to Supabase
    client = create_client(
        settings.supabase_url,
        settings.supabase_anon_key,
    )
    
    # Test connection by listing tables (profiles should exist)
    response = client.table("profiles").select("id").limit(1).execute()
    
    assert response is not None
    assert hasattr(response, 'data')
    print(f"✅ Connected to Supabase: {settings.supabase_url}")


def test_supabase_admin_connection():
    """Test admin connection to Supabase."""
    from app.core.config import Settings
    from supabase import create_client
    
    settings = Settings()
    
    # Connect with service role key
    admin_client = create_client(
        settings.supabase_url,
        settings.supabase_service_role_key,
    )
    
    # Test by querying auth.users (requires admin)
    response = admin_client.table("profiles").select("*").limit(5).execute()
    
    assert response is not None
    print(f"✅ Admin connection works, found {len(response.data)} profiles")


def test_create_user_and_profile():
    """Test creating a user through Supabase Auth and verify profile trigger."""
    from app.core.config import Settings
    from supabase import create_client
    import uuid
    
    settings = Settings()
    
    # Admin client for user creation
    admin_client = create_client(
        settings.supabase_url,
        settings.supabase_service_role_key,
    )
    
    # Create a test user
    test_email = f"test-{uuid.uuid4().hex[:8]}@example.com"
    test_password = "TestPassword123!"
    
    try:
        # Create user via admin API
        response = admin_client.auth.admin.create_user({
            "email": test_email,
            "password": test_password,
            "email_confirm": True,
        })
        
        user_id = response.user.id
        print(f"✅ Created user: {user_id}")
        
        # Check if profile was auto-created by trigger
        profile_response = admin_client.table("profiles").select("*").eq("id", user_id).single().execute()
        
        assert profile_response.data is not None
        assert profile_response.data["id"] == user_id
        print(f"✅ Profile auto-created for user: {profile_response.data}")
        
        # Clean up - delete user
        admin_client.auth.admin.delete_user(user_id)
        print(f"✅ Cleaned up test user")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        raise


def test_fastapi_with_supabase():
    """Test FastAPI endpoints with real Supabase."""
    from fastapi.testclient import TestClient
    from app.main import create_app
    
    app = create_app()
    
    with TestClient(app) as client:
        # Test health endpoint
        response = client.get("/api/v1/health")
        assert response.status_code == 200
        
        data = response.json()
        print(f"✅ Health check: {data}")
        
        # Supabase should be in services
        assert "services" in data
        assert "supabase" in data["services"]
        
        # Should be connected
        assert data["services"]["supabase"] == "connected"


if __name__ == "__main__":
    print("🧪 Running Supabase integration tests...\n")
    
    test_supabase_connection()
    print()
    
    test_supabase_admin_connection()
    print()
    
    test_create_user_and_profile()
    print()
    
    test_fastapi_with_supabase()
    print()
    
    print("✅ All integration tests passed!")
