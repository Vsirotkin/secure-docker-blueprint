"""
URL configuration for secure-django-backend project.
"""

from django.contrib import admin
from django.urls import path
from django.http import JsonResponse


def health_check(request):
    """Health check endpoint for Docker health checks."""
    return JsonResponse({"status": "healthy"})


def api_root(request):
    """API root endpoint."""
    return JsonResponse(
        {
            "message": "Welcome to Secure Django API",
            "version": "0.1.0",
            "endpoints": {
                "health": "/api/health/",
                "admin": "/admin/",
            },
        }
    )


urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/", api_root, name="api-root"),
    path("api/health/", health_check, name="health-check"),
]
