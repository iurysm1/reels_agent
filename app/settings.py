import os
from dotenv import load_dotenv
if os.getenv("DEV_MODE"):
    load_dotenv()

GROQ_API_KEY=os.getenv("GROQ_API_KEY")
OPENAI_API_KEY=os.getenv("OPENAI_API_KEY")
TAVILY_API_KEY=os.getenv("TAVILY_API_KEY")
API_KEY = os.getenv("API_KEY")