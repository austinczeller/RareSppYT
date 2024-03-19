#Predict using OpenSoundscape Model
from opensoundscape.ml.cnn import load_model
from opensoundscape import Audio
import opensoundscape
# Other utilities and packages
import torch
from pathlib import Path
import numpy as np
import pandas as pd
from glob import glob
import subprocess
#set up plotting
from matplotlib import pyplot as plt
plt.rcParams['figure.figsize']=[15,5] #for large visuals
%config InlineBackend.figure_format = 'retina'


model = load_model('model_training_checkpoints/best.model')

from glob import glob 
audio_files = glob('D:/**/*.wav',recursive=True) #match all .wav files in the current directory
print(audio_files )

scores = model.predict(audio_files)
import pandas as pd
scores.to_csv("C:/Users/austi/Documents/COPI_HDD.csv")#Change the name to unique csv name as to not overwrite previous predictions