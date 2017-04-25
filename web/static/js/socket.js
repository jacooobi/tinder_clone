// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"

let privateLobbyUrl = (path) => {
  return path[1] == "private_room";
}

let privateLobbyId = (path) => {
  return path[2];
}

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let currentPathElements = window.location.pathname.split("/");
let chatRoom = "room:lobby";

if (privateLobbyUrl(currentPathElements)) {
  chatRoom = "room:" + privateLobbyId(currentPathElements);
}

// Now that you are connected, you can join channels with a topic:
let channel           = socket.channel(chatRoom, {token: window.userToken})
let chatInput         = document.querySelector("#chat-input")
let messagesContainer = document.querySelector("#messages")

chatInput.addEventListener("keypress", event => {
  if(event.keyCode === 13 && chatInput.value != ""){
    channel.push("new_msg", {body: chatInput.value})
    chatInput.value = ""
  }
})

channel.on("new_msg", payload => {
  let messageItem = document.createElement("li");
  messageItem.innerText = `${payload.user}: ${payload.body}`
  messagesContainer.appendChild(messageItem)
})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
