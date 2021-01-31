import json
import socket
import time

UDP_IP = "127.0.0.1"
UDP_PORT = 4242


def send_packet(data):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP
    sock.sendto(bytes(json.dumps(data), "utf-8"), (UDP_IP, UDP_PORT))


users = ["Cavedens", "b33bytes", "velopman", "incompetent_ian", "wan_hack", "liioni"]

time.sleep(5)

for user in users:
    send_packet({
        "type": "player_joined",
        "username": user,
    })

time.sleep(5)

for i in range(1000):
    send_packet({
        "type": "player_moved",
        "username": users[i%len(users)],
        "direction": i % 4,
    })