import socketio
from datetime import datetime
from pytz import timezone
from aiohttp import web
import logging

# sio = socketio.AsyncServer(async_mode='asgi', logger=True, engineio_logger=True, cors_allowed_origins='*')
# app = socketio.ASGIApp(sio)
sio = socketio.AsyncServer(logger=True, engineio_logger=True, cors_allowed_origins='*')
app = web.Application()
sio.attach(app)


APP_DEV_PREP = "app_dev"
DEV_APP_PREP = "dev_app"
DEV_APP_NOTIF_PREP = "dev_app_notif"
APP_DEV_NOTIF_PREP = "app_dev_notif"
SERVER_DEV_PREP = "server_dev"
DEV_SERVER_PREP = "dev_server"

app_status_update_request = 'app_status_update_request'
dev_status_update_response = 'dev_status_update_response'

dev_id_ROOM_PREP = '_room'
dev_ROOM_PREP = '_devRoom'
dev_ONLINE_PREP = '_on'
dev_OFFLINE_PREP = '_off'

dev_dev_id_not_valid = 'dev_dev_id_not_valid'
dev_reg_successful = 'dev_reg_successful'
dev_app_dev_online_status = 'dev_app_dev_online_status'
dev_app_response = 'dev_app_response'
dev_response = 'dev_response'

app_dev_id_not_valid = 'app_dev_id_not_valid'
app_reg_successful = 'app_reg_successful'

event_register_dev = 'register_dev'
event_register_app = 'register_app'

unregister_app = 'unregister_app'

dev_reconnect_request = 'dev_reconnect_request'

device_dev_id_sid_routes = {}
online_devices_sid = set()


def get_dev_sid(dev_id):
    try:
        return device_dev_id_sid_routes[dev_id]
    except KeyError:
        return None


def is_valid(dev_id):
    return True


@sio.on(APP_DEV_PREP)
async def app_dev(sid, message):
    dev_id = message['devID']
    app_id = message.get('appID', '')
    msg = message.get('message', '')
    msg_id = message.get('messageID', '')
    widget_id = message.get('widgetID', '')

    dev_sid = get_dev_sid(dev_id)
    if not is_valid(dev_id):
        await sio.emit(dev_dev_id_not_valid, {'devID': dev_id}, room=sid)

    if not online_devices_sid.__contains__(dev_sid) or dev_sid is None:
        if device_dev_id_sid_routes.__contains__(dev_id):
            try:
                del device_dev_id_sid_routes[dev_id]
            except KeyError:
                pass

        await sio.emit(dev_app_dev_online_status, {'devID': dev_id, 'isDevOnline': False}, room=sid)

    await sio.emit(APP_DEV_PREP,
                   {'appID': app_id, 'message': msg, 'msgID': msg_id, 'devID': dev_id, 'widgetID': widget_id},
                   room=dev_sid)


@sio.on(dev_app_response)
async def def_app_response_event(sid, message):
    dev_id = message['devID']
    msg = message.get('message', '')
    msg_id = message.get('messageID', '')
    app_id = message.get('appID', '')

    room = dev_id + dev_id_ROOM_PREP

    await sio.emit(dev_response, {'devID': dev_id, 'message': msg, 'messageID': msg_id, 'appID': app_id}, room=room)


@sio.on(DEV_APP_PREP)
async def dev_app(sid, message):
    dev_id = message['devID']
    msg = message.get('message', '')
    widget_id = message.get('widgetID', '')

    dev_sid = get_dev_sid(dev_id)
    if not is_valid(dev_id) or dev_sid != sid:
        await sio.emit(dev_dev_id_not_valid, sid, room=sid)

    room = dev_id + dev_id_ROOM_PREP
    await sio.emit(DEV_APP_PREP, {'message': msg, 'devID': dev_id, 'widgetID': widget_id}, room=room)


