## 🚀Usage

### With Text (String)

```dart
final background = Image.asset('image.webp');
const title = RectGlassTitle(text: 'Forgotten Dreams');

return Stack(children: [background, title]);
```

### With Widget (Icon)

```dart
const icon = Icon(Icons.hiking, color: Colors.white);
final title = RectGlassTitle(widget: icon);

return Stack(children: [background, title]);
```

[<img src="https://raw.githubusercontent.com/{{owner_id}}/{{project_id}}/master/images/screenshots/1.gif" width="600"/>](https://raw.githubusercontent.com/{{owner_id}}/{{project_id}}/master/images/screenshots/1.gif)
