FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV PYTHONUNBUFFERED=1
ENV GROQ_API_KEY=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
ENV OPENAI_API_KEY=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                                                                                                                                                                   
ENV TAVILY_API_KEY=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
ENV OS_SECURITY_KEY=OSK_cxmiySWs7aDpOUo211QJ

EXPOSE 8088

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8088"]
