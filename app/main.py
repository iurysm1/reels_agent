from agno.os import AgentOS
from app.agents import copywriter

agent_os = AgentOS(
    id="my-first-os",
    description="My first AgentOS",
    agents=[copywriter],
)

app = agent_os.get_app()