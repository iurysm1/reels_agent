from fastapi import FastAPI, Header, HTTPException
from starlette.middleware.cors import CORSMiddleware
from agno.playground import Playground

from app.agents import copywriter

from app.settings import API_KEY

playground = Playground(agents=[copywriter])

app = playground.get_app()


def verify_api_key(x_api_key: str = Header(None)):
    if x_api_key != API_KEY:
        raise HTTPException(status_code=401, detail="Unauthorized")


# Protege todos os endpoints /v1
@app.middleware("http")
async def protect_v1(request, call_next):
    print(request.headers)
    # if request.url.path.startswith("/v1"):
    #     await verify_api_key(request.headers.get("x-api-key"))
    return await call_next(request)
