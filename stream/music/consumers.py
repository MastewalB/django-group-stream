from channels.generic.websocket import AsyncWebsocketConsumer
import json

class MusicConsumer(AsyncWebsocketConsumer):
    async def connect(self):

        await self.channel_layer.group_add(
            "stream",
            self.channel_name			

        )
        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(
            "stream",
            self.channel_name
        )

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        operation = text_data_json['operation']
        url = text_data_json['url']
        seek = text_data_json['seek']
        await self.channel_layer.group_send(
            "stream",
            {
                'type': 'music_stream',
                'operation':operation,
                'url': url,
                'seek': seek,
            }
        )

    async def music_stream(self, event):
        operation = event['operation']
        url = event['url']
        seek = event['seek']

        await self.send(text_data=json.dumps({
                'operation':operation,
                'url': url,
                'seek': seek,
        }))