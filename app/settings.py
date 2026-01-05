import os
from dotenv import load_dotenv
load_dotenv()

GROQ_API_KEY=os.getenv("GROQ_API_KEY")
OPENAI_API_KEY=os.getenv("OPENAI_API_KEY")
TAVILY_API_KEY=os.getenv("TAVILY_API_KEY")
OS_SECURITY_KEY = os.getenv("OS_SECURITY_KEY")