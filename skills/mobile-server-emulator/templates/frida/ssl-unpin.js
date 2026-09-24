/**
 * Generic SSL pinning bypass hints — customize per app.
 */
Java.perform(function () {
  console.log("[ssl-unpin] loaded");

  try {
    var TrustManager = Java.registerClass({
      name: "com.emulator.TrustAllManager",
      implements: [Java.use("javax.net.ssl.X509TrustManager")],
      methods: {
        checkClientTrusted: function () {},
        checkServerTrusted: function () {},
        getAcceptedIssuers: function () {
          return [];
        },
      },
    });

    var SSLContext = Java.use("javax.net.ssl.SSLContext");
    var TrustManagers = Java.array("javax.net.ssl.TrustManager", [
      TrustManager.$new(),
    ]);
    var ctx = SSLContext.getInstance("TLS");
    ctx.init(null, TrustManagers, null);
    console.log("[ssl-unpin] TrustAll manager registered");
  } catch (e) {
    console.log("[ssl-unpin] Java hook failed: " + e);
  }
});
