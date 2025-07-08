#!/usr/bin/env python3
import sys
import os
from openai import OpenAI
client = OpenAI()
SYSTEM_PROMPT = open("PROMPT.md").read()
def main():
    user_input = sys.argv[1]
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": user_input}
        ]
    )
    print(response.choices[0].message.content)
if __name__ == "__main__":
    main()
