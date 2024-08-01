const http = require('http');
const socketIo = require('socket.io');
const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());

const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
});

const clients = new Map();

io.on('connection', (socket) => {
  const userId = socket.handshake.query.userId.toString(); // Ensure userId is a string
  console.log(`New client connected with user ID: ${userId}`);
  clients.set(userId, socket);

  // Log all connected clients
  console.log('All connected clients:', Array.from(clients.keys()));

  socket.on('disconnect', (reason) => {
    console.log(`Client disconnected with user ID: ${userId}, Reason: ${reason}`);
    clients.delete(userId);
    console.log('All connected clients:', Array.from(clients.keys()));
  });

  socket.on('call-user', (data) => {
    console.log('call-user event received:', data); // Log the received data
    const { to, from, signal, display_name } = data;
    console.log(`Call request from ${from} to ${to}`);
    if (!to) {
      console.error('Missing "to" parameter in call-user event');
      return;
    }
    const callee = clients.get(to.toString()); // Ensure to is a string
    if (callee) {
      console.log(`Sending call request from ${from} to ${to}`);
      callee.emit('call-user', { from, signal, display_name });
    } else {
      console.log(`Callee with ID ${to} not found`);
      console.log('Current clients:', Array.from(clients.keys()));
      console.log(`clients.get(${to}):`, clients.get(to.toString())); // Ensure to is a string
    }
  });

  socket.on('accept-call', (data) => {
    const { to, from, signal } = data;
    console.log(`Call accepted by ${from}`);
    if (!to) {
      console.error('Missing "to" parameter in accept-call event');
      return;
    }
    const caller = clients.get(to.toString()); // Ensure to is a string
    if (caller) {
      console.log(`Sending call accepted signal to ${to}`);
      caller.emit('call-accepted', { signal, from }); // Include the 'from' property
    } else {
      console.log(`Caller with ID ${to} not found`);
    }
  });

  socket.on('ice-candidate', (data) => {
    const { to, candidate } = data;
    console.log(`ICE candidate from ${data.from} to ${to}`);
    if (!to) {
      console.error('Missing "to" parameter in ice-candidate event');
      return;
    }
    const peer = clients.get(to.toString()); // Ensure to is a string
    if (peer) {
      peer.emit('ice-candidate', { candidate });
    } else {
      console.log(`Peer with ID ${to} not found`);
    }
  });
  
  socket.on('send-message', (data) => {
    const { to, from, text, name } = data; // Include the 'name' property
    console.log(`Message from ${from} to ${to}: ${text}`);
    const recipientSocket = clients.get(to.toString());
    if (recipientSocket) {
      recipientSocket.emit('receive-message', { from, text, name }); // Include 'name' in the emitted data
    } else {
      console.log(`Recipient with ID ${to} not found`);
    }
  });

  socket.on('end-call', (data) => {
    const { to } = data;
    console.log(`End call request from ${userId} to ${to}`);
    const peer = clients.get(to.toString()); // Ensure to is a string
    if (peer) {
      peer.emit('end-call');
    }
  });
});

server.listen(8080, () => {
  console.log('Socket.IO signaling server running on http://localhost:8080');
});
