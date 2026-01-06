from agno.agent import Agent
from agno.models.openai import OpenAIChat
from agno.tools.tavily import TavilyTools
from agno.db.sqlite import AsyncSqliteDb
from app.transcription_reader import get_creator_transcriptions, list_available_creators
from app.settings import OPENAI_API_KEY, TAVILY_API_KEY

copywriter = Agent(
    model=OpenAIChat(id="gpt-4.1-mini", api_key=OPENAI_API_KEY),
    name="copywriter",

    num_history_messages=True,
    num_history_runs=30,
    db=AsyncSqliteDb(db_file="my_os.db"),


    tools=[
        TavilyTools(api_key=TAVILY_API_KEY),
        list_available_creators,
        get_creator_transcriptions
    ],
    instructions=open("app/prompts/copywriter.md").read()
)
