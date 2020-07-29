## Description

* A custom api developed using Python Flask, to generate caption for input images using a pretrained model.
* Google Firestore Storage is used to retrieve the image information that is passed from the frontend

### Notes

* As this is a custom api, it only runs on `localhost` and cannot be used for real mobile devices
* In order to run on real mobile devices please start the localhost and run the following commands on the terminal : 
```
brew cask install ngrok
ngrok http 5000
```
* After this you will receive an url, please replace 

### Important
You will find in the code that there was a  `loaded VGG16 restructed model` used. However the model was too large to upload on GitHub.

The restructed model will download if you run the provided google colab notbook or you can simply run the following commands to download it:

```from keras.applications.vgg16 import VGG16

model = VGG16()
# re-structure the model
model.layers.pop()

model = Model(inputs=model.inputs, outputs=model.layers[-1].output)

model.save('any_name.h5')
```


Every other model or tokenizer used can be found in this folder.



