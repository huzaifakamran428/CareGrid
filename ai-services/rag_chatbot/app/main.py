from fastapi import FastAPI

app = FastAPI(title="CareGrid - rag_chatbot")


@app.get("/health")
def health():
    return {"status": "ok", "service": "rag_chatbot"}
