class CustomController {
  Map<String, Function> controls = Map<String, Function>();

  CustomController() {
    controls = Map<String, Function>();
  }

  add(String key, Function func) {
    controls.putIfAbsent(key, () {
      return func;
    });
  }

  get(key) {
    return controls[key];
  }
}
