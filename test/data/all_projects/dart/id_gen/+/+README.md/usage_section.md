## 🚀Usage

### Generate 4 UUIDs

About UUID and online generator: <https://uuidgenerator.net>

```dart
print([for (var i = 0; i < 4; ++i) genUuid]);
```

```text
[4c48329b-2c1b-4534-b649-1a462626bcd4, a1afafe2-d57a-46ae-9f27-7e42dc936475,
283ae055-cf4e-4d6d-b505-e2a7d60806d2, 843832d1-d0f0-48e7-8a61-3aa151c2103b]
```

### Generate HumanID from Language

Supported languages:

- Belarusian
- English
- Ukrainian

```dart
const gen = HumanIdGen(options: HumanIdGenOptions(lowerCase: true));
final hid = gen.get('Тема статті чи назва курсу');
print(hid);
```

```text
tema-stati-chy-nazva-kursu
```

### Generate Transit Integer ID

```dart
print([for (var i = 0; i < 4; ++i) genTransitId]);
```

```text
[1, 2, 3, 4]
```

### Generate Time Integer ID

```dart
// milliseconds
print(genTimeId);
// microseconds
print(genTimeIdMicro);
```

```text
1705954581187
1705954581188687
```

Note that second ID does not fit into 53 bits (the size of a IEEE double). A JavaScript number is not able to hold this value.

### Add HID and UID to Any Class

```dart
class Quant with HasStringIdMix {
  Quant({String? hid, String? uid}) {
    this.hid = hid;
    this.uid = uid;
  }
}

print(Quant().id);
print(Quant(hid: 'aerwyna').id);
```

```text
92e6ee3e-537a-4dd3-b4e9-06b8fd366469
aerwyna
```
