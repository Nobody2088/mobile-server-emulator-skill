/**
 * Redirect TCP connect to localhost — set TARGET_HOST / TARGET_PORT before inject.
 * Example: frida ... -l connect-redirect.js
 *
 * For native connect() hook; adjust for game's actual libc usage.
 */
var TARGET_HOST = "127.0.0.1";
var TARGET_PORT = 8080;

Interceptor.attach(Module.findExportByName("libc.so", "connect"), {
  onEnter: function (args) {
    var sockaddr = args[1];
    var family = Memory.readU16(sockaddr);
    if (family === 2) {
      // AF_INET
      var port = (Memory.readU8(sockaddr.add(2)) << 8) | Memory.readU8(sockaddr.add(3));
      var ip =
        Memory.readU8(sockaddr.add(4)) +
        "." +
        Memory.readU8(sockaddr.add(5)) +
        "." +
        Memory.readU8(sockaddr.add(6)) +
        "." +
        Memory.readU8(sockaddr.add(7));
      console.log("[connect] " + ip + ":" + port + " -> redirect " + TARGET_HOST + ":" + TARGET_PORT);
      Memory.writeU8(sockaddr.add(4), 127);
      Memory.writeU8(sockaddr.add(5), 0);
      Memory.writeU8(sockaddr.add(6), 0);
      Memory.writeU8(sockaddr.add(7), 1);
      Memory.writeU8(sockaddr.add(2), (TARGET_PORT >> 8) & 0xff);
      Memory.writeU8(sockaddr.add(3), TARGET_PORT & 0xff);
    }
  },
});

console.log("[connect-redirect] active -> " + TARGET_HOST + ":" + TARGET_PORT);
