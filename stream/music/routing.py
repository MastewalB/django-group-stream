from django.urls import re_path
from music.consumers import MusicConsumer

websocket_urlpatterns = [
    re_path(r'ws/stream/', MusicConsumer.as_asgi())
]