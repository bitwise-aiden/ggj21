class_name ExternalInput extends Node

var server := UDPServer.new()
var peers = []


func _ready():
	server.listen(4242)


func _process(delta):
	server.poll()
	if server.is_connection_available():
		var peer : PacketPeerUDP = server.take_connection()
		var pkt = peer.get_packet()

		var result = JSON.parse(pkt.get_string_from_utf8()).result
		if result.error:
			return

		var data = result.result

		if !data is Dictionary || !data.has_all("type", "username"):
			return

			match data["type"]:
				"player_joined":
					Event.emit_signal(
						"player_joined",
						data["username"]
					)
				"player_moved":
					if !data.has("direction"):
						return

					Event.emit_signal(
						"player_moved",
						data["username"],
						data["direction"]
					)
