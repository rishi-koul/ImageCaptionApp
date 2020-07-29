### Notes

You will find in the code that there was a  `loaded VGG16 restructed model` used. However the model was too large to upload on GitHub.

The restructed model will download if you run the provided google colab notbook or you can simply run the following commands to download it:

`from keras.applications.vgg16 import VGG16

model = VGG16()
# re-structure the model
model.layers.pop()

model = Model(inputs=model.inputs, outputs=model.layers[-1].output)

model.save('any_name.h5')`

Every other model or tokenizer used can be found in this folder.



