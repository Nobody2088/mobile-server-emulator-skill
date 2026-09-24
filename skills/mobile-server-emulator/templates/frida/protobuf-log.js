/**
 * Log protobuf parseFrom / toByteArray — adjust class names from jadx output.
 */
function hexPreview(bytes, max) {
  max = max || 64;
  var out = [];
  for (var i = 0; i < Math.min(bytes.length, max); i++) {
    out.push(("0" + (bytes[i] & 0xff).toString(16)).slice(-2));
  }
  return out.join("") + (bytes.length > max ? "..." : "");
}

Java.perform(function () {
  console.log("[protobuf-log] scanning MessageLite implementations…");

  Java.enumerateLoadedClasses({
    onMatch: function (name) {
      if (name.indexOf("google.protobuf") === -1 && name.indexOf("Proto") === -1) return;
      try {
        var Cls = Java.use(name);
        if (Cls.parseFrom) {
          Cls.parseFrom.overload("[B").implementation = function (data) {
            console.log("[parseFrom] " + name + " len=" + data.length + " hex=" + hexPreview(data));
            return this.parseFrom(data);
          };
        }
      } catch (_) {}
    },
    onComplete: function () {
      console.log("[protobuf-log] scan complete");
    },
  });
});
