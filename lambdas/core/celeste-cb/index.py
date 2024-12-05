import sys
sys.path.insert(1, './libs')
sys.path.append('./libs')

import nltk, json, random, pickle
from nltk.stem import WordNetLemmatizer
lemmatizer = WordNetLemmatizer()
import pickle
import numpy as np
from keras.api.models import load_model

model = load_model('chatbot_model.h5')
# 
model.compiled_metrics == None
intents = json.loads(open('intents.json').read())
words = pickle.load(open('words.pkl','rb'))
classes = pickle.load(open('classes.pkl','rb'))

# preprocessamento input utente
def clean_up_sentence(sentence):
    sentence_words = nltk.word_tokenize(sentence)
    sentence_words = [lemmatizer.lemmatize(word.lower()) for word in sentence_words]
    return sentence_words

# # Tokenizar la entrada del usuario
def bow(sentence, words, show_details=True):
    sentence_words = clean_up_sentence(sentence)
    bag = [0]*len(words)
    for s in sentence_words:
        for i,w in enumerate(words):
            if w == s:
                bag[i] = 1
                if show_details:
                    print ("found in bag: %s" % w)
    return(np.array(bag))

def response_pred(sentence, model):
    p = bow(sentence, words,show_details=True)
    
    # Predecir el siguiente token en la secuencia
    res = model.predict(np.array([p]))
    ERROR_THRESHOLD = 0.25
    results = [[i,r] for i,r in enumerate(res[0]) if r > ERROR_THRESHOLD]
    # sort by strength of probability
    results.sort(key=lambda x: x[1], reverse=True)
    return_list = []
    for r in results:
        intent = classes[r[0]]
        probability = str(r[1])
        return_list.append({"intent": intent, "probability": probability})
    return return_list

def get_response(ints, intents_json):
    # position first most strong
    tag = ints[0]['intent']
    list_of_intents = intents_json['intents']
    for i in list_of_intents:
        if(i['tag']== tag):
            result = random.choice(i['responses'])
            break
    return result

def input_data(msg):
    ints = response_pred(msg, model)
    return get_response(ints, intents)

#utente = ''
#print('Hola, bienvenido.')

#try:
#    while utente != 'esc':
#        utente = str(input(""))
#        res = input_data(utente)
#        print('AI:' + res)
#except KeyboardInterrupt as e:
#    print(e)

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])
        entry = body['message']
        result = input_data(entry)
        response = { 'message' : result }
        return {
            'statusCode' : 200,
            'body': json.dumps(response)
        }
    except Exception as e:
        return {
            'statusCode' : 500,
            'body': json.dumps({ 'error' : str(e) })
        }