@sio.on(dev_status_update_response)
async def dev_status(sid, message):
    dev_id = message['devID']
    msg = message.get('message', '')

    dev_sid = get_dev_sid(dev_id)
    if not is_valid(dev_id) or dev_sid != sid:
        await sio.emit(dev_dev_id_not_valid, sid, room=sid)

    room = dev_id + dev_id_ROOM_PREP
    await sio.emit(dev_status_update_response, {'message': msg, 'devID': dev_id}, room=room)


@sio.on(app_status_update_request)
async def dev_status_req(sid, message):
    dev_id = message['devID']

    dev_sid = get_dev_sid(dev_id)
    if not is_valid(dev_id):
        await sio.emit(app_dev_id_not_valid, sid, room=sid)

    await sio.emit(app_status_update_request, {}, room=dev_sid)


@sio.on(DEV_SERVER_PREP)
async def dev_server(sid, message):
    return True


@sio.on(event_register_dev)
async def register_dev(sid, message):
    dev_id = message['devID']
    if not is_valid(dev_id):
        await sio.emit(dev_dev_id_not_valid, sid, room=sid)

    device_dev_id_sid_routes[dev_id] = sid
    tz = message.get('tz', '')
    if tz != '':
        now = datetime.now(timezone(tz))
        hour = now.hour
        minute = now.minute
    else:
        hour = 0
        minute = 0

    online_devices_sid.add(sid)
    sio.enter_room(sid, dev_id + dev_ROOM_PREP)
    await sio.emit(dev_reg_successful, {'hour': hour, 'minute': minute}, room=sid)
    await sio.emit(dev_app_dev_online_status, {'devID': dev_id, 'isDevOnline': True}, room=dev_id + dev_id_ROOM_PREP)


@sio.on(event_register_app)
async def register_app(sid, message):
    dev_id = message['devID']

    if isinstance(dev_id, list):
        res = []
        for _dev_id in dev_id:
            valid = False
            if is_valid(_dev_id):
                valid = True
            dev_sid = get_dev_sid(_dev_id)
            is_dev_online = online_devices_sid.__contains__(dev_sid)
            a = {
                'devID': _dev_id,
                'isDevOnline': is_dev_online,
                'validDevID': valid,
            }
            res.append(a)
            if valid:
                sio.enter_room(sid, _dev_id + dev_id_ROOM_PREP)
        await sio.emit(app_reg_successful, res, room=sid)

    else:
        if not is_valid(dev_id):
            await sio.emit(app_dev_id_not_valid, {'devID': dev_id}, room=sid)
            await sio.disconnect(sid)

        sio.enter_room(sid, dev_id + dev_id_ROOM_PREP)
        dev_sid = get_dev_sid(dev_id)
        is_dev_online = online_devices_sid.__contains__(dev_sid)
        await sio.emit(app_reg_successful, {'isDevOnline': is_dev_online, 'devID': dev_id}, room=sid)


@sio.on(dev_reconnect_request)
async def dev_reconnect_request(sid, message):
    dev_id = message['devID']
    straySID = set()
    if not is_valid(dev_id):
        await sio.emit(app_dev_id_not_valid, {'devID': dev_id}, room=sid)

    for _sid, _ in sio.environ.items():
        if len(sio.rooms(_sid)) == 1:
            straySID.add(_sid)

    for _sid in straySID:
        await sio.disconnect(_sid)
        # await sio.emit(dev_reconnect_request, {'devID': dev_id}, room=_sid)


@sio.on('unregister_app')
async def unregister_app(sid, message):
    dev_id = message['devID']
    sio.leave_room(sid, dev_id + dev_id_ROOM_PREP)


@sio.on('connect')
async def connect(sid, environ):
    return True


@sio.on('disconnect')
async def disconnect(sid):
    if sid in online_devices_sid:
        online_devices_sid.remove(sid)

        for dev_id, dev_sid in device_dev_id_sid_routes.items():
            if dev_sid == sid:
                await sio.emit(dev_app_dev_online_status,
                               {'devID': dev_id, 'isDevOnline': False},
                               room=dev_id + dev_id_ROOM_PREP)
                del device_dev_id_sid_routes[dev_id]
                break


if __name__ == '__main__':
    web.run_app(app, host='127.0.0.1', port=1486)
