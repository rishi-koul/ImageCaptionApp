from flask import Flask, request, jsonify
import pickle
from numpy import argmax
import tensorflow.keras.preprocessing.sequence
import tensorflow.keras.preprocessing.image
import tensorflow.keras.applications.vgg16
import tensorflow.keras.models
from pyrebase import pyrebase

config = {

    "apiKey": "AIzaSyDRTG5YQkCLjWk8Wv9e7YzrWXFxQPL0BZA",
    "authDomain": "fir-practice-a632b.firebaseapp.com",
    "databaseURL": "https://fir-practice-a632b.firebaseio.com",
    "projectId": "fir-practice-a632b",
    "storageBucket": "fir-practice-a632b.appspot.com",
    "messagingSenderId": "556202070812",
    "appId": "1:556202070812:web:71a8428af7890d804aa0d9",
    "measurementId": "G-YLTC014YK2"

}

app = Flask(__name__)

def extract_features(filename):
	model = tensorflow.keras.models.load_model('/Users/rishikoul/PycharmProjects/Vocalize_1.0/model_vgg16_restructured.h5')
	# load the photo
	image = tensorflow.keras.preprocessing.image.load_img(filename, target_size=(224, 224))
	# convert the image pixels to a numpy array
	image = tensorflow.keras.preprocessing.image.img_to_array(image)
	# reshape data for the model
	image = image.reshape((1, image.shape[0], image.shape[1], image.shape[2]))
	# prepare the image for the VGG model
	image = tensorflow.keras.applications.vgg16.preprocess_input(image)
	# get features
	feature = model.predict(image, verbose=0)
	return feature

# map an integer to a word
def word_for_id(integer, tokenizer):
	for word, index in tokenizer.word_index.items():
		if index == integer:
			return word
	return None


# generate a description for an image
def generate_desc(model, tokenizer, photo, max_length):
	# seed the generation process
	in_text = 'startseq'
	# iterate over the whole length of the sequence
	for i in range(max_length):
		# integer encode input sequence
		sequence = tokenizer.texts_to_sequences([in_text])[0]
		# pad input
		sequence = tensorflow.keras.preprocessing.sequence.pad_sequences([sequence], maxlen=max_length)
		# predict next word
		yhat = model.predict([photo,sequence], verbose=0)
		# convert probability to integer
		yhat = argmax(yhat)
		# map integer to word
		word = word_for_id(yhat, tokenizer)
		# stop if we cannot map the word
		if word is None:
			break
		# append as input for generating the next word
		in_text += ' ' + word
		# stop if we predict the end of the sequence
		if word == 'endseq':
			break
	return in_text

# load the tokenizer
tokenizer = pickle.load(open('/Users/rishikoul/PycharmProjects/Vocalize_1.0/tokenizer.pkl', 'rb'))
# # pre-define the max sequence length (from training)
max_length = 34
# load the model
model = tensorflow.keras.models.load_model('/Users/rishikoul/PycharmProjects/Vocalize_1.0/image_captioning_model.h5')


@app.route('/api', methods = ["GET"])
def hello_world():
	d = {}

	# Instance of Google Firebase
	firebase = pyrebase.initialize_app(config)

	# Acess the storage
	storage = firebase.storage()

	path_on_cloud = 'images/main.jpg'
	path_local = 'photo.png'

	# Get the image from path_on_cloud to path_local
	storage.child(path_on_cloud).download(path_local)

	input_word = str(request.args["Query"])
	if input_word == 'start':
		photo = extract_features('photo.png')
		# generate the description for the image
		description = generate_desc(model, tokenizer, photo, max_length)

		# Remove startseq and endseq
		query = description
		stopwords = ['startseq', 'endseq']
		querywords = query.split()

		resultwords = [word for word in querywords if word.lower() not in stopwords]
		result = ' '.join(resultwords)
		d['Query'] = result
		return jsonify(d)
	else:
		return 'Error'

if __name__== '__main__':
	app.run()


