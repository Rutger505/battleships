import { Server } from "socket.io";
import { createServer } from "http";
import { env } from "@/env";

const httpServer = createServer();

const io = new Server(httpServer, {
  cors: {
    origin: env.BASE_URL,
    methods: ["GET", "POST"],
  },
  path: "/api/socket",
});

io.on("connection", (socket) => {
  console.log("Client connected:", socket.id);

  socket.on("message", (msg) => {
    console.log("Message:", msg);
    io.emit("message", msg);
  });
});

httpServer.listen(3000, () => {
  console.log("Server running on port 3000");
});
