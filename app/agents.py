from agno.agent import Agent
from agno.models.openai import OpenAIChat
from agno.tools.tavily import TavilyTools
from agno.storage.sqlite import SqliteStorage
from app.transcription_reader import get_creator_transcriptions, list_available_creators
from app.settings import OPENAI_API_KEY, TAVILY_API_KEY

copywriter = Agent(
    model=OpenAIChat(id="gpt-4.1-mini", api_key=OPENAI_API_KEY),
    name="copywriter",

    add_history_to_messages=True,
    num_history_runs=10,
    storage=SqliteStorage(table_name="agent_sessions", db_file="tmp/storage.db"),

    tools=[
        TavilyTools(api_key=TAVILY_API_KEY),
        list_available_creators,
        get_creator_transcriptions
    ],

    show_tool_calls=True,
    instructions=open("app/prompts/copywriter.md").read()
)
