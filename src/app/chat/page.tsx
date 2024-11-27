"use client";

import { useEffect, useState } from "react";
import { io, type Socket } from "socket.io-client";

let socket: Socket | null = null;

export default function SocketPage() {
  const [message, setMessage] = useState<string>("");
  const [receivedMessages, setReceivedMessages] = useState<string[]>([]);

  useEffect(() => {
    socket = io({
      path: "/api/socket",
    });

    socket.on("connect", () => {
      console.log("Connected to socket server");
    });

    socket.on("message", (msg: string) => {
      setReceivedMessages((prevMessages) => [...prevMessages, msg]);
    });

    return () => {
      socket?.disconnect();
    };
  }, []);

  const sendMessage = () => {
    if (socket) {
      socket.emit("message", message);
      setMessage("");
    }
  };

  return (
    <div>
      <h1>Socket.IO Chat</h1>
      <ul>
        {receivedMessages.map((msg, index) => (
          <li key={index}>{msg}</li>
        ))}
      </ul>
      <input
        type="text"
        value={message}
        onChange={(e) => setMessage(e.target.value)}
        placeholder="Type a message"
      />
      <button onClick={sendMessage}>Send</button>
    </div>
  );
}
