# 📱 VoiceDrive

**VoiceDrive** is a Flutter prototype app designed to let drivers quickly record voice notes while staying focused on the road.  
The app records audio, converts speech to text, and stores notes locally with an adaptive UI for both mobile phones and in‑car smart screens.

---

## 🚀 Features

- 🎙️ **Audio recording** (start/stop)  
- 🧠 **Speech‑to‑text**  
- 📝 **Create, view and delete notes**  
- 🧮 **Adaptive UI** for phone and car display  
- 💾 **Local storage (Hive)**  

---

## 🛠️ Tech Stack

- **Flutter**  
- **record** – audio recording  
- **speech_to_text** – speech recognition  
- **path_provider** – file system access  
- **hive** – local database  

---

## 🧪 Test Summary

All core features tested and passing:

- Recording  
- Stopping & saving audio  
- Speech‑to‑text  
- Saving notes  
- Deleting notes  
- Adaptive layout  

---

## ▶️ Run the App

```bash
flutter pub get
flutter run
```
### If platform folders are missing:
```bash
flutter create .

