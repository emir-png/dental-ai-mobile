"""
Dental AI - YOLOv11 FastAPI Backend
------------------------------------
Başlatmak için:
    cd backend
    uvicorn main:app --host 0.0.0.0 --port 8000 --reload

Model yoksa Google Drive'dan otomatik indirilir.
"""

import io
from pathlib import Path

import gdown
from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from PIL import Image
from ultralytics import YOLO

# ── Model Yolu & Otomatik İndirme ────────────────────────────────────────────
WEIGHTS_DIR = Path(__file__).parent / "weights"
MODEL_PATH = WEIGHTS_DIR / "best.pt"

# Google Drive dosya ID'si
GDRIVE_FILE_ID = "1KY8ELm9xi-OUy9hcA-TQFgDdBxqVGYxt"
GDRIVE_URL = f"https://drive.google.com/uc?id={GDRIVE_FILE_ID}"


def _download_model() -> None:
    """Model dosyası yoksa Google Drive'dan indirir."""
    WEIGHTS_DIR.mkdir(parents=True, exist_ok=True)
    print(f"[Dental AI] Model bulunamadı, indiriliyor: {GDRIVE_URL}")
    gdown.download(GDRIVE_URL, str(MODEL_PATH), quiet=False)
    if not MODEL_PATH.exists():
        raise RuntimeError(
            "Model indirilemedi. Lütfen Google Drive paylaşım iznini kontrol edin "
            "veya best.pt dosyasını backend/weights/ klasörüne manuel kopyalayın."
        )
    print(f"[Dental AI] Model indirildi: {MODEL_PATH}")


if not MODEL_PATH.exists():
    _download_model()

model = YOLO(str(MODEL_PATH))
print(f"[Dental AI] Model yüklendi: {MODEL_PATH}")
print(f"[Dental AI] Sınıflar: {model.names}")

# ── FastAPI ──────────────────────────────────────────────────────────────────
app = FastAPI(title="Dental AI API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
def health():
    return {"status": "ok", "classes": model.names}


@app.post("/predict")
async def predict(
    file: UploadFile = File(...),
    conf: float = 0.25,
):
    """
    Bir görüntü alır, YOLOv11 ile analiz eder ve tespit edilen
    bulguları normalize edilmiş koordinatlarla döndürür.

    Response örneği:
    {
      "predictions": [
        {
          "disease": "Caries",
          "confidence": 0.93,
          "x1": 0.12,
          "y1": 0.34,
          "x2": 0.28,
          "y2": 0.55
        }
      ]
    }
    """
    if not file.content_type.startswith("image/"):
        raise HTTPException(
            status_code=415,
            detail="Yalnızca görüntü dosyaları kabul edilir.",
        )

    contents = await file.read()
    try:
        image = Image.open(io.BytesIO(contents)).convert("RGB")
    except Exception:
        raise HTTPException(status_code=400, detail="Görüntü açılamadı.")

    img_w, img_h = image.size

    results = model.predict(source=image, conf=conf, verbose=False)[0]

    predictions = []
    for box in results.boxes:
        x1, y1, x2, y2 = box.xyxy[0].tolist()
        confidence = float(box.conf[0])
        cls_id = int(box.cls[0])
        disease = model.names[cls_id]

        predictions.append(
            {
                "disease": disease,
                "confidence": round(confidence, 4),
                "x1": round(x1 / img_w, 4),
                "y1": round(y1 / img_h, 4),
                "x2": round(x2 / img_w, 4),
                "y2": round(y2 / img_h, 4),
            }
        )

    predictions.sort(key=lambda p: p["confidence"], reverse=True)

    return {"predictions": predictions}
