import os
import uvicorn
def main():
    host = os.getenv("HOST", "0.0.0.0")
    port = int(os.getenv("PORT", "8088"))

    # Melhor para empacotar: usar "import string"
    # (evita alguns problemas de multiprocess/reload e empacotamento)
    uvicorn.run("app.main:app", host=host, port=port, log_level="info")

if __name__ == "__main__":
    main()
