from fastapi import FastAPI

app = FastAPI(title="CareGrid - food_demand")


@app.get("/health")
def health():
    return {"status": "ok", "service": "food_demand"}
