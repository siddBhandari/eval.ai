MY_ENV_VAR = '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'
import openai
from typing import Union
import base64
from fastapi import FastAPI
from pydantic import BaseModel
import ast  # for converting embeddings saved as strings back to arrays
import pandas as pd  # for storing text and embeddings data
import tiktoken  # for counting tokens
from scipy import spatial  #
openai.api_key = MY_ENV_VAR
import time
import jsonify
import gcloud2
import time

app = FastAPI()
eval_scheme = '''Identification of causes of air pollution (10 marks): Full marks (10): Accurately identifies all major causes of air pollution, including emissions from industries, vehicles, and burning of fossil fuels. Partial marks (5-9): Identifies some causes of air pollution but misses some major causes or provides incomplete information.
No marks (0-4): Does not identify any causes of air pollution or provides incorrect information.
Explanation of effects of air pollution (10 marks):
Full marks (10): Provides a comprehensive and detailed explanation of the effects of air pollution, including serious health problems, harm to the environment, and contribution to climate change.
Partial marks (5-9): Provides some explanation of the effects of air pollution but misses some key points or lacks detail.
No marks (0-4): Does not provide any explanation of the effects of air pollution or provides incorrect information.
Coherence and organization (5 marks):
Full marks (5): The answer is well-organized and easy to follow, with a clear introduction, body, and conclusion. Transitions between ideas are smooth and logical.
Partial marks (3-4): The answer is somewhat organized but lacks clarity in some areas or has some awkward transitions.
No marks (0-2): The answer is poorly organized and difficult to follow.
Grammar and vocabulary (5 marks):
Full marks (5): The answer demonstrates a high level of grammatical accuracy and varied vocabulary appropriate for the topic.
Partial marks (3-4): The answer has some grammatical errors or lacks variety in vocabulary, but overall demonstrates a good command of language.
No marks (0-2): The answer has many grammatical errors or uses inappropriate vocabulary, making it difficult to understand.
'''
question = "Describe the causes and effects of air pollution in 100-150 words."
answer = '''Air pollution is a major problem that affects the environment and human health. There are several causes of air pollution, including emissions from industries, vehicles, and burning of fossil fuels. These activities release harmful chemicals into the air, such as carbon monoxide, sulfur dioxide, and nitrogen oxides.
The effects of air pollution are far-reaching and can lead to serious health problems, such as respiratory diseases, heart problems, and even cancer. In addition, air pollution can harm the environment by causing acid rain, damaging crops, and contributing to climate change.
'''

@app.get("/ocr")
def ocrAPI(img_data : str):
    fileName = "temp"+str(time.time() // 10000000)+".png"
    with open(fileName, "wb") as fh:
        fh.write(base64.decodebytes(img_data))

    return gcloud2.detect_document(fileName)


def hitAPI(eval_scheme, question, answer):
    
    main_prompt = "Question " + question + "Answer by the student " + answer + "Evaluation Scheme for the answer " + eval_scheme + '''give output in the json format based on the evaluation scheme and assess the answer: Assessment Results: {"Marks Obtained": x/y (where x and y are integers and can be same),"Assessment according to the evaluation scheme": Assessment}'''

    messages=[
        {"role": "system", "content": "You are an answer sheet evaluator who evaluates answer sheets according to a marking scheme and explain the wrong or missing part in the answer. You are provided with the question, and answer by the student, a marking scheme for evaluation."},
        {"role": "user", "content": main_prompt},
    ]

    response = openai.ChatCompletion.create(
        model='gpt-3.5-turbo',
        messages=messages,
        temperature=0
    )

    response_message = response["choices"][0]["message"]["content"]

    print(response_message)
    return response_message

@app.get("/")
async def read_item(eval_scheme : str, question : str, answer: str):
    return hitAPI(eval_scheme, question, answer)