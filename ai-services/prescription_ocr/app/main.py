from fastapi import FastAPI

app = FastAPI(title="CareGrid - prescription_ocr")


@app.get("/health")
def health():
    return {"status": "ok", "service": "prescription_ocr"}
