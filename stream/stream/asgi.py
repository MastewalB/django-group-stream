"""
ASGI config for stream project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/4.1/howto/deployment/asgi/
"""

import os
from channels.auth import AuthMiddlewareStack
from channels.routing import ProtocolTypeRouter, URLRouter
from django.core.asgi import get_asgi_application
import music.routing

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'stream.settings')
# channel_layer = channels.asgi.get_channel_layer()

application = ProtocolTypeRouter({
    'http':get_asgi_application(),
    'websocket':AuthMiddlewareStack(
        URLRouter(
            music.routing.websocket_urlpatterns
        )
    ),
})