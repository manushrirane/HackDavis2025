import json
from typing import Dict
from typing_extensions import TypedDict
from pydantic.v1 import BaseModel
from dotenv import load_dotenv
import os

from langchain_community.tools.tavily_search import TavilySearchResults
from langchain_core.messages import BaseMessage, HumanMessage, SystemMessage, AIMessage
from langchain_openai import ChatOpenAI

from langgraph.graph import StateGraph, START, END

# Load environment variables
load_dotenv()
# Define the state schema - keeps track of the conversation history
class AppState(TypedDict):
    messages: list[BaseMessage]

# Initialize LLMs
visa_llm = ChatOpenAI(model_name="gpt-3.5-turbo", temperature=0.7)
checklist_llm = ChatOpenAI(model_name="gpt-3.5-turbo", temperature=0.7)
search_query_llm = ChatOpenAI(model_name="gpt-3.5-turbo", temperature=0.2)  # Optional

# Tavily Search Tool
search = TavilySearchResults(max_results=7, search_depth="basic")

# Search Tool Node (optional)
def search_tool(state: Dict) -> Dict:
    messages = state["messages"]
    
    refine_messages = [
        SystemMessage(content="You are a search query specialist. Reformulate the user input into a highly specific internet search query. Return only the query."),
        HumanMessage(content=f"Convert this request into a specific internet search query: {messages[-1].content}")
    ]

    refined_query = search_query_llm.invoke(refine_messages).content.strip().replace('"', '')
    print(f"\n==== REFINED QUERY ====\n{refined_query}")

    search_results = search.invoke({"query": refined_query})
    formatted_results = json.dumps(search_results, indent=2)

    messages.append(AIMessage(content=formatted_results))
    return {"messages": messages}

# Visa Agent Node
def visa_agent(state: Dict) -> Dict:
    messages = state["messages"]

    system_prompt = SystemMessage(content="""
        You are a visa recommendation expert. Based on a user's background, purpose of visit, nationality, and other preferences,
        suggest the most suitable type of U.S. visa or immigration path. Be specific and include relevant details like visa name, category, and general purpose.
    """)
    
    response = visa_llm.invoke([system_prompt, messages[-1]])
    messages.append(response)
    return {"messages": messages}

# Checklist Agent Node
def checklist_agent(state: Dict) -> Dict:
    messages = state["messages"]

    system_prompt = SystemMessage(content="""
        You are a documentation checklist assistant. Based on a user's visa type and situation, generate a clear, step-by-step checklist 
        for what they need to do to successfully apply for the visa or documentation. Include forms, fees, interviews, and timelines if possible.
    """)
    
    response = checklist_llm.invoke([system_prompt, messages[-1]])
    messages.append(response)
    return {"messages": messages}

# Create the graph
# Build the graph
builder = StateGraph(AppState)
builder.add_node("search", search_tool)
builder.add_node("visa_agent", visa_agent)
builder.add_node("checklist_agent", checklist_agent)

# Define the edges
builder.set_entry_point("search")
builder.add_edge("search", "visa_agent")
builder.add_edge("visa_agent", "checklist_agent")
builder.add_edge("checklist_agent", END)

# Compile graph
graph = builder.compile()

# Example run
if __name__ == "__main__":
    user_input = "I'm a software engineer from India looking to move to the US for work. What visa should I apply for?"

    # Start state with user message
    initial_state = {
        "messages": [HumanMessage(content=user_input)]
    }

    # Run the graph
    final_state = graph.invoke(initial_state)

    # Print final output
    print("\n==== FINAL OUTPUT ====")
    for msg in final_state["messages"]:
        print(f"\n[{msg.__class__.__name__}]\n{msg.content}")
