class NSNotificationCenter {
  static Map<String,
          Map<dynamic, Function(String key, dynamic packet, dynamic sender)>>
      listeners = {};

  static void register(dynamic self, String key,
      Function(String key, dynamic packet, dynamic sender) callback) {
    NSNotificationCenter.listeners.putIfAbsent(key, () => {});
    NSNotificationCenter.listeners[key].putIfAbsent(self, () => callback);
  }

  static void remove(dynamic self, String key) {
    if (NSNotificationCenter.listeners.containsKey(key))
      NSNotificationCenter.listeners[key].remove(self);
  }

  static void notify(String key, dynamic self, dynamic packet) {
    final Map<dynamic, Function(String key, dynamic packet, dynamic sender)>
        listeners = NSNotificationCenter.listeners[key];
    if (listeners == null) return;
    listeners.forEach((_, handler) {
      try {
        handler(key, packet, self);
      } catch (_) {}
    });
  }

  static void removeAll(dynamic self) {
    NSNotificationCenter.listeners.forEach((key, value) {
      NSNotificationCenter.listeners[key].removeWhere((key, _) => key == self);
    });
  }
}